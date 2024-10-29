package gov.va.med.imaging.dicom.common.stats;

public class VixDicomServicesStoreSCUStatistics 
implements VixDicomServicesStoreSCUStatisticsMBean {

	private String aeTitle;
	private int totalVixSendToAEFailures;

	public VixDicomServicesStoreSCUStatistics(String aeTitle) {
		super();
		this.aeTitle = aeTitle;
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


}
