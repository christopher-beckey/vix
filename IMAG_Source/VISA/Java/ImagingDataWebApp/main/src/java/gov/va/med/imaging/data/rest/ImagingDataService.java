/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jan 10, 2014
 * Developer: Administrator
 */
package gov.va.med.imaging.data.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.data.ImagingDataContextHolder;
import gov.va.med.imaging.data.commands.GetImageDevFieldsCommand;
import gov.va.med.imaging.data.commands.GetImageSystemGlobalNodeCommand;
import gov.va.med.imaging.data.rest.endpoints.ImagingDataRestUri;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/**
 * @author Budy Tjahjo
 *
 */
@Path(ImagingDataRestUri.imageServicePath)
public class ImagingDataService
extends AbstractRestService
{
	@GET
	@Path(ImagingDataRestUri.imageGlobalNodesMethodPath) 
	@Produces(MediaType.APPLICATION_XML)
	public Response getImageSystemGlobalNode(
		@PathParam("imageUrn") String imageUrn)
	throws MethodException, ConnectionException
	{
		if ((imageUrn != null) && (imageUrn.contains("museimage"))) {
			return wrapResultWithResponseHeaders("<imageSystemGlobalNode>No metadata is available for MUSE images</imageSystemGlobalNode>");
		}

		String result = new GetImageSystemGlobalNodeCommand(
				getLocalSiteNumber(), 
				imageUrn, 
				getInterfaceVersion()).execute();

		return wrapResultWithResponseHeaders("<imageSystemGlobalNode>" + result + "</imageSystemGlobalNode>");
	}
	
	@GET
	@Path(ImagingDataRestUri.imageDevFieldsMethodPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getImageDevFields(
			@PathParam("imageUrn") String imageUrn,
			@QueryParam("flags") String flags)
	throws MethodException, ConnectionException
	{
		if ((imageUrn != null) && (imageUrn.contains("museimage"))) {
			return wrapResultWithResponseHeaders("<imageDevFields>No metadata is available for MUSE images</imageDevFields>");
		}

		String result = new GetImageDevFieldsCommand(
				imageUrn, 
				flags, 
				getInterfaceVersion()).execute();
		
		return wrapResultWithResponseHeaders("<imageDevFields>" + result + "</imageDevFields>");
	}

	
	protected String getInterfaceVersion()
	{
		return "V1";
	}

	protected String getLocalSiteNumber()
	{
		return ImagingDataContextHolder.getImagingDataContext().getAppConfiguration().getLocalSiteNumber();
	}
}
