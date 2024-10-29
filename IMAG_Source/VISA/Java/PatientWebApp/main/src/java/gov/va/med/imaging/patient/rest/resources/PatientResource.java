package gov.va.med.imaging.patient.rest.resources;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.patient.commands.GetHealthSummaryCommand;
import gov.va.med.imaging.patient.commands.GetHealthSummaryTypesCommand;
import gov.va.med.imaging.patient.commands.GetPatientInformationCommand;
import gov.va.med.imaging.patient.commands.GetPatientListCommand;
import gov.va.med.imaging.patient.commands.GetPatientMeansTestCommand;
import gov.va.med.imaging.patient.commands.GetPatientSensitivityLevelCommand;
import gov.va.med.imaging.patient.commands.GetPatientSensitivityLevelTypeCommand;
import gov.va.med.imaging.patient.commands.LogSensitivePatientAccessCommand;
import gov.va.med.imaging.patient.commands.LogSensitivePatientAccessTypeCommand;
import gov.va.med.imaging.patient.commands.PatientSearchCommand;
import gov.va.med.imaging.patient.rest.types.PatientHealthSummariesType;
import gov.va.med.imaging.patient.rest.types.PatientMeansTestType;
import gov.va.med.imaging.patient.rest.types.PatientSensitiveValueType;
import gov.va.med.imaging.patient.rest.types.PatientType;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.rest.types.RestStringType;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

/**
 * @author vhaiswlouthj
 *
 */
@Path("/patient")
public class PatientResource {

    @GET
    @Path("/getPatientList")
    @Consumes("text/plain")
    public String getPatientList(@QueryParam("searchCriteria") String searchCriteria) 
    	throws MethodException, ConnectionException
	{
    	PatientSearchCommand command = new PatientSearchCommand(searchCriteria, "1.0");
    	return command.execute();
    }
    
    @GET
    @Path("/getPatientSensitivityLevelByDfn")
    @Consumes("text/plain")
    public String getPatientSensitivityLevelByDfn(@QueryParam("patientDfn") String patientDfn) 
    	throws MethodException, ConnectionException
	{
    	GetPatientSensitivityLevelCommand command = new GetPatientSensitivityLevelCommand(
    			new PatientIdentifier(patientDfn, PatientIdentifierType.dfn), 
    			"1.0");
    	
    	return command.execute();
    }
    
    
    @GET
    @Path("/getPatientSensitivityLevelByIcn")
    @Consumes("text/plain")
    public String getPatientSensitivityLevelByIcn(@QueryParam("patientIcn") String patientIcn) 
    	throws MethodException, ConnectionException
	{
    	GetPatientSensitivityLevelCommand command = new GetPatientSensitivityLevelCommand(
    			new PatientIdentifier(patientIcn, PatientIdentifierType.icn), 
    			"1.0");
    
    	return command.execute();
    }
    
    @GET
    @Path("/logSensitivePatientAccessByDfn")
    @Consumes("text/plain")
    public String logSensitivePatientAccessByDfn(@QueryParam("patientDfn") String patientDfn) 
    	throws MethodException, ConnectionException
	{
    	LogSensitivePatientAccessCommand command = new LogSensitivePatientAccessCommand(
    			new PatientIdentifier(patientDfn, PatientIdentifierType.dfn), 
    			"1.0");
    	
    	command.execute();
    	
    	return "";
    }
    
    
    @GET
    @Path("/logSensitivePatientAccessByIcn")
    @Consumes("text/plain")
    public String logSensitivePatientAccessByIcn(@QueryParam("patientIcn") String patientIcn) 
    	throws MethodException, ConnectionException
	{
    	LogSensitivePatientAccessCommand command = new LogSensitivePatientAccessCommand(
    			new PatientIdentifier(patientIcn, PatientIdentifierType.icn), 
    			"1.0");

    	command.execute();
    	return "";
    }
    
    @GET
    @Path("/sensitive/check/{siteId}/{patientId}")
    @Produces(MediaType.APPLICATION_XML)
    public PatientSensitiveValueType getPatientSensitivityLevel(
    		@PathParam("siteId") String siteId,
    		@PathParam("patientId") String patientId)
    throws MethodException, ConnectionException
    {
    	try {
    	return new GetPatientSensitivityLevelTypeCommand(siteId,
    			PatientIdentifier.fromString(patientId),
    			"1.0").execute();
		} catch (PatientIdentifierParseException e) {
			throw new MethodException("Patient Identifier Parse Exception.");
    }
    }
    
    @GET
    @Path("/sensitive/log/{siteId}/{patientId}")
    @Produces(MediaType.APPLICATION_XML)
    public RestBooleanReturnType logPatientSensitivityAccess(
    		@PathParam("siteId") String siteId,
    		@PathParam("patientId") String patientId)
    throws MethodException, ConnectionException
    {
    	try {
    	return new LogSensitivePatientAccessTypeCommand(siteId,
    			PatientIdentifier.fromString(patientId),
    			"1.0").execute();
		} catch (PatientIdentifierParseException e) {
			throw new MethodException("Patient Identifier Parse Exception.");
		}
    }
    
    @GET
    @Path("/information/{siteId}/{patientId}")
    @Produces(MediaType.APPLICATION_XML)
    public PatientType getPatientInformation(
    		@PathParam("siteId") String siteId,
    		@PathParam("patientId") String patientId)
    throws MethodException, ConnectionException
    {
    	try {
    		return new GetPatientInformationCommand(siteId, PatientIdentifier.fromString(patientId), 
    			"1.0").execute();
		} catch (PatientIdentifierParseException e) {
			throw new MethodException("Patient Identifier Parse Exception.");
		}
    }
    
    @GET
    @Path("/healthsummaries/{siteId}")
    @Produces(MediaType.APPLICATION_XML)
    public PatientHealthSummariesType getHealthSummaries(
    		@PathParam("siteId") String siteId)
    throws MethodException, ConnectionException
    {
    	return new GetHealthSummaryTypesCommand(siteId, "1.0").execute();
    }
    
    @GET
    @Path("/healthsummary/{patientId}/{summaryId}")
    @Produces(MediaType.APPLICATION_XML)
    public RestStringType getHealthSummaries(
    		@PathParam("patientId") String patientId,
    		@PathParam("summaryId") String summaryId)
    throws MethodException, ConnectionException
    {
    	try {
    	return new GetHealthSummaryCommand(summaryId, PatientIdentifier.fromString(patientId), "1.0").execute();
		} catch (PatientIdentifierParseException e) {
			throw new MethodException("Patient Identifier Parse Exception.");
		}
    }
    
    @GET
    @Path("/healthsummary/icn/{patientIcn}/{summaryId}")
    @Produces(MediaType.APPLICATION_XML)
    public RestStringType getHealthSummariesByIcn(
    		@PathParam("patientIcn") String patientIcn,
    		@PathParam("summaryId") String summaryId)
    throws MethodException, ConnectionException
    {
    	return new GetHealthSummaryCommand(summaryId, PatientIdentifier.icnPatientIdentifier(patientIcn), "1.0").execute();
    }
    
    @GET
    @Path("/healthsummary/dfn/{patientDfn}/{summaryId}")
    @Produces(MediaType.APPLICATION_XML)
    public RestStringType getHealthSummariesByDfn(
    		@PathParam("patientDfn") String patientDfn,
    		@PathParam("summaryId") String summaryId)
    throws MethodException, ConnectionException
    {
    	return new GetHealthSummaryCommand(summaryId, PatientIdentifier.dfnPatientIdentifier(patientDfn, null), "1.0").execute();
    }
    
    @GET
    @Path("/meansTest/{siteId}/{patientId}")
    @Produces(MediaType.APPLICATION_XML)
    public PatientMeansTestType getMeansTest(
    		@PathParam("siteId") String siteId,
    		@PathParam("patientId") String patientId)
    throws MethodException, ConnectionException
    {
    	try {
    	return new GetPatientMeansTestCommand(siteId, PatientIdentifier.fromString(patientId), "1.0").execute();
		} catch (PatientIdentifierParseException e) {
			throw new MethodException("Patient Identifier Parse Exception.");
		}
    }
    
    @GET
    @Path("/patientList/{siteId}")
    @Consumes("text/plain")
    public String getPatientList(
    		@PathParam("siteId") String siteId,
    		@QueryParam("searchCriteria") String searchCriteria)
    	throws MethodException, ConnectionException
	{
    	return new GetPatientListCommand(siteId, searchCriteria, "1.0").execute();
	}
}