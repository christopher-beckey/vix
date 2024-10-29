package gov.va.med.imaging.mix.webservices.rest.endpoints;

/**
 * @author vacotittoc
 *
 */
public class MixImagingStudyRestUri 
{
	/**
	 * 
	 */
//	public final static String mixServicePath = "mix"; // "mix/metadata";
	
	/**
	 * Path to retrieve a study tree by studyId (DICOM Study UID) 
	 */
	public final static String studyListPath = "ImagingStudy?uid={studyUid}";
}
