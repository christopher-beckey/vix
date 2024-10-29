package gov.va.med.imaging.dicomservices.datasource.configuration;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


/**
 * 
 * @author William Peterson
 *
 */



public class DicomServicesConfiguration 
implements Serializable {

	private static final long serialVersionUID = 1L;
	private static final String DEFAULT_LOCAL_AETITLE = "VISTA_STORAGE";
	private static final int PDU_TIMEOUT = 180;

	private String localSiteLocalAETitle = null;
	private String localSiteRemoteAETitle = null;
	private String localSiteHost = null;
	private Integer localSitePort = 0;
	private Integer localSitePDUTimeout = 0;
	private boolean dicomServicesDisabled;
	private String localTempPath = "c:\\dicom\\temp\\";
	private String textValueTag = "0040,A160";
	
	private List<String> dicomRemoteAEs = null;
	
	public DicomServicesConfiguration() {
		super();
	}

	public static DicomServicesConfiguration createDefaultConfiguration() {
	
		DicomServicesConfiguration config = new DicomServicesConfiguration();
		
		config.localSiteLocalAETitle = DEFAULT_LOCAL_AETITLE;
		config.localSitePDUTimeout = PDU_TIMEOUT;
		
		config.dicomRemoteAEs = new ArrayList<String>();
		
		return config;
	}

	public String getLocalSiteLocalAETitle() {
		return localSiteLocalAETitle;
	}

	//public void setLocalSiteLocalAETitle(String localSiteLocalAETitle) {
		//this.localSiteLocalAETitle = localSiteLocalAETitle;
	//}

	public String getLocalSiteRemoteAETitle() {
		return localSiteRemoteAETitle;
	}

	//public void setLocalSiteRemoteAETitle(String localSiteRemoteAETitle) {
	//	this.localSiteRemoteAETitle = localSiteRemoteAETitle;
	//}

	public String getLocalSiteHost() {
		return localSiteHost;
	}

	public String getLocalTempPath() {
		return localTempPath;
	}

	public String getTextValueTag() {
		return textValueTag;
	}
	
	//public void setLocalSiteHost(String localSiteHost) {
	//	this.localSiteHost = localSiteHost;
	//}

	public Integer getLocalSitePort() {
		return localSitePort;
	}

	//public void setLocalSitePort(Integer localSitePort) {
	//	this.localSitePort = localSitePort;
	//}

	public Integer getLocalSitePDUTimeout() {
		return localSitePDUTimeout;
	}

	//public void setLocalSitePDUTimeout(Integer localSitePDUTimeout) {
	//	this.localSitePDUTimeout = localSitePDUTimeout;
	//}

	public List<String> getDicomRemoteAEs() {
		return dicomRemoteAEs;
	}

	public boolean isDicomServicesDisabled() {
		return dicomServicesDisabled;
	}

	//public void setDicomRemoteAEs(List<String> dicomRemoteAEs) {
	//	this.dicomRemoteAEs = dicomRemoteAEs;
	//}
	


}
