package gov.va.med.imaging.mix.webservices.rest.endpoints;

/**
 * @author vacotittoc
 *
 */
public class MixImageWADORestUri 
{
	/**
	 * base path for all MIX services 
	 */
//	public final static String mixServicePath = "mix/v1"; // "mix/images"; 
	
	/**
	 * Path to retrieve JPEG Thumbnails for DICOM Instances -- implicitly implies image/jpeg or text/plain response
	 */
	public final static String thumbnailPath = "RetrieveThumbnail?requestType=WADO&studyUID={studyUid}&seriesUID={seriesUid}&objectUID={instanceUid}"; 

	/**
	 * Paths to retrieve DICOM Reference (70) or Diagnostic (90) quality image objects in JPEG200 compressed Transfer Syntax
	 * -- explicitly implies application/dicom+jp2 or text/plain response; transfer syntax UID ends on 1 for Reference and on 2 for Diagnostic quality
	 */
	public final static String dicomJ2KReferencePath = 
			"RetrieveInstance/studies/{studyUid}/series/{seriesUid}/instances/{instanceUid}?imageQuality=70&transferSyntax=1.2.840.10008.1.2.4.91&accept=application%2Fdicom%252Bjp2";
	public final static String dicomJ2KDiagnosticPath = 
			"RetrieveInstance/studies/{studyUid}/series/{seriesUid}/instances/{instanceUid}?imageQuality=90&transferSyntax=1.2.840.10008.1.2.4.90&accept=application%2Fdicom%252Bjp2";
	
	public final static String ecaiWadoUri = "wadoget?requestType=WADO&contenttype=application/dicom&studyUID={studyUid}&seriesUID={seriesUid}&objectUID={instanceUid}";

}
