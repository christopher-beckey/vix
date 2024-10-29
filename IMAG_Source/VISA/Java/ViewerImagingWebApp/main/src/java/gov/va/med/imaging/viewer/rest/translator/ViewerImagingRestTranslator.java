/**
 * Date Created: Apr 25, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.rest.translator;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.exchange.business.ImageAccessReason;
import gov.va.med.imaging.viewer.ViewerImagingContext;
import gov.va.med.imaging.viewer.business.CaptureUserResult;
import gov.va.med.imaging.viewer.business.DeleteImageUrn;
import gov.va.med.imaging.viewer.business.DeleteImageUrnResult;
import gov.va.med.imaging.viewer.business.DeleteReasonsType;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrn;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrnResult;
import gov.va.med.imaging.viewer.business.ImageFilterField;
import gov.va.med.imaging.viewer.business.ImageFilterFieldValue;
import gov.va.med.imaging.viewer.business.ImageFilterResult;
import gov.va.med.imaging.viewer.business.ImageProperty;
import gov.va.med.imaging.viewer.business.LogAccessImageUrn;
import gov.va.med.imaging.viewer.business.LogAccessImageUrnResult;
import gov.va.med.imaging.viewer.business.PrintReasonsType;
import gov.va.med.imaging.viewer.business.QAReviewReportResult;
import gov.va.med.imaging.viewer.business.StatusReasonsType;
import gov.va.med.imaging.viewer.business.TreatingFacilityResult;
import gov.va.med.imaging.viewer.rest.types.CaptureUserResultType;
import gov.va.med.imaging.viewer.rest.types.CaptureUserResultsType;
import gov.va.med.imaging.viewer.rest.types.DeleteImageUrnResultType;
import gov.va.med.imaging.viewer.rest.types.DeleteImageUrnResultsType;
import gov.va.med.imaging.viewer.rest.types.DeleteImageUrnType;
import gov.va.med.imaging.viewer.rest.types.DeleteImageUrnsType;
import gov.va.med.imaging.viewer.rest.types.FlagSensitiveImageUrnResultType;
import gov.va.med.imaging.viewer.rest.types.FlagSensitiveImageUrnResultsType;
import gov.va.med.imaging.viewer.rest.types.FlagSensitiveImageUrnType;
import gov.va.med.imaging.viewer.rest.types.FlagSensitiveImageUrnsType;
import gov.va.med.imaging.viewer.rest.types.ImageFilterDetailResultType;
import gov.va.med.imaging.viewer.rest.types.ImageFilterResultType;
import gov.va.med.imaging.viewer.rest.types.ImageFilterResultsType;
import gov.va.med.imaging.viewer.rest.types.ImagePropertiesType;
import gov.va.med.imaging.viewer.rest.types.ImagePropertyType;
import gov.va.med.imaging.viewer.rest.types.LogAccessImageUrnResultType;
import gov.va.med.imaging.viewer.rest.types.LogAccessImageUrnResultsType;
import gov.va.med.imaging.viewer.rest.types.LogAccessImageUrnType;
import gov.va.med.imaging.viewer.rest.types.LogAccessImageUrnsType;
import gov.va.med.imaging.viewer.rest.types.QAReviewReportResultType;
import gov.va.med.imaging.viewer.rest.types.QAReviewReportResultsType;
import gov.va.med.imaging.viewer.rest.types.SetImagePropertiesResultsType;
import gov.va.med.imaging.viewer.rest.types.TreatingFacilityResultType;
import gov.va.med.imaging.viewer.rest.types.TreatingFacilityResultsType;
import gov.va.med.imaging.viewer.rest.types.UserInfoType;
import gov.va.med.imaging.viewer.rest.types.UserSecurityKeyType;
import gov.va.med.imaging.viewer.rest.types.UserSecurityKeysType;


/**
 * @author vhaisltjahjb
 *
 */
public class ViewerImagingRestTranslator
{
	private final static Logger logger = Logger.getLogger(ViewerImagingContext.class);
	
	public static List<DeleteImageUrn> translateImageUrns(DeleteImageUrnsType imageUrns) 
	{
		if(imageUrns == null)
			return null;
		
		String defaultReason = imageUrns.getDefaultDeleteReason();
				
		List<DeleteImageUrn> result = new ArrayList<DeleteImageUrn>();
		
		for(DeleteImageUrnType item : imageUrns.getDeleteImageUrns())
		{
			if ((item.getReason() == null) || item.getReason().isEmpty())
			{
				if (defaultReason != null)
				{
					item.setReason(defaultReason);
				}
			}
			if ((item.getDeleteGroup() == null) || item.getDeleteGroup().isEmpty())
			{
				item.setDeleteGroup("false");
			}
			result.add(translateDeleteImageUrn(item));
		}
		return result;
	}

	private static DeleteImageUrn translateDeleteImageUrn(
			DeleteImageUrnType item) {
		return new DeleteImageUrn(
				item.getValue(),
				(item.getDeleteGroup().equals("true") ? true : false),
				item.getReason());
	}

	public static DeleteImageUrnResultsType translateDeleteImageUrnResults(List<DeleteImageUrnResult> deleteImageUrns)
	{
		if(deleteImageUrns == null)
			return null;
		
		DeleteImageUrnResultType[] result = new DeleteImageUrnResultType[deleteImageUrns.size()];
		for(int i = 0; i < deleteImageUrns.size(); i++)
		{
			result[i] = translate(deleteImageUrns.get(i));			
		}
		return new DeleteImageUrnResultsType(result);
		
	}
	
	public static DeleteImageUrnResultType translate(DeleteImageUrnResult deleteImageUrnResult)
	{
		return new DeleteImageUrnResultType(
				deleteImageUrnResult.getValue(),
				deleteImageUrnResult.getResult().equals("1")?"SUCCESS":"ERROR",
				deleteImageUrnResult.getResult().equals("1")?"":"" + deleteImageUrnResult.getMsg()
				);
	}

	public static DeleteReasonsType translateDeleteReasons(
			List<ImageAccessReason> routerResult) {
		
		String[] deleteReasons = new String[routerResult.size()];
		int idx = 0;
		for(ImageAccessReason delReason : routerResult)
		{
			deleteReasons[idx] = delReason.getDescription();
			idx++;
		}
		
		return new DeleteReasonsType(deleteReasons);
	}

	public static PrintReasonsType translatePrintReasons(
			List<ImageAccessReason> routerResult) 
	{
	
		String[] printReasons = new String[routerResult.size()];
		int idx = 0;
		for(ImageAccessReason prtReason : routerResult)
		{
			printReasons[idx] = prtReason.getDescription();
			idx++;
		}
		
		return new PrintReasonsType(printReasons);
	}
	
	public static StatusReasonsType translateStatusReasons(
			List<ImageAccessReason> routerResult) 
	{
	
		String[] statReasons = new String[routerResult.size()];
		int idx = 0;
		for(ImageAccessReason statReason : routerResult)
		{
			statReasons[idx] = statReason.getDescription();
			idx++;
		}
		
		return new StatusReasonsType(statReasons);
	}

	public static List<FlagSensitiveImageUrn> translateImageUrns(FlagSensitiveImageUrnsType imageUrns) 
	{
		if(imageUrns == null)
			return null;
		
		String defaultSensitive = imageUrns.getDefaultSensitive();
		
		List<FlagSensitiveImageUrn> result = new ArrayList<FlagSensitiveImageUrn>();
		
		for(FlagSensitiveImageUrnType item : imageUrns.getFlagSensitiveImageUrns())
		{
			if ((item.getSensitive() == null) || item.getSensitive().isEmpty())
			{
				if (defaultSensitive != null)
				{
					item.setSensitive(defaultSensitive);
				}
			}
			
			result.add(translateFlagSensitiveImageUrn(item));
		}
		return result;
	}

	private static FlagSensitiveImageUrn translateFlagSensitiveImageUrn(
			FlagSensitiveImageUrnType item) {
		return new FlagSensitiveImageUrn(
				item.getImageUrn(),
				(item.getSensitive().equals("true") ? true : false));
	}


	public static FlagSensitiveImageUrnResultsType translateFlagSensitiveImageUrnResults(List<FlagSensitiveImageUrnResult> imageUrns)
	{
		if(imageUrns == null)
			return null;
		
		FlagSensitiveImageUrnResultType[] result = new FlagSensitiveImageUrnResultType[imageUrns.size()];
		for(int i = 0; i < imageUrns.size(); i++)
		{
			result[i] = translate(imageUrns.get(i));			
		}
		return new FlagSensitiveImageUrnResultsType(result);
	}
	
	public static FlagSensitiveImageUrnResultType translate(FlagSensitiveImageUrnResult imageUrnResult)
	{
		return new FlagSensitiveImageUrnResultType(
				imageUrnResult.getImageUrn(),
				imageUrnResult.getResult().equals("1")?"SUCCESS":"ERROR",
				imageUrnResult.getResult().equals("1")?"":"" + imageUrnResult.getMsg()
				);
	}

	public static UserInfoType translateUserInfo(List<String> routerResult) 
	{
		if(routerResult == null)
			return null;
		
		String[] securityKeys = new String[routerResult.size()-1];
		for(int i = 0; i < routerResult.size()-1; i++)
		{
            logger.debug("key: {}", routerResult.get(i));
			securityKeys[i] = routerResult.get(i);			
		}
		
		String userInfo = routerResult.get(routerResult.size() - 1);
        logger.debug("userInfo: {}", userInfo);
		String[] user = userInfo.split("\\^");
		String userName = (user.length > 0) ? (user[0]) : ("");
		String userInitials = (user.length > 1) ? (user[1]) : ("");
		
		return new UserInfoType(userName, userInitials, new UserSecurityKeysType(securityKeys));
	}

	public static List<LogAccessImageUrn> translateImageUrns(LogAccessImageUrnsType imageUrns) 
	{
		if(imageUrns == null)
			return null;
		
		String defaultAccessReason = imageUrns.getDefaultLogAccessReason();
		
		List<LogAccessImageUrn> result = new ArrayList<LogAccessImageUrn>();
		
		for(LogAccessImageUrnType item : imageUrns.getLogAccessImageUrns())
		{
			if ((item.getReason() == null) || item.getReason().isEmpty())
			{
				if (defaultAccessReason != null)
				{
					item.setReason(defaultAccessReason);
				}
			}
			
			result.add(translateLogAccessImageUrn(item));
		}
		return result;
	}

	private static LogAccessImageUrn translateLogAccessImageUrn(
			LogAccessImageUrnType item) {
		return new LogAccessImageUrn(
				item.getValue(),
				item.getReason());
	}

	public static LogAccessImageUrnResultsType translateLogAccessImageUrnResults(
			List<LogAccessImageUrnResult> imageUrns)
	{
		if(imageUrns == null)
			return null;
		
		LogAccessImageUrnResultType[] result = new LogAccessImageUrnResultType[imageUrns.size()];
		for(int i = 0; i < imageUrns.size(); i++)
		{
			result[i] = translate(imageUrns.get(i));			
		}
		return new LogAccessImageUrnResultsType(result);
	}
	
	public static LogAccessImageUrnResultType translate(LogAccessImageUrnResult imageUrnResult)
	{
		return new LogAccessImageUrnResultType(
				imageUrnResult.getImageUrn(),
				imageUrnResult.getResult().equals("1")?"SUCCESS":"ERROR",
				imageUrnResult.getResult().equals("1")?"":"" + imageUrnResult.getMsg()
				);
	}
	

	public static TreatingFacilityResultsType translateTreatingFacilityResults(
			List<TreatingFacilityResult> treatingFacilities)
	{
		if(treatingFacilities == null)
			return null;
		
		TreatingFacilityResultType[] result = new TreatingFacilityResultType[treatingFacilities.size()];
		for(int i = 0; i < treatingFacilities.size(); i++)
		{
			result[i] = translate(treatingFacilities.get(i));			
		}
		return new TreatingFacilityResultsType(result);
	}	
	
	public static TreatingFacilityResultType translate(TreatingFacilityResult treatingFacilityResult)
	{
		return new TreatingFacilityResultType(
				treatingFacilityResult.getInstitutionIEN(),
				treatingFacilityResult.getInstitutionName(),
				treatingFacilityResult.getCurrentDateOnRecord(),
				treatingFacilityResult.getFacilityType()
			);
	}

	
	public static CaptureUserResultsType translateCaptureUserResults(
			List<CaptureUserResult> captureUsers)
	{
		if(captureUsers == null)
			return null;
		
		CaptureUserResultType[] result = new CaptureUserResultType[captureUsers.size()];
		for(int i = 0; i < captureUsers.size(); i++)
		{
			result[i] = translate(captureUsers.get(i));			
		}
		return new CaptureUserResultsType(result);
	}	
	
	public static CaptureUserResultType translate(CaptureUserResult captureUserResult)
	{
		return new CaptureUserResultType(
				captureUserResult.getUserId(),
				captureUserResult.getUserName()
			);
	}

	public static ImageFilterResultsType translate(List<ImageFilterResult> imageFilters) {
		if(imageFilters == null)
			return null;
		
		ImageFilterResultType[] result = new ImageFilterResultType[imageFilters.size()];
		for(int i = 0; i < imageFilters.size(); i++)
		{
			result[i] = translate(imageFilters.get(i));			
		}
		return new ImageFilterResultsType(result);
	}

	private static ImageFilterResultType translate(ImageFilterResult imageFilterResult) {
		return new ImageFilterResultType(
				imageFilterResult.getFilterIEN(),
				imageFilterResult.getFilterName(),
				imageFilterResult.getUserId()
			);
	}

	public static ImageFilterDetailResultType translateImageFilterFieldValues(List<ImageFilterFieldValue> imageFilterFieldValues) {
		if(imageFilterFieldValues == null)
			return null;
		
		ImageFilterDetailResultType result = new ImageFilterDetailResultType();
		
		for (ImageFilterFieldValue imageFilterFieldValue : imageFilterFieldValues)
		{
			if (ImageFilterField.CAPTUREDBY.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setCapturedBy(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.CLASSINDEX.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setClassIndex(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.COLUMNWIDTHS.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setColumnWidths(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.DATEFROM.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setDateFrom(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.DATETHROUGH.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setDateThrough(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.DAYRANGE.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setDayRange(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.DESCRIPTIONCONTAINS.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setDescriptionContains(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.EVENTINDEX.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setEventIndex(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.FILTERIEN.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setFilterIEN(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.FILTERNAME.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setFilterName(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.IMAGESTATUS.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setImageStatus(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.ORIGIN.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setOrigin(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.PACKAGEINDEX.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setPackageIndex(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.PERCENT.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setPercent(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.RELATIVERANGE.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setRelativeRange(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.SPECIALTIESINDEX.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setSpecialtiesIndex(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.TYPEINDEX.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setTypeIndex(imageFilterFieldValue.getFieldValue());
			}
			else if (ImageFilterField.USECAPTUREDATES.getFieldNumber().equals(imageFilterFieldValue.getFieldName()))
			{
				result.setUseCaptureDates(imageFilterFieldValue.getFieldValue());
			}
				
		}
		return result;
	}

	public static QAReviewReportResultsType translateQAReviewReportResults(List<QAReviewReportResult> qaReviewReports) 
	{
		if(qaReviewReports == null)
			return null;
		
		QAReviewReportResultType[] result = new QAReviewReportResultType[qaReviewReports.size()];
		for(int i = 0; i < qaReviewReports.size(); i++)
		{
			result[i] = translate(qaReviewReports.get(i));			
		}
		return new QAReviewReportResultsType(result);
	}	
	
	public static QAReviewReportResultType translate(QAReviewReportResult qaReviewReport)
	{
		return new QAReviewReportResultType(
				qaReviewReport.getReportFlags(),
				qaReviewReport.getFromDate(),
				qaReviewReport.getThroughDate(),
				qaReviewReport.getReportStartDateTime(),
				qaReviewReport.getReportCompletedDateTime()
			);
	}

	public static List<ImageProperty> translateImageProperties(ImagePropertiesType imageProperties) 
	{
		if(imageProperties == null)
			return null;
		
		List<ImageProperty> result = new ArrayList<ImageProperty>();
		
		for(ImagePropertyType item : imageProperties.getImageProperties())
		{
			result.add(translateImageProperty(item));
		}
		return result;
	}
	
	private static ImageProperty translateImageProperty(ImagePropertyType item) 
	{
		return new ImageProperty(item.getIen(), item.getFlags(), item.getName(), item.getValue());
	}
	
	public static ImagePropertiesType translateImageProperties(List<ImageProperty> imageProperties) 
	{
		if(imageProperties == null)
			return null;
		
		ImagePropertyType[] result = new ImagePropertyType[imageProperties.size()];
		for(int i = 0; i < imageProperties.size(); i++)
		{
			result[i] = translate(imageProperties.get(i));			
		}

		
		return new ImagePropertiesType(result);
	}

	private static ImagePropertyType translate(ImageProperty imageProperty) 
	{
		return new ImagePropertyType(imageProperty.getIen(), imageProperty.getFlags(), imageProperty.getName(), imageProperty.getValue());
	}
	
	
	public static SetImagePropertiesResultsType translateSetImagePropertiesResults(List<String> imageProperties)
	{
		if(imageProperties == null)
			return null;
		
		String[] result = imageProperties.toArray(new String[imageProperties.size()]);
		return new SetImagePropertiesResultsType(result);
	}
	
}
