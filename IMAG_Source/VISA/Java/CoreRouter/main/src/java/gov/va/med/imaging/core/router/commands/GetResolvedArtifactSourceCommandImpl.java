/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * A command that finds the ArtifactSource(s) that a RoutingToken
 * will be directed to.
 * 
 * @author vhaiswbeckec
 *
 */
public class GetResolvedArtifactSourceCommandImpl
extends AbstractCommandImpl<List<ResolvedArtifactSource>>
{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(GetResolvedArtifactSourceCommandImpl.class);

	private final RoutingToken routingToken;
	
	public GetResolvedArtifactSourceCommandImpl(RoutingToken routingToken)
	{
		this.routingToken = routingToken;
	}
	
	public RoutingToken getRoutingToken()
	{
		return this.routingToken;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public List<ResolvedArtifactSource> callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException
	{
		List<ResolvedArtifactSource> artifactSources = new ArrayList<ResolvedArtifactSource>(1);
        try
        {
        	ResolvedArtifactSource resolvedArtifactSource = 
        		getCommandContext().getSiteResolver().resolveArtifactSource(getRoutingToken());
        	if(resolvedArtifactSource != null)
        		artifactSources.add(resolvedArtifactSource);
        } 
        
        catch (MethodException me)
        {
        	String msg = "GetResolvedArtifactSourceCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to to resolve routing token [" + this.routingToken + "]: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "GetResolvedArtifactSourceCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source for routing token [" + this. routingToken + "]: " + ce.getMessage();
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
		if(this.getClass().isInstance(obj))
			return getRoutingToken().equals( ((GetResolvedArtifactSourceCommandImpl)obj).routingToken );
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return "Routing token: " + this.routingToken.toString();
	}
}
