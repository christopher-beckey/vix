/**
 * 
 */
package gov.va.med.imaging.ihe.request;

import gov.va.med.imaging.ihe.TransactionType;

/**
 * An encapsulation of a IHE request, probably from a web service call.
 * This is the abstract root class of all requests, specific concrete types
 * are constructed by a RequestFactory implementation.
 * 
 * @author vhaiswbeckec
 *
 */
public abstract class Request
{
	private final TransactionType transactionType;

	/**
	 * @param transactionType
	 */
	public Request(TransactionType transactionType)
	{
		super();
		this.transactionType = transactionType;
	}

	public TransactionType getTransactionType()
	{
		return this.transactionType;
	}
}
