/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 7, 2017
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
package gov.va.med.imaging.ax.webservices.commands;

import gov.va.med.imaging.ax.webservices.rest.types.RequestorType;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.transactioncontext.TransactionContext;

/**
 * @author vacotittoc
 *
 */
public class AxGetDocumentListCommand
extends AbstractAxGetDocumentListCommand<DocumentSetResult>
{
	
	public AxGetDocumentListCommand(
			String patientId, String LOINC, String fromDate, String toDate, String purposeOfUse, String transactionId)
	{
//		super(patientId, assigner, filter.getFromDate(), filter.getToDate(), requestedSite);
		super(patientId, LOINC, fromDate, toDate); // dates are null or 'yyyyMMdd'
		TransactionContext transactionContext = getTransactionContext();
		RequestorType requestorInfo = 
				new RequestorType(
						transactionContext.getFullName(), 
						transactionContext.getSsn(), 
						transactionContext.getSiteNumber(), 
						transactionContext.getSiteName(), 
						purposeOfUse);
		String transactionID = getTransactionContext().getTransactionId();
		// replace transactionID with incoming DAS request's ID
		if ((transactionId != null) && !transactionId.isEmpty())
			transactionID = transactionId;
		AxCommandCommon.setTransactionContext(requestorInfo, transactionID);
	}

	@Override
	public Integer getEntriesReturned(DocumentSetResult translatedResult)
	{
		return (translatedResult == null ? 0 : (translatedResult.getArtifacts().size() == 0 ? 0 : translatedResult.getArtifacts().size()));
	}

	@Override
	public String getInterfaceVersion()
	{
		return AxCommandCommon.axV1InterfaceVersion;
	}

	@Override
	protected Class<DocumentSetResult> getResultClass()
	{
		return DocumentSetResult.class;
	}

	// no clue, why this is needed
	@Override
	protected DocumentSetResult translateRouterResult(
			DocumentSetResult routerResult)
			throws TranslationException, MethodException {
		return routerResult;
	}

}
