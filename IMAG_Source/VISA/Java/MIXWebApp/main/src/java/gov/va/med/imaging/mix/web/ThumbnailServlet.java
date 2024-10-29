/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jul 8, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.mix.web;

import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;

import java.util.ArrayList;
import java.util.List;
// import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

/**
 * @author Julian
 *
 */
public class ThumbnailServlet
extends AbstractMIXImageServlet
{

	private static final long serialVersionUID = 2224568416028047862L;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXImageServlet#isBadContentType()
	 */
	@Override
	protected boolean isBadContentType(HttpServletRequest request)
	{
		String contentType = request.getParameter("contentType");
		return ((contentType == null) || (contentType.length() == 0) || (!contentType.contains(imageJpeg)));
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractHydraImageServlet#getAcceptableResponseContent()
	 */
	@Override
	protected List<ImageFormat> getAcceptableResponseContent(HttpServletRequest request)
	{
		List<ImageFormat> acceptableResponseContent = new ArrayList<ImageFormat>();
//		String contentType = request.getParameter("contentType");
//		if(contentType != null && contentType.length() > 0 && contentType.contains(imageJpeg))
//		{
//			List<ImageFormat> parsedFormats = parseImageFormatList(contentType);
//			acceptableResponseContent.addAll(parsedFormats);
//		}
//		else
//		{		
			acceptableResponseContent.add(ImageFormat.JPEG);
//		}
		return acceptableResponseContent;
	}

//	private List<ImageFormat> parseImageFormatList(String imageFormatList)
//	{	// TODO should not accept other then image/jpeg --> JPEG
//		List<ImageFormat> formats = new ArrayList<ImageFormat>();
//		for(StringTokenizer commaTokenizer = new StringTokenizer(imageFormatList, ","); commaTokenizer.hasMoreTokens();)
//		{
//			formats.add(ImageFormat.valueOfMimeType(commaTokenizer.nextToken().trim())); 
//		}
//		return formats;
//	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractHydraImageServlet#getImageQuality()
	 */
	@Override
	protected ImageQuality getImageQuality(HttpServletRequest request)
	{
		return ImageQuality.THUMBNAIL;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractHydraImageServlet#getOperationName()
	 */
	@Override
	protected String getOperationName()
	{
		return "getRetrieveThumbnail"; // results in retrieveThumbnail in URL path...
	}

}
