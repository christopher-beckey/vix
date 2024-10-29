package gov.va.med.imaging.vixserverhealth.web;

public class VixDicomSendFailures {

	private String AeTitle;
	private String sopClass;
	private String totalVixSendToAEFailures;
	
	public VixDicomSendFailures() {
		// TODO Auto-generated constructor stub
	}

	public String getAeTitle() {
		return AeTitle;
	}

	public void setAeTitle(String aeTitle) {
		this.AeTitle = aeTitle;
	}

	public String getSopClass() {
		return sopClass;
	}

	public void setSopClass(String sopClass) {
		this.sopClass = sopClass;
	}

	public String getTotalVixSendToAEFailures() {
		return totalVixSendToAEFailures;
	}

	public void setTotalVixSendToAEFailures(String totalObjectsFailed) {
		this.totalVixSendToAEFailures = totalObjectsFailed;
	}
	


}
