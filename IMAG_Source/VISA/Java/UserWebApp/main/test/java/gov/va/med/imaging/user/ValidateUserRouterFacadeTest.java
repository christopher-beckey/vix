/**
 * 
 */
package gov.va.med.imaging.user;

import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class ValidateUserRouterFacadeTest
extends TestCase
{
	public void testGeneratedFacade()
	{
		try
		{
			GeneratedCodeValidationUtility.validateImplementation(
					gov.va.med.imaging.user.UserRouter.class, 
					gov.va.med.imaging.user.UserRouterImpl.class
			);
		}
		catch (ValidationException x)
		{
			fail(x.getMessage());
		}
	}
}
