package gov.va.med.imaging.study.web.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.study.web.commands.GetUserStsTokenCommand;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("token")
public class ViewerTokenService extends AbstractRestService {
    @GET
    @Path("")
    @Produces(MediaType.APPLICATION_XML)
    public Response createStsToken(@HeaderParam("xxx-appName") String appName, @HeaderParam("xxx-stsToken") String stsToken) throws MethodException, ConnectionException {
        // We need to immediately validate the STS token here
        return wrapResultWithResponseHeaders(new GetUserStsTokenCommand(appName, stsToken).execute());
    }
}
