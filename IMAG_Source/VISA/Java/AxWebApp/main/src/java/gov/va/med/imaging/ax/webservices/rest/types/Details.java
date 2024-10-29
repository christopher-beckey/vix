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
public class Details
{	    
	protected String text;

	public Details(String message)
	{
		this.text = message;
	}


	public String getText() {
		return text;
	}


	public void setText(String text) {
		this.text = text;
	}
}
