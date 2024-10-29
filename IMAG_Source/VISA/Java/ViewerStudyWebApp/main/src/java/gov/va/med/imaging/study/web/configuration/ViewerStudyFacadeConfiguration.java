/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.configuration;

import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.webservices.clinical.AbstractClinicalWebAppConfiguration;

/**
 * @author Julian
 *
 */
public class ViewerStudyFacadeConfiguration
extends AbstractClinicalWebAppConfiguration
{
	private String siteServiceUrl;
	private String cvixSiteNumber;

	public ViewerStudyFacadeConfiguration()
	{
		super(true);
	}
	
	
	public synchronized static ViewerStudyFacadeConfiguration getConfiguration()
	{
		try
		{
			return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(ViewerStudyFacadeConfiguration.class);
		}
		catch(CannotLoadConfigurationException clcX)
		{
			// no need to log, already logged
			return null;
		}
	}

	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration()
	{
		super.loadDefaultConfiguration();
		this.siteServiceUrl = "http://siteserver.vista.med.va.gov/VistaWebSvcs/ImagingExchangeSiteService.asmx";
		this.cvixSiteNumber = "2001";		
		return this;
	}
	
	public static void main(String [] args)
	{
		ViewerStudyFacadeConfiguration config = getConfiguration();
		
		if(args.length == 2)
		{
			config.setSiteServiceUrl(args[0]);
			config.setCvixSiteNumber(args[1]);
			config.storeConfiguration();
		}
		else
		{
			System.out.println("Requires 2 parameters <Site Service URL> <CVIX SiteNumber>");
		}
	}


	public String getSiteServiceUrl()
	{
		return siteServiceUrl;
	}

	public void setSiteServiceUrl(String siteServiceUrl)
	{
		this.siteServiceUrl = siteServiceUrl;
	}

	public String getCvixSiteNumber()
	{
		return cvixSiteNumber;
	}

	public void setCvixSiteNumber(String cvixSiteNumber)
	{
		this.cvixSiteNumber = cvixSiteNumber;
	}


}
