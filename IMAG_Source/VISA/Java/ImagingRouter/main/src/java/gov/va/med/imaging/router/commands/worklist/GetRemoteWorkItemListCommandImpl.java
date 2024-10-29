/**
 * 
 */
package gov.va.med.imaging.router.commands.worklist;
import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.core.router.worklist.InternalWorkListRouter;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author vhaisltjahjb
 * 
 * Get Work items from Data Source.
 *
 */
public class GetRemoteWorkItemListCommandImpl 
extends AbstractCommandImpl<List<WorkItem>> 
{

	private static final long serialVersionUID = 1364589895920189181L;
	private final RoutingToken routingToken;
	private final String cptCode;
	private final String idType;
	private final String patientId;
	
	public GetRemoteWorkItemListCommandImpl(
			RoutingToken routingToken,
			String idType,
			String patientId,
			String cptCode)
	{
		super();
		this.routingToken = routingToken;
		this.idType = idType;
		this.patientId = patientId;
		this.cptCode = cptCode;
	}
	
	public String getIdType()
	{
		return idType;
	}

	public String getPatientId()
	{
		return patientId;
	}

	public String getCptCode() 
	{
		return cptCode;
	}

	public RoutingToken getRoutingToken() 
	{
		return routingToken;
	}

	@Override
	public List<WorkItem> callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException 
	{
        getLogger().info("Synchronous Command [{}] - processing.", this.getClass().getSimpleName());
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setServicedSource(getRoutingToken().toRoutingTokenString());
		transactionContext.setPatientID(getPatientId());
		transactionContext.setItemCached(Boolean.FALSE);

		List<WorkItem> workItems = ImagingContext.getRouter().getRemoteWorkItemListFromDataSource(
				getRoutingToken(), 
				getIdType(), 
				getPatientId(), 
				getCptCode());
		
		return workItems;
	}

	@Override
	public boolean equals(Object obj) 
	{
		return false;
	}

	@Override
	protected String parameterToString() 
	{
		return this.getIdType() + "," + this.getPatientId() + "," + this.getCptCode();
	}


}
