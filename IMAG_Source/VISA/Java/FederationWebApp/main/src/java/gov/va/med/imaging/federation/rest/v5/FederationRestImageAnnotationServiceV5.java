/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 20, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.federation.rest.v5;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.commands.imageannotations.FederationImageAnnotationGetImageAnnotationDetailsCommand;
import gov.va.med.imaging.federation.commands.imageannotations.FederationImageAnnotationGetImageAnnotationsCommand;
import gov.va.med.imaging.federation.commands.imageannotations.FederationImageAnnotationPostImageAnnotationCommand;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationImageAnnotationRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.federation.rest.types.FederationImageAnnotationSourceType;

/**
 * @author VHAISWWERFEJ
 *
 */
@Path(FederationRestUri.federationRestUriV5 + "/" + FederationImageAnnotationRestUri.imageAnnotationServicePath)
public class FederationRestImageAnnotationServiceV5
extends AbstractFederationRestService
{

	@Override
	protected String getInterfaceVersion()
	{
		return "V5";
	}
	
	@GET
	@Path(FederationImageAnnotationRestUri.imageAnnotationsPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getImageAnnotations(
			@PathParam("imagingUrn") String imagingUrn)
	throws MethodException, ConnectionException
	{
		FederationImageAnnotationGetImageAnnotationsCommand command =
			new FederationImageAnnotationGetImageAnnotationsCommand(imagingUrn, getInterfaceVersion());		
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@GET
	@Path(FederationImageAnnotationRestUri.imageAnnotationDetailsPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getAnnotationDetails(
			@PathParam("imagingUrn") String imagingUrn,
			@PathParam("imageAnnotationUrn") String imageAnnotationUrn)
	throws MethodException, ConnectionException
	{
		FederationImageAnnotationGetImageAnnotationDetailsCommand command = 
			new FederationImageAnnotationGetImageAnnotationDetailsCommand(imagingUrn,
					imageAnnotationUrn, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@POST
	@Path(FederationImageAnnotationRestUri.storeImageAnnotationPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response storeImageAnnotationDetails(
			@PathParam("imagingUrn") String imagingUrn,
			@PathParam("version") String version,
			@PathParam("source") FederationImageAnnotationSourceType source,
			String annotationDetails)
	throws MethodException, ConnectionException
	{
		FederationImageAnnotationPostImageAnnotationCommand command = 
			new FederationImageAnnotationPostImageAnnotationCommand(imagingUrn, annotationDetails, version, 
					source, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
}
