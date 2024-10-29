/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 1, 2016
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
package gov.va.med.imaging.mix.webservices.commands.v1;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
// import gov.va.med.imaging.exchange.ProcedureFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.mix.webservices.commands.AbstractMixGetReportAndShallowStudyListCommand;
// import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorTypePurposeOfUse;
// import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslatorV1;
// import gov.va.med.imaging.mix.webservices.translator.v1.MixWebAppTranslatorV1;
import  gov.va.med.imaging.transactioncontext.TransactionContext;

/**
 * @author vacotittoc
 *
 */
public class MixGetReportAndShallowStudyListCommandV1
extends AbstractMixGetReportAndShallowStudyListCommand<StudySetResult>
//extends AbstractMixGetReportAndShallowStudyListCommand<gov.va.med.imaging.mix.webservices.fhir.types.v1.ReportStudyListResponseType>
//extends AbstractMixGetReportAndShallowStudyListCommand<gov.va.med.imaging.mix.webservices.fhir.types.v1.DiagnosticReport>
{
	
	public MixGetReportAndShallowStudyListCommandV1(
			String patientId, String assigner, String fromDate, String toDate, String modalities, String dasTALogId)
	{
//		super(patientId, assigner, filter.getFromDate(), filter.getToDate(), requestedSite);
		super(patientId, assigner, fromDate, toDate, modalities);
		TransactionContext transactionContext = getTransactionContext();
		RequestorType requestor = 
				new RequestorType(
						transactionContext.getFullName(), 
						transactionContext.getSsn(), 
						transactionContext.getSiteNumber(), 
						transactionContext.getSiteName(), 
				RequestorTypePurposeOfUse.value1);
		String transactionId = getTransactionContext().getTransactionId();
		// replace transactionID with incoming DAS request's ID
		if ((dasTALogId != null) && !dasTALogId.isEmpty())
			transactionId = dasTALogId;
		MixCommandCommonV1.setTransactionContext(requestor, transactionId);
	}

	@Override
	public Integer getEntriesReturned(StudySetResult translatedResult)
	{
		return (translatedResult == null ? 0 : (translatedResult.getArtifacts().size() == 0 ? 0 : translatedResult.getArtifacts().size()));
	}

	@Override
	public String getInterfaceVersion()
	{
		return MixCommandCommonV1.mixV1InterfaceVersion;
	}

	@Override
	protected Class<StudySetResult> getResultClass()
	{
		return StudySetResult.class;
	}

	// no clue, why this is needed
	@Override
	protected StudySetResult translateRouterResult(
			StudySetResult routerResult)
			throws TranslationException, MethodException {
		return routerResult;
	}

}
