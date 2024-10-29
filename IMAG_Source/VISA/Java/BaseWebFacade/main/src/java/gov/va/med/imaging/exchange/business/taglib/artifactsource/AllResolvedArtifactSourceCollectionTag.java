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
public class AllResolvedArtifactSourceCollectionTag
extends AbstractResolvedArtifactSourceCollectionTag
{
	private static final long serialVersionUID = 1L;

	/**
	 * {@link javax.servlet.jsp.PageContext} attribute for page-level
	 * {@link RequestContext} instance.
	 */
	public static final String REQUEST_CONTEXT_PAGE_ATTRIBUTE = "org.springframework.web.servlet.tags.REQUEST_CONTEXT";

	private static final Logger LOGGER = Logger.getLogger(AllResolvedArtifactSourceCollectionTag.class);

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.taglib.artifactsource.AbstractArtifactSourceCollectionTag#getArtifactSources()
	 */
	@Override
	protected Collection<ResolvedArtifactSource> getResolvedArtifactSources() 
	throws JspException
	{
    	BaseWebFacadeRouter router = null;
    	
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(BaseWebFacadeRouter.class);
		} 
		catch (Exception x)
		{
            LOGGER.error("AllArtifactSourceCollectionTag.getArtifactSources() --> Unable to get BaseWebFacadeRouter implementation:{}", x.getMessage());
			throw new JspException("AllResolvedArtifactSourceCollectionTag.getResolvedArtifactSources() --> Unable to get BaseWebFacadeRouter implementation", x);
		}
    	
    	try 
    	{
    		return router.getResolvedArtifactSourceList();
    	}
    	catch(Exception ex)
    	{
            LOGGER.error("AllArtifactSourceCollectionTag.getArtifactSources() --> Unable to get resolved Artifact Source List:{}", ex.getMessage());
			throw new JspException("AllResolvedArtifactSourceCollectionTag.getResolvedArtifactSources() --> Unable to get resolved Artifact Source List", ex);
    	}
    }
}
