/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 29, 2012
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
package gov.va.med.imaging.federation.commands.pathology;

import gov.va.med.URNFactory;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.pathology.PathologyCaseURN;
import gov.va.med.imaging.rest.types.RestCoreTranslator;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationPathologyGetCaseReportCommand
extends AbstractFederationPathologyCommand<String, RestStringType>
{
	private final String caseId;
	private final String interfaceVersion;

	/**
	 * @param methodName
	 */
	public FederationPathologyGetCaseReportCommand(String caseId, 
			String interfaceVersion)
	{
		super("getPathologyCaseReport");
		this.caseId = caseId;
		this.interfaceVersion = interfaceVersion;
	}

	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	public String getCaseId()
	{
		return caseId;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			PathologyCaseURN pathologyCaseUrn = URNFactory.create(getCaseId(), PathologyCaseURN.class);
			getTransactionContext().setPatientID(pathologyCaseUrn.getPatientId().toString());
			String result = getRouter().getPathologyCaseReport(pathologyCaseUrn);
			getTransactionContext().setFacadeBytesSent(result == null ? 0L : result.length());
			return result;
		}
		catch(URNFormatException rtfX)
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
		return "for case '" + getCaseId() + "'.";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected RestStringType translateRouterResult(String routerResult)
	throws TranslationException, MethodException
	{
		return RestCoreTranslator.translate(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<RestStringType> getResultClass()
	{
		return RestStringType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 */
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getCaseId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(RestStringType translatedResult)
	{
		return null;
	}

}
