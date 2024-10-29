package gov.va.med.imaging.user.rest.resources;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.rest.types.RestStringArrayType;
import gov.va.med.imaging.user.commands.AuthenticateUserCommand;
import gov.va.med.imaging.user.commands.GetApplicationTimeoutParametersCommand;
import gov.va.med.imaging.user.commands.GetDivisionListCommand;
import gov.va.med.imaging.user.commands.GetUserKeysCommand;
import gov.va.med.imaging.user.commands.VerifyElectronicSignatureCommand;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

/**
 * @author vhaiswlouthj
 *
 */@Path("/user")
public class UserResource {
	
	    @GET
	    @Path("/authenticateUser")
	    @Consumes("text/plain")
	    public String authenticateUser(@QueryParam("applicationName") String applicationName)
	    		throws MethodException, ConnectionException
		{
	    	AuthenticateUserCommand command = new AuthenticateUserCommand("1.0", applicationName);
	    	return command.execute();
	    }
	    
	    @GET
	    @Path("/getDivisionList")
	    @Consumes("text/plain")
	    public String getDivisionsList(@QueryParam("accessCode") String accessCode)
	    		throws MethodException, ConnectionException
		{
	    	GetDivisionListCommand command = new GetDivisionListCommand(accessCode, "1.0");
	    	String divisionsXml = command.execute();
	    	return divisionsXml;
	    }
	    
	    @GET
	    @Path("/verifyElectronicSignature/{siteId}/{electronicSignature}")
	    @Produces(MediaType.APPLICATION_XML)
	    public RestBooleanReturnType verifyElectronicSignature(
	    		@PathParam("siteId") String siteId,
	    		@PathParam("electronicSignature") String electronicSignature)
		throws MethodException, ConnectionException
	    {
	    	return new VerifyElectronicSignatureCommand(siteId, electronicSignature).execute();
	    }
	    
	    @GET
	    @Path("/keys/{siteId}")
	    @Produces(MediaType.APPLICATION_XML)
	    public RestStringArrayType getUserKeys(
	    		@PathParam("siteId") String siteId)
	    throws MethodException, ConnectionException
	    {
	    	return new GetUserKeysCommand(siteId).execute();
	    }
	    
	    @GET 
	    @Path("/getApplicationTimeoutParameters")
	    @Produces("application/xml")
	    public String getApplicationTimeoutParameters(
	    		@QueryParam("siteId") String siteId,
	    		@QueryParam("applicationName") String applicationName) 
	    throws MethodException, ConnectionException 
	    {
	    	GetApplicationTimeoutParametersCommand command = new GetApplicationTimeoutParametersCommand(siteId, applicationName, "1.0");
	    	String result = command.execute();
	    	return result;
	    }
}