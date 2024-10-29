/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 16, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.study.configuration;

import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.webservices.clinical.AbstractClinicalWebAppConfiguration;

/**
 * @author VHAISWWERFEJ
 *
 */
public class StudyFacadeConfiguration
extends AbstractClinicalWebAppConfiguration
{
	private String siteServiceUrl;
	private String cvixSiteNumber;
	
	
	public StudyFacadeConfiguration()
	{
		super();
	}
	
	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration()
	{
		super.loadDefaultConfiguration();
		this.siteServiceUrl = "http://siteserver.vista.med.va.gov/VistaWebSvcs/ImagingExchangeSiteService.asmx";
		this.cvixSiteNumber = "2001";		
		return this;
	}

	public synchronized static StudyFacadeConfiguration getConfiguration()	
	{
		try
		{
			return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(
					StudyFacadeConfiguration.class);
		}
		catch(CannotLoadConfigurationException clcX)
		{
			// no need to log, already logged
			return null;
		}
	}

	public static void main(String [] args)
	{
		StudyFacadeConfiguration config = getConfiguration();
		
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
