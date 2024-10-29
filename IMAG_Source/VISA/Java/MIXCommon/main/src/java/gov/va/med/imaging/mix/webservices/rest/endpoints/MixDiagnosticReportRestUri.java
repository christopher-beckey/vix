package gov.va.med.imaging.mix.webservices.rest.endpoints;

/**
 * @author vacotittoc
 *
 */
public class MixDiagnosticReportRestUri 
{
	/**
	 * 
	 */
//	public final static String mixServicePath = "mix/v1"; // "mix/metadata"; 
	
	/**
	 * Path to retrieve studies for patients with optional date range (modality filter ignored)
	 */
	public final static String reportStudyListPath = "DiagnosticReport/subject?value={patientIcn}&assigner=VHA&fromDate={fromDate}&toDate={toDate}"; // &modalities={modalityList}";

	public final static String reportStudyListPathModality = reportStudyListPath + "&modalities={modalityList}";

}
