/**
 * 
 */
package gov.va.med.imaging.exchange.business.taglib.artifactsource;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
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
public abstract class AbstractResolvedArtifactSourcePropertyTag
extends BodyTagSupport
{
	/**
	 * 
	 * @return
	 * @throws JspException
	 */
	protected ResolvedArtifactSource getResolvedArtifactSource() 
	throws JspException
	{
		return ResolvedArtifactSourceTagUtility.getResolvedArtifactSource(this);
	}
	
	protected Writer getWriter() 
	throws IOException
	{
		return pageContext.getOut();
	}
	
	public abstract String getElementValue() 
	throws JspException;

	@Override
    public int doEndTag() 
	throws JspException
    {
		JspUtilities.write(pageContext, getElementValue());
    	return Tag.EVAL_PAGE;
    }
}
