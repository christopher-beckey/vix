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
public class ContentType
{	    
	protected AttachmentType attachment;


	public ContentType(AttachmentType attachment)
	{
		this.attachment = attachment;
	}
	
	public AttachmentType getAttachment() {
		return attachment;
	}

	public void setAttachment(AttachmentType attType) {
		this.attachment = attType;
	}
}
