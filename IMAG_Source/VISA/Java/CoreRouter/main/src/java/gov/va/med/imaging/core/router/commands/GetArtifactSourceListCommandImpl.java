/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;

import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswbeckec
 *
 */
public class GetArtifactSourceListCommandImpl
extends AbstractCommandImpl<List<ArtifactSource>>
{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(GetArtifactSourceListCommandImpl.class);

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public List<ArtifactSource> callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException
	{
		List<ArtifactSource> artifactSources = null;
        try
        {
        	artifactSources = getCommandContext().getSiteResolver().getAllArtifactSources();
        } 
        catch (MethodException me)
        {
        	String msg = "GetArtifactSourceListCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to resolve all regions: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "GetArtifactSourceListCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source: " + ce.getMessage();
        	logger.error(msg);
        	throw new ConnectionException(msg, ce);
        }
		return artifactSources;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return "No params";
	}
}
