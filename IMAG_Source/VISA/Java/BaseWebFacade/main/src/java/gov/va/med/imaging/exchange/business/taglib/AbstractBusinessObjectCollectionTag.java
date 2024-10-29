/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jan 22, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
package gov.va.med.imaging.exchange.business.taglib;

import java.io.IOException;
import java.util.Collection;
import java.util.Iterator;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.IterationTag;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TryCatchFinally;

/**
 * This class must be subclassed with something that will set the
 * List of Image instances to display.
 * 
 * @author VHAISWBECKEC
 *
 */
public abstract class AbstractBusinessObjectCollectionTag<T> 
extends AbstractApplicationContextBodyTagSupport
implements TryCatchFinally
{
	private static final long serialVersionUID = 1L;
	private String emptyResultMessage;
    private Iterator<T> businessObjectCollectionIterator;
    private T currentBusinessObject;
    private StringBuilder messages;
	
	/**
     * @return the collection of business object to display
     */
    protected abstract Collection<T> getCollection()
    throws JspException;

	/**
     * @return the current business object to display
     */
    public T getCurrent() throws JspException
    {
    	return this.currentBusinessObject;
    }

    /**
     * 
     * @param message
     */
    protected void appendMessage(String message)
    {
    	if(message != null)
    	{
			if(this.messages.length() > 0)
				this.messages.append("<br/>");
			this.messages.append(message);
    	}
    }
    
	/**
	 * The message to show if the image list is empty
	 * @return
	 */
	public String getEmptyResultMessage()
    {
    	return this.emptyResultMessage;
    }

	public void setEmptyResultMessage(String emptyResultMessage)
    {
    	this.emptyResultMessage = emptyResultMessage;
    }
	
	/**
     * @see javax.servlet.jsp.tagext.TagSupport#doStartTag()
     */
    @Override
    public int doStartTag() throws JspException
    {
    	int result = Tag.SKIP_BODY;
    	this.messages = new StringBuilder();
    	Collection<T> businessObjectCollection = getCollection();    	
    	
    	if(businessObjectCollection != null && businessObjectCollection.size() > 0)
    	{
    		this.businessObjectCollectionIterator = businessObjectCollection.iterator();
    		this.currentBusinessObject = businessObjectCollectionIterator.next();
    		result = Tag.EVAL_BODY_INCLUDE;
    	}
		else if(getEmptyResultMessage() != null)
	    	appendMessage( getEmptyResultMessage() );
		
		if(this.messages.length() > 0)
			try 
			{
				pageContext.getOut().write(messages.toString());
			}
			catch(IOException ioX)
			{
                getLogger().error("AbstractBusinessObjectCollectionTag.doStartTag() --> Unable to write taglib message(s): {}", ioX.getMessage());
			}
    	
        return result;
    }

    Iterator<T> getBusinessObjectCollectionIterator()
    {
    	return this.businessObjectCollectionIterator;
    }

	@Override
    public int doAfterBody() 
	throws JspException
    {
		Iterator<T> boIterator = getBusinessObjectCollectionIterator();
	    if( boIterator != null && boIterator.hasNext() )
	    {
	    	this.currentBusinessObject = boIterator.next();
	    	return IterationTag.EVAL_BODY_AGAIN;
	    }
	    this.currentBusinessObject = null;
	    return BodyTag.SKIP_BODY;
    }
    
	/**
     * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
     */
    @Override
    public int doEndTag() throws JspException
    {
	    return Tag.EVAL_PAGE;
    }

	@Override
    public void doCatch(Throwable t) throws Throwable
    {
	    appendMessage(t.getMessage());
    }

	@Override
    public void doFinally()
    {
		if(this.messages != null && this.messages.length() > 0)
    		try
    		{
    			pageContext.getOut().write(this.messages.toString());
    		}
    		catch(IOException ioX)
    		{
                getLogger().error("AbstractBusinessObjectCollectionTag.doFinally() --> Unable to write taglib message(s): {}", ioX.getMessage());
    		}
    }
}
