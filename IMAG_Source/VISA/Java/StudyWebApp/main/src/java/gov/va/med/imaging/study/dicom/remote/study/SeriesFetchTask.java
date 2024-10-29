package gov.va.med.imaging.study.dicom.remote.study;

import gov.va.med.StudyURNFactory;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.remote.HttpsUtil;
import gov.va.med.imaging.study.rest.StudyService;
import gov.va.med.imaging.study.rest.types.LoadedStudyType;
import gov.va.med.imaging.study.rest.types.StudySeriesesType;
import gov.va.med.imaging.study.rest.types.StudyType;
import gov.va.med.logging.Logger;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import java.io.File;
import java.nio.file.Files;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.concurrent.Callable;

public class SeriesFetchTask implements Callable<StudySeriesesType> {

	private final static Logger LOGGER = Logger.getLogger(SeriesFetchTask.class);
	private final String studyUrn;
	private final String transactionContextGuid;
	private final String siteCode;
	private final String icn;

	public SeriesFetchTask(String studyUrn, String transactionContextGuid) throws URNFormatException {
		StudyURN urn = StudyURNFactory.create(studyUrn);
		this.studyUrn = studyUrn;
		this.transactionContextGuid = transactionContextGuid;
		this.icn = urn.getPatientId();
		this.siteCode = urn.getOriginatingSiteId();
	}

	public SeriesFetchTask(String studyUrn, String transactionContextGuid, String siteCode, String icn)
	{
		this.studyUrn = studyUrn.replace("%5b", "[").replace("%5d", "]");
		this.transactionContextGuid = transactionContextGuid;
		this.siteCode = siteCode;
		this.icn = icn;
	}

	@Override
	public StudySeriesesType call() throws Exception {
		long startmilli = System.currentTimeMillis();
		DicomService.prepareTransactionContext(transactionContextGuid); //must be done on the new thread
		StudySeriesesType serieses = getSeriesForStudy();

		if(LOGGER.isDebugEnabled()){
            LOGGER.debug("===<VixSeriesDataSource_ ends, got series , took {} ms for studyUrn={}", System.currentTimeMillis() - startmilli, studyUrn);
		}

		return serieses;
	}

	/* */
	private StudySeriesesType getSeriesForStudy() {
		try {
			return getStudyAndSeriesMeta().getSeries();
		} catch (Exception e) {
            LOGGER.error("Get Series For Study fails with msg: {}", e.getMessage());
			return null;
		}
	}

	public LoadedStudyType getStudyAndSeriesMeta()
	{
		long startMillis = System.currentTimeMillis();
		LoadedStudyType lst = null;
		LoadedStudyType st = loadFromCache();
		if(st != null){
			try{
				long end = System.currentTimeMillis() - startMillis;
				LOGGER.info("Serving study metadata for [{}] from cache took [{}]",studyUrn, end);
				return st;
			}catch (Exception e){
                LOGGER.warn("failed to convert cached study to loadedstudytype {}", e.getMessage());
			}
		}
		try {
			if(!DicomService.getSiteInfo().getSiteCode().equals(siteCode)) {
				try {
					lst = HttpsUtil.getSeriesMeta(studyUrn, siteCode);
				}catch (Exception e){
                    LOGGER.warn("Direct Http fetch for series meta failed, falling back to local commands {}", e.getMessage());
				}
				if (lst == null || lst.getSeries() == null || lst.getSeries().getSeries() == null) {
                    LOGGER.warn("###==-Direct fetch for series of {} failed  retrying through federation", studyUrn);
				}
			}

			if (lst == null || lst.getSeries() == null || lst.getSeries().getSeries() == null) {
				lst = new StudyService().getStudy(studyUrn, true);
			}

			if (lst.getSeries() == null || lst.getSeries().getSeries() == null) {
                LOGGER.warn("###==-Got NULL series for study({}), took {} ms. return null", studyUrn, System.currentTimeMillis() - startMillis);
				return lst;
			}

			saveSeriesMetaToCache(lst);

            LOGGER.info("###==-SeriesFetch got {} series for study({}), took {} ms", lst.getSeries().getSeries().length, studyUrn, System.currentTimeMillis() - startMillis);

			String[] mods = lst.getStudyModalities(); // dod studies put modality here
			String mod = lst.getProcedureDescription(); // va studies put modality here
			if(mods != null && mods.length > 0 && (mod == null || mod.length() == 0)) {
				StringBuilder modstring = new StringBuilder();
				for (String s : mods) modstring.append(" ").append(s);
				if (modstring.length() > 1) modstring = new StringBuilder(modstring.substring(1));
				mod = modstring.toString();
			}
			String modality = mod;
			if (mod.startsWith("RAD ") || mod.startsWith("CON ")) { // vista added. remove. per John D.
				modality = mod.substring(4);
			}
			if(LOGGER.isDebugEnabled()){
                LOGGER.debug("study_urn={} got from studyModalities or procedureDescription={} final modality={}", studyUrn, mod, modality);
			}
		} catch (MethodException | ConnectionException e) {
            LOGGER.error("Failed to fetch series data for {} msg: {}", studyUrn, e.getMessage());
			if(LOGGER.isDebugEnabled()) LOGGER.debug("Series fetch failure details ", e);
		}
		return lst;
	}

	// if file ops fail, just no cache, metadata will be pulled each time
	private void saveSeriesMetaToCache(LoadedStudyType sst) {
		if (sst == null || sst.getSeries() == null){
			return;
		}
		try {
			String fileName = DicomService.getSeriesMetaFileName(studyUrn, icn);
			JAXBContext jaxb = JAXBContext.newInstance(LoadedStudyType.class);
			Marshaller marshaller = jaxb.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			File seriesMetaFile = new File(fileName);
			if(!seriesMetaFile.exists() && !seriesMetaFile.getParentFile().exists()) {
				seriesMetaFile.getParentFile().mkdirs();
				marshaller.marshal(sst, seriesMetaFile);
			}
		} catch (Exception e) {
            LOGGER.warn("Cannot save series for {} proceeding with in-memory cache. msg {}", studyUrn, e.getMessage());
			if(LOGGER.isDebugEnabled()) LOGGER.debug("series meta save failure details", e);
		}
	}

	private LoadedStudyType loadFromCache(){
		try{
			String fileName = DicomService.getSeriesMetaFileName(studyUrn, icn);
			File seriesMetaFile = new File(fileName);
			if(seriesMetaFile.exists() && seriesMetaFile.isFile() ){
				Instant fi = Files.getLastModifiedTime(seriesMetaFile.toPath()).toInstant();
				if(LOGGER.isDebugEnabled()){
					LOGGER.debug("Cache expires [{}], last modified time is [{}]", fi.toString(), Instant.now().minus(DicomService.getScpConfig().getCacheMetaHoursToLive(), ChronoUnit.HOURS));
				}
				if(fi.isAfter(Instant.now().minus(DicomService.getScpConfig().getCacheMetaHoursToLive(), ChronoUnit.HOURS))) {
					JAXBContext jaxb = JAXBContext.newInstance(StudyType.class, LoadedStudyType.class);
					Unmarshaller unmarshaller = jaxb.createUnmarshaller();
					return (LoadedStudyType) unmarshaller.unmarshal(seriesMetaFile);
				}
			}
			return null;
		}catch (Exception e) { //nice to have not need to have
            LOGGER.warn("Cannot load series for {} from cache. msg {}", studyUrn, e.getMessage());
			return null;
		}
	}
}
