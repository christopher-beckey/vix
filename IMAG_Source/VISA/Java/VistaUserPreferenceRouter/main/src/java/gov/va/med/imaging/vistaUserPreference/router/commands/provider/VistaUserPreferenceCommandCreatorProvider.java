/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference.router.commands.provider;

import gov.va.med.imaging.core.CommandCreatorProvider;
import gov.va.med.imaging.core.interfaces.router.CommandContext;

/**
 * @author Budy Tjahjo
 *
 */
public class VistaUserPreferenceCommandCreatorProvider
extends CommandCreatorProvider
{

	public VistaUserPreferenceCommandCreatorProvider()
	{
		// must have default constructor
	}

	@Override
	protected String[] getCommandPackageNames() 
	{
		return new String []
           {
				"gov.va.med.imaging.vistaUserPreference.router.commands"
           };
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.CommandFactoryProviderImpl#getCommandContext(gov.va.med.imaging.core.interfaces.router.CommandContext)
	 */
	@Override
	protected CommandContext getCommandContext(CommandContext baseCommandContext) {
		return baseCommandContext;
	}

}
