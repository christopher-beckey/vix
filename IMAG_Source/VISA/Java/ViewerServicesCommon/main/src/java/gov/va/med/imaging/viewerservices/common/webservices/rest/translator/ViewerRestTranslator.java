package gov.va.med.imaging.viewerservices.common.webservices.rest.translator;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import gov.va.med.PatientIdentifier;
import gov.va.med.StudyURNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.P34StudyURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.WorkItemTag;
import gov.va.med.imaging.exchange.business.WorkItemTags;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.translator.AbstractClinicalTranslator;
import gov.va.med.imaging.viewerservices.common.webservices.rest.type.PreCacheNotificationImageType;
import gov.va.med.imaging.viewerservices.common.webservices.rest.type.PreCacheNotificationImagesType;
import gov.va.med.imaging.viewerservices.common.webservices.rest.type.PreCacheNotificationSeriesType;
import gov.va.med.imaging.viewerservices.common.webservices.rest.type.PreCacheNotificationSeriesesType;
import gov.va.med.imaging.viewerservices.common.webservices.rest.type.PreCacheNotificationStudyType;
import gov.va.med.imaging.viewerservices.common.webservices.rest.type.PreCacheNotificationType;
import gov.va.med.imaging.viewerservices.configuration.ViewerContentTypeConfiguration;

public class ViewerRestTranslator 
extends AbstractClinicalTranslator
{

	public static PreCacheNotificationType translate(List<WorkItem> items) throws URNFormatException
	{
		List<PreCacheNotificationStudyType> studies = new ArrayList<PreCacheNotificationStudyType>();
		for (WorkItem item : items)
		{
			WorkItemTags tags = item.getTags();
			String description = "";
			String imageIen = "";
			String studyIen = "";
			String patientIcn = "";
			String modality = null;
			String storage = "";
			String type = "";
			String bigFilename = "";
			String contextId = "";
			int imgType = 0;
			
			for(WorkItemTag tag : tags.getTags())
			{
				String key = tag.getKey().toLowerCase(Locale.ENGLISH);
				String value = tag.getValue();
				
				if (key.equals("contextid"))
				{
					contextId = value.replace('~', '^');
				} 
				else if (key.equals("patienticn"))
				{
					patientIcn = value;
				} 
				else if (key.equals("studyien"))
				{
					studyIen= value;
				}
				else if (key.equals("imageien"))
				{
					imageIen = value;
				}
				else if (key.equals("storage"))
				{
					storage = value;
				}
				else if (key.equals("imageshortdescr"))
				{
					description = value;
				}
				else if (key.equals("imagemodality"))
				{
					modality = value;
				}
				else if (key.equals("imagefilename"))
				{
					bigFilename = value;
				}
				else if (key.equals("imageobjecttype"))
				{
					if (!value.isEmpty())
					{
						imgType = Integer.parseInt(value);
						VistaImageType vistaImageType = VistaImageType.valueOfImageType(imgType);
						type = vistaImageType == null ? "" : "" + vistaImageType.name();
						
					}
				}
			}
			
			PatientIdentifier patientIdentifier = PatientIdentifier.icnPatientIdentifier(patientIcn);
			PreCacheNotificationImageType imageType = null;

			if (!imageIen.isEmpty())
			{
				if (studyIen.isEmpty())
					studyIen = imageIen;
				
				Image image = Image.create(
						item.getPlaceId(),
						imageIen, 
						studyIen, 
			    		patientIdentifier,
			    		modality, 
						!storage.equals("2005"));
	
				image.setImgType(imgType);
				image.setBigFilename(bigFilename);
				
				ImageURN imageUrn = image.getImageUrn();
				
				if (contextId.isEmpty())
				{
					StudyURN studyUrn = null;
					if (storage.equals("2005"))
					{
						studyUrn = StudyURNFactory.create(item.getPlaceId(), studyIen, patientIdentifier.getValue(), StudyURN.class);
					}
					else{
						studyUrn = StudyURNFactory.create(item.getPlaceId(), studyIen, patientIdentifier.getValue(), P34StudyURN.class);			
					}
	
					contextId = studyUrn.toString();
				}
				
				imageType = new PreCacheNotificationImageType();
				imageType.setDescription(description);
				String diagnosticImageUri = getDiagnosticImageUri(image, imageUrn.toString());
				imageType.setDiagnosticImageUri(diagnosticImageUri);
				imageType.setImageId(imageUrn.toString());
				imageType.setImageType(type);
			}
			
			PreCacheNotificationStudyType study = findPreCachedStudy(studies, contextId);
			if (study == null)
			{
				study = new PreCacheNotificationStudyType();
				study.setSiteNumber(item.getPlaceId());
				study.setContextId(contextId);
				study.setPatientICN(patientIcn);
				study.setStudyId(studyIen);
				
				if (imageType != null)
				{
					List<PreCacheNotificationImageType> images = new ArrayList<PreCacheNotificationImageType>();
					images.add(imageType);
		
					PreCacheNotificationImagesType imagesType = new PreCacheNotificationImagesType();
					imagesType.setImages(images);
		
					List<PreCacheNotificationImagesType> series = new ArrayList<PreCacheNotificationImagesType>();
					series.add(imagesType);
		
					PreCacheNotificationSeriesType seriesType = new PreCacheNotificationSeriesType();
					seriesType.setSeries(series);
					
					List<PreCacheNotificationSeriesType> serieses = new ArrayList<PreCacheNotificationSeriesType>();
					serieses.add(seriesType);
	
					PreCacheNotificationSeriesesType seriesesType = new PreCacheNotificationSeriesesType();
					seriesesType.setSerieses(serieses);
	
					List<PreCacheNotificationSeriesesType> sty = new ArrayList<PreCacheNotificationSeriesesType>();
					sty.add(seriesesType);

					study.setStudy(sty);
				}
				
				studies.add(study);
			}
			else
			{
				if (imageType != null)
				{
					List<PreCacheNotificationSeriesesType> sty = study.getStudy();
					PreCacheNotificationSeriesesType seriesesType = sty.get(0);
	
					List<PreCacheNotificationSeriesType> serieses = seriesesType.getSerieses();
					PreCacheNotificationSeriesType seriesType = serieses.get(0);
					
					List<PreCacheNotificationImagesType> series = seriesType.getSeries();
					PreCacheNotificationImagesType imagesType = series.get(0);
					
					List<PreCacheNotificationImageType> images = imagesType.getImages();
					images.add(imageType);
				}
			}
		}

		PreCacheNotificationType preCache = new PreCacheNotificationType();
		preCache.setStudies(studies);
		return preCache;
	}

	private static PreCacheNotificationStudyType findPreCachedStudy(
			List<PreCacheNotificationStudyType> studies,
			String contextId) 
	{
		for(PreCacheNotificationStudyType study: studies)
		{
			if (study.getContextId().equals(contextId))
				return study;
		}
		return null;
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
		
		return  getContentType(image, imageQuality, ViewerContentTypeConfiguration.getConfiguration());
	}
	

}
