/**
 * 
 */
package gov.va.med.imaging.exchange.business.taglib;

import gov.va.med.imaging.exchange.business.taglib.exceptions.MissingRequiredArgumentException;
import java.io.IOException;
import java.net.URL;
import java.util.Collection;
import java.util.Iterator;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.IterationTag;
import gov.va.med.logging.Logger;

/**
 * @author vhaiswbeckec
 *
 */
public abstract class AbstractUrlCollectionTag
extends BodyTagSupport
{
	private static final long serialVersionUID = 1L;
	private final static Logger LOGGER = Logger.getLogger(AbstractUrlCollectionTag.class);
	
	private String emptyResultMessage;
	
	private Collection<URL> urls;
	private Iterator<URL> urlIterator;
	private URL currentUrl;
	
	/**
	 * Either this method XOR getUrlIterator() must be overridden by derived
	 * classes.  By default, this method returns null.  If this method is overridden
	 * then getUrlIterator() will call this method to get the URL collection.  If
	 * getUrlIterator() is overridden then this method will not be called.
	 * 
	 * @return
	 * @throws JspException
	 * @throws MissingRequiredArgumentException
	 */
	protected Collection<URL> getUrls()	throws JspException
	{
		return null;
	}

	/**
	 * Either this method XOR getUrls() must be overridden by derived classes.
	 * 
	 * @return
	 * @throws JspException
	 */
	protected Iterator<URL> getUrlIterator() throws JspException
	{
		this.urls = getUrls();
		return this.urls == null ? null : this.urls.iterator();
	}
	
	/**
	 * The message to show if the site list is empty
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
	
	// ==============================================================================
	// JSP Tag Lifecycle Events
	// ==============================================================================

	/**
	 * Create and expose the current RequestContext. Delegates to
	 * {@link #doStartTagInternal()} for actual work.
	 * 
	 * @see #REQUEST_CONTEXT_PAGE_ATTRIBUTE
	 * @see org.springframework.web.servlet.support.JspAwareRequestContext
	 */
	public final int doStartTag() throws JspException
	{
		this.urlIterator = getUrlIterator();
		
		if(this.urlIterator != null && this.urlIterator.hasNext())
		{
				currentUrl = urlIterator.next();
				return BodyTag.EVAL_BODY_INCLUDE;
		}
		else
		{
			if(getEmptyResultMessage() != null)
				try
				{
					pageContext.getOut().write(getEmptyResultMessage());
				}
    			catch(IOException ioX)
				{
                    LOGGER.warn("AbstractUrlCollectionTag.doStartTag() --> Unable to write empty result set message: {}", ioX.getMessage());
    			}
	    		
				this.currentUrl = null;
		}
		
		return BodyTag.SKIP_BODY;
	}

	/**
	 * 
	 * @return
	 */
	public URL getCurrentUrl()
	{
		return this.currentUrl;
	}
	
	@Override
    public int doAfterBody() throws JspException
    {
		if(this.urlIterator != null && this.urlIterator.hasNext())
		{
			this.currentUrl = this.urlIterator.next();
			return IterationTag.EVAL_BODY_AGAIN;
		}
		else
		{
			this.currentUrl = null;
			return IterationTag.SKIP_BODY;
		}
    }
}
