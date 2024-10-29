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
public class Value
{	    
	protected String value;
	
	public Value(String value)
	{
		this.value = value;
	}
	
	public String getValue() {
		return value;
	}


	public void setValue(String value) {
		this.value = value;
	}

}
