/**
 * 
cd .. * Date Created: Apr 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer;

import static org.junit.Assert.fail;
import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;
import gov.va.med.imaging.viewer.ViewerImagingRouterTest;


import org.junit.Test;



/**
 * @author vhaisltjahjb
 *
 */
public class ValidateRouterCommands
{
	@Test
	public void testCommands()
	{
		try
		{
			GeneratedCodeValidationUtility.validateCommandsExist(ViewerImagingRouterTest.class);
		}
		catch(ValidationException vX)
		{
			fail(vX.getMessage());
		}
	}
}
