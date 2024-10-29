/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 4, 2009
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
package gov.va.med.imaging.federation.webservices.translator;

import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.exchange.business.Site;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class AbstractFederationWebAppTranslator 
{
	private final Logger logger = Logger.getLogger(AbstractFederationWebAppTranslator.class);
	
	private final static String federationWebserviceShortDateFormat = "MM/dd/yyyy";
	
	protected Logger getLogger()
	{
		return logger;
	}
	
	public String[] transformSitesToSiteNumberArary(List<ResolvedArtifactSource> sites)
	{
		if(sites == null)
			return null;
		String[] siteNumbers = new String[sites.size()];
		for(int i = 0; i < sites.size(); i++)
		{
			ResolvedArtifactSource resolvedSite = sites.get(i);
			ArtifactSource site = resolvedSite.getArtifactSource();
			siteNumbers[i] = site instanceof Site ? ((Site)site).getSiteNumber() : null;
		}
		return siteNumbers;
	}
	
	// be careful about re-using SimpleDateFormat instances because they are not thread-safe 
	protected DateFormat getFederationWebserviceShortDateFormat()
	{
		return new SimpleDateFormat(federationWebserviceShortDateFormat);
	}
}
