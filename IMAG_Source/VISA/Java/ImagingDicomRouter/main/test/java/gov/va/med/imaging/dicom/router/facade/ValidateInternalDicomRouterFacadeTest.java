/**
 * 
 */
package gov.va.med.imaging.dicom.router.facade;

import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class ValidateInternalDicomRouterFacadeTest
extends TestCase
{
	public void testGeneratedFacade()
	{
		try
		{
			GeneratedCodeValidationUtility.validateImplementation(
					gov.va.med.imaging.dicom.router.facade.InternalDicomRouter.class, 
					gov.va.med.imaging.dicom.router.facade.InternalDicomRouterImpl.class
			);
		}
		catch (ValidationException x)
		{
			fail(x.getMessage());
		}
	}
}
