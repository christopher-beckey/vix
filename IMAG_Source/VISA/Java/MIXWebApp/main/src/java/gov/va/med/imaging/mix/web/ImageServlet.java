package gov.va.med.imaging.mix.web;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;

import java.util.ArrayList;
import java.util.List;
// import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

/**
 * @author vacotittoc
 *
 */
public class ImageServlet
extends AbstractMIXImageServlet
{

	private static final long serialVersionUID = 1746653124236216680L;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXImageServlet#isBadContentType()
	 */
	@Override
	protected boolean isBadContentType(HttpServletRequest request)
	{
		String contentType = request.getParameter("contentType");
		return ((contentType == null) || (contentType.length() == 0) || (!contentType.contains(applicationDicomJp2)));
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXImageServlet#getAcceptableResponseContent()
	 */
	@Override
	protected List<ImageFormat> getAcceptableResponseContent(HttpServletRequest request)
	throws MethodException
	{
		List<ImageFormat> acceptableResponseContent = new ArrayList<ImageFormat>();		
//		String contentType = request.getParameter("contentType");
//		if(contentType != null && contentType.length() > 0 && contentType.contains("application/dicom+jp2"))
////		String acceptType = request.getParameter("accept");
////		if(acceptType != null && acceptType.length() > 0 && acceptType.contains("application/dicom+jp2"))
//		{
//			List<ImageFormat> parsedFormats = parseImageFormatList(contentType); // (acceptType);
//			acceptableResponseContent.addAll(parsedFormats);
//		}
//		else
//		{		
			acceptableResponseContent.add(ImageFormat.DICOMJPEG2000);
////		acceptableResponseContent.add(ImageFormat.TGA);
//		}
////		acceptableResponseContent.add(ImageFormat.ORIGINAL);
//		// should check other parameters and if not met, empty list!
////		String requestType = request.getParameter("accept");
		
		return acceptableResponseContent;
	}
	
//	private List<ImageFormat> parseImageFormatList(String imageFormatList)
//	{	// TODO should not accept other then application/dicom+jp2 --> DICOMJPEG2000
//		List<ImageFormat> formats = new ArrayList<ImageFormat>();
//		for(StringTokenizer commaTokenizer = new StringTokenizer(imageFormatList, ","); commaTokenizer.hasMoreTokens();)
//		{
//			formats.add(ImageFormat.valueOfMimeType(commaTokenizer.nextToken().trim())); 
//		}
//		return formats;
//	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXImageServlet#getImageQuality()
	 */
	@Override
	protected ImageQuality getImageQuality(HttpServletRequest request)
	{
		String imageQualityString = request.getParameter("imageQuality");
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
		return "getRetrieveInstance"; // results in retrieveInstance in URL path...
	}
}
