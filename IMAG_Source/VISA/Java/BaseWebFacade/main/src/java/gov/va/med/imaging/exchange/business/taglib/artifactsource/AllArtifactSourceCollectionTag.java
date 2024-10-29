/**
 * 
 */
package gov.va.med.imaging.exchange.business.taglib.artifactsource;

import gov.va.med.imaging.BaseWebFacadeRouter;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.FacadeRouterUtility;

import java.util.Collection;
import javax.servlet.jsp.JspException;
import gov.va.med.logging.Logger;

import org.springframework.web.servlet.support.RequestContext;

/**
 * @author vhaiswbeckec
 *
 */
public class AllArtifactSourceCollectionTag
extends AbstractArtifactSourceCollectionTag
{

	private static final long serialVersionUID = 1L;
	private final static Logger LOGGER = Logger.getLogger(AllArtifactSourceCollectionTag.class);
	
	/**
	 * {@link javax.servlet.jsp.PageContext} attribute for page-level
	 * {@link RequestContext} instance.
	 */
	public static final String REQUEST_CONTEXT_PAGE_ATTRIBUTE = "org.springframework.web.servlet.tags.REQUEST_CONTEXT";

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.taglib.artifactsource.AbstractArtifactSourceCollectionTag#getArtifactSources()
	 */
	@Override
	protected Collection<ResolvedArtifactSource> getArtifactSources() 
	throws JspException
	{
    	BaseWebFacadeRouter router = null;
    	// Could combine into one but requires testing.  Left as they are.
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(BaseWebFacadeRouter.class);
		} 
		catch (Exception x)
		{
            LOGGER.error("AllArtifactSourceCollectionTag.getArtifactSources() --> Unable to get BaseWebFacadeRouter implementation: {}", x.getMessage());
			throw new JspException("AllArtifactSourceCollectionTag.getArtifactSources() --> Unable to get BaseWebFacadeRouter implementation", x);
		}
    	
    	try 
    	{
    		return router.getArtifactSourceList();
    	}
    	catch(Exception ex)
    	{
            LOGGER.error("AllArtifactSourceCollectionTag.getArtifactSources() --> Unable to get Artifact Source List: {}", ex.getMessage());
			throw new JspException("AllArtifactSourceCollectionTag.getArtifactSources() --> Unable to get Artifact Source List", ex);
    	}
    }
}
