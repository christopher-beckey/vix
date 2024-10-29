/**
 * 
 */
package gov.va.med.imaging.federation.rest.v6;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.commands.externalpackage.FederationExternalPackagePostBothDBStudiesFromCprsIdentifiersCommand;
import gov.va.med.imaging.federation.commands.externalpackage.FederationExternalPackagePostStudiesFromCprsIdentifiersCommand;
import gov.va.med.imaging.federation.rest.endpoints.FederationExternalPackageRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.federation.rest.types.FederationCprsIdentifiersType;
import gov.va.med.imaging.federation.rest.v5.FederationRestExternalPackageServiceV5;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/**
 * @author William Peterson
 *
 */
@Path(FederationRestUri.federationRestUriV6 + "/" + FederationExternalPackageRestUri.externalPackageServicePath)
public class FederationRestExternalPackageServiceV6 
extends FederationRestExternalPackageServiceV5 {
	
	@POST
	@Path(FederationExternalPackageRestUri.postStudiesFromCprsMethodPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response postStudiesFromCprsIdentifiers(
			@PathParam("routingToken") String routingToken, 
			@PathParam("patientIcn") String patientIcn,
			@QueryParam("bothdb") String bothdb,
			FederationCprsIdentifiersType cprsIdentifiers)
	throws MethodException, ConnectionException
	{
		if (bothdb == null)
		{
			bothdb = "";
		}
		
		logger.debug("executing PostStudiesFromCprsIdentifiers web service in FederationRestExternalPackageServiceV6.");
		FederationExternalPackagePostBothDBStudiesFromCprsIdentifiersCommand command = 
			new FederationExternalPackagePostBothDBStudiesFromCprsIdentifiersCommand(
					routingToken, patientIcn, 
					cprsIdentifiers, 
					bothdb,
					getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@Override
	protected String getInterfaceVersion()
	{
		return "V6";
	}


}
