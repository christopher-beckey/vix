/**
 * Date Created: Apr 25, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.business;

import java.util.Date;

/**
 * @author vhaisltjahjb
 *
 */
public class QAReviewReportResult
{
	private final String reportFlags;
	private final String fromDate;
	private final String throughDate;
	private final String reportStartDateTime;
	private final String reportCompletedDateTime;

	/**
	 * @param userId
	 * @param userName
	 */
	public QAReviewReportResult(
			String reportFlags,
			String fromDate,
			String throughDate,
			String reportStartDateTime,
			String reportCompletedDateTime
			)
	{
		super();
		this.reportFlags = reportFlags;
		this.fromDate = fromDate;
		this.throughDate = throughDate;
		this.reportStartDateTime = reportStartDateTime;
		this.reportCompletedDateTime = reportCompletedDateTime;
	}

	public String getReportFlags() {
		return reportFlags;
	}

	public String getFromDate() {
		return fromDate;
	}

	public String getThroughDate() {
		return throughDate;
	}

	public String getReportStartDateTime() {
		return reportStartDateTime;
	}

	public String getReportCompletedDateTime() {
		return reportCompletedDateTime;
	}

}



