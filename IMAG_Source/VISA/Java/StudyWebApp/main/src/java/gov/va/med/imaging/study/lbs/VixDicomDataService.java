// Copyright Laurel Bridge Software, Inc.  All rights reserved.  See distributed license file.

package gov.va.med.imaging.study.lbs;

import com.lbs.CDS.CFGGroup;
import com.lbs.DCF.DCFException;
import com.lbs.DCS.*;
import com.lbs.DDS.DDSException;
import com.lbs.DDS.DicomDataService;
import com.lbs.DDS.DicomDataServiceListener;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.query.PatientCFind;
import gov.va.med.imaging.study.dicom.query.QueryFactory;
import gov.va.med.imaging.study.dicom.query.StudyQuery;
import gov.va.med.imaging.study.dicom.query.VixDicomQuery;
import gov.va.med.imaging.study.dicom.remote.NetworkFetchManager;
import gov.va.med.imaging.study.dicom.remote.image.ImageFetchDto;
import gov.va.med.imaging.study.dicom.remote.report.ReportFetchDto;
import gov.va.med.imaging.study.lbs.vix.dpod.ImageDpod;
import gov.va.med.imaging.study.lbs.vix.dpod.ReportDpod;
import gov.va.med.imaging.study.lbs.vix.dpod.VixDpod;
import gov.va.med.imaging.study.rest.types.StudyType;
import gov.va.med.logging.Logger;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Map;
import java.util.Set;
import java.util.Vector;
import java.util.concurrent.*;

/**
 * Reference implementation of the DicomDataService interface. Images and other
 * DICOM objects are stored as DICOM format files in a directory specified in
 * the configuration for this component.
 *
 * This implementation of DicomDataService interprets
 * DicomPersistentObjectDescriptor as follows: persistent_id is the filename,
 * and persistent_info is the transfer syntax uid for the file. If
 * persistent_info is an empty string, on input, auto-detect will be used to
 * determine the encoding of the file (part-10 or not, and transfer syntax).
 *
 * The CDS CFGDB is used as a lightweight database service by this class.
 * Patient, Study, Series, SOP-Instance, Modality Worklist Item, and Performed
 * Procedure Step objects are stored as CFGGroup objects. SOP-Instance objects
 * are primarily references to files which contain the bulk of the image or
 * other object's data.
 */

public class VixDicomDataService extends DicomDataService {
	private final static Logger logger = Logger.getLogger(VixDicomDataService.class);
	/**
	 * The singleton instance.
	 */
	private static VixDicomDataService instance_;
	private final static Map<String, Instant> destinationUidLocks = new ConcurrentHashMap<>(); //prevents accidental repeat requests from being processed and tying up resources concurrently
	private final static ScheduledExecutorService lockCleanupService = new ScheduledThreadPoolExecutor(1);
	private final static Map<String, AssociationAcceptor> cmoveAssociations = new ConcurrentHashMap<>();//TODO: consolidate with locks

	private static String newline_ = null;

	public static VixDicomDataService getInstance() {
		return instance_;
	}

	public static void shutdownServices(){
		if(lockCleanupService != null){
			lockCleanupService.shutdownNow();
		}
	}

	static {
		Runnable lockCleanupTask = () -> destinationUidLocks.entrySet()
				.removeIf(entry -> entry.getValue().isBefore(Instant.now().minus(60, ChronoUnit.SECONDS)));
		lockCleanupService.scheduleAtFixedRate(lockCleanupTask,60,60, TimeUnit.SECONDS);
	}

	/**
	 * Default constructor
	 */
	protected VixDicomDataService() throws DDSException {
		newline_ = System.getProperty("line.separator");
		try {
			CFGGroup cfg = CINFO.getConfig();
		} catch (DCFException e) {
			LOG.error(-1, e.toString());
            logger.error("DICOM SCP data service failed initialization{}", e.getMessage());
			throw new DDSException("failed initialization" + e.getMessage(),e);
		}
	}

	/**
	 * Install this adapter as the implementation of the DicomDataService interface.
	 * The following command line arguments are recognized:
	 *
	 * Command line arguments override Environment variable settings for
	 * configuration options. Environment variable settings override configuration
	 * file (CDS CFGGroup) settings.
	 *
	 *
	 * @throws DDSException if the object could not be opened
	 */
	public static synchronized void setup() throws DDSException {
		if (instance_ != null) {
			instance_ = null;
		}
		instance_ = new VixDicomDataService();
		setInstance(instance_);
	}

	/**
	 * Shutdown this adapter.
	 */
	public static synchronized void teardown() {
		instance_ = null;
	}


	/**
	 * Find objects that match the given dicomQuery criterion, and return the location in
	 * storage for those objects. This method is normally called by a Query Retrieve
	 * SCP when it receives a C-Move-Request or C-Get-Request. The QRSCP will handle
	 * the Store sub-operations when it gets back the list of matching instances.
	 * 
	 * @param association the current DICOM association. This contains information
	 *                    about the client AE, negotiated contexts, etc.
	 * @param dicomQuery       the c-move or c-get request DIMSE message which contains
	 *                    the dicomQuery criterion. This object contains both the command
	 *                    dataset, and the "data" dataset, which contains the dicomQuery
	 *                    identifier.
	 * @return a Vector which will be filled in with
	 *         DicomPersistentObjectDescriptors for the matching objects. Only the
	 *         information on how to load the object from storage is returned.
	 * @throws DDSException if an error occurs
	 */
	@Override
	public Vector<DicomPersistentObjectDescriptor> findObjectsForTransfer(AssociationAcceptor association, DimseMessage dicomQuery)
			throws DDSException {
		//Do C-MOVE, return a list of DPOD where persistentId is the filename with path, used by LBS to c-store
        logger.info("C_MOVE from {}  findObjectsForTransfer: dicomQuery ={}{}", association.getAssociationInfo().callingTitle(), newline_, dicomQuery.toString());

		StudyQuery query = null;
		try {
			query = (StudyQuery) QueryFactory.getQuery(association, dicomQuery, VixDicomQuery.QueryType.CMOVE, null);
		}catch(Exception e){
            logger.error("Process C-MOVE failed. msg {}", e.getMessage());
			if(logger.isDebugEnabled()){
				logger.debug("C-MOVE failure details ",e);
			}
			throw new DDSException("Process C-MOVE failed ", e);
		}
		destinationUidLocks.put(query.getDestinationAe()+query.getStudyUrn(), Instant.now());//ensure only one C-MOVE per destination,studyuid combo is processed at once
		cmoveAssociations.put(query.getCallingAe()+query.getCallingIp()+query.getStudyUrn(),association);//track the association so we can send keepalives during C-STORE
		Vector<DicomPersistentObjectDescriptor> result = null;
		try{
			result = query.performCMove();
		}catch (Exception e){
            logger.error("Perform CMOVE failed.  msg {}", e.getMessage());
			if(logger.isDebugEnabled()){
				logger.debug("C-MOVE failure details ",e);
			}
			destinationUidLocks.remove(getCmoveLockKey(query));
			cmoveAssociations.remove(getCmoveAssocKey(query));
			throw new DDSException("Perform C-MOVE failed ", e);
		}
		return result;
	}

	/**
	 * Find all objects that match the given dicomQuery criterion, and send them
	 * individually back to the specified DicomDataServiceListener object. This
	 * method is invoked by QR or MWL SCP's when they receive C-Find-Request
	 * messages. The results can be passed back to the dicomQuery listener as they are
	 * fetched, or all at once when the dicomQuery has completed. SCP's will typically
	 * generate C-Find-Response messages as they receive the results via the
	 * DicomDataServiceListener interface.
	 * 
	 * @param acceptor The current DICOM association acceptor. This contains
	 *                 information about the client AE, negotiated contexts, etc.
	 * @param dicomQuery    The DIMSE message which contains the dicomQuery criterion. This
	 *                 object contains both the command dataset, and the "data"
	 *                 dataset, which contains the matching and return keys.
	 * @param listener The DicomDataServiceListener that will receive the dicomQuery
	 *                 results.
	 * @throws DDSException if an error occurs
	 */
	@Override
	public void findObjects(AssociationAcceptor acceptor, DimseMessage dicomQuery, DicomDataServiceListener listener)
			throws DDSException {
        logger.info("C_FIND from {} findObjects: dicomQuery ={}{}", acceptor.getAssociationInfo().callingTitle(), newline_, dicomQuery.toString());

		try {
			VixDicomQuery query = QueryFactory.getQuery(acceptor, dicomQuery, VixDicomQuery.QueryType.PATIENTCFIND, listener);
			query.performCFind();
		}catch (Exception e){
            logger.error("Failed to correctly process C-FIND msg {}", e.getMessage());
			if(logger.isDebugEnabled()) logger.debug("C-FIND failure details ",e);
			throw new DDSException("C-FIND failed to process ", e);
		}
	}

	public static int sendStudyCFindResponse(StudyType study, Set<String> cleanModalities, String newDesc,
											 VixDicomQuery query)
			throws DCSException, ImagingDicomException, UnsupportedEncodingException {
		if(study.getDicomUid() == null){
            logger.warn("Tried to send a study with null dicomUid {}", study.getStudyId());
			return  -2;
		}
		DicomDataSet ds = new DicomDataSet(query.getDimseQuery().data());
		try {
			ds.insert(DCM.E_STUDY_INSTANCE_UID, study.getDicomUid());
			if (query.getPatientInfo().getDssn() != null) {
				ds.insert(DCM.E_PATIENT_ID, query.getPatientInfo().getDssn());
				ds.insert(DCM.E_PATIENTS_BIRTH_DATE, query.getPatientInfo().getDob());
			}else{//unknown at sta200 case
				ds.insert(DCM.E_PATIENT_ID, query.getPatientInfo().getIcn());
			}

			ds.insert(DCM.E_STUDY_DATE, (new SimpleDateFormat("yyyyMMdd").format(study.getProcedureDate())));
			ds.insert(DCM.E_STUDY_TIME, (new SimpleDateFormat("HHmmss").format(study.getProcedureDate())));
			ds.insert(DCM.E_PATIENTS_NAME, study.getPatientName());
			ds.insert(DCM.E_MODALITIES_IN_STUDY, String.join(" ", cleanModalities));
			ds.insert(DCM.E_STUDY_DESCRIPTION, newDesc);
			if (study.getAccessionNumber() != null) {
				ds.insert(DCM.E_ACCESSION_NUMBER, study.getAccessionNumber());
			}
			ds.insert(DCM.E_NUMBER_OF_STUDY_REL_SERIES, "" + study.getNumberOfSeries());
			int rptCnt = (DicomService.getScpConfig().getConfigForAe(query.getCallingAe(), query.getCallingIp()).getBuildReport().equalsIgnoreCase("NONE")) ? 0 : 1;
			int imgCnt = study.getStudyId().contains("vastudy:") ? study.getImageCount() + rptCnt : study.getImageCount();
			ds.insert(DCM.E_NUMBER_STUDY_REL_INSTANCES, "" + imgCnt);
			ds.insert(DCM.E_RETRIEVE_AE_TITLE, query.getRetrieveAe());
			if (DicomService.getScpConfig().getConfigForAe(query.getCallingAe(), query.getCallingIp()).isReturnQueryLevel()) {
				ds.insert(DCM.E_QUERYRETRIEVE_LEVEL, query.getQueryLevel());
			}
			return query.getListener().findObjectsResult(ds, DimseStatus.PENDING);
		}catch(Exception e){
            logger.error("Failed to send C-FIND result for {} msg: {}", study.getStudyId(), e.getMessage(), e);
			return -2;//processing continues without counting the study as sent, -1 would abort the C-FIND
		}
	}

	public static void completeCFind(DicomDataServiceListener listener, int finalResultCode){
		listener.findObjectsComplete(finalResultCode, null);
	}

	@Override
	public DicomDataSet loadObject(DicomPersistentObjectDescriptor dicomPersistentObjectDescriptor,
								   boolean readPixelData, DicomSessionSettings dicomSessionSettings)
			throws DDSException {
		if(dicomPersistentObjectDescriptor.persistentId() == null){
			logger.error("Attempting to C-STORE a null file");
			throw new DDSException("Attempting to C-STORE a null file");
		}

		if (logger.isDebugEnabled()){
            logger.debug("loadObject called: {}{}f_read_pixel_data = {}", dicomPersistentObjectDescriptor.persistentId(), newline_, readPixelData);
		}

		VixDpod vixDpod = null;
		if(dicomPersistentObjectDescriptor instanceof VixDpod){
			vixDpod = (VixDpod) dicomPersistentObjectDescriptor;
			if(!readPixelData && DicomService.getScpConfig().getConfigForAe(vixDpod.getStudyQuery().getCallingAe(),
					vixDpod.getStudyQuery().getCallingIp()).isSendKeepAlive()){ //send keepalive before we wait for a file to download to VIX
				try {
					sendKeepAlive(vixDpod);
				}catch (Exception e){
					logger.error("C-MOVE Keep Alive failed, continuing. Msg [{}]", e.getMessage());
					if(logger.isDebugEnabled()){
						logger.error("C-MOVE Keep Alive failure details", e);
					}
				}
			}
		}else{
            logger.error("Dpod is not a vixdpod, should not happen {}", dicomPersistentObjectDescriptor.persistentId());
			throw new DDSException("Got an invalid Dpod type");
		}

		String fileName = dicomPersistentObjectDescriptor.persistentId();
		try {
			return processDpod(vixDpod,readPixelData,dicomSessionSettings);
		}
		catch (Exception e){
			destinationUidLocks.remove(getCmoveLockKey(vixDpod.getStudyQuery()));
			cmoveAssociations.remove(getCmoveAssocKey(vixDpod.getStudyQuery()));
			logger.error("C-STORE failure for file {} msg {}", fileName, e.getMessage());
			if(logger.isDebugEnabled()){
                logger.debug("C-STORE Generic failure details for {}", fileName, e);
			}
			throw new DDSException("Generic exception handling, failure during C-STORE",e);
		}
	}

	private void sendKeepAlive(VixDpod dpod) throws DCSException {
		StudyQuery query = dpod.getStudyQuery();
		AssociationAcceptor association = cmoveAssociations.get(query.getCallingAe()+query.getCallingIp()+query.getStudyUrn());
		DimseMessage rsp = new DimseMessage(32801);
		rsp.context_id(query.getDimseQuery().context_id());
		rsp.messageIdResp(query.getDimseQuery().messageId());
		rsp.status(65280);
		rsp.dataSetType(257);
		rsp.numberOfRemainingSubops(dpod.getTotalCount());
		rsp.numberOfCompletedSubops(0);
		rsp.numberOfFailedSubops(0);
		rsp.numberOfWarningSubops(0);
		association.sendDimseMessage(rsp, 0);
	}

	private DicomDataSet processDpod(VixDpod vixDpod, boolean readPixelData, DicomSessionSettings
			dicomSessionSettings) throws DDSException, DCSException {
		String fileName = null;
		DicomDataSet toReturn = null;
		try {
			if (vixDpod instanceof ImageDpod) {
				if(vixDpod.getFetchResult().getCacheTask().isCached()){
					try{
						toReturn = readDicomFile(vixDpod.getFetchResult().getCacheFileName(), vixDpod, readPixelData,
								dicomSessionSettings, true);
					}catch(Exception e){
                        logger.warn("Could not read cached file {} msg {}", vixDpod.getFetchResult().getCacheFileName(), e.getMessage());
					}
				}else {
					long millisToWait = Integer.parseInt(DicomService.getScpConfig().getImageFetchTimeLimit()) * 1000L;
					fileName = NetworkFetchManager.getImageResultsBlocking((ImageFetchDto) vixDpod.getFetchResult(),
							millisToWait);
				}
			} else if (vixDpod instanceof ReportDpod) {
				fileName = NetworkFetchManager.getReportBlocking((ReportFetchDto) vixDpod.getFetchResult());
			}else{
                logger.error("Dpod Error, not report or image, what are you {}", vixDpod.persistentId());
				throw new DDSException("Dpod error, should not happen");
			}
		} catch (ExecutionException | InterruptedException | TimeoutException e) {
            logger.error("Dicom File Fetch failure for {} msg: {}", vixDpod.persistentId(), e.getMessage());
			throw new DDSException("Dicom File Fetch failure for " + vixDpod.persistentId(), e);
		}

		if(toReturn == null){
			if(fileName == null){
				throw new DDSException("Did not get file or file name for " + vixDpod.getFetchResult());
			}
			toReturn = readDicomFile(fileName,vixDpod,readPixelData,dicomSessionSettings);
		}

		if (logger.isTraceEnabled()) {
            logger.trace("loadObject: object = {}{}{}", newline_, toReturn, newline_);
		}

		if( vixDpod.getImageCount() == 1 && !readPixelData){
            logger.info("###===C-STORE begins for {}", vixDpod.getStudyUid());
		}

		if(readPixelData){
			logger.info("###====C-STORE processing for {}", vixDpod.getFetchResult().getCacheFileName());
		}

		if(vixDpod.getImageCount() == vixDpod.getTotalCount() && readPixelData){
			long totalMillis = System.currentTimeMillis() - vixDpod.getStartMillis();
            logger.info("###===C-STORE complete for {} perfTime {}ms", vixDpod, totalMillis);
			cmoveAssociations.remove(getCmoveAssocKey(vixDpod.getStudyQuery()));
			destinationUidLocks.remove(getCmoveLockKey(vixDpod.getStudyQuery()));
			DicomService.vistaLog(vixDpod.getStartMillis(), vixDpod.getPatientIcn(), "C-STORE ", vixDpod.getDestAe(),
					vixDpod.getTotalCount(), vixDpod.getTotalCount(),"n/a", "n/a",false,
					null, "","Dicom C-STORE", "",
					PatientCFind.getStudyUrnByUid(vixDpod.getStudyUid()),"SCP", "C-STORE ",
					vixDpod.getSrcSiteCode(), vixDpod.getStudyQuery().getTransactionGuid(),
					vixDpod.getStudyQuery().getSiteCode());
		}
		return toReturn;
	}

	private static String getCmoveAssocKey(StudyQuery query){
		return query.getCallingAe()+query.getCallingIp()+query.getStudyUrn();
	}

	private static String getCmoveLockKey(StudyQuery query){
		return query.getDestinationAe()+query.getStudyUrn();
	}

	private DicomDataSet readDicomFile(String fileName, DicomPersistentObjectDescriptor dpod, boolean readPixelData,
									   DicomSessionSettings dicomSessionSettings, boolean retry ) throws DCSException {
		try{
			return readDicomFile(fileName, dpod, readPixelData,dicomSessionSettings);
		}catch (Exception e){
			logger.warn("First attempt to read {} failed retry is {} msg {} sleeping 500", fileName, retry, e.getMessage());
			String tempFileName = fileName + "_temp";
			try {
				Thread.sleep(500);
				DicomDataSet tempDs = readDicomFile(tempFileName, dpod, readPixelData, dicomSessionSettings);
				if(tempDs != null) {
					logger.warn("Able to return data from temp file {} data is {}", tempFileName, tempDs);
					return tempDs;
				}
			} catch (Exception ex) {
				logger.warn("Expected error: Failed to read temp file {}", ex.getMessage());
			}
		}
		return readDicomFile(fileName, dpod, readPixelData, dicomSessionSettings);
	}

	private DicomDataSet readDicomFile(String fileName, DicomPersistentObjectDescriptor dpod, boolean readPixelData,
									   DicomSessionSettings dicomSessionSettings ) throws DCSException {
		DicomFileInput dfi = new DicomFileInput(fileName, dicomSessionSettings);
		dfi.setReadPixelData(readPixelData);
		dfi.open();
		DicomDataSet toReturn = dfi.readDataSet();
		if (dpod != null && (dpod.persistentInfo() == null || dpod.persistentInfo().length() == 0)) {
			dpod.persistentInfo(dfi.transferSyntax());
		}
		dfi.close();
		return toReturn;
	}

	//===========================================non Q/R methods=======================
	@Override
	public void updateObject(AssociationAcceptor associationAcceptor, DimseMessage dimseMessage) throws DDSException {
		//not implemented
	}

	@Override
	public void commitRequestReceived(AssociationAcceptor associationAcceptor, DimseMessage dimseMessage, DimseMessage dimseMessage1) throws DDSException {
		//not implemented
	}

	@Override
	public void commitRequestSent(AssociationRequester associationRequester, DimseMessage dimseMessage, DimseMessage dimseMessage1) throws DDSException {
		//not implemented
	}

	@Override
	public void commitCompleted(DimseServiceUser dimseServiceUser, DimseMessage dimseMessage, DimseMessage dimseMessage1) throws DDSException {
		//not implemented
	}

	@Override
	public void storeObject(DicomDataSet dicomDataSet, DicomPersistentObjectDescriptor dicomPersistentObjectDescriptor, DicomSessionSettings dicomSessionSettings) throws DDSException {
		//not implemented, we dont store
	}

	@Override
	public void storeObject(AssociationAcceptor associationAcceptor, DimseMessage dimseMessage, DimseMessage dimseMessage1, DicomPersistentObjectDescriptor dicomPersistentObjectDescriptor) throws DDSException {
		//not implemented, we dont store
	}

	@Override
	public DicomPersistentObjectDescriptor duplicateObject(DicomPersistentObjectDescriptor dicomPersistentObjectDescriptor) throws DDSException {
		//not implemented
		return null;
	}

	@Override
	public void referenceObject(DicomPersistentObjectDescriptor dicomPersistentObjectDescriptor) throws DDSException {
		//not implemented
	}

	@Override
	public void dereferenceObject(DicomPersistentObjectDescriptor dicomPersistentObjectDescriptor) throws DDSException {
		//not implemented
	}

	@Override
	public void deleteObject(DicomPersistentObjectDescriptor dicomPersistentObjectDescriptor, boolean b) throws DDSException {
		//not implemented
	}
}
