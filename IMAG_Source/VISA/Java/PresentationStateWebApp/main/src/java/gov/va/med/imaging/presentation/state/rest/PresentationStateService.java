/**
 * 
 */
package gov.va.med.imaging.presentation.state.rest;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.presentation.state.PresentationStateContextHolder;
import gov.va.med.imaging.presentation.state.commands.DeletePresentationStateRecordCommand;
import gov.va.med.imaging.presentation.state.commands.GetPresentationStateAnnotationsCommand;
import gov.va.med.imaging.presentation.state.commands.GetPresentationStateDetailsCommand;
import gov.va.med.imaging.presentation.state.commands.GetPresentationStateRecordsCommand;
import gov.va.med.imaging.presentation.state.commands.PostPresentationStateDetailCommand;
import gov.va.med.imaging.presentation.state.commands.PostPresentationStateRecordCommand;
import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordType;
import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordsType;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

/**
 * @author William Peterson
 *
 */
@Path("presentationstate")
public class PresentationStateService 
extends AbstractRestService {
	
	private final Logger logger = Logger.getLogger(PresentationStateService.class);


	@POST
	@Path("create/record")
	@Consumes(MediaType.APPLICATION_JSON)
	public Response createPStateRecord(
			@HeaderParam("filename") String fileSpec,
			PresentationStateRecordType pStateRecordType)
	throws MethodException, ConnectionException
	{
		logger.debug("Finally made it to the service call.");
		if(pStateRecordType == null){
			logger.debug("PresentationStateRecordType is not set.");
		}
        logger.debug("Received JSON Values: {}", pStateRecordType.toString());
        logger.debug("XML Object String: {}", pStateRecordType.getPStateData());
		return wrapResultWithResponseHeaders(
				new PostPresentationStateRecordCommand(getLocalSiteNumber(), getInterfaceVersion(), fileSpec, pStateRecordType).execute());
	}

	@DELETE
	@Path("delete/record")
	@Consumes(MediaType.APPLICATION_JSON)
	public Response deletePStateRecord(
			PresentationStateRecordType pStateRecordType)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new DeletePresentationStateRecordCommand(getLocalSiteNumber(), getInterfaceVersion(), pStateRecordType).execute());
	}
	
	
	@POST
	@Path("get/records")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON)
	public Response getPStateRecords(
			PresentationStateRecordType pStateRecordType)
	throws MethodException, ConnectionException
	{
		PresentationStateRecordsType rec = (PresentationStateRecordsType)
			new GetPresentationStateRecordsCommand(getLocalSiteNumber(), getInterfaceVersion(), pStateRecordType).execute();
		
		if (rec == null)
		{
			return Response.status(204).build();
		}
		else
		{
			return wrapResultWithResponseHeaders(rec);
		}
	}
	

	@POST
	@Path("set/detail")
	@Consumes(MediaType.APPLICATION_JSON)
	public Response setPStateDetail(
			PresentationStateRecordType pStateRecordType)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new PostPresentationStateDetailCommand(getLocalSiteNumber(), getInterfaceVersion(), pStateRecordType).execute());
	}
	
	@POST
	@Path("get/details")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON)
	public Response getPStateDetails(
			PresentationStateRecordsType pStateRecords)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new GetPresentationStateDetailsCommand(getLocalSiteNumber(), getInterfaceVersion(), pStateRecords).execute());
	}


	@GET
	@Path("get/annotations")
	@Produces(MediaType.APPLICATION_XML)
	public Response getAnnotations(
			@QueryParam("studyContext") String studyContext)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new GetPresentationStateAnnotationsCommand(getLocalSiteNumber(), getInterfaceVersion(), studyContext).execute());
	}

	private String getLocalSiteNumber()
	{
		return PresentationStateContextHolder.getPresentationStateContext().getAppConfiguration().getLocalSiteNumber();
	}
	
	protected String getInterfaceVersion()
	{
		return "1";
	}

}
