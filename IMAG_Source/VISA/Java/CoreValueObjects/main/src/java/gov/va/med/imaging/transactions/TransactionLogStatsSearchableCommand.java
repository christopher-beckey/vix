
package gov.va.med.imaging.transactions;

/**
 * @author Administrator
 *
 */
public class TransactionLogStatsSearchableCommand
{
	private final String commandName;
	private final String description;
	private final boolean includeInMessage;
	private final boolean summaryInMessage;
	
	/**
	 * @param commandName
	 * @param description
	 */
	public TransactionLogStatsSearchableCommand(String commandName,
		String description, boolean includeInMessage, boolean summaryInMessage)
	{
		super();
		this.commandName = commandName;
		this.description = description;		
		this.includeInMessage = includeInMessage;
		this.summaryInMessage = summaryInMessage;
	}
	
	/**
	 * @return the commandName
	 */
	public String getCommandName()
	{
		return commandName;
	}
	
	/**
	 * @return the description
	 */
	public String getDescription()
	{
		return description;
	}

	/**
	 * @return the includeInMessage
	 */
	public boolean isIncludeInMessage()
	{
		return includeInMessage;
	}

	/**
	 * @return the summaryInMessage
	 */
	public boolean isSummaryInMessage()
	{
		return summaryInMessage;
	}
}
