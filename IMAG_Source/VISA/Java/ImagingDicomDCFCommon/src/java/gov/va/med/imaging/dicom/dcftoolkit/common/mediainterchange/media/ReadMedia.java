/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 7, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswpeterb
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
package gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.media;

import java.io.FileInputStream;

import org.apache.commons.io.FilenameUtils;

/**
 * @author vhaiswpeterb
 *
 */
public class ReadMedia {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		String localFilename = null;
		
		if(args != null && args.length > 0) {
			localFilename = FilenameUtils.normalize(args[0]);
		} else {
			System.out.println("Need a file name to be passed in.....");
			System.exit(-1);
		}
			
		DicomMediaImpl media = new DicomMediaImpl();
		String xmlObj = null;
		
		// Fortify change: "new" Java try-with-resources to see if Fortify still complains. Not even use in production. Fixed anyway.
		
		try (FileInputStream inStream = new FileInputStream(localFilename)) {
			
			xmlObj = media.readDicomDIRToXMLString(inStream);
			System.out.println("XML: " + xmlObj);
			
		} catch (Exception e) {
			System.out.println("Exception thrown.");
			e.printStackTrace();
			System.exit(-1);
		} 
	}
}
