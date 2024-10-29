
package gov.va.med.imaging.transactions;

import gov.va.med.imaging.access.TransactionLogEntry;

import org.apache.commons.collections.Buffer;
import org.apache.commons.collections.BufferUtils;
import org.apache.commons.collections.buffer.CircularFifoBuffer;

/**
 * @author Julian
 *
 */
public class RecentTransactions
{
	
	private final static RecentTransactionsConfiguration configuration = RecentTransactionsConfiguration.getCommandConfiguration();
	private final static Buffer fifo = BufferUtils.synchronizedBuffer(new CircularFifoBuffer(getMaxSize()));
	
	public final static int getMaxSize()
	{
		return configuration.getMaxTransactions();
	}
	
	@SuppressWarnings("unchecked")
	public static void addRecentTransactionLogEntry(TransactionLogEntry entry)
	{
		if(configuration.isEnabled() && isEntryIncluded(entry))
			fifo.add(entry);
	}
	
	@SuppressWarnings("unchecked")
	public static TransactionLogEntry [] getEntries()
	{
		if(!configuration.isEnabled())
			return null;
		synchronized(fifo)
		{
			//return (TransactionLogEntry [])fifo.toArray();
			return (TransactionLogEntry [])fifo.toArray(new TransactionLogEntry[fifo.size()]);
		}
		//return fifo.iterator();
	}
	
	public static int getSize()
	{		
		return fifo.size();
	}	
	
	private static boolean isEntryIncluded(TransactionLogEntry entry)
	{		
		return configuration.isTransactionIncluded(entry);		
	}
}
