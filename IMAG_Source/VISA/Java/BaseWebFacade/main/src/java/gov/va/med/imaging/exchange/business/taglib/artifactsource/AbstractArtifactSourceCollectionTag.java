/**
 * 
 */
package gov.va.med.imaging.exchange.business.taglib.artifactsource;

import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.exchange.business.taglib.exceptions.MissingRequiredArgumentException;
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
public abstract class AbstractArtifactSourceCollectionTag
extends BodyTagSupport
{
	private static final long serialVersionUID = 1L;
	private final static Logger LOGGER = Logger.getLogger(AbstractArtifactSourceCollectionTag.class);
	private String emptyResultMessage;
	
	private Collection<ResolvedArtifactSource> artifactSources;
	private Iterator<ResolvedArtifactSource> artifactSourceIterator;
	private ResolvedArtifactSource currentResolvedArtifactSource;
	private ArtifactSource currentArtifactSource;
	
	protected abstract Collection<ResolvedArtifactSource> getArtifactSources()
	throws JspException, MissingRequiredArgumentException;
	
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
		try
        {
			this.artifactSources = getArtifactSources();
        } 
		catch (MissingRequiredArgumentException e)
        {
            LOGGER.warn("AbstractArtifactSourceCollectionTag.doStartTag() --> Encountered MissingRequiredArgumentException exception: {}", e.getMessage());
			
        	// Fortify change: can't expose messages for some reason
			try
			{
				pageContext.getOut().write("Encountered MissingRequiredArgumentException exception");
			}
			catch (IOException ioX)
			{
                LOGGER.error("AbstractArtifactSourceCollectionTag.doStartTag() --> Unable to write excpetion message: {}", ioX.getMessage());
				throw new JspException("AbstractArtifactSourceCollectionTag.doStartTag() --> Unable to write exception message", ioX);
			}
			
			return BodyTag.SKIP_BODY;
        }
		
		if(artifactSources == null || artifactSources.size() < 1)
		{
	    	if(getEmptyResultMessage() != null)
	    		try
	    		{
	    			pageContext.getOut().write(getEmptyResultMessage());
	    		}
	    		catch(IOException ioX)
	    		{
                    LOGGER.warn("AbstractArtifactSourceCollectionTag.doStartTag() --> Unable to write empty result set message: {}", ioX.getMessage());
	    		}
	    		
			return BodyTag.SKIP_BODY;
		}
		
		this.artifactSourceIterator = this.artifactSources.iterator();
		this.currentResolvedArtifactSource = this.artifactSourceIterator.next();
		this.currentArtifactSource = this.currentResolvedArtifactSource.getArtifactSource();
		
		return BodyTag.EVAL_BODY_INCLUDE;
	}

	/**
	 * 
	 * @return
	 */
	public ArtifactSource getCurrentArtifactSource()
	{
		return this.currentArtifactSource;
	}
	
	public ResolvedArtifactSource getCurrentResolvedArtifactSource()
	{
		return this.currentResolvedArtifactSource;
	}
	
	@Override
    public int doAfterBody() throws JspException
    {
		if(this.artifactSourceIterator != null && this.artifactSourceIterator.hasNext())
		{
			this.currentResolvedArtifactSource = this.artifactSourceIterator.next();
			this.currentArtifactSource = this.currentResolvedArtifactSource.getArtifactSource();
			return IterationTag.EVAL_BODY_AGAIN;
		}
		else
		{
			this.currentResolvedArtifactSource = null;
			this.currentArtifactSource = null;
			return IterationTag.SKIP_BODY;
		}
    }
}
