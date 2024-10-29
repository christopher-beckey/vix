/**
 * 
 */
package gov.va.med.imaging.exchange;

import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class ValidateRouterFacadeTest
extends TestCase
{
	public void testGeneratedFacade()
	{
		try
		{
			GeneratedCodeValidationUtility.validateImplementation(
				gov.va.med.imaging.exchange.VixGuiWebAppRouter.class, 
				gov.va.med.imaging.exchange.VixGuiWebAppRouterImpl.class
			);
		}
		catch (ValidationException x)
		{
			fail(x.getMessage());
		}
	}
}
