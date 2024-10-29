/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 2, 2016
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vacotittoc
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
package gov.va.med.imaging.mix.webservices.commands;

// import java.sql.Date;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
// simport java.util.List;
import java.util.Map;
import java.util.TreeSet;

import gov.va.med.PatientIdentifier;
// import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.exchange.ProcedureFilter;
// import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.PatientNotFoundException;
import gov.va.med.imaging.mix.MixRouter;
// import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType;
// import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslatorV1;
import gov.va.med.imaging.mix.webservices.translator.v1.MixWebAppTranslatorV1;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
// import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vacotittoc
 *
 */
public abstract class AbstractMixGetReportAndShallowStudyListCommand<E extends Object>
extends AbstractMixWebserviceCommand<StudySetResult, E>
//extends AbstractMixWebserviceCommand<ReportStudyListResponseType, E>
{
	private final String patientId;
	private final String assigner;
	private final String modalities;
//	private final String requestedSite;

	private final gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType filter;

	public AbstractMixGetReportAndShallowStudyListCommand(String patientId, String assigner, String fromDate, String toDate, String modalities)
	{
		super("GetStudySetResultWithReportForPatientCommand");
		this.patientId = patientId;
		this.assigner = assigner;
		filter = new gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType();
		filter.setFromDate(convertDate(fromDate));
		filter.setToDate(convertDate(toDate));
		this.modalities = modalities;
	}
	
	protected ProcedureFilter getStudyFilter()
	{
		String fromDate = filter.getFromDate();
		String toDate = filter.getToDate();
		filter.setFromDate(convertDate(fromDate));
		filter.setToDate(convertDate(toDate));
		ProcedureFilter procedureFilter = MixWebAppTranslatorV1.translate(filter);
		return procedureFilter;
	}

	@Override
	protected StudySetResult executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		MixRouter rtr = getRouter();
		StudyFilter studyFilter = getStudyFilter();
		try
		{
			studyFilter.setExcludeSiteNumbers(getExcludedSiteNumbers());
		}
		catch(RoutingTokenFormatException rtfX)
		{
            getLogger().warn("RoutingTokenFormatException while setting excluded sites, {}", rtfX.getMessage(), rtfX);
		}
		getTransactionContext().setQueryFilter(TransactionContextFactory.getFilterDateRange(studyFilter.getFromDate(), studyFilter.getToDate()));
		StudySetResult result = null;
		
		try
		{
			// get data from all sites for this patient with reports included -- "GetStudySetResultWithReportForPatientCommand"
			result = rtr.getStudySetResultWithReportsForPatient(PatientIdentifier.icnPatientIdentifier(getPatientId()),
					studyFilter);
		}
		catch(PatientNotFoundException pnfX)
		{
            getLogger().warn("PatientNotFoundException returning empty study list '{}', {}", getPatientId(), pnfX.getMessage());
			// for this interface return an empty study list if a patient is not found
			result = StudySetResult.createFullResult(new TreeSet<Study>());			
		}
        getLogger().info("Got {} Artifacts in StudySetResult from router for patient '{}'.", result == null ? "null" : "" + result.getArtifactSize(), getPatientId());
		getTransactionContext().addDebugInformation("Result has status [" + result == null ? "null result" : "" + result.getArtifactResultStatus() + "].");
		if (modalities!=null) {
			// remove studies with modalities, not in the list
			// ***
		}
		return result;
	}	
	
	private String convertDate(String webDate)
	{
		String dicomDate=null;

		// convert "yyyy-mm-dd" to "yyyymmdd" or return null
		if ((webDate!=null) && (!webDate.isEmpty())) {
			// dicomDate = webDate;
			dicomDate=webDate.replace("-", "");
		}
		
		return dicomDate;
	}
	private Collection<String> getExcludedSiteNumbers()
	{
		Collection<String> excludedSiteNumbers = new ArrayList<String>();
		excludedSiteNumbers.add("200");
		return excludedSiteNumbers;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient '" + getPatientId() + "'.";
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientId());

		return transactionContextFields;
	}

	public String getPatientId()
	{
		return patientId;
	}

	public String getAssigner()
	{
		return assigner;
	}
	
//	protected gov.va.med.imaging.mix.webservices.fhir.types.v1.ReportStudyListResponseType translateRouterResult(
//			StudySetResult routerResult) throws TranslationException
//	{
//		// convert StudySetResult to ReportStudyListResponseType -- setting Study and instance UIDs as VA URNs to carry site and studyId and AssignedId respectively
//		ReportStudyListResponseType rslrt = null;
//		try {
//			rslrt = MixTranslatorV1.translate(routerResult);;
//		} catch (TranslationException te) {
//			throw new MethodException(te.getMessage());
//		}
//		return rslrt;
//	}
	
}
