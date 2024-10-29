/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 22, 2011
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

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.commands.user.FederationUserGetDivisionsCommand;
import gov.va.med.imaging.federation.commands.user.FederationUserGetUserInformationCommand;
import gov.va.med.imaging.federation.commands.user.FederationUserGetUserKeysCommand;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationUserRestUri;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/**
 * @author VHAISWWERFEJ
 *
 */
@Path(FederationRestUri.federationRestUriV5 + "/" + FederationUserRestUri.userServicePath)
public class FederationRestUserServiceV5
extends AbstractFederationRestService
{
	
	@Override
	protected String getInterfaceVersion()
	{
		return "V5";
	}
	
	@GET
	@Path(FederationUserRestUri.userKeysPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getUserKeys(
			@PathParam("routingToken") String routingToken)
	throws MethodException, ConnectionException
	{
		FederationUserGetUserKeysCommand command = 
			new FederationUserGetUserKeysCommand(routingToken, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@POST
	@Path(FederationUserRestUri.divisionListPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getDivisionList(
			@PathParam("routingToken") String routingToken,
			String accessCode) 
	throws MethodException, ConnectionException
	{
		FederationUserGetDivisionsCommand command = 
			new FederationUserGetDivisionsCommand(routingToken, accessCode, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@GET
	@Path(FederationUserRestUri.information)
	@Produces(MediaType.APPLICATION_XML)
	public Response getUserInformation(
			@PathParam("routingToken") String routingToken)
	throws MethodException, ConnectionException
	{
		FederationUserGetUserInformationCommand command = 
			new FederationUserGetUserInformationCommand(routingToken, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}

}
