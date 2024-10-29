/**
 * 
 */
package gov.va.med.imaging.roi.commands.facade;

import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class ValidateROIPeriodicRouterFacadeTest
extends TestCase
{
	public void testGeneratedFacade()
	{
		try
		{
			GeneratedCodeValidationUtility.validateImplementation(
				gov.va.med.imaging.roi.commands.facade.ROIPeriodicCommandsRouter.class, 
				gov.va.med.imaging.roi.commands.facade.ROIPeriodicCommandsRouterImpl.class
			);
		}
		catch (ValidationException x)
		{
			fail(x.getMessage());
		}
	}
}
