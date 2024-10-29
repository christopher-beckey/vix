/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 8, 2018
  Developer:  vhaisltjahjb
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
package gov.va.med.imaging.federation.rest.v9;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.commands.externalpackage.FederationExternalPackageDeleteWorkItemCommand;
import gov.va.med.imaging.federation.commands.externalpackage.FederationExternalPackageGetWorkListCommand;
import gov.va.med.imaging.federation.rest.endpoints.FederationExternalPackageRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationWorkListRestUri;
import gov.va.med.imaging.federation.rest.v8.FederationRestExternalPackageServiceV8;


/**
 * @author vhaisltjahjb
 *
 */
@Path(FederationRestUri.federationRestUriV9 + "/" + FederationExternalPackageRestUri.externalPackageServicePath)
public class FederationRestExternalPackageServiceV9 
extends FederationRestExternalPackageServiceV8
{	
	@GET
	@Path(FederationWorkListRestUri.getRemoteWorkListMethodPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getWorkList(
			@PathParam("routingToken") String routingToken, 
			@QueryParam("idType") String idType,
			@QueryParam("patientId") String patientId,
			@QueryParam("cptCode") String cptCode
			)
	throws MethodException, ConnectionException
	{
        logger.debug("Federation getWorkList. routingToken={} idType={} patientId={} cptCode={}", routingToken, idType, patientId, cptCode);
		FederationExternalPackageGetWorkListCommand command = 
				new FederationExternalPackageGetWorkListCommand(
						routingToken, 
						idType,
						patientId, 
						cptCode,
						getInterfaceVersion());
		
		return wrapResultWithResponseHeaders(command.execute());
	}

	@DELETE
	@Path(FederationWorkListRestUri.deleteWorkItemMethodPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response deleteWorkItem(
			@PathParam("routingToken") String routingToken, 
			@PathParam("id") String id
			)
	throws MethodException, ConnectionException
	{
		
		FederationExternalPackageDeleteWorkItemCommand command = 
				new FederationExternalPackageDeleteWorkItemCommand(
						routingToken, id,
						getInterfaceVersion());
		
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	protected String getInterfaceVersion()
	{
		return "V9";
	}

}

