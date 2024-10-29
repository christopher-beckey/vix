/**
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.rest;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.indexterm.rest.commands.GetOriginsCommand;
import gov.va.med.imaging.indexterm.rest.commands.GetProcedureEventsCommand;
import gov.va.med.imaging.indexterm.rest.commands.GetSpecialtiesCommand;
import gov.va.med.imaging.indexterm.rest.commands.GetTypesCommand;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

/**
 * @author Julian Werfel
 *
 */
@Path("indexTerms")
public class IndexTermService
extends AbstractRestService
{

	@GET
	@Path("origins/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getOrigins(
			@PathParam("siteId") String siteId)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetOriginsCommand(siteId, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("procedureevents/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getProcedureEvents(
			@PathParam("siteId") String siteId)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetProcedureEventsCommand(siteId, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("procedureevents/{siteId}/{specialties}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getProcedureEventsForSpecialties(
			@PathParam("siteId") String siteId,
			@PathParam("specialties") String specialties,
			@QueryParam("classes") String classes)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetProcedureEventsCommand(siteId, classes, specialties, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("specialties/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getSpecialties(
			@PathParam("siteId") String siteId)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetSpecialtiesCommand(siteId, null, null, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("specialties/{siteId}/{events}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getSpecialtiesForEvents(
			@PathParam("siteId") String siteId,
			@PathParam("events") String events,
			@QueryParam("classes") String classes)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetSpecialtiesCommand(siteId, classes, 
						events, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("types/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getTypes(
			@PathParam("siteId") String siteId)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetTypesCommand(siteId, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("typesWithClasses/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getTypesForClasses(
			@PathParam("siteId") String siteId,
			@QueryParam("classes") String classes)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetTypesCommand(siteId, classes, 
						getInterfaceVersion()).execute());
	}
		
	protected String getInterfaceVersion()
	{
		return "V1";
	}
}
