/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 8, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.clinicaldisplay.configuration;

import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.webservices.clinical.AbstractClinicalWebAppConfiguration;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayWebAppConfiguration 
extends AbstractClinicalWebAppConfiguration 
{
	private Boolean allowV2V;	
	
	public ClinicalDisplayWebAppConfiguration()
	{
		super();
		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration#loadDefaultConfiguration()
	 */
	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration() 
	{
		super.loadDefaultConfiguration();
		this.allowV2V = true;			
		return this;
	}	
	
	public synchronized static ClinicalDisplayWebAppConfiguration getConfiguration()	
	{
		try
		{
			return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(
					ClinicalDisplayWebAppConfiguration.class);
		}
		catch(CannotLoadConfigurationException clcX)
		{
			// no need to log, already logged
			return null;
		}
	}

	/**
	 * @return the allowV2V
	 */
	public Boolean getAllowV2V() {
		return allowV2V;
	}

	/**
	 * @param allowV2V the allowV2V to set
	 */
	public void setAllowV2V(Boolean allowV2V) {
		this.allowV2V = allowV2V;
	}		

	public static void main(String [] args)
	{
		ClinicalDisplayWebAppConfiguration config = getConfiguration();
		config.storeConfiguration();
	}
}
