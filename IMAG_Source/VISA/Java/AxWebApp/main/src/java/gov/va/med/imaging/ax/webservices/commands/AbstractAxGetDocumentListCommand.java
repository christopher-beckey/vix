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
package gov.va.med.imaging.ax.webservices.commands;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.MediaType;
import gov.va.med.RoutingToken;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.DicomDateFormat;
import gov.va.med.imaging.ax.AxWebAppRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.PatientNotFoundException;
import gov.va.med.imaging.exchange.business.DocumentFilter;
import gov.va.med.imaging.exchange.business.documents.Document;
import gov.va.med.imaging.exchange.business.documents.DocumentSet;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vacotittoc
 *
 */
public abstract class AbstractAxGetDocumentListCommand<E extends Object>
extends AbstractAxWebserviceCommand<DocumentSetResult, E>
{
	private final String patientId;
	private final String loinc;
	private final DocumentFilter documentFilter;
	
	private java.util.Date getDate(String yMD)
	{
		java.util.Date dicomDate = null;
		DicomDateFormat ddf = new DicomDateFormat();

		if (yMD != null) {
			try {
				dicomDate = ddf.parse(yMD);
			} 
			catch (ParseException pe) {
                getLogger().error("AbstractAxGetDocumentListCommand.getDate() --> Encountered ParseException on date string [{}]{}", yMD, pe.getMessage());
			} 			
		} 

		return dicomDate;
	}

	public AbstractAxGetDocumentListCommand(String patientId, String LOINC, String fromDate, String toDate) // String requestor, String transactionId)
	{
		super("GetDocumentSetResultForPatientCommand");
		this.patientId = patientId;
		this.loinc = LOINC;

		java.util.Date begDate = getDate(fromDate); // time is 00:00:00
		java.util.Date endDate = getDate(toDate);
		if (endDate == null)
			endDate = new java.util.Date(); // now!
		// endDate.setTime(86399999); // make sure end of day is set in milliseconds!!
		documentFilter = new DocumentFilter(patientId, begDate, endDate);
		documentFilter.setMaximumAllowedLevel(PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK); // =2, 3 or higher blocked! set 1 to call PatientSensitivityLevel.DISPLAY_WARNING);		
	}

	@Override
	protected DocumentSetResult executeRouterCommand() 
	throws MethodException, ConnectionException
	{
    	TransactionContext transactionContext = TransactionContextFactory.get();
    	
    	AxWebAppRouter router = getRouter();

		try
		{
			documentFilter.setExcludeSiteNumbers(getExcludedSiteNumbers());
		}
		catch(RoutingTokenFormatException rtfX)
		{
            getLogger().warn("AbstractAxGetDocumentListCommand.executeRouterCommand() --> Encountered RoutingTokenFormatException while setting excluded sites, {}", rtfX.getMessage());
		}
		getTransactionContext().setQueryFilter(TransactionContextFactory.getFilterDateRange(documentFilter.getFromDate(), documentFilter.getToDate()));
		DocumentSetResult result = null;

		try
		{
			transactionContext.setPatientID(documentFilter.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " Query");
			transactionContext.setQueryFilter(TransactionContextFactory.getFilterDateRange(documentFilter.getCreationTimeFrom(), documentFilter.getCreationTimeTo()));

			// we should have a configuration for the OID that we are representing
			RoutingToken routingToken = RoutingTokenImpl.createVADocumentSite(RoutingToken.ROUTING_WILDCARD);

			// get documents from all sites for this patient
			result = router.getDocumentSetResultForPatient(routingToken, documentFilter);
			// check for null documentSetResult - really shouldn't happen but just in case
			if(result == null)
				throw new MethodException("AbstractAxGetDocumentListCommand.executeRouterCommand() --> no documents found for patient ID [" + documentFilter.getPatientId() + "]");

			//TODO: check for partial result and for errors and add them to the response, make translator use DocumentSetResult
			result = removeDicomDocs(result);
			
			transactionContext.setEntriesReturned(result == null ? 0 : result.getArtifactSize());	
		}
		catch(PatientNotFoundException pnfX)
		{
            getLogger().warn("AbstractAxGetDocumentListCommand.executeRouterCommand() --> Returning empty document list. Not found patient ID [{}], {}", getPatientId(), pnfX.getMessage());
			// for this interface return an empty document list if a patient is not found
			SortedSet<DocumentSet> fullResults = new TreeSet<DocumentSet>();
			result = DocumentSetResult.createFullResult(fullResults);
		}
		catch (RoutingTokenFormatException x)
		{
            LOGGER.error("AbstractAxGetDocumentListCommand.executeRouterCommand() --> Encountered RoutigTokenformatexception: {}", x.getMessage());
		}
        getLogger().info("AbstractAxGetDocumentListCommand.executeRouterCommand() --> Got {} Artifacts in DocumentSetResult from router for patient [{}]", result == null ? "null" : result.getArtifactSize(), getPatientId());
		getTransactionContext().addDebugInformation("AbstractAxGetDocumentListCommand.executeRouterCommand() --> Result has status [" + result == null ? "null result" : result.getArtifactResultStatus() + "]");

		return result;
	}	
	
	private Collection<String> getExcludedSiteNumbers()
	{
		Collection<String> excludedSiteNumbers = new ArrayList<String>();
		excludedSiteNumbers.add("200");
		// Additional "central office / 100" site numbers that should be excluded
		excludedSiteNumbers.add("200CORP");
		excludedSiteNumbers.add("200CLMS");
		excludedSiteNumbers.add("100");
		return excludedSiteNumbers;
	}

	private DocumentSetResult removeDicomDocs(DocumentSetResult routerResult) {
		
		int removedCount = 0;
		
		if ((routerResult != null) && (routerResult.getArtifactSize() > 0)) {
			
			SortedSet<DocumentSet> inDocs = routerResult.getArtifacts();
			SortedSet<DocumentSet> outDocs = new TreeSet<DocumentSet>();
			
			for (DocumentSet docSet: inDocs) {
				
				boolean includeDocSet = true;
				
				if (docSet.size() > 0) {
				
					for (Document doc:docSet) {
						if (doc.getMediaType() == MediaType.APPLICATION_DICOM) {
							removedCount += docSet.size(); // assuming a group that has 1 DICOM document contains only DICOM documents
							includeDocSet = false;
							break;
						}
					}
				}
				
				if (includeDocSet) {
					outDocs.add(docSet);
				}
			}
			if (removedCount > 0)
                getLogger().info("AbstractAxGetDocumentListCommand.executeRouterCommand() --> removed {} DICOM document(s) from list !", removedCount);

			if (!outDocs.isEmpty()) {
				DocumentSetResult fileredDocumentSetResult = DocumentSetResult.createFullResult(outDocs);
				return fileredDocumentSetResult;
			}
		}
		return routerResult;
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

	public String getLoinc()
	{
		return loinc;
	}	
}
