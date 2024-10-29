/**
 */
package gov.va.med.imaging.dx.datasource.interactive.commands;

import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.dx.datasource.configuration.DxDataSourceConfiguration;
import gov.va.med.interactive.Command;
import gov.va.med.interactive.CommandProcessor;

/**
 * @author vhaisltjahjb
 *
 */
public class SaveCommand
extends Command<DxDataSourceConfiguration>
{
	private Provider provider;

	/**
	 * @see gov.va.med.interactive.Command#processCommand(gov.va.med.interactive.CommandProcessor, java.lang.Object)
	 */
	@Override
	public void processCommand(CommandProcessor<DxDataSourceConfiguration> processor, DxDataSourceConfiguration config)
	throws Exception
	{
		getProvider().storeConfiguration();
	}

	/**
	 * @return the provider
	 */
	public Provider getProvider()
	{
		return this.provider;
	}

	/**
	 * @param provider the provider to set
	 */
	public void setProvider(Provider provider)
	{
		this.provider = provider;
	}
}
