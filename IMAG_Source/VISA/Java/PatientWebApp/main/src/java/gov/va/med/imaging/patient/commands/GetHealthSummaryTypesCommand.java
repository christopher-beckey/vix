/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 8, 2012
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
package gov.va.med.imaging.patient.commands;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.HealthSummaryType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.patient.PatientRouter;
import gov.va.med.imaging.patient.rest.translator.PatientRestTranslator;
import gov.va.med.imaging.patient.rest.types.PatientHealthSummariesType;

import java.util.List;

/**
 * @author VHAISWWERFEJ
 *
 */
public class GetHealthSummaryTypesCommand
extends AbstractPatientCommand<List<HealthSummaryType>, PatientHealthSummariesType>
{
	private final String siteId;
	private final String interfaceVersion;

	/**
	 * @param methodName
	 */
	public GetHealthSummaryTypesCommand(String siteId,
			String interfaceVersion)
	{
		super("getHealthSummaryTypes");
		this.siteId = siteId;
		this.interfaceVersion = interfaceVersion;
	}

	public String getSiteId()
	{
		return siteId;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<HealthSummaryType> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		PatientRouter router = getRouter();
		try
		{
			RoutingToken routingToken =
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			return router.getHealthSummaries(routingToken);
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "from site '" + getSiteId() + "'.";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected PatientHealthSummariesType translateRouterResult(
			List<HealthSummaryType> routerResult)
	throws TranslationException, MethodException
	{
		return PatientRestTranslator.translateHealthSummaries(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<PatientHealthSummariesType> getResultClass()
	{
		return PatientHealthSummariesType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getInterfaceVersion()
	 */
	@Override
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(
			PatientHealthSummariesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getHealthSummary().length;
	}

}
