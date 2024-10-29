/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 1, 2010
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
package gov.va.med.imaging.federation.commands.externalpackage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationCprsIdentifierType;
import gov.va.med.imaging.federation.rest.types.FederationStudyType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationExternalPackageGetStudyFromCprsCommand
extends AbstractFederationCommand<List<Study>, FederationStudyType[]>
{
	private final String routingTokenString; 
	private final String patientIcn;
	private final FederationCprsIdentifierType cprsIdentifier;
	private final String interfaceVersion;

	public FederationExternalPackageGetStudyFromCprsCommand(String routingTokenString, 
			String patientIcn, 
			FederationCprsIdentifierType cprsIdentifier,
			String interfaceVersion)
	{
		super("getStudiesFromCprsIdentifier");
		this.routingTokenString = routingTokenString;
		this.cprsIdentifier = cprsIdentifier;
		this.patientIcn = patientIcn;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<Study> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			FederationRouter router = getRouter();		
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			List<Study> studies = router.getStudiesByCprsIdentifier(getPatientIcn(), 
					routingToken, new CprsIdentifier(getCprsIdentifier().getCprsIdentifier()));
            getLogger().info("{}, transaction({}) got {} Study business objects from router.", getMethodName(), getTransactionId(), studies == null ? "null" : "" + studies.size());
			return studies;
		}
		catch(RoutingTokenFormatException rtfX)
		{
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException(rtfX);
		}
	}

	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(FederationStudyType[] translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.length;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for CprsIdentifier [" + getCprsIdentifier().getCprsIdentifier()
			+ "] at site [" + getRoutingTokenString() + "]";
	}

	@Override
	protected Class<FederationStudyType[]> getResultClass()
	{
		return FederationStudyType[].class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIcn());

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	protected FederationStudyType[] translateRouterResult(List<Study> routerResult)
	throws TranslationException
	{
		return FederationRestTranslator.translate(routerResult);
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getPatientIcn()
	{
		return patientIcn;
	}

	public FederationCprsIdentifierType getCprsIdentifier()
	{
		return cprsIdentifier;
	}
	
}
