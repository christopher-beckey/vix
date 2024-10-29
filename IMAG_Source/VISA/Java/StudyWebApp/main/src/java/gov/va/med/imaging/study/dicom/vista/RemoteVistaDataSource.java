package gov.va.med.imaging.study.dicom.vista;

import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.protocol.vista.VistaImagingTranslator;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.ConnectionFailedException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.MethodException;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.url.vista.image.SiteParameterCredentials;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.VistaImagingQueryFactory;
import gov.va.med.logging.Logger;

import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.SortedSet;
import java.util.concurrent.ConcurrentHashMap;

public class RemoteVistaDataSource {

    private static final Map<String, SiteParameterCredentials> credsBySite = new ConcurrentHashMap<>();
    private final Site site;
    private final VistaSession vistaSession;
    private final static Logger logger = Logger.getLogger(RemoteVistaDataSource.class);
    private final String callingAe;
    private final String callingIp;

    public RemoteVistaDataSource(String siteCode, String callingAe, String callingIp) throws ImagingDicomException {
        try {
            this.site = DicomService.getSiteByCode(siteCode);
            if(this.site == null){
                throw new ImagingDicomException("Could not find site " + siteCode + " for direct fetch");
            }
        } catch (gov.va.med.imaging.core.interfaces.exceptions.MethodException | ConnectionException e) {
            logger.error("Could not look up site {} to perform direct fetch {}", siteCode, e.getMessage());
            throw new ImagingDicomException("Could not look up site " + siteCode + " to perform direct fetch " + e.getMessage());
        }

        this.vistaSession = createVistaSessionForSite();
        this.callingAe = callingAe;
        this.callingIp = callingIp;
    }

    private VistaSession createVistaSessionForSite() throws ImagingDicomException {
        String vistaUrl = createVistaUrl();
        try {
            DicomService.prepareTransactionContext(callingAe, callingIp);
            return VistaSession.getOrCreate(new URL(vistaUrl), site, ImagingSecurityContextType.MAG_WINDOWS);
        } catch (CannotLoadConfigurationException | InvalidCredentialsException | MethodException |
                IOException | gov.va.med.imaging.core.interfaces.exceptions.MethodException | ConnectionFailedException |
                ConnectionException e) {
            logger.error("Problem creating VistaSession for direct fetch msg {}", e.getMessage());
            if(logger.isDebugEnabled()){
                logger.debug("VistaSession creation failure details ", e);
            }
            throw new ImagingDicomException("Problem creating VistaSession for direct fetch " + e.getMessage(), e);
        }
    }

    private String createVistaUrl() throws ImagingDicomException {
        String vistaHostNameAndPort = null;

        for (SiteConnection siteConnection : site.getSiteConnections().values()) {
            if (siteConnection.getProtocol().equals("VISTA")) {
                vistaHostNameAndPort = siteConnection.getServer() + ":" + siteConnection.getPort();
                break;
            }
        }
        if(vistaHostNameAndPort == null){
            throw new ImagingDicomException("No VistA for site " + site.getSiteNumber() + " cannot direct fetch images");
        }
        return "vistaimaging://" + vistaHostNameAndPort;
    }

    public Study getStudyByUrn(StudyURN studyUrn) throws ImagingDicomException {
        try {
            String studyIen = studyUrn.getStudyId();
            Map<String, String> studyMap = new HashMap<>();
            studyMap.put("" + studyMap.size(), studyIen);
            String patientDfn = VistaCommonUtilities.getPatientDfn(vistaSession, studyUrn.getThePatientIdentifier());
            StudyDeletedImageState studyDeletedImageState = StudyDeletedImageState.cannotIncludeDeletedImages;
            SortedSet<Study> studies = getPatientStudyGraph(vistaSession, studyMap, patientDfn,
                    StudyLoadLevel.FULL, studyDeletedImageState);
            if(studies.size() <= 0)
            {
                logger.error("Got zero studies from VistA for {}", studyUrn);
                return null;
            }
            if(studies.size() > 1)
            {
                logger.error("Got more than one study from VistA for {}", studyUrn);
                return null;
            }
            return studies.first();
            //does this just do the firstImage crap? revisit
            //VistaQuery patGroupsQuery = VistaImagingQueryFactory.createGetGroupsVistaQuery(patientDfn, null);
            //String patGroupString = vistaSession.call(patGroupsQuery);
            //SortedSet<VistaGroup> groups =  VistaImagingTranslator.createGroupsFromGroupLines(site, patGroupString,
            //        studyUrn.getThePatientIdentifier(), studyDeletedImageState);
            //if((groups == null) || (groups.size() <= 0))
            //{
              //  return null;
            //}
            //return VistaImagingCommonUtilities.mergeStudyWithMatchingGroup(vistaSession, study, groups, StudyLoadLevel.FULL);
        } catch (IOException | gov.va.med.imaging.core.interfaces.exceptions.MethodException | ConnectionException e) {
            logger.error("Could not get image list from remote VistA for {}", studyUrn.getStudyId());
            if(logger.isDebugEnabled()){
                logger.debug("Failure to get image list details {}", studyUrn.getStudyId(), e);
            }
            throw new ImagingDicomException("Could not get image list from remote VistA for " + studyUrn.getStudyId(), e);
        }
    }

    @Override
    public String toString() {
        return "RemoteVistaDataSource{" +
                "site=" + site.getSiteName() +
                ", vistaSession=" + vistaSession.getConnectTime() +
                ", callingAe='" + callingAe + '\'' +
                ", callingIp='" + callingIp + '\'' +
                '}';
    }

    private SortedSet<Study> getPatientStudyGraph(
            VistaSession localVistaSession,
            Map<String, String> studyMap,
            String patientDfn,
            StudyLoadLevel studyLoadLevel,
            StudyDeletedImageState studyDeletedImageState)
            throws gov.va.med.imaging.core.interfaces.exceptions.MethodException, ConnectionException
    {
        try
        {
            VistaQuery query = VistaImagingQueryFactory.createGetStudiesByIenVistaQuery(studyMap,
                    patientDfn, studyLoadLevel);
            String vistaResponse = localVistaSession.call(query);

            return VistaImagingTranslator.createStudiesFromGraph(site, vistaResponse, studyLoadLevel,
                    studyDeletedImageState);
        }
        catch (Exception ex)
        {
            logger.error("Failed to get study set for {}msg :{}", this, ex.getMessage());
            throw new gov.va.med.imaging.core.interfaces.exceptions.MethodException(ex);
        }
    }

    public static void purgeCredsForSite(String siteCode){
        credsBySite.remove(siteCode);
    }

    public static SiteParameterCredentials getSiteParameterCredentials(String siteCode, String callingAe, String callingIp) throws ImagingDicomException {
        if (credsBySite.containsKey(siteCode)) {
            return credsBySite.get(siteCode);
        }
        try{
            RemoteVistaDataSource remoteVistaDataSource = new RemoteVistaDataSource(siteCode, callingAe, callingIp);
            credsBySite.put(siteCode, remoteVistaDataSource.getSiteCreds());
            return credsBySite.get(siteCode);
        } catch (IOException | InvalidVistaCredentialsException | VistaMethodException e) {
            logger.error("Could not get SiteParameterCredentials for site {} cannot do direct image fetch", siteCode);
            if(logger.isDebugEnabled()){
                logger.debug("Could not get SiteParameterCredentials for site {}", siteCode, e);
            }
            throw new ImagingDicomException("Could not get SiteParameterCredentials for site " + siteCode);
        }
    }

    private SiteParameterCredentials getSiteCreds() throws InvalidVistaCredentialsException, VistaMethodException, IOException {
        VistaQuery siteParameterQuery = VistaImagingQueryFactory.createGetImagingSiteParametersQuery(VistaCommonUtilities.getWorkstationId());
        String rtn = vistaSession.call(siteParameterQuery);
        return VistaImagingTranslator.VistaImagingSiteParametersStringToSiteCredentials(rtn);
    }
}
