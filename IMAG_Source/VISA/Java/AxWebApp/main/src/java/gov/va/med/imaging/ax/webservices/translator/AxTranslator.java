/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 27, 2010
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
package gov.va.med.imaging.ax.webservices.translator;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.SortedSet;

import gov.va.med.imaging.*;
import gov.va.med.imaging.utils.NetUtilities;
import gov.va.med.logging.Logger;

import static org.apache.commons.lang.StringEscapeUtils.escapeHtml;

import gov.va.med.imaging.ax.webservices.rest.types.AttachmentType;
import gov.va.med.imaging.ax.webservices.rest.types.Bundle;
import gov.va.med.imaging.ax.webservices.rest.types.ContentType;
import gov.va.med.imaging.ax.webservices.rest.types.DocumentReference;
import gov.va.med.imaging.ax.webservices.rest.types.OperationOutcome;
import gov.va.med.imaging.ax.webservices.rest.types.ReferenceType;
import gov.va.med.imaging.ax.webservices.rest.types.CodeType;
import gov.va.med.imaging.ax.webservices.rest.types.CodingType;
import gov.va.med.imaging.ax.webservices.rest.types.TextType;
import gov.va.med.imaging.ax.webservices.rest.types.Value;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.exchange.business.documents.Document;
import gov.va.med.imaging.exchange.business.documents.DocumentSet;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;

/**
 * @author vhaisatittoc
 *
 */
@SuppressWarnings("deprecation")
public class AxTranslator
{
	private final static Logger LOGGER = Logger.getLogger(AxTranslator.class);
	
	/**
	 * Translate Date into a JSON formatted String date[Time].
	 * 
	 * @param Date		date to format
	 * @return String	formatted date as a String
	 *  
	 */
	public static String translateDateToJSON(Date date) 

	{ // TODO make this really produce yyyy-MM-ddTHH:MI:SS+HH:MI (UTC time)
		String dateStringAsJSON = "";
		if (date != null) 
		{
			DateFormat jsonDate = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ"); // yyyy-MM-dd'T'HH:mm:ss.SSSZ
			dateStringAsJSON = jsonDate.format(date);
			// this produces 'yyyy-MM-ddTHH:mm:ss+HHmm' or '...-HHmm' --> 24 chars
			// insert ':' to UTC part
			if (dateStringAsJSON.length() == 24) {
				String beg = dateStringAsJSON.substring(0,22);
				String end = dateStringAsJSON.substring(22,24);
				dateStringAsJSON = beg + ":" + end;
			}
		}
		return dateStringAsJSON;
	}

	/**
	 * Translate a DICOM style String date into a JSON formatted String date.
	 * 
	 * @param String			date as String
	 * @return String			result
	 * @throws ParseException	required exception
	 * 
	 */
	public static String translateDateToJSON(String dateString) 
	throws ParseException
	{
		String dateStringAsJSON = "";
		if (dateString != null)
		{
			String trimmedDateString = dateString.trim();
			if (trimmedDateString.length() > 0)
			{
				DicomDateFormat dicomDateFormat = new DicomDateFormat();
				// post patch 59 dates include time-of-day segment
				DateFormat jsonDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ"); 
				Date date = dicomDateFormat.parse(trimmedDateString);
				dateStringAsJSON = jsonDateFormat.format(date);
			}
		}
		return dateStringAsJSON;
	}
	
	/**
	 * Convert doc references to usable info downstream
	 * 
	 * @param DocumentSetResult				object to convert
	 * @param String						requestor
	 * @param String						transaction Id
	 * @return Bundle						result
	 * @throws TranslationException			required exception
	 * 
	 */
	public static Bundle convertDocumentReferences(DocumentSetResult documentSetResult, String requestor, String transactionId)
	throws TranslationException
	{
		
		if(documentSetResult == null)
			return null;
		
		// consistent with V1 translator
		// Code like this for Fortify
		SortedSet<DocumentSet> artifacts = documentSetResult.getArtifacts();
		if(artifacts == null || artifacts.size() == 0)
			return null;
		
		Bundle bundle = makeDocumentReferenceBundle(documentSetResult, requestor, transactionId);

        LOGGER.info("AxTranslator.convertDocumentReferences() --> Translated [{}] documents into a bundle of DocumentReference(s) to return", bundle.getTotal());
		
		return bundle;
	}

	/**
	 * Create an operation outcome based on given code and message
	 * 
	 * @param String			code to create with
	 * @param String			message to create with
	 * @return OperationOutcome	result
	 * 
	 */
	public static OperationOutcome createOperationOutcome(String code, String message)
	{
		return new OperationOutcome(code, message);
	}
	
	/**
	 * Getter for FQDN
	 * 
	 * @return String		unsafe local host name
	 * 
	 */
	private static String getFQDN(){
		return NetUtilities.getUnsafeLocalHostName();
	}
	
	/**
	 * Process results. If no matching report, make new dR with shallowStudy, populate dR fields,
	 * on dR found add new shallowStudy only
	 * 
	 * @param Bundle						object to hold the results
	 * @param DocumentSet					object to process
	 * @param String						requestor
	 * @param String						transaction Id
	 * @throws TranslationException			required exception
	 * 
	 */
	private static void processDocument(Bundle bundle, DocumentSet docSet, String requestor, String transactionId)
	throws TranslationException
	{
		int id=1;
		for (Document document : docSet)
		{
			gov.va.med.imaging.ax.webservices.rest.types.Entry newEntry = 
					new gov.va.med.imaging.ax.webservices.rest.types.Entry();
			String entryId;
			if ((docSet.getIdentifier()!=null) && !docSet.getIdentifier().isEmpty())
				entryId = docSet.getIdentifier() + "-" + Integer.toString(id);
			else
				entryId = docSet.getGroupIen() + "-" + Integer.toString(id);
			newEntry.setId(entryId);

			newEntry.setFullUrl("https://" + getFQDN() + "/DocumentReference/" + entryId);
			
			// SearchModeType sMT = new SearchModeType("match"); // hardcoded
			// newEntry.setSearch(sMT);	-- done in Entry constructor

			DocumentReference theDR = newEntry.getResource();
			
			String escapedDocName = ""; // unnamed document
			if ((document.getName()!=null) && !document.getName().isEmpty()) {
				escapedDocName = escapeHtml(document.getName()); // make sure ", &, <, > are escaped
			}
			TextType text = new TextType("additional", "<div>" + escapedDocName + "</div>"); // give this field (name) a chance
			theDR.setText(text);

			Value value = new Value(document.getDocumentUrn().toString());
			theDR.setMasterIdentifier(value);

			ReferenceType subject = new ReferenceType("Patient/"+document.getPatientId());
			theDR.setSubject(subject);
			
			// TODO set 34794-8 as LOINC ???
			CodingType coding0 = new CodingType("https://loinc.org", "34794-8", "Interdisciplinary Note: "+document.getDescription());
			CodingType[] codingArray0 = new CodingType[1];
			codingArray0[0] = coding0;
			CodeType typeCode = new CodeType(codingArray0);
			theDR.setType(typeCode); // no LOINC or other standard code !! default assumed: 34794-8 - "Interdisciplinary Note"
			
			ReferenceType[] author = new ReferenceType[2];
			author[0] = new ReferenceType("Practitioner/author"); // no practitioner available
			author[1] = new ReferenceType("Organization/VistA Imaging"); // hardcoded
			theDR.setAuthor(author);

			ReferenceType custodian = new ReferenceType("Organization/VHA"); // hardcoded
			theDR.setCustodian(custodian);
			
			theDR.setCreated(translateDateToJSON(document.getCreationDate()));
			
			theDR.setIndexed(translateDateToJSON(docSet.getProcedureDate())); // or .getAquisitionDate() ???
			
			// theDR.setStatus("current"); // set by default in DocumentReference constructor
			
			theDR.setDescription(document.getDescription());
			
			// *** securityLabel -- TODO: set all 'N' or figure a way to delegate down patient's Sensitivity Code: null/0->'L', 1->'M', 2->'N', 3->'R', >3->'V'
			CodingType coding = new CodingType("http://hl7.org/fhir/ValueSet/v3-Confidentiality", "N", "normal");
			CodingType[] codingArray = new CodingType[1];
			codingArray[0] = coding;
			CodeType[] securityCode = new CodeType[1];
			securityCode[0] = new CodeType(codingArray);
			theDR.setSecurityLabel(securityCode);
			
			String url = "Binary/" + theDR.getMasterIdentifier().getValue(); // + "/?TransactionID=" + transactionId + 
						 // "&requestor=" + requestor + "&purposeOfUse=Treatment"; // try to give a path example with the documentUrn in it; suggest the query's requestor and TID
			String hash = "bnVsbA=="; // prevent NullPointerException for hash, put base64 encoded value for 'null'
			if((document.getChecksumValue()!=null) && (document.getChecksumValue().getValue()!=null))
				hash = document.getChecksumValue().getValue().toString(64); // radix-64
			if (hash.equals("0"))
				hash = "bnVsbA=="; // prevent NullPointerException for hash, put base64 encoded value for 'null'
				
			AttachmentType attachment = new AttachmentType(document.getMediaType().toString().toLowerCase(), url, document.getContentLength(), hash);
			ContentType[] content = new ContentType[1];
			content[0]	= new ContentType(attachment);
			theDR.setContent(content);	

			bundle.addEntry(newEntry);
			id++;
		}
	}
	
	/**
	 * Loop through documents -- sorted: latest document (...Date) first ???
	 * 
	 * @param DocumentSetResult				object to process
	 * @param String						requestor
	 * @param String						transaction Id
	 * @return Bundle						object to hold processed doc set
	 * @throws TranslationException			required exception
	 * 
	 */
	private static Bundle makeDocumentReferenceBundle(DocumentSetResult documentSetResult, String requestor, String transactionId)
	throws TranslationException
	{
		Bundle bundle = new Bundle();
	
		bundle.setId(transactionId);
		
		for(DocumentSet docSet : documentSetResult.getArtifacts())
		{	
			processDocument(bundle, docSet, requestor, transactionId);
		}
		
		return bundle;
	}
	
	/**
	 * Translate a non-DICOM format date to DICOM format date
	 * 
	 * @param Date					procedure date
	 * @return String				translated result
	 * @throws ParseException		required exception
	 * 
	 */
	private static String translate(Date procedureDate) 
	throws ParseException
	{
		String procedureDateStringAsDicom = "";
		if(procedureDate != null)
		{
			DateFormat dicomDateFormat = new DicomDateFormat();
			procedureDateStringAsDicom = dicomDateFormat.format(procedureDate);
		}
		return procedureDateStringAsDicom;
	}

}
