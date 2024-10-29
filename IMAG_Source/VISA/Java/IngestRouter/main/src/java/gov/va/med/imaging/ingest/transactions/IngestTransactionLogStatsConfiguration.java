/**
 * 
 * 
 * Date Created: Jan 17, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.ingest.transactions;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.transactions.AbstractTransactionLogStatsGroupConfiguration;
import gov.va.med.imaging.transactions.TransactionLogStatsSearchableCommand;
import gov.va.med.imaging.transactions.TransactionLogStatsSearchableCommandGroup;

/**
 * @author Administrator
 *
 */
public class IngestTransactionLogStatsConfiguration
extends AbstractTransactionLogStatsGroupConfiguration
{
	public synchronized static IngestTransactionLogStatsConfiguration getConfiguration()	
	{
		try
		{
			return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(
				IngestTransactionLogStatsConfiguration.class);
		}
		catch(CannotLoadConfigurationException clcX)
		{
			// no need to log, already logged
			return null;
		}
	}
	
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.transactions.AbstractTransactionLogStatsGroupConfiguration#loadDefaultConfiguration()
	 */
	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration()
	{
		List<TransactionLogStatsSearchableCommand> result = new ArrayList<TransactionLogStatsSearchableCommand>();
		result.add(new TransactionLogStatsSearchableCommand("PostIngestImageCommandImpl", 
			"Adds a new image to be stored", true, true));		

		this.group = new TransactionLogStatsSearchableCommandGroup("Ingest");
		group.getCommands().addAll(result);
		return this;
	}


	public static void main(String [] args)
	{
		getConfiguration().storeConfiguration();
	}

}
