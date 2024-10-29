
package gov.va.med.imaging.transactions;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.access.TransactionLogEntry;
import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;

/**
 * @author Julian
 *
 */
public class RecentTransactionsConfiguration
extends AbstractBaseFacadeConfiguration
{
	private int maxTransactions;
	private boolean enabled;
	private List<RecentTransactionsWatchedCommands> recentTransactionsWatchedCommands = new ArrayList<RecentTransactionsWatchedCommands>();

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration#loadDefaultConfiguration()
	 */
	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration()
	{
		this.maxTransactions = 500;
		this.enabled = true;
		this.recentTransactionsWatchedCommands.add(new RecentTransactionsWatchedCommands("GetInstanceByImageUrnCommandImpl", "Clinical Display WebApp"));
		this.recentTransactionsWatchedCommands.add(new RecentTransactionsWatchedCommands("GetImageTextCommandImpl", "Clinical Display WebApp"));
		this.recentTransactionsWatchedCommands.add(new RecentTransactionsWatchedCommands("GetExamInstanceByImageUrnCommandImpl", "VistaRad WebApp"));
		this.recentTransactionsWatchedCommands.add(new RecentTransactionsWatchedCommands("GetExamTextFileByImageUrnCommandImpl", "VistaRad WebApp"));		
		return this;
	}
	
	public boolean isTransactionIncluded(TransactionLogEntry entry)
	{
		for(RecentTransactionsWatchedCommands recentWatchedCommands : recentTransactionsWatchedCommands)
		{
			if(recentWatchedCommands.isTransactionIncluded(entry))
				return true;
		}
		return false;
	}
	
	public synchronized static RecentTransactionsConfiguration getCommandConfiguration()
	{
		try
		{
			return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(RecentTransactionsConfiguration.class);
		}
		catch(CannotLoadConfigurationException clcX)
		{
			// no need to log, already logged
			return null;
		}
	}

	/**
	 * @return the maxTransactions
	 */
	public int getMaxTransactions()
	{
		return maxTransactions;
	}

	/**
	 * @param maxTransactions the maxTransactions to set
	 */
	public void setMaxTransactions(int maxTransactions)
	{
		this.maxTransactions = maxTransactions;
	}

	/**
	 * @return the recentTransactionsWatchedCommands
	 */
	public List<RecentTransactionsWatchedCommands> getRecentTransactionsWatchedCommands()
	{
		return recentTransactionsWatchedCommands;
	}

	/**
	 * @param recentTransactionsWatchedCommands the recentTransactionsWatchedCommands to set
	 */
	public void setRecentTransactionsWatchedCommands(
		List<RecentTransactionsWatchedCommands> recentTransactionsWatchedCommands)
	{
		this.recentTransactionsWatchedCommands = recentTransactionsWatchedCommands;
	}

	/**
	 * @return the enabled
	 */
	public boolean isEnabled()
	{
		return enabled;
	}

	/**
	 * @param enabled the enabled to set
	 */
	public void setEnabled(boolean enabled)
	{
		this.enabled = enabled;
	}

}
