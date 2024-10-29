/**
 * 
 */
package gov.va.med.imaging.router.commands.worklist;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.core.router.worklist.InternalWorkListRouter;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.router.facade.ImagingContext;

/**
 * @author vhaisltjahjb
 * 
 * Delete Work item Record from Data Source.
 *
 */
public class DeleteRemoteWorkItemCommandImpl 
extends AbstractCommandImpl<Boolean> 
{

	private static final long serialVersionUID = 1464588895920189181L;
	private final RoutingToken routingToken;
	private final String id;
	
	public DeleteRemoteWorkItemCommandImpl(
			RoutingToken routingToken,
			String id) 
	{
		super();
		this.routingToken = routingToken;
		this.id = id;
	}
	
	private String getWorkItemId() 
	{
		return id;
	}
	
	private RoutingToken getWKRoutingToken() 
	{
		return routingToken;
	}


	@Override
	public Boolean callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException 
	{
        getLogger().info("Synchronous Command [{}] - processing.", this.getClass().getSimpleName());
		
		return ImagingContext.getRouter().deleteRemoteWorkItemFromDataSource(
				getWKRoutingToken(), getWorkItemId());
	}

	@Override
	public boolean equals(Object obj) 
	{
		return false;
	}

	@Override
	protected String parameterToString() 
	{
		return this.id;
	}


}
