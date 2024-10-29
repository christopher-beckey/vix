/**
 * 
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.rest.translator;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.documents.Document;
import gov.va.med.imaging.exchange.business.documents.DocumentSet;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.ObjectOrigin;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.study.web.configuration.ViewerStudyFacadeConfiguration;
import gov.va.med.imaging.study.web.rest.types.CprsIdentifiersType;
import gov.va.med.imaging.study.web.rest.types.ViewerQAStudyFilterType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyFilterType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyImageType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyImagesType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudySeriesType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudySeriesesType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyStudiesType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyStudyType;
import gov.va.med.imaging.tomcat.vistarealm.StringUtils;
import gov.va.med.imaging.translator.AbstractClinicalTranslator;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * @author Julian
 *
 */
public class ViewerStudyWebTranslator
extends AbstractClinicalTranslator
{
	
	public static ViewerStudyStudiesType translateStudies(List<Study> studies)
	throws MethodException
	{
		if(studies == null)
			return null;
		
		ViewerStudyStudyType result[] = new ViewerStudyStudyType[studies.size()];
		for(int i = 0; i < studies.size(); i++)
		{
			try{
				result[i] = translate(studies.get(i));
			}
			catch(MethodException mX){
				logger.warn(mX.getMessage());
			}
		}
		
		return new ViewerStudyStudiesType(result);
	}
	
	public static StudyFilter translate(ViewerStudyFilterType filter)
	{
		StudyFilter result = new StudyFilter();
		result.setMaximumAllowedLevel(PatientSensitivityLevel.ACCESS_DENIED);
		if(filter != null)
		{
			result.setOrigin(filter.getFilterOrigin());
			result.setFromDate(filter.getFromDate());
			result.setToDate(filter.getToDate());
			result.setStudy_class(filter.getFilterClass());
			result.setStudy_event(filter.getFilterEvent());
			result.setStudy_package(filter.getFilterPackage());
			result.setStudy_specialty(filter.getFilterSpecialty());
			result.setStudy_type(filter.getFilterType());
			result.setIncludePatientOrders(filter.isIncludePatientOrders());
			result.setIncludeEncounterOrders(filter.isIncludeEncounterOrders());
			result.setIncludeMuseOrders(filter.isIncludeMuseOrders());
		}
		
		return result;		
	}
	
	public static StudyFilter translate(ViewerQAStudyFilterType filter)
	{
		StudyFilter result = new StudyFilter();
		result.setMaximumAllowedLevel(PatientSensitivityLevel.ACCESS_DENIED);
		if(filter != null)
		{
			Date from = null;
			Date tru = null;
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
			try 
			{
				String fromDate = filter.getFromDate();
				from = formatter.parse(fromDate);
			}
			catch (ParseException e) 
			{
			}
		
			try 
			{
				String throughDate = filter.getToDate();
				tru = formatter.parse(throughDate);
			}
			catch (ParseException e) 
			{
			}
		
			result.setFromDate(from);
			result.setToDate(tru);
			result.setOrigin(filter.getFilterOrigin());
			result.setStudy_class(filter.getFilterClass());
			result.setStudy_event(filter.getFilterEvent());
			result.setStudy_package(filter.getFilterPackage());
			result.setStudy_specialty(filter.getFilterSpecialty());
			result.setStudy_type(filter.getFilterType());
			result.setCaptureApp(filter.getCaptureApp());
			result.setCaptureSavedBy(filter.getCaptureSavedBy());
			result.setQAStatus(filter.getQaStatus());
			result.setIncludePatientOrders(getBoolean(filter.getIncludePatientOrders()));
			result.setIncludeEncounterOrders(getBoolean(filter.getIncludeEncounterOrders()));
			result.setIncludeMuseOrders(getBoolean(filter.getIncludeMuseOrders()));
			
			String maxResult = filter.getMaximumResult();
			
			if (maxResult != null)
			{
				String maximumResultType = StringUtils.Piece(maxResult, ",", 1);
				String maximumResults = StringUtils.Piece(maxResult, ",", 2);
				
				result.setMaximumResultType(maximumResultType);
				result.setMaximumResults(Integer.parseInt(maximumResults));
			}
		}
		
		return result;		
	}

	private static boolean getBoolean(String boolString) 
	{
		if (boolString == null)
			return false;
		if (boolString.toLowerCase(Locale.ENGLISH).equals("true"))
			return true;
		return false;
	}
	
	private static ViewerStudyStudyType translate(Study study)
	throws MethodException
	{
		ViewerStudyStudyType result = new ViewerStudyStudyType();
		if(study == null)
			return result;
		
		result.setDescription(study.getDescription());
		
		result.setEvent(study.getEvent());
		result.setImageCount(study.getImageCount());
		result.setImagePackage(study.getImagePackage());
		result.setImageType(study.getImageType());
		result.setNoteTitle(study.getNoteTitle());
		result.setOrigin(study.getOrigin());
		result.setPatientId(study.getPatientIdentifier().toString());
		result.setPatientName(study.getPatientName());
		result.setProcedureDescription(study.getProcedure());
		result.setSiteNumber(study.getSiteNumber());
		result.setSiteName(study.getSiteName());
		result.setSiteAbbreviation(study.getSiteAbbr());
		result.setSpecialtyDescription(study.getSpecialty());
		result.setProcedureDate(study.getProcedureDate());
		
		result.setStudyPackage(study.getImagePackage());
		result.setStudyClass(study.getStudyClass() == null ? "" : "" + study.getStudyClass());
		result.setStudyType(study.getImageType());
		result.setCaptureDate(study.getCaptureDate());
		result.setCapturedBy(study.getCaptureBy());	
		result.setGroupIen(study.getGroupIen());
		//result.setAlternateExamNumber(study.getAlternateExamNumber());
		
		result.setDocumentDate(study.getDocumentDate());
		result.setSensitive(study.isSensitive());
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (study.getStudyUid() != null && study.getStudyUid().trim().length() > 0)
			result.setDicomUid(study.getStudyUid());
		else
			result.setDicomUid(null);
		
		//result.setStudyId(study.getStudyUrn().toString(SERIALIZATION_FORMAT.CDTP));
		// JMW 1/3/13 - using VFTP format so any additional parameters are URL encoded properly
		result.setStudyId(study.getStudyUrn().toString(SERIALIZATION_FORMAT.VFTP));
		
		if(study.getSeries() != null)
		{
			ViewerStudySeriesType [] seriesType = new ViewerStudySeriesType[study.getSeriesCount()];
			int i = 0;
			for(Series ser : study)
			{
				seriesType[i] = translate(ser);
				i++;
			}			
			result.setSeries(new ViewerStudySeriesesType(seriesType));
		}
		
		if ((study.getErrorMessage() == null) || (study.getErrorMessage().isEmpty()))
		{
		
		if(study.getFirstImage() == null)
			throw new MethodException("first image is null");
		
		ViewerStudyImageType firstImage = translate(study.getFirstImage());
		result.setFirstImage(firstImage);
		result.setFirstImageId(firstImage.getImageId());
		}
		else
		{
			result.setErrorMessage(study.getErrorMessage());
			result.setStudyId(null);
		}
		
		if(study.getModalities() != null)
			result.setStudyModalities(study.getModalities().toArray(new String [study.getModalities().size()]));
		
		if(study.getContextId() != null)
			result.setContextId(study.getContextId());
		
		if(study.getGroupIen() != null)
			result.setGroupIen(study.getGroupIen());
		
		if(study.getAlternateExamNumber() != null)
			result.setAlternateExamNumber(study.getAlternateExamNumber());
		//if(study.getAccessionNumber() != null)
		//	result.setAccessionNumber(study.getAccessionNumber());
		
		
		return result;
	}
	
	private static ViewerStudySeriesType translate(Series series)
	{
		ViewerStudySeriesType result = new ViewerStudySeriesType();
		result.setModality(series.getModality());
		//result.setSeriesIen(series.getSeriesIen());
		result.setSeriesNumber(series.getSeriesNumber());
		result.setSeriesUid(series.getSeriesUid());
		
		ViewerStudyImageType [] images = new ViewerStudyImageType[series.getImageCount()];
		int i = 0;
		for(Image image : series)
		{
			images[i] = translate(image);
			i++;
		}
		
		result.setImages(new ViewerStudyImagesType(images));
		return result;
	}
	
	private static ViewerStudyImageType translate(Image image)
	{
		ViewerStudyImageType result = new ViewerStudyImageType();
		
		if(image == null)
			return result;
		
		String imageId = image.getImageUrn().toString(SERIALIZATION_FORMAT.RAW);
		if (image.getSiteAbbr().startsWith("DOD")) 
		{	// stick to the (MIX interface required) URN format urn:bhieimage:200-<studyUID>-<serUID>-<instanceUID> -- that works in Clinical Display for DOD image retrieval
			imageId = imageId.substring(0, imageId.indexOf('['));
		}
		
		result.setImageId( imageId );		
		
		// Exchange fields
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (image.getImageUid()!= null && image.getImageUid().trim().length() > 0)
		{
			result.setDicomUid(image.getImageUid().trim());
		}
		
		
		if (image.getImageNumber() != null && image.getImageNumber().trim().length() > 0)
		{
			try
			{
				Integer imageNumber = new Integer(image.getImageNumber());
				result.setImageNumber(imageNumber);
			}
			catch (NumberFormatException ex)
			{
				result.setImageNumber(null);
			}
		}
		else
		{
			result.setImageNumber(null);
		}
		
		result.setDicomImageNumber(image.getDicomImageNumberForDisplay());
		result.setDicomSequenceNumber(image.getDicomSequenceNumberForDisplay());
		
		VistaImageType vistaImageType = VistaImageType.valueOfImageType(image.getImgType());
		result.setImageType(vistaImageType == null ? "" : "" + vistaImageType.name());
		result.setThumbnailImageUri(getThumbnailImageUri(image, imageId));
		
		String referenceImageFullUri = getReferenceImageFullUri(image, imageId);
		result.setReferenceImageUri(referenceImageFullUri);
		
		String diagnosticImageUri = getDiagnosticImageUri(image, imageId);
		result.setDiagnosticImageUri(diagnosticImageUri);

		result.setImageModality(image.getImageModality());		
		result.setCaptureDate(image.getCaptureDate());
		result.setDocumentDate(image.getDocumentDate());
		result.setSensitive(image.isSensitive());
		result.setDescription(image.getDescription());
		
		if (image.getImageStatus() != null)
			result.setImageStatus(image.getImageStatus().getDescription());
		
		if (image.getImageViewStatus() !=null)
			result.setImageViewStatus(image.getImageViewStatus().getDescription());

        logger.debug("FullFilename:{}", image.getFullFilename());
		String imageFileExt = getImgeFileExtension(image.getFullFilename());
        logger.debug("File Ext:{}", imageFileExt);

        logger.debug("DiagnosticImageUri:{}", result.getDiagnosticImageUri());
		
		if (imageFileExt != null)
		{
			if (imageFileExt.toUpperCase(Locale.ENGLISH).equals("TGA"))
			{
				result.setImageType("TGA");

				referenceImageFullUri = removeTargaFromUri(referenceImageFullUri);
				result.setReferenceImageUri(referenceImageFullUri);

				diagnosticImageUri = removeTargaFromUri(diagnosticImageUri);
				result.setDiagnosticImageUri(diagnosticImageUri);
			}
		}
		
		if (!result.getImageType().equals("TGA"))
		{
			if ((result.getDiagnosticImageUri().toLowerCase(Locale.ENGLISH).contains("application/dicom"))
					|| (result.getImageType().toLowerCase(Locale.ENGLISH).equals("dcm")) )
			{
				result.setImageType("DICOM");
			}
		}

        logger.debug("Image Type:{}", result.getImageType());

		return result;
	}

	private static String removeTargaFromUri(String imageUri) 
	{
		String[] params = imageUri.split("&");
		List<String> paramList = new ArrayList<String>();
		
		for (String param : params)
		{
			if (param.toLowerCase(Locale.ENGLISH).startsWith("contenttypewithsubtype"))
			{
				param = "contentTypeWithSubType=" + fixContentType(param);
			}
			else if (param.toLowerCase(Locale.ENGLISH).startsWith("contenttype"))
			{
				param = "contentType=" + fixContentType(param);
			}
			
			paramList.add(param);
		}
		
		return String.join("&", paramList);
	}
		
	private static String fixContentType(String imageUri) 
	{
		String[] contentType = imageUri.split("=");
		String contentTypeValue = contentType[1];
		
		String[] items = contentTypeValue.split(",");

		List<String> list = new ArrayList<String>();
		
		for(String item: items)
		{
			if ((!item.equals("image/x-targa")) &&
				(!item.equals("*/*")))
			{
				list.add(item);
			}
		}
		
		return String.join(",", list);
	}


	private static String getImgeFileExtension(String filename) 
	{
		int lastIndexOfDot = filename.lastIndexOf('.');
		 
		String fileExtension = null;
		if (lastIndexOfDot > 0) {
		    fileExtension = filename.substring(lastIndexOfDot+1);
		}
		
		return fileExtension;
	}

	
	private static String getThumbnailImageUri(Image image, String imageUrn)
	{
		if((image.getAbsFilename() != null) && (image.getAbsFilename().startsWith("-1")))
		{
			return "";
		}
		else
		{
			return "imageURN=" + imageUrn + "&imageQuality=20&contentType=" + getContentType(image, ImageQuality.THUMBNAIL);
		}
	}
	
	private  static String getReferenceImageFullUri(Image image, String imageUrn)
	{
		boolean isRadImage = isRadImage(image);
		if((image.getFullFilename() != null) && (image.getFullFilename().startsWith("-1")))
		{
			return "";
		}
		else
		{
			// in this interface, if a rad image then there is a reference quality, if not rad then no ref quality - just diagnostic
			if(isRadImage)
			{
				int imageQuality = ImageQuality.REFERENCE.getCanonical();
				return "imageURN=" + imageUrn + "&imageQuality=" + imageQuality + "&contentType=" + getContentType(image, 
						ImageQuality.REFERENCE) + "&contentTypeWithSubType=" + getContentType(image, ImageQuality.REFERENCE);
			}
			else
			{
				return "";
			}
		}
	}
	
	
	
	private static String getDiagnosticImageUri(Image image, String imageUrn)
	{
		boolean isRadImage = isRadImage(image);		
		if((image.getBigFilename() != null) && (image.getBigFilename().startsWith("-1")))
		{
			return "";
		}
		else
		{
			if(isRadImage)
			{
				return "imageURN=" + imageUrn + "&imageQuality=90&contentType=" + 
					getContentType(image, ImageQuality.DIAGNOSTIC) + "&contentTypeWithSubType=" + getContentType(image, ImageQuality.DIAGNOSTIC);
			}
			else
			{
				return "imageURN=" + imageUrn + "&imageQuality=" + ImageQuality.DIAGNOSTICUNCOMPRESSED.getCanonical() + "&contentType=" + getContentType(image, 
						ImageQuality.REFERENCE);
			}
		}		
	}
	
	private static String getContentType(Image image, ImageQuality imageQuality)
	{
		return  getContentType(image, imageQuality, ViewerStudyFacadeConfiguration.getConfiguration());
	}
	
	public static List<CprsIdentifier> translateCprsIdentifiers(CprsIdentifiersType cprsIdentifiers)
	{
		if(cprsIdentifiers == null)
			return null;
		
		List<CprsIdentifier> cprsIdentifierList = new ArrayList<CprsIdentifier>();
		
		for(String cprsIdentifier : cprsIdentifiers.getCprsIdentifiers())
		{
			if(isCprsIdentifierValid(cprsIdentifier)){
				cprsIdentifierList.add(new CprsIdentifier(cprsIdentifier));
			}
			else{
                logger.debug("Removed invalid CPRS Identifier: {}", cprsIdentifier);
			}
		}
		return cprsIdentifierList;
	}

	public static List<CprsIdentifier> translateCprsIdentifier(String cprsIdentifier)
	{
		if(cprsIdentifier == null)
			return null;
		
		List<CprsIdentifier> cprsIdentifierList = new ArrayList<CprsIdentifier>();
		
		if(isCprsIdentifierValid(cprsIdentifier)){
			cprsIdentifierList.add(new CprsIdentifier(cprsIdentifier));
		}
		else{
            logger.debug("Removed invalid CPRS Identifier: {}", cprsIdentifier);
		}
		return cprsIdentifierList;
	}

	public static boolean isCprsIdentifierValid(String cprsIdentifier){
		
		if(cprsIdentifier.startsWith("urn")){
			return true;
		}
		String rpt = StringUtil.Piece(cprsIdentifier, StringUtil.CARET, 1);
		if(!rpt.equals("RPT")){
			return false;
		}
		 String cprs = StringUtil.Piece(cprsIdentifier, StringUtil.CARET, 2);
		 if(!cprs.equals("CPRS")){
			 return false;
		 }
		 String pkg = StringUtil.Piece(cprsIdentifier, StringUtil.CARET, 4);
		 if(!pkg.equals("TIU") && !pkg.equals("RA")){
			 return false;
		 }
		 
		 return true;
	}

	public static List<ViewerStudyStudyType> translateDocumentSetResult(DocumentSetResult documentSetResult)
	throws TranslationException
	{
		List<ViewerStudyStudyType> result = new ArrayList<ViewerStudyStudyType>(); 
		
		if(documentSetResult != null && documentSetResult.getArtifacts() != null)
		{
			for(DocumentSet documentSet : documentSetResult.getArtifacts())
			{
				List<ViewerStudyStudyType> studiesType = translateDocumentSet(documentSet);
				if(studiesType != null)
					result.addAll(studiesType);
			}
		}
		
		return result;
	}
	
	public static List<ViewerStudyStudyType> translateDocumentSetResultWithImages(
			DocumentSetResult documentSetResult,
			String cprsIdentifier)
	throws TranslationException
	{
		List<ViewerStudyStudyType> result = new ArrayList<ViewerStudyStudyType>(); 
		
		if(documentSetResult != null && documentSetResult.getArtifacts() != null)
		{
			for(DocumentSet documentSet : documentSetResult.getArtifacts())
			{
				List<ViewerStudyStudyType> studiesType = translateDocumentSetWithImages(documentSet, cprsIdentifier);
				if(studiesType != null)
					result.addAll(studiesType);
			}
		}
		
		return result;
	}

	private static List<ViewerStudyStudyType> translateDocumentSet(DocumentSet documentSet)
	{
		List<ViewerStudyStudyType> result = new ArrayList<ViewerStudyStudyType>();
		if(documentSet == null)
			return result;
			
		for(Document document : documentSet)
		{
			ViewerStudyStudyType studyType = new ViewerStudyStudyType();
			
			VistaImageType vistaImageType = getImageType(getStudyFacadeConfiguration(), document);
			if(vistaImageType == null)
			{
				vistaImageType = VistaImageType.UNKNOWN_IMAGING_TYPE;
                logger.debug("Document with media type '{}', returning VistaImageType of '{}' for Clinical Display.", document.getMediaType(), vistaImageType);
			}		
			String id = document.getGlobalArtifactIdentifier().toString(SERIALIZATION_FORMAT.CDTP);
			
			studyType.setStudyId(id);
			studyType.setPatientId(documentSet.getPatientIcn());
			studyType.setPatientName(documentSet.getPatientName());
			studyType.setSiteAbbreviation(documentSet.getSiteAbbr());
			Date procedureDate = null;
			if(documentSet.getProcedureDate() != null)
			{
				procedureDate = documentSet.getProcedureDate();
			}
			else
			{
				if(document.getCreationDate() != null)
				{
					procedureDate = document.getCreationDate();
					logger.debug("DocumentSet ProcedureDate is null, using Document CreationDate");
				}
				else
				{
					logger.debug("DocumentSet ProcedureDate and Document CreationDate are both null.");
				}					
			}
			studyType.setProcedureDate(procedureDate);
			studyType.setProcedureDescription(document.getName());
			studyType.setImageType(vistaImageType.getImageType() + "");
			studyType.setImageCount(1);
			studyType.setFirstImage(translate(documentSet, document, vistaImageType));
//				studyType.setStudyStatus(ViewerStudyObjectStatusType.NO_STATUS);
//				studyType.setStudyViewStatus(ViewerStudyObjectStatusType.NO_STATUS);
			studyType.setSensitive(false);
			studyType.setOrigin("DOD");
			studyType.setSiteAbbreviation("DoD");
			
			if((WellKnownOID.HAIMS_DOCUMENT.isApplicable(document.getGlobalArtifactIdentifier().getHomeCommunityId()) || 
					(ncatRepositoryId.equals(document.getRepositoryId()))))
			{
				studyType.setSiteNumber("200");
			}				
			else
			{
				// this should be a VA document, set the site number to the repository (there should not actually 
				// be VA documents here but just in case)
				studyType.setSiteNumber(document.getRepositoryId());
			}
//				studyType.setStudyCanHaveReport(false);
//				studyType.setStudyHasImageGroup(false);
			
			result.add(studyType);			
		}
		
		return result;
	}

	private static List<ViewerStudyStudyType> translateDocumentSetWithImages(
			DocumentSet documentSet,
			String cprsIdentifier)
	{
		List<ViewerStudyStudyType> result = new ArrayList<ViewerStudyStudyType>();
		if((documentSet == null) || (documentSet.size() == 0))
			return result;
			
		ViewerStudyImageType[] images = new ViewerStudyImageType[documentSet.size()];
        logger.debug("Translating DocumentSet to images. cprsIdentifier = {}", cprsIdentifier);
		for(Document document : documentSet)
		{
			VistaImageType vistaImageType = getImageType(getStudyFacadeConfiguration(), document);
			if(vistaImageType == null)
			{
				vistaImageType = VistaImageType.UNKNOWN_IMAGING_TYPE;
                logger.debug("Document with media type '{}', returning VistaImageType of '{}' for Clinical Display.", document.getMediaType(), vistaImageType);
			}		
			String imageId = document.getGlobalArtifactIdentifier().toString(SERIALIZATION_FORMAT.CDTP);
            logger.debug("Translating document to image = {}", imageId);
			if (cprsIdentifier.equals(imageId))
			{
				images[0] = translate(documentSet,document, vistaImageType);
				break;
			}
		}
		
		logger.debug("Creating ViewerStudySeriesType");
		ViewerStudySeriesType seriesType = new ViewerStudySeriesType();
		seriesType.setSeriesNumber("1");
		seriesType.setSeriesUid(documentSet.getIdentifier());
		seriesType.setImages(new ViewerStudyImagesType(images));
		
		ViewerStudySeriesType[] serieses = new ViewerStudySeriesType[1];
		serieses[0] = seriesType;
		
		logger.debug("Creating ViewerStudySeriesesType");
		ViewerStudySeriesesType seriesesType = new ViewerStudySeriesesType(serieses);
		
		logger.debug("Creating ViewerStudyStudyType");
		ViewerStudyStudyType studyType = new ViewerStudyStudyType();
		//String id = document.getGlobalArtifactIdentifier().toString(SERIALIZATION_FORMAT.CDTP);
				
		studyType.setStudyId(documentSet.getIdentifier());
		studyType.setPatientId(documentSet.getPatientIcn());
		studyType.setPatientName(documentSet.getPatientName());
		studyType.setSiteAbbreviation(documentSet.getSiteAbbr());
		Date procedureDate = null;
		if(documentSet.getProcedureDate() != null)
		{
			procedureDate = documentSet.getProcedureDate();
			studyType.setProcedureDate(procedureDate);
		}
		studyType.setImageCount(documentSet.size());
		studyType.setFirstImage(images[0]);
		studyType.setSensitive(false);
		studyType.setOrigin("DOD");
		studyType.setSiteAbbreviation("DoD");
		studyType.setSiteNumber("200");
		studyType.setSeries(seriesesType);

		result.add(studyType);			
		logger.debug("Study created");
		return result;
	}

	private static ViewerStudyImageType translate(DocumentSet documentSet, 
			Document document, VistaImageType vistaImageType)
	{
		ViewerStudyImageType image = 
			new ViewerStudyImageType();
		image.setImageId(document.getGlobalArtifactIdentifier().toString(SERIALIZATION_FORMAT.CDTP));
		image.setImageType(vistaImageType.name());
		image.setSensitive(false);
//		image.setImageStatus(ViewerStudyObjectStatusType.NO_STATUS);
//		image.setImageViewStatus(ViewerStudyObjectStatusType.NO_STATUS);
		image.setThumbnailImageUri(""); // no thumbnail for artifacts
        logger.debug("ImageURN before replacing [ ] {}", image.getImageId());
		//Viewer decodes encoded uri during image request which is causing request error.
		//The workaround is to send the uri un-encoded by replacing "[]" with ":" in metadata request  
		//and replace back ":" with "[]" in image request
		String transformedImageId = replaceBracketWithColonInImageurn(image.getImageId());
        logger.debug("ImageURN after transform = {}", transformedImageId);
		image.setDiagnosticImageUri(
					"imageURN=" + transformedImageId +
					"&imageQuality=" + ImageQuality.DIAGNOSTICUNCOMPRESSED.getCanonical() + 
					"&contentType=" + document.getMediaType().toString().toLowerCase());
		image.setReferenceImageUri("");
		return image;
	}

	public static String replaceBracketWithColonInImageurn(String imageUrn) 
	{
		if (imageUrn.startsWith("urn:paid:") && imageUrn.contains("[") && imageUrn.endsWith("]"))
		{
			int lastIndex = imageUrn.lastIndexOf("[");
			String imageUrnWithoutPatient = imageUrn.substring(0, lastIndex);
			String patientId = imageUrn.substring(lastIndex+1, imageUrn.length()-1);
			return imageUrnWithoutPatient + ":" + patientId;
		}
		else
		{
			return imageUrn;
		}
	}

	private synchronized static ViewerStudyFacadeConfiguration getStudyFacadeConfiguration()
	{
		try
		{
			return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(
					ViewerStudyFacadeConfiguration.class);
		}
		catch(CannotLoadConfigurationException clcX)
		{
			// no need to log, already logged
			return null;
		}
	}

}
