/**
 */
package gov.va.med.imaging.dx.datasource.interactive.commands;

import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.interactive.Command;
import gov.va.med.interactive.CommandParametersDescription;
import gov.va.med.interactive.CommandProcessor;

/**
 * @author vhaisltjahjb
 *
 */
public class TlsCommand
extends Command<DxDataSourceConfiguration>
{
	private static final CommandParametersDescription<?>[] commandParametersDescription = 
		new CommandParametersDescription[]
		{
			new CommandParametersDescription<String>("protocol", String.class, true), 
			new CommandParametersDescription<Integer>("port", Integer.class, true), 
		};
	public static CommandParametersDescription<?>[] getCommandParametersDescription()
	{
		return commandParametersDescription;
	}
	
	/**
	 * 
	 */
	public TlsCommand()
	{
		super();
	}

	/**
	 * @param commandParameterValues
	 */
	public TlsCommand(String[] commandParameterValues)
	{
		super(commandParameterValues);
	}

	@Override
	public void processCommand(CommandProcessor<DxDataSourceConfiguration> processor, DxDataSourceConfiguration config) 
	throws Exception
	{
		String[] commandParameters = getCommandParameterValues();

		this.validateParameters(commandParameters);
		
		config.setTLSProtocol(commandParameters[0]);
		config.setTLSPort( Integer.parseInt(commandParameters[1]) );
	}
}
