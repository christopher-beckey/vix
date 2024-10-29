/**
 * 
 * Date Created: Apr 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.datasource;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

import gov.va.med.URNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.viewer.business.CaptureUserResult;
import gov.va.med.imaging.viewer.business.DeleteImageUrnResult;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrnResult;
import gov.va.med.imaging.viewer.business.ImageFilterFieldValue;
import gov.va.med.imaging.viewer.business.ImageFilterResult;
import gov.va.med.imaging.viewer.business.ImageProperty;
import gov.va.med.imaging.viewer.business.LogAccessImageUrnResult;
import gov.va.med.imaging.viewer.business.QAReviewReportResult;
import gov.va.med.imaging.viewer.business.TreatingFacilityResult;

/**
 * @author vhaisltjahjb
 *
 */
public class ViewerImagingTranslator
{
	private final static Logger logger = Logger.getLogger(ViewerImagingTranslator.class);
	
	public static List<DeleteImageUrnResult> translateDeleteImagesResult(
			String deleteImagesResult, 
			Map<String, String> imageUrnMap)
	{
		List<DeleteImageUrnResult> rows = new ArrayList<DeleteImageUrnResult>();
		
		String [] lines = StringUtils.Split(deleteImagesResult, StringUtils.NEW_LINE);
		
		for(int i = 0; i < lines.length; i++)
		{
			DeleteImageUrnResult deleteResult = new DeleteImageUrnResult(
					imageUrnMap.get(StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 1)),
					StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 2),
					StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 3)
					);
			rows.add(deleteResult);
		}
		
		return rows;
		
	}
	
	public static String getImageIen(String imageUrn)
	{
		ImageURN urn;
		try {
			urn = URNFactory.create(imageUrn, ImageURN.class);
			if ((urn.getImageId() == null) || (urn.getImageId().isEmpty()))
			{
				return imageUrn;
			}
			else
			{
				return urn.getImageId();
			}
		} catch (URNFormatException e) {
			return imageUrn;
		}
	}
	
	public static List<FlagSensitiveImageUrnResult> translateFlagSensitiveImagesResult(
			String flagSensitiveImagesResult, 
			Map<String, String> imageUrnMap)
	{
		List<FlagSensitiveImageUrnResult> rows = new ArrayList<FlagSensitiveImageUrnResult>();
		
		String [] lines = StringUtils.Split(flagSensitiveImagesResult, StringUtils.NEW_LINE);
		
		for(int i = 0; i < lines.length; i++)
		{
			FlagSensitiveImageUrnResult flagResult = new FlagSensitiveImageUrnResult(
					imageUrnMap.get(StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 1)),
					StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 2),
					StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 3)
					);
			rows.add(flagResult);
		}
		
		return rows;
		
	}

	public static List<LogAccessImageUrnResult> translateLogAccessImagesResult(
			String logAccessImagesResult, 
			Map<String, String> imageUrnMap)
	{
		List<LogAccessImageUrnResult> rows = new ArrayList<LogAccessImageUrnResult>();
		
		String [] lines = StringUtils.Split(logAccessImagesResult, StringUtils.NEW_LINE);
		
		for(int i = 0; i < lines.length; i++)
		{
			LogAccessImageUrnResult logAccessResult = new LogAccessImageUrnResult(
					imageUrnMap.get(StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 1)),
					StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 2),
					StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 3)
					);
			rows.add(logAccessResult);
		}
		
		return rows;
		
	}
	
	public static List<DeleteImageUrnResult> mergeDeleteImagesErrorResult(
			List<DeleteImageUrnResult> deletedList, List<String> p34ImageUrns)
	{
		if (deletedList == null)
		{
			deletedList = new ArrayList<DeleteImageUrnResult>();
		}
		
		for (String p34ImageUrn: p34ImageUrns)
		{
			DeleteImageUrnResult deleteResult = new DeleteImageUrnResult(
				p34ImageUrn,
				"ERROR",
				"Deleting this URN type has not been implemented");
			deletedList.add(deleteResult);
		}

		return deletedList;
		
	}

	public static List<LogAccessImageUrnResult> mergeLogAccessErrorResult(
			List<LogAccessImageUrnResult> logAccessList, List<String> p34ImageUrns)
	{
		if (logAccessList == null)
		{
			logAccessList = new ArrayList<LogAccessImageUrnResult>();
		}

		for (String p34ImageUrn: p34ImageUrns)
		{
		
			LogAccessImageUrnResult logAccessResult = new LogAccessImageUrnResult(
				p34ImageUrn,
				"ERROR",
				"Logging Access of this URN type has not been implemented");
			logAccessList.add(logAccessResult);
		}
		
		return logAccessList;
		
	}
	
	public static List<FlagSensitiveImageUrnResult> mergeFlagSensitiveErrorResult(
			List<FlagSensitiveImageUrnResult> flagSensitiveList, List<String> p34ImageUrns)
	{
		if (flagSensitiveList == null)
		{
			flagSensitiveList = new ArrayList<FlagSensitiveImageUrnResult>();
		}

		for (String p34ImageUrn: p34ImageUrns)
		{
			FlagSensitiveImageUrnResult flagResult = new FlagSensitiveImageUrnResult(
				p34ImageUrn,
				"ERROR",
				"Marking this URN type as sensitive has not been implemented");
			flagSensitiveList.add(flagResult);
		}
		
		return flagSensitiveList;
		
	}
	
	
	public static List<TreatingFacilityResult> convertTreatingFacilities(
			String vistaResult)
	{
		List<TreatingFacilityResult> result = new ArrayList<TreatingFacilityResult>();

		if(vistaResult != null)
		{
			String [] lines = StringUtils.Split(vistaResult.trim(), StringUtils.NEW_LINE);
			if(lines.length <= 0)
			{
				logger.warn("Got empty string results from VistA for treating sites, this shouldn't happen!");
			}
			else if(lines.length > 0)
			{
				for(int i = 0; i < lines.length; i++)
				{
					String [] pieces = StringUtils.Split(lines[i], StringUtils.CARET);
					String visitDate = vistaDate2NormalDate(pieces[2]);
					TreatingFacilityResult res = new TreatingFacilityResult(
						 pieces[0],
						 pieces[1],
						 visitDate,
						 pieces[4]);
					result.add(res);
				}
			}
		}		
		return result;
	}

	public static List<TreatingFacilityResult> convertCvixTreatingFacilities(
			String vistaResult)
	{
		List<TreatingFacilityResult> result = new ArrayList<TreatingFacilityResult>();

		if(vistaResult != null)
		{
			String [] lines = StringUtils.Split(vistaResult.trim(), StringUtils.NEW_LINE);
			if(lines.length <= 0)
			{
				logger.warn("Got empty string results from VistA for treating sites, this shouldn't happen!");
			}
			else if(lines.length > 0)
			{
				for(int i = 0; i < lines.length; i++)
				{
					String [] pieces = StringUtils.Split(lines[i], StringUtils.CARET);
					String visitDate = vistaDate2NormalDate(pieces[2]);
					TreatingFacilityResult res = new TreatingFacilityResult(
						 pieces[0],
						 pieces[1],
						 visitDate,
						 pieces[4]);
					result.add(res);
				}
			}
		}		
		return result;
	}

	private static String vistaDate2NormalDate(String vistaDate) 
	{
		String result = "";

		if (!vistaDate.isEmpty())
		{
			String[] vistaDateTime = vistaDate.split("\\.");
			String yyyymmdd = Integer.toString(Integer.parseInt(vistaDateTime[0]) + 17000000);

			String yyyy = yyyymmdd.substring(0,4);
			String mm = yyyymmdd.substring(4,6);
			String dd = yyyymmdd.substring(6,8);
			
			if (vistaDateTime.length > 1)
			{
				String VistaTime = vistaTime2NormalTime(vistaDateTime[1]);
				String vistaTimeHour = VistaTime.substring(0,2);
				String vistaTimeMin = VistaTime.substring(2,4);
				String vistaTimeSec = VistaTime.substring(4,6);

				result = mm + "/" + dd + "/" + yyyy + " " +
						vistaTimeHour + ":" +
						vistaTimeMin + ":" +
						vistaTimeSec;
			}
			else
			{
				result = mm + "/" + dd + "/" + yyyy;
			}
		}
		return result;
	}

	private static String vistaTime2NormalTime(String vistaTime) 
	{
		String result = vistaTime;
		int add = 6 - vistaTime.length();
		for (int i = 0; i < add; i++)
		{
			result += "0";
		}
		return result;
	}
	
	
	public static List<CaptureUserResult> convertCaptureUsers(
			String vistaResult) 
	{
		List<CaptureUserResult> result = new ArrayList<CaptureUserResult>();

		if(vistaResult != null)
		{
			String [] lines = StringUtils.Split(vistaResult.trim(), StringUtils.CRLF);
			if(lines.length <= 0)
			{
				CaptureUserResult res = new CaptureUserResult(
						 "0",
						 "Got empty string results from VistA calling MAGG CAPTURE USERS"
				);
				result.add(res);
			}
			else if (lines[0].startsWith("0"))
			{
				if (!lines[0].contains("No users found."))
				{
					CaptureUserResult res = new CaptureUserResult(
							 "0",
							 StringUtils.Piece(lines[0], StringUtils.CARET, 2)
					);
					result.add(res);
				}
			}
			else
			{
				for(int i = 1; i < lines.length; i++)
				{
					String [] pieces = StringUtils.Split(lines[i], StringUtils.CARET);
					CaptureUserResult res = new CaptureUserResult(
						 pieces[1],
						 pieces[0]);
					result.add(res);
				}
			}
		}		
		return result;
	}
	
	public static List<ImageFilterResult> convertImageFilters(
			String imageFilters)
	{
		List<ImageFilterResult> rows = new ArrayList<ImageFilterResult>();
		
		String [] lines = StringUtils.Split(imageFilters, StringUtils.NEW_LINE);
		
		for(int i = 0; i < lines.length; i++)
		{
			ImageFilterResult imageFilter = new ImageFilterResult(
					StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 1),
					StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 2),
					StringUtils.MagPiece(lines[i].trim(), StringUtils.CARET, 3)
					);
			rows.add(imageFilter);
		}
		
		return rows;
		
	}

	public static List<ImageFilterFieldValue> convertImageFilterDetail(
			String imageFilterDetail)
	{
		List<ImageFilterFieldValue> rows = new ArrayList<ImageFilterFieldValue>();

		String [] lines = StringUtils.Split(imageFilterDetail, StringUtils.NEW_LINE);
		if (lines.length < 2)
			return null;
		
		String [] fieldValues = StringUtils.Split(lines[1], StringUtils.CARET);
		
		for(int i = 0; i < fieldValues.length; i++)
		{
			if (!fieldValues[i].isEmpty())
			{
				String fieldNumber = Integer.toString(i);
				if (i == 1) 
				{
					fieldNumber = ".01";
				}
				else if (i > 1)
				{
					fieldNumber = Integer.toString(i-1);
				}
				
				ImageFilterFieldValue filterFieldValue = new ImageFilterFieldValue(fieldNumber, fieldValues[i]);
				rows.add(filterFieldValue);
			}
		}
		
		return rows;
		
	}

	public static List<QAReviewReportResult> convertQAReviewReports(String qaReviewReports) 
	{
		List<QAReviewReportResult> rows = new ArrayList<QAReviewReportResult>();

		String [] lines = StringUtils.Split(qaReviewReports, StringUtils.NEW_LINE);
		if (lines.length < 2)
			return null;
		
		for(int i = 1; i < lines.length; i++)
		{
			String line = lines[i];
			String flag = StringUtils.Piece(line, StringUtils.CARET, 1);
			String fromDate = StringUtils.Piece(line, StringUtils.CARET, 2);
			String throughDate = StringUtils.Piece(line, StringUtils.CARET, 3);
			String reportStartDateTime = StringUtils.Piece(line, StringUtils.CARET, 4);
			String reportCompletedDateTime = StringUtils.Piece(line, StringUtils.CARET, 5);
			
			QAReviewReportResult rpt = new QAReviewReportResult(flag, fromDate, throughDate, 
					reportStartDateTime, reportCompletedDateTime);
					
			rows.add(rpt);
		}
		
		return rows;
	}

	public static List<ImageProperty> convertImageProperties(String rtn) 
	{
		List<ImageProperty> rows = new ArrayList<ImageProperty>();

		String [] lines = StringUtils.Split(rtn, StringUtils.CRLF);
		if (lines.length == 1)
			return null;
		
		if (!lines[0].startsWith("1"))
		{
			ImageProperty prop = new ImageProperty("ERROR",rtn);
			rows.add(prop);
			return rows;
		}
		
		for(int i = 1; i < lines.length; i++)
		{
			String line = lines[i];
			String propName = StringUtils.Piece(line, StringUtils.CARET, 1);
			String internalValue = StringUtils.Piece(line, StringUtils.CARET, 3);
			String externalValue = StringUtils.Piece(line, StringUtils.CARET, 4);
			
			ImageProperty prop = new ImageProperty(propName,internalValue + StringUtils.CARET + externalValue);
			rows.add(prop);
		}
		
		return rows;
	}
	
	
}
