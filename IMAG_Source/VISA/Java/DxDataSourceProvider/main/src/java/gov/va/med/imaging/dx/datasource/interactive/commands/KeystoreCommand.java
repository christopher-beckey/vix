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
public class KeystoreCommand
extends Command<DxDataSourceConfiguration>
{
	private static final CommandParametersDescription<?>[] commandParametersDescription = 
		new CommandParametersDescription[]
		{
			new CommandParametersDescription<String>("url", String.class, true), 
			new CommandParametersDescription<String>("password", String.class, true), 
			new CommandParametersDescription<String>("certificate", String.class, false), 
		};
	public static CommandParametersDescription<?>[] getCommandParametersDescription()
	{
		return commandParametersDescription;
	}
	
	/**
	 * 
	 */
	public KeystoreCommand()
	{
		super();
	}

	/**
	 * @param commandParameterValues
	 */
	public KeystoreCommand(String[] commandParameterValues)
	{
		super(commandParameterValues);
	}

	@Override
	public void processCommand(CommandProcessor<DxDataSourceConfiguration> processor, DxDataSourceConfiguration config) 
	throws Exception
	{
		String[] commandParameters = getCommandParameterValues();

		this.validateParameters(commandParameters);
		
		config.setKeystoreUrl(commandParameters[0]);
		config.setKeystorePassword(new EncryptedConfigurationPropertyString(commandParameters[1]));
		if(commandParameters.length > 2)
			config.setKeystoreAlias(commandParameters[2]);
	}
}
