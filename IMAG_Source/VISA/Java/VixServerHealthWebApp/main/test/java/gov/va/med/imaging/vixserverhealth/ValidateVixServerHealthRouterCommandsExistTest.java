package gov.va.med.imaging.vixserverhealth;

import static org.junit.Assert.fail;
import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;

import org.junit.Test;

public class ValidateVixServerHealthRouterCommandsExistTest
{
	@Test
	public void testCommands()
	{
		try
		{
			GeneratedCodeValidationUtility.validateCommandsExist(VixServerHealthRouterTest.class);
		}
		catch(ValidationException vX)
		{
			vX.printStackTrace();
			fail(vX.getMessage());
		}
	}
}
