/**
 */
package gov.va.med.imaging.dx.datasource.interactive.commands;

import java.net.URL;
import gov.va.med.OID;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.imaging.dx.datasource.configuration.DxSiteConfiguration;
import gov.va.med.interactive.Command;
import gov.va.med.interactive.CommandParametersDescription;
import gov.va.med.interactive.CommandProcessor;

/**
 * @author vhaisltjahjb
 *
 */
public class ClearCommand
extends Command<DxDataSourceConfiguration>
{
	private static final CommandParametersDescription<?>[] commandParametersDescription = 
		new CommandParametersDescription[]
		{
		};
	public static CommandParametersDescription<?>[] getCommandParametersDescription()
	{
		return commandParametersDescription;
	}
	
	/**
	 * 
	 */
	public ClearCommand()
	{
		super();
	}

	/**
	 * @param commandParameterValues
	 */
	public ClearCommand(String[] commandParameterValues)
	{
		super(commandParameterValues);
	}

	@Override
	public void processCommand(CommandProcessor<DxDataSourceConfiguration> processor, DxDataSourceConfiguration config) 
	throws Exception
	{
		config.clear();
	}
}
