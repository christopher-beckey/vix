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
package gov.va.med.imaging.federation.commands.studygraph;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationFilterType;
import gov.va.med.imaging.federation.rest.types.FederationStudyLoadLevelType;
import gov.va.med.imaging.federation.rest.types.FederationStudyResultType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationStudyGraphStudyListCommand 
extends AbstractFederationCommand<StudySetResult, FederationStudyResultType> 
{
	private final String routingTokenString;	
	private final String patientIcn;
	private final int authorizedSensitivityLevel;
	private final FederationStudyLoadLevelType studyLoadLevelType;
	private final FederationFilterType federationFilterType;
	private final String interfaceVersion;
	
	public FederationStudyGraphStudyListCommand(String routingTokenString, String patientIcn, 
			int authorizedSensitivityLevel, FederationStudyLoadLevelType studyLoadLevelType,
			FederationFilterType federationFilterType,
			String interfaceVersion)
	{
		super("getPatientStudyList");
		this.routingTokenString = routingTokenString;
		this.patientIcn = patientIcn;
		this.authorizedSensitivityLevel = authorizedSensitivityLevel;
		this.studyLoadLevelType = studyLoadLevelType;
		this.federationFilterType = federationFilterType;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected StudySetResult executeRouterCommand() 
	throws MethodException, ConnectionException, InsufficientPatientSensitivityException 
	{
		StudyFilter studyFilter = null;
		try
		{
			studyFilter = FederationRestTranslator.translate(getFederationFilterType(), getAuthorizedSensitivityLevel(), true);
		}
		catch (GlobalArtifactIdentifierFormatException x)
		{
			String msg = "FederationStudyGraphStudyListCommand.executeRouterCommand() --> Encountered Id format exception: " + x.getMessage();
			getLogger().error(msg);
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException(msg, x);
		}
		TransactionContext transactionContext = TransactionContextFactory.get();		
		transactionContext.setQueryFilter(TransactionContextFactory.getFilterDateRange(studyFilter.getFromDate(), 
				studyFilter.getToDate()));
		
		StudySetResult result = null;
		PatientIdentifier patientId = PatientIdentifier.icnPatientIdentifier(patientIcn);
		
		try
		{
			FederationRouter router = getRouter();
			StudyLoadLevel studyLoadLevel = FederationRestTranslator.translate(studyLoadLevelType);
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			if(studyLoadLevel == StudyLoadLevel.STUDY_ONLY)
				result = router.getPatientShallowStudySetResult(routingToken, patientId, studyFilter);
			else if(studyLoadLevel == StudyLoadLevel.STUDY_AND_REPORT)
				result = router.getPatientShallowStudySetWithReport(routingToken, patientId, studyFilter);
			else if(studyLoadLevel == StudyLoadLevel.STUDY_AND_IMAGES)
				result = router.getPatientStudySetResultWithImages(routingToken, patientId, studyFilter);
			else			
				result = router.getPatientStudySet(routingToken, patientId, studyFilter);

            getLogger().info("FederationStudyGraphStudyListCommand.executeRouterCommand() --> transaction Id [{}], got [{} ArtifactResult business object(s) from router.", getTransactionId(), result == null ? 0 : result.getArtifactSize());
			return result;
		}
		catch(RoutingTokenFormatException rtfX)
		{
			String msg = "FederationStudyGraphStudyListCommand.executeRouterCommand() --> Encountered routing exception: " + rtfX.getMessage();
			getLogger().error(msg);
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException(msg, rtfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString() 
	{
		return "patient [" + getPatientIcn() + "] from site [" + getRoutingTokenString() + "] with load level [" + FederationRestTranslator.translate(getStudyLoadLevelType()) + "]";
	}

	@Override
	protected Class<FederationStudyResultType> getResultClass() 
	{
		return FederationStudyResultType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() 
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIcn());

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields() 
	{
		
	}

	@Override
	protected FederationStudyResultType translateRouterResult(
			StudySetResult routerResult) 
	throws TranslationException 
	{
		return FederationRestTranslator.translate(routerResult);
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getPatientIcn() {
		return patientIcn;
	}

	public int getAuthorizedSensitivityLevel() {
		return authorizedSensitivityLevel;
	}

	public FederationStudyLoadLevelType getStudyLoadLevelType() {
		return studyLoadLevelType;
	}

	public FederationFilterType getFederationFilterType() {
		return federationFilterType;
	}

	@Override
	public String getInterfaceVersion() 
	{
		return this.interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(FederationStudyResultType translatedResult)
	{
		return translatedResult == null ? 0 : (translatedResult.getStudies() == null ? 0 : translatedResult.getStudies().length);
	}
}
