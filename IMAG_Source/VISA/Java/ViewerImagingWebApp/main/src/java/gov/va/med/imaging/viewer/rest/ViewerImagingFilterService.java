/**
 * Date Created: Apr 23, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.ViewerImagingContextHolder;
import gov.va.med.imaging.viewer.commands.DeleteImageFilterCommand;
import gov.va.med.imaging.viewer.commands.GetImageFilterDetailCommand;
import gov.va.med.imaging.viewer.commands.GetImageFiltersCommand;
import gov.va.med.imaging.viewer.commands.SaveImageFilterCommand;
import gov.va.med.imaging.viewer.rest.endpoints.ViewerImagingRestUri;
import gov.va.med.imaging.viewer.rest.types.ImageFilterFieldValuesType;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/**
 * @author vhaisltjahjb
 *
 */
@Path(ViewerImagingRestUri.viewerImagingFilterServicePath)
public class ViewerImagingFilterService
extends AbstractRestService
{
    @GET
   	@Path(ViewerImagingRestUri.viewerImagingGetImageFiltersMethodPath)
    @Produces(MediaType.APPLICATION_XML)
   	public Response getImageFilters(
            @QueryParam("userId") String userId)
    throws MethodException, ConnectionException
    {
    	return wrapResultWithResponseHeaders(
				new GetImageFiltersCommand(
						getLocalSiteNumber(), 
						userId, 
						getInterfaceVersion()).execute());
   	}
	
	
	@GET
	@Path(ViewerImagingRestUri.viewerImagingGetImageFilterDetailMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response getImageFilterDetail(
            @QueryParam("filterIen") String filterIen,
            @QueryParam("filterName") String filterName,
            @QueryParam("userId") String userId
    )
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new GetImageFilterDetailCommand(
						getLocalSiteNumber(), 
						filterIen, filterName, userId, 
						getInterfaceVersion()).execute());
	}

	@GET
	@Path(ViewerImagingRestUri.viewerImagingDeleteImageFilterMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response deleteImageFilter(
            @QueryParam("filterIen") String filterIen
    )
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new DeleteImageFilterCommand(
						getLocalSiteNumber(), 
						filterIen, 
						getInterfaceVersion()).execute());
	}

	@POST
	@Path(ViewerImagingRestUri.viewerImagingSaveImageFilterMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response saveImageFilter(ImageFilterFieldValuesType imageFilterFieldValues)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new SaveImageFilterCommand(
						getLocalSiteNumber(), 
						imageFilterFieldValues,
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
