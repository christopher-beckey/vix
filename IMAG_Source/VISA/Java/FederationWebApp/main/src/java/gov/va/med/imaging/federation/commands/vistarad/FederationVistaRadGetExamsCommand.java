/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 25, 2010
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
package gov.va.med.imaging.federation.commands.vistarad;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.vistarad.ExamSite;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationExamResultType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationVistaRadGetExamsCommand
extends AbstractFederationVistaRadCommand
<ExamSite, FederationExamResultType>
{
	private final String routingTokenString;
	private final String patientIcn;
	private final boolean fullyLoaded;
	private final boolean forceRefresh;
	private final String interfaceVersion;
	private final boolean forceImagesFromJb;
	
	public FederationVistaRadGetExamsCommand(String routingTokenString, String patientIcn, 
			boolean fullyLoaded, boolean forceRefresh, 
			boolean forceImagesFromJb, String interfaceVersion)
	{
		super("getPatientExams");
		this.routingTokenString = routingTokenString;
		this.patientIcn = patientIcn;
		this.fullyLoaded = fullyLoaded;
		this.forceRefresh = forceRefresh;
		this.interfaceVersion = interfaceVersion;
		this.forceImagesFromJb = forceImagesFromJb;
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getPatientIcn() {
		return patientIcn;
	}

	public boolean isFullyLoaded() {
		return fullyLoaded;
	}

	public boolean isForceRefresh()
	{
		return forceRefresh;
	}

	public boolean isForceImagesFromJb()
	{
		return forceImagesFromJb;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() 
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIcn());

		return transactionContextFields;
	}

	@Override
	protected ExamSite executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		try
		{
			FederationRouter router = getRouter();
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			ExamSite examSite = null;
			if(fullyLoaded)
			{
				examSite = router.getFullyLoadedExamSite(routingToken, getPatientIcn(), 
						isForceRefresh(), isForceImagesFromJb());	
			}
			else
			{
				examSite = router.getExamSite(routingToken, getPatientIcn(), 
						isForceRefresh(), isForceImagesFromJb());
			}
			return examSite;
		}
		catch(RoutingTokenFormatException rtfX)
		{
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException(rtfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString() 
	{
		return "at site [" + getRoutingTokenString() + "] for patient '" + getPatientIcn() + "'";
	}

	@Override
	protected FederationExamResultType translateRouterResult(ExamSite routerResult)
	throws TranslationException
	{
		return FederationRestTranslator.translate(routerResult); 
	}

	@Override
	protected Class<FederationExamResultType> getResultClass() 
	{
		return FederationExamResultType.class;
	}
	
	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}
	
	@Override
	public Integer getEntriesReturned(FederationExamResultType translatedResult)
	{
		return translatedResult == null ? 0 : (translatedResult.getExams() == null ? 0 : translatedResult.getExams().length);
	}
}
