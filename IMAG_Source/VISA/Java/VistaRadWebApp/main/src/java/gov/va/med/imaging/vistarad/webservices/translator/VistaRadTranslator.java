/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 13, 2009
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
package gov.va.med.imaging.vistarad.webservices.translator;

import java.text.DateFormat;
import java.util.List;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.DicomDateFormat;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.SiteNumber;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ArtifactResultError;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.exchange.business.PassthroughParameter;
import gov.va.med.imaging.exchange.business.PassthroughParameterType;
import gov.va.med.imaging.exchange.business.vistarad.ActiveExam;
import gov.va.med.imaging.exchange.business.vistarad.ActiveExams;
import gov.va.med.imaging.exchange.business.vistarad.Exam;
import gov.va.med.imaging.exchange.business.vistarad.ExamImage;
import gov.va.med.imaging.exchange.business.vistarad.ExamImages;
import gov.va.med.imaging.exchange.business.vistarad.ExamSite;
import gov.va.med.imaging.exchange.business.vistarad.ExamSiteCachedStatus;
import gov.va.med.imaging.exchange.business.vistarad.PatientEnterpriseExams;
import gov.va.med.imaging.exchange.enums.ArtifactResultErrorCode;
import gov.va.med.imaging.exchange.enums.ArtifactResultStatus;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.SiteConnectivityStatus;
import gov.va.med.imaging.vistarad.VistaRadFilter;
import gov.va.med.imaging.vistarad.configuration.VistaRadWebAppConfiguration;
import gov.va.med.imaging.vistarad.webservices.exceptions.VistaRadSocketTimeoutException;

/**
 * VistARad Facade translator for converting VIX business objects into VistARad Web App specific objects
 * 
 * @author vhaiswwerfej
 *
 */
public class VistaRadTranslator 
{
	private static DateFormat getWebserviceDateFormat()
	{
		return new DicomDateFormat();
		//return new SimpleDateFormat(webserviceDateFormat);
	}
	
	public static gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse transformSiteConnectivityStatus(SiteConnectivityStatus status)
	{
		gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse response = 
			gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse.SERVER_UNAVAILABLE;			
		if(status == SiteConnectivityStatus.VIX_READY)
		{
			return gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse.SERVER_READY;
		}
		else if(status == SiteConnectivityStatus.DATASOURCE_UNAVAILABLE)
		{
			return gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse.VISTA_UNAVAILABLE;			
		}
		return response;
	}
	
	public static gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType transformActiveExams(ActiveExams activeExams)
	throws URNFormatException
	{
		gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType result = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType();		
		if(activeExams != null)
		{
			result.setHeaderLine1(activeExams.getRawHeader1());
			result.setHeaderLine2(activeExams.getRawHeader2());		
			gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType [] activeWorklistType = 
				new gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType[activeExams.size()]; 
			for(int i = 0; i < activeExams.size(); i++)
			{
				ActiveExam activeExam = activeExams.get(i);
				activeWorklistType[i] = transformActiveExam(activeExam);
			}	
			result.setWorklistItems(activeWorklistType);
		}		
		else
		{
			result.setHeaderLine1("");
			result.setHeaderLine2("");
		}
		return result;
	}
	
	private static gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType transformActiveExam(ActiveExam activeExam)
	throws URNFormatException
	{
		gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType result =
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType();
		if((activeExam.getPatientIcn() == null) || (activeExam.getPatientIcn().length() <= 0))
		{
			// if the exam Id is empty or null (should be empty) - it means the VIX could not get the DFN for the ICN, still want to return the exam
			result.setExamId("");
		}
		else
		{
			result.setExamId(activeExam.getStudyUrn().toStringCDTP());
		}
		result.setRawString(activeExam.getRawValue());
		return result;
	}
	
	/*
	public static String transformActiveExamsStringArrayToString(String [] activeExams)
	{
		if(activeExams == null)
			return null;
		StringBuilder sb = new StringBuilder();
		for(int i = 0; i < activeExams.length; i++)
		{
			sb.append(activeExams[i] + "\n");
		}
		return sb.toString();
	}*/
	
	public static VistaRadFilter transformFilter()	
	{
		VistaRadFilter result = new VistaRadFilter();
		
		
		return result;
	}
	
	public static gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite [] transformPatientEnterpriseExams(PatientEnterpriseExams enterpriseExams)
	throws URNFormatException
	{
		if(enterpriseExams == null)
			return null;
		gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite [] result = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite [enterpriseExams.getExamSites().size()];
		
		int i = 0;
		for(Map.Entry<RoutingToken,ExamSite> entry : enterpriseExams.getExamSites().entrySet())
		{
			ExamSite es = entry.getValue();
			try
			{
				result[i] = transformExamSite(es);
			}
			catch(VistaRadSocketTimeoutException vrstX)
			{
				// this will occur if one of the sites had a socket timeout - it should really be handled better
				result[i] = new gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite();
				result[i].setSiteName(es.getRoutingToken().toString());
				result[i].setSiteNumber(es.getRoutingToken().getRepositoryUniqueId());				
				result[i].setStatus(gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteStatus.ERROR);
				
			}
			i++;
		}		
		return result;
	}
	
	/*
	public static gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite [] transformExamSites(List<ExamSite> sites)
	throws URNFormatException
	{
		if(sites == null)
			return null;
		gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite [] result = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite [sites.size()];
		for(int i = 0; i < sites.size(); i++)
		{
			result[i] = transformExamSite(sites.get(i));
		}
		
		return result;
	}
	*/
	
	public static gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite transformExamSite(ExamSite site)
	throws URNFormatException, VistaRadSocketTimeoutException
	{
		if(site == null)
			return null;
		if((site.getArtifactResultStatus() == ArtifactResultStatus.errorResult))
		{
			if(site.getArtifactResultErrors() != null)
			{
				for(ArtifactResultError error : site.getArtifactResultErrors())
				{
					if(error.getErrorCode() == ArtifactResultErrorCode.timeoutException)
						throw new VistaRadSocketTimeoutException(error.getCodeContext());
				}
			}
		}		
		gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite result = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite();		
		result.setSiteName(site.getSiteName() == null ? site.getRoutingToken().toString() : site.getSiteName());
		result.setSiteNumber(site.getRoutingToken().getRepositoryUniqueId());
		
		gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType [] shallowExams = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType[site.size()];
		int i = 0;
		for(Exam exam : site)
		{
			shallowExams[i] = transformExamToShallow(exam);
			i++;
		}
		result.setExam(shallowExams);
		result.setStatus(transformSiteStatus(site.getArtifactResultStatus()));
		return result;		
	}
	
	private static gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType transformExamToShallow(Exam exam)
	throws URNFormatException
	{
		gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType result = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType();
		result.setExamDetails(transformExamToDetails(exam));
		return result;
	}
	
	public static gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType transformExamToFatExam(Exam exam)
	throws URNFormatException
	{
		gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType result = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType();
		result.setExamDetails(transformExamToDetails(exam));
		
		result.setRadiologyReport(exam.getExamReport());
		result.setRequisitionReport(exam.getExamRequisitionReport());
		result.setComponentImages(transformExamImages(exam.getImages()));
		result.setPresentationState(exam.getPresentationStateData());
		return result;
	}
	
	private static gov.va.med.imaging.vistarad.webservices.soap.v1.ComponentImagesType transformExamImages(ExamImages images)
	throws URNFormatException
	{
		if(images == null)
			return null;
		gov.va.med.imaging.vistarad.webservices.soap.v1.ComponentImagesType result = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ComponentImagesType();		
		
		result.setHeaderString(images.getRawHeader());
		
		gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType [] resultArray = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType[images.size()];
		int i = 0;
		for(ExamImage examImage: images)
			resultArray[i++] = transformExamImage(examImage);
		
		result.setImages(resultArray);
		return result;
	}
	
	private static gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType transformExamImage(ExamImage image)
	throws URNFormatException
	{
		if(image == null)
			return null;
		
		gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType result = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType();
		result.setImageCached(image.isImageInCache());
		
		ImageURN imageUrn = image.getImageUrn();
		result.setImageId(imageUrn.toStringCDTP());
 
		result.setRequestQueryString(getContentTypeString(imageUrn));		
		return result;
	}
	
	private static String getContentTypeString(ImageURN imageUrn)
	{
		StringBuilder sb = new StringBuilder();
		sb.append("imageURN=");
		sb.append(imageUrn.toStringCDTP());
		sb.append("&imageQuality=");
		sb.append(ImageQuality.DIAGNOSTIC.getCanonical());
		sb.append("&contentType=");
		sb.append(getImageFormats());
		return sb.toString();
	}
	
	private static VistaRadWebAppConfiguration getVistaRadWebAppConfiguration()
	{
		return VistaRadWebAppConfiguration.getVistaRadConfiguration();
	}
	
	private static String getImageFormats()
	{
		List<ImageFormat> imageFormats = getVistaRadWebAppConfiguration().getDiagnosticQualityImageFormats();
		StringBuilder sb = new StringBuilder(); 
		
		String prefix = "";
		for(ImageFormat imageFormat : imageFormats)
		{
			sb.append(prefix);
			sb.append(imageFormat.getMime());
			prefix = ",";
		}		
		
		return sb.toString();
	}
	
	private static gov.va.med.imaging.vistarad.webservices.soap.v1.ExamTypeDetails transformExamToDetails(Exam exam)
	throws URNFormatException
	{
		if(exam == null)
			return null;
		gov.va.med.imaging.vistarad.webservices.soap.v1.ExamTypeDetails result = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ExamTypeDetails();
		
		//TODO: determine if all images are cached
		//result.setAllImagesCached(exam.get)
		result.setCptCode(exam.getCptCode());
		result.setExamId(exam.getStudyUrn().toStringCDTP());
		result.setHeaderString1(exam.getRawHeaderLine1());
		result.setHeaderString2(exam.getRawHeaderLine2());
		result.setImageCount(exam.getImageCount());
		result.setModality(exam.getModality());
		result.setPatientIcn(exam.getPatientIcn());
		result.setRawString(exam.getRawOutput());
		result.setSiteAbbreviation(exam.getSiteAbbr());
		result.setSiteName(exam.getSiteName());
		result.setSiteNumber(exam.getSiteNumber());
		return result;
	}
	
	private static gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteStatus transformSiteStatus(ArtifactResultStatus artifactResultStatus)
	{
		switch(artifactResultStatus)
		{
			case errorResult:
				return gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteStatus.ERROR;
			case fullResult:
			case partialResult:
				return gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteStatus.ONLINE;			
		}
		return gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteStatus.ERROR;
	}
	
	public static PassthroughInputMethod transformPassthroughMethod(String methodName,
			gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType [] parameters)
	{
		if(methodName == null)
			return null;
		PassthroughInputMethod result = new PassthroughInputMethod(methodName);
		if(parameters != null)
		{
			for(gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType parameter : parameters)
			{
				result.getParameters().add(transformParameter(parameter));
			}
		}
		
		return result;
	}
		
	private static PassthroughParameter transformParameter(
			gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType parameter)
	{
		PassthroughParameter result = new PassthroughParameter();
		result.setIndex(parameter.getParameterIndex().intValue());
		result.setParameterType(transformParameterType(parameter.getParameterType()));
		if(parameter.getParameterValue() == null)
		{
			result.setValue(null);
			result.setMultipleValues(null);
		}
		else
		{
			result.setValue(parameter.getParameterValue().getValue());
			result.setMultipleValues(transformMultiples(parameter.getParameterValue().getMultipleValue()));
		}
		
		return result;
	}
	
	private static String [] transformMultiples(gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterMultipleType multiples)
	{
		if(multiples == null)
			return null;
		return multiples.getMultipleValue();
	}
	
	private static PassthroughParameterType transformParameterType(
			gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterTypeType parameterType)
	{
		PassthroughParameterType result = PassthroughParameterType.literal;
		
		if(parameterType != null)
		{
			if(parameterType != null)
			{
				if(parameterType == gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterTypeType.LIST)
				{
					result = PassthroughParameterType.list;
				}
				else if(parameterType == gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterTypeType.REFERENCE)
				{
					result = PassthroughParameterType.reference;
				}
			}
		}
		
		return result;
	}
	
	public static SiteNumber [] transformSiteNumbers(String [] siteNumbers)
	{
		if(siteNumbers == null)
			return null;
		SiteNumber [] result = new SiteNumber[siteNumbers.length];
		
		int count = 0;
		for(String siteNumber : siteNumbers)
		{
			result[count] = new SiteNumber(siteNumber);
			count++;
		}
		
		return result;
	}
	
	/**
	 * Transform the array of site numbers into a comma separated list of site numbers (to output cleanly).
	 * @param siteNumbers
	 * @return
	 */
	public static String transformSiteNumbersToString(String [] siteNumbers)
	{
		StringBuilder sb = new StringBuilder();
		
		if(siteNumbers != null)
		{
			String prefix = "";
			for(String siteNumber : siteNumbers)
			{
				sb.append(prefix);
				sb.append(siteNumber);
				prefix = ", ";
			}			
		}
		
		return sb.toString();
	}
	
	public static gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType [] transformExamSiteCachedStatuses(
			List<ExamSiteCachedStatus> examSiteCachedStatuses)
	{
		if(examSiteCachedStatuses == null)
			return null;
		gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType [] result =
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType [examSiteCachedStatuses.size()];
		
		int count = 0;
		for(ExamSiteCachedStatus examSiteCachedStatus : examSiteCachedStatuses)
		{
			result[count] = transformExamSiteCachedStatus(examSiteCachedStatus);
			count++;
		}
		
		return result;
	}
	
	private static gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType transformExamSiteCachedStatus(
			ExamSiteCachedStatus examSiteCachedStatus)
	{
		gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType result = 
			new gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType();
		
		result.setIsCached(examSiteCachedStatus.isCached());
		result.setSiteNumber(examSiteCachedStatus.getRoutingToken().getRepositoryUniqueId());
		result.setPatientIcn(examSiteCachedStatus.getPatientIcn());
		
		return result;
	}
}
