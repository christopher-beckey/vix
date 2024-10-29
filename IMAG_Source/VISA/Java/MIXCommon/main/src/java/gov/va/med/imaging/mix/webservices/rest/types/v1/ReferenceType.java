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
public class ReferenceType
{	    
	protected String reference;
	public ReferenceType(String ref)
	{
		this.reference = ref;
	}

    public String getReference() {
        return this.reference;
    }

    public void setReference(String ref) {
        this.reference = ref;
    }

}
