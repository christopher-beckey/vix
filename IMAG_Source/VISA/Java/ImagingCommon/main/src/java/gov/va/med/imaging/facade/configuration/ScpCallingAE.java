package gov.va.med.imaging.facade.configuration;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import java.util.ArrayList;
import java.util.List;

@XmlAccessorType(XmlAccessType.FIELD)
public class ScpCallingAE {
    @XmlAttribute
	private String aeTitle;

    @XmlElement
	private String callingAeIp;
    private String buildSCReport;
    private String buildReport;
	private boolean returnQueryLevel;
	private String studyQueryFilter = "radiology";//works for all sources May 24 23
	private boolean sendKeepAlive = false;
	public List<ScpModalityList> modalityBlockList = new ArrayList<ScpModalityList>();
	private List<String> siteCodeBlackList = new ArrayList<String>();
	
	public ScpCallingAE() {
	}
	public String getAeTitle() {
		return aeTitle;
	}
	public void setAeTitle(String aeTitle) {
		this.aeTitle = aeTitle;
	}
	public String getCallingAeIp() {
		return callingAeIp;
	}
	public void setCallingAeIp(String callingAeIp) {
		this.callingAeIp = callingAeIp;
	}
	public String getBuildSCReport() {
		return buildSCReport;
	}
	public void setBuildSCReport(String buildSCReport) {
		this.buildSCReport = buildSCReport;
	}
	public String getBuildReport() {
		return buildReport;
	}
	public void setBuildReport(String buildReport) {
		this.buildReport = buildReport;
	}
	public List<String> getSiteCodeBlacklist() {
		return siteCodeBlackList;
	}

	public void setSiteCodeBlackList(List<String> sitesBlocked) {
		this.siteCodeBlackList = sitesBlocked;
	}
	
	public List<ScpModalityList> getModalityBlockList() {
		return modalityBlockList;
	}
	public void setModalityBlockList(List<ScpModalityList> modalityBlockList) {
		this.modalityBlockList = modalityBlockList;
	}

	public boolean isReturnQueryLevel() {
		return returnQueryLevel;
	}

	public void setReturnQueryLevel(boolean returnQueryLevel) {
		this.returnQueryLevel = returnQueryLevel;
	}

	public String getStudyQueryFilter() {
		return studyQueryFilter;
	}

	public void setStudyQueryFilter(String studyQueryFilter) {
		this.studyQueryFilter = studyQueryFilter;
	}

	@Override
	public String toString() {
		return "ScpCallingAE{" +
				"aeTitle='" + aeTitle + '\'' +
				",\n callingAeIp='" + callingAeIp + '\'' +
				",\n buildSCReport='" + buildSCReport + '\'' +
				",\n buildReport='" + buildReport + '\'' +
				",\n returnQueryLevel=" + returnQueryLevel +
				",\n studyQueryFilter='" + studyQueryFilter + '\'' +
				",\n modalityBlockList=" + modalityBlockList +
				",\n siteCodeBlackList=" + siteCodeBlackList +
				'}';
	}

	public boolean isSendKeepAlive() {
		return sendKeepAlive;
	}

	public void setSendKeepAlive(boolean sendKeepAlive) {
		this.sendKeepAlive = sendKeepAlive;
	}
}
