package gov.va.med.imaging;

import junit.framework.TestCase;

import org.junit.Test;

public class StringUtilTest extends TestCase {

	@Test
	public void testRemoveNonAlphaNumericCharOne() {
		String data = new String("TEST");
		String result = StringUtil.removeNonAlphaNumericChars(data);
		assertEquals(result, data);
	}
	@Test
	public void testRemoveNonAlphaNumericCharTwo() {
		String data = new String("GY.M2");
		String result = StringUtil.removeNonAlphaNumericChars(data);
		assertEquals(result, "GYM2");
	}
	@Test
	public void testRemoveNonAlphaNumericCharThree() {
		String data = new String("mGy");
		String result = StringUtil.removeNonAlphaNumericChars(data);
		assertEquals(result, "mGy");	
	}
	@Test
	public void testRemoveNonAlphaNumericCharFour() {
		String data = new String("GYM2");
		String result = StringUtil.removeNonAlphaNumericChars(data);
		assertEquals(result, data);
	}
	@Test
	public void testRemoveNonAlphaNumericCharFive() {
		String data = new String("GY.M2/WW-3421");
		String result = StringUtil.removeNonAlphaNumericChars(data);
		assertEquals(result, "GYM2WW3421");
	}

}
