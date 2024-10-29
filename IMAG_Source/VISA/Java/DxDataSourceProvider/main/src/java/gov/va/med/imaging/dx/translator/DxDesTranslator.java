package gov.va.med.imaging.dx.translator;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.GlobalArtifactIdentifierFactory;
import gov.va.med.MediaType;
import gov.va.med.OID;
import gov.va.med.PatientArtifactIdentifierImpl;
import gov.va.med.WellKnownOID;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.imaging.dx.DesPollerData;
import gov.va.med.imaging.dx.DesPollerResult;
import gov.va.med.imaging.exceptions.OIDFormatException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.documents.Document;
import gov.va.med.imaging.exchange.business.documents.DocumentSet;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class DxDesTranslator {
	
	public static final Logger LOGGER = Logger.getLogger(DxDesTranslator.class);

	public static DocumentSetResult translate(DesPollerResult pollerResult) {
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		SortedSet<DocumentSet> documentSets = new TreeSet<DocumentSet>();
		
		if (pollerResult == null)
		{
			return DocumentSetResult.createFullResult(documentSets);
		}		

		DocumentSet documentSet = null;
		String patientIcn = transactionContext.getPatientID();

        LOGGER.debug("DxDesTranslator.translate() --> patientIcn: {}", patientIcn);
		
		for (DesPollerData data : pollerResult.getDesPollerDataList())
		{
			String homeCommunityId = data.getHomeCommunityId();
			String repositoryId = data.getRepositoryId();
			String documentId = data.getDocumentId();
			
			Document document = Document.create(
					data.getRecordId(), 
					getGlobalArtifactIdentifier(patientIcn, homeCommunityId, repositoryId, documentId)
				); 
			LOGGER.debug("DxDesTranslator.translate() --> document created");

			Date creationDate = null;
			if (!data.getEnteredDate().equals(""))
			{
                LOGGER.debug("DxDesTranslator.translate() --> Given creationDate: {}", data.getEnteredDate());
				creationDate = getCreationDate(data.getEnteredDate());
			}
			if (creationDate != null) {
				document.setCreationDate(creationDate);
                LOGGER.debug("DxDesTranslator.translate() --> Converted creationDate: {}", creationDate);
			}
			
			document.setClinicalType(data.getClinicalType());			
			document.setMediaType(getMediaType(data.getContentType()));
			document.setContentLength(data.getSize());
			document.setName(data.getTitle());
			document.setDescription(data.getDescription() + " [DX: " + data.getContent() + "]");
			
			OID oid = null;
			try {
				oid = OID.create(data.getOriginId());
			} catch (OIDFormatException e) {
				oid = WellKnownOID.LOINC.getCanonicalValue();
			}
			
			if(LOGGER.isDebugEnabled()) 
			{
				StringBuilder sb = new StringBuilder();
				
				sb.append("DxDesTranslator.translate() --> homeCommunityId: " + homeCommunityId);
				sb.append("                            --> repositoryId: " + repositoryId);
				sb.append("                            --> documentId: " + documentId);
				sb.append("                            --> clinicalType: " + data.getClinicalType());
				sb.append("                            --> contentType: " + data.getContentType());
				sb.append("                            --> Content size: " + data.getSize());
				sb.append("                            --> name/title: " + data.getTitle());
				sb.append("                            --> description: " + data.getDescription());
				sb.append("                            --> origin: " + oid);
				
				LOGGER.debug(sb.toString());
			}
			
			if (documentSet == null)
			{
				documentSet = new DocumentSet(
						oid,
						repositoryId, 
						homeCommunityId);
				LOGGER.debug("DxDesTranslator.translate() --> documentSet created");
			}
			
			documentSet.setPatientIcn(patientIcn);
			documentSet.add(document);			
		}
		
		if (documentSet != null)
		{
			documentSets.add( documentSet );
		}

		return DocumentSetResult.createFullResult(documentSets);
	}

	private static Date getCreationDate(String enteredDate) 
	{
		String dateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss";

		try
		{
			SimpleDateFormat df = new SimpleDateFormat(dateTimeFormat);
			Date creationDate = df.parse(enteredDate);
			return creationDate;
		}
		catch (ParseException e)
		{
            LOGGER.warn("DxDesTranslator.getCreationDate() --> Date Parse Exception Error:{}", e.getMessage());
			return null;
		}
	}

	private static GlobalArtifactIdentifier getGlobalArtifactIdentifier(
			String patientIcn,
			String homeCommunityId,
			String repositoryId, 
			String documentReferenceIdentifier)
	{
		GlobalArtifactIdentifier documentGlobalIdentifier = null;
		
		try
		{
			documentGlobalIdentifier = GlobalArtifactIdentifierFactory.create(
					homeCommunityId, 
					repositoryId, 
					documentReferenceIdentifier);
			// a PatientArtifactIdentifier includes the patient ID as an extra identifier
			documentGlobalIdentifier = PatientArtifactIdentifierImpl.create(documentGlobalIdentifier, patientIcn);
		}
		catch (GlobalArtifactIdentifierFormatException x)
		{
            LOGGER.warn("DxDesTranslator.getGlobalArtifactIdentifier() --> Encountered Id format exception: {}", x.getMessage());
		}
		catch (URNFormatException urnfX)
		{
            LOGGER.warn("DxDesTranslator.getGlobalArtifactIdentifier() --> Encountered URNFormatException: {}", urnfX.getMessage());
		}
		
		return documentGlobalIdentifier;
	}

	private static MediaType getMediaType(String contentType)
	{
		
		if (contentType.equals("text/plain"))
		{
			return MediaType.TEXT_PLAIN;
		}
		else if (contentType.equals("text/html"))
		{
			return MediaType.TEXT_HTML;
		}
		else if (contentType.equals("text/xml"))
		{
			return MediaType.TEXT_XML;
		}
		else if (contentType.equals("text/rtf"))
		{
			return MediaType.TEXT_RTF;
		}

		else if (contentType.equals("text/css"))
		{
			return MediaType.TEXT_CSS;
		}
		else if (contentType.equals("text/csv"))
		{
			return MediaType.TEXT_CSV;
		}
		else if (contentType.equals("text/rtf"))
		{
			return MediaType.TEXT_RTF;
		}
		else if (contentType.equals("text/enriched"))
		{
			return MediaType.TEXT_ENRICHED;
		}
		else if (contentType.equals("text/tab-separated-values"))
		{
			return MediaType.TEXT_TSV;
		}
		else if (contentType.equals("text/uri-list"))
		{
			return MediaType.TEXT_URI_LIST;
		}
		else if (contentType.equals("text/xml-external-parsed-entity"))
		{
			return MediaType.TEXT_XML_EXTERNAL_PARSED_ENTITY;
		}
		else if (contentType.equals("application/rtf"))
		{
			return MediaType.APPLICATION_RTF;
		}
		else if (contentType.equals("application/pdf"))
		{
			return MediaType.APPLICATION_PDF;
		}
		else if (contentType.equals("application/msword"))
		{
			return MediaType.APPLICATION_DOC;
		}
		else if (contentType.equals("application/dicom"))
		{
			return MediaType.APPLICATION_DICOM;
		}
		else if (contentType.equals("application/vnd.ms-excel"))
		{
			return MediaType.APPLICATION_EXCEL;
		}
		else if (contentType.equals("application/vnd.ms-powerpoint"))
		{
			return MediaType.APPLICATION_PPT;
		}
		else if (contentType.equals("application/vnd.openxmlformats-officedocument.wordprocessingml.document"))
		{
			return MediaType.APPLICATION_DOCX;
		}
		else if (contentType.equals("image/tiff"))
		{
			return MediaType.IMAGE_TIFF;
		}
		else if (contentType.equals("image/jpeg"))
		{
			return MediaType.IMAGE_JPEG;
		}
		else if (contentType.equals("image/png"))
		{
			return MediaType.IMAGE_PNG;
		}
		else if (contentType.equals("image/bmp"))
		{
			return MediaType.IMAGE_BMP;
		}
		else if (contentType.equals("image/x-bmp"))
		{
			return MediaType.IMAGE_XBMP;
		}
		else if (contentType.equals("image/j2k"))
		{
			return MediaType.IMAGE_J2K;
		}
		else if (contentType.equals("image/jp2"))
		{
			return MediaType.IMAGE_JP2;
		}
		else if (contentType.equals("image/x-targa"))
		{
			return MediaType.IMAGE_TGA;
		}
		else if (contentType.equals("audio/x-wav"))
		{
			return MediaType.AUDIO_WAV;
		}
		else if (contentType.equals("audio/mpeg"))
		{
			return MediaType.AUDIO_MPEG;
		}
		else if (contentType.equals("audio/mp4"))
		{
			return MediaType.AUDIO_MP4;
		}
		else if (contentType.equals("video/BMPEG"))
		{
			return MediaType.VIDEO_BMPEG;
		}
		else if (contentType.equals("video/BMPEG"))
		{
			return MediaType.VIDEO_BMPEG;
		}
		else if (contentType.equals("video/jpeg2000"))
		{
			return MediaType.VIDEO_JPEG2000;
		}
		else if (contentType.equals("video/JPEG"))
		{
			return MediaType.VIDEO_JPEG;
		}
		else if (contentType.equals("video/mp4"))
		{
			return MediaType.VIDEO_MP4;
		}
		else if (contentType.equals("video/mpeg4-generic"))
		{
			return MediaType.VIDEO_MPEG4_GENERIC;
		}
		else if (contentType.equals("video/MPEG"))
		{
			return MediaType.VIDEO_MPEG;
		}
		else if (contentType.equals("video/ogg"))
		{
			return MediaType.VIDEO_OGG;
		}
		else if (contentType.equals("video/quicktime"))
		{
			return MediaType.VIDEO_QUICKTIME;
		}
		else if (contentType.equals("video/x-msvideo"))
		{
			return MediaType.VIDEO_AVI;
		}
		else if (contentType.equals("multipart/form-data"))
		{
			return MediaType.MULTIPART_FORM_DATA;
		}
		else if (contentType.equals("multipart/mixed"))
		{
			return MediaType.MULTIPART_MIXED;
		}
		else
		{
			return MediaType.APPLICATION_OCTETSTREAM;
		}
	}
}
