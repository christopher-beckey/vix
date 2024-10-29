package gov.va.med.imaging.study.dicom.vista;

import gov.va.med.imaging.conversion.IdConversion;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.remote.NetworkFetchManager;
import gov.va.med.imaging.study.rest.types.StudyFilterResultType;
import gov.va.med.imaging.tomcat.vistarealm.VistaAccessVerifyRealm;
import gov.va.med.imaging.tomcat.vistarealm.VistaQuery;
import gov.va.med.imaging.tomcat.vistarealm.VistaRealmPrincipal;
import gov.va.med.imaging.tomcat.vistarealm.broker.NewRpcBroker;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.ConnectionFailedException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.MethodException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.RpcException;
import gov.va.med.imaging.transactioncontext.ClientPrincipal;
import gov.va.med.logging.Logger;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

//Takes a queried Patient Id as received from C-FIND req, converts to an ICN and DFN, gets patient demo data and TFL
//DFN is not required at Sta200, but this case needs further consideration as demo data not available without DFN
public class LocalVistaDataSource {
    private final static Logger logger = Logger.getLogger(LocalVistaDataSource.class);
    private static String bseToken;
    private static Instant bseTokenInstant;
    private final NewRpcBroker broker;
    private static ClientPrincipal principal;
    private static boolean isSetup = false;
    private static final Map<String, PatientInfo> patIcnToInfo = new ConcurrentHashMap<>(); //TODO: look at implementing cache limits, more robust cache management, maybe guava LoaderCache?
    private static final Map<String, String> queriedIdToIcn = new HashMap<>(); //maps icns to originally queried patientIds, we operate on icns as we always have one, but original patient id could be icn, edipi,ssn, or dfn

    //private to limit access to Vista, only this class should initiate access to vista, should cache all possible values for performance reasons
    private LocalVistaDataSource()
            throws InvalidCredentialsException, MethodException, ConnectionFailedException, CannotLoadConfigurationException {
        setup();
        this.broker = connectAndAuthWithVista();
    }

    public static String getBseToken() throws MethodException,
            InvalidCredentialsException, ConnectionFailedException, CannotLoadConfigurationException {
        if(bseTokenInstant != null && bseTokenInstant.isAfter(Instant.now().minus(1, ChronoUnit.DAYS))){
            return bseToken;
        }
        LocalVistaDataSource localVistaDataSource = new LocalVistaDataSource();
        localVistaDataSource.refreshBse();
        if(bseTokenInstant.isAfter(Instant.now().minus(1, ChronoUnit.DAYS))){
            return bseToken;
        }
        throw new RpcException("Bse Token cannot be updated and is no longer valid");
    }

    public static PatientInfo getPatientInfo(String queriedPatientId, String transId, StudyFilterResultType filter) throws ImagingDicomException
    {
        if(patIcnToInfo.containsKey(queriedPatientId) && patIcnToInfo.get(queriedPatientId).getIcn().equals("-1")){
            throw new ImagingDicomException("VistA does not return patient info for " + queriedPatientId);
        }

        String icn = null;
        if(queriedIdToIcn.containsKey(queriedPatientId)){
            icn = queriedIdToIcn.get(queriedPatientId);
        }else{
            try {
                LocalVistaDataSource localVistaDataSource = new LocalVistaDataSource();
                PatientInfo patientInfo = localVistaDataSource.getPatientInfoFromVista(queriedPatientId, transId,filter);

                icn = patientInfo.getIcn();
                patIcnToInfo.put(icn, patientInfo);
            }catch(Exception e){
                logger.error("Failed to fetch patient info from VistA {}", e.getMessage());
                if(logger.isDebugEnabled()){
                    logger.debug("vista patInfo fetch failure details " , e);
                }
                throw new ImagingDicomException("Failed to get necessary patient information to process query for " + queriedPatientId);
            }
        }

        return patIcnToInfo.get(icn);
    }

    private PatientInfo getPatientInfoFromVista(String queriedPatientId, String transId, StudyFilterResultType filter) throws RpcException, ImagingDicomException
    {
        if(logger.isDebugEnabled()){
                logger.debug("LocalVistaDataSource-getPatientInfoFromVista({})",queriedPatientId);
        }
        PatientInfo patientInfo = new PatientInfo();
        try{
           patientInfo = getIcnFromPid(queriedPatientId);
        }catch (RpcException rpcException){
            logger.warn("Failed to resolve queried patient Id " + queriedPatientId + " with exception: " + rpcException.getMessage());
        }
        if(!patientInfo.isPatIdResolved()){
            if(!DicomService.getScpConfig().isRemotePatientResolution() || !DicomService.getSiteInfo().getLocalSiteType().equals("VIX")){
                throw new RpcException("Could not resolve Patient Id " + queriedPatientId);
            }
            logger.info("Attempting to resolve unknown patient through CVIX");
            patientInfo = new PatientInfo(NetworkFetchManager.getInfoForUnkPatId(queriedPatientId,transId));
            if(!patientInfo.isPatIdResolved()){
                logger.warn("Failed to resolve unknown patient through CVIX ");
                throw new ImagingDicomException("Failed to resolve unknown patient through CVIX");
            }
            return patientInfo;
        }

        try {
            patientInfo.setMtfList(getTflFromVista(patientInfo.getIen()));
            if(logger.isDebugEnabled()) {
                logger.debug("Mtf list is: {}", Arrays.toString(patientInfo.getMtfList().toArray(new String[0])));
            }
        } catch (Exception e) {
            logger.error("VistA cannot get patient MTF list for {} / {} msg: {}", queriedPatientId, patientInfo.getIen(), e.getMessage());
            throw new RpcException("Failed to get TFL, cannot continue for " + queriedPatientId);
        }

        //name Dssn DoB
        try {
            // get patient info (name, dob)

            String pdata = null;
            try {
                String patientQueryData = broker.runRpc("ORRCQLPT PTDEMOS", patientInfo.getIen());
                logger.debug("ORRCQLPT PTDEMOS result is {}", patientQueryData);
                pdata = patientQueryData.replace("^", ":");
                String[] patientData = pdata.split(":");
                patientInfo.setName(patientData[1]);
                patientInfo.setDssn(patientData[2]);
                patientInfo.setDob(patientData[3]);
            }catch(Exception e){
                logger.error("VistA cannot get patient information for {} / {} rpc=ORRCQLPT PTDEMOS msg: {}",
                        queriedPatientId, patientInfo.getIen(), e.getMessage());
            }

            if (DicomService.getSiteInfo().getLocalSiteType().equals("VIX")) {
                try {
                    pdata = broker.runRpc("MAGG PAT INFO", patientInfo.getIen() + "^^0^^1");
                    pdata = pdata.replace("^", ":");
                    String[] sn = pdata.split(":");
                    patientInfo.setSex(sn[3]);
                } catch (Exception e) {
                    logger.error("VistA cannot get patient information for {} / {} rpc=MAGG PAT INFO msg: {}",
                            queriedPatientId, patientInfo.getIen(), e.getMessage());
                    if (logger.isDebugEnabled()){
                        logger.debug("Failure to get patient info details ", e);
                    }
                }
            }

            try {
                if (patientInfo.getSex() == null || patientInfo.getSex().length() == 0) {
                    pdata = broker.runRpc("ORWPT ID INFO", patientInfo.getIen());
                    pdata = pdata.replace("^", ":");
                    String[] sn = pdata.split(":");
                    patientInfo.setSex(sn[2]);
                }
            } catch (Exception e) {
                logger.error("VistA cannot get patient information for {} / {} rpc=ORWPT ID INFO msg: {}",
                        queriedPatientId, patientInfo.getIen(), e.getMessage());
            }

        } catch(Exception e){
            logger.error("VistA cannot get Dssn or DoB for {} rpc=ORRCQLPT PTDEMOS msg {}", patientInfo.getIen(), e.getMessage());
            if (logger.isDebugEnabled()){
                logger.debug("Failure to get dssn or dob info details ", e);
            }
        }
        return patientInfo;
    }

    private PatientInfo mapPatientIcn(String queriedPid, String icn, PatientInfo patientInfo){
        queriedIdToIcn.put(queriedPid, icn);
        patientInfo.setIcn(icn);
        patientInfo.setPatIdResolved(true);
        return patientInfo;
    }

    private PatientInfo getIcnFromPid(String pidin) throws RpcException {
        PatientInfo patientInfo = new PatientInfo();
        String icn = null;
        if (pidin.length() == 9) { //ssn
            patientInfo.setDssn(pidin);
            icn = broker.runRpc("DSIC DPT GET ICN", pidin).replace("^", ":");
            if(icn.equals("")){
                throw new RpcException("Did not get ICN from VistA for pid " + pidin);
            }
            icn = icn.split(":")[0];
            if(icn.equals("-1")){
                throw new RpcException("Did not get ICN from VistA for pid " + pidin);
            }
            logger.info("Query Patient ID is SSN: {}  got ICN from VistA: {}",pidin,icn);
        } else if (pidin.length() == 10 && pidin.charAt(0) == '1') { //EDIPI
            try { //this block always fails on VIX as they do not connect to LVS
                icn = IdConversion.toIcnByEdipi(pidin); //blocking and need to block here if given edipi
                logger.info("Query Patient ID is EDIPI: {}  got ICN from MVI: {}",pidin,icn);
                if(icn == null || icn.length() < 17 || !icn.contains("V")){
                    throw new RpcException("Failed to get ICN from EDIPI. EDIPI " + pidin + " returned ICN " + icn);
                }
                patientInfo.setEdipi(pidin);
            } catch (Exception e) {
                logger.error("Error when getting ICN. Query Patient ID is EDIPI: {} msg: {}",pidin ,e.getMessage());
                if(logger.isDebugEnabled()){
                    logger.debug("Exception calling IdConversion details: ", e);
                }
                throw new RpcException("Could not convert EDIPI to ICN " + pidin + " msg: "+ e.getMessage());
            }
        } else if (pidin.length() == 17 && pidin.indexOf("V") > 0) { // ICN, Dan said checking one V is good enough
             icn = pidin;
             setDfn(pidin, icn, patientInfo);
        }
        patientInfo = mapPatientIcn(pidin, icn, patientInfo);
        if(patientInfo.getIcn() == null || patientInfo.getIcn().isEmpty() || patientInfo.getIcn().length() < 2){
            throw new RpcException("Could not get ICN for " + pidin);
        }
        patientInfo = setDfn(pidin, icn, patientInfo);
        return patientInfo;
    }

    private PatientInfo setDfn(String pidin, String icn, PatientInfo patientInfo) throws RpcException {
        if(patientInfo.getIen() == null || patientInfo.getIen().isEmpty()){
            String dfn = broker.runRpc("VAFCTFU CONVERT ICN TO DFN", icn);
            if (dfn.startsWith("-1")) {
                throw new RpcException("Requested patient " +pidin + " does not exist in VistA to get DFN.");
            } else if (dfn.equals(patientInfo.getIcn())) {
                logger.info("Patient was not known to 200, proceeding without ien, using " + dfn);
                patientInfo.setIen(dfn);
            } else {
                patientInfo.setIen(dfn);
            }
        }
        return patientInfo;
    }


    private void setVistaAccountInfo(NewRpcBroker broker)
    {
        try
        {
            String vistaQueryResult = broker.runRpc("XUS GET USER INFO");
            String pdata = vistaQueryResult.replace("^", ":");
            String[] sn = pdata.split("\n");
            if (sn.length > 4) {
                DicomService.getSiteInfo().setServiceAccountDuz(sn[0].trim());
                DicomService.getSiteInfo().setServiceAccountName(sn[1].trim());
            }
            String uduz = "@\"^VA(200," + DicomService.getSiteInfo().getServiceAccountDuz() + ",1)\"";
            String usrssn = broker.runRpc("XWB GET VARIABLE VALUE", VistaQuery.REFERENCE, uduz);
            String[] uinfo = usrssn.replace("^", ":").split(":");
            if (uinfo.length >= 8) {
                usrssn = uinfo[8];
                DicomService.getSiteInfo().setServiceAccountSsn(usrssn);
            }
            else {
                logger.error("XWB GET VARIABLE VALUE cannot get ssn {}", uinfo.length);
            }
        } catch (Exception e) {
            logger.error("VistA cannot get user information for {} rpc=XUS GET USER INFO msg: {}", DicomService.getScpConfig().getAccessCode().getValue(), e.getMessage());
            if(logger.isDebugEnabled()) logger.debug("User info failure details for service account ", e);
        }
    }

    private NewRpcBroker connectAndAuthWithVista() throws InvalidCredentialsException,
            MethodException, ConnectionFailedException
    {
        VistaAccessVerifyRealm realm = buildVistaRealm();
        String aCode = DicomService.getScpConfig().getAccessCode().getValue();
        String vCode = DicomService.getScpConfig().getVerifyCode().getValue();
        if (aCode == null || vCode == null) {
            logger.error("access code or verify code error! NULL! Check config file and encryptions!");
            return null;
        }

        if(!DicomService.getSiteInfo().getLocalSiteType().contains("CVIX")) realm.authenticate(aCode, vCode);
        NewRpcBroker broker = new NewRpcBroker();

        if (DicomService.getSiteInfo().getLocalSiteType().equals("VIX")) { // using MAG WINDOWS context
            broker.localConnectWithoutImagingMagWin(realm, principal);
        } else { // using CPRS context
            broker.localConnectWithoutImaging(realm, principal);
        }

        return broker;
    }

    private void refreshBse()
    {
        try {
            if (DicomService.getSiteInfo().getLocalSiteType().equals("VIX")) { // using MAG WINDOWS context
                bseToken = this.broker.getBrokerSecurityTokenWithImaging(DicomService.getSiteInfo().getBseRealm());
            } else { // using CPRS context
                bseToken = this.broker.getBrokerSecurityTokenWithoutImaging(DicomService.getSiteInfo().getBseRealm());
            }
            bseTokenInstant = Instant.now();
        } catch (MethodException e) {
            logger.error("DICOM SCP unable to refresh BSE token with local vista. Generic failure: {}", e.getMessage());
        }
    }

    private VistaAccessVerifyRealm buildVistaRealm()
    {
        VistaAccessVerifyRealm realm = new VistaAccessVerifyRealm();
        realm.setSiteNumber(DicomService.getSiteInfo().getSiteCode());
        realm.setSiteAbbreviation(DicomService.getSiteInfo().getSiteAbb());
        realm.setSiteName(DicomService.getSiteInfo().getSiteName());
        realm.setVistaServer(DicomService.getSiteInfo().getVistaHostName());
        realm.setVistaPort(DicomService.getSiteInfo().getVistaPort());
        realm.setBseRealm(DicomService.getSiteInfo().getBseRealm());
        return realm;
    }

    public static ClientPrincipal getPrincipal() {
        return principal;
    }

    private void setup() throws InvalidCredentialsException, MethodException, ConnectionFailedException,
            CannotLoadConfigurationException
    {
        if(!isSetup){
            ClientPrincipal setupPrincipal = setupClientPrincipal();
            VistaAccessVerifyRealm realm = buildVistaRealm();
            NewRpcBroker broker = new NewRpcBroker();
            if (DicomService.getSiteInfo().getLocalSiteType().equals("VIX")) { // using MAG WINDOWS context
                realm.authenticate(DicomService.getScpConfig().getAccessCode().getValue(),
                        DicomService.getScpConfig().getVerifyCode().getValue());
                broker.localConnectWithoutImagingMagWin(realm, setupPrincipal);
            } else { // using CPRS context
                broker.localConnectWithoutImaging(realm, setupPrincipal);
            }
            setVistaAccountInfo(broker);
            principal = buildClientPrincipal();
            isSetup = true;
        }
    }

    private ClientPrincipal setupClientPrincipal()
    {//gotta use dummy site info because we don't have the duz until we connect to vista, but we need a duz to build this thing to connect to other vistas...
        List<String> testRoles = new ArrayList<>();
        testRoles.add("clinical-display-user");
        testRoles.add("vista-user");
        testRoles.add("peer-vixs");
        String aCode = DicomService.getScpConfig().getAccessCode().getValue();
        String vCode = DicomService.getScpConfig().getVerifyCode().getValue();
        String strAE = DicomService.getScpConfig().getCalledAETitle();
        return new ClientPrincipal(DicomService.getSiteInfo().getBseRealm(), false,
                VistaRealmPrincipal.AuthenticationCredentialsType.Password, aCode, vCode, "126", strAE,
                "911111126", DicomService.getSiteInfo().getBseRealm(), DicomService.getSiteInfo().getSiteName(),
                testRoles, null);
    }

    private ClientPrincipal buildClientPrincipal()
    {
        List<String> testRoles = new ArrayList<>();
        testRoles.add("clinical-display-user");
        testRoles.add("vista-user");
        testRoles.add("peer-vixs");
        String aCode = DicomService.getScpConfig().getAccessCode().getValue();
        String vCode = DicomService.getScpConfig().getVerifyCode().getValue();
        String strAE = DicomService.getScpConfig().getCalledAETitle();
        return new ClientPrincipal(DicomService.getSiteInfo().getBseRealm(), false,
                VistaRealmPrincipal.AuthenticationCredentialsType.Password, aCode, vCode,
                DicomService.getSiteInfo().getServiceAccountDuz(), strAE,
                DicomService.getSiteInfo().getServiceAccountSsn(), DicomService.getSiteInfo().getBseRealm(),
                DicomService.getSiteInfo().getSiteName(),
                testRoles, null);
    }
    
    public static String getStudyInfo(String Ien) throws RpcException
    {
        if (Ien == null || Ien.length() == 0) return "";
        else {
            try {
                LocalVistaDataSource localVistaDataSource = new LocalVistaDataSource();
                return localVistaDataSource.getStudyInfoFromVista(Ien);
            } catch (Exception e) {
                if(logger.isDebugEnabled())
                    logger.warn("Query Study/Image with IEN: {}  Did not get result. {}", Ien, e.getMessage());
                throw new RpcException("Did not get Study from VistA for Ien " + Ien);
            }
        }
    }

   // public static String getImageFilePath(ImageURN imageURN){
        //VistaConnection vistaConnection =
    //}
    
    private String getStudyInfoFromVista(String Ien) throws RpcException
    {
        String ret = broker.runRpc("MAG IMAGE CURRENT INFO", Ien); // only works on VIX, local Vista
        if(logger.isDebugEnabled()) {
        	String msg = "getStudyInfoFromVista: Query Study/Image with IEN: " + Ien + "  ret= "+ret.substring(0, ret.indexOf("\n")).trim();
        	if (ret.indexOf("0008,0050^")>0) {
        		msg += " AN= "+ret.substring(ret.indexOf("0008,0050^")+10, ret.indexOf("\n", ret.indexOf("0008,0050^"))).trim();
        	}
        	if (ret.indexOf("0010,1000^")>0) {
        		msg += " ICN= "+ret.substring(ret.indexOf("0010,1000^")+10, ret.indexOf("\n", ret.indexOf("0010,1000^"))).trim();
        	}
        	logger.debug(msg);
        }
        return ret;
    }


    private List<String> getTflFromVista(String patientId) throws RpcException
    {
        if(DicomService.getSiteInfo().getLocalSiteType().equals("VIX")){
            return getTflForVix(patientId);
        }else if(DicomService.getSiteInfo().getLocalSiteType().equals("CVIX")){
            return getTflForCvix(patientId);
        }
        return new ArrayList<>();
    }

    private List<String> getTflForVix(String patientId) throws RpcException
    {
        return getOrTfl(patientId);
    }

    private List<String> getTflForCvix(String patientId) throws RpcException
    {
        if(patientId.contains("V")){
            return getOrTfl(patientId); //only OR RPC can handle ICNs, won't return 200CRNR
        }
        List<String> ret = getVaTfl(patientId); //only get 200CRNR from VACFTCU TFL RPC
        if(ret.size() == 0 || ret.get(0).equals("-1")){
            return getOrTfl(patientId); //can't get it here might get it from LVS
        }
        return ret;
    }

    private List<String> getVaTfl(String patientId) throws RpcException
    {
        List<String> siteCodes = new ArrayList<>();
        String facList = broker.runRpc("VAFCTFU GET TREATING LIST", patientId);
        String[] facArray = facList. split(Pattern.quote("^"));
        Pattern pattern = Pattern.compile("\\d");
        for(int i = 0; i < facArray.length; i+=4){
            Matcher matcher = pattern.matcher(facArray[i]);
            if(matcher.find()) {
                String siteCode = facArray[i].substring(facArray[i].indexOf(matcher.group(0)));
                siteCodes.add(siteCode);
            }
        }
        return siteCodes;
    }

    private List<String> getOrTfl(String patientId) throws RpcException
    {
        String facList = broker.runRpc("ORWCIRN FACLIST", patientId);
        if(logger.isDebugEnabled()){
            logger.debug("VistA RPC=ORWCIRN FACLIST. Result={}", facList);
        }
        String[] facs = facList.split(System.getProperty("line.separator"));
        List<String> ret = new ArrayList<>();
        for (String fac : facs) {
            String parsedFacSiteCode = fac.substring(0, fac.indexOf("^")).trim();
            if (parsedFacSiteCode.length() < 3)
                continue;
            ret.add(parsedFacSiteCode);
        }
        ret.add(DicomService.getSiteInfo().getSiteCode());
        return ret;
    }
}
