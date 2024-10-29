package gov.va.med.cache.gui.client;

import java.util.logging.Logger;

public class Utilities
{
	private static Logger logger = Logger.getLogger("ASSERT-FAILED");
	
	/**
	 * 
	 * @param value
	 * @param msg
	 */
	public static void assertIsTrue(boolean value, String msg)
	{
		if(! value)
		{
			logger.severe(msg);
			MessageDialog.showErrorDialog("Assertion Error", msg);
		}
	}
	
}
