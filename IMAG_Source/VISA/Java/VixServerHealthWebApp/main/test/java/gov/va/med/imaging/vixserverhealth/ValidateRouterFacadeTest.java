/**
 * 
 */
package gov.va.med.imaging.vixserverhealth;

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
				gov.va.med.imaging.vixserverhealth.VixServerHealthRouter.class, 
				gov.va.med.imaging.vixserverhealth.VixServerHealthRouterImpl.class
			);
		}
		catch (ValidationException x)
		{
			fail(x.getMessage());
		}
	}
}
