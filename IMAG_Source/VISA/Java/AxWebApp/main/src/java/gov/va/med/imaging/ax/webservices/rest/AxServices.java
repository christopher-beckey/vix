/**
 * Ax Web App Rest service definitions
 * Date Created: May 7, 2017
 * Developer:  vacotittoc
 */
package gov.va.med.imaging.ax.webservices.rest;

import gov.va.med.imaging.ax.web.AxDoGetDocument;
import gov.va.med.imaging.ax.webservices.commands.AxGetDocumentListCommand;
import gov.va.med.imaging.ax.webservices.commands.AxGetLucky;
import gov.va.med.imaging.ax.webservices.rest.types.Bundle;
import gov.va.med.imaging.ax.webservices.rest.types.LuckyType;
import gov.va.med.imaging.ax.webservices.rest.types.OperationOutcome;
import gov.va.med.imaging.ax.webservices.translator.AxTranslator;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;

import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.core.StreamingOutput;
import javax.ws.rs.core.UriInfo;

import gov.va.med.logging.Logger;

/**
 * @author vacotittoc
 *
 */
@Path("ax")
public class AxServices
{
	private static final String VAOID = "2.16.840.1.113883.4.349|";
	private static final String APPJSONFHIR = "application/json+fhir"; // useless, no body writer for this MIME type with genson-x.x
	private final static String transactionLogHeaderTagName = "X-ConversationID";

	private final static Logger LOGGER = Logger.getLogger(AxServices.class);

	protected Logger getLogger()
	{
		return LOGGER;
	}

	// Pass 1 -- get list of patient documents by date range
	//     DocumentReference?subject.identifier=2.16.840.1.113883.4.349|{ICN}&[type={LOINC}][&created=>={YYYY-MM-DD}&created=<={YYYY-MM-DD}]&
	//						 requestor={system}&transactionId={queryId}&purposeOfUse=Treatment
	//      for the record: 2.16.840.1.113883.3.42.10001.100001.12|{EDIPI} for DoD
	@GET
	@Path("DocumentReference") 
//	@Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
	@Produces({MediaType.APPLICATION_JSON, APPJSONFHIR})
	public Response getDocumentReferenceListForPatient(
			@Context HttpServletRequest request,
			@Context HttpServletResponse response,
			@Context UriInfo uriInfo,
			@QueryParam("subject.identifier") String patientId,
			@QueryParam("type") String LOINC,
			@QueryParam("created=>") String fromDate,
			@QueryParam("created=<") String toDate,
			@QueryParam("requestor") String requestor,
			@QueryParam("transactionID") String transactionId,
			@QueryParam("purposeOfUse") String purposeOfUse,
			@HeaderParam("Accept") String acceptHeader)
	throws MethodException, ConnectionException
	{
        @SuppressWarnings("deprecation")
		String requestURL = URLDecoder.decode(uriInfo.getRequestUri().toString()); // , "ISO-8859-1");
        LOGGER.debug("AxServices.getDocumentReferenceListForPatient() --> Request received: {} with Accept header: {}", requestURL, (acceptHeader == null) ? "" : acceptHeader);
		
		// 2.16.840.1.113883.4.349|ICN, [LOINC], [yyyy-MM-dd]-s, requestor, transactionId and purposeOfUse ("Treatment") are expected
		String begDate = convertDate(fromDate); // start of day;
		String endDate = convertDate(toDate); // later set end of the day!;
		
		if ((LOINC == null) || LOINC.isEmpty())
			LOINC = null;
		
		// Are 2.16.840.1.113883.4.349|ICN, [LOINC], [yyyy-MM-dd]-s, requestor, transactionId and purposeOfUse ("Treatment") passed? 
		// (LOINC and dates can be null)
		if ((patientId == null) || (!patientId.startsWith(VAOID)) || (!patientId.contains("V")) ||
			(requestor == null) || requestor.isEmpty() || (transactionId == null) || transactionId.isEmpty() || 
			(purposeOfUse == null) || (!purposeOfUse.equalsIgnoreCase("Treatment"))) {
			String message = "Invalid DocumentReference request: subject.identifier must start with '2.16.840.1.113883.4.349|' and must be folowed by a correlated ICN; " +
							 "'requestor', 'transactionID' and 'purposeOfUse' must be explicitly defined and 'purposeOfUse' must be 'Treatment'!";
			return wrapErrorResponse(Status.NOT_ACCEPTABLE, message);
		}
		
		String patientIcn = patientId.replace(VAOID, ""); // remove OID, keep ICN

		// *** mocking with ICNs is temporary for Integration Tests ***
		// patientIcn = checkToSwapICN(patientIcn);

		if ((acceptHeader!=null) && !acceptHeader.isEmpty() && acceptHeader.contains(APPJSONFHIR)) {
			String newAccept = request.getHeader("Accept").replace(APPJSONFHIR, "application/json"); // make sure "application/json+fhir" disappears from Accept header
			request.setAttribute("Accept", newAccept); // overwrite ???!!!
            LOGGER.debug("AX GET DR Accept header: '{}'; altered to: '{}'; from request: '{}' got.", acceptHeader, newAccept, request.getHeader("Accept"));
		}
		
		String dasTALogId = request.getHeader(transactionLogHeaderTagName);
		
		if ((dasTALogId == null) || dasTALogId.isEmpty())
			dasTALogId = transactionId;
		
		return wrapOkResponse(convertDocumentSetResult(new AxGetDocumentListCommand(patientIcn, LOINC, begDate, endDate, purposeOfUse, dasTALogId).execute(), requestor, transactionId) );
		// DiagnosticReports class is returned
	}
	
// Pass 2, BLOB retrieval
//         Binary/{documentURN}/?transactionId={uniqueID}&requestor={JLV|HAIMS|Etc.}&purposeOfUse=Treatment
	@GET
	@Path("Binary/{documentURN}/")
	@Produces({MediaType.APPLICATION_OCTET_STREAM, MediaType.APPLICATION_OCTET_STREAM}) // Data is streamed binary, error is FHIR JSON
	public Response getDocumentBLOB(
			@Context UriInfo uriInfo,
			@Context HttpServletRequest request,
			@Context HttpServletResponse response,
			@PathParam("documentURN") String documentURN,
			@QueryParam("transactionID") String transactionId,
			@QueryParam("requestor") String requestor,
			@QueryParam("purposeOfUse") String purposeOfUse)
	throws MethodException, ConnectionException
	{
		
        @SuppressWarnings("deprecation")
		String requestURL = URLDecoder.decode(uriInfo.getRequestUri().toString()); // , "ISO-8859-1");

        LOGGER.debug("AxServices.getDocumentBLOB() --> Binary document request received: {}", requestURL);
		
		if ( (documentURN == null) || documentURN.isEmpty() ||
			 (requestor == null) || requestor.isEmpty() || (transactionId==null) || transactionId.isEmpty() || 
				(purposeOfUse == null) || !purposeOfUse.equalsIgnoreCase("Treatment")) {
			return wrapErrorResponse(Status.NOT_ACCEPTABLE, "Invalid document retrieval request: 'documentURN', 'requestor', 'transactionID' and 'purposeOfUse' must be explicitly defined and 'purposeOfUse' must be 'Treatment'");
		}

		return streamResponse(AxGetAndStreamDocument(request, response, documentURN));
	}
	
	// ------------------------------------------ test only!!! --------------------------------------------
	//     Lucky?word={a-word}&number={a-number}[&accept=application/json]
	@GET
	@Path("Lucky")
	@Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
	public Response getLucky(
			@Context UriInfo uriInfo,
			@QueryParam("word") String aWord,
			@QueryParam("number") String aNumber)
	throws MethodException
	{
        @SuppressWarnings("deprecation")
		String requestURL = URLDecoder.decode(uriInfo.getRequestUri().toString()); // , "ISO-8859-1");
        getLogger().debug("MIX 'GET Lucky' request received. URI: {}", requestURL);

		AxGetLucky getLucky = new AxGetLucky(aWord, aNumber);
		LuckyType luckyType = getLucky.crunch();
		return wrapOkResponse(luckyType);
	}
	// test only!!!
	//     LuckyPP/{word}/{number}[?accept=application/json]
	@GET
	@Path("LuckyPP/{word}/{number}")
	@Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
	public Response getLuckyPP(
			@Context UriInfo uriInfo,
			@PathParam("word") String aWord,
			@PathParam("number") String aNumber)
	throws MethodException
	{
		String requestURL = URLDecoder.decode(uriInfo.getRequestUri().toString()); // , "ISO-8859-1");
        getLogger().debug("MIX 'GET LuckyPP' request received. URI: {}", requestURL);

		AxGetLucky getLucky = new AxGetLucky(aWord, aNumber);
		LuckyType luckyType = getLucky.crunch();
		return wrapOkResponse(luckyType);
	}
	
// ------------------------------------------ support methods --------------------------------------------

	private String checkToSwapICN(String theICNgot)
	{
		String theICN = theICNgot;
		
		// trick to swap IPO 4&5 test ICNs to IPO 1&2 mirrors
		if (theICNgot.equalsIgnoreCase("1008689559V859134"))
			theICN = "1012740021V495560"; 
		else if (theICNgot.equalsIgnoreCase("1008689424V686541"))
			theICN = "1012740381V796853"; 
		else if (theICNgot.equalsIgnoreCase("1008689409V873033"))
			theICN = "1012740369V059445"; 
		else if (theICNgot.equalsIgnoreCase("1008689511V752466"))
			theICN = "1012740020V387031"; 
		
		if (!theICN.equalsIgnoreCase(theICNgot))
            LOGGER.debug("AxServices.checkToSwapICN() --> Reference -- ICN swap from [{}] to [{}]", theICNgot, theICN);
		 
		return theICN;
	}

	private String convertDate(String webDate)
	{
		String dicomDate = null;

		// convert "yyyy-mm-dd" to "yyyymmdd" or return null
		if ((webDate!=null) && (!webDate.isEmpty())) {
			dicomDate = webDate.replace("-", "");
		}
		
		return dicomDate;
	}
		
	protected Bundle convertDocumentSetResult(DocumentSetResult documentSetresult, String requestor, String transactionId)
	throws MethodException
	{
		Bundle bundle = null;
		try {
			bundle = AxTranslator.convertDocumentReferences(documentSetresult, requestor, transactionId);
		}
		catch (TranslationException te) {
			String msg = "AxServices.convertDocumentSetResult() --> translation exception: " + te.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg);
		}

		if (bundle == null)
			bundle = new Bundle();

		bundle.setId(transactionId);
		
		return bundle;
	}

	private StreamingOutput AxGetAndStreamDocument(HttpServletRequest request, HttpServletResponse response,
			String documentURN) {
		AxDoGetDocument axDoGetImage = new AxDoGetDocument(documentURN, request, response);
		return axDoGetImage.streamDocument(request, response, documentURN);
	}

	private Response wrapErrorResponse(Status status, String message)
	{		
		OperationOutcome operationOutcome = AxTranslator.createOperationOutcome(Integer.toString(status.getStatusCode()), message);
		
		return Response.status(status).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
				TransactionContextFactory.get().getMachineName()).entity(operationOutcome).build();
	}

	private Response wrapOkResponse(Object result)
	{
		Response response=null;
		try {
			response = Response.status(Status.OK).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
					    TransactionContextFactory.get().getMachineName()).entity(result).build();
		} 
		catch (Exception ex)
		{
			return wrapErrorResponse(Status.INTERNAL_SERVER_ERROR, ex.getMessage());
		}
		return response;
	}

	private Response streamResponse(StreamingOutput stream)
	{
		return Response.ok(stream).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
				TransactionContextFactory.get().getMachineName()).build();
	}
}
