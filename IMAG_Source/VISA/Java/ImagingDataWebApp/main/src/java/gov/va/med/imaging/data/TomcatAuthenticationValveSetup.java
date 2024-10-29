package gov.va.med.imaging.data;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class TomcatAuthenticationValveSetup {

	
	public TomcatAuthenticationValveSetup() {}

	private static final char[] ascii = {'%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%',32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,'%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%','%'};

	public static String cleanString(String aString)
	{
		if (aString == null) return null;
		String valdateString = "";
		for (int i = 0; i < aString.length(); ++i)
		{
			valdateString += ascii[aString.charAt(i)];
		}
		return valdateString;
	}

	public static void main(String[] args) {
		// QN: reworked the method a bit
		if(args == null || args.length == 0) {
			throw new IllegalArgumentException("Required file name is either null or empty.");
		}
		
		// Can't see common-io for some reason --> String filename = args[0] != null ? FilenameUtils.normalize(args[0]) : "";
		String filename = args[0];
		
		String VIXType = System.getenv("VIXType");
		
		// Fortify change: can't use try-with-resources.  May require change in pom b/c it's not supported in Java 1.5
		FileWriter fw = null;
		BufferedWriter bw = null;
		
		try {
		
			//delete original context.xml in WebRoot\META-INF
			File delFile = new File(cleanString(filename));
			if (delFile.exists()) {
				delFile.delete();
			}
		
			// QN: Left here so that if the file couln't be deleted, these won't run
			//create string buffer to use the correct Tomcat Authentication Value.
			StringBuffer buffer = new StringBuffer();
			buffer.append("<Context>");
			buffer.append("\n");
			buffer.append("\t");
			
			 
			if(VIXType != null)	{
				if (VIXType.equalsIgnoreCase("RVIX")) {
					buffer.append("<Valve className=\"gov.va.med.server.tomcat.TomcatBasicSkipVistaAuthenticationValve\" />");
				} else {
				buffer.append("<Valve className=\"gov.va.med.server.tomcat.TomcatBasicAuthenticatorValve\" />");
				}
			} else {
				buffer.append("<Valve className=\"gov.va.med.server.tomcat.TomcatBasicAuthenticatorValve\" />");
			}
			
			buffer.append("\n");
			buffer.append("</Context>");
			buffer.append("\n");
			
			fw = new FileWriter(new File(cleanString(filename)));
			bw = new BufferedWriter(fw);

			//save as context.xml in WebRoot\META-INF
			bw.write(buffer.toString());
			bw.flush();
			
		} catch (IOException iox) {
			System.out.println("IOException was thrown for working with file [" + filename + "] and VIXType [" + VIXType + "]");
			System.out.println("Error message: " + iox.getMessage());
		} finally {
        	// Fortify change: added finally block
        	try { if(fw != null) { fw.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        	try { if(bw != null) { bw.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}

		}
	}
}
