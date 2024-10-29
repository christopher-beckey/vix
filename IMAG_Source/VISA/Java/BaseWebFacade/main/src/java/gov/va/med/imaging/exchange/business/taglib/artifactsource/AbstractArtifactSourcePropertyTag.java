/**
 * 
 */
package gov.va.med.imaging.exchange.business.taglib.artifactsource;

import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.utils.JspUtilities;

import java.io.IOException;
import java.io.Writer;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.Tag;

/**
 * @author vhaiswbeckec
 *
 */
public abstract class AbstractArtifactSourcePropertyTag
extends BodyTagSupport
{
	/**
	 * 
	 * @return
	 * @throws JspException
	 */
	protected ArtifactSource getArtifactSource() 
	throws JspException
	{
		return ArtifactSourceTagUtility.getArtifactSource(this);
	}
	
	protected Writer getWriter() 
	throws IOException
	{
		return pageContext.getOut();
	}

	protected void write(String value) throws JspException {
		JspUtilities.write(pageContext, value);
	}
	
	public abstract String getElementValue() 
	throws JspException;

	@Override
    public int doEndTag() 
	throws JspException
    {
    	write(getElementValue());
    	
    	return Tag.EVAL_PAGE;
    }
}
