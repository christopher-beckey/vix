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
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.commands.studygraph.FederationStudyGraphStudyListCommand;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationStudyGraphRestUri;
import gov.va.med.imaging.federation.rest.types.FederationFilterType;
import gov.va.med.imaging.federation.rest.types.FederationStudyLoadLevelType;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/**
 * @author vhaiswwerfej
 *
 */
@Path(FederationRestUri.federationRestUriV4 + "/" + FederationStudyGraphRestUri.studyServicePath)
public class FederationRestStudyGraphServiceV4 
extends AbstractFederationRestService
{

	@POST
	@Path(FederationStudyGraphRestUri.studyListPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response getPatientStudyList(
			@PathParam("routingToken") String routingToken, 
			@PathParam("patientIcn") String patientIcn,
			@PathParam("authorizedSensitiveLevel") int authorizedSensitivityLevel,
			@PathParam("studyLoadLevel") FederationStudyLoadLevelType studyLoadLevelType,
			FederationFilterType federationFilterType)
	throws InsufficientPatientSensitivityException, MethodException, ConnectionException
	{
		FederationStudyGraphStudyListCommand command = 
			new FederationStudyGraphStudyListCommand(routingToken, patientIcn, 
					authorizedSensitivityLevel, studyLoadLevelType, federationFilterType, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@Override
	protected String getInterfaceVersion()
	{
		return "V4";
	}
}
