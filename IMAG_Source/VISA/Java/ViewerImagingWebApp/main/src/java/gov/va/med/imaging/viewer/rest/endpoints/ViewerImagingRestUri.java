package gov.va.med.imaging.viewer.rest.endpoints;

/**
 * @author Budy Tjahjo
 *
 */
public class ViewerImagingRestUri {

	/**
	 * Service application
	 */
	public final static String viewerImagingServicePath = "viewerImaging"; 
	public final static String viewerImagingDeleteImagesMethodPath = "/deleteImages";
	public final static String viewerImagingGetDeleteReasonsMethodPath = "/getDeleteReasons";
	public final static String viewerImagingGetPrintReasonsMethodPath = "/getPrintReasons";
	public final static String viewerImagingGetStatusReasonsMethodPath = "/getStatusReasons";
	public final static String viewerImagingFlagImagesAsSensitiveMethodPath = "/flagImagesAsSensitive";
	public final static String viewerImagingGetUserInformationMethodPath = "/getUserInformation";
	public final static String viewerImagingLogPrintImageAccessMethodPath = "/logPrintImageAccess";
	public final static String viewerImagingLogImageAccessMethodPath = "/logImageAccess";
	
	//EFR
	public final static String viewerImagingGetTreatingFacilitiesMethodPath = "/getTreatingFacilities";

	//QA Review
	public final static String viewerImagingQAServicePath = "viewerImagingQA"; 
	public final static String viewerImagingGetCaptureUsersMethodPath = "/getCaptureUsers";
	public final static String viewerImagingGetQAReviewReports = "/getQAReviewReports";
	public final static String viewerImagingGetQAReviewReportData = "/getQAReviewReportStat";
	public final static String viewerImagingSetImagePropertiesMethodPath = "/setImageProperties";
	public final static String viewerImagingGetImagePropertiesMethodPath = "/getImageProperties";

	//Image Filters
	public final static String viewerImagingFilterServicePath = "viewerImagingFilter"; 
	public final static String viewerImagingGetImageFiltersMethodPath = "/getImageFilters";
	public final static String viewerImagingGetImageFilterDetailMethodPath = "/getImageFilterDetail";
	public final static String viewerImagingDeleteImageFilterMethodPath = "/deleteImageFilter";
	public final static String viewerImagingSaveImageFilterMethodPath = "/saveImageFilter";

}


