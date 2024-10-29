/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult.rest;

import gov.va.med.imaging.consult.rest.commands.GetPatientConsultsCommand;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/**
 * @author Julian Werfel
 *
 */
@Path("consult")
public class ConsultService
extends AbstractRestService
{
	
	@GET
	@Path("consults/{siteId}/{patientId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getPatientConsults(
		@PathParam("siteId") String siteId,
		@PathParam("patientId") String patientId)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetPatientConsultsCommand(siteId, patientId, 
				getInterfaceVersion()).execute());
	}

	protected String getInterfaceVersion()
	{
		return "V1";
	}
}
