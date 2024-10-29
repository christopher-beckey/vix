/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 9, 2008
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
package gov.va.med.imaging.url.mix.test;

import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;
import gov.va.med.imaging.url.mix.exceptions.MIXConfigurationException;

/**
 * @author VHAISWWERFEJ
 *
 */
public class MixConfigurationTest 
extends AbstractMixTest 
{

	public MixConfigurationTest()
	{
		super(MixConfigurationTest.class.toString());
	}
	
	public void testPersistConfigurationFile() 
	{
		MIXSiteConfiguration configuration = null;
		try 
		{
			MIXConfiguration mixConfiguration = 
				MIXConfiguration.createDefaultMixConfiguration( new String[]{"660", "688"});
			configuration = mixConfiguration.getSiteConfiguration(site.getSiteNumber(), null);
			assertNotNull(configuration);
			//configuration.persistConfigurationFile();
		}
		catch(MIXConfigurationException ecX)
		{
			ecX.printStackTrace();
		}
	}
}
