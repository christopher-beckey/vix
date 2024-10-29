/**
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement
public class IndexTermValueType
{
	private String indexTermUrn;
	private String name;
	private String abbreviation;
	private String siteVixUrl = null;
	
	public IndexTermValueType()
	{
		super();
	}

	/**
	 * @param indexTermId
	 * @param name
	 * @param abbreviation
	 */
	public IndexTermValueType(String indexTermUrn, String name,
			String abbreviation)
	{
		super();
		this.indexTermUrn = indexTermUrn;
		this.name = name;
		this.abbreviation = abbreviation;
	}

	public String getIndexTermUrn()
	{
		return indexTermUrn;
	}

	public void setIndexTermUrn(String indexTermUrn)
	{
		this.indexTermUrn = indexTermUrn;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getAbbreviation()
	{
		return abbreviation;
	}

	public void setAbbreviation(String abbreviation)
	{
		this.abbreviation = abbreviation;
	}
	
	public String getSiteVixUrl() {
		return siteVixUrl;
	}

	public void setSiteVixUrl(String siteVixUrl) {
		this.siteVixUrl = siteVixUrl;
	}	


}
