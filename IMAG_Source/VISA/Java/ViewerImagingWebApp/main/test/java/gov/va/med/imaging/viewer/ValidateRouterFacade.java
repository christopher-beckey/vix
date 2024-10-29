/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jan 17, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.viewer;

import static org.junit.Assert.fail;
import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;

import org.junit.Test;

/**
 * @author Administrator
 *
 */
public class ValidateRouterFacade
{
	@Test
	public void testGeneratedFacade()
	{
		try
		{
			GeneratedCodeValidationUtility.validateImplementation(
				gov.va.med.imaging.viewer.ViewerImagingRouter.class,
				gov.va.med.imaging.viewer.ViewerImagingRouterImpl.class
			);
		}
		catch (ValidationException x)
		{
			fail(x.getMessage());
		}
		
	}

}
