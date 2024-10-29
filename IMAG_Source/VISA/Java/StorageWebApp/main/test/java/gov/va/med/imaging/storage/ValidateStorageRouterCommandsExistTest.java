package gov.va.med.imaging.storage;

import static org.junit.Assert.fail;
import gov.va.med.GeneratedCodeValidationUtility;
import gov.va.med.exceptions.ValidationException;

import org.junit.Test;

public class ValidateStorageRouterCommandsExistTest
{
	@Test
	public void testCommands()
	{
		try
		{
			GeneratedCodeValidationUtility.validateCommandsExist(StorageRouterTest.class);
		}
		catch(ValidationException vX)
		{
			vX.printStackTrace();
			fail(vX.getMessage());
		}
	}
}
