package gov.va.med.imaging.core.router.periodiccommands;

import gov.va.med.imaging.core.router.queue.ScheduledPriorityQueueElement;
import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;

import java.util.ArrayList;
import java.util.List;

public class PeriodicCommandConfiguration 
extends AbstractBaseFacadeConfiguration 
{
	public static final int STARTING_DAYS_FOR_DOD_STUDIES_DEFAULT = 30;

	private static PeriodicCommandConfiguration periodicCommandConfiguration = null;
	private List<PeriodicCommandDefinition> commandDefinitions;
	private EncryptedConfigurationPropertyString accessCode;
	private EncryptedConfigurationPropertyString verifyCode;

	public PeriodicCommandConfiguration() {
		commandDefinitions = new ArrayList<PeriodicCommandDefinition>();
	}

	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration() {
		return this;
	}

	public synchronized static PeriodicCommandConfiguration getConfiguration() {
		if (periodicCommandConfiguration == null) {
			PeriodicCommandConfiguration config = new PeriodicCommandConfiguration();
			periodicCommandConfiguration = (PeriodicCommandConfiguration) config
					.loadConfiguration();
		}
		return periodicCommandConfiguration;
	}

	public EncryptedConfigurationPropertyString getAccessCode()
	{
		return accessCode;
	}

	public void setAccessCode(EncryptedConfigurationPropertyString accessCode)
	{
		this.accessCode = accessCode;
	}

	public EncryptedConfigurationPropertyString getVerifyCode()
	{
		return verifyCode;
	}

	public void setVerifyCode(EncryptedConfigurationPropertyString verifyCode)
	{
		this.verifyCode = verifyCode;
	}

	public static void main(String[] args) {
		if (args.length < 2 || args.length%2 > 0) {
			printUsage();
			System.exit(0);
		}
		
		int startingDaysForDodStudies = STARTING_DAYS_FOR_DOD_STUDIES_DEFAULT;
		PeriodicCommandConfiguration config = PeriodicCommandConfiguration.getConfiguration();
		PeriodicCommandDefinition commandDefinition;

		for (int i=0; i < args.length; i = i + 2)
		{
			if (args[i].equals("accessCode"))
			{
				if (!args[i+1].equals("none"))
				{
					config.setAccessCode(new EncryptedConfigurationPropertyString(args[i+1]));
				}
			}
			else if (args[i].equals("verifyCode"))
			{
				if (!args[i+1].equals("none"))
				{
					config.setVerifyCode(new EncryptedConfigurationPropertyString(args[i+1]));
				}
			}
			else if (args[i].equals("startingDaysForDodStudies"))
			{
				startingDaysForDodStudies = Integer.parseInt(args[i+1]);
			}
			else
			{
				commandDefinition = new PeriodicCommandDefinition();
				commandDefinition.setReturnClass(Object.class);
				commandDefinition.setCommandClassName(args[i]);
				commandDefinition.setCommandParameters(new Object[] {});
				commandDefinition.setPeriodicDelayInterval(args[i + 1]);
				commandDefinition.setPriority(ScheduledPriorityQueueElement.Priority.NORMAL);
				config.commandDefinitions.add(commandDefinition);
			}
		}
		
		config.storeConfiguration();
		
		
		PeriodicPreCacheConfiguration preCacheConfig = PeriodicPreCacheConfiguration.getConfiguration();
		preCacheConfig.setStartingDaysForDodStudies(Integer.toString(startingDaysForDodStudies));
		preCacheConfig.storeConfiguration();
		
	}

	public List<PeriodicCommandDefinition> getCommandDefinitions() {
		return commandDefinitions;
	}

	public void setCommandDefinitions(
			List<PeriodicCommandDefinition> commandDefinitions) {
		this.commandDefinitions = commandDefinitions;
	}

    private static void printUsage() {
        System.out.println("This program requires two arguments:");
        System.out.println("  * The name of the periodic command");
        System.out.println("  * The period in seconds");
    }
    
}
