/**
 * 
 */
package gov.va.med.imaging.ax.webservices.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VACOTITTOC
 *
 */
@XmlRootElement
public class LinkType
{	    
	protected String relation;
	protected String url;

	public LinkType(String relation, String url)
	{
		this.relation = relation;
		this.url = url;
	}
	
	public String getRelation() {
		return relation;
	}

	public void setRelation(String relation) {
		this.relation = relation;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

}
