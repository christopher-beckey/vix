package gov.va.med.imaging.dicomservices.common.stats;

public class VixDicomServicesStoreSCUStatistics 
implements VixDicomServicesStoreSCUStatisticsMBean {

	private String aeTitle;
	private String sopClassUID;
	private int totalVixSendToAEFailures;

	public VixDicomServicesStoreSCUStatistics(String aeTitle, String sopClassUID) {
		super();
		this.aeTitle = aeTitle;
		this.sopClassUID = sopClassUID;
		this.totalVixSendToAEFailures = 0;
	}

	@Override
	public String getAeTitle() {
		return aeTitle;
	}

	@Override
	public int getTotalVixSendToAEFailures() {
		return totalVixSendToAEFailures;
	}
	
	public synchronized void incrementVixSendToAEFailuresCount(){
		this.totalVixSendToAEFailures++;
	}
	
	public synchronized void addToVixSendToAEFailuresCount(int failuresCount){
		this.totalVixSendToAEFailures += failuresCount;
	}

	public String getSopClassUID() {
		return sopClassUID;
	}


}
