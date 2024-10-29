/**
 *
 Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 Date Created: Mar 29, 2021
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
package gov.va.med.imaging.facade.configuration;

import gov.va.med.imaging.configuration.RefreshableConfig;
import gov.va.med.imaging.configuration.VixConfiguration;
import gov.va.med.imaging.encryption.AesEncryption;
import gov.va.med.logging.Logger;

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ScpConfiguration
		extends AbstractBaseFacadeConfiguration
		implements RefreshableConfig {
	private EncryptedConfigurationPropertyString accessCode;
	private EncryptedConfigurationPropertyString verifyCode;
	private String studytype; //remove in p348
	private String siteFetchTPoolMax;
	private String siteFetchTimeLimit;
	private String imageFetchTPoolMax;
	private String imageFetchTimeLimit;
	private boolean useRemoteImageFetch = true;
	private boolean useDirectFetch = true;
	private String cacheLifespan; //sp
	private String preFetchSeries;
	private String calledAETitle;
	private boolean remotePatientResolution = false;
	private String imageQueueSize = "10000";
	private int cacheMetaHoursToLive = 24;
	private boolean isFdtEnabled = true;
	private int fdtPort = 2762;
	private static final Logger LOGGER = Logger.getLogger(ScpConfiguration.class);

	private List<ScpCallingAE> callingAEConfigs;

	public ScpConfiguration() {
		super();
	}

	public EncryptedConfigurationPropertyString getAccessCode() {
		return accessCode;
	}

	public void setAccessCode(EncryptedConfigurationPropertyString accessCode) {
		this.accessCode = accessCode;
	}

	public EncryptedConfigurationPropertyString getVerifyCode() {
		return verifyCode;
	}

	public void setVerifyCode(EncryptedConfigurationPropertyString verifyCode) {
		this.verifyCode = verifyCode;
	}

	public String getAccessCodeLegacySupport() {
		try {
			return AesEncryption.decrypt(accessCode.getValue());
		} catch (Exception ex) {
            LOGGER.error("Cannot decrypt access code from ScpConfiguration.config file: {}", ex.getMessage());
			return null;
		}
	}

	public String getVerifyCodeLegacySupport() {
		try {
			return AesEncryption.decrypt(verifyCode.getValue());
		} catch (Exception ex) {
            LOGGER.error("Cannot decrypt verify code from ScpConfiguration.config file: {}", ex.getMessage());
			return null;
		}
	}

	public String getCachedir() {
        String ret = System.getenv("vixcache");
        if (ret != null && ret.length() > 0) {
        	ret = ret.replace("/", File.separator);
            LOGGER.debug("getCachedir got cache path from environment var: {}", ret);
        }
        else {
    		File[] vixServerDrives = File.listRoots();
		    for (File drive : vixServerDrives) {
			    String path = drive.getPath() + "VixCache";
                LOGGER.debug("getCachedir checking path {}", path);
	    		File vixCache = new File(path);
		    	if (vixCache.exists() && vixCache.isDirectory()) {
			    	ret = path;
                    LOGGER.debug("getCachedir got cache path by searching the drives: {}", path);
	    		    //System.out.println("VixCache is at: " + drive);
		    		break;
			    }
		    }
			if (ret == null)
				ret = "C:"+File.separator+"VixCache"; // it may not exist, but the default fallback value
		}
		return ret;
	}

//	public void setCachedir(String cachedir) {
//		this.cachedir = cachedir;
//	}
//

	public String getImageFetchTPoolMax() {
		return imageFetchTPoolMax;
	}

	public String getImageFetchTimeLimit() {
		return imageFetchTimeLimit;
	}

	public void setImageFetchTimeLimit(String imageFetchTimeLimit) {
		this.imageFetchTimeLimit = imageFetchTimeLimit;
	}

	public void setImageFetchTPoolMax(String imageFetchTPoolMax) {
		this.imageFetchTPoolMax = imageFetchTPoolMax;
	}

	public String getSiteFetchTPoolMax() {
		return siteFetchTPoolMax;
	}

	public void setSiteFetchTPoolMax(String siteFetchTPoolMax) {
		this.siteFetchTPoolMax = siteFetchTPoolMax;
	}

	public String getSiteFetchTimeLimit() {
		return siteFetchTimeLimit;
	}

	public void setSiteFetchTimeLimit(String siteFetchTimeLimit) {
		this.siteFetchTimeLimit = siteFetchTimeLimit;
	}

	public boolean isPreFetchSeries() {
		return preFetchSeries.equalsIgnoreCase("true");
	}

	public void setPreFetchSeries(boolean preFetchSeries) {
		this.preFetchSeries = ""+ preFetchSeries;
	}

	public String getCalledAETitle() {
		return calledAETitle;
	}

	public void setCalledAETitle(String calledAETitle) {
		this.calledAETitle = calledAETitle;
	}

	public int getCacheLifespan() {
		return Integer.parseInt(cacheLifespan);
	}

	public void setCacheLifespan(int cacheLifespan) {
		this.cacheLifespan = ""+ cacheLifespan;
	}

	public Set<ScpCallingAE> getCallingAEConfigs() {
		return new HashSet<ScpCallingAE>(callingAEConfigs);
	}

	public void setCallingAEConfigs(List<ScpCallingAE> callingAEConfigs) {
		this.callingAEConfigs = callingAEConfigs;
	}

	/*
	 * (non-Javadoc)
	 *
	 * @see gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration#
	 * loadDefaultConfiguration()
	 */
	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration() {
		LOGGER.debug("loadDefaultConfiguration");
		this.accessCode = new EncryptedConfigurationPropertyString("");
		this.verifyCode = new EncryptedConfigurationPropertyString("");
		this.siteFetchTPoolMax = "20";
		this.siteFetchTimeLimit = "45";
		this.imageFetchTPoolMax = "15";
		this.imageFetchTimeLimit = "600";
		this.preFetchSeries = "true";
		this.calledAETitle = "ANY_0.0.0.0";
		this.cacheLifespan = "1";
		this.callingAEConfigs = new ArrayList<ScpCallingAE>();
		ScpCallingAE aes = new ScpCallingAE();
		aes.setAeTitle("ALL");
		aes.setCallingAeIp("0.0.0.0");
		aes.setBuildReport("SC");
		aes.setReturnQueryLevel(false);
		List<String> siteCodeBlacklist = getDefaultSiteBlackList();

		aes.setSiteCodeBlackList(siteCodeBlacklist);
		aes.modalityBlockList = new ArrayList<ScpModalityList>();
		ScpModalityList mods = new ScpModalityList();
		mods.dataSource = "ALL";
		mods.addImageLevelFilter = "false";
		mods.modalities = new ArrayList<String>();
		mods.modalities.add("none");
		aes.modalityBlockList.add(mods);
		this.callingAEConfigs.add(aes);

		return this;
	}

	public static List<String> getDefaultSiteBlackList() {
		List<String> blackList = new ArrayList<String>();
		blackList.add("100");
		blackList.add("200CLMS");
		blackList.add("200CORP");
		blackList.add("741"); //disability exams
		return blackList;
	}

	public synchronized static ScpConfiguration getConfiguration() {
		try {
			ScpConfiguration sc = FacadeConfigurationFactory.getConfigurationFactory()
					.getConfiguration(ScpConfiguration.class);
			LOGGER.debug("got ScpConfiguration from factory.");
			return sc;
		} catch (Exception clcX) {
            LOGGER.error("ScpConfiguration exception: {}", clcX.getMessage());
			return null;
		}
	}

	public synchronized VixConfiguration refreshFromFile(){
		try {
			ScpConfiguration sc = (ScpConfiguration) loadConfiguration();
			LOGGER.debug("reloaded ScpConfiguration from file.");
			return sc;
		} catch (Exception clcX) {
            LOGGER.error("Unable to load ScpConfiguration from file. ScpConfiguration exception: {}", clcX.getMessage());
			return null;
		}
	}

	public boolean isCallingAeAllowed(String callingAe, String callingIp) {
		boolean ret = false;

		List<ScpCallingAE> aes = this.callingAEConfigs;
		if (aes == null) {
            LOGGER.warn("in isCallingAEallowed, currAE={} but config list is null. So reject!", callingAe);
			return false;
		}
		if ( "ALL_0.0.0.0".equals(aes.get(0).getAeTitle()+"_"+aes.get(0).getCallingAeIp() )) {
			LOGGER.debug("in isCallingAEallowed, current configuration says ANY callingAEs are allowed");
			return true;
		}

		for (ScpCallingAE ae : aes) {
			if (callingAe.trim().equalsIgnoreCase(ae.getAeTitle().trim()) && callingIp.trim().equalsIgnoreCase(ae.getCallingAeIp().trim())) {
				//LOGGER.debug("in isAEallowed, got this AE as one of the list, "+ae);
				return true;
			}
		}
        LOGGER.debug("AE {} is not allowed to make QueryRetrive to this SCP", callingAe);
		return ret;
	}

	public String getAEbuildImageReport(String callingTitle, String callingIp) {
		String ret = null;
		List<ScpCallingAE> aes = this.callingAEConfigs;
		if (aes == null) {
            LOGGER.warn("in isAEbuildImageReport, currAE={} but config list is null", callingTitle);
			return ret;
		}
		if (aes.size() > 0)
            LOGGER.debug("in isAEbuildImageReport, AE={} against aes.size={} 0th={}", callingTitle, aes.size(), aes.get(0).getBuildSCReport());
		for (ScpCallingAE ae : aes) {
			if ("ALL".equalsIgnoreCase(ae.getAeTitle()) ||
					(callingTitle.equalsIgnoreCase(ae.getAeTitle()) && callingIp.equalsIgnoreCase(ae.getCallingAeIp()))){
				return ae.getBuildReport().toUpperCase();
			}
		}
		return ret;
	}

	public ScpCallingAE getConfigForAe(String strAe, String ipAddr){
		for(ScpCallingAE aeConfig : getCallingAEConfigs()){
			if(aeConfig.getAeTitle().equals(strAe) && aeConfig.getCallingAeIp().equals(ipAddr)){
				return aeConfig;
			}
		}
        LOGGER.warn("Request config for {} not found", strAe);
		return null;
	}

	public List<ScpModalityList> getModalityBlockList(String callingAe, String callingIp) {
		List<ScpModalityList> ret = null;
		List<ScpCallingAE> aes = this.callingAEConfigs;
		if (aes == null) {
            LOGGER.debug("in getModalityBlockList, currAE={}{} but callingAE list is null", callingAe, callingIp);
			return null;
		}
		if (aes.size() > 0 && LOGGER.isDebugEnabled()) {
            LOGGER.debug("in getModalityBlockList, AE={}{} against aes.size={} 0th mod list={}", callingAe, callingIp, aes.size(), aes.get(0).getModalityBlockList().size());
		}
		for (ScpCallingAE ae : aes) {
			if ("ALL".equalsIgnoreCase(ae.getAeTitle()) || (callingAe.equalsIgnoreCase(ae.getAeTitle()) &&
					callingIp.equalsIgnoreCase(ae.getCallingAeIp()))) {
				ret = ae.getModalityBlockList();
				break;
			}
		}

		if (ret == null || ret.size() == 0) {
            LOGGER.warn("callingAE {} does not get modality block list or it is empty", callingAe);
		}
		else if(LOGGER.isDebugEnabled()) {
            LOGGER.debug("callingAE {} gets modality block list, size={} 0th data source={}", callingAe, ret.size(), ret.get(0).getDataSource());
		}
		return ret;
	}

	public List<String> getModalityBlockList(String callingAe, String callingIp, String dataSource) {
		List<ScpModalityList> aelist = getModalityBlockList(callingAe, callingIp);
		if (aelist == null || aelist.size() == 0) {
            LOGGER.debug("in getModalityBlockList(src), callingAE={} dataSource={} got null.", callingAe, dataSource);
			return null;
		}
		for(ScpModalityList ml : aelist) {
			if ("ALL".equalsIgnoreCase(ml.getDataSource())) {
				return ml.getModalities();
			} else if (	dataSource.equalsIgnoreCase(ml.getDataSource()) ) { // dod or va
				return ml.getModalities();
			}
		}

		return null;
	}

	/* */
	public static void main(String[] args) {
		ScpConfiguration targetConfig = getConfiguration();
		ScpConfiguration defaultConfig = (ScpConfiguration) (new ScpConfiguration().loadDefaultConfiguration());

		if(args.length != 0 && args.length != 2){
			System.out.println("Argument length must be 2 or 0. If 2 access and verify code will be updated.");
		}

		if (targetConfig == null) {
			targetConfig = defaultConfig;
			System.out.println("orig config is null, use default one.");
		} else {
			System.out.println("orig config exists.");
		}

		// overwrite
		if(args.length == 2) {
			targetConfig.setAccessCode(new EncryptedConfigurationPropertyString(args[0]));
			targetConfig.setVerifyCode(new EncryptedConfigurationPropertyString(args[1]));
		}


		targetConfig.studytype = null;//remove after 348
		if (targetConfig.getSiteFetchTPoolMax() == null) {
			targetConfig.setSiteFetchTPoolMax(defaultConfig.getSiteFetchTPoolMax());
		}
		if (targetConfig.getSiteFetchTimeLimit() == null) {
			targetConfig.setSiteFetchTimeLimit(defaultConfig.getSiteFetchTimeLimit());
		}
		if (targetConfig.getImageFetchTPoolMax() == null || Integer.parseInt(targetConfig.getImageFetchTPoolMax()) > 5) {
			targetConfig.setImageFetchTPoolMax(defaultConfig.getImageFetchTPoolMax());
		}
		if (targetConfig.getImageFetchTimeLimit() == null) {
			targetConfig.setImageFetchTimeLimit(defaultConfig.getImageFetchTimeLimit());
		}
		if (targetConfig.preFetchSeries == null) {
			targetConfig.setPreFetchSeries(defaultConfig.isPreFetchSeries());
		}
		if (targetConfig.cacheLifespan == null) {
			targetConfig.setCacheLifespan(defaultConfig.getCacheLifespan());
		}
		if (targetConfig.getCalledAETitle() == null) {
			targetConfig.setCalledAETitle(defaultConfig.getCalledAETitle());
		}
		if (targetConfig.callingAEConfigs == null) {
			targetConfig.callingAEConfigs = defaultConfig.callingAEConfigs;
		}
		if(targetConfig.imageQueueSize == null){
			targetConfig.imageQueueSize = defaultConfig.imageQueueSize;
		}
		if(targetConfig.imageFetchTimeLimit.equals(defaultConfig.imageFetchTimeLimit)){
			targetConfig.imageFetchTimeLimit = "1000000"; //remove limit to allow C-MOVEs to process as long as possible
		}
		for(ScpCallingAE callingAE : targetConfig.callingAEConfigs){
			callingAE.getSiteCodeBlacklist().remove("200CRNR");
			callingAE.getSiteCodeBlacklist().remove("200");
			if(callingAE.getStudyQueryFilter() == null || callingAE.getStudyQueryFilter().isEmpty()){
				callingAE.setStudyQueryFilter("radiology");
			}
			if(callingAE.getBuildSCReport() != null && callingAE.getBuildSCReport().equalsIgnoreCase("true")) // backward compatible
				callingAE.setBuildReport("SC");
			else if (callingAE.getBuildSCReport() != null && callingAE.getBuildSCReport().equalsIgnoreCase("false"))
				callingAE.setBuildReport("SR");
			else if (callingAE.getBuildSCReport() == null && callingAE.getBuildReport() == null)
				callingAE.setBuildReport("NONE");
			else
			    callingAE.setBuildReport(callingAE.getBuildReport().toUpperCase());
			callingAE.setBuildSCReport(null);
		}


		targetConfig.storeConfiguration();
		System.out.println("ScpConfiguration file updated");
		if(args.length > 1) {
			System.out.println("ScpConfiguration done for " + args[0] + " / " + args[1]);
		}
	}
	/* */
	public void refresh() {
		refreshFromFile();
	}

	public boolean isCalledAeCorrect(String calledTitle) {
		if(this.calledAETitle.equals("ANY_0.0.0.0")) {
			return true;
		}
		else{
			return this.calledAETitle.equals(calledTitle);
		}
	}

	public boolean isUseRemoteImageFetch() {
		return useRemoteImageFetch;
	}

	public void setUseRemoteImageFetch(boolean useRemoteImageFetch) {
		this.useRemoteImageFetch = useRemoteImageFetch;
	}

	public boolean useDirectFetch() {
		return useDirectFetch;
	}

	public void setUseDirectFetch(boolean useDirectFetch) {
		this.useDirectFetch = useDirectFetch;
	}

	public boolean isRemotePatientResolution() {
		return remotePatientResolution;
	}

	public void setRemotePatientResolution(boolean remotePatientResolution) {
		this.remotePatientResolution = remotePatientResolution;
	}

	public Integer getImageQueueSize() {
		return Integer.parseInt(imageQueueSize);
	}

	public void setImageQueueSize(String imageQueueSize) {
		this.imageQueueSize = imageQueueSize;
	}

	public boolean isFdtEnabled() {
		return isFdtEnabled;
	}

	public void setFdtEnabled(boolean fdtEnabled) {
		isFdtEnabled = fdtEnabled;
	}

	public int getFdtPort() {
		return fdtPort;
	}

	public void setFdtPort(int fdtPort) {
		this.fdtPort = fdtPort;
	}

	public int getCacheMetaHoursToLive() {
		return cacheMetaHoursToLive;
	}

	public void setCacheMetaHoursToLive(int cacheMetaHoursToLive) {
		this.cacheMetaHoursToLive = cacheMetaHoursToLive;
	}

	@Override
	public String toString() {
		return "ScpConfiguration{" +
				"accessCode=" + accessCode +
				",\n verifyCode=" + verifyCode +
				",\n studytype='" + studytype + '\'' +
				",\n siteFetchTPoolMax='" + siteFetchTPoolMax + '\'' +
				",\n siteFetchTimeLimit='" + siteFetchTimeLimit + '\'' +
				",\n imageFetchTPoolMax='" + imageFetchTPoolMax + '\'' +
				",\n imageFetchTimeLimit='" + imageFetchTimeLimit + '\'' +
				",\n useRemoteImageFetch=" + useRemoteImageFetch +
				",\n useDirectFetch=" + useDirectFetch +
				",\n cacheLifespan='" + cacheLifespan + '\'' +
				",\n preFetchSeries='" + preFetchSeries + '\'' +
				",\n calledAETitle='" + calledAETitle + '\'' +
				",\n remotePatientResolution=" + remotePatientResolution +
				",\n imageQueueSize='" + imageQueueSize + '\'' +
				",\n isFdtEnabled=" + isFdtEnabled +
				",\n isFdtPort=" + fdtPort +
				",\n cacheMetaHoursToLive="+cacheMetaHoursToLive +
				",\n callingAEConfigs=" + callingAEConfigs +
				'}';
	}
}
