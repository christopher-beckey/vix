/**
 * 
 * 
 * Date Created: Dec 6, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.vistaimagingdatasource.ingest;

import gov.va.med.imaging.url.vista.StringUtils;

/**
 * This probably should be put into a more generic place since it could be very useful
 * 
 * @author Administrator
 *
 */
public class VistaImageInformation
{

	private final String ien;
	private final String groupIen;
	private final String imageFilename; // not full path
	private final int imageType;
	private final String procedure;
	//private final Date lastAccessDate; // who cares...
	private final String patientDfn;
	private final String abstractNetworkLocationIen;
	private final String magneticNetworkLocationIen;
	private final String jbNetworkLocationIen;
	
	public boolean isGroup()
	{
		return (imageType == 11);
	}
	
	public VistaImageInformation(String imageIen, String mag2005ZeroNode)
	{
		// FRANK,MACY LUCY   123657890^ECG00000012509.BMP^5^5^^1^23^CLIN^3131113.095722^12508
		// ARABIC,NAME ONLY  123-65-7890  CT ABDOMEN W/CONT^EHR00000012239.DCM^2^2^^100^23^*^3111218.230333^12237
		// ARABIC,NAME ONLY  123-65-7890  CT ABDOMEN W/CONT^^^^^11^23^RAD *^3120307.072239 <- Group
		this.ien = imageIen;
		
		String [] pieces = StringUtils.Split(mag2005ZeroNode, StringUtils.CARET);// mag2005ZeroNode.split(StringUtils.CARET);
		this.imageFilename = pieces[1]; // empty for group
		this.magneticNetworkLocationIen = pieces[2];
		this.abstractNetworkLocationIen = pieces[3];		
		this.jbNetworkLocationIen = pieces[4];
		this.imageType = Integer.parseInt(pieces[5]);
		this.patientDfn = pieces[6];
		this.procedure = pieces[7];
		if(pieces.length > 9)
			this.groupIen = pieces[9];
		else
			this.groupIen = imageIen;		
	}

	/**
	 * @return the ien
	 */
	public String getIen()
	{
		return ien;
	}

	/**
	 * @return the groupIen
	 */
	public String getGroupIen()
	{
		return groupIen;
	}

	/**
	 * @return the imageFilename
	 */
	public String getImageFilename()
	{
		return imageFilename;
	}

	/**
	 * @return the imageType
	 */
	public int getImageType()
	{
		return imageType;
	}

	/**
	 * @return the procedure
	 */
	public String getProcedure()
	{
		return procedure;
	}

	/**
	 * @return the patientDfn
	 */
	public String getPatientDfn()
	{
		return patientDfn;
	}

	/**
	 * @return the abstractNetworkLocationIen
	 */
	public String getAbstractNetworkLocationIen()
	{
		return abstractNetworkLocationIen;
	}

	/**
	 * @return the magneticNetworkLocationIen
	 */
	public String getMagneticNetworkLocationIen()
	{
		return magneticNetworkLocationIen;
	}

	/**
	 * @return the jbNetworkLocationIen
	 */
	public String getJbNetworkLocationIen()
	{
		return jbNetworkLocationIen;
	}
	
}
