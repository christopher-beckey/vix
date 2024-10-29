/**
 */
package gov.va.med.imaging.dx.datasource.interactive.commands;

import gov.va.med.OID;
import gov.va.med.URLComponentMerger;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.dx.datasource.DxDocumentSetDataSourceService;
import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.imaging.dx.datasource.configuration.DxSiteConfiguration;
import gov.va.med.interactive.Command;
import gov.va.med.interactive.CommandParametersDescription;
import gov.va.med.interactive.CommandProcessor;

/**
 * @author vhaisltjahjb
 *
 */
public class AddSiteCommand
extends Command<DxDataSourceConfiguration>
{
	private final static String NULL_PARAMETER = "null";
	
	private static final CommandParametersDescription<?>[] commandParametersDescription = 
		new CommandParametersDescription[]
		{
			new CommandParametersDescription<String>("homeCommunityId", String.class, true), 
			new CommandParametersDescription<String>("repositoryId", String.class, true), 
			new CommandParametersDescription<String>("queryProtocol", String.class, true),
			new CommandParametersDescription<String>("queryUsername", String.class, true),
			new CommandParametersDescription<String>("queryPassword", String.class, true),
			new CommandParametersDescription<String>("queryHost", String.class, true),
			new CommandParametersDescription<Integer>("queryPort", Integer.class, true),
			new CommandParametersDescription<String>("queryFile", String.class, true),
			new CommandParametersDescription<String>("retrieveProtocol", String.class, true),
			new CommandParametersDescription<String>("retrieveUsername", String.class, true),
			new CommandParametersDescription<String>("retrievePassword", String.class, true),
			new CommandParametersDescription<String>("retrieveHost", String.class, true),
			new CommandParametersDescription<Integer>("retrievePort", Integer.class, true),
			new CommandParametersDescription<String>("retrieveFile", String.class, true)
		};
	public static CommandParametersDescription<?>[] getCommandParametersDescription()
	{
		return commandParametersDescription;
	}
	
	/**
	 * 
	 */
	public AddSiteCommand()
	{
		super();
	}

	/**
	 * @param commandParameterValues
	 */
	public AddSiteCommand(String[] commandParameterValues)
	{
		super(commandParameterValues);
	}

	@Override
	public void processCommand(CommandProcessor<DxDataSourceConfiguration> processor, DxDataSourceConfiguration config) 
	throws Exception
	{
		String[] commandParameters = getCommandParameterValues();

		this.validateParameters(commandParameters);
		
		String homeCommunity = commandParameters[0];
		WellKnownOID wellKnownOID = WellKnownOID.getOrValueOf(homeCommunity.toUpperCase());
		OID homeCommunityOID = wellKnownOID == null ? OID.create(homeCommunity) : wellKnownOID.getCanonicalValue();
		
		String repositoryId = commandParameters[1];
		
		String queryProtocol = commandParameters[2];
		String queryUsername = commandParameters[3];
		
		String queryPassword = null;
		if(commandParameters[4] != null ) {
			queryPassword = commandParameters[4];
		}
		
		String queryHost = commandParameters[5];
		Integer queryPort = (Integer)getCommandParametersDescription("queryPort").getValue( commandParameters[6] );
		String queryFile = commandParameters[7];
		
		String retrieveProtocol = commandParameters[8];
		String retrieveUsername = commandParameters[9];
		
		String retrievePassword = null;
		if(commandParameters[10] != null ) {
			retrievePassword = commandParameters[10];
		}
		
		String retrieveHost = commandParameters[11];		
		Integer retrievePort = (Integer)getCommandParametersDescription("retrievePort").getValue( commandParameters[12] );
		String retrieveFile = commandParameters[13];

		URLComponentMerger queryMerger = new URLComponentMerger(
			NULL_PARAMETER.equals(queryProtocol) ? DxDocumentSetDataSourceService.SUPPORTED_PROTOCOL : queryProtocol,
			NULL_PARAMETER.equals(queryUsername) ? null : queryUsername,
			queryPassword,
			NULL_PARAMETER.equals(queryHost) ? null : queryHost, 
			queryPort.intValue(), 
			NULL_PARAMETER.equals(queryFile) ? null : queryFile,
			URLComponentMerger.URLComponentMergerPrecedence.MergerComponentsFirst);
		
		URLComponentMerger retrieveMerger = new URLComponentMerger(
			NULL_PARAMETER.equals(retrieveProtocol) ? DxDocumentSetDataSourceService.SUPPORTED_PROTOCOL : retrieveProtocol,
			NULL_PARAMETER.equals(retrieveUsername) ? null : retrieveUsername,
			retrievePassword,
			NULL_PARAMETER.equals(retrieveHost) ? null : retrieveHost, 
			retrievePort.intValue(), 
			NULL_PARAMETER.equals(retrieveFile) ? null : retrieveFile,
			URLComponentMerger.URLComponentMergerPrecedence.MergerComponentsFirst);
		
		DxSiteConfiguration siteConfiguration = DxSiteConfiguration.create(
			homeCommunityOID, repositoryId,
			queryMerger, retrieveMerger );
		
		config.add(siteConfiguration);
	}
}
