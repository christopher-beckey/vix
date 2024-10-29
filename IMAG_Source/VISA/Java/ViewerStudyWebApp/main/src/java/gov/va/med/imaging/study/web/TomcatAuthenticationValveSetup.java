package gov.va.med.imaging.study.web;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;

public class TomcatAuthenticationValveSetup {

	
	public TomcatAuthenticationValveSetup() {
		
		
	}

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
		
		//read VIXType variable from arguments
		String VIXType = null;
		String filename = null;
		try{
			VIXType = System.getenv("VIXType");
			filename = args[0];
			//delete original context.xml in WebRoot\META-INF
			File delFile = new File(cleanString(filename));
			if(delFile.exists()){
				if(!delFile.delete()){
					throw new Exception();
				}
			}
		
			//create string buffer to use the correct Tomcat Authentication Value.
			StringBuffer buffer = new StringBuffer();
			buffer.append("<Context>");
			buffer.append("\n");
			buffer.append("\t");
			if(VIXType.equalsIgnoreCase("VIX")){
				buffer.append("<Valve className=\"gov.va.med.server.tomcat.TomcatBasicAuthenticatorValve\" />");
			}
			else if(VIXType.equalsIgnoreCase("RVIX")){
				buffer.append("<Valve className=\"gov.va.med.server.tomcat.TomcatBasicSkipVistaAuthenticationValve\" />");
			}
			else if(VIXType.equalsIgnoreCase("CVIX")){
				buffer.append("<Valve className=\"gov.va.med.server.tomcat.TomcatBasicAuthenticatorValve\" />");
			}
			else if(VIXType.equalsIgnoreCase("HDIG")){
				buffer.append("<Valve className=\"gov.va.med.server.tomcat.TomcatBasicAuthenticatorValve\" />");
			}
			else{
				buffer.append("<Valve className=\"gov.va.med.server.tomcat.TomcatBasicAuthenticatorValve\" />");				
			}
			
			buffer.append("\n");
			buffer.append("</Context>");
			buffer.append("\n");
			
			//save as context.xml in WebRoot\META-INF
			FileWriter fileWriter = null;
			BufferedWriter writer = null;
			try {
				fileWriter = new FileWriter(new File(cleanString(filename)));
				writer = new BufferedWriter(fileWriter);
				writer.write(buffer.toString());
				writer.flush();
				writer.close();
			} finally {
				if (fileWriter != null) {
					try {
						fileWriter.close();
					} catch (Exception e) {
						// Ignore
					}
				}
				if (writer != null) {
					try {
						writer.close();
					} catch (Exception e) {
						// Ignore
					}
				}
			}
		}
		catch(Exception X){
			System.out.println("Exception thrown while attempting to create new file.");
			System.out.println("filename: "+filename);
			System.out.println("VIXType: "+VIXType);
		}
	}
}
