package gov.va.med.imaging.study.dicom.remote.study;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.query.VixDicomQuery;
import gov.va.med.imaging.study.rest.StudyService;
import gov.va.med.imaging.study.rest.types.*;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.ConnectionFailedException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.MethodException;
import gov.va.med.logging.Logger;

import java.time.Instant;
import java.util.concurrent.Callable;

public class StudyFetchTask implements Callable<StudiesResultType> {
	protected final String vixSiteId;
	protected final String patientId;
	protected final StudyFilterType studyFilter = new StudyFilterType();
	private final static Logger LOGGER = Logger.getLogger(StudyFetchTask.class);
	protected final String tContextGuid;
	protected Instant lastAccessed = Instant.now();
	protected long startMillis;
	protected StudiesResultType result = null;

	public StudyFetchTask(String siteId, String patientId, StudyFilterResultType studyFilterTerm, String tContextGuid){
		this.vixSiteId = siteId;
		this.patientId = patientId;
		this.tContextGuid = tContextGuid;
		this.studyFilter.setResultType(studyFilterTerm);
	}

	public StudyFetchTask(String siteId, VixDicomQuery vixDicomQuery, StudyFilterResultType studyFilterTerm) {
		this.tContextGuid = vixDicomQuery.getTransactionGuid();
		this.vixSiteId = siteId;
		this.patientId = vixDicomQuery.getPatientInfo().getIcn();
		if(getVixSiteId().equals("200CRNR") || getVixSiteId().equals("200")){
			this.studyFilter.setResultType(StudyFilterResultType.all);//only all works over fed for Cerner
		}else {
			this.studyFilter.setResultType(studyFilterTerm);
		}
	}

	protected void setup() throws CannotLoadConfigurationException, InvalidCredentialsException, MethodException,
			ConnectionFailedException {
		DicomService.prepareTransactionContext(tContextGuid); //this thread's transaction context
		this.startMillis = System.currentTimeMillis();
	}

	protected StudiesResultType postProcess(StudiesResultType retx) {
		long perfsitemilli = System.currentTimeMillis() - this.startMillis;
		if(retx == null || retx.getStudies() == null || retx.getStudies().getStudies() == null){
            LOGGER.warn("StudyFetch from site {} for {} unsuccessful. Took {} ms.", getVixSiteId(), patientId, perfsitemilli);
			retx = new StudiesResultType();
			StudiesType emptyStudies = new StudiesType();
			emptyStudies.setStudies(new StudyType[0]);
			retx.setStudies(emptyStudies);
		}
		return retx;
	}

	@Override
	public StudiesResultType call()
			throws InvalidCredentialsException, MethodException, ConnectionFailedException,
			CannotLoadConfigurationException, ImagingDicomException {
		setup();
		StudiesResultType retx = null;
		if(LOGGER.isDebugEnabled()){
            LOGGER.debug("FederationStudyFetch site: {} patient: {} filter={}", getVixSiteId(), patientId, studyFilter.getResultType());
		}
		try {
			retx = postProcess(new StudyService().getPatientStudiesFromIcnWithAccessionNumber(getVixSiteId(), patientId, studyFilter)); //legacy architecture handles caching
		} catch (gov.va.med.imaging.core.interfaces.exceptions.MethodException | ConnectionException e) {
            LOGGER.error("Unable to get study meta through federation for {} site {} msg {}", patientId, getVixSiteId(), e.getMessage());
			if(LOGGER.isDebugEnabled()){
				LOGGER.debug("Study meta failure details ", e);
			}
			return postProcess(null);
		}
		StudiesResultType toReturn = postProcess(retx);
		long perfsitemilli = System.currentTimeMillis() - this.startMillis;
        LOGGER.info("###===<GetVixStudies from site {} for {} totsize={} returns {} part={}. took {} ms.", getVixSiteId(), patientId, toReturn.getSize(), toReturn.getStudies().getStudies().length, toReturn.isPartialResult(), perfsitemilli);
		return toReturn;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		StudyFetchTask that = (StudyFetchTask) o;

		if (!getVixSiteId().equals(that.getVixSiteId())) return false;
		if (!studyFilter.getResultType().equals(that.studyFilter.getResultType())) return false;
		return patientId.equals(that.patientId);
	}

	@Override
	public int hashCode() {
		int result = getVixSiteId().hashCode();
		result = 31 * result + patientId.hashCode();
		result = 31 * result + studyFilter.getResultType().hashCode();
		return result;
	}

	public String getVixSiteId() {
		return vixSiteId;
	}

	public Instant getLastAccessed() {
		return lastAccessed;
	}

	public void updateAccessTime(){
		lastAccessed = Instant.now();
	}
}
