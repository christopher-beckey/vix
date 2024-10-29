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
package gov.va.med.imaging.federation.rest.v6;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.commands.patient.FederationPatientGetHealthSummariesCommand;
import gov.va.med.imaging.federation.commands.patient.FederationPatientGetHealthSummaryCommand;
import gov.va.med.imaging.federation.rest.endpoints.FederationPatientRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.federation.rest.v5.FederationRestPatientServiceV5;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

/**
 * @author vhaiswwerfej
 *
 */
@Path(FederationRestUri.federationRestUriV6 + "/" + FederationPatientRestUri.patientServicePath)
public class FederationRestPatientServiceV6 
extends FederationRestPatientServiceV5
{
	@Override
	protected String getInterfaceVersion()
	{
		return "V6";
	}
	
	@GET
	@Produces("application/xml")
	@Path(value=FederationPatientRestUri.healthSummariesPath)
	public Response getPatientSitesVisited(
			@PathParam("routingToken") String routingToken) 
	throws MethodException, ConnectionException
	{
		FederationPatientGetHealthSummariesCommand command = 
			new FederationPatientGetHealthSummariesCommand(routingToken, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@GET
	@Produces("application/xml")
	@Path(value=FederationPatientRestUri.patientHealthSummaryPath)
	public Response getPatientSitesVisited(
			@PathParam("healthSummaryId") String healthSummaryId,
			@PathParam("patientIcn") String patientIcn) 
	throws MethodException, ConnectionException
	{
		FederationPatientGetHealthSummaryCommand command = 
			new FederationPatientGetHealthSummaryCommand(healthSummaryId, patientIcn, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
}
