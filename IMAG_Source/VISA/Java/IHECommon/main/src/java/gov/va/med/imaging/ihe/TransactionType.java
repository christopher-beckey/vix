/**
 * 
 */
package gov.va.med.imaging.ihe;

/**
 * @author vhaiswbeckec
 *
 */
public enum TransactionType
{
	CrossGatewayQuery(38),
	CrossGatewayRetrieve(39);
	
	private final int transactionNumber;
	
	TransactionType(int transactionNumber)
	{
		this.transactionNumber = transactionNumber;
	}

	public int getTransactionNumber()
	{
		return this.transactionNumber;
	}
}
