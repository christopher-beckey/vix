/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 27, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.federation.rest.v4;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.commands.image.FederationImageGetImageDevFieldsCommand;
import gov.va.med.imaging.federation.commands.image.FederationImageGetImageInformationCommand;
import gov.va.med.imaging.federation.commands.image.FederationImageGetImageSystemGlobalNodeCommand;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationImageRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;

/**
 * @author vhaiswwerfej
 *
 */
@Path(FederationRestUri.federationRestUriV4 + "/" + FederationImageRestUri.imageServicePath)
public class FederationRestImageServiceV4 
extends AbstractFederationRestService
{
	@GET
	@Path(FederationImageRestUri.imageInformationMethodPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getImageInformation(
			@PathParam("imageUrn") String imageUrn,
			@PathParam("includeDeletedImages") boolean includeDeletedImages)
	throws MethodException, ConnectionException
	{
		FederationImageGetImageInformationCommand command = 
			new FederationImageGetImageInformationCommand(imageUrn, getInterfaceVersion(), 
					includeDeletedImages);
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@GET
	@Path(FederationImageRestUri.imageGlobalNodesMethodPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getImageSystemGlobalNode(
			@PathParam("imageUrn") String imageUrn)
	throws MethodException, ConnectionException
	{
		FederationImageGetImageSystemGlobalNodeCommand command = 
			new FederationImageGetImageSystemGlobalNodeCommand(imageUrn, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@GET
	@Path(FederationImageRestUri.imageDevFieldsMethodPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getImageDevFields(
			@PathParam("imageUrn") String imageUrn,
			@QueryParam("flags") String flags)
	throws MethodException, ConnectionException
	{
		FederationImageGetImageDevFieldsCommand command = 
			new FederationImageGetImageDevFieldsCommand(imageUrn, flags, 
					getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@Override
	protected String getInterfaceVersion()
	{
		return "V4";
	}

}
