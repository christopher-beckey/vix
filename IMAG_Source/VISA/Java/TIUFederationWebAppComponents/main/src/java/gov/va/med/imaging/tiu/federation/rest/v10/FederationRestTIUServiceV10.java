package gov.va.med.imaging.tiu.federation.rest.v10;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.federation.commands.AssociateImageWithTIUNoteFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.CreateTIUNoteAddendumFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.CreateTIUNoteFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.ElectronicallyFileTIUNoteFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.ElectronicallySignTIUNoteFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.GetAuthorsFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.GetLocationsFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.GetMatchingTIUNotesFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.GetPatientTIUNotesFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.GetTIUNoteTextFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.IsNoteValidAdvanceDirectiveFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.IsPatientNoteValidAdvanceDirectiveFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.IsTIUNoteAConsultFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.commands.IsTIUNoteValidFederationTIUCommand;
import gov.va.med.imaging.tiu.federation.endpoints.FederationTIUNoteRestUri;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteAddendumInputType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteInputParametersType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteInputType;

@Path(FederationRestUri.federationRestUriV10 + "/" + FederationTIUNoteRestUri.tiuNoteServicePath)
public class FederationRestTIUServiceV10 
extends AbstractFederationRestService 
{
	
	@GET
	@Path(FederationTIUNoteRestUri.getTIUNotesPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getMatchingTIUNotes(
			@PathParam("routingToken") String routingTokenString,
			@QueryParam("searchText") String searchText,
			@QueryParam("titleList") String titleList)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetMatchingTIUNotesFederationTIUCommand(routingTokenString, searchText, titleList, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path(FederationTIUNoteRestUri.getTIULocationsPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getTIUNoteLocations(
			@PathParam("routingToken") String routingTokenString,
			@QueryParam("searchText") String searchText)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetLocationsFederationTIUCommand(routingTokenString, searchText, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path(FederationTIUNoteRestUri.getTIUAuthorsPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getTIUNoteAuthors(
			@PathParam("routingToken") String routingTokenString,
			@QueryParam("searchText") String searchText)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetAuthorsFederationTIUCommand(routingTokenString, searchText, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path(FederationTIUNoteRestUri.associateImageWithNotePath)
	@Produces(MediaType.APPLICATION_XML)
	public Response associateImageWithTIUNote(
		@PathParam("routingToken") String routingTokenString,
		@PathParam("imageUrn") String imageUrn,
		@PathParam("tiuNoteUrn") String tiuNoteUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new AssociateImageWithTIUNoteFederationTIUCommand(routingTokenString, imageUrn, tiuNoteUrn, getInterfaceVersion()).execute());
	}
	
	@POST
	@Path(FederationTIUNoteRestUri.createTIUNotePath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response createTIUNote(
			@PathParam("routingToken") String routingTokenString,
			FederationTIUNoteInputType noteInputType)	
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new CreateTIUNoteFederationTIUCommand(routingTokenString, noteInputType, getInterfaceVersion()).execute());
	}
	
	@POST
	@Path(FederationTIUNoteRestUri.electronicallySignNotePath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response electronicallySignTIUNote(
		@PathParam("routingToken") String routingTokenString,
		@PathParam("tiuNoteUrn") String tiuNoteUrn,
		RestStringType electronicSignature)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new ElectronicallySignTIUNoteFederationTIUCommand(routingTokenString, tiuNoteUrn, 
			electronicSignature, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path(FederationTIUNoteRestUri.electronicallyFileNotePath)
	@Produces(MediaType.APPLICATION_XML)
	public Response electronicallyFileTIUNote(
		@PathParam("routingToken") String routingTokenString,
		@PathParam("tiuNoteUrn") String tiuNoteUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new ElectronicallyFileTIUNoteFederationTIUCommand(routingTokenString, tiuNoteUrn, 
			getInterfaceVersion()).execute());
	}
	
	@GET
	@Path(FederationTIUNoteRestUri.isTiuNoteAConsultPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response isTIUNoteAConsult(
		@PathParam("routingToken") String routingTokenString,
		@PathParam("tiuItemUrn") String tiuItemUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new IsTIUNoteAConsultFederationTIUCommand(routingTokenString, tiuItemUrn, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path(FederationTIUNoteRestUri.isNoteValidAdvanceDirectivePath)
	@Produces(MediaType.APPLICATION_XML)
	public Response isTIUNoteAdvanceDirective(
		@PathParam("routingToken") String routingTokenString,
		@PathParam("tiuItemUrn") String tiuItemUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new IsNoteValidAdvanceDirectiveFederationTIUCommand(routingTokenString, tiuItemUrn, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path(FederationTIUNoteRestUri.isPatientNoteValidAdvanceDirectivePath)
	@Produces(MediaType.APPLICATION_XML)
	public Response isTIUPatientNoteAdvanceDirective(
		@PathParam("routingToken") String routingTokenString,
		@PathParam("noteUrn") String noteUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new IsPatientNoteValidAdvanceDirectiveFederationTIUCommand(routingTokenString, noteUrn, getInterfaceVersion()).execute());
	}
	
	@POST
	@Path(FederationTIUNoteRestUri.getPatientTIUNotesPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getPatientTIUNotes(
		@PathParam("routingToken") String routingTokenString,
		FederationTIUNoteInputParametersType parametersType)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new GetPatientTIUNotesFederationTIUCommand(routingTokenString, parametersType, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path(FederationTIUNoteRestUri.getTIUNoteTextPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getPatientTIUNoteText(
		@PathParam("routingToken") String routingTokenString,
		@PathParam("noteUrn") String noteUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new GetTIUNoteTextFederationTIUCommand(routingTokenString, noteUrn, getInterfaceVersion()).execute());
	}
	
	
	@POST
	@Path(FederationTIUNoteRestUri.createTIUNoteAddendumPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response createTIUNoteAddendum(
		@PathParam("routingToken") String routingTokenString,
		@PathParam("noteUrn") String noteUrn,
		FederationTIUNoteAddendumInputType addendumInput)	
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new CreateTIUNoteAddendumFederationTIUCommand(routingTokenString, noteUrn, addendumInput, getInterfaceVersion()).execute());
	}

	@GET
	@Path(FederationTIUNoteRestUri.isTiuNoteValidPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response isTiuNoteValid(
			@PathParam("routingToken") String routingTokenString,
			@QueryParam("tiuNoteUrn") String tiuNoteUrn,
			@QueryParam("patientTiuNoteUrn") String patientTiuNoteUrn,
			@QueryParam("typeIndex") String typeIndex)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new IsTIUNoteValidFederationTIUCommand(routingTokenString, tiuNoteUrn, patientTiuNoteUrn, typeIndex, getInterfaceVersion()).execute());
	}

	@Override
	protected String getInterfaceVersion() {
		return "V10";
	}


}
