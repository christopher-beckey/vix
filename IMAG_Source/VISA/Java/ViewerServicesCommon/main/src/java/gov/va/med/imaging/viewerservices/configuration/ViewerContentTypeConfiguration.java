package gov.va.med.imaging.viewerservices.configuration;

import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.webservices.clinical.AbstractClinicalWebAppConfiguration;


public class ViewerContentTypeConfiguration 
extends AbstractClinicalWebAppConfiguration
{
	
	public ViewerContentTypeConfiguration()
	{
		super(true);
	}
	
	private static ViewerContentTypeConfiguration viewerContentTypeConfiguration = null;
	
	public synchronized static ViewerContentTypeConfiguration getConfiguration()
	{
		try
		{
			if (viewerContentTypeConfiguration == null)
			{
				viewerContentTypeConfiguration = FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(ViewerContentTypeConfiguration.class);
			}
			return viewerContentTypeConfiguration;
		}
		catch(CannotLoadConfigurationException clcX)
		{
			// no need to log, already logged
			return null;
		}
	}
	
}