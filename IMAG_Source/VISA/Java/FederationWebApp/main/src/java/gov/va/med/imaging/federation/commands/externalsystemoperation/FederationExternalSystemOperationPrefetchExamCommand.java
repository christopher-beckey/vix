/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 22, 2010
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

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.vistarad.AbstractFederationVistaRadCommand;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationExternalSystemOperationPrefetchExamCommand
extends AbstractFederationVistaRadCommand<Boolean, RestBooleanReturnType>
{
	private final String examId;
	private final String interfaceVersion;

	public FederationExternalSystemOperationPrefetchExamCommand(String examId, String interfaceVersion)
	{
		super("prefetchExam");
		this.examId = examId;
		this.interfaceVersion = interfaceVersion;
	}

	public String getExamId()
	{
		return examId;
	}

	@Override
	protected Boolean executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			FederationRouter router = getRouter();
			StudyURN studyUrn = URNFactory.create(getExamId(), SERIALIZATION_FORMAT.RAW, StudyURN.class);
			getTransactionContext().setPatientID(studyUrn.getPatientId());
			router.prefetchExamImages(studyUrn);
			getLogger().info("FederationExternalSystemOperationPrefetchExamCommand.executeRouterCommand() --> Submitted request for exam prefetch.");
			return true;
		}
		catch(URNFormatException iurnfX)
		{
			// if these are set here, they will be overwritten in the parent class
			//getLogger().error("FAILED " + methodName + " transaction(" + transactionId, iurnfX );
			//transactionContext.setErrorMessage(iurnfX.getMessage());
			//transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new MethodException(iurnfX);
		}	
	}

	@Override
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult)
	{
		return null;
	}

	@Override
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return " for exam [" + getExamId() + "]";
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getExamId());		

		return transactionContextFields;
	}

	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult)
	throws TranslationException
	{
		return new RestBooleanReturnType(routerResult); 
	}
}
