/**
 * MIX Web App Rest service definitions
 * Date Created: Nov 30, 2016
 * Developer:  vacotittoc
 */
package gov.va.med.imaging.mix.webservices.rest;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.mix.web.MIXDoGetImage;
import gov.va.med.imaging.mix.webservices.commands.v1.MixGetDASCachedDocId;
// import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;
import gov.va.med.imaging.mix.webservices.commands.v1.MixGetReportAndShallowStudyListCommandV1; // MixGetStudyListCommandV1;
import gov.va.med.imaging.mix.webservices.commands.v1.MixGetStudyTreeCommandV1;
import gov.va.med.imaging.mix.webservices.commands.v1.MixGetLucky;
import gov.va.med.imaging.mix.webservices.rest.types.v1.DASCacheIdType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.DiagnosticReport;
// import gov.va.med.imaging.mix.webservices.rest.types.v1.DiagnosticReports;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ImagingStudy;
import gov.va.med.imaging.mix.webservices.rest.types.v1.LuckyType;
import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslator;
import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslatorV1;
// import gov.va.med.imaging.rest.types.RestBooleanReturnType;
// import gov.va.med.imaging.rest.types.RestStringType;
// import gov.va.med.imaging.tomcat.vistarealm.encryption.EncryptionToken;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;

import java.net.URLDecoder;
import java.text.ParseException;
// import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
// import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
// import javax.ws.rs.core.Request;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.core.StreamingOutput;
import javax.ws.rs.core.UriInfo;

import gov.va.med.logging.Logger;

/**
 * @author vacotittoc
 *
 */
@Path("mix")
public class MixServices
{
	public static final String applicationDicomJp2 = "application/dicom+jp2";
//	public static final String ImageJpeg = "image/jpeg";
	private final static String transactionLogHeaderTagName = "X-ConversationID";

	private final static Logger logger = Logger.getLogger(MixServices.class);

	protected Logger getLogger()
	{
		return logger;
	}

	// Pass 1, Level 1 (flavor 1 & 2)
	//     DiagnosticReport/subject?value={icn}&assigner={asnr}[&fromDate={yyyy-mm-dd}][&toDate={yyyy-mm-dd}]
	//     DiagnosticReport/subject?value={icn}&assigner={asnr}[&fromDate={yyyy-mm-dd}][&toDate={yyyy-mm-dd}][&modalities={XX[{,...}]}]
	@GET
	@Path("DiagnosticReport/subject") 
//	@Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
	@Produces(MediaType.APPLICATION_JSON)
	public Response getReportAndShallowStudyListbyModalities(
			@Context HttpServletRequest request,
			@Context UriInfo uriInfo,
			@QueryParam("value") String patientId,
			@QueryParam("assigner") String assignerId,
			@QueryParam("fromDate") String fromDate,
			@QueryParam("toDate") String toDate,
			@QueryParam("modalities") String modalities)
	throws MethodException, ConnectionException
	{
        @SuppressWarnings("deprecation")
		String requestURL = URLDecoder.decode(uriInfo.getRequestUri().toString()); // , "ISO-8859-1");
        getLogger().debug("MIX GET DiagnosticReport request received: {}", requestURL);
		
		// ICN, "VHA", "yyyy-MM-dd"-s and ',' separated list of modalities (to include) are expected
		String begDate=null;
		String endDate=null;
		begDate = convertDate(fromDate);
		endDate = convertDate(toDate);
		if (modalities!=null && modalities.isEmpty())
			modalities=null;
		// ICN, "VHA", "yyyyMMdd"-s and ',' separated list of modalities (to include) passed (dates, modalities can be null)
		if ((patientId==null) || (!patientId.contains("V")) || (begDate==null) || (endDate==null)) {
			String message = "MIX DiagnosticReport request requierments: 'value' must be a correlated ICN; 'fromDate' and 'toDate' must be explicitly defined in 'yyyy-MM-dd' format!";
			return wrapResponse(Status.NOT_ACCEPTABLE, message);
		}
		// *** mocking with ICNs is temporary for Integration Tests ***
		// patientId = checkToSwapICN(patientId);

		String dasTALogId = request.getHeader(transactionLogHeaderTagName);
	
		return wrapResponse(Status.OK, convertStudySetResult(new MixGetReportAndShallowStudyListCommandV1(patientId, assignerId, begDate, endDate, modalities, dasTALogId).execute()) );
		// DiagnosticReports class is returned
	}
	
	// Pass 1, Level 2
	//     ImagingStudy?uid={study-IUD}
	@GET
	@Path("ImagingStudy")
//	@Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
	@Produces(MediaType.APPLICATION_JSON)
	public Response getStudyTree(
			@Context HttpServletRequest request,
			@Context UriInfo uriInfo,
			@QueryParam("uid") String studyUid)
	throws MethodException, ConnectionException
	{
		// String theISRequest = (request!=null)?(request.getPathInfo() + "?" + request.getQueryString()):"n/a";
        @SuppressWarnings("deprecation")
		String requestURL = URLDecoder.decode(uriInfo.getRequestUri().toString()); // , "ISO-8859-1");
        getLogger().debug("MIX GET ImagingStudy request received: {}", requestURL);
		
		if ((studyUid==null) || studyUid.isEmpty()) {
			String message = "MIX ImagingStudy request requirement: the 'uid' value must be an unaltered (opaque) value from a shallowStudy entry of the response result of a prior DiagnosticReport request!";
			return wrapResponse(Status.NOT_ACCEPTABLE, message);
		}

		String dasTALogId = request.getHeader(transactionLogHeaderTagName);

		// an agency unique ID is expected
		return wrapResponse(Status.OK, convertStudy(new MixGetStudyTreeCommandV1(studyUid, dasTALogId).execute())); // ImagingStudy class is returned
	}
	
//	// Pass 2, TN -- this is WADO-URI - goes through ThumbnailServlet
//	       RetrieveThumbnail?requestType=WADO&studyUID={studyUid}&seriesUID={seriesUid}&objectUID={instanceUid}[&imageQuality=20]
//	@GET
//	@Path("RetrieveThumbnail")
//	@Produces(MediaType.APPLICATION_OCTET_STREAM) // ImageJpeg --> writer??
//	public Response getThumbnailImage(			
// 			@Context HttpServletRequest request,
//			@QueryParam("requestType") String requestType,
//			@QueryParam("studyUid") String studyUid,
//			@QueryParam("seriesUid") String seriesUid,
//			@QueryParam("objectUid") String instanceUid,
//			@QueryParam("imageQuality") String imageQuality)
//	throws MethodException, ConnectionException
//	{
//		String theRTRequest = (request!=null)?(request.getPathInfo() + request.getQueryString()):"n/a";
//		getLogger().debug("MIX GET RetrieveThumbnail request received: " + theRTRequest);
//
//		if ( ((requestType==null) || (!requestType.equals("WADO"))) ||
//			 ((imageQuality!=null) && !imageQuality.equals(ImageQuality.THUMBNAIL)) )
//			return Response.status(Status.NOT_ACCEPTABLE).
//					header(TransactionContextHttpHeaders.httpHeaderMachineName,	TransactionContextFactory.get().getMachineName()).
//						tag("Invalid request (... imageQuality must be '20' and requestType must be 'WADO'").build();	
//		// temp error
//		return Response.status(Status.INTERNAL_SERVER_ERROR).
//				    header(TransactionContextHttpHeaders.httpHeaderMachineName,	TransactionContextFactory.get().getMachineName()).
//				    	tag("RetrieveThumbnail is not implemented yet!").build();	
//		// 1 DICOM UID (series) and 2 URNs (study, image) are expected
//	//	return wrapResponse(Status.OK, new MixGetThumbnailImageCommandV1(studyUid, seriesUid, instanceUid).execute() );
//	}

	
// Pass 2, Ref/Diag -- this is WADO-RS implemented here, but works through ImageServlet as well (WADO-URI, see URL below)
//         RetrieveInstance/studies/{studyUid}/series/{seriesUid}/instances/{instanceUid}?imageQuality={iQ}
//			 &transferSyntax={transferSyntaxUID}&contentType={contentType}
//           notes: iQ=70 or 90; contentType=application/dicom+jp2; transferSyntax=1.2.840.10008.1.2.4.91 for 70 and 1.2.840.10008.1.2.4.90 for 90
//         WADO-URI: retrieveThumbnail?requestType=WADO&studyUID={studyUid}&seriesUID={seriesUid}&objectUID={instanceUid}?imageQuality={iQ}
	@GET
//	@Path("RetrieveInstance")
	@Path("RetrieveInstance/studies/{studyUid}/series/{seriesUid}/instances/{instanceUid}")
	@Produces(MediaType.APPLICATION_OCTET_STREAM) // applicationDicomJp2 --> writer??
	public Response getDicomJ2KImage(
			@Context UriInfo uriInfo,
			@Context HttpServletRequest request,
			@Context HttpServletResponse response,
			@PathParam("studyUid") String studyUid,
			@PathParam("seriesUid") String seriesUid,
			@PathParam("instanceUid") String instanceUid,
			@QueryParam("imageQuality") String imageQuality,
			@QueryParam("transferSyntax") String transferSyntax,
			@QueryParam("contentType") String contentType)
	throws MethodException, ConnectionException
	{
		// String theRIRequest = (request!=null)?(request.getPathInfo()  + "?" + request.getQueryString()):"n/a";
        @SuppressWarnings("deprecation")
		String requestURL = URLDecoder.decode(uriInfo.getRequestUri().toString()); // , "ISO-8859-1");
        getLogger().debug("MIX GET RetrieveInstance request received: {}", requestURL);
		
		String message="";
		ImageQuality iQ = ImageQuality.THUMBNAIL; // set illegal value for RetrieveInstance
		if ((imageQuality != null) && (0 < imageQuality.length()))
			iQ = ImageQuality.getImageQuality(imageQuality);

		if ( ((contentType==null) || (!contentType.contains(applicationDicomJp2))) ||
			 !((iQ==ImageQuality.REFERENCE) || (iQ==ImageQuality.DIAGNOSTIC)) ||
			 ((transferSyntax==null) || 
			  !( (transferSyntax.equals("1.2.840.10008.1.2.4.90") && (iQ==ImageQuality.DIAGNOSTIC)) ||
			     (transferSyntax.equals("1.2.840.10008.1.2.4.91") && (iQ==ImageQuality.REFERENCE))) ) ) { //checks for TS<->IQ
			message="Invalid request (... imageQuality (iQ='" + iQ.getCanonical() + "') must be '70' or '90'; contentType ('" + contentType + "')  must be '" + applicationDicomJp2 + "';\n" +
					"transferSyntax ('" + transferSyntax + "') must be '1.2.840.10008.1.2.4.9x' where x is 1 fot iQ=70 and 0 for iQ=90 ! All explicitly required! ...)";
			return wrapResponse(Status.NOT_ACCEPTABLE, message);
		}
		// temp error (until fully implemented):
		// message = "RetrieveImage is not fully implemented yet. Please use WADO-URI format !";
		// return wrapResponse(Status.INTERNAL_SERVER_ERROR, message);
		
		// 4 DICOM UIDs, 70 or 90 and "application/dicom+jp2" are confirmed; MixGetAndstreamDicomJ2KImage will returns a java  OutputStream!
		return streamResponse(MixGetAndStreamImage(request, response, instanceUid, imageQuality));
	}
	
	// get a DAS cached ID saved in the local cache for short-term
	//      DasCachedDocumentId?repoId={repoId}&docId={docId}
	@GET
	@Path("DasCachedDocumentId")
	@Produces(MediaType.TEXT_PLAIN)
	public Response getCachedEncryptedId(
			@Context UriInfo uriInfo,
			@QueryParam("repoId") String repoId,
			@QueryParam("docId") String docId)
	throws MethodException
	{
        @SuppressWarnings("deprecation")
		String requestURL = URLDecoder.decode(uriInfo.getRequestUri().toString()); // , "ISO-8859-1");
        getLogger().debug("MIX 'GET DASCachedDocumentId' request received. URI: {}", requestURL);

		MixGetDASCachedDocId getDocId = new MixGetDASCachedDocId(repoId, docId);
//		DASCacheIdType dASCacheType = getDocId.getIDFromLocalCache();
		return wrapResponse(Status.OK, getDocId.getIDFromLocalCache());
	}

	// test only!!!
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

		MixGetLucky getLucky = new MixGetLucky(aWord, aNumber);
		LuckyType luckyType = getLucky.crunch();
		return wrapResponse(Status.OK, luckyType);
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

		MixGetLucky getLucky = new MixGetLucky(aWord, aNumber);
		LuckyType luckyType = getLucky.crunch();
		return wrapResponse(Status.OK, luckyType);
	}
	
// ------------------------------------------ support methods --------------------------------------------
	
	private String checkToSwapICN(String theICNgot)
	{
		String theICN = theICNgot;
		
		// trick to swap IPO 4&5 test ICNS to IPO 1&2 mirrors
		if (theICNgot.equalsIgnoreCase("1008689559V859134"))
			theICN = "1012740021V495560"; 
		else if (theICNgot.equalsIgnoreCase("1008689424V686541"))
			theICN = "1012740381V796853"; 
		else if (theICNgot.equalsIgnoreCase("1008689409V873033"))
			theICN = "1012740369V059445"; 
		else if (theICNgot.equalsIgnoreCase("1008689511V752466"))
			theICN = "1012740020V387031"; 
		
		if (!theICN.equalsIgnoreCase(theICNgot))
            getLogger().debug("MIX GET DiagnosticReport -- ICN swap from '{}' to '{}' !!!", theICNgot, theICN);
		 
		return theICN;
	}
	
	private String convertDate(String webDate)
	{
		String dicomDate=null;

		// convert "yyyy-mm-dd" to "yyyymmdd" or return null
		if ((webDate!=null) && (!webDate.isEmpty())) {
			// dicomDate = webDate;
			dicomDate = webDate.replace("-", "");
		}
		
		return dicomDate;
	}
	
	private ImagingStudy convertStudy(Study study)
	throws MethodException
	{
		ImagingStudy imagingStudy= null;
		
		try {
			imagingStudy = MixTranslator.translateStudy(study);
		} 
		catch (URNFormatException ufe) {
			throw new MethodException("URN format exception during study translation: " + ufe.getMessage());
		}
		catch (ParseException pe) {
			throw new MethodException("URN parse exception during study translation: " + pe.getMessage());
		}
		return imagingStudy;
	}
	
	protected DiagnosticReport[] convertStudySetResult(StudySetResult studySetresult)
	throws MethodException
	{
		DiagnosticReport[] dRs = null;
		int numDRs=0;
		try {
			dRs = MixTranslatorV1.convertStudies(studySetresult);
			if (dRs!=null)
				numDRs = dRs.length;
		}
		catch (TranslationException te) {
			throw new MethodException("StudySetResult translation exception: " + te.getMessage());
		}
		// DiagnosticReports diagnosticReports = null;
		// if (numDRs!=0) {
		//	diagnosticReports = new DiagnosticReports(dRs);
		// }
		// return diagnosticReports;
		if (numDRs==0)
			dRs = new DiagnosticReport[0];

		return dRs;
	}

	private StreamingOutput MixGetAndStreamImage(HttpServletRequest request, HttpServletResponse response,
			String instanceURN, String imageQuality) {
		// TODO Auto-generated method stub
		MIXDoGetImage mixDoGetImage = new MIXDoGetImage(instanceURN, imageQuality, request, response);
		return mixDoGetImage.streamImage(request, response, instanceURN, imageQuality);
	}

	private Response wrapResponse(Status status, Object result)
	throws MethodException
	{
		return Response.status(status).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
				TransactionContextFactory.get().getMachineName()).entity(result).build();
	}

	private Response streamResponse(StreamingOutput stream)
	throws MethodException
	{
		return Response.ok(stream).header(TransactionContextHttpHeaders.httpHeaderMachineName, 
				TransactionContextFactory.get().getMachineName()).build();
	}

}
