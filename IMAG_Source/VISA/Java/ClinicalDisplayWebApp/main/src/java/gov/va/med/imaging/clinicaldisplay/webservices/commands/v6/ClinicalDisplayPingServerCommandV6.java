/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 18, 2010
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
package gov.va.med.imaging.clinicaldisplay.webservices.commands.v6;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.AbstractClinicalDisplayPingServerCommand;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator6;
import gov.va.med.imaging.exchange.enums.SiteConnectivityStatus;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayPingServerCommandV6
extends AbstractClinicalDisplayPingServerCommand<gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PingServerTypePingResponse>
{
	
	public ClinicalDisplayPingServerCommandV6(String transactionId,
			String clientWorkstation, String requestSiteNumber,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials)
	{
		super(clientWorkstation, requestSiteNumber);
		ClinicalDisplayCommandCommonV6.setTransactionContext(credentials, transactionId);
	}

	@Override
	public Integer getEntriesReturned(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PingServerTypePingResponse translatedResult)
	{
		return null;
	}

	@Override
	public String getInterfaceVersion()
	{
		return ClinicalDisplayCommandCommonV6.clinicalDisplayV6InterfaceVersion;
	}

	@Override
	protected Class<gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PingServerTypePingResponse> getResultClass()
	{
		return gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PingServerTypePingResponse.class;
	}

	@Override
	protected gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PingServerTypePingResponse translateRouterResult(
			SiteConnectivityStatus routerResult) 
	throws TranslationException
	{
		return ClinicalDisplayTranslator6.transform(routerResult);
	}

}
