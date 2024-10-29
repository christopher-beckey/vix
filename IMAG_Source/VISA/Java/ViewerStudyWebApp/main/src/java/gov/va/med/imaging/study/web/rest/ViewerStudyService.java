/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.rest;

import java.util.Date;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.study.web.commands.*;
import gov.va.med.imaging.study.web.rest.types.CprsIdentifiersType;
import gov.va.med.imaging.study.web.rest.types.ViewerQAStudyFilterType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyFilterType;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

/**
 * @author Julian
 *
 */
@Path("study")
public class ViewerStudyService
extends AbstractRestService
{	
	//private final static Logger LOGGER = Logger.getLogger(ViewerStudyService.class);
	
	@GET
	@Path("cprs/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getStudiesFromCprsIdentifier(
		@PathParam("siteId") String siteId,
		@QueryParam("icn") String patientIcn,
		@QueryParam("cprsIdentifier") String cprsIdentifier)
	throws MethodException, ConnectionException
	{		
		return wrapResultWithResponseHeaders(new GetStudiesByCprsIdentifierCommand(siteId, patientIcn, cprsIdentifier).execute());
	}
	
	/**
	@GET
	@Path("studies/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getPatientStudies(
		@PathParam("siteId") String siteId,
		@QueryParam("icn") String patientIcn)
	throws MethodException, ConnectionException
	{		
		return wrapResultWithResponseHeaders(new GetPatientStudiesCommand(siteId, patientIcn, null).execute());
	}
	**/

	@GET
	@Path("studies/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getPatientStudies(
		@PathParam("siteId") String siteId,
		@QueryParam("icn") String patientIcn,
		@QueryParam("imageFilter") String imageFilter,
		@QueryParam("appName") String appName) // QN: this is new
	throws MethodException, ConnectionException
	{	
		// QN: can't use ViewerStudyFilterType (always null here) b/c of potential side effects of null vs. empty object
		// when translating if created new. Can use siteId, icn or imageFilter. Safer to choose imageFilter.
		imageFilter = imageFilter + (appName == null || appName.isEmpty() ? "" : "*DASH*");
		
		return wrapResultWithResponseHeaders(new GetPatientStudiesCommand(siteId, patientIcn, imageFilter, null).execute());
	}

	@POST
	@Path("studies/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getPatientStudies(
		@PathParam("siteId") String siteId,
		@QueryParam("icn") String patientIcn,
		ViewerStudyFilterType filter)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(new GetPatientStudiesCommand(siteId, patientIcn, filter).execute());
	}
	
	@GET
	@Path("cprs/hydra/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getStudiesFromCprsIdentifierInHydraForm(
		@PathParam("siteId") String siteId,
		@QueryParam("icn") String patientIcn,
		@QueryParam("cprsIdentifier") String cprsIdentifier)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(new GetHydraStudiesByCrpsIdentifierCommand(siteId, patientIcn, cprsIdentifier).execute());
	}
	
	@POST
	@Path("cprs/viewer/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getViewerStudiesFromCprsIdentifier(
		@PathParam("siteId") String siteId,
		@QueryParam("icn") String patientIcn,
		CprsIdentifiersType cprsIdentifiers)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(new PostStudiesByCprsIdentifiersCommand(
				siteId, patientIcn, cprsIdentifiers).execute());
	}

	@GET
	@Path("user/token")
	@Produces(MediaType.APPLICATION_XML)
	public Response createToken(
		@HeaderParam("xxx-appName") String appName)
	throws MethodException, ConnectionException
	{
		// must be in here using a secure method
		return wrapResultWithResponseHeaders(new GetUserTokenCommand(appName).execute());
	}

	@GET
	@Path("user/ststoken")
	@Produces(MediaType.APPLICATION_XML)
	public Response createStsToken(
			@HeaderParam("xxx-appName") String appName,
			@HeaderParam("xxx-stsToken") String stsToken)
			throws MethodException, ConnectionException
	{
		// must be in here using a secure method
		return wrapResultWithResponseHeaders(new GetUserStsTokenCommand(appName, stsToken).execute());
	}
	
	@GET
	@Path("filter")
	@Produces(MediaType.APPLICATION_XML)
	public Response getFilter()
	throws MethodException, ConnectionException
	{
		// must be in here using a secure method
		ViewerStudyFilterType filter = new ViewerStudyFilterType();
		filter.setFilterClass("FilterClass");
		filter.setFilterEvent("FilterEvent");
		filter.setFilterOrigin("FilterOrigin");
		filter.setFilterPackage("FilterPackage");
		filter.setFilterSpecialty("FilterSpecialty");
		filter.setFilterType("FilterType");
		filter.setFromDate(new Date());
		filter.setToDate(new Date());
		return wrapResultWithResponseHeaders(filter);
	}

	@POST
	@Path("viewer/qareview/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getViewerStudiesForQaReview(
		@PathParam("siteId") String siteId,
		ViewerQAStudyFilterType studyFilter)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(new PostViewerStudiesForQaReviewCommand(
				siteId, studyFilter).execute());
	}
}
