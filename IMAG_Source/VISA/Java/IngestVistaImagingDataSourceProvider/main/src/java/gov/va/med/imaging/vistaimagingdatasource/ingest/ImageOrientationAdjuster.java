/**
 * 
 * 
 * Date Created: Dec 9, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.vistaimagingdatasource.ingest;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import org.apache.commons.io.IOUtils;
import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import mediautil.image.jpeg.AbstractImageInfo;
import mediautil.image.jpeg.Entry;
import mediautil.image.jpeg.Exif;
import mediautil.image.jpeg.LLJTran;
import mediautil.image.jpeg.LLJTranException;

/**
 * @author Administrator
 *
 */
public class ImageOrientationAdjuster
{
	private final static Logger logger = Logger.getLogger(ImageOrientationAdjuster.class);
	
	public static boolean adjustImageOrientation(String filename, String outputFilename)
	throws MethodException
	{
		try
		{
		    // Read image EXIF data
			File imageFile = new File(filename);
		    LLJTran llj = new LLJTran(imageFile);
		    llj.read(LLJTran.READ_INFO, true);
		    AbstractImageInfo<?> imageInfo = llj.getImageInfo();
		    if (!(imageInfo instanceof Exif))
		    {
                logger.warn("Image [{}] has no EXIF data, cannot adjust orientation.", filename);
		    	return false;
		    }		    

		    // Determine the orientation
		    Exif exif = (Exif) imageInfo;
		    int orientation = 1;
		    Entry orientationTag = exif.getTagValue(Exif.ORIENTATION, true);
		    if (orientationTag != null)
		        orientation = (Integer) orientationTag.getValue(0);

		    // Determine required transform operation
		    int operation = 0;
		    if (orientation > 0
		            && orientation < Exif.opToCorrectOrientation.length)
		        operation = Exif.opToCorrectOrientation[orientation];
		    if (operation == 0)
		    {
                logger.info("Orientation of image [{}] is correct, no adjustment necessary", filename);
		    	return false;
		    }		        
		    OutputStream output = null;
		    FileOutputStream innerStream = null;
		    try 
		    {   
		        // Transform image
		        llj.read(LLJTran.READ_ALL, true);
		        llj.transform(operation, LLJTran.OPT_DEFAULTS
		                | LLJTran.OPT_XFORM_ORIENTATION);

		        innerStream = new FileOutputStream(outputFilename);
		        output = new BufferedOutputStream(innerStream);
		        llj.save(output, LLJTran.OPT_WRITE_ALL);
		        return true;
		    } 
		    finally 
		    {
		    	if (innerStream != null) {
		    		try {
		    			innerStream.close();
					} catch (Exception e) {
		    			// ---
					}
				}

		    	if (output != null) {
		    		try {
		    			output.close();
					} catch (Exception e) {
		    			// ---
					}
				}
		        llj.freeMemory();
		    }
		}
		catch(LLJTranException lljtX)
		{
			throw new MethodException("Error updating image orientation, " + lljtX.getMessage());
		}
		catch(IOException ioX)
		{
			throw new MethodException("Error updating image orientation, " + ioX.getMessage());
		}
		
	}

}
