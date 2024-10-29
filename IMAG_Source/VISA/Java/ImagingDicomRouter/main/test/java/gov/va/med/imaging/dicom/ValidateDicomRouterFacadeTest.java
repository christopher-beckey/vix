package gov.va.med.imaging.dicom;

import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;
import junit.framework.TestCase;

public class ValidateDicomRouterFacadeTest
extends TestCase
{
	public void testGeneratedFacade()
	{
		try
		{
			GeneratedCodeValidationUtility.validateImplementation(
					gov.va.med.imaging.dicom.DicomRouter.class, 
					gov.va.med.imaging.dicom.DicomRouterImpl.class
			);
		}
		catch (ValidationException x)
		{
			fail(x.getMessage());
		}
	}
}
