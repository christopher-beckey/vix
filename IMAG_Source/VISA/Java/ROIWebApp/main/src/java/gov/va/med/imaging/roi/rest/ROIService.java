/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 22, 2012
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
package gov.va.med.imaging.roi.rest;

import gov.va.med.PatientIdentifier;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.roi.commands.ROICancelWorkItemCommand;
import gov.va.med.imaging.roi.commands.ROIChangeWorkItemStatusCommand;
import gov.va.med.imaging.roi.commands.ROIDeleteUserWorkItemsCommand;
import gov.va.med.imaging.roi.commands.ROIGetActiveWorkItemsCommand;
import gov.va.med.imaging.roi.commands.ROIGetUserWorkItemsCommand;
import gov.va.med.imaging.roi.commands.ROIProcessActiveRequestsCommand;
import gov.va.med.imaging.roi.commands.ROIProcessWorkItemCommand;
import gov.va.med.imaging.roi.commands.ROIResetOldUnfinishedRequestsCommand;
import gov.va.med.imaging.roi.commands.ROIQueueStudiesCommand;
import gov.va.med.imaging.roi.commands.RoiStatusCommand;
import gov.va.med.imaging.roi.rest.types.ROIRequestType;

import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.Consumes;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

/**
 * @author VHAISWWERFEJ
 *
 */
@Path("roi")
public class ROIService
{
	/**
	 * 
	 * @param studyIds caret delimited string of study URNs
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("queue/{study-ids}/{queue-id}")
	public ROIRequestType queue(
			@PathParam("study-ids") String studyIds,
			@PathParam("queue-id") String queueId)
	throws MethodException, ConnectionException
	{
		return new ROIQueueStudiesCommand(studyIds, queueId).execute();
	}
	
	/**
	 * 
	 * @param studyIds caret delimited string of study URNs
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("queue/{study-ids}")
	public ROIRequestType queue(
			@PathParam("study-ids") String studyIds)
	throws MethodException, ConnectionException
	{
		return new ROIQueueStudiesCommand(studyIds).execute();
	}
	
	/**
	 * 
	 * @param patientId Patient ICN
	 * @param siteId Site Number
	 * @param studyIens caret delimited string of study IENs (not study URNs)
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("queue/{patient-id}/{site-id}/{study-iens}")
	public ROIRequestType queue(
			@PathParam("patient-id") String patientId,
			@PathParam("site-id") String siteId,
			@PathParam("study-iens") String studyIens)
	throws MethodException, ConnectionException
	{
		try {
		return new ROIQueueStudiesCommand(PatientIdentifier.fromString(patientId), siteId, studyIens).execute();
		} catch (PatientIdentifierParseException e) {
			throw new MethodException("Patient Identifier Parse Exception.");
	}
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("queue/{patient-id}/{site-id}/{study-iens}/{queue-id}")
	public ROIRequestType queue(
			@PathParam("patient-id") String patientId,
			@PathParam("site-id") String siteId,
			@PathParam("study-iens") String studyIens,
			@PathParam("queue-id") String queueId)
	throws MethodException, ConnectionException
	{
		try {
		return new ROIQueueStudiesCommand(PatientIdentifier.fromString(patientId), siteId, studyIens, queueId).execute();
		} catch (PatientIdentifierParseException e) {
			throw new MethodException("Patient Identifier Parse Exception.");
		}
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("queue/dfn/{patient-dfn}/{site-id}/{study-iens}/{queue-id}")
	public ROIRequestType queueByPatientDfn(
			@PathParam("patient-dfn") String patientDfn,
			@PathParam("site-id") String siteId,
			@PathParam("study-iens") String studyIens,
			@PathParam("queue-id") String queueId)
	throws MethodException, ConnectionException
	{
		return new ROIQueueStudiesCommand(PatientIdentifier.dfnPatientIdentifier(patientDfn, siteId), 
				siteId, studyIens, queueId).execute();
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("queue/icn/{patient-icn}/{site-id}/{study-iens}/{queue-id}")
	public ROIRequestType queueByPatientIcn(
			@PathParam("patient-icn") String patientIcn,
			@PathParam("site-id") String siteId,
			@PathParam("study-iens") String studyIens,
			@PathParam("queue-id") String queueId)
	throws MethodException, ConnectionException
	{
		return new ROIQueueStudiesCommand(PatientIdentifier.icnPatientIdentifier(patientIcn), 
				siteId, studyIens, queueId).execute();
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("queue/dfn/{patient-dfn}/{site-id}/{study-iens}")
	public ROIRequestType queueByPatientDfn(
			@PathParam("patient-dfn") String patientDfn,
			@PathParam("site-id") String siteId,
			@PathParam("study-iens") String studyIens)
	throws MethodException, ConnectionException
	{
		return new ROIQueueStudiesCommand(PatientIdentifier.dfnPatientIdentifier(patientDfn, siteId), 
				siteId, studyIens).execute();
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("queue/icn/{patient-icn}/{site-id}/{study-iens}")
	public ROIRequestType queueByPatientIcn(
			@PathParam("patient-icn") String patientIcn,
			@PathParam("site-id") String siteId,
			@PathParam("study-iens") String studyIens)
	throws MethodException, ConnectionException
	{
		return new ROIQueueStudiesCommand(PatientIdentifier.icnPatientIdentifier(patientIcn), 
				siteId, studyIens).execute();
	}

	@POST
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	@Path("queue/{patient-id}/{site-id}/{study-iens}/{queue-id}/{incl-nd}/{incl-rpt}")
	public ROIRequestType queueCommunityCare(
			@PathParam("patient-id") String patientId,
			@PathParam("site-id") String siteId,
			@PathParam("study-iens") String studyIens,
			@PathParam("queue-id") String queueId,
			@PathParam("incl-nd") String includeNonDicom,
			@PathParam("incl-rpt") String includeReport,
			String ccpHeaders)
	throws MethodException, ConnectionException
	{
		try {
		return new ROIQueueStudiesCommand(PatientIdentifier.fromString(patientId), 
				siteId, studyIens, queueId, ccpHeaders, includeNonDicom, includeReport).execute();
		} catch (PatientIdentifierParseException e) {
			throw new MethodException("Patient Identifier Parse Exception.");
		}
	}

	@POST
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	@Path("queue/dfn/{patient-dfn}/{site-id}/{study-iens}/{queue-id}/{incl-nd}/{incl-rpt}")
	public ROIRequestType queueCommunityCareByPatientDfn(
			@PathParam("patient-dfn") String patientDfn,
			@PathParam("site-id") String siteId,
			@PathParam("study-iens") String studyIens,
			@PathParam("queue-id") String queueId,
			@PathParam("incl-nd") String includeNonDicom,
			@PathParam("incl-rpt") String includeReport,
			String ccpHeaders)
	throws MethodException, ConnectionException
	{
		return new ROIQueueStudiesCommand(PatientIdentifier.dfnPatientIdentifier(patientDfn, siteId), 
				siteId, studyIens, queueId, ccpHeaders, includeNonDicom, includeReport).execute();
	}
	
	@POST
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	@Path("queue/icn/{patient-icn}/{site-id}/{study-iens}/{queue-id}/{incl-nd}/{incl-rpt}")
	public ROIRequestType queueCommunityCareByPatientIcn(
			@PathParam("patient-icn") String patientIcn,
			@PathParam("site-id") String siteId,
			@PathParam("study-iens") String studyIens,
			@PathParam("queue-id") String queueId,
			@PathParam("incl-nd") String includeNonDicom,
			@PathParam("incl-rpt") String includeReport,
			String ccpHeaders)
	throws MethodException, ConnectionException
	{
		return new ROIQueueStudiesCommand(PatientIdentifier.icnPatientIdentifier(patientIcn), 
				siteId, studyIens, queueId, ccpHeaders, includeNonDicom, includeReport).execute();
	}
	
	
	/**
	 * Get the status of a particular work item
	 * @param id
	 * @param extended
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("status/{id}")
	public ROIRequestType status(
			@PathParam("id") String id,
			@DefaultValue("") @QueryParam("extended") String extended)
	throws MethodException, ConnectionException
	{
		return new RoiStatusCommand(id, extended).execute();
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("cancel/{id}")
	public RestBooleanReturnType cancel(
			@PathParam("id") String id)
	throws MethodException, ConnectionException
	{
		return new ROICancelWorkItemCommand(id).execute();
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("status")
	public ROIRequestType[] status()
	throws MethodException, ConnectionException
	{
		return new ROIGetActiveWorkItemsCommand().execute();
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("process")
	public RestBooleanReturnType process()
	throws MethodException, ConnectionException
	{
		return new ROIProcessActiveRequestsCommand().execute();
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("process/{id}")
	public RestBooleanReturnType process(
			@PathParam("id") String id)
	throws MethodException, ConnectionException
	{
		return new ROIProcessWorkItemCommand(id).execute();
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("status/{id}/{status}")
	public RestBooleanReturnType changeStatus(
			@PathParam("id") String id, 
			@PathParam("status") String status)
	throws MethodException, ConnectionException
	{
		return new ROIChangeWorkItemStatusCommand(id, status).execute();
	}
	
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("reset")
	public RestBooleanReturnType resetOldUnfinishedRequests()
	throws MethodException, ConnectionException
	{
		return new ROIResetOldUnfinishedRequestsCommand().execute();
	}
	
	/**
	 * Get the list of ROI requests for the current user (based on the DUZ of the user from the realm).
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("user")
	public ROIRequestType [] user()
	throws MethodException, ConnectionException
	{
		return new ROIGetUserWorkItemsCommand().execute();
	}
	
	/**
	 * Deletes all work items for the current user (based on realm)
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	@GET
	@Produces(MediaType.APPLICATION_XML)
	@Path("delete")
	public RestBooleanReturnType deleteUser()
	throws MethodException, ConnectionException
	{
		return new ROIDeleteUserWorkItemsCommand().execute();
	}
	
	
}