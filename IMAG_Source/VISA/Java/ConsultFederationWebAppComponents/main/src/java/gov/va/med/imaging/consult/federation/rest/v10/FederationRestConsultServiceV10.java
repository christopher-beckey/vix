package gov.va.med.imaging.consult.federation.rest.v10;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.imaging.consult.federation.commands.FederationConsultGetPatientConsultsCommand;
import gov.va.med.imaging.consult.federation.endpoints.FederationConsultRestUri;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;

@Path(FederationRestUri.federationRestUriV10 + "/" + FederationConsultRestUri.consultServicePath)
public class FederationRestConsultServiceV10 
extends AbstractFederationRestService 
{

	@GET
	@Path(FederationConsultRestUri.getConsultsPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getPatientConsults(
			@PathParam("routingToken") String routingTokenString, 
			@PathParam("patientIcn") String patientIcn)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(new FederationConsultGetPatientConsultsCommand(
				routingTokenString, patientIcn, getInterfaceVersion()).execute());
	}


	@Override
	protected String getInterfaceVersion() {
		return "V10";
	}


}
