package gov.va.med.imaging.mix.web;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
// import java.util.StringTokenizer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.StreamingOutput;

/**
 * @author vacotittoc
 *
 */
public class MIXDoGetImage
extends AbstractMIXDoGetImage
{
	private static final long serialVersionUID = 1746653124236216680L;
	private String imageURN;
	private String imageQ;
	private HttpServletRequest request;
	private HttpServletResponse response;
	//private OutputStream outStream = null;
	
	public MIXDoGetImage()
	{
		// TODO Auto-generated constructor stub
	}
	
	public MIXDoGetImage(String imageURN, String imageQ, HttpServletRequest request, HttpServletResponse response) 
	{
		super();
		this.imageURN = imageURN;
		this.imageQ = imageQ;
		this.request = request;
		this.response = response;
	}

	public StreamingOutput streamImage(HttpServletRequest req, HttpServletResponse resp,
			String instanceUrn, String imageQuality)
		{
			StreamingOutput stream = new StreamingOutput() {
				@Override
				public void write(OutputStream outputStream) throws WebApplicationException, IOException {
					try {
						doGet(request, response);
						// pipe(...); // ???
					} catch (ServletException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			};
			return stream;
	}

	public String getImageURN() {
		return imageURN;
	}

	public OutputStream getOutputStream() 
	throws IOException
	{
		return response.getOutputStream();
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXDoImage#isBadContentType()
	 */
	protected boolean isBadContentType(HttpServletRequest request)
	{
		String contentType = request.getParameter("contentType");
		return ((contentType == null) || (contentType.length() == 0) || (!contentType.contains(applicationDicomJp2)));
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXImageServlet#getAcceptableResponseContent()
	 */
	protected List<ImageFormat> getAcceptableResponseContent(HttpServletRequest request)
	throws MethodException
	{
		List<ImageFormat> acceptableResponseContent = new ArrayList<ImageFormat>();		
		acceptableResponseContent.add(ImageFormat.DICOMJPEG2000);
		
		return acceptableResponseContent;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXDoImage#getImageQuality()
	 */
	protected ImageQuality getImageQuality(HttpServletRequest request)
	{
		String imageQualityString = (imageQ==null)?(request.getParameter("imageQuality")):imageQ;

		if(imageQualityString == null || imageQualityString.length() == 0) {
			getLogger().warn("No imageQuality specified in WADO image request; REFERENCE (70) quality is set!");
			return ImageQuality.REFERENCE; // default
		}
		
		ImageQuality imageQuality = ImageQuality.getImageQuality(imageQualityString);
		if (imageQuality==ImageQuality.THUMBNAIL) {// ImageServlet cannot serve thumbnails for MIX
			getLogger().warn("THUMBNAIL (20) imageQuality is specified in WADO Image request; F o r c e d  REFERENCE (70) quality!");
			return ImageQuality.REFERENCE;
		}
		else if (imageQuality==ImageQuality.DIAGNOSTICUNCOMPRESSED) { // unused format for MIX
			getLogger().warn("DIAGNOSTICUNCOMPRESSED (100 -- retired) imageQuality is specified in WADO Image request; DIAGNOSTIC (90) quality is set!");
			return ImageQuality.DIAGNOSTIC;
		}
		
		return imageQuality;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXImageServlet#getOperationName()
	 */
	@Override
	protected String getOperationName()
	{
		return "retrieveInstance"; // results in retrieveInstance in URL path...
	}
}

