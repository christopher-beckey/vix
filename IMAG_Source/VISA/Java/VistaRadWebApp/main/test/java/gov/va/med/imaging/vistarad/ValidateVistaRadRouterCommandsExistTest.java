package gov.va.med.imaging.vistarad;

import static org.junit.Assert.fail;
import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;

import org.junit.Test;

public class ValidateVistaRadRouterCommandsExistTest
{
	@Test
	public void testCommands()
	{
		try
		{
			GeneratedCodeValidationUtility.validateCommandsExist(VistaRadRouterTest.class);
		}
		catch(ValidationException vX)
		{
			fail(vX.getMessage());
		}
	}
}
