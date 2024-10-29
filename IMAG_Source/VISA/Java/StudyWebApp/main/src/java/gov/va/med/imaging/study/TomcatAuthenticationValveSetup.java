package gov.va.med.imaging.study;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;

public class TomcatAuthenticationValveSetup {

	
	public TomcatAuthenticationValveSetup() {
		
		
	}

	public static void main(String[] args) {
		
		//read VIXType variable from arguments
		String VIXType = null;
		String filename = null;
		try{
			VIXType = System.getenv("VIXType");
			filename = args[0];
			//delete original context.xml in WebRoot\META-INF
			File delFile = new File(filename);
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
				fileWriter = new FileWriter(new File(filename));
				new BufferedWriter(fileWriter);
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
