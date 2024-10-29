/**
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.router.commands.provider;

import gov.va.med.imaging.core.CommandCreatorProvider;
import gov.va.med.imaging.core.interfaces.router.CommandContext;

/**
 * @author Administrator
 *
 */
public class IndexTermCommandCreatorProvider
extends CommandCreatorProvider
{

	public IndexTermCommandCreatorProvider()
	{
		// must have default constructor
	}

	@Override
	protected String[] getCommandPackageNames() 
	{
		return new String []
           {
				"gov.va.med.imaging.indexterm.router.commands"
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