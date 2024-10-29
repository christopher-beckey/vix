/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 16, 2010
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
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.commands.externalsystemoperation.FederationExternalSystemOperationPrefetchExamCommand;
import gov.va.med.imaging.federation.commands.externalsystemoperation.FederationExternalSystemOperationPrefetchExamImageCommand;
import gov.va.med.imaging.federation.commands.externalsystemoperation.FederationExternalSystemOperationPrefetchGaiCommand;
import gov.va.med.imaging.federation.commands.externalsystemoperation.FederationExternalSystemOperationPrefetchImageCommand;
import gov.va.med.imaging.federation.commands.externalsystemoperation.FederationExternalSystemOperationPrefetchStudiesCommand;
import gov.va.med.imaging.federation.commands.externalsystemoperation.FederationExternalSystemOperationRefreshSiteServiceCacheCommand;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationExternalSystemOperationsRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.federation.rest.types.FederationFilterType;
import gov.va.med.imaging.federation.rest.types.FederationImageFormatQualitiesType;
import gov.va.med.imaging.federation.rest.types.FederationStudyLoadLevelType;

/**
 * @author vhaiswwerfej
 *
 */
@Path(FederationRestUri.federationRestUriV4 + "/" + FederationExternalSystemOperationsRestUri.externalSystemOperationsServicePath)
public class FederationRestExternalSystemOperationServiceV4
extends AbstractFederationRestService
{

	@Override
	protected String getInterfaceVersion()
	{
		return "V4";
	}
	
	@GET
	@Path(FederationExternalSystemOperationsRestUri.prefetchExam)
	@Produces(MediaType.APPLICATION_XML)
	public Response initiateExamPrefetch(
			@PathParam("examId") String examId)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(new FederationExternalSystemOperationPrefetchExamCommand(examId, 
				getInterfaceVersion()).execute());
	}
	
	@GET
	@Path(FederationExternalSystemOperationsRestUri.refreshSiteServiceCache)
	@Produces(MediaType.APPLICATION_XML)
	public Response refreshSiteServiceCache()
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(
				new FederationExternalSystemOperationRefreshSiteServiceCacheCommand(getInterfaceVersion()).execute());
	}
	
	@POST
	@Path(FederationExternalSystemOperationsRestUri.prefetchStudiesPath)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response prefetchPatientStudies(
			@PathParam("routingToken") String routingToken, 
			@PathParam("patientIcn") String patientIcn,
			@PathParam("authorizedSensitiveLevel") int authorizedSensitivityLevel,
			@PathParam("studyLoadLevel") FederationStudyLoadLevelType studyLoadLevelType,
			FederationFilterType federationFilterType)
	throws MethodException, ConnectionException
	{
		FederationExternalSystemOperationPrefetchStudiesCommand command = 
			new FederationExternalSystemOperationPrefetchStudiesCommand(routingToken, patientIcn, 
					authorizedSensitivityLevel, studyLoadLevelType, federationFilterType, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@POST
	@Path(FederationExternalSystemOperationsRestUri.prefetchImage)
	@Produces(MediaType.APPLICATION_XML)
	public Response prefetchImage(
			@PathParam("imageUrn") String imageUrn, 
			FederationImageFormatQualitiesType imageFormatQualitiesType)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(new FederationExternalSystemOperationPrefetchImageCommand(imageUrn, 
				imageFormatQualitiesType, getInterfaceVersion()).execute());
	}
	
	@POST
	@Path(FederationExternalSystemOperationsRestUri.prefetchExamImage)
	@Produces(MediaType.APPLICATION_XML)
	public Response prefetchExamImage(
			@PathParam("imageUrn") String imageUrn, 
			@PathParam("includeTextFile") boolean includeTextFile,
			FederationImageFormatQualitiesType imageFormatQualitiesType)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(new FederationExternalSystemOperationPrefetchExamImageCommand(imageUrn, 
				imageFormatQualitiesType, includeTextFile,
				getInterfaceVersion()).execute());
	}
	
	@GET
	@Path(FederationExternalSystemOperationsRestUri.prefetchGai)
	@Produces(MediaType.APPLICATION_XML)
	public Response prefetchGai(
			@PathParam("gai") String gai)
	throws MethodException, ConnectionException
	{
		return wrapResultWithResponseHeaders(new FederationExternalSystemOperationPrefetchGaiCommand(gai,
				getInterfaceVersion()).execute());
	}

}
