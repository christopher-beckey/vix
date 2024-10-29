package gov.va.med.imaging.url.vista;


import junit.framework.TestCase;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class TestEncryptionDecryption extends TestCase{

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testDecryption1(){
		String code = "0r##HFF'V+";
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("Access1.", codeResult);		
	}

	@Test
	public void testDecryption2(){
		String code = "\"rkkN``X%*";
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("Access1.", codeResult);		
	}

	@Test
	public void testDecryption3(){
		String code = " r##HFF'V+";
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("zjjX;;'[", codeResult);		
	}
	
	@Test
	public void testDecryption4(){
		String code = ".r##HFF'V+";
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("BSSMbb`s", codeResult);		
	}

	@Test
	public void testDecryption5(){
		String code = "'r##HFF'V+";
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("8\"\"r__Es", codeResult);		
	}

	@Test
	public void testDecryption6(){
		String code = "(WSSq..%\\ ";
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("Access1.", codeResult);		
	}

	@Test
	public void testDecryption7(){
		String code = "\'bAAj&&0+&";
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("Access1.", codeResult);		
	}

	@Test
	public void testDecryption8(){
		String code = "/\"~~1[[5,$";
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("Access1.", codeResult);		
	}

	@Test
	public void testDecryption9(){
		String code = "!;RRI``qh$";
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("Access1.", codeResult);		
	}

	@Test
	public void testDecryption10(){
		String code = "(WSSq..%\\ ";
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("Access1.", codeResult);		
	}

	@Test
	public void testEncryptDecryptOne(){
		String accessCode = "Access1.";
		String code = EncryptionUtils.encrypt(accessCode);
		
		String codeResult = EncryptionUtils.decrypt(code);
		assertEquals("Access1.", codeResult);		
	}

}
