/**
 * Date Created: Apr 25, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="qaReviewReports")
public class QAReviewReportResultsType
{
	
	private QAReviewReportResultType[] qaReviewReports;
	
	public QAReviewReportResultsType()
	{
		super();
	}

	/**
	 * @param qaReviewReport
	 */
	public QAReviewReportResultsType(QAReviewReportResultType[] qaReviewReports)
	{
		super();
		this.qaReviewReports = qaReviewReports;
	}

	/**
	 * @return the qaReviewReports
	 */
	@XmlElement(name="qaReviewReport")
	public QAReviewReportResultType[] getQAReviewReports()
	{
		return qaReviewReports;
	}

	/**
	 * @param qaReviewReports the qaReviewReports to set
	 */
	public void setQAReviewReports(QAReviewReportResultType[] qaReviewReports)
	{
		this.qaReviewReports = qaReviewReports;
	}

}

