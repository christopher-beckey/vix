/**
 * 
 */
package gov.va.med.imaging.exchange.business.taglib.artifactsource;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import java.io.IOException;
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
public abstract class AbstractResolvedArtifactSourceCollectionTag
extends BodyTagSupport
{
	private static final long serialVersionUID = 1L;
	private final static Logger LOGGER = Logger.getLogger(AbstractResolvedArtifactSourceCollectionTag.class);
	
	private String emptyResultMessage;
	private Collection<ResolvedArtifactSource> resolvedArtifactSources;
	private Iterator<ResolvedArtifactSource> resolvedArtifactSourceIterator;
	private ResolvedArtifactSource currentResolvedArtifactSource;
	
	/**
	 * Override this method XOR getResolvedArtifactSourcesIterator()
	 * in derived classes.
	 * 
	 * @return
	 * @throws JspException
	 */
	protected Collection<ResolvedArtifactSource> getResolvedArtifactSources() throws JspException
	{
		return null;
	}

	/**
	 * Override this method XOR getResolvedArtifactSources()
	 * in derived classes.
	 * 
	 * @return
	 * @throws JspException
	 */
	protected Iterator<ResolvedArtifactSource> getResolvedArtifactSourcesIterator()	throws JspException
	{
		this.resolvedArtifactSources = getResolvedArtifactSources();
		return this.resolvedArtifactSources == null ? null : resolvedArtifactSources.iterator();
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
	public final int doStartTag() 
	throws JspException
	{
		this.resolvedArtifactSourceIterator = getResolvedArtifactSourcesIterator();
		if(this.resolvedArtifactSourceIterator == null || !this.resolvedArtifactSourceIterator.hasNext())
		{
			this.currentResolvedArtifactSource = null;
			
	    	if(getEmptyResultMessage() != null)
	    		try
	    		{
	    			pageContext.getOut().write(getEmptyResultMessage());
	    		}
	    		catch(IOException ioX)
	    		{
                    LOGGER.warn("AbstractResolvedArtifactSourceCollectionTag.doStartTag() --> Unable to write empty result set message: {}", ioX.getMessage());
	    		}
	    		
			return BodyTag.SKIP_BODY;
		}
		else
		{
			this.currentResolvedArtifactSource = resolvedArtifactSourceIterator.next();
			return BodyTag.EVAL_BODY_INCLUDE;
		}
	}

	/**
	 * 
	 * @return
	 */
	public ResolvedArtifactSource getCurrentResolvedArtifactSource()
	{
		return this.currentResolvedArtifactSource;
	}
	
	@Override
    public int doAfterBody() 
	throws JspException
    {
		if(this.resolvedArtifactSourceIterator != null && this.resolvedArtifactSourceIterator.hasNext())
		{
			this.currentResolvedArtifactSource = this.resolvedArtifactSourceIterator.next();
			return IterationTag.EVAL_BODY_AGAIN;
		}
		else
		{
			this.currentResolvedArtifactSource = null;
			return IterationTag.SKIP_BODY;
		}
    }
}
