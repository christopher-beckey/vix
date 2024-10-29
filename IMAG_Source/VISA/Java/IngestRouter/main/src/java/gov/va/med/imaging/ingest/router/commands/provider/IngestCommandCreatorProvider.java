/**
 * 
 * 
 * Date Created: Dec 6, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.ingest.router.commands.provider;


import gov.va.med.imaging.core.CommandCreatorProvider;
import gov.va.med.imaging.core.interfaces.router.CommandContext;

/**
 * @author Administrator
 *
 */
public class IngestCommandCreatorProvider
extends CommandCreatorProvider
{

	public IngestCommandCreatorProvider()
	{
		// must have default constructor
	}

	@Override
	protected String[] getCommandPackageNames() 
	{
		return new String []
           {
				"gov.va.med.imaging.ingest.router.commands"
           };
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.CommandFactoryProviderImpl#getCommandContext(gov.va.med.imaging.core.interfaces.router.CommandContext)
	 */
	@Override
	protected CommandContext getCommandContext(CommandContext baseCommandContext) 
	{
		return baseCommandContext;
	}
}
