
package gov.va.med.imaging.transactions;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Administrator
 *
 */
public class TransactionLogStatsSearchableCommandGroup
{
	private final String name;
	private final List<TransactionLogStatsSearchableCommand> commands = 
		new ArrayList<TransactionLogStatsSearchableCommand>();
	
	/**
	 * @param name
	 */
	public TransactionLogStatsSearchableCommandGroup(String name)
	{
		super();
		this.name = name;
	}

	/**
	 * @return the name
	 */
	public String getName()
	{
		return name;
	}

	/**
	 * @return the commands
	 */
	public List<TransactionLogStatsSearchableCommand> getCommands()
	{
		return commands;
	}

}
