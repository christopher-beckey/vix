/**
 * 
 */
package gov.va.med.imaging.exchange.business.taglib;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.Tag;

/**
 * @author vhaiswbeckec
 *
 */
public abstract class AbstractBusinessObjectTag<T>
extends AbstractApplicationContextTagSupport
{
	private static final long serialVersionUID = 1L;

	/**
     * @return the image
     */
    public abstract T getBusinessObject() throws JspException;

    /**
     * 
     * @return
     * @throws JspException
     */
    @SuppressWarnings("unchecked")
	public Class<T> getBusinessObjectType() throws JspException
    {
    	try
		{
			return (Class<T>)( getBusinessObject().getClass() );
		}
		catch (Throwable x)
		{
            getLogger().warn("AbstractBusinessObjectTag.getBusinessObjectType() --> Business Object Type is not of the expected type: {}", x.getMessage());
			return null;
		}
    }
    
	/**
     * @see javax.servlet.jsp.tagext.TagSupport#doStartTag()
     */
    @Override
    public int doStartTag() throws JspException
    {  	
    	return getBusinessObject() != null ? Tag.EVAL_BODY_INCLUDE : Tag.SKIP_BODY;
    }
}
