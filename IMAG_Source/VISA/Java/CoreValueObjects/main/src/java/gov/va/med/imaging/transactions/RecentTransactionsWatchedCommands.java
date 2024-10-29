
package gov.va.med.imaging.transactions;

import gov.va.med.imaging.access.TransactionLogEntry;

/**
 * @author Julian
 *
 */
public class RecentTransactionsWatchedCommands
{
	private final String commandClassName;
	private final String queryType;
	
	/**
	 * @param commandClassName
	 * @param queryType
	 */
	public RecentTransactionsWatchedCommands(String commandClassName,
		String queryType)
	{
		super();
		this.commandClassName = commandClassName;
		this.queryType = queryType;
	}
	
	public boolean isTransactionIncluded(TransactionLogEntry entry)
	{
		if(entry == null)
			return false;
		String queryType = entry.getQueryType();
		if(queryType == null)
			return false;
		
		if(commandClassName.equals(entry.getCommandClassName()) && queryType.startsWith(this.queryType))
			return true;
		return false;
	}

	/**
	 * @return the commandClassName
	 */
	public String getCommandClassName()
	{
		return commandClassName;
	}

	/**
	 * @return the queryType
	 */
	public String getQueryType()
	{
		return queryType;
	}
	
	

}
