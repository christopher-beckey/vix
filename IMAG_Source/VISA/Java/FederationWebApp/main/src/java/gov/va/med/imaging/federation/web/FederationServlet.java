package gov.va.med.imaging.federation.web;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.http.AcceptElementList;
import gov.va.med.imaging.http.exceptions.HttpHeaderParseException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.query.WadoQuery;
import gov.va.med.imaging.wado.query.WadoRequest;
import gov.va.med.imaging.wado.query.exceptions.WadoQueryComplianceException;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class FederationServlet 
extends AbstractFederationServlet
{
	
	public static final List<ImageFormat> acceptableThumbnailResponseTypes;
	public static final List<ImageFormat> acceptableReferenceResponseTypes;
	public static final List<ImageFormat> acceptableDiagnosticResponseTypes;	
	
	static
	{
		acceptableThumbnailResponseTypes = new ArrayList<ImageFormat>();		
		acceptableThumbnailResponseTypes.add(ImageFormat.JPEG);
		acceptableThumbnailResponseTypes.add(ImageFormat.BMP);
		acceptableThumbnailResponseTypes.add(ImageFormat.TGA);
		acceptableThumbnailResponseTypes.add(ImageFormat.ORIGINAL);
		
		acceptableReferenceResponseTypes = new ArrayList<ImageFormat>();		
		acceptableReferenceResponseTypes.add(ImageFormat.DICOMJPEG2000);
//		acceptableReferenceResponseTypes.add(ImageFormat.DICOM);
		acceptableReferenceResponseTypes.add(ImageFormat.TGA);
		acceptableReferenceResponseTypes.add(ImageFormat.PDF);
		acceptableReferenceResponseTypes.add(ImageFormat.DOC);
		acceptableReferenceResponseTypes.add(ImageFormat.RTF);
		acceptableReferenceResponseTypes.add(ImageFormat.TEXT_PLAIN);
		acceptableReferenceResponseTypes.add(ImageFormat.AVI);
		acceptableReferenceResponseTypes.add(ImageFormat.BMP);
		acceptableReferenceResponseTypes.add(ImageFormat.HTML);
		acceptableReferenceResponseTypes.add(ImageFormat.MP3);
		acceptableReferenceResponseTypes.add(ImageFormat.MPG);
		acceptableReferenceResponseTypes.add(ImageFormat.J2K);
		acceptableReferenceResponseTypes.add(ImageFormat.JPEG);
		acceptableReferenceResponseTypes.add(ImageFormat.TIFF);
		acceptableReferenceResponseTypes.add(ImageFormat.XML);
		acceptableReferenceResponseTypes.add(ImageFormat.ORIGINAL);
		
		acceptableDiagnosticResponseTypes = new ArrayList<ImageFormat>();		
		acceptableDiagnosticResponseTypes.add(ImageFormat.DICOMJPEG2000);
//		acceptableDiagnosticResponseTypes.add(ImageFormat.DICOM);
		acceptableDiagnosticResponseTypes.add(ImageFormat.TGA);
		acceptableDiagnosticResponseTypes.add(ImageFormat.PDF);
		acceptableDiagnosticResponseTypes.add(ImageFormat.DOC);
		acceptableDiagnosticResponseTypes.add(ImageFormat.RTF);
		acceptableDiagnosticResponseTypes.add(ImageFormat.TEXT_PLAIN);
		acceptableDiagnosticResponseTypes.add(ImageFormat.AVI);
		acceptableDiagnosticResponseTypes.add(ImageFormat.BMP);
		acceptableDiagnosticResponseTypes.add(ImageFormat.HTML);
		acceptableDiagnosticResponseTypes.add(ImageFormat.MP3);
		acceptableDiagnosticResponseTypes.add(ImageFormat.MPG);
		acceptableDiagnosticResponseTypes.add(ImageFormat.J2K);
		acceptableDiagnosticResponseTypes.add(ImageFormat.JPEG);
		acceptableDiagnosticResponseTypes.add(ImageFormat.TIFF);
		acceptableDiagnosticResponseTypes.add(ImageFormat.XML);
		acceptableDiagnosticResponseTypes.add(ImageFormat.ORIGINAL);
	}
	
	private static final long serialVersionUID = 1798751111376312073L;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getAcceptableDiagnosticResponseTypes()
	 */
	@Override
	protected List<ImageFormat> getAcceptableDiagnosticResponseTypes(boolean includeSubTypes) 
	{
		if(includeSubTypes)
		{
			List<ImageFormat> formats = new ArrayList<ImageFormat>(acceptableDiagnosticResponseTypes);
			formats.add(0, ImageFormat.DICOM); // cannot be at the bottom (ORIGINAL must be last), top doesn't really matter
			formats.add(0, ImageFormat.DICOMJPEG);
			formats.add(0, ImageFormat.DICOMPDF);
			return formats;
		}
		else
		{
			return acceptableDiagnosticResponseTypes;
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getAcceptableReferenceResponseTypes()
	 */
	@Override
	protected List<ImageFormat> getAcceptableReferenceResponseTypes(boolean includeSubTypes) 
	{
		if(includeSubTypes)
		{
			List<ImageFormat> formats = new ArrayList<ImageFormat>(acceptableReferenceResponseTypes);
			formats.add(0, ImageFormat.DICOM); // cannot be at the bottom (ORIGINAL must be last), top doesn't really matter
			formats.add(0, ImageFormat.DICOMJPEG);
			formats.add(0, ImageFormat.DICOMPDF);
			return formats;
		}
		else
		{
			return acceptableReferenceResponseTypes;
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getAcceptableThumbnailResponseTypes()
	 */
	@Override
	protected List<ImageFormat> getAcceptableThumbnailResponseTypes() 
	{
		return acceptableThumbnailResponseTypes;
	}
	
	/**
	 * Constructor of the object.
	 */
	public FederationServlet() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException 
	{
		// turn off sessions?
		HttpSession session = request.getSession(false);
		if(session != null)
			session.invalidate();
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		//FederationQuery federationQuery = null;
		WadoRequest wadoRequest = null;
		WadoQuery wadoQuery = null;
		try
		{
			wadoRequest = createParsedWadoRequest(request);
			wadoQuery = wadoRequest.getWadoQuery();			
	
			initTransactionContext(wadoRequest);
			
			// ImageURN is base32 encoded at this point
			ImageURN imageUrn = wadoQuery.getInstanceUrn();
			GlobalArtifactIdentifier gai = wadoQuery.getGlobalArtifactIdentifier();
			// this servlet uses the wadoQuery to parse the URN into the proper format (handles base32 encoding/decoding)
		
			if(wadoQuery.isGetTxtFile())
			{
				doGetTxtFile(imageUrn, response);
			}
			else // get an image (and maybe TXT file) and return as ZIP stream
			{
				ImageQuality imageQuality = getImageQuality(wadoQuery);
				AcceptElementList contentTypeList = wadoQuery.getContentTypeList();
                getLogger().info("FederationServlet.doGet() --> Accept list from client [{}]", contentTypeList);
				List<ImageFormat> contentTypeWithSubTypeList = wadoQuery.getContentTypeWithSubTypeList();
				List<ImageFormat> acceptableResponseContent = validateContentType(imageQuality, contentTypeList, contentTypeWithSubTypeList);
				streamImageIntoZipStream(imageUrn == null ? gai : imageUrn, imageQuality, acceptableResponseContent, response);
			}
		}
		catch(HttpHeaderParseException httphpX)
		{
			String msg = "FederationServlet.doGet() --> Error parsing Federation HTTP header information: " + httphpX.getMessage();	
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(httphpX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		}
		catch(WadoQueryComplianceException wqcX)
		{
			String msg = "FederationServlet.doGet() --> Request is not a valid Federation query compliance request: " + wqcX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(wqcX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg );	
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "FederationServlet.doGet() --> Routing token formatting error when sending image content: " + rtfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		}
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() 
	throws ServletException 
	{
		// Put your code here
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getUserSiteNumber()
	 */
	@Override
	public String getUserSiteNumber() 
	{
		TransactionContext context = TransactionContextFactory.get();
		return context.getLoggerSiteNumber();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.web.AbstractFederationServlet#getImage(gov.va.med.imaging.ImageURN, gov.va.med.imaging.exchange.business.ImageFormatQualityList, java.io.OutputStream, gov.va.med.imaging.core.interfaces.ImageMetadataNotification)
	 */
	@Override
	public Long getImage(ImageURN imageUrn,
			ImageFormatQualityList requestedFormatQuality,
			OutputStream outStream, ImageMetadataNotification metadataCallback)
	throws MethodException, ConnectionException 
	{
        getLogger().debug("FederationServlet.getImage() --> Image URN [ {}]", imageUrn);
		return getFederationRouter().getInstanceByImageURN(imageUrn, requestedFormatQuality, outStream,	metadataCallback);
	}

	@Override
	public Long getDocument(GlobalArtifactIdentifier gai,
			OutputStream outStream, ImageMetadataNotification imageMetadataNotification)
	throws MethodException, ConnectionException
	{
		return getFederationRouter().getDocumentStreamed(gai, outStream, imageMetadataNotification);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.web.AbstractFederationServlet#getImageTxtFile(gov.va.med.imaging.ImageURN, java.io.OutputStream, gov.va.med.imaging.core.interfaces.ImageMetadataNotification)
	 */
	@Override
	public int getImageTxtFile(ImageURN imageUrn, OutputStream outStream,
			ImageMetadataNotification metadataNotification)
	throws MethodException, ConnectionException 
	{
		return getFederationRouter().getTxtFileByImageURN(imageUrn, outStream, 
				metadataNotification);
	}

	@Override
	protected String getWebAppVersion()
	{
		return "";
	}
	
	protected WadoRequest createParsedWadoRequest(HttpServletRequest request)
	throws HttpHeaderParseException, WadoQueryComplianceException
	{
		return WadoRequest.createParsedPatch83VFTPCompliantWadoRequest(request);
	}

	@Override
	public int getImageTxtFileAsChild(ImageURN imageUrn,
			OutputStream outStream,
			ImageMetadataNotification metadataNotification)
			throws MethodException, ConnectionException
	{
		return getFederationRouter().getTxtFileByImageURNAsChild(imageUrn, outStream, 
				metadataNotification);
	}

	@Override
	public boolean includeTextFile(GlobalArtifactIdentifier gai)
	{
		// only get the text file if the image is a VA image
		return isGaiVA(gai);
	}
}
