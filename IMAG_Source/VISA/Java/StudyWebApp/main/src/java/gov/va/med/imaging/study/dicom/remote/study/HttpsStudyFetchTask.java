package gov.va.med.imaging.study.dicom.remote.study;

import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.query.VixDicomQuery;
import gov.va.med.imaging.study.dicom.remote.HttpsUtil;
import gov.va.med.imaging.study.rest.types.StudiesResultType;
import gov.va.med.imaging.study.rest.types.StudyFilterResultType;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.ConnectionFailedException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.MethodException;
import gov.va.med.logging.Logger;

public class HttpsStudyFetchTask extends StudyFetchTask {

    private final static Logger LOGGER = Logger.getLogger(HttpsStudyFetchTask.class);

    public HttpsStudyFetchTask(String siteId, VixDicomQuery vixDicomQuery, StudyFilterResultType studyFilterTerm) {
        super(siteId, vixDicomQuery, studyFilterTerm);
    }

    @Override
    public StudiesResultType call() throws CannotLoadConfigurationException, InvalidCredentialsException,
            MethodException, ConnectionFailedException, ImagingDicomException {
        setup();
        if(LOGGER.isDebugEnabled()){
            LOGGER.debug("HttpStudyFetch site: {} patient: {} filter={}", getVixSiteId(), patientId, studyFilter.getResultType());
        }
        StudyResultWrapper retx = null;

        if(useHttpFetch()) { //only go direct if not local and using generic filter revisit this logic when 329 rolled out nationally and filters available at all VIX
            retx = HttpsUtil.getStudyMetaForSite(vixSiteId, patientId, studyFilter);
            if(retx == null || retx.getResult() == null || retx.getStatusCode() == 404){
                retx = HttpsUtil.getStudyMetaForSiteLegacy(vixSiteId, patientId, studyFilter);
            }
        }

        if(retx == null || retx.getStatusCode() != 200){
            return super.call();
        }
        StudiesResultType toReturn = postProcess(retx.getResult());
        long perfsitemilli = System.currentTimeMillis() - this.startMillis;
        LOGGER.info("###===<GetVixStudies from site {} for {} totsize={} returns {} part={}. took {} ms.", getVixSiteId(), patientId, toReturn.getSize(), toReturn.getStudies().getStudies().length, toReturn.isPartialResult(), perfsitemilli);
        return toReturn;
    }

    private boolean useHttpFetch(){
        if(getVixSiteId().equals(DicomService.getSiteInfo().getSiteCode())){
            return false; //local site use local commands
        }

        //CCIA will not support new filtering without code change, only 329 hosts will allow new filtering, and only 200/CVIX is guaranteed to be 329 for any production VIX executing this code, revisit after 329 national
        return isLegacyFilterTerm() || getVixSiteId().equals("200");//post 329 national !isLegacyFilterTerm() && getVixSiteId().equals("200CRNR");
    }

    private boolean isLegacyFilterTerm(){
        if(studyFilter.getResultType().equals(StudyFilterResultType.all)) return true;
        return studyFilter.getResultType().equals(StudyFilterResultType.radiology);
    }
}
