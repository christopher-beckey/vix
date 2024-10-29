/**
 * 
 */
package gov.va.med.imaging.ihe.request;

import gov.va.med.imaging.ihe.TransactionType;

/**
 * The abstract root class encapsulating the request of all query transactions.
 * 
 * @author vhaiswbeckec
 *
 */
public abstract class QueryRequest
extends Request
{

	/**
	 * @param transactionType
	 */
	public QueryRequest(TransactionType transactionType)
	{
		super(transactionType);
	}
}
