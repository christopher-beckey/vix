package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Apr 25, 2018
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="qaReviewReport")
public class QAReviewReportResultType
{
	private String reportFlags;
	private String fromDate;
	private String throughDate;
	private String reportStartDateTime;
	private String reportCompletedDateTime;
	
	public QAReviewReportResultType()
	{
		super();
	}

	public QAReviewReportResultType(
		String reportFlags,
		String fromDate,
		String throughDate,
		String reportStartDateTime,
		String reportCompletedDateTime)
	{
		super();
		this.setReportFlags(reportFlags);
		this.setFromDate(fromDate);
		this.setThroughDate(throughDate);
		this.setReportStartDateTime(reportStartDateTime);
		this.setReportCompletedDateTime(reportCompletedDateTime);
	}

	public String getReportFlags() {
		return reportFlags;
	}

	public void setReportFlags(String reportFlags) {
		this.reportFlags = reportFlags;
	}

	public String getThroughDate() {
		return throughDate;
	}

	public void setThroughDate(String throughDate) {
		this.throughDate = throughDate;
	}

	public String getFromDate() {
		return fromDate;
	}

	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}

	public String getReportStartDateTime() {
		return reportStartDateTime;
	}

	public void setReportStartDateTime(String reportStartDateTime) {
		this.reportStartDateTime = reportStartDateTime;
	}

	public String getReportCompletedDateTime() {
		return reportCompletedDateTime;
	}

	public void setReportCompletedDateTime(String reportCompletedDateTime) {
		this.reportCompletedDateTime = reportCompletedDateTime;
	}

}
