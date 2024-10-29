/**
 * 
 * 
 * Date Created: Jan 17, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.ingest.transactions;

import gov.va.med.imaging.transactions.TransactionLogStatsProvider;
import gov.va.med.imaging.transactions.TransactionLogStatsSearchableCommandGroup;

/**
 * @author Administrator
 *
 */
public class IngestTransactionLogStatsProvider
extends TransactionLogStatsProvider
{

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.transactions.TransactionLogStatsProvider#getSearchableCommandGroup()
	 */
	@Override
	public TransactionLogStatsSearchableCommandGroup getSearchableCommandGroup()
	{
		return IngestTransactionLogStatsConfiguration.getConfiguration().getGroup();
	}

}
