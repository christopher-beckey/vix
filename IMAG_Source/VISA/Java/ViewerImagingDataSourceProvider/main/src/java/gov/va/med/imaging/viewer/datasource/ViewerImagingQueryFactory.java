/**
 * 
 * Date Created: Apr 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.datasource;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.viewer.business.DeleteImageUrn;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrn;
import gov.va.med.imaging.viewer.business.LogAccessImageUrn;

/**
 * @author vhaisltjahjb
 *
 */
public class ViewerImagingQueryFactory
{
	private final static String RPC_GET_VARIABLE_VALUE = "XWB GET VARIABLE VALUE";
	private final static String RPC_SET_IMAGES_PROPS = "MAGN SET IMAGES PROPS BY IEN";
	private final static String RPC_DELETE_IMAGES = "MAGN DELETE IMAGES BY IEN";
	private final static String RPC_LOG_IMAGE_ACCESSS = "MAGN LOG IMAGE ACCESS BY IEN";


	public static VistaQuery createDeleteImagesQuery(List<DeleteImageUrn> imageUrns)
	{
		VistaQuery query = new VistaQuery(RPC_DELETE_IMAGES);
		
		HashMap<String, String> parameters = new HashMap<String, String>();
		
		for(int i = 0; i < imageUrns.size(); i++)
		{
			parameters.put("\"" + i + "\"", 
					ViewerImagingTranslator.getImageIen(imageUrns.get(i).getValue()) + "^" + 
					(imageUrns.get(i).isDeleteGroup() ? "1" : "0") + "^" +
					imageUrns.get(i).getReason());
		}

		query.addParameter(VistaQuery.LIST, parameters);
		
		return query;
	}
	
	public static VistaQuery createFlagSensitiveImagesQuery(List<FlagSensitiveImageUrn> imageUrns)
	{
		VistaQuery query = new VistaQuery(RPC_SET_IMAGES_PROPS);
		
		HashMap<String, String> parameters = new HashMap<String, String>();
		
		for(int i = 0; i < imageUrns.size(); i++)
		{
			parameters.put("\"" + i + "\"", 
					ViewerImagingTranslator.getImageIen(imageUrns.get(i).getImageUrn()) + 
					"^SENSIMG^" + 
					(imageUrns.get(i).isSensitive() ? "1" : "0"));
		}

		query.addParameter(VistaQuery.LIST, parameters);
		
		return query;
	}
	
	public static VistaQuery createGetUserInformationByUserIdQuery(String userId)
	{		
		VistaQuery msg = new VistaQuery(RPC_GET_VARIABLE_VALUE);
		String arg = "^VA(200," + userId + ",0)";
		msg.addParameter(VistaQuery.REFERENCE, arg);
		return msg;
	}

	public static VistaQuery createLogAccessImagesQuery(
		String patientDfn,
		List<LogAccessImageUrn> imageUrns)
	{
		VistaQuery query = new VistaQuery(RPC_LOG_IMAGE_ACCESSS);
		
		HashMap<String, String> parameters = new HashMap<String, String>();
		
		for(int i = 0; i < imageUrns.size(); i++)
		{
			LogAccessImageUrn logUrn = imageUrns.get(i);
			String imageIen = ViewerImagingTranslator.getImageIen(imageUrns.get(i).getImageUrn());
				
			parameters.put("\"" + i + "\"", 
						imageIen + "^" +
						"A^^" +
						imageIen + "^" +
						logUrn.getAccessReason() + "^" +
						patientDfn + "^1"
						);
		}

		query.addParameter(VistaQuery.LIST, parameters);
		
		return query;
	}
	

}
