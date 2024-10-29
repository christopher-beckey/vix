/**
 * 
 * Date Created: Apr 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands.provider;

import gov.va.med.imaging.core.interfaces.router.CommandContext;
import gov.va.med.imaging.router.cache.ImagingCacheContextImpl;

/**
 * @author vhaisltjahjb
 *
 */
public class ViewerImagingCommandContextImpl
extends ImagingCacheContextImpl
implements ViewerImagingCommandContext, CommandContext
{
	
	public ViewerImagingCommandContextImpl(CommandContext commandContext)
	{
		super(commandContext);
	}
}