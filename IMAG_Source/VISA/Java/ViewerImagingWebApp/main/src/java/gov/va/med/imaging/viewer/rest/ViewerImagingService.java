/**
 * Date Created: Apr 22, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;
import gov.va.med.imaging.viewer.ViewerImagingContextHolder;
import gov.va.med.imaging.viewer.commands.DeleteImagesCommand;
import gov.va.med.imaging.viewer.commands.FlagImagesAsSensitiveCommand;
import gov.va.med.imaging.viewer.commands.GetDeleteReasonsCommand;
import gov.va.med.imaging.viewer.commands.GetPrintReasonsCommand;
import gov.va.med.imaging.viewer.commands.GetStatusReasonsCommand;
import gov.va.med.imaging.viewer.commands.GetTreatingFacilitiesCommand;
import gov.va.med.imaging.viewer.commands.GetUserInformationByUserIdCommand;
import gov.va.med.imaging.viewer.commands.LogAccessImageUrnsCommand;
import gov.va.med.imaging.viewer.commands.LogPrintImageAccessCommand;
import gov.va.med.imaging.viewer.rest.endpoints.ViewerImagingRestUri;
import gov.va.med.imaging.viewer.rest.types.DeleteImageUrnsType;
import gov.va.med.imaging.viewer.rest.types.FlagSensitiveImageUrnsType;
import gov.va.med.imaging.viewer.rest.types.LogAccessImageUrnsType;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

/**
 * @author vhaisltjahjb
 *
 */
@Path(ViewerImagingRestUri.viewerImagingServicePath)
public class ViewerImagingService
extends AbstractRestService
{
    @GET
   	@Path(ViewerImagingRestUri.viewerImagingGetUserInformationMethodPath)
    @Produces(MediaType.APPLICATION_XML)
   	public Response getUserInformation(
            @QueryParam("siteId") String siteId,
            @QueryParam("userId") String userId)
    throws MethodException, ConnectionException
    {
    	//GetUserInformationByUserIdCommand command = new GetUserInformationByUserIdCommand(siteId, userId, "1.0");
        //return command.execute();
        
 		return wrapResultWithUserResponseHeaders(
 				new GetUserInformationByUserIdCommand(
 						siteId, 
 						userId, 
 						getInterfaceVersion()).execute());
    }
    
	private Response wrapResultWithUserResponseHeaders(Object result)
	{		
		TransactionContext transactionContext = TransactionContextFactory.get();
		return Response.status(Status.OK).
			header(TransactionContextHttpHeaders.httpHeaderMachineName, transactionContext.getMachineName()).
			header(TransactionContextHttpHeaders.httpHeaderDuz, transactionContext.getDuz()).
			header(TransactionContextHttpHeaders.httpHeaderFullName, transactionContext.getFullName()).
			header(TransactionContextHttpHeaders.httpHeaderSiteNumber, transactionContext.getSiteNumber()).
			header(TransactionContextHttpHeaders.httpHeaderSiteName, transactionContext.getSiteName()).
			entity(result).build();
	}

	
	@POST
	@Path(ViewerImagingRestUri.viewerImagingDeleteImagesMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response deleteImages(DeleteImageUrnsType imageUrns)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new DeleteImagesCommand(
						getLocalSiteNumber(), 
						imageUrns, 
						getInterfaceVersion()).execute());
	}

	@GET
	@Path(ViewerImagingRestUri.viewerImagingGetDeleteReasonsMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response getDeleteReasons()
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new GetDeleteReasonsCommand(
						getLocalSiteNumber(), 
						getInterfaceVersion()).execute());
	}

	@GET
	@Path(ViewerImagingRestUri.viewerImagingGetPrintReasonsMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response getPrintReasons()
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new GetPrintReasonsCommand(
						getLocalSiteNumber(), 
						getInterfaceVersion()).execute());
	}

	@GET
	@Path(ViewerImagingRestUri.viewerImagingGetStatusReasonsMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response getStatusReasons()
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new GetStatusReasonsCommand(
						getLocalSiteNumber(), 
						getInterfaceVersion()).execute());
	}

	@POST
	@Path(ViewerImagingRestUri.viewerImagingFlagImagesAsSensitiveMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response flagImagesAsSensitive(FlagSensitiveImageUrnsType imageUrns)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new FlagImagesAsSensitiveCommand(
						getLocalSiteNumber(), 
						imageUrns, 
						getInterfaceVersion()).execute());
	}
	
	@POST
	@Path(ViewerImagingRestUri.viewerImagingLogImageAccessMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response logImageAccess(
			@QueryParam("icn") String patientIcn,
			@QueryParam("dfn") String patientDfn,
			LogAccessImageUrnsType imageUrns)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new LogAccessImageUrnsCommand(
						getLocalSiteNumber(), 
						patientIcn,
						patientDfn,
						imageUrns, 
						getInterfaceVersion()).execute());
	}
	
    @GET
   	@Path(ViewerImagingRestUri.viewerImagingLogPrintImageAccessMethodPath)
    @Produces(MediaType.APPLICATION_XML)
   	public RestBooleanReturnType logPrintImageAccessEvent(
            @QueryParam("siteId") String siteId,
            @QueryParam("imageUrn") String imageUrn,
            @QueryParam("reason") String printReason)
    throws MethodException, ConnectionException
    {
       LogPrintImageAccessCommand command = new LogPrintImageAccessCommand(siteId, imageUrn, printReason, "1.0");
       return command.execute();
   	}

    
    @GET
   	@Path(ViewerImagingRestUri.viewerImagingGetTreatingFacilitiesMethodPath)
    @Produces(MediaType.APPLICATION_XML)
   	public Response getTreatingFacilities(
            @QueryParam("siteId") String siteId,
			@QueryParam("icn") String patientIcn,
			@QueryParam("dfn") String patientDfn)
    throws MethodException, ConnectionException
    {
    	return wrapResultWithResponseHeaders(new GetTreatingFacilitiesCommand(
    		   siteId, 
    		   patientIcn, 
    		   patientDfn,
    		   getInterfaceVersion()).execute());
   	}

	protected String getInterfaceVersion()
	{
		return "V1";
	}

	protected String getLocalSiteNumber()
	{
		return ViewerImagingContextHolder.getViewerImagingContext().getAppConfiguration().getLocalSiteNumber();
	}
}
