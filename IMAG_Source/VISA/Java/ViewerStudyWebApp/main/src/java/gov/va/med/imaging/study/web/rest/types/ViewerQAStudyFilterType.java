/**
 * Date Created: Jun 1, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.study.web.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="studyFilter")
public class ViewerQAStudyFilterType
{
	private String filterPackage;
	private String filterClass;
	private String filterType;
	private String filterEvent;
	private String filterSpecialty;
	private String filterOrigin;
	private String fromDate;
	private String toDate;
	private String includeMuseOrders;
	private String includePatientOrders;
	private String includeEncounterOrders;
	private String captureApp;
	private String captureSavedBy;
	private String qaStatus;
	private String maximumResult;

	public ViewerQAStudyFilterType()
	{
		super();
	}

	/**
	 * @return the filterPackage
	 */
	public String getFilterPackage()
	{
		return filterPackage;
	}

	/**
	 * @param filterPackage the filterPackage to set
	 */
	public void setFilterPackage(String filterPackage)
	{
		this.filterPackage = filterPackage;
	}

	/**
	 * @return the filterClass
	 */
	public String getFilterClass()
	{
		return filterClass;
	}

	/**
	 * @param filterClass the filterClass to set
	 */
	public void setFilterClass(String filterClass)
	{
		this.filterClass = filterClass;
	}

	/**
	 * @return the filterType
	 */
	public String getFilterType()
	{
		return filterType;
	}

	/**
	 * @param filterType the filterType to set
	 */
	public void setFilterType(String filterType)
	{
		this.filterType = filterType;
	}

	/**
	 * @return the filterEvent
	 */
	public String getFilterEvent()
	{
		return filterEvent;
	}

	/**
	 * @param filterEvent the filterEvent to set
	 */
	public void setFilterEvent(String filterEvent)
	{
		this.filterEvent = filterEvent;
	}

	/**
	 * @return the filterSpecialty
	 */
	public String getFilterSpecialty()
	{
		return filterSpecialty;
	}

	/**
	 * @param filterSpecialty the filterSpecialty to set
	 */
	public void setFilterSpecialty(String filterSpecialty)
	{
		this.filterSpecialty = filterSpecialty;
	}

	/**
	 * @return the fromDate
	 */
	public String getFromDate()
	{
		return fromDate;
	}

	/**
	 * @param fromDate the fromDate to set
	 */
	public void setFromDate(String fromDate)
	{
		this.fromDate = fromDate;
	}

	/**
	 * @return the toDate
	 */
	public String getToDate()
	{
		return toDate;
	}

	/**
	 * @param toDate the toDate to set
	 */
	public void setToDate(String toDate)
	{
		this.toDate = toDate;
	}

	/**
	 * @return the filterOrigin
	 */
	public String getFilterOrigin()
	{
		return filterOrigin;
	}

	/**
	 * @param filterOrigin the filterOrigin to set
	 */
	public void setFilterOrigin(String filterOrigin)
	{
		this.filterOrigin = filterOrigin;
	}

	public String getIncludeMuseOrders() {
		return includeMuseOrders;
	}

	public void setIncludeMuseOrders(String includeMuseOrders) {
		this.includeMuseOrders = includeMuseOrders;
	}

	public String getIncludePatientOrders() {
		return includePatientOrders;
	}

	public void setIncludePatientOrders(String includePatientOrders) {
		this.includePatientOrders = includePatientOrders;
	}

	public String getIncludeEncounterOrders() {
		return includeEncounterOrders;
	}

	public void setIncludeEncounterOrders(String includeEncounterOrders) {
		this.includeEncounterOrders = includeEncounterOrders;
	}

	public String getCaptureApp() {
		return captureApp;
	}

	public void setCaptureApp(String captureApp) {
		this.captureApp = captureApp;
	}

	public String getCaptureSavedBy() {
		return captureSavedBy;
	}

	public void setCaptureSavedBy(String captureSavedBy) {
		this.captureSavedBy = captureSavedBy;
	}

	public String getQaStatus() {
		return qaStatus;
	}
	
	public void setQaStatus(String qaStatus) {
		this.qaStatus = qaStatus;
	}
	
	/**
	 * @return the maximumResult
	 */
	public String getMaximumResult()
	{
		return maximumResult;
	}

	/**
	 * @param maximumResult the maximumResult to set
	 */
	public void setMaximumResult(String maximumResult)
	{
		this.maximumResult = maximumResult;
	}


}
