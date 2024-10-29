/**
 */
package gov.va.med.imaging.dx.datasource.interactive.commands;

import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.interactive.Command;
import gov.va.med.interactive.CommandProcessor;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswbeckec
 *
 */
public class ListSitesCommand
extends Command<DxDataSourceConfiguration>
{
	private static final Logger logger = Logger.getLogger(ListSitesCommand.class);

	/* (non-Javadoc)
	 * @see gov.va.med.interactive.Command#processCommand(gov.va.med.interactive.CommandProcessor, java.lang.Object)
	 */
	@Override
	public void processCommand(CommandProcessor<DxDataSourceConfiguration> processor, DxDataSourceConfiguration config)
	throws Exception
	{
		logger.info(config.toString());
	}

}
