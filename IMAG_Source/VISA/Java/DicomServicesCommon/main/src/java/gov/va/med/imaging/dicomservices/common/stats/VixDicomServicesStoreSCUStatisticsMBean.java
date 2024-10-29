package gov.va.med.imaging.dicomservices.common.stats;

public interface VixDicomServicesStoreSCUStatisticsMBean{

	public String getAeTitle();
	
	public String getSopClassUID();
		
	public int getTotalVixSendToAEFailures();

}
