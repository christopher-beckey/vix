/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 1, 2010
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

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.commands.externalpackage.FederationExternalPackageGetStudiesWithAllObjectsFromCprsIdentifierCommand;
import gov.va.med.imaging.federation.commands.externalpackage.FederationExternalPackageGetStudyFromCprsCommand;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationExternalPackageRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.federation.rest.types.FederationCprsIdentifierType;

/**
 * @author vhaiswwerfej
 *
 */
@Path(FederationRestUri.federationRestUriV4 + "/" + FederationExternalPackageRestUri.externalPackageServicePath)
public class FederationRestExternalPackageServiceV4 
extends AbstractFederationRestService
{

	@POST
	@Path(FederationExternalPackageRestUri.getStudyFromCprsMethodPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getStudyFromCprsIdentifier(
			@PathParam("routingToken") String routingToken, 
			@PathParam("patientIcn") String patientIcn,
			@QueryParam("bothdb") String bothdb,
			FederationCprsIdentifierType cprsIdentifier)
	throws MethodException, ConnectionException
	{
//		FederationExternalPackageGetStudyFromCprsCommand command = 
//			new FederationExternalPackageGetStudyFromCprsCommand(routingToken, patientIcn, 
//					cprsIdentifier, getInterfaceVersion());
		if (bothdb == null)
		{
			bothdb = "";
		}
		
		logger.debug("executing PostStudiesFromCprsIdentifiers web service in FederationRestExternalPackageServiceV6.");

		FederationExternalPackageGetStudiesWithAllObjectsFromCprsIdentifierCommand command = 
				new FederationExternalPackageGetStudiesWithAllObjectsFromCprsIdentifierCommand(
						routingToken, patientIcn, 
						cprsIdentifier,
						bothdb,
						getInterfaceVersion());
		
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@Override
	protected String getInterfaceVersion()
	{
		return "V4";
	}
}
