/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jun 4, 2015
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian
 *
 */
@XmlRootElement
public class ViewerStudyFilterType
{
	private String filterPackage = null;
	private String filterClass = null;
	private String filterType = null;
	private String filterEvent = null;
	private String filterSpecialty = null;
	private String filterOrigin = null;
	private Date fromDate = null;
	private Date toDate = null;
	private boolean includeMuseOrders = false;
	private boolean includePatientOrders = true;
	private boolean includeEncounterOrders = true;

	
	public ViewerStudyFilterType()
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
	public Date getFromDate()
	{
		return fromDate;
	}

	/**
	 * @param fromDate the fromDate to set
	 */
	public void setFromDate(Date fromDate)
	{
		this.fromDate = fromDate;
	}

	/**
	 * @return the toDate
	 */
	public Date getToDate()
	{
		return toDate;
	}

	/**
	 * @param toDate the toDate to set
	 */
	public void setToDate(Date toDate)
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

	public boolean isIncludeMuseOrders() {
		return includeMuseOrders;
	}

	public void setIncludeMuseOrders(boolean includeMuseOrders) {
		this.includeMuseOrders = includeMuseOrders;
	}

	public boolean isIncludePatientOrders() {
		return includePatientOrders;
	}

	public void setIncludePatientOrders(boolean includePatientOrders) {
		this.includePatientOrders = includePatientOrders;
	}

	public boolean isIncludeEncounterOrders() {
		return includeEncounterOrders;
	}

	public void setIncludeEncounterOrders(boolean includeEncounterOrders) {
		this.includeEncounterOrders = includeEncounterOrders;
	}

}
