/**
 */
package gov.va.med.imaging.dx.datasource.interactive.commands;

import java.net.URL;
import gov.va.med.OID;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.imaging.dx.datasource.configuration.DxSiteConfiguration;
import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.interactive.Command;
import gov.va.med.interactive.CommandParametersDescription;
import gov.va.med.interactive.CommandProcessor;

/**
 * @author vhaisltjahjb
 *
 */
public class TruststoreCommand
extends Command<DxDataSourceConfiguration>
{
	private static final CommandParametersDescription<?>[] commandParametersDescription = 
		new CommandParametersDescription[]
		{
			new CommandParametersDescription<String>("url", String.class, true), 
			new CommandParametersDescription<String>("password", String.class, true), 
		};
	public static CommandParametersDescription<?>[] getCommandParametersDescription()
	{
		return commandParametersDescription;
	}
	
	/**
	 * 
	 */
	public TruststoreCommand()
	{
		super();
	}

	/**
	 * @param commandParameterValues
	 */
	public TruststoreCommand(String[] commandParameterValues)
	{
		super(commandParameterValues);
	}

	@Override
	public void processCommand(CommandProcessor<DxDataSourceConfiguration> processor, DxDataSourceConfiguration config) 
	throws Exception
	{
		String[] commandParameters = getCommandParameterValues();

		this.validateParameters(commandParameters);
		
		config.setTruststoreUrl(commandParameters[0]);
		config.setTruststorePassword(new EncryptedConfigurationPropertyString(commandParameters[1]));
	}
}
