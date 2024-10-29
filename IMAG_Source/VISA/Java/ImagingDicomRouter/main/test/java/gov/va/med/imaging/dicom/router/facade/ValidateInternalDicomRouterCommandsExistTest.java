package gov.va.med.imaging.dicom.router.facade;

import static org.junit.Assert.fail;

import org.junit.Test;

import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;

public class ValidateInternalDicomRouterCommandsExistTest
{
	@Test
	public void testCommands()
	{
		try
		{
			GeneratedCodeValidationUtility.validateCommandsExist(InternalDicomRouterTest.class);
		}
		catch(ValidationException vX)
		{
			vX.printStackTrace();
			fail(vX.getMessage());
		}
	}
}
