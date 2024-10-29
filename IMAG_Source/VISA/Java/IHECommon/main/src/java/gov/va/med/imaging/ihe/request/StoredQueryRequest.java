/**
 * 
 */
package gov.va.med.imaging.ihe.request;

import gov.va.med.imaging.ihe.TransactionType;

/**
 * Encapsulates the parameters passed in a stored query request, either
 * an ITI-18 or ITI-39 in IHE Transactions world.
 * 
 * @author vhaiswbeckec
 *
 */
public abstract class StoredQueryRequest
extends QueryRequest
{
	private final long maxResults;
	private final boolean returnComposedObject;
	private final java.net.URI queryUUID;
	private final StoredQueryParameterList parameters;
	
	/**
	 * @param maxResults
	 * @param returnComposedObject
	 */
	public StoredQueryRequest(
			TransactionType transactionType, 
			java.net.URI queryUUID, 
			long maxResults, 
			boolean returnComposedObject, 
			StoredQueryParameterList parameters)
	{
		super(transactionType);
		this.queryUUID = queryUUID;
		this.maxResults = maxResults;
		this.returnComposedObject = returnComposedObject;
		this.parameters = parameters;
	}
	
	public java.net.URI getQueryUUID()
	{
		return this.queryUUID;
	}

	public long getMaxResults()
	{
		return this.maxResults;
	}
	
	public boolean isReturnComposedObject()
	{
		return this.returnComposedObject;
	}

	public StoredQueryParameterList getParameters()
	{
		return this.parameters;
	} 
	
}
