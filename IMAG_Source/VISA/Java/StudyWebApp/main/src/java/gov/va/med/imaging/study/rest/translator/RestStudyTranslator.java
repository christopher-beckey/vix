/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 16, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.study.rest.translator;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.StoredStudyFilterURN;
import gov.va.med.imaging.awiv.AwivEncryption;
import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.business.documents.Document;
import gov.va.med.imaging.exchange.business.documents.DocumentSet;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.ObjectStatus;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.study.StudyFacadeFilter;
import gov.va.med.imaging.study.configuration.StudyFacadeConfiguration;
import gov.va.med.imaging.study.rest.types.*;
import gov.va.med.imaging.translator.AbstractClinicalTranslator;
import gov.va.med.logging.Logger;

import java.util.*;
import java.util.Map.Entry;

/**
 * @author VHAISWWERFEJ
 *
 */
public class RestStudyTranslator extends AbstractClinicalTranslator {
	
	private final static Logger LOGGER = Logger.getLogger(RestStudyTranslator.class);
	private static Map<ObjectStatus, StudyObjectStatusType> objectStatusMap;
	
	static {
		objectStatusMap = new HashMap<ObjectStatus, StudyObjectStatusType>();
		objectStatusMap.put(ObjectStatus.CONTROLLED, StudyObjectStatusType.CONTROLLED);
		objectStatusMap.put(ObjectStatus.DELETED, StudyObjectStatusType.DELETED);
		objectStatusMap.put(ObjectStatus.IMAGE_GROUP, StudyObjectStatusType.IMAGE_GROUP);
		objectStatusMap.put(ObjectStatus.IN_PROGRESS, StudyObjectStatusType.IN_PROGRESS);
		objectStatusMap.put(ObjectStatus.NEEDS_REFRESH, StudyObjectStatusType.NEEDS_REFRESH);
		objectStatusMap.put(ObjectStatus.NEEDS_REVIEW, StudyObjectStatusType.NEEDS_REVIEW);
		objectStatusMap.put(ObjectStatus.NO_STATUS, StudyObjectStatusType.NO_STATUS);
		objectStatusMap.put(ObjectStatus.QA_REVIEWED, StudyObjectStatusType.QA_REVIEWED);
		objectStatusMap.put(ObjectStatus.QUESTIONABLE_INTEGRITY, StudyObjectStatusType.QUESTIONABLE_INTEGRITY);
		objectStatusMap.put(ObjectStatus.RAD_EXAM_STATUS_BLOCK, StudyObjectStatusType.RAD_EXAM_STATUS_BLOCK);
		objectStatusMap.put(ObjectStatus.TIU_AUTHORIZATION_BLOCK, StudyObjectStatusType.TIU_AUTHORIZATION_BLOCK);
		objectStatusMap.put(ObjectStatus.UNKNOWN, StudyObjectStatusType.UNKNOWN);
		objectStatusMap.put(ObjectStatus.VIEWABLE, StudyObjectStatusType.VIEWABLE);
	}
	
	protected static Logger getLogger()	{
		return LOGGER;
	}
	
	public static StudyFacadeFilter tranlsate(StudyFilterType studyFilter) {
		
		StudyFacadeFilter filter = null;
		
		if(studyFilter == null)	{
			filter = StudyFacadeFilter.createAllFilter();
			// VAI-1202: this is for GET request
			filter.setIncludeMuseOrders(false);
		} else {
			switch(studyFilter.getResultType())	{
				case artifacts:
					filter = StudyFacadeFilter.createArtifactsFilter();
					break;
				case radiology:
					filter = StudyFacadeFilter.createRadiologyFilter();
					filter.setIncludeMuseOrders(false); 		// VAI-1202: this is for POST request
					break;
				case all:
					filter = StudyFacadeFilter.createAllFilter();
					filter.setIncludeMuseOrders(false); 		// VAI-1202: this is for POST request
					break;
				default:
					//cl_ type of results
					filter = StudyFacadeFilter.createSpecializationFilter(studyFilter.getResultType());
					filter.setIncludeMuseOrders(false); 		// VAI-1202: this is for POST request
					break;
			}
			
			filter.setFromDate(studyFilter.getFromDate());
			filter.setToDate(studyFilter.getToDate());
			filter.setModalityCodes(studyFilter.getModalityCodes());
			filter.setCptCodes(studyFilter.getCptCodes());
			
			if(studyFilter.getStoredFilterId() != null)	{
				try {
					StoredStudyFilterURN storedStudyFilterUrn = URNFactory.create(studyFilter.getStoredFilterId(), SERIALIZATION_FORMAT.CDTP, StoredStudyFilterURN.class);			
					filter.setStoredStudyFilterUrn(storedStudyFilterUrn);

				} catch(URNFormatException urnfX) {
					LOGGER.warn("[URNFormatException]: " + urnfX.getMessage());
				}
			}
		}
		
		filter.setMaximumAllowedLevel(PatientSensitivityLevel.DISPLAY_WARNING_REQUIRE_OK);
				
		return filter;
	}
	
	public static StudiesResultType translate(ArtifactResults artifactResults)
	throws TranslationException {
		
		return artifactResults == null ? null : new StudiesResultType(translateArtifactResults(artifactResults), 
				translateErrors(artifactResults), artifactResults.isPartialResult());	
	}
	
	private static StudySourceErrorsType translateErrors(ArtifactResults artifactResults) {
		
		if(artifactResults == null) {
			LOGGER.warn("translateErrors(ArtifactResults) --> Given 'artifacts' is null. Return empty StudySourceErrorsType");
			return new StudySourceErrorsType();
		}
		
		List<StudySourceErrorType> errors = new ArrayList<StudySourceErrorType>();
		
		if(artifactResults.getStudySetResult().getArtifactResultErrors() != null) {
			errors.addAll(translateErrors(artifactResults.getStudySetResult().getArtifactResultErrors()));
		}
		
		if(artifactResults.getDocumentSetResult() != null && artifactResults.getDocumentSetResult().getArtifactResultErrors() != null) {
			errors.addAll(translateErrors(artifactResults.getDocumentSetResult().getArtifactResultErrors()));
		}
		
		return new StudySourceErrorsType(errors.toArray(new StudySourceErrorType[errors.size()]));
	}
	
	private static List<StudySourceErrorType> translateErrors(List<ArtifactResultError> errors) {
		
		List<StudySourceErrorType> result = new ArrayList<StudySourceErrorType>();
		
		if(errors == null) {
			LOGGER.warn("translateErrors(List<ArtifactResultError>) --> Given 'errors' is null. Return empty List<StudySourceErrorType>");
			return result;
		}

		for(ArtifactResultError error : errors) {
			result.add(translate(error));
		}
		
		return result;
	}
	
	private static StudySourceErrorType translate(ArtifactResultError error) {
		
		return error == null ? new StudySourceErrorType() : new StudySourceErrorType(error.getCodeContext(), error.getSeverity().name(), 
																					 error.getLocation(), error.getErrorCode().name());
	}
	
	private static StudiesType translateArtifactResults(ArtifactResults artifactResults)
	throws TranslationException {
		
		if(artifactResults == null) {
			LOGGER.warn("translateArtifactResults(ArtifactResults) --> Given 'artifactResults' is null. Return null.");
			return null;
		}
		
		List<StudyType> result = new ArrayList<StudyType>();
		result.addAll(translate(artifactResults.getDocumentSetResult()));
		result.addAll(translate(artifactResults.getStudySetResult()));
		
		return new StudiesType(result.toArray(new StudyType[result.size()]));		
	}
	
	private static List<StudyType> translate(StudySetResult studySetResult)
	throws TranslationException {
		
		List<StudyType> result = new ArrayList<StudyType>(); 
		if(studySetResult != null && studySetResult.getArtifacts() != null) {
			
			for(Study study : studySetResult.getArtifacts()) {
				StudyType studyType = translate(study, false);
				if(studyType != null)
					result.add(studyType);
			}
		}
		
		return result;
	}
	
	private static StudyType translate(Study study, boolean includeImages)
	throws TranslationException {
		
		StudyType result = includeImages ? new LoadedStudyType() : new StudyType();
		
		if(study == null) {
			LOGGER.warn("translate(Study, includeImages) --> Given 'study' is null. Return empty " + (includeImages ? "LoadedStudyType" : "StudyType"));
			return result;
		}
		
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
		result.setStudyClass(study.getStudyClass() == null ? "" : study.getStudyClass());
		result.setStudyType(study.getImageType());
		result.setCaptureDate(study.getCaptureDate());
		result.setCapturedBy(study.getCaptureBy());	
		
		result.setDocumentDate(study.getDocumentDate());
		result.setSensitive(study.isSensitive());
		result.setStudyStatus(translate(study.getStudyStatus()));
		result.setStudyViewStatus(translate(study.getStudyViewStatus()));
		result.setCptCode(study.getCptCode());
		result.setAccessionNumber(study.getAccessionNumber());
		
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (study.getStudyUid() != null && study.getStudyUid().trim().length() > 0)
			result.setDicomUid(study.getStudyUid());
		else
			result.setDicomUid(null);

		// JMW 1/3/13 - using VFTP format so any additional parameters are URL encoded properly
		result.setStudyId(study.getStudyUrn().toString(SERIALIZATION_FORMAT.VFTP));
		
		if(study.getSeries() != null && includeImages) {
			
			StudySeriesType [] seriesType = new StudySeriesType[study.getSeriesCount()];
			int i = 0;
			
			for(Series ser : study) {
				seriesType[i] = translate(ser);
				i++;
			}			
			
			((LoadedStudyType)result).setSeries(new StudySeriesesType(seriesType));
		}
		
		if(study.getFirstImage() == null)
			throw new TranslationException("Study.firstImage is null, translation of study [" + study.getStudyUrn() + "]. Cannot continue.");
		
		StudyImageType firstImage = translate(study.getFirstImage());
		result.setFirstImage(firstImage);
		result.setFirstImageId(firstImage.getImageId());
		
		if(study.getModalities() != null)
			result.setStudyModalities(study.getModalities().toArray(new String [study.getModalities().size()]));
		
		result.setStudyImagesHaveAnnotations(study.isStudyImagesHaveAnnotations());
		result.setAwivParameters(translateAwivParameters(study));
		result.setStudyCanHaveReport(true);
		result.setStudyHasImageGroup(true);
		result.setNumberOfDicomImages(study.getNumberOfDicomImages());
		
		result.setNumberOfNonDicomImages(study.getImageCount() - study.getNumberOfDicomImages());
		
		if(study.getRadiologyReport() != null && study.getRadiologyReport().isEmpty()) {
			result.setRadiologyReport(null);
		} else {
			result.setRadiologyReport(study.getRadiologyReport());
		}
		
		return result;
	}
	
	private static StudySeriesType translate(Series series) {
		
		StudySeriesType result = new StudySeriesType();
		
		result.setModality(series.getModality());
		result.setDescription(series.getDescription());
		result.setSeriesNumber(series.getSeriesNumber());
		result.setSeriesUid(series.getSeriesUid());
		
		StudyImageType [] images = new StudyImageType[series.getImageCount()];
		int i = 0;
		
		for(Image image : series) {
			images[i] = translate(image);
			i++;
		}
		
		result.setImages(new StudyImagesType(images));
		
		return result;
	}
	
	private static String translateAwivParameters(Study study) {
		
		try	{
			//TODO: need way to get patient SSN
			return AwivEncryption.encryptParameters(study.getPatientName(), "", study.getPatientId(),
					study.getStudyUrn().toStringCDTP(), study.getSiteNumber(),
					getStudyFacadeConfiguration().getSiteServiceUrl(), 
					getStudyFacadeConfiguration().getCvixSiteNumber(), AwivEncryption.viewTypeVistaImaging,
					AwivEncryption.ncatDoesNotHasKey, study.getSiteNumber());
		} catch(AesEncryptionException aeX)	{
			LOGGER.warn("Error creating AWIV encrypted parameters for study [" + study.getStudyUrn().toStringCDTP() + "]: " + aeX.getMessage());
			return null;
		}
	}
	
	private static List<StudyType> translate(DocumentSetResult documentSetResult)
	throws TranslationException {
		
		List<StudyType> result = new ArrayList<StudyType>();
		
		if(documentSetResult != null && documentSetResult.getArtifacts() != null) {
			for(DocumentSet documentSet : documentSetResult.getArtifacts()) {
				List<StudyType> studiesType = translate(documentSet);
				if(studiesType != null)
					result.addAll(studiesType);
			}
		}
		
		return result;
	}
	
	private static List<StudyType> translate(DocumentSet documentSet) {
		
		List<StudyType> result = new ArrayList<StudyType>();
		if(documentSet == null)
			return result;
			
			for(Document document : documentSet) {
				StudyType studyType = new StudyType();
				
				VistaImageType vistaImageType = getImageType(getStudyFacadeConfiguration(), document);
				if(vistaImageType == null) {
					vistaImageType = VistaImageType.UNKNOWN_IMAGING_TYPE;
					if(LOGGER.isDebugEnabled()) LOGGER.debug("Document with media type [" + document.getMediaType() + "], returning VistaImageType of [" + vistaImageType + "] for Clinical Display.");
				}
				
				String id = document.getGlobalArtifactIdentifier().toString(SERIALIZATION_FORMAT.CDTP);
				
				studyType.setStudyId(id);
				studyType.setPatientId(documentSet.getPatientIcn());
				studyType.setPatientName(documentSet.getPatientName());
				studyType.setSiteAbbreviation(documentSet.getSiteAbbr());
				
				Date procedureDate = null;
				if(documentSet.getProcedureDate() != null) {
					procedureDate = documentSet.getProcedureDate();
				} else {
					if(document.getCreationDate() != null) {
						procedureDate = document.getCreationDate();
						if(LOGGER.isDebugEnabled()) LOGGER.debug("DocumentSet ProcedureDate is null, using Document CreationDate");
					} else if(LOGGER.isDebugEnabled()) {
						LOGGER.debug("DocumentSet ProcedureDate and Document CreationDate are both null.");
					}					
				}
				
				studyType.setProcedureDate(procedureDate);
				studyType.setProcedureDescription(document.getName());
				studyType.setImageType(vistaImageType.getImageType() + "");
				studyType.setImageCount(1);
				studyType.setFirstImage(translate(documentSet, document, vistaImageType));
				studyType.setStudyStatus(StudyObjectStatusType.NO_STATUS);
				studyType.setStudyViewStatus(StudyObjectStatusType.NO_STATUS);
				studyType.setSensitive(false);
				studyType.setOrigin("DOD");
				studyType.setSiteAbbreviation("DoD");
				
				if((WellKnownOID.HAIMS_DOCUMENT.isApplicable(document.getGlobalArtifactIdentifier().getHomeCommunityId()) || 
						(ncatRepositoryId.equals(document.getRepositoryId())))) {
					studyType.setSiteNumber("200");
				} else {
					// this should be a VA document, set the site number to the repository (there should not actually 
					// be VA documents here but just in case)
					studyType.setSiteNumber(document.getRepositoryId());
				}
				
				studyType.setStudyCanHaveReport(false);
				studyType.setStudyHasImageGroup(false);
				result.add(studyType);			
			}
		
		return result;
	}
	
	private static StudyImageType translate(DocumentSet documentSet, 
			Document document, VistaImageType vistaImageType) {
		
		StudyImageType image = 	new StudyImageType();
		image.setImageId(document.getGlobalArtifactIdentifier().toString(SERIALIZATION_FORMAT.CDTP));
		image.setImageType(vistaImageType.name());
		image.setSensitive(false);
		image.setImageStatus(StudyObjectStatusType.NO_STATUS);
		image.setImageViewStatus(StudyObjectStatusType.NO_STATUS);
		image.setThumbnailImageUri(""); // no thumbnail for artifacts
		image.setDiagnosticImageUri("imageURN=" + image.getImageId() + "&imageQuality=" + ImageQuality.DIAGNOSTICUNCOMPRESSED.getCanonical() + "&contentType=" + document.getMediaType().toString().toLowerCase());
		image.setReferenceImageUri("");
		
		// Patch 122 fields
		image.setAssociatedNoteResulted("");		
		image.setImageHasAnnotations(false);
		
		return image;
	}
	
	public static StudyImageType translate(Image image) {
		
		StudyImageType result = new StudyImageType();
		
		if(image == null) {
			LOGGER.warn("translate(Image) --> Given 'image' is null. Return empty StudyImageType.");
			return result;
		}
		
		String imageId = image.getImageUrn().toString(SERIALIZATION_FORMAT.VFTP);
		
		result.setImageId( imageId );		
		
		// Exchange fields
		// return null for the UID instead of the empty string to be consistent with the WSDL - DKB
		if (image.getImageUid()!= null && image.getImageUid().trim().length() > 0) {
			result.setDicomUid(image.getImageUid().trim());
		}
		
		if (image.getImageNumber() != null && image.getImageNumber().trim().length() > 0) {
			try {
				result.setImageNumber(new Integer(image.getImageNumber()));
			} catch (NumberFormatException ex) {
				// not a number - return null
				result.setImageNumber(null);
			}
		} else {
			result.setImageNumber(null);
		}
		
		// Clinical Display fields
		result.setDicomImageNumber(image.getDicomImageNumberForDisplay());
		result.setDicomSequenceNumber(image.getDicomSequenceNumberForDisplay());
		
		VistaImageType vistaImageType = VistaImageType.valueOfImageType(image.getImgType());
		result.setImageType(vistaImageType == null ? "" : vistaImageType.name());
		boolean isDicom = false;
		if(vistaImageType != null) {
			switch(vistaImageType) {
				case DICOM:
				case XRAY:
				case ECG:
					isDicom = true;
				default:
					isDicom = false;
			}
		}
		
		result.setDicom(isDicom);
		result.setThumbnailImageUri(getThumbnailImageUri(image, imageId));
		result.setReferenceImageUri(getReferenceImageFullUri(image, imageId));
		result.setDiagnosticImageUri(getDiagnosticImageUri(image, imageId));

		result.setImageModality(image.getImageModality());		
		result.setAssociatedNoteResulted(image.getAssociatedNoteResulted());
		result.setImageHasAnnotations(image.isImageHasAnnotations());
		
		result.setCaptureDate(image.getCaptureDate());
		result.setDocumentDate(image.getDocumentDate());
		result.setSensitive(image.isSensitive());
		result.setImageViewStatus(translate(image.getImageViewStatus()));
		result.setImageStatus(translate(image.getImageStatus()));
		
		return result;
	}
	
	private static String getThumbnailImageUri(Image image, String imageUrn) {
		if((image.getAbsFilename() != null) && (image.getAbsFilename().startsWith("-1"))) {
			return "";
		} else {
			return "imageURN=" + imageUrn + "&imageQuality=20&contentType=" + getContentType(image, ImageQuality.THUMBNAIL, 
					getStudyFacadeConfiguration());
		}
	}
	
	private  static String getReferenceImageFullUri(Image image, String imageUrn) {
		
		boolean isRadImage = isRadImage(image);
		
		if((image.getFullFilename() != null) && (image.getFullFilename().startsWith("-1"))) {
			return "";
		} else {
			// in this interface, if a rad image then there is a reference quality, if not rad then no ref quality - just diagnostic
			if(isRadImage) 	{
				int imageQuality = ImageQuality.REFERENCE.getCanonical();
				return "imageURN=" + imageUrn + "&imageQuality=" + imageQuality + "&contentType=" + getContentType(image, 
						ImageQuality.REFERENCE, getStudyFacadeConfiguration());	
			} else {
				return "";
			}
		}
	}
	
	private static String getDiagnosticImageUri(Image image, String imageUrn) {
		
		boolean isRadImage = isRadImage(image);
		
		if((image.getBigFilename() != null) && (image.getBigFilename().startsWith("-1"))) {
			return "";
		} else {
			if(isRadImage) {
				return "imageURN=" + imageUrn + "&imageQuality=90&contentType=" + 
					getContentType(image, ImageQuality.DIAGNOSTIC, getStudyFacadeConfiguration());
			} else {
				return "imageURN=" + imageUrn + "&imageQuality=" + ImageQuality.DIAGNOSTICUNCOMPRESSED.getCanonical() + "&contentType=" + getContentType(image, 
						ImageQuality.REFERENCE, getStudyFacadeConfiguration());
			}
		}		
	}
	
	private static StudyObjectStatusType translate(ObjectStatus objectStatus) {
		
		for(Entry<ObjectStatus, StudyObjectStatusType> entry : objectStatusMap.entrySet()) {
			if(entry.getKey() == objectStatus)
				return entry.getValue();
		}
		
		return StudyObjectStatusType.UNKNOWN;
	}

	private static StudyFacadeConfiguration getStudyFacadeConfiguration() {
		
		return StudyFacadeConfiguration.getConfiguration();
	}
	
	public static LoadedStudyType translateLoadedStudy(Study study)
	throws TranslationException {
		
		StudyType studyType = translate(study, true);
		
		if(studyType == null)
			return null;
		
		return (LoadedStudyType)studyType;
	}
	
	private static StoredFilterType translate(StoredStudyFilter storedStudyFilter) {
		
		StoredFilterType result = new StoredFilterType();
		result.setId(storedStudyFilter.getStoredStudyFilterUrn().toString());
		result.setName(storedStudyFilter.getName());
		
		return result;
	}
	
	public static StoredFiltersType translateStoredFilters(List<StoredStudyFilter> storedStudyFilters) {
		
		if(storedStudyFilters == null)
			return null;
		
		StoredFilterType [] result = new StoredFilterType[storedStudyFilters.size()];
		for(int i = 0; i < storedStudyFilters.size(); i++) {
			result[i] = translate(storedStudyFilters.get(i));
		}
		
		return new StoredFiltersType(result);
	}
	
	public static StudiesType translateStudies(List<Study> studies)
	throws TranslationException {
		
		if(studies == null)
			return null;
		
		StudyType [] result = new StudyType[studies.size()];
		
		for(int i = 0; i < studies.size(); i++) {
			Study study = studies.get(i);
			StudyType studyType = translate(study, true);
			if(studyType != null)
				result[i] = studyType;
		}
		
		return new StudiesType(result);
	}
}

