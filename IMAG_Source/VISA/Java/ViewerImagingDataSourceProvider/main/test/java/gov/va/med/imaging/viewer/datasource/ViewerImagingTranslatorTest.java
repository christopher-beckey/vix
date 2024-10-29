/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jan 10, 2014
 * Developer: Administrator
 */
package gov.va.med.imaging.viewer.datasource;

import gov.va.med.imaging.viewer.datasource.ViewerImagingTranslator;

import java.util.List;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * @author Administrator
 *
 */
public class ViewerImagingTranslatorTest
{
	@Test
	public void testUrnTranslation()
	{
		try
		{
			String imageUrn = "urn:vaimage:A-B-C-D-";
			String imageIen = ViewerImagingTranslator.getImageIen(imageUrn);
			assertEquals("B", imageIen);
			
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			fail(ex.getMessage());
		}
	}
	
}
