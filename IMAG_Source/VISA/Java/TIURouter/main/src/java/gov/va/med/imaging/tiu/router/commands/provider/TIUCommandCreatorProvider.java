/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands.provider;

import gov.va.med.imaging.core.CommandCreatorProvider;
import gov.va.med.imaging.core.interfaces.router.CommandContext;

/**
 * @author Julian Werfel
 *
 */
public class TIUCommandCreatorProvider
extends CommandCreatorProvider
{

	public TIUCommandCreatorProvider()
	{
		// must have default constructor
	}

	@Override
	protected String[] getCommandPackageNames() 
	{
		return new String []
           {
				"gov.va.med.imaging.tiu.router.commands"
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