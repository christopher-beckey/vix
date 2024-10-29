/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 24, 2010
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
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.federation.commands.vistarad.FederationVistaRadGetActiveWorklistCommand;
import gov.va.med.imaging.federation.commands.vistarad.FederationVistaRadGetExamCommand;
import gov.va.med.imaging.federation.commands.vistarad.FederationVistaRadGetExamImagesCommand;
import gov.va.med.imaging.federation.commands.vistarad.FederationVistaRadGetExamReportCommand;
import gov.va.med.imaging.federation.commands.vistarad.FederationVistaRadGetExamRequisitionReportCommand;
import gov.va.med.imaging.federation.commands.vistarad.FederationVistaRadGetExamsCommand;
import gov.va.med.imaging.federation.commands.vistarad.FederationVistaRadGetNextPatientRegistrationCommand;
import gov.va.med.imaging.federation.commands.vistarad.FederationVistaRadGetRelevantPriorCptCodesCommand;
import gov.va.med.imaging.federation.commands.vistarad.FederationVistaRadPostImageAccessCommand;
import gov.va.med.imaging.federation.rest.AbstractFederationRestService;
import gov.va.med.imaging.federation.rest.endpoints.FederationRestUri;
import gov.va.med.imaging.federation.rest.endpoints.FederationVistaRadRestUri;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
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
@Path(FederationRestUri.federationRestUriV4 + "/" + FederationVistaRadRestUri.vistaradServicePath)
public class FederationRestVistaRadServiceV4 
extends AbstractFederationRestService 
{
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path(FederationVistaRadRestUri.vistaradGetNextPatientRegistration)
	public Response getNextPatientRegistration(
		@PathParam("routingToken") String routingToken)
	throws MethodException, ConnectionException
	{
		FederationVistaRadGetNextPatientRegistrationCommand command = 
			new FederationVistaRadGetNextPatientRegistrationCommand(routingToken, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());		
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path(FederationVistaRadRestUri.vistaradGetExamImages)
	public Response getExamImagesForExam(
			@PathParam("examId") String examId) 
	throws MethodException, ConnectionException
	{
		FederationVistaRadGetExamImagesCommand command = 
			new FederationVistaRadGetExamImagesCommand(examId, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());	
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path(FederationVistaRadRestUri.vistaradCptCodes)
	public Response getRelevantPriorCptCodes(
			@PathParam("routingToken") String routingToken, 
			@PathParam("cptCode") String cptCode)
	throws MethodException, ConnectionException
	{
		FederationVistaRadGetRelevantPriorCptCodesCommand command = 
			new FederationVistaRadGetRelevantPriorCptCodesCommand(routingToken, cptCode, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());		
	}
	
	@POST
	@Path(FederationVistaRadRestUri.vistaradPostImageAccess)
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response postVistaRadExamAccessEvent(
			@PathParam("routingToken") String routingToken, 
			String inputParameter) 
	throws MethodException, ConnectionException
	{
		FederationVistaRadPostImageAccessCommand command = 
			new FederationVistaRadPostImageAccessCommand(routingToken, inputParameter, getInterfaceVersion());		
		return wrapResultWithResponseHeaders(command.execute());	
	}
	
	@GET
	@Path(FederationVistaRadRestUri.vistaradGetExamsPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getPatientExams(
			@PathParam("routingToken") String routingToken,
			@PathParam("patientIcn") String patientIcn,
			@PathParam("fullyLoaded") boolean fullyLoaded,
			@PathParam("forceRefresh") boolean forceRefresh,
			@PathParam("forceImagesFromJb") boolean forceImagesFromJb)
	throws MethodException, ConnectionException 
	{		
		FederationVistaRadGetExamsCommand method = 
			new FederationVistaRadGetExamsCommand(routingToken, patientIcn, fullyLoaded, 
					forceRefresh, forceImagesFromJb, getInterfaceVersion());
		return wrapResultWithResponseHeaders(method.execute());
	}

	@GET
	@Path(FederationVistaRadRestUri.vistaradGetExamPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getPatientExam(
			@PathParam("examId") String examId) 
	throws ConnectionException, MethodException
	{
		FederationVistaRadGetExamCommand command =
			new FederationVistaRadGetExamCommand(examId, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());	
	}
	
	@GET
	@Path(FederationVistaRadRestUri.vistaradGetActiveExamsPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getActiveWorklist(
			@PathParam("routingToken") String routingToken,
			@PathParam("listDescriptor") String listDescriptor)
	throws MethodException, ConnectionException 
	{
		FederationVistaRadGetActiveWorklistCommand command = 
			new FederationVistaRadGetActiveWorklistCommand(routingToken, listDescriptor, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	@GET
	@Path(FederationVistaRadRestUri.vistaradGetExamReportPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getVistaRadRadiologyReport(
			@PathParam("examId") String examId) 
	throws MethodException, ConnectionException
	{
		FederationVistaRadGetExamReportCommand command = 
			new FederationVistaRadGetExamReportCommand(examId, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());	
	}
	
	@GET
	@Path(FederationVistaRadRestUri.vistaradGetExamRequisitionReportPath)
	@Produces(MediaType.APPLICATION_XML)
	public Response getVistaRadRequisitionReport(
			@PathParam("examId") String examId) 
	throws MethodException, ConnectionException
	{
		FederationVistaRadGetExamRequisitionReportCommand command = 
			new FederationVistaRadGetExamRequisitionReportCommand(examId, getInterfaceVersion());
		return wrapResultWithResponseHeaders(command.execute());
	}
	
	protected void setVistaRadImagingContext()
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setImagingSecurityContextType(ImagingSecurityContextType.MAGJ_VISTARAD.toString());
	}
	
	@Override
	protected String getInterfaceVersion()
	{
		return "V4";
	}
}
