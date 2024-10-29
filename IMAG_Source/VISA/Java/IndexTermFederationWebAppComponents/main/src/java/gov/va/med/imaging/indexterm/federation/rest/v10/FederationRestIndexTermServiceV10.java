package gov.va.med.imaging.indexterm.federation.rest.v10;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.indexterm.federation.commands.GetOriginsFederationIndexTermCommand;
import gov.va.med.imaging.indexterm.federation.commands.GetProcedureEventsFederationIndexTermCommand;
import gov.va.med.imaging.indexterm.federation.commands.GetSpecialtiesFederationIndexTermCommand;
import gov.va.med.imaging.indexterm.federation.commands.GetTypesFederationIndexTermCommand;
import gov.va.med.imaging.indexterm.federation.endpoints.FederationIndexTermRestUri;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexClassArrayType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexClassAndURNType;

@Path(FederationRestUri.federationRestUriV10 + "/" + FederationIndexTermRestUri.indexTermServicePath)
public class FederationRestIndexTermServiceV10 
extends AbstractFederationRestService 
{

	@GET
	@Path(FederationIndexTermRestUri.getOriginsPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getOrigins(
			@PathParam("routingToken") String routingTokenString)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetOriginsFederationIndexTermCommand(routingTokenString, getInterfaceVersion()).execute());
	}
	
	
	@POST
	@Path(FederationIndexTermRestUri.getProcedureEventsPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getProcedureEvents(
			@PathParam("routingToken") String routingTokenString,
			FederationIndexClassAndURNType eventBodyType)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetProcedureEventsFederationIndexTermCommand(routingTokenString, eventBodyType, 
						getInterfaceVersion()).execute());
	}
	
	
	@POST
	@Path(FederationIndexTermRestUri.getSpecialtiesPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getSpecialties(
			@PathParam("routingToken") String routingTokenString,
			FederationIndexClassAndURNType specialtiesBodyType)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new GetSpecialtiesFederationIndexTermCommand(routingTokenString, specialtiesBodyType, 
						getInterfaceVersion()).execute());
	}
	
	@POST
	@Path(FederationIndexTermRestUri.getTypesPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getTypes(
			@PathParam("routingToken") String routingTokenString,
			FederationIndexClassArrayType federationIndexClasses)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetTypesFederationIndexTermCommand(routingTokenString, federationIndexClasses, 
						getInterfaceVersion()).execute());
	}

	
	@Override
	protected String getInterfaceVersion() {
		return "V10";
	}


}
