package gov.va.med.imaging.url.vista;

import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

public class BasicVistaLogin {

	public static void main(String[] args) {
		
		BasicVistaLogin vistaLogin = new BasicVistaLogin();
		
		try {
			vistaLogin.handlerPkgs();
			VistaConnection connect = vistaLogin.connectVista();
			connect.connect();
	        System.out.println("Connect complete");
	        String bseToken = vistaLogin.LoginVista(connect);
	        System.out.println("BSE Token: " + bseToken);
	        connect.disconnectImmediately();
			
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (InvalidVistaCredentialsException e) {
			e.printStackTrace();
		} catch (VistaMethodException e) {
			e.printStackTrace();
		}
		
		System.exit(0);
	}
	
	public void handlerPkgs(){
		String handlerPackages = System.getProperty("java.protocol.handler.pkgs");
		System.setProperty("java.protocol.handler.pkgs",
		        handlerPackages == null || handlerPackages.length() == 0 ? 
		        "gov.va.med.imaging.url" : 
		        "" + handlerPackages + "|" + "gov.va.med.imaging.url");

	}
	
	public VistaConnection connectVista() throws MalformedURLException{
	
		VistaConnection vistaConnection = null;
		String vistaHost = "vaausappvim905.aac.dva.va.gov";
		String vistaPort = "9300";
		
		//URL vistaUrl = new URL("vista://localhost:9300");
	    URL vistaUrl = new URL("vista://vaausdbsvim905.aac.dva.va.gov:9300");
	    

	    vistaConnection = new VistaConnection(vistaUrl);
	    
	    return vistaConnection;
	}
	
	
	public String LoginVista(VistaConnection connect) throws IOException, InvalidVistaCredentialsException, VistaMethodException{
        VistaQuery vq = null;

        String bseToken = null;
        
    	vq = new VistaQuery("XUS SIGNON SETUP");
    	String setupResult = connect.call(vq);
    	System.out.println("Signon Setup: " + StringUtils.displayEncodedChars(setupResult));
    	
    	vq.clear();
        vq.setRpcName("XUS AV CODE");
        vq.addEncryptedParameter(VistaQuery.LITERAL, "boating1;boating1.");
        String avCodeResult = connect.call(vq);
        System.out.println("AV Code: " + StringUtils.displayEncodedChars(avCodeResult));
        
        vq.clear();
        vq.setRpcName("XWB CREATE CONTEXT");
        vq.addEncryptedParameter(VistaQuery.LITERAL, "MAG WINDOWS");
        String contextResult = connect.call(vq);
        System.out.println("Set Context: " + StringUtils.displayEncodedChars(contextResult));
        
        vq.clear();
		vq.setRpcName("XUS DIVISION SET");
		vq.addParameter(VistaQuery.LITERAL, "660");
        String divResult = connect.call(vq);
        System.out.println("Set Division: " + StringUtils.displayEncodedChars(divResult));

		vq.clear();
	    vq.setRpcName("MAG BROKER SECURITY");
	    String bseResult = connect.call(vq);
        System.out.println("BSE Token: " + StringUtils.displayEncodedChars(bseResult));
        bseToken = bseResult;

    	vq = new VistaQuery("MAGG LOGOFF");
    	String logoffResult = connect.call(vq);
    	System.out.println("Logoff: " + StringUtils.displayEncodedChars(logoffResult));

    	return bseToken;
	}
	


}
