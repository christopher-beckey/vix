/**
 */
package gov.va.med.imaging.dx.datasource.interactive.commands;

import gov.va.med.OID;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.interactive.Command;
import gov.va.med.interactive.CommandParametersDescription;
import gov.va.med.interactive.CommandProcessor;

/**
 * @author vhaisltjahjb
 *
 */
public class RemoveSiteCommand
extends Command<DxDataSourceConfiguration>
{
	private static CommandParametersDescription<?>[] commandParametersDescription = new CommandParametersDescription[]
  	{
  		new CommandParametersDescription<String>("homeCommunityId", String.class, true),
  		new CommandParametersDescription<String>("repositoryId", String.class, true)
  	};
  	public static CommandParametersDescription<?>[] getCommandParametersDescription()
  	{
  		return commandParametersDescription;
  	}
  	

	/* (non-Javadoc)
	 * @see gov.va.med.interactive.Command#processCommand(gov.va.med.interactive.CommandProcessor, java.lang.Object)
	 */
	@Override
	public void processCommand(CommandProcessor<DxDataSourceConfiguration> processor, DxDataSourceConfiguration config)
	throws Exception
	{
		String[] commandParameters = getCommandParameterValues();

		this.validateParameters(commandParameters);
		
		String homeCommunity = commandParameters[0];
		WellKnownOID wellKnownOID = WellKnownOID.valueOf(homeCommunity.toUpperCase());
		OID homeCommunityOID = wellKnownOID == null ? OID.create(homeCommunity) : wellKnownOID.getCanonicalValue();
		
		String repositoryId = commandParameters[1];
		
		config.remove(homeCommunityOID, repositoryId);
	}

}
