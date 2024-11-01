/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 22, 2011
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
package gov.va.med.imaging.federation.commands.externalsystemoperation;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.GlobalArtifactIdentifierFactory;
import gov.va.med.PatientArtifactIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.rest.types.RestCoreTranslator;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationExternalSystemOperationPrefetchGaiCommand
extends AbstractFederationCommand<Boolean, RestBooleanReturnType>
{
	private final String gai;
	private final String interfaceVersion;
	
	public FederationExternalSystemOperationPrefetchGaiCommand(String gai,
			String interfaceVersion)
	{
		super("prefetchGai");
		this.gai = gai;
		this.interfaceVersion = interfaceVersion;
	}

	@SuppressWarnings("unchecked")
	@Override
	protected Boolean executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			GlobalArtifactIdentifier g = 
				GlobalArtifactIdentifierFactory.create(getGai(), SERIALIZATION_FORMAT.RAW, 
						GlobalArtifactIdentifier.class);
			if(g instanceof PatientArtifactIdentifier)
			{
				PatientArtifactIdentifier paid = (PatientArtifactIdentifier)g;
				getTransactionContext().setPatientID(paid.getPatientIdentifier());
			}
			
			FederationRouter router = getRouter();
			return router.prefetchDocument(g);			
		}
		catch(GlobalArtifactIdentifierFormatException gaifX)
		{
			throw new MethodException(gaifX);
		}
	}

	@Override
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult)
	{
		return 0;
	}

	@Override
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return " for image '" + getGai() + "'.";
	}

	@Override
	protected Class<RestBooleanReturnType> getResultClass()
	{
		return RestBooleanReturnType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getGai());		

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult)
	throws TranslationException, MethodException
	{
		return RestCoreTranslator.translate(routerResult);
	}

	public String getGai()
	{
		return gai;
	}

}
