package gov.va.med.imaging.business.test.data;

import gov.va.med.imaging.storage.IconImageCreation;
import junit.framework.TestCase;

public class IconCreationTests extends TestCase {

	protected void setUp() throws Exception {
		super.setUp();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}

	public void testMakeAbstract1(){
		int result = IconImageCreation.createIconImage(".\\main\\src\\resources\\A0000218.dcm", ".\\main\\src\\resources\\abstract1.jpg");
		
		if(result != 0){
			System.out.println("Failed to create icon with Error Code: "+ result);
			fail();
		}
	}
}
