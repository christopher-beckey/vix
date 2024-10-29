/**
 * 
 * Date Created: Apr 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands.provider;

import gov.va.med.imaging.core.CommandCreatorProvider;
import gov.va.med.imaging.core.interfaces.router.CommandContext;

/**
 * @author vhaisltjahjb
 *
 */
public class ViewerImagingCommandCreatorProvider
extends CommandCreatorProvider
{

	public ViewerImagingCommandCreatorProvider()
	{
		// must have default constructor
	}

	@Override
	protected String[] getCommandPackageNames() 
	{
		return new String []
           {
				"gov.va.med.imaging.viewer.router.commands"
           };
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.CommandFactoryProviderImpl#getCommandContext(gov.va.med.imaging.core.interfaces.router.CommandContext)
	 */
	@Override
	protected CommandContext getCommandContext(CommandContext baseCommandContext) 
	{
		return new ViewerImagingCommandContextImpl(baseCommandContext);
	}
}
