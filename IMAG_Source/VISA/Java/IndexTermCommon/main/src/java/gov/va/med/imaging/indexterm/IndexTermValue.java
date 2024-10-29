/**
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm;

/**
 * @author Administrator
 *
 */
public class IndexTermValue
{
	private final IndexTermURN indexTermUrn;
	private final String name;
	private final String abbreviation;
	private String siteVixUrl = null;

	
	/**
	 * @param indexTermUrn
	 * @param name
	 * @param abbreviation
	 */
	public IndexTermValue(IndexTermURN indexTermUrn, String name,
	String abbreviation)
	{
		super();
		this.indexTermUrn = indexTermUrn;
		this.name = name;
		this.abbreviation = abbreviation;
	}
	
	/**
	 * @return the indexTermUrn
	 */
	public IndexTermURN getIndexTermUrn()
	{
		return indexTermUrn;
	}
	
	/**
	 * @return the name
	 */
	public String getName()
	{
		return name;
	}
	
	/**
	 * @return the abbreviation
	 */
	public String getAbbreviation()
	{
		return abbreviation;
	}
	
	public String getSiteVixUrl() {
		return siteVixUrl;
	}

	public void setSiteVixUrl(String siteVixUrl) {
		this.siteVixUrl = siteVixUrl;
	}

}
