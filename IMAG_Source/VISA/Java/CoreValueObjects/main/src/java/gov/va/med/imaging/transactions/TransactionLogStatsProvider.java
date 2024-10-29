
package gov.va.med.imaging.transactions;

import java.util.ArrayList;
import java.util.List;
import java.util.ServiceLoader;

/**
 * @author Administrator
 *
 */
public abstract class TransactionLogStatsProvider
{
	public abstract TransactionLogStatsSearchableCommandGroup getSearchableCommandGroup();


	public static List<TransactionLogStatsSearchableCommandGroup> getAllSearchableCommandGroups()
	{
		ServiceLoader<TransactionLogStatsProvider> provider = ServiceLoader.load(TransactionLogStatsProvider.class);
		List<TransactionLogStatsSearchableCommandGroup> result = new ArrayList<TransactionLogStatsSearchableCommandGroup>();
		
		for(TransactionLogStatsProvider statsProvider : provider)
		{
			
			result.add(statsProvider.getSearchableCommandGroup());
		}
		
		return result;
	}
}
