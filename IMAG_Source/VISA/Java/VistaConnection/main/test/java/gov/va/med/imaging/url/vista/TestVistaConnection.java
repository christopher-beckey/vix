package gov.va.med.imaging.url.vista;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;

import junit.framework.TestCase;

public class TestVistaConnection 
extends AbstractVistaConnectionTest
{
	private VistaConnection vistaConnection;
	
	@Override
    protected void setUp() 
	throws Exception
    {
	    super.setUp();
	    
	    URL vistaUrl = new URL("vista://localhost:9300");
	    //vistaUrl = new URL("vista://vhaiswimgvms501:9300");
	    //vistaUrl = new URL("vista://VISTA.WASHINGTON.MED.VA.GOV:19227");
	    //vistaUrl = new URL("vista://VISTA.RICHMOND.MED.VA.GOV:9200");
	    //vistaUrl = new URL("vista://vhaiswimmixvi1:9500");
	    //vistaUrl = new URL("vista://vista.baltimore.med.va.gov:19225");
	    //vistaUrl = new URL("vista://VISTA.MARTINSBURG.MED.VA.GOV:19226");
	    vistaUrl = new URL("vista://10.4.237.70:9200"); // station 200
	    vistaConnection = new VistaConnection(vistaUrl);
    }

	
	private VistaConnection getVistaConnection()
    {
    	return vistaConnection;
    }
	
	public void testConnect()
	{
		try
        {
			boolean capri = false;
			long startTime = System.currentTimeMillis();
            logger.info("start time: {}", startTime);
			getVistaConnection().connect();
			System.out.println("Connect took '" + (System.currentTimeMillis() - startTime) + "' ms.");
	        logger.info("Connect complete");
	       
	        VistaQuery vq = null;
	        if(capri)
	        {
	        	
	        	vq = new VistaQuery("XUS SIGNON SETUP");
	        	//vq.addParameter(VistaQuery.LITERAL, "2");
	        	//vq.addParameter(VistaQuery.LITERAL, "2");
	        	getVistaConnection().call(vq);
	        	
	        	String param = "-31^DVBA_" + 
				"^843924956" + 
				"^IMAGPROVIDERONETWOSIX,ONETWOSIX" + 
				"^Salt Lake City" + 
				"^660" +  
				"^126" + 
				"^No Phone";
	        	
	        	
	        	vq = new VistaQuery("XUS SIGNON SETUP");
	        	vq.addParameter(VistaQuery.LITERAL, param);
	        	getVistaConnection().call(vq);
	        	
	        }
	        else
	        {	        		        	
	        	vq = new VistaQuery("XUS SIGNON SETUP");
	        	//vq.addParameter(VistaQuery.LITERAL, "");
	        	//vq.addParameter(VistaQuery.LITERAL, "2");
	        	getVistaConnection().call(vq);
	        	
	        	
	        	vq.clear();
		        vq.setRpcName("XUS AV CODE");
		        //vq.addEncryptedParameter(VistaQuery.LITERAL, "testing_1;testing_2");
		        vq.addEncryptedParameter(VistaQuery.LITERAL, "boating1;boating1.");
		        //vq.addEncryptedParameter(VistaQuery.LITERAL, "vix1234;washington.456");
		        String response = getVistaConnection().call(vq);
                logger.info("'{}' result: {}", vq.getRpcName(), response);
	        }	        	       
	        
	        vq.clear();
	        long endTime = System.currentTimeMillis();
	        /*
	        vq.setRpcName("XWB CREATE CONTEXT");
	        vq.addEncryptedParameter(VistaQuery.LITERAL, "MAG WINDOWS");
	        String response = getVistaConnection().call(vq);
	        logger.info("'" + vq.getRpcName() + "' result: " + response);
	        
	        
	        vq.clear();
	        vq.setRpcName("MAGG PAT INFO");
	        vq.addParameter(VistaQuery.LITERAL, "711^^0");
	        response = getVistaConnection().call(vq);
	        logger.info("'" + vq.getRpcName() + "' result: " + response);	        	       	        
	        */
	        System.out.println("Full login took '" + (endTime - startTime) + "' ms.");
	        
	        
        } 
		catch (IOException e)
        {
	        e.printStackTrace();
	        fail(e.getMessage());
        }
		catch(Exception e)
		{
			e.printStackTrace();
			fail(e.getMessage());
		}
		
		// we're not testing disconnect so don't broadcast errors
        getVistaConnection().disconnectImmediately();
	}

	/*
	public void testDisconnect()
	{
		try
        {
	        getVistaConnection().connect();
        } 
		catch (IOException e)
        {
	        e.printStackTrace();
	        TestCase.fail(e.getMessage());
        }
	    assertTrue( getVistaConnection().isConnected() );
		
	    getVistaConnection().disconnect();
	    assertFalse( getVistaConnection().isConnected() );
	}*/
	
	/**
	 * Just repeatedly connect and disconnect
	 */
	/*
	public void testRepetitiveConnectDisconnect()
	{
		for(int n=0; n < 10; ++n)
		{
			try
	        {
		        getVistaConnection().connect();
	        } 
			catch (IOException e)
	        {
		        e.printStackTrace();
		        TestCase.fail(e.getMessage());
	        }
			
		    getVistaConnection().disconnect();
		}
		
	}
	
	public void testGetInputStream()
	{
		try
        {
	        getVistaConnection().connect();
	        InputStream inStream = getVistaConnection().getInputStream();
	        assertNotNull("Input stream is null and should not be.", inStream);
	        
	        getVistaConnection().disconnect();
        } 
		catch (IOException e)
        {
	        e.printStackTrace();
	        TestCase.fail(e.getMessage());
        }
	}

	public void testGetOutputStream()
	{
		try
        {
	        getVistaConnection().connect();
	        OutputStream outStream = getVistaConnection().getOutputStream();
	        assertNotNull("Output stream is null and should not be.", outStream);
	        
	        getVistaConnection().disconnect();
        } 
		catch (IOException e)
        {
	        e.printStackTrace();
	        TestCase.fail(e.getMessage());
        }
	}*/

	@Override
    protected void tearDown() 
	throws Exception
    {
	    super.tearDown();
    }
}
