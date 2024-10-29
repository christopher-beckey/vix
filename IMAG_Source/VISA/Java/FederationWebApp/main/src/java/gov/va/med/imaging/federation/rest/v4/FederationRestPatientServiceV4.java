/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 15, 2010
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

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.PatientNotFoundException;
import gov.va.med.imaging.federation.commands.patient.FederationPatientGetSensitivityCommand;
import gov.va.med.imaging.federation.commands.patient.FederationPatientGetSitesVisitedCommand;
import gov.va.med.imaging.federation.commands.patient.FederationPatientLogSensitiveAccessCommand;
import gov.va.med.imaging.federation.commands.patient.FederationPatientSearchCommand;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationPatientRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

/**
 * @author vhaiswwerfej
 *
 */
@Path(FederationRestUri.federationRestUriV4 + "/" + FederationPatientRestUri.patientServicePath)
public class FederationRestPatientServiceV4 
extends AbstractFederationRestService
{
	
	@GET
	@Path(value=FederationPatientRestUri.patientSensitivePath)
	@Produces("application/xml")
	public Response getPatientSensitivityLevel(
			@PathParam("routingToken") String routingToken, 
			@PathParam("patientIcn") String patientIcn)
	throws ConnectionException, MethodException
	{
		FederationPatientGetSensitivityCommand command = 
			new FederationPatientGetSensitivityCommand(routingToken, patientIcn, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());	
	}
	
	@POST
	@Path(value=FederationPatientRestUri.patientSearchPath)
	@Produces("application/xml")
	@Consumes("application/xml")
	public Response findPatients( 
			@PathParam("routingToken") String routingToken,
			String searchName)
	throws MethodException, ConnectionException
	{
		FederationPatientSearchCommand command = 
			new FederationPatientSearchCommand(routingToken, searchName, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());	
	}
	
	@GET
	@Produces("application/xml")
	@Path(value=FederationPatientRestUri.patientVisitedPath)
	public Response getPatientSitesVisited(
			@PathParam("routingToken") String routingToken, 
			@PathParam("patientIcn") String patientIcn)	
	throws PatientNotFoundException, MethodException, ConnectionException
	{
		FederationPatientGetSitesVisitedCommand command = 
			new FederationPatientGetSitesVisitedCommand(routingToken, patientIcn, 
					getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@GET
	@Produces("application/xml")
	@Path(value=FederationPatientRestUri.patientLogSensitiveAccessPath)
	public Response logPatientSensitiveAccess(
			@PathParam("routingToken") String routingToken, 
			@PathParam("patientIcn") String patientIcn)	
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(new FederationPatientLogSensitiveAccessCommand(routingToken, 
				patientIcn, getInterfaceVersion()).execute());
	}
	
	@Override
	protected String getInterfaceVersion()
	{
		return "V4";
	}
}
