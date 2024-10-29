/**
 * 
 */
package gov.va.med.imaging.ihe.request;

import gov.va.med.imaging.ihe.IheUUID;
import gov.va.med.imaging.ihe.TransactionType;

/**
 * @author vhaiswbeckec
 *
 */
public class FindDocumentStoredQueryRequest
extends StoredQueryRequest
{
	/**
	 * @param transactionType
	 * @param queryUUID
	 * @param maxResults
	 * @param returnComposedObject
	 * @param parameters
	 */
	public FindDocumentStoredQueryRequest(
			TransactionType transactionType,
			long maxResults, 
			boolean returnComposedObject,
			StoredQueryParameterList parameters)
	{
		super(transactionType, IheUUID.FIND_DOCUMENTS_UUID.getUrn(), maxResults, returnComposedObject, parameters);
	}

}
