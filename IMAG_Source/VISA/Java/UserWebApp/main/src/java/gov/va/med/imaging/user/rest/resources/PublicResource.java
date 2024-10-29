package gov.va.med.imaging.user.rest.resources;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.user.commands.AuthenticateUserCommand;
import gov.va.med.imaging.user.commands.GetWelcomeMessageCommand;

import java.io.IOException;
import java.io.InputStream;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;

/**
 * @author vhaiswlouthj
 *
 */@Path("/public")
public class PublicResource {

	    @GET
	    @Path("/getWelcomeMessage")
	    @Consumes("text/plain")
	    public String getWelcomeMessage()
	    throws MethodException, ConnectionException
		{
	    	GetWelcomeMessageCommand command = new GetWelcomeMessageCommand("1.0");
	    	return command.execute();
	    }
    
}