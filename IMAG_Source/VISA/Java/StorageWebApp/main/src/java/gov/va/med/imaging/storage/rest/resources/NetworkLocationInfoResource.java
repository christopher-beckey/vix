package gov.va.med.imaging.storage.rest.resources;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.storage.commands.GetCurrentWriteLocationCommand;
import gov.va.med.imaging.storage.commands.GetNetworkLocationDetailsCommand;

import java.io.IOException;
import java.io.InputStream;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.QueryParam;

/**
 * @author vhaiswlouthj
 *
 */@Path("/networkLocationInfo")
public class NetworkLocationInfoResource {

	    @GET
	    @Path("/getCurrentWriteLocation")
	    @Consumes("text/plain")
	    public String getCurrentWriteLocation(@QueryParam("siteNumber") String siteNumber)
	    		throws MethodException, ConnectionException
		{
	    	String result = "";
	    	try
	    	{
		    	GetCurrentWriteLocationCommand command = new GetCurrentWriteLocationCommand(siteNumber, "1.0");
		    	result = command.execute();
	    	}
	    	catch(Exception e)
	    	{
	    		e.printStackTrace();
	    	}
	    	
	    	return result;
	    }
	    
	    @GET
	    @Path("/getNetworkLocationDetails")
	    @Consumes("text/plain")
	    public String getNetworkLocationDetails(@QueryParam("networkLocationIen") String networkLocationIen)
	    		throws MethodException, ConnectionException
		{
	    	GetNetworkLocationDetailsCommand command = new GetNetworkLocationDetailsCommand(networkLocationIen, "1.0");
	    	return command.execute();
	    }
	    
}