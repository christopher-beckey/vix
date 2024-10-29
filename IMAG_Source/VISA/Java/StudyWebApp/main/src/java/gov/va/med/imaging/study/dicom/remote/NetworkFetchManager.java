/**
 *
 Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 Date Created: Mar 25, 2021
 Site Name:  Washington OI Field Office, Silver Spring, MD
 Developer:  OITAACDiehlS
 Description:

 ;; +--------------------------------------------------------------------+
 ;; Property of the US Government.
 ;; No permission to copy or redistribute this software is given.
 ;; Use of unreleased versions of this software requires the user
 ;;  to execute a written test agreement with the VistA Imaging
 ;;  Development Office of the Department of Veterans Affairs,
 ;;  telephone (301) 734-0100.
 ;;
 ;; The Food and Drug Administration classifies this software as
 ;; a Class II medical device.  As such, it may not be changed
 ;; in any way.  Modifications to this software may result in an
 ;; adulterated medical device under 21CFR820, the use of which
 ;; is considered to be a violation of US Federal Statutes.
 ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.study.dicom.remote;

import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.PatVistaInfo;
import gov.va.med.imaging.study.dicom.query.PatientCFind;
import gov.va.med.imaging.study.dicom.query.StudyQuery;
import gov.va.med.imaging.study.dicom.remote.image.DirectImageFetchTask;
import gov.va.med.imaging.study.dicom.remote.image.ImageFetchDto;
import gov.va.med.imaging.study.dicom.remote.image.LocalImage;
import gov.va.med.imaging.study.dicom.remote.report.ReportFetchDto;
import gov.va.med.imaging.study.dicom.remote.report.ReportFetchTask;
import gov.va.med.imaging.study.dicom.remote.study.HttpsStudyFetchTask;
import gov.va.med.imaging.study.dicom.remote.study.SeriesFetchTask;
import gov.va.med.imaging.study.dicom.remote.study.StudyFetchTask;
import gov.va.med.imaging.study.rest.types.StudiesResultType;
import gov.va.med.imaging.study.rest.types.StudySeriesesType;
import gov.va.med.imaging.study.rest.types.StudyType;
import gov.va.med.logging.Logger;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicLong;

public class NetworkFetchManager {

    private static NetworkFetchManager instance;
    private static ThreadPoolExecutor metaDataFetchService; //cfind, cmove
    private static ThreadPoolExecutor imageFetchService; //cstore
    private static ThreadPoolExecutor longRunningImageFetchService; //cstore with more than 100? images
    private static ThreadPoolExecutor localImageService;
    private static final AtomicLong remoteFetchesPerformed = new AtomicLong(0);
    private final static Logger LOGGER = Logger.getLogger(NetworkFetchManager.class);
    private static final Map<StudyFetchTask, Future<StudiesResultType>> remoteFetchStudyFutures = new ConcurrentHashMap<>(); //patient futures by site code
    private static final Map<String, Future<StudySeriesesType>> remoteFetchSeriesFutures = new ConcurrentHashMap<>();
    private static final Map<String, Future<String>> remoteFetchImageFuturesByUrn = new ConcurrentHashMap<>();
    private static final Map<String, Future<String>> remoteFetchReportFuturesByUrn = new ConcurrentHashMap<>();
    private static final Map<String, Future<String>> localImageFuturesByUrn = new ConcurrentHashMap<>();
    private static Instant lastCleanup = Instant.now();

    public static void shutdownServices(){
        if(longRunningImageFetchService != null) {
            longRunningImageFetchService.shutdownNow();
        }
        if(imageFetchService != null) {
            imageFetchService.shutdownNow();
        }
        if(metaDataFetchService != null){
            metaDataFetchService.shutdownNow();
        }
        if(localImageService != null){
            localImageService.shutdownNow();
        }
    }

    private NetworkFetchManager(int metaFetchPoolMax, int imageFetchPoolMax, int imageQueueSize){
        if(metaDataFetchService == null){
            metaDataFetchService = (ThreadPoolExecutor) Executors.newFixedThreadPool(metaFetchPoolMax);
        }
        if(imageFetchService == null){
            imageFetchService = (ThreadPoolExecutor) getBoundedExecutorService(imageFetchPoolMax,imageQueueSize);
        }
        if(longRunningImageFetchService == null){
            longRunningImageFetchService = (ThreadPoolExecutor) getBoundedExecutorService(imageFetchPoolMax,imageQueueSize);
        }
        if(localImageService == null){
            localImageService = (ThreadPoolExecutor) getBoundedExecutorService(imageFetchPoolMax,imageQueueSize);
        }
    }

    private ExecutorService getBoundedExecutorService(int poolSize, int queueSize){
        BlockingQueue<Runnable> workQueue = new LinkedBlockingDeque<Runnable>(
                queueSize);
        return new ThreadPoolExecutor(poolSize, poolSize, 30, TimeUnit.SECONDS, workQueue);
    }

    private static synchronized NetworkFetchManager getInstance(){
        int metaFetchPoolMax = Integer.parseInt(DicomService.getScpConfig().getSiteFetchTPoolMax());
        int imageFetchPoolMax = Integer.parseInt(DicomService.getScpConfig().getImageFetchTPoolMax());
        int imageQueueSize = DicomService.getScpConfig().getImageQueueSize();
        if(instance == null){
            instance = new NetworkFetchManager(metaFetchPoolMax, imageFetchPoolMax, imageQueueSize);
        }
        return instance;
    }

    //This will always be the first type of request this class receives as we must collect and map studyUrns to handle studyUids
    public static Future<StudiesResultType> requestStudiesFromSite(String siteId, PatientCFind query){
        StudyFetchTask aSiteStudies = new HttpsStudyFetchTask(siteId, query, query.getStudyFilterTerm());
        cleanUpCache();
        return getInstance().submitStudyTask(aSiteStudies);
    }

    public static PatVistaInfo getInfoForUnkPatId(String queriedPatientId, String transId){
        return HttpsUtil.getPatInfoFromCvix(queriedPatientId, transId);
    }

    public static Future<String> requestLocalImage(LocalImage toFetch){
        String imageKey = DicomService.getImageKey(toFetch.getImageURN());
        if(remoteFetchImageFuturesByUrn.containsKey(imageKey) &&
                remoteFetchImageFuturesByUrn.get(imageKey) != null){
            if(!remoteFetchImageFuturesByUrn.get(imageKey).isDone()) return remoteFetchImageFuturesByUrn.get(imageKey); //being worked
            else remoteFetchImageFuturesByUrn.remove(imageKey);//fetch it again, shouldn't be asking for it here if it's already in file system
        }
        return getInstance().submitLocalImageTask(toFetch, imageKey);
    }

    public static StudySeriesesType getStudySeriesBlocking(StudyQuery studyQuery)
            throws ExecutionException, InterruptedException, TimeoutException
    {
        if(remoteFetchSeriesFutures.containsKey(studyQuery.getStudyUrn())){
            StudySeriesesType seriesMeta = remoteFetchSeriesFutures.get(studyQuery.getStudyUrn()).get(Integer.parseInt(DicomService.getScpConfig().getSiteFetchTimeLimit()),TimeUnit.SECONDS);
            remoteFetchSeriesFutures.remove(studyQuery.getStudyUrn());
            return seriesMeta;
        }
        Future<StudySeriesesType> future = instance.submitSeriesTask(studyQuery);
        StudySeriesesType series = future.get(Integer.parseInt(DicomService.getScpConfig().getSiteFetchTimeLimit()),TimeUnit.SECONDS);
        remoteFetchSeriesFutures.remove(studyQuery.getStudyUrn());
        return series;
    }

    public static String getReportBlocking(ReportFetchDto reportFetchDto)
            throws ExecutionException, InterruptedException, TimeoutException {
        if(remoteFetchReportFuturesByUrn.containsKey(reportFetchDto.getStudyUrn())){
            return remoteFetchReportFuturesByUrn.get(reportFetchDto.getStudyUrn())
                    .get(Integer.parseInt(DicomService.getScpConfig().getImageFetchTimeLimit()), TimeUnit.SECONDS);
        }
        Future<String> reportFuture = instance.submitReportTask(reportFetchDto);
        return reportFuture.get(Integer.parseInt(DicomService.getScpConfig().getImageFetchTimeLimit()), TimeUnit.SECONDS);
    }

    public static void requestRemoteReport(ReportFetchDto toFetch)
    {//non blocking, these results go to the filesystem
        instance.submitReportTask(toFetch);
    }

    public static void requestRemoteImage(ImageFetchDto toFetch, int totalInstances)
    {//non blocking, these results go to the filesystem
        String imageKey = DicomService.getImageKey(toFetch.getImageURN());
        if(remoteFetchImageFuturesByUrn.containsKey(imageKey) &&
                remoteFetchImageFuturesByUrn.get(imageKey) != null){
            if(!remoteFetchImageFuturesByUrn.get(imageKey).isDone()) return; //being worked
            else remoteFetchImageFuturesByUrn.remove(imageKey);//fetch it again, shouldn't be asking for it here if it's already in file system
        }
        instance.submitImageTask(toFetch, totalInstances);
    }

    public static String getImageResultsBlocking(ImageFetchDto toFetch, long millisToWait)
            throws InterruptedException, ExecutionException, TimeoutException {
        String imageKey = DicomService.getImageKey(toFetch.getImageURN());
        if(!remoteFetchImageFuturesByUrn.containsKey(imageKey)){
            LOGGER.warn("Did not pre-load image fetch request, blocking for full load time {} valid keys are {}", imageKey, remoteFetchImageFuturesByUrn.keySet());
            instance.submitImageTask(toFetch, 101);
        }
        return remoteFetchImageFuturesByUrn.get(imageKey).get(millisToWait, TimeUnit.MILLISECONDS);
    }

    private Future<String> submitReportTask(ReportFetchDto reportFetchDto){
        if(remoteFetchReportFuturesByUrn.containsKey(reportFetchDto.getStudyUrn())
                && remoteFetchReportFuturesByUrn.get(reportFetchDto.getStudyUrn()).isDone()){
            remoteFetchReportFuturesByUrn.remove(reportFetchDto.getStudyUrn());//should be in the file system, remove
        }
        remoteFetchReportFuturesByUrn.compute(reportFetchDto.getStudyUrn(), (k, v)->{
            if(v != null && !v.isDone()) return v;
            ReportFetchTask reportFetchTask = new ReportFetchTask(reportFetchDto);
            return metaDataFetchService.submit(reportFetchTask);
        });
        return remoteFetchReportFuturesByUrn.get(reportFetchDto.getStudyUrn());
    }

    private Future<String> submitLocalImageTask(LocalImage image, String imageKey){
        ThreadPoolExecutor executor = localImageService;
        remoteFetchImageFuturesByUrn.compute(imageKey, (k, v) ->{
            if(v != null && !v.isDone()){
                return v;
            }

            DirectImageFetchTask imageFetchTask = new DirectImageFetchTask(image);
            return executor.submit(imageFetchTask);
        });

        return remoteFetchImageFuturesByUrn.get(imageKey);
    }

    //Returns a future that will contain the file name for the image, indicating it has been cached
    private Future<String> submitImageTask(ImageFetchDto toFetch, int totalInstances) {
        String imageKey = DicomService.getImageKey(toFetch.getImageURN());
        ThreadPoolExecutor executor = totalInstances > 100 ? longRunningImageFetchService : imageFetchService;
        remoteFetchImageFuturesByUrn.compute(imageKey, (k, v) ->{
           if(v != null && !v.isDone()){
               return v;
           }

           DirectImageFetchTask imageFetchTask = new DirectImageFetchTask(toFetch);
           return executor.submit(imageFetchTask);
        });

        return remoteFetchImageFuturesByUrn.get(imageKey);
    }

    private Future<StudySeriesesType> submitSeriesTask(StudyQuery query)
    {
        return remoteFetchSeriesFutures.compute(query.getStudyUrn(), (k,v) ->{
            if(v!= null && !v.isDone()) return v;//already being worked
            SeriesFetchTask series = new SeriesFetchTask(query.getStudyUrn(), query.getTransactionGuid(),
                    query.getSiteCode(), query.getPatientInfo().getIcn());
            return metaDataFetchService.submit(series);
        });
    }

    private Future<StudiesResultType> submitStudyTask(StudyFetchTask toRun)
    {
        remoteFetchStudyFutures.compute(toRun, (k, v) -> {
            if (v == null){
                v = metaDataFetchService.submit(toRun);
            }
            else k.updateAccessTime();//modifying underlying map...bad?
            return v;
        });
        remoteFetchesPerformed.getAndIncrement();
        return remoteFetchStudyFutures.get(toRun);
    }

    public static void clearCache(){
        remoteFetchStudyFutures.clear();
        remoteFetchSeriesFutures.clear();
        remoteFetchReportFuturesByUrn.clear();
        remoteFetchImageFuturesByUrn.clear();
    }

    private static void cleanUpCache() {
        if (lastCleanup.isBefore(Instant.now().minus(60, ChronoUnit.MINUTES))) {
            Iterator<Map.Entry<StudyFetchTask, Future<StudiesResultType>>> iterator = remoteFetchStudyFutures.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<StudyFetchTask, Future<StudiesResultType>> nextEntry = iterator.next();
                StudyFetchTask siteStudiesTask = nextEntry.getKey();
                Future<StudiesResultType> studiesResultTypeFuture = nextEntry.getValue();
                if (siteStudiesTask.getLastAccessed().isBefore(Instant.now().minus(30, ChronoUnit.MINUTES))) {
                    if (!studiesResultTypeFuture.isDone()) studiesResultTypeFuture.cancel(true);
                    try {
                        for (StudyType studyType : studiesResultTypeFuture.get().getStudies().getStudies()) {
                            remoteFetchSeriesFutures.remove(studyType.getStudyId());
                        }
                    } catch (Exception e) {
                        LOGGER.error("Hope that didn't orphan anything in the cache. msg {}", e.getMessage());
                    }
                    iterator.remove();
                }
            }
            lastCleanup = Instant.now();
        }
    }
}
