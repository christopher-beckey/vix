package gov.va.med.imaging.user;

import static org.junit.Assert.fail;
import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;

import org.junit.Test;

public class ValidateUserRouterCommandsExistTest
{
	@Test
	public void testCommands()
	{
		try
		{
			GeneratedCodeValidationUtility.validateCommandsExist(UserRouterTest.class);
		}
		catch(ValidationException vX)
		{
			vX.printStackTrace();
			fail(vX.getMessage());
		}
	}
}
