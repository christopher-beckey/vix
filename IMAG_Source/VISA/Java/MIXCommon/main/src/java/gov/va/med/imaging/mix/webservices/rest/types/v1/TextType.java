/**
 * 
 */
package gov.va.med.imaging.mix.webservices.rest.types.v1;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VACOTITTOC
 *
 */
@XmlRootElement
public class TextType
{	    
	protected String status;
	protected String div;
	
	public TextType(String status, String div)
	{
		this.status = status;
		this.div = div;
	}
	
	public String getStatus() {
		return status;
	}


	public void setStatus(String status) {
		this.status = status;
	}


	public String getDiv() {
		return div;
	}


	public void setDiv(String div) {
		this.div = div;
	}



}
