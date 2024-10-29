/**
 * 
 * 
 * Date Created: Feb 11, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult;

/**
 * @author Julian Werfel
 *
 */
public class Consult
{
	private final ConsultURN consultUrn;
	private final String date;
	private final String service;
	private final String procedure;
	private final String status;
	private final int numberNotes;
	private String siteVixUrl = null;

	
	/**
	 * @param consultUrn
	 * @param date
	 * @param service
	 * @param procedure
	 * @param status
	 * @param numberNotes
	 */
	public Consult(ConsultURN consultUrn, String date, String service,
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
	 * @return the consultUrn
	 */
	public ConsultURN getConsultUrn()
	{
		return consultUrn;
	}
	
	/**
	 * @return the date
	 */
	public String getDate()
	{
		return date;
	}
	
	/**
	 * @return the service
	 */
	public String getService()
	{
		return service;
	}
	
	/**
	 * @return the procedure
	 */
	public String getProcedure()
	{
		return procedure;
	}
	
	/**
	 * @return the status
	 */
	public String getStatus()
	{
		return status;
	}
	
	/**
	 * @return the numberNotes
	 */
	public int getNumberNotes()
	{
		return numberNotes;
	}
	
	public String getSiteVixUrl() {
		return siteVixUrl;
	}

	public void setSiteVixUrl(String siteVixUrl) {
		this.siteVixUrl = siteVixUrl;
	}

}
