/**
 * 
 */
package gov.va.med.imaging.presentation.state.router.commands.provider;

import gov.va.med.imaging.core.CommandCreatorProvider;
import gov.va.med.imaging.core.interfaces.router.CommandContext;

/**
 * @author William Peterson
 *
 */
public class PresentationStateCommandCreatorProvider 
extends CommandCreatorProvider {

	/**
	 * 
	 */
	public PresentationStateCommandCreatorProvider() {

	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.CommandCreatorProvider#getCommandPackageNames()
	 */
	@Override
	protected String[] getCommandPackageNames() {
		return new String []
		           {
						"gov.va.med.imaging.presentation.state.router.commands"
		           };
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.CommandCreatorProvider#getCommandContext(gov.va.med.imaging.core.interfaces.router.CommandContext)
	 */
	@Override
	protected CommandContext getCommandContext(CommandContext baseCommandContext) {
		return baseCommandContext;
	}

}
