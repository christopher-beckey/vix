/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement
public class ConsultType
{
	private String consultUrn;
	private String date;
	private String service;
	private String procedure;
	private String status;
	private int numberNotes;
	private String siteVixUrl;

	
	public ConsultType()
	{
		super();
	}

	/**
	 * @param consultId
	 * @param date
	 * @param service
	 * @param procedure
	 * @param status
	 * @param numberNotes
	 */
	public ConsultType(String consultUrn, String date, String service,
		String procedure, String status, int numberNotes)
	{
		super();
		this.consultUrn = consultUrn;
		this.date = date;
		this.service = service;
		this.procedure = procedure;
		this.status = status;
		this.numberNotes = numberNotes;
	}

	/**
	 * @return the consultId
	 */
	public String getConsultUrn()
	{
		return consultUrn;
	}

	/**
	 * @param consultId the consultId to set
	 */
	public void setConsultUrn(String consultUrn)
	{
		this.consultUrn = consultUrn;
	}

	/**
	 * @return the date
	 */
	public String getDate()
	{
		return date;
	}

	/**
	 * @param date the date to set
	 */
	public void setDate(String date)
	{
		this.date = date;
	}

	/**
	 * @return the service
	 */
	public String getService()
	{
		return service;
	}

	/**
	 * @param service the service to set
	 */
	public void setService(String service)
	{
		this.service = service;
	}

	/**
	 * @return the procedure
	 */
	public String getProcedure()
	{
		return procedure;
	}

	/**
	 * @param procedure the procedure to set
	 */
	public void setProcedure(String procedure)
	{
		this.procedure = procedure;
	}

	/**
	 * @return the status
	 */
	public String getStatus()
	{
		return status;
	}

	/**
	 * @param status the status to set
	 */
	public void setStatus(String status)
	{
		this.status = status;
	}

	/**
	 * @return the numberNotes
	 */
	public int getNumberNotes()
	{
		return numberNotes;
	}

	/**
	 * @param numberNotes the numberNotes to set
	 */
	public void setNumberNotes(int numberNotes)
	{
		this.numberNotes = numberNotes;
	}
	
	public String getSiteVixUrl() {
		return siteVixUrl;
	}

	public void setSiteVixUrl(String siteVixUrl) {
		this.siteVixUrl = siteVixUrl;
	}	


}
