/**
 * Date Created: Apr 25, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;
import gov.va.med.imaging.viewer.ViewerImagingContextHolder;
import gov.va.med.imaging.viewer.commands.DeleteImagesCommand;
import gov.va.med.imaging.viewer.commands.FlagImagesAsSensitiveCommand;
import gov.va.med.imaging.viewer.commands.GetCaptureUsersCommand;
import gov.va.med.imaging.viewer.commands.GetImagePropertiesCommand;
import gov.va.med.imaging.viewer.commands.GetQAReviewReportDataCommand;
import gov.va.med.imaging.viewer.commands.GetQAReviewReportsCommand;
import gov.va.med.imaging.viewer.commands.SetImagePropertiesCommand;
import gov.va.med.imaging.viewer.rest.endpoints.ViewerImagingRestUri;
import gov.va.med.imaging.viewer.rest.types.CaptureUserResultType;
import gov.va.med.imaging.viewer.rest.types.CaptureUserResultsType;
import gov.va.med.imaging.viewer.rest.types.DeleteImageUrnsType;
import gov.va.med.imaging.viewer.rest.types.ImagePropertiesType;
import gov.va.med.imaging.viewer.rest.types.QAReviewReportResultsType;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

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
@Path(ViewerImagingRestUri.viewerImagingQAServicePath)
public class ViewerImagingQAService
extends AbstractRestService
{
    @GET
   	@Path(ViewerImagingRestUri.viewerImagingGetQAReviewReports)
    @Produces(MediaType.APPLICATION_XML)
   	public Response getQAReviewReports(
            @QueryParam("userId") String userId)
    throws MethodException, ConnectionException
    {
    	if (userId == null)
    		userId = "";
    	
    	GetQAReviewReportsCommand cmd =  new GetQAReviewReportsCommand(userId, getInterfaceVersion());
    	QAReviewReportResultsType result = cmd.execute();
    	if (result == null)
    	{
    		return Response.status(Status.NOT_FOUND).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
    				TransactionContextFactory.get().getMachineName()).entity("VistA Remote Procedure Error").build();
    	}
    	else
    	{
    		return wrapResultWithResponseHeaders(result);
    	}
   	}

    @GET
   	@Path(ViewerImagingRestUri.viewerImagingGetQAReviewReportData)
    @Produces(MediaType.APPLICATION_XML)
   	public Response getQAReviewReportData(
            @QueryParam("flags") String flags,
            @QueryParam("fromDate") String fromDate,
            @QueryParam("throughDate") String throughDate,
            @QueryParam("mque") String mque
   			)
    throws MethodException, ConnectionException
    {
    	int vistaFromDate = Integer.parseInt(fromDate) - 17000000;
    	int vistaThroughDate = Integer.parseInt(throughDate) - 17000000;
    	
    	GetQAReviewReportDataCommand cmd =  new GetQAReviewReportDataCommand(flags, Integer.toString(vistaFromDate), Integer.toString(vistaThroughDate), mque, getInterfaceVersion());
    	RestStringType result = cmd.execute();
    	if (result == null)
    	{
    		return Response.status(Status.INTERNAL_SERVER_ERROR).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
    				TransactionContextFactory.get().getMachineName()).entity("Unexpected internal error").build();
    	}
    	else if (result.getValue().startsWith("0"))
    	{
    		return Response.status(Status.NOT_ACCEPTABLE).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
    				TransactionContextFactory.get().getMachineName()).entity("result").build();
    		
    	}
    	else
    	{
    		return wrapResultWithResponseHeaders(result);
    	}
   	}

    @GET
   	@Path(ViewerImagingRestUri.viewerImagingGetCaptureUsersMethodPath)
    @Produces(MediaType.APPLICATION_XML)
   	public Response getCaptureUsers(
            @QueryParam("appFlag") String appFlag,
			@QueryParam("fromDate") String fromDate,
			@QueryParam("throughDate") String throughDate)
    throws MethodException, ConnectionException
    {
    	String err = validateCaptureUsersParams(appFlag, fromDate, throughDate);
    	
    	if (err != null)
    	{
    		return Response.status(Status.BAD_REQUEST).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
    				TransactionContextFactory.get().getMachineName()).entity(err).build();
    	}
    	
    	int vistaFromDate = Integer.parseInt(fromDate) - 17000000;
    	int vistaThroughDate = Integer.parseInt(throughDate) - 17000000;
    	
    	GetCaptureUsersCommand cmd =  new GetCaptureUsersCommand(appFlag, Integer.toString(vistaFromDate), Integer.toString(vistaThroughDate), getInterfaceVersion());
    	CaptureUserResultsType result = cmd.execute();
    	if (result == null)
    	{
    		return Response.status(Status.NOT_FOUND).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
    				TransactionContextFactory.get().getMachineName()).entity(result).build();
    	}
    	
    	CaptureUserResultType[] lst = result.getCaptureUsers();
    	
    	if (lst.length == 0)
    	{
    		return Response.status(Status.NOT_FOUND).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
    				TransactionContextFactory.get().getMachineName()).entity(result).build();
    	}
    	else
    	{
    		CaptureUserResultType resMsg = lst[0];
    		if (resMsg.getUserId().equals("0"))
    		{
        		return Response.status(Status.BAD_REQUEST).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
        				TransactionContextFactory.get().getMachineName()).entity(resMsg.getUserName()).build();
    		}
    		else
    		{
    	    	return wrapResultWithResponseHeaders(result);
    			
    		}
    	}
   	}
    
	private String validateCaptureUsersParams(String appFlag, String fromDate, String throughDate) 
	{
		if ((appFlag == null) || appFlag.isEmpty())
		{
			return "Application Flag is required";
		}
		
		if (!(appFlag.equals("C") || appFlag.equals("I")))
		{
			return "Application Flag must be 'C' for Capture Workstation or 'I' for Imprt API";
		}
		
		if ((fromDate == null) || fromDate.isEmpty())
		{
			return "From Date is required";
		}
		
		if ((throughDate == null) || throughDate.isEmpty())
		{
			return "Through Date is required";
		}
		
		Date from = null;
		Date tru = null;
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		try 
		{
			from = formatter.parse(fromDate);
		}
		catch (ParseException e) 
		{
			return "From Date must be in yyyyMMdd format [20181231]. Error: " + e.getMessage();
		}
	
		try 
		{
			tru = formatter.parse(throughDate);
		}
		catch (ParseException e) 
		{
			return "Through Date must be in yyyyMMdd format [20181231]. Error: " + e.getMessage();
		}
				
		if (tru.before(from))
		{
			return "Through Date must be after From Date";
		}
		 
		return null;
	}

	@POST
	@Path(ViewerImagingRestUri.viewerImagingSetImagePropertiesMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response setImageProperties(ImagePropertiesType imageProps)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new SetImagePropertiesCommand(
						imageProps, 
						getInterfaceVersion()).execute());
	}

    @GET
   	@Path(ViewerImagingRestUri.viewerImagingGetImagePropertiesMethodPath)
    @Produces(MediaType.APPLICATION_XML)
   	public Response getImageProperties(
			@QueryParam("imageIEN") String imageIEN,
            @QueryParam("props") String props,
            @QueryParam("flags") String flags
   			)
    throws MethodException, ConnectionException
    {
    	GetImagePropertiesCommand cmd =  new GetImagePropertiesCommand(imageIEN, props, flags, getInterfaceVersion());
    	ImagePropertiesType result = cmd.execute();
    	if (result == null)
    	{
    		return Response.status(Status.INTERNAL_SERVER_ERROR).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
    				TransactionContextFactory.get().getMachineName()).entity("Unexpected internal error").build();
    	}
    	else if (result.getImageProperties()[0].getName().startsWith("ERROR"))
    	{
    		return Response.status(Status.BAD_REQUEST).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
    				TransactionContextFactory.get().getMachineName()).entity(result.getImageProperties()[0].getValue()).build();
    	}
    	else
    	{
    		return wrapResultWithResponseHeaders(result);
    	}
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
