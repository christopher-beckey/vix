/**
 * 
 */
package gov.va.med.imaging.exchange.business;

/**
 * @author William Peterson
 *
 */
public class MuseReport {

	
	private String outputType;
	private String reportFormatId;
	private String testId;
	
	
	public MuseReport(String outputType, String reportFormatId, String testId) {
		super();
		this.outputType = outputType;
		this.reportFormatId = reportFormatId;
		this.testId = testId;
	}

	public MuseReport(){
		outputType = null;
		reportFormatId = null;
		testId = null;
	}

	public String getOutputType() {
		return outputType;
	}

	public String getReportFormatId() {
		return reportFormatId;
	}

	public String getTestId() {
		return testId;
	}

	public void setOutputType(String outputType) {
		this.outputType = outputType;
	}

	public void setReportFormatId(String reportFormatId) {
		this.reportFormatId = reportFormatId;
	}

	public void setTestId(String testId) {
		this.testId = testId;
	}
	
	

}
