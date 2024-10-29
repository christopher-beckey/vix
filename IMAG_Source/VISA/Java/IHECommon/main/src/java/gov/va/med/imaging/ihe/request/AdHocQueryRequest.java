/**
 * 
 */
package gov.va.med.imaging.ihe.request;

import gov.va.med.imaging.ihe.TransactionType;

/**
 * A query request that includes SQL or XML query, i.e. is not a stored query.
 * 
 * @author vhaiswbeckec
 *
 */
public class AdHocQueryRequest
extends QueryRequest
{
	/**
	 * @param transactionType
	 */
	public AdHocQueryRequest(TransactionType transactionType)
	{
		super(transactionType);
	}

}
