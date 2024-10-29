package gov.va.med.imaging.data.rest.endpoints;

/**
 * @author Budy Tjahjo
 *
 */
public class ImagingDataRestUri {

	/**
	 * Service application
	 */
	public final static String imageServicePath = "image"; 
	
	public final static String imageInformationMethodPath = "/information/{imageUrn}/{includeDeletedImages}";
	public final static String imageGlobalNodesMethodPath = "/globalnodes/{imageUrn}";
	public final static String imageDevFieldsMethodPath = "/devfields/{imageUrn}";
}


