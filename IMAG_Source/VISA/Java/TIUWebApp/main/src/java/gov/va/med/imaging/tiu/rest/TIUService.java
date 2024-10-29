/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest;

import java.io.InputStream;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import gov.va.med.logging.Logger;

import com.sun.jersey.core.header.FormDataContentDisposition;
import com.sun.jersey.multipart.FormDataBodyPart;
import com.sun.jersey.multipart.FormDataParam;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.rest.commands.GetTIUAuthorsCommand;
import gov.va.med.imaging.tiu.rest.commands.GetTIUElectronicallyFileNoteCommand;
import gov.va.med.imaging.tiu.rest.commands.GetTIULocationsCommand;
import gov.va.med.imaging.tiu.rest.commands.GetTIUNoteIsAdvanceDirective;
import gov.va.med.imaging.tiu.rest.commands.GetTIUNoteIsConsultCommand;
import gov.va.med.imaging.tiu.rest.commands.GetTIUNoteIsValidCommand;
import gov.va.med.imaging.tiu.rest.commands.GetTIUNoteTextCommand;
import gov.va.med.imaging.tiu.rest.commands.GetTIUNotesCommand;
import gov.va.med.imaging.tiu.rest.commands.GetTIUPatientNoteIsAdvanceDirective;
import gov.va.med.imaging.tiu.rest.commands.GetTIUPatientNotesCommand;
import gov.va.med.imaging.tiu.rest.commands.PostTIUElectronicallySignNoteCommand;
import gov.va.med.imaging.tiu.rest.commands.PostTIUNoteAddendumCommand;
import gov.va.med.imaging.tiu.rest.commands.PostTIUNoteCommand;
import gov.va.med.imaging.tiu.rest.commands.TIUNoteIngestCommand;
import gov.va.med.imaging.tiu.rest.types.TIUItemStreamType;
import gov.va.med.imaging.tiu.rest.types.TIUNoteAddendumInputType;
import gov.va.med.imaging.tiu.rest.types.TIUResponseType;
import gov.va.med.imaging.tiu.rest.types.TIUNoteInputType;
import gov.va.med.imaging.tiu.rest.types.TIUOpResultType;
import gov.va.med.imaging.tiu.rest.types.TIUPatientNoteType;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;
import gov.va.med.imaging.web.rest.exceptions.AbstractRestService;

/**
 * @author Julian Werfel
 *
 */
@Path("tiu")
public class TIUService
extends AbstractRestService
{
	private final static Logger LOGGER = Logger.getLogger(TIUService.class);

	@GET
	@Path("ping")
	@Produces(MediaType.APPLICATION_XML)
	public Response ping()
	{
		return createResponse(new TIUOpResultType(Status.OK, "Pong !!! TIUService is up and running !!!"));
	}

	@GET
	@Path("notes/titles/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getTIUNoteTitles(
			@PathParam("siteId") String siteId,
			@QueryParam("searchText") String searchText,
			@QueryParam("titleList") String titleList)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetTIUNotesCommand(siteId, searchText, titleList, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("locations/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getTIUNoteLocations(
			@PathParam("siteId") String siteId,
			@QueryParam("searchText") String searchText)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetTIULocationsCommand(siteId, searchText, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("authors/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getTIUNoteAuthors(
			@PathParam("siteId") String siteId,
			@QueryParam("searchText") String searchText)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
				new GetTIUAuthorsCommand(siteId, searchText, getInterfaceVersion()).execute());
	}
	
	@POST
	@Path("note")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response createTIUNote(TIUNoteInputType noteInput)	
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new PostTIUNoteCommand(noteInput, getInterfaceVersion()).execute());
	}
	
	@POST
	@Path("note/sign/{patientTIUNoteUrn}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response electronicallySignTIUNote(
		@PathParam("patientTIUNoteUrn") String patientTIUNoteUrn,
		RestStringType electronicSignature)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new PostTIUElectronicallySignNoteCommand(patientTIUNoteUrn, 
			electronicSignature.getValue(), getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("note/file/{patientTIUNoteUrn}")
	@Produces(MediaType.APPLICATION_XML)
	//@Consumes(MediaType.APPLICATION_XML)
	public Response electronicallyFileTIUNote(
		@PathParam("patientTIUNoteUrn") String patientTIUNoteUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new GetTIUElectronicallyFileNoteCommand(patientTIUNoteUrn, 
			getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("note/consult/{tiuNoteTitleUrn}")
	@Produces(MediaType.APPLICATION_XML)
	public Response isTIUNoteAConsult(
		@PathParam("tiuNoteTitleUrn") String tiuNoteTitleUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new GetTIUNoteIsConsultCommand(tiuNoteTitleUrn, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("note/advanceDirective/{tiuNoteTitleUrn}")
	@Produces(MediaType.APPLICATION_XML)
	public Response isTIUNoteTitleAdvanceDirective(
		@PathParam("tiuNoteTitleUrn") String tiuNoteTitleUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new GetTIUNoteIsAdvanceDirective(tiuNoteTitleUrn, getInterfaceVersion()).execute());
	}
	
	@GET
	@Path("patient/note/advanceDirective/{patientTIUNoteUrn}")
	@Produces(MediaType.APPLICATION_XML)
	public Response isPatientTIUNoteAdvanceDirective(
		@PathParam("patientTIUNoteUrn") String patientTIUNoteUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new GetTIUPatientNoteIsAdvanceDirective(patientTIUNoteUrn, getInterfaceVersion()).execute());
	}


	@GET
	@Path("note/valid/{siteId}")
	@Produces(MediaType.APPLICATION_XML)
	public Response isTIUNoteValid(
		@PathParam("siteId") String siteId,
		@QueryParam("tiuNoteTitleUrn") String tiuNoteTitleUrn,
		@QueryParam("patientTiuNoteUrn") String patientTiuNoteUrn,
		@QueryParam("typeIndex") String typeIndex)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new GetTIUNoteIsValidCommand(siteId, tiuNoteTitleUrn, patientTiuNoteUrn, typeIndex, getInterfaceVersion()).execute());
	}

	
	@GET
	@Path("patient/notes/{siteId}/{patientId}/{status}/{count}/{ascending}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getPatientTIUNotes(
		@PathParam("siteId") String siteId,
		@PathParam("patientId") String patientId,
		@PathParam("status") String status,
		@PathParam("count") int count,
		@PathParam("ascending") boolean ascending,
		@QueryParam("fromDate") String fromDate,
		@QueryParam("toDate") String toDate,
		@QueryParam("authorDuz") String authorDuz)
	throws ConnectionException, MethodException
	{	    
		return wrapResultWithResponseHeaders(
			new GetTIUPatientNotesCommand(siteId, status, patientId, fromDate, toDate, authorDuz, 
				count, ascending, getInterfaceVersion()).execute());
	}
	
	
	@GET
	@Path("patient/note/{patientTIUNoteUrn}")
	@Produces(MediaType.APPLICATION_XML)
	public Response getPatientTIUNoteText(
		@PathParam("patientTIUNoteUrn") String patientTIUNoteUrn)
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new GetTIUNoteTextCommand(patientTIUNoteUrn, getInterfaceVersion()).execute());
	}

	@POST
	@Path("note/addendum/{patientTIUNoteUrn}")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.APPLICATION_XML)
	public Response createTIUNoteAddendum(
		@PathParam("patientTIUNoteUrn") String patientTIUNoteUrn,
		TIUNoteAddendumInputType addendumInput)	
	throws ConnectionException, MethodException
	{
		return wrapResultWithResponseHeaders(
			new PostTIUNoteAddendumCommand(patientTIUNoteUrn, addendumInput, getInterfaceVersion()).execute());
	}

	protected String getInterfaceVersion()
	{
		return "V1";
	}
	
	// Quoc added to ingest an image/file with or without a note
	@POST
	@Path("note/ingest")
	@Produces(MediaType.APPLICATION_XML)
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	public Response ingestNote( 
								@FormDataParam("createNote") String inCreateNote,
								@FormDataParam("file") InputStream uploadedFile,
							    @FormDataParam("file") FormDataContentDisposition fileDetails,
							    @FormDataParam("noteInput") FormDataBodyPart inputs
							   )
	{
		// There's no need to get "securityToken". The BSE token will be put in TransactionContext by filter component
		
		String errMsg = null;
		boolean createNote = false;
		
		if (StringUtil.isEmpty(inCreateNote)) 
		{
			errMsg = "'createNote' was not given.";
			LOGGER.error(errMsg);
			return createResponse(new TIUOpResultType(Status.BAD_REQUEST, errMsg));
		} 
		else 
		{
			createNote = Boolean.parseBoolean(inCreateNote); 
		}
		
		if (uploadedFile == null || fileDetails == null) 
		{
			errMsg = "No file was uploaded.";
			LOGGER.error(errMsg);
			return createResponse(new TIUOpResultType(Status.BAD_REQUEST, errMsg));
		}
		
		// Use Jersey to marshall
		inputs.setMediaType(MediaType.APPLICATION_XML_TYPE);
		TIUNoteInputType noteInput = inputs.getValueAs(TIUNoteInputType.class);
		
		if (! hasEnoughInputs(noteInput, createNote))		// Check required fields to be present
		{
			errMsg = "No or not enough required input(s) to proceed for " + (createNote ? "note and ingest" :  "ingest only");
			LOGGER.error(errMsg);
			return createResponse(new TIUOpResultType(Status.BAD_REQUEST, errMsg));
		}
		
		if (createNote) 
		{
			// Cursory checks before moving forward
		
			if (! noteInput.getTiuNoteTitleUrn().startsWith("urn:tiu"))
			{
				errMsg = "Given note title URN [" + noteInput.getTiuNoteTitleUrn() + "] MUST start with 'urn:tiu'";
				LOGGER.error(errMsg);
				return createResponse(new TIUOpResultType(Status.BAD_REQUEST, errMsg));			
			}
		
			if (! noteInput.getPatientId().contains("V"))
			{
				errMsg = "Given patient Id [" + noteInput.getPatientId() + "] MUST be in ICN format.";
				LOGGER.error(errMsg);
				return createResponse(new TIUOpResultType(Status.BAD_REQUEST, errMsg));			
			}
		}
		
		noteInput.setStreamType(new TIUItemStreamType(uploadedFile, fileDetails.getFileName()));
		
		// Everything is checked out as much as possible --> proceed to ingest
		
		LOGGER.info("Invoking TIUNoteIngestCommand.execute()......");
		
		return createResponse(new TIUNoteIngestCommand(noteInput, createNote).execute());
	}

	// ************************** Helper method section *************************************************
	
	
	/**
	 * Helper method to create a Response object
	 * from a TIUOpResultType or a TIUPatientNoteType
	 * 
	 * 	Possible codes:
	 *    2oo - OK
	 *    400 - Bad Request
	 *    500 - Internal Server Error
	 *    
	 * @param Object				input: either a TIUOpResultType or a TIUPatientNoteType instance
	 * @return Response				result
	 * 
	 */
	private Response createResponse(Object result) 
	{
		if (result instanceof TIUPatientNoteType) 
		{	
			return Response.status(Status.OK)
					   .header(TransactionContextHttpHeaders.httpHeaderMachineName, TransactionContextFactory.get().getMachineName())
					   .entity((TIUPatientNoteType) result)
					   .build();
		} 
		else 
		{	
			TIUOpResultType opResult = (TIUOpResultType) result;
			String respStatus = opResult.getHttpStatus().getStatusCode() + " - " + opResult.getHttpStatus().getReasonPhrase();
			
			return Response.status(opResult.getHttpStatus())
						   .header(TransactionContextHttpHeaders.httpHeaderMachineName, TransactionContextFactory.get().getMachineName())
						   .entity(new TIUResponseType(respStatus, opResult.getMessage()))
						   .build();
		}
	}
		
	/**
	 * Helper method to check required inputs before moving forward
	 * 
	 * @param TIUNoteInputType		object contains inputs
	 * @param boolean				flag to check for every input or just "ingest" only inputs
	 * @return boolean				result
	 * 
	 */
	private boolean hasEnoughInputs(TIUNoteInputType noteInput, boolean createNote) 
	{	
		// TIUItemStreamType is already checked.
		// Easy button
		if (createNote) 
		{
			return (noteInput != null &&
					! StringUtil.isEmpty(noteInput.getTiuNoteTitleUrn()) &&
					! StringUtil.isEmpty(noteInput.getDate()) &&
					! StringUtil.isEmpty(noteInput.getNoteText()) &&
					! StringUtil.isEmpty(noteInput.getShortDescription()) &&
					! StringUtil.isEmpty(noteInput.getOriginIndex()) &&				
					! StringUtil.isEmpty(noteInput.getTypeIndex()) &&				
					! StringUtil.isEmpty(noteInput.getPatientId()) 					
					);
		} 
		else 
		{
			return (noteInput != null &&
					! StringUtil.isEmpty(noteInput.getOriginIndex()) &&				// For ingest only
					! StringUtil.isEmpty(noteInput.getTypeIndex()) &&				// For ingest only
					! StringUtil.isEmpty(noteInput.getSiteId()) &&					// For ingest only
					! StringUtil.isEmpty(noteInput.getPatientId()) 					// For ingest only
					);
		}
	}
		
}