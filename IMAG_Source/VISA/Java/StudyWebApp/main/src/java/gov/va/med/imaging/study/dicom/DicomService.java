/**
 *
 Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 Date Created: Mar 25, 2021
 Site Name:  Washington OI Field Office, Silver Spring, MD
 Developer:  VHAISWJIANGS
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
package gov.va.med.imaging.study.dicom;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.StudyURNFactory;
import gov.va.med.URNFactory;
import gov.va.med.imaging.BaseWebFacadeRouter;
import gov.va.med.imaging.GUID;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.conversion.IdConversion;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.exchange.configuration.AppConfiguration;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.ScpConfiguration;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.study.StudyFacadeContext;
import gov.va.med.imaging.study.StudyFacadeRouter;
import gov.va.med.imaging.study.dicom.cache.ImageCacheTask;
import gov.va.med.imaging.study.dicom.query.PatientCFind;
import gov.va.med.imaging.study.dicom.query.StudyQuery;
import gov.va.med.imaging.study.dicom.remote.HttpsUtil;
import gov.va.med.imaging.study.dicom.remote.NetworkFetchManager;
import gov.va.med.imaging.study.dicom.remote.image.LocalImage;
import gov.va.med.imaging.study.dicom.util.ProcessWrapper;
import gov.va.med.imaging.study.dicom.vista.LocalVistaDataSource;
import gov.va.med.imaging.study.dicom.vista.PatientInfo;
import gov.va.med.imaging.study.dicom.vista.RemoteVistaDataSource;
import gov.va.med.imaging.study.rest.translator.RestStudyTranslator;
import gov.va.med.imaging.study.rest.types.StudyImageType;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.ConnectionFailedException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.transactioncontext.ClientPrincipal;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.logging.Logger;
import lia.util.net.copy.FDT;

import javax.xml.bind.DatatypeConverter;
import java.io.File;
import java.net.InetAddress;
import java.security.MessageDigest;
import java.util.*;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;


public class DicomService
{

	private final static Logger logger = Logger.getLogger(DicomService.class);
	private static final String BSE_APP_NAME = "VISTA IMAGING VIX";
	private static final AppConfiguration appConfig = new AppConfiguration();
	private static final SiteInfo siteInfo = new SiteInfo();
	private static ScpConfiguration scpConfiguration;
	private static Thread fdtListener = null;

	static {
		getAppConfig().loadAppConfigurationFromFile();
		siteInfo.setVersionNumber(getAppConfig().getVixSoftwareVersion());
		if ( getAppConfig().getLocalSiteNumber().startsWith("200")) siteInfo.setSiteCode("200");
		else siteInfo.setSiteCode( getAppConfig().getLocalSiteNumber());
		if(siteInfo.getSiteCode().startsWith("200")) siteInfo.setLocalSiteType("CVIX");
		try {
			populateSiteInfo();
		}catch (Exception e){
            logger.error("DicomScp unable to populate site info, site service unavailable?{}", e.getMessage());
		}
		fdtListener = startFdtListener();
	}

	private static class FdtServerRunnable implements Runnable{

		@Override
		public void run() {
			String fdtPath = System.getenv("CATALINA_HOME") + File.separator + "lib" + File.separator + "fdt.jar";
			List<String> toWhiteList;
			try {
				toWhiteList = getVixIps();
			}catch (Exception e){
				logger.error("Unable to get list of IP Addresses for FDT to allow. FDT will not run.", e);
				return;
			}
			String[] command = {"java", "-jar", fdtPath, "-noupdates", "-p", String.valueOf(getScpConfig().getFdtPort()),
			"-f",String.join(":",toWhiteList)};
			try {
				logger.info("Starting FDT Listener Service with command [{}]",String.join(" ", command));
				FDT.main(command);
			} catch (Exception e) {
				logger.error("FDT Server process failed with msg [{}]", e.getMessage());
			}
		}
	}

	private static Thread startFdtListener() {
		FdtServerRunnable fdtServerRunnable = new FdtServerRunnable();
		Thread fdtThread = new Thread(fdtServerRunnable);
		fdtThread.start();
		return fdtThread;
	}

	public static ScpConfiguration getScpConfig() {
		if(scpConfiguration == null) scpConfiguration = ScpConfiguration.getConfiguration();
		if(scpConfiguration == null){
			logger.error("C:\\VixConfig\\ScpConfiguration.config is invalid");
		}
		return scpConfiguration;
	}

	public static String getImageKey(ImageURN imageURN){
		return imageURN.getOriginatingSiteId() + imageURN.getImageId();
	}

	public static RestStringType refresh() {
		logger.debug("refreshing scp config in DicomService.");

		scpConfiguration = null;
		FacadeConfigurationFactory.getConfigurationFactory().clearConfiguration(ScpConfiguration.class);
		new ScpConfiguration().refreshFromFile();
		scpConfiguration = ScpConfiguration.getConfiguration();
		String ret = "This site: " + getAppConfig().getLocalSiteNumber() + " ("+getSiteInfo().getSiteAbb()+
				"; " + getSiteInfo().getSiteName() + ")\n" + scpConfiguration.toString();
		if(logger.isDebugEnabled()) {
            logger.debug("refreshed new ScpConfigurations:\n{}", ret);
		}
		return new RestStringType(ret);
	}

	protected static AppConfiguration getAppConfig() {
		return appConfig;
	}

	public static SiteInfo getSiteInfo() {
		return siteInfo;
	}

	public static TransactionContext prepareTransactionContext(String transId)
			throws CannotLoadConfigurationException, InvalidCredentialsException,
			gov.va.med.imaging.tomcat.vistarealm.exceptions.MethodException, ConnectionFailedException {
		return prepareTransactionContext("", getScpConfig().getCalledAETitle(), transId);
	}

	public static TransactionContext prepareTransactionContext(String pacsIP, String strAe, String transId)
			throws InvalidCredentialsException, gov.va.med.imaging.tomcat.vistarealm.exceptions.MethodException,
			ConnectionFailedException, CannotLoadConfigurationException {
		TransactionContext transactionContext = prepareTransactionContext(pacsIP, strAe);
		transactionContext.setTransactionId(transId);
		return transactionContext;
	}

	public static TransactionContext prepareTransactionContext(String pacsIP, String strAe)
			throws InvalidCredentialsException, gov.va.med.imaging.tomcat.vistarealm.exceptions.MethodException,
			ConnectionFailedException, CannotLoadConfigurationException {
		//TODO: do we need these roles? do we need 2 versions of this, one for making requests to other sites and one for serving to clients?
		List<String> testRoles = new ArrayList<>();
		testRoles.add("clinical-display-user");
		testRoles.add("vista-user");
		testRoles.add("peer-vixs");
		ClientPrincipal principal = LocalVistaDataSource.getPrincipal();
		TransactionContext transactionContext = TransactionContextFactory.createClientTransactionContext(principal);

		//TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setStartTime(System.currentTimeMillis());
		transactionContext.setTransactionId((new GUID()).toLongString());
		transactionContext.setBrokerSecurityApplicationName(BSE_APP_NAME);
		transactionContext.setAccessCode(getScpConfig().getAccessCode().getValue());
		transactionContext.setVerifyCode(getScpConfig().getVerifyCode().getValue());
		transactionContext.setSsn(siteInfo.getServiceAccountSsn());
		transactionContext.setFullName(strAe);
		transactionContext.setSiteNumber(siteInfo.getSiteCode());
		transactionContext.setSiteName(siteInfo.getSiteName());
		transactionContext.setOriginatingAddress(pacsIP);
		transactionContext.setBrokerSecurityToken(LocalVistaDataSource.getBseToken());
		return transactionContext;
	}

	public static void vistaLog(long startMillis, String logIcn, String qType, String qSrc, int returnCnt, int rcvCnt,
								String quality, String callingIpAddr, boolean cached,String errMsg, String mods,
								String srcProto, String respCode, String urn, String loginMethod, 	String srcMethod,
								String srcSvrs, String transId, String srcSite)
	{
		String purpose = getSiteInfo().getLocalSiteType().equals("CVIX") ? "DoD" : "cPACS";
		try {
			TransactionContext transactionContext = TransactionContextFactory.get();
			transactionContext.setStartTime(startMillis);
			transactionContext.setPatientID(logIcn);
			transactionContext.setRequestType(qType);
			transactionContext.setSiteNumber(qSrc);
			transactionContext.setServicedSource(srcSite);
			transactionContext.setQueryFilter("n/a");
			transactionContext.setAsynchronousCommand(true);
			transactionContext.setEntriesReturned(returnCnt);
			transactionContext.setDataSourceEntriesReturned(rcvCnt);
			transactionContext.setQuality(quality);
			transactionContext.setCommandClassName("DicomService");
			transactionContext.setOriginatingAddress(callingIpAddr);
			transactionContext.setFullName(getSiteInfo().getServiceAccountName());
			transactionContext.setSecurityTokenApplicationName(BSE_APP_NAME);
			transactionContext.setItemCached(cached);
			transactionContext.setErrorMessage(errMsg);
			transactionContext.setModality(mods);
			transactionContext.setPurposeOfUse(purpose);
			transactionContext.setDatasourceProtocol(srcProto);
			transactionContext.setResponseCode(respCode);
			transactionContext.setUrn(urn);
			transactionContext.setTransactionId(transId);
			transactionContext.setVixSoftwareVersion(getSiteInfo().getVersionNumber());
			transactionContext.setLoginMethod(loginMethod);
			transactionContext.setDataSourceMethod(srcMethod);
			transactionContext.setDataSourceResponseServer(srcSvrs);
			transactionContext.setVixSiteNumber(getSiteInfo().getSiteCode());
			transactionContext.setRequestingVixSiteNumber("");

			try {
				BaseWebFacadeRouter logrouter = FacadeRouterUtility.getFacadeRouter(BaseWebFacadeRouter.class);
				logrouter.postTransactionLogEntryImmediate(new TransactionContextLogEntrySnapshot(transactionContext));
			} catch (Exception xAny) {
                logger.error("postTransactionLogEntryImmediate Failed: {}", xAny.getMessage(), xAny);
				// don't throw the exception so the client doesn't see it, this transaction will
				// just be dropped
				// throw new ServletException(xAny);
			}
		} catch (Exception e) {
            logger.error("VistaLog exception: {}", e.getMessage());
		}
	}

	public static RestStringType cacheLocalStudy(String studyId, String callingAe, String callingIp, String icn){
		RestStringType restStringType = new RestStringType();
		logger.info("Processing precache request for [{}] from [{}] [{}]", studyId, callingAe, callingIp);
		try {
			StudyURN studyURN = URNFactory.create(studyId);
			if(!studyURN.getOriginatingSiteId().equals(getSiteInfo().getSiteCode())){
				restStringType.setValue("ERROR: Site " + studyURN.getOriginatingSiteId() + " is not this site " + getSiteInfo().getSiteCode());
				return restStringType;
			}
			Study study = null;
			if (getSiteInfo().getLocalSiteType().contains("CVIX")){
				StudyURN studyUrn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
				StudyFacadeRouter router = StudyFacadeContext.getStudyFacadeRouter();
				StudyFilter newStudyFilter = new StudyFilter(studyUrn);
				study = router.getStudy(studyURN, newStudyFilter);
			}else{
				RemoteVistaDataSource remoteVistaDataSource = new RemoteVistaDataSource(studyURN.getOriginatingSiteId(),
						callingAe, callingIp);
				study = remoteVistaDataSource.getStudyByUrn(studyURN);
			}

			Map<String, Image> imageMap = StudyQuery.getImageMapFromStudy(study);
			Set<String> dirPaths = new LinkedHashSet<>();
			List<Future<String>> futures = new ArrayList<>();
			for(Image image : imageMap.values()){
				LocalImage localImage = buildLocalImageFetchDto(image, icn, callingAe, callingIp);
				futures.add(NetworkFetchManager.requestLocalImage(localImage));
			}
			dirPaths.add("Success");
			for(Future<String> future : futures){
				String filePath = future.get(60, TimeUnit.SECONDS);
				File cacheFile = new File(filePath);
				dirPaths.add(cacheFile.getParent());
			}

			dirPaths.add(InetAddress.getLocalHost().getHostAddress());
			dirPaths.add(String.valueOf(DicomService.getScpConfig().getFdtPort()));
			restStringType.setValue(dirPaths.stream().map(Object::toString).collect(Collectors.joining("|")));
		}catch (Exception e){
			logger.error("Problem local study cache processing ", e);
			restStringType.setValue("ERROR: Problem with local cache task for " + studyId + " msg: " + e.getMessage());
		}
		return restStringType;
	}

	public static LocalImage buildLocalImageFetchDto(Image image, String icn, String callingAe, String callingIp)
			throws ImagingDicomException, URNFormatException {
		StudyImageType imageType = RestStudyTranslator.translate(image);
		String imageUri = imageType.getDiagnosticImageUri();
		ImageURN imageURN = URNFactory.create(imageUri.substring(imageUri.indexOf("=")+1, imageUri.indexOf("&")));
		ImageCacheTask imageCacheTask = new ImageCacheTask(imageURN, icn);
		return new LocalImage(image, imageUri, imageURN, imageCacheTask, callingAe, callingIp);
	}

	public static Site getSiteByCode(String remoteSiteNumber) throws MethodException, ConnectionException {
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		List<Region> regions = router.getRegionList();
		regions.sort(new RegionComparator());
		for (Region region : regions) {
			for (Site site : region.getSites()) {
				if (site.getSiteNumber().equals(remoteSiteNumber)) {
					return site;
				}
			}
		}
		return null;
	}

	public static String getSeriesMetaFileName(String studyUrnString, String icn) throws URNFormatException {
		StudyURN studyURN = StudyURNFactory.create(studyUrnString);
		return getCacheFilePath(studyURN, icn) + "LoadedStudy.xml";
	}

	public static String getCacheFilePath(StudyURN studyURN, String patientIcn){
		return System.getenv("vixcache") + File.separator + "scp-region" +File.separator +
				studyURN.getOriginatingSiteId() + File.separator +"icn(" +	patientIcn + ")" +File.separator
				+studyURN.getStudyId() +File.separator;
	}

	public static String getHashString(String instring) {
		return getHashString(instring, "SHA-1");
	}

	public static String getHashString(String instring, String method) {
		String imethod = "SHA-1"; // default
		if (method != null && method.length() > 0) {
			imethod = method;
		}
		String ret = instring;
		try {
			MessageDigest md = MessageDigest.getInstance(imethod);
			md.update(instring.getBytes());
			byte[] digest = md.digest();
			ret = DatatypeConverter.printHexBinary(digest).toUpperCase();
		} catch (Exception e) {
            logger.error("Cannot hash string {} using {}. Exception: {}", instring, imethod, e.getMessage());
		}
		return ret;
	}

	public static String getStudyInfo(String Ien) {
		// only works on VIX
		String ret;
		try {
			ret = LocalVistaDataSource.getStudyInfo(Ien);
		} catch (Exception e) {
			ret = "Cannot get StudyInfo for IEN " + Ien + " e=" + e.getMessage();
		}
		return ret;
	}

	public static String getStudyAccessionNumber(String Ien) {
		// only works on VIX
		String accnum = "";
		try {
			String studyInfo = LocalVistaDataSource.getStudyInfo(Ien);
			int idx = studyInfo.indexOf("0008,0050^");
			if ( idx > 0) {
				accnum = studyInfo.substring(idx+10, studyInfo.indexOf("\n", idx)).trim();
			}
		} catch (Exception e) {
			accnum = "Cannot get StudyAccessionNumber for IEN " + Ien + " e=" + e.getMessage();
		}
		return accnum;
	}

	public static String getStudyIcn(String Ien) {
		// only works on VIX
		String icn = "";
		try {
			String studyInfo = LocalVistaDataSource.getStudyInfo(Ien);
			int idx = studyInfo.indexOf("0010,1000^");
			if (idx > 0) {
				icn = studyInfo.substring(idx + 10, studyInfo.indexOf("\n", idx)).trim();
			}
		} catch (Exception e) {
			icn = "Cannot get StudyIcn for IEN " + Ien + " e=" + e.getMessage();
		}
		return icn;
	}

    public static void preCacheWithFdt(String studyId, String callingAe, String callingIp, String icn, String remoteSiteId) {
		if(remoteSiteId.equals(getSiteInfo().getSiteCode())) return; // do not precache with fdt for local studies
		logger.info("Attempting Pre Cache With FDT for [{}] ", studyId);
		List<String> results = HttpsUtil.getCacheDirs(remoteSiteId,icn,callingAe,callingIp,studyId);

		if(results == null || results.size() < 1 || !results.get(0).equalsIgnoreCase("Success")){
			String msg = results == null || results.size() < 1 ? "No message" : results.get(0);
			logger.warn("Could not precache with FDT for [{}] error [{}]", studyId, msg);
			return;
		}
		logger.info("FDT Pre Cache result is [{}]", String.join("| ",results));
		results.remove(0);//Remove success message
		int remoteFdtPort = Integer.parseInt(results.get(results.size()-1));
		results.remove(results.size()-1);
		String remoteIp = results.get(results.size()-1);
		results.remove(results.size()-1);
		String envVc = System.getenv("vixcache");

		String parentDir = envVc + File.separator + "scp-region" +File.separator +
				remoteSiteId + File.separator +"icn(" +	icn + ")" +File.separator;
		logger.info("Requesting FDT push to [{}]", parentDir);
		requestFdtDirs(remoteIp,results,parentDir,remoteFdtPort);
    }

	private static void requestFdtDirs(String remoteHost, List<String> remoteDirs, String localDir, int remoteFdtPort){
		String fdtPath = System.getenv("CATALINA_HOME") + File.separator + "lib" + File.separator + "fdt-0.24.jar";
		String[] command = { "java", "-jar", fdtPath, "-c", remoteHost, "-noupdates",
				"-P", "16", "-p", String.valueOf(remoteFdtPort), "-r", "-d", localDir, "-pull" };
		List<String> commandStrings = new ArrayList<>(Arrays.asList(command));
		commandStrings.addAll(remoteDirs);
		logger.info("FDT Command is [{}]", String.join(" ", commandStrings));
		ProcessWrapper wrapper = new ProcessWrapper(commandStrings.toArray(new String[0]),false,true);
		wrapper.start();
		int secondsToWait = Integer.parseInt(getScpConfig().getImageFetchTimeLimit());
		int secondsCounter = 0;
		while(wrapper.isRunning() || secondsCounter > secondsToWait){
			try {
				Thread.sleep(1000);
				secondsCounter++;
			} catch (InterruptedException e) {
				logger.warn("Did not finish waiting for FDT client msg [{}]", e.getMessage());
			}
		}
	}

	private static List<String> getVixIps() throws MethodException, ConnectionException {
		List<String> ips = new ArrayList<>();
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		List<Region> regions = router.getRegionList();
		for (Region region : regions) {
			for (Site site : region.getSites()) {
				for (SiteConnection siteConnection : site.getSiteConnections().values()) {
					if (siteConnection.getProtocol().equals("VIX") && !siteConnection.getServer().contains("localhost")) {
						try{
							String ip = String.valueOf(InetAddress.getByName(siteConnection.getServer()).getHostAddress()).replace("/","");
							ips.add(ip);
						}catch (Exception e){
							logger.error("Failed to resolve hostname [{}], msg [{}]",siteConnection.getServer(), e.getMessage());
						}
					}
				}
			}
		}
		return ips;
	}

	public static void shutDownFdt() {
		if(fdtListener != null){
			try{
				fdtListener.interrupt();
			}catch (Exception e){
				logger.error("Failed to interrupt fdt thread msg [{}]",e.getMessage());
			}
		}
	}

	enum STUDYCALLS {
		WHOLE, ACCNUM, ICN
	}

	public static String getRemoteAccessionNumber(String site, String ien) {
		return getRemoteStudyInfo(site, ien, STUDYCALLS.ACCNUM);
	}
	
	public static String getRemoteIcn(String site, String ien) {
		return getRemoteStudyInfo(site, ien, STUDYCALLS.ICN);
	}
	
	public static String getRemoteStudyInfo(String site, String ien) {
		return getRemoteStudyInfo(site, ien, STUDYCALLS.WHOLE);
	}
	
	public static String getRemoteStudyInfo(String site, String Ien, STUDYCALLS studyCallType) {
		// only can call on VIX
		String ret;
		// local VIX
		if (siteInfo.getSiteCode().equals(site)) { 
			switch (studyCallType) {
			case ACCNUM:
				ret = getStudyAccessionNumber(Ien);
				if(logger.isDebugEnabled())
                    logger.debug("getRemoteStudyInfo: local site {} accessionNumber for IEN {} = {}", site, Ien, ret);
				break;
			case ICN:
				ret = getStudyIcn(Ien);
				if(logger.isDebugEnabled())
                    logger.debug("getRemoteStudyInfo: local site {} ICN for IEN {} = {}", site, Ien, ret);
				break;
			default :
				ret = getStudyInfo(Ien);
				if(logger.isDebugEnabled())
                    logger.debug("getRemoteStudyInfo: local site {} dicomTags for IEN {} = {}", site, Ien, ret);
			}
            return ret;
		}
		// remote VIX
		String urlPath = null;
		switch (studyCallType) {
		case ACCNUM:
			urlPath = "/Study/token/restservices/study/accnum/";
			break;
		case ICN:
			urlPath = "/Study/token/restservices/study/icn/";
			break;
		default :
		    urlPath = "/Study/token/restservices/study/dicom/";
		}

		String remoteVixHost= getRemoteVixHost(site);
		if (remoteVixHost == null || remoteVixHost.length() < 1) { 
			return "Cannot get dicom tags from site "+site + ". Please check the site number.";
		}
		String siteUrl = "https://" + remoteVixHost + urlPath + Ien + "?securityToken=" +HttpsUtil.getToken();
		if(logger.isDebugEnabled()){
            logger.debug("getRemoteStudyInfo: remote VIX URL for {} = {}", site, siteUrl);
		}

		try {
			ret = HttpsUtil.getStringResultFromUrl(siteUrl);
			ret = ret.substring(ret.indexOf("<value>")+7, ret.indexOf("</value>")).replace("&#xD;", "");
			//ret = java.net.URLDecoder.decode(ret, "UTF_8");
			if(logger.isDebugEnabled())
                logger.debug("getRemoteStudyInfo: remote site {} {} for IEN {} = {}", site, (studyCallType == STUDYCALLS.WHOLE) ? "dicom tags" : studyCallType, Ien, (ret.length() > 100) ? ret.substring(0, 100) + "..." : ret);
		} catch (Exception e) {
			ret = "Cannot get dicom tags from site " + site + " for IEN " + Ien + " e=" + e.getMessage();
		}
		return ret;
	}

	public RestStringType getPatientTFL(PatientCFind query) throws ImagingDicomException, MethodException, ConnectionException{
		return convertPatientInfoToRestString(getPatientTFL(query, true));
	}

	private RestStringType convertPatientInfoToRestString(PatientInfo patientInfo) throws MethodException, ConnectionException {
		if (patientInfo.getMtfList() == null){
			return new RestStringType("");
		}
		StringBuilder temp = new StringBuilder();
		int idx = 0;
		for (String siteId : patientInfo.getMtfList()) {
			Site site = getSiteByCode(siteId);
			if (site != null) {
				temp.append("\n site_")
						.append(idx++)
						.append(": ")
						.append(siteId).append("/")
						.append(site.getSiteAbbr())
						.append("/")
						.append(site.getSiteName())
						.append(" VISN ")
						.append(site.getRegionId());
			}
		}
		return new RestStringType(patientInfo.toString() + temp.toString());
	}

	public PatientInfo getPatientTFL(PatientCFind query, boolean reqEdipi) throws ImagingDicomException, MethodException, ConnectionException {// for additional functionality: an undocumented study service can get a Treatment Facility List for a patient
		String patientId = query.getQueriedPatientId();
		logger.info("***===patTFL for patientId={}", patientId);

		PatientInfo patientInfo = LocalVistaDataSource.getPatientInfo(query.getQueriedPatientId(), query.getTransactionGuid(), query.getStudyFilterTerm());
		List<String> siteIds = patientInfo.getMtfList();

		if (siteIds == null) {
            logger.error("***===patTFL does not get remote VIX site list from VistA for {}", patientId);
			return patientInfo;
		}

		try {
			if ((patientInfo.getEdipi() == null || patientInfo.getEdipi().length() < 10) && reqEdipi) {
				if(logger.isDebugEnabled()){
					logger.debug("No EDIPI in Patient Info from Vista. Trying to get one...Query Patient ID is {} " +
							"ICN={} getting EDIPI.", patientId, patientInfo.getIcn());
				}
				patientInfo.setEdipi(IdConversion.toEdipiByIcn(patientInfo.getIcn()));
				logger.info("Query Patient ID is {} ICN={} got EDIPI={}", patientId, patientInfo.getIcn(),
						patientInfo.getEdipi());
			}
		} catch (Exception exp) {
			// it maybe okay not able to get EDIPI
			if(logger.isDebugEnabled())
				logger.debug("Did not get EDIPI for patient {}. exception={}", patientId, exp.getMessage());
		}

		logger.info("***===patTFL returning {}", patientInfo);
		return patientInfo;
	}

	public RestStringType resetCache(PatientCFind query) throws ImagingDicomException {
		String patientId = query.getQueriedPatientId();
		RestStringType ret = new RestStringType("Reset cache done for "+patientId);
        logger.info("resetCache called for patientId={}", patientId);
		NetworkFetchManager.clearCache();
		String cacheDir = "C:" + File.separator + "VixCache" + File.separator; // should come from config
		if (System.getenv("vixcache") != null && System.getenv("vixcache").length() > 0) {
			cacheDir = System.getenv("vixcache").replace("/", File.separator)+ File.separator;
		} else {
			cacheDir = getScpConfig().getCachedir() + File.separator;
		}

		Set<String> siteIds = null;
		if(patientId.equalsIgnoreCase("ALL")){
			boolean dodImgrt = deleteAll(new File(cacheDir + "scp-region"), false);
			if(logger.isDebugEnabled()){
                logger.debug("deleting ALL={}", dodImgrt);
			}
			return new RestStringType("Reset cache done for "+patientId + " scp-region="+ dodImgrt);
		}
		patientId = patientId.trim().replace("^", "-").replaceAll("-", "").replaceAll(" ", "");
		PatientInfo patInfo = LocalVistaDataSource.getPatientInfo(query.getQueriedPatientId(),query.getTransactionGuid(), query.getStudyFilterTerm());
		String patientIcn = patInfo.getIcn();
		siteIds = new HashSet<>(patInfo.getMtfList());

		if (siteIds.size() > 0) {
			// study metadata
			for(String siteId : siteIds) {
				if (siteId.length()>=3 && !siteId.startsWith("200")) {
					String vastudydir = cacheDir + "scp-region"+ File.separator + siteId;
					boolean r = deleteAll(new File(vastudydir), true); // this also deletes all series metadata
					if(logger.isDebugEnabled()){
                        logger.debug("deleting study metadata for {} at {} result done={}", patientId, vastudydir, r);
					}
				}
			}
			String dodstudydir = cacheDir + "scp-region" + File.separator + "200"
					+ File.separator + "icn("+patientIcn+")";
			boolean rt = deleteAll(new File(dodstudydir), true);
			if(logger.isDebugEnabled())
                logger.debug("deleting study metadata for {} at {} result done={}", patientId, dodstudydir, rt);
			if(patInfo.getEdipi() == null) {
				try {
					patInfo.setEdipi(IdConversion.toEdipiByIcn(patInfo.getIcn()));
				} catch (Exception e) {
                    logger.error("Failed to get EDIPI in cache reset for patient {} msg {}", patInfo.getIcn(), e.getMessage());
					if(logger.isDebugEnabled()) logger.debug("reset EDIPI failure details ", e);
				}
			}

			// dod series metadata
			if (patInfo.getEdipi() != null) {
				String dodsrsdir = cacheDir + "scp-region" + File.separator + "200" + File.separator
						+ patInfo.getEdipi(); // edipi
				rt = deleteAll(new File(dodsrsdir), true);
				if(logger.isDebugEnabled())
                    logger.debug("deleting DOD series metadata for {} at {} result done={}", patientId, dodsrsdir, rt);
			}

			// images
			String vaimagedir = cacheDir + "scp-region";
			for(String siteId : siteIds) {
				if (!siteId.startsWith("200")) {
					File vstdm = new File(vaimagedir + File.separator + (siteId) + File.separator + "icn(" + patientIcn + ")");
					boolean r = deleteAll(vstdm, true); // this deletes all images in all series
					if(logger.isDebugEnabled())
                        logger.debug("deleting instances for {} at {} result done={}", patientId, vstdm, r);
				}
			}

			String dodimagedir = cacheDir + "scp-region" + File.separator + "200";
			if (patInfo.getEdipi() != null) {
				dodimagedir += File.separator + patInfo.getEdipi(); // edipi
			}
			rt = deleteAll(new File(dodimagedir), true);
			if(logger.isDebugEnabled())
                logger.debug("deleting instances for {} at {} result done={}", patientId, dodimagedir, rt);
		} else {
			String vastudydir = cacheDir + "scp-region";
			boolean r = deleteAll(new File(vastudydir), false);
			if(logger.isDebugEnabled())
                logger.debug("deleting study metadata for all VA patients. {}{}* result={}", vastudydir, File.separator, r);

			String dodstudydir = cacheDir + "scp-region" + File.separator + "200";
			r = deleteAll(new File(dodstudydir), false);
			if(logger.isDebugEnabled())
                logger.debug("deleting study metadata for all DOD patients. {}{}* result={}", dodstudydir, File.separator, r);

			String vaimagedir = cacheDir + "scp-region";
			r = deleteAll(new File(vaimagedir), false);
			if(logger.isDebugEnabled())
                logger.debug("deleting study image data for all VA patients. {}{}* result={}", vaimagedir, File.separator, r);

			String dodimagedir = cacheDir + "scp-region" + File.separator + "200";
			r = deleteAll(new File(dodimagedir), false);
			if(logger.isDebugEnabled())
                logger.debug("deleting study image data for all DOD patients. {}{}* result={}", dodimagedir, File.separator, r);
		}
		return ret;
	}

	private boolean deleteAll(File directoryToBeDeleted, boolean delthis) {
		File[] allContents = directoryToBeDeleted.listFiles();
		boolean ret = true;
		if (allContents != null) {
			for (File file : allContents) {
				ret = ret && deleteAll(file, true);
			}
		}
		if (delthis)
			return directoryToBeDeleted.delete();
		else
			return ret;
	}

	private static void populateSiteInfo() throws MethodException, ConnectionException {
		String siteNumber = appConfig.getLocalSiteNumber();
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		List<Region> regions = router.getRegionList();
		regions.sort(new RegionComparator());
		for (Region region : regions) {
			for (Site site : region.getSites()) {
				if (site.getSiteNumber().equals(siteNumber)) {
					siteInfo.setSiteAbb(site.getSiteAbbr().trim());
					siteInfo.setSiteName(site.getSiteName().trim());
					siteInfo.setVistaHostName(site.getVistaServer().trim());
					siteInfo.setVistaPort(site.getVistaPort());
					siteInfo.setRegion(region);
					String bseRealm = site.getSiteNumber();
					if (bseRealm.length() > 3) {
						if(logger.isDebugEnabled())
                            logger.debug("buildAndStartVistaRealm: bseRealm changed from {} to {}", bseRealm, bseRealm.substring(0, 3));
						bseRealm = bseRealm.substring(0, 3);
					}
					siteInfo.setBseRealm(bseRealm);
				}
			}
		}
	}

	public static String getRemoteVixHost(String remoteSiteNumber){
		try {
			if(remoteSiteNumber.equals("200")){
				remoteSiteNumber = "2001"; //200 is localhost in silver, gold, prod siteservice
			}
			SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
			List<Region> regions = router.getRegionList();
			regions.sort(new RegionComparator());
			for (Region region : regions) {
				for (Site site : region.getSites()) {
					if (site.getSiteNumber().equals(remoteSiteNumber)) {
						for (SiteConnection siteConnection : site.getSiteConnections().values()) {
							if (siteConnection.getProtocol().equals("VIX")) return siteConnection.getServer();
						}
					}
				}
			}
		}catch(MethodException | ConnectionException e){
            logger.error("unable to get remote site hostname, falling back to localhost ImageWebApp. Ex is {}", e.getMessage());
		}
		return "";
	}
}