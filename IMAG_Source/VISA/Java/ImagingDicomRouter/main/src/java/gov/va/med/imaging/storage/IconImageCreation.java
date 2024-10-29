package gov.va.med.imaging.storage;

public class IconImageCreation {

	public static native int createIconImage(String dicomFile, String iconFile);
	
	static{
		System.loadLibrary("IconImageCreation");
	}
}
