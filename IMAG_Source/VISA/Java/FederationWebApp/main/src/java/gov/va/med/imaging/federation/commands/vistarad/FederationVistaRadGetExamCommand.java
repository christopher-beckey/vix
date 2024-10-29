/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 27, 2010
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

import gov.va.med.URNFactory;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.vistarad.Exam;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationExamType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationVistaRadGetExamCommand
extends AbstractFederationVistaRadCommand<Exam, FederationExamType>
{
	private final String examId;
	private final String interfaceVersion;

	public FederationVistaRadGetExamCommand(String examId, String interfaceVersion)
	{
		super("getPatientExam");
		this.examId = examId;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected Exam executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			FederationRouter router = getRouter();
			StudyURN studyUrn = URNFactory.create(examId, StudyURN.class);
			getTransactionContext().setPatientID(studyUrn.getPatientId());
			Exam exam = router.getExam(studyUrn);
            getLogger().info("FederationVistaRadGetExamCommand.executeRouterCommand() --> transaction Id [{}], got {} exam business object from router.", getTransactionId(), exam == null ? "null" : "not null");
			return exam;
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
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(FederationExamType translatedResult)
	{
		return null;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for URN [" + getExamId() + "]";
	}

	@Override
	protected Class<FederationExamType> getResultClass()
	{
		return FederationExamType.class;
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
	protected FederationExamType translateRouterResult(Exam routerResult)
			throws TranslationException
	{
		return FederationRestTranslator.translate(routerResult);
	}

	public String getExamId()
	{
		return examId;
	}
}
