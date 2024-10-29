package gov.va.med.imaging.vistaimagingdatasource;

import gov.va.med.HealthSummaryURN;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.ImagingLogEvent;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ImageAccessReasonType;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.protocol.vista.VistaTranslatorUtility;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * 
 * @author vhaiswbeckec
 *
 */
public class VistaImagingQueryFactory
{
	private static final Logger LOGGER = Logger.getLogger(VistaImagingQueryFactory.class);
	private static final String RPC_XUS_GET_DIVISIONS = "XUS DIVISION GET";
	public final static String MENU_SUBSCRIPT = "200.03";
	public final static String DELEGATE_SUBSCRIPT = "200.19";

	// rpc calls made to other packages
	private final static String RPC_CONVERT_ICN_TO_DFN = "VAFCTFU CONVERT ICN TO DFN";
	private final static String RPC_CONVERT_DFN_TO_ICN = "VAFCTFU CONVERT DFN TO ICN";
	private final static String RPC_GET_VARIABLE_VALUE = "XWB GET VARIABLE VALUE";
	
	// MAG rpc calls	
	private final static String RPC_MAG_GET_GROUPS = "MAG4 PAT GET IMAGES";
	private final static String RPC_MAG_GET_STUDY_IMAGES = "MAGG GROUP IMAGES";
	private final static String RPC_MAG_REPORT = "MAGGRPT";
	private final static String RPC_MAG_GET_NETLOC = "MAG GET NETLOC";
	private final static String RPC_MAG_MAGGUSER2 = "MAGGUSER2";
	private final static String RPC_MAG_DOD_GET_STUDIES_BY_IEN = "MAG DOD GET STUDIES IEN";
	private final static String RPC_MAG_IMAGE_CURRENT_INFO = "MAG IMAGE CURRENT INFO";
	private final static String RPC_MAG_NEW_SOP_INSTANCE_UID = "MAG NEW SOP INSTANCE UID";
	private final static String RPC_MAG_ACTION_LOG = "MAGGACTION LOG";
	private final static String RPC_MAG_WRKS_UPDATES = "MAGG WRKS UPDATES";
	private final static String RPC_MAG_OFFLINE_IMAGE_ACCESSED = "MAGG OFFLINE IMAGE ACCESSED";	
	private final static String RPC_MAG_INSTALL = "MAGG INSTALL";
	private final static String RPC_MAG_GET_IMAGE_INFO = "MAG4 GET IMAGE INFO";
	private final static String RPC_MAG_SYS_GLOBAL_NODE = "MAGG SYS GLOBAL NODE";
	private final static String RPC_MAG_DEV_FIELD_VALUES = "MAGG DEV FIELD VALUES";
	private final static String RPC_MAG_PAT_FIND = "MAGG PAT FIND";
	private final static String RPC_MAG_PAT_INFO = "MAGG PAT INFO";
	private final static String RPC_MAG_PAT_PHOTOS = "MAGG PAT PHOTOS";
	private final static String RPC_MAG_CPRS_RAD_EXAM = "MAGG CPRS RAD EXAM";
	private final static String RPC_MAG_CPRS_TIU_NOTE = "MAG3 CPRS TIU NOTE";
	private final static String RPC_MAGN_CPRS_IMAGE_LIST = "MAGN CPRS IMAGE LIST";
	private final static String RPC_MAGN_PATIENT_IMAGE_LIST = "MAGN PATIENT IMAGE LIST";	
	private final static String RPC_MAG_BROKER_SECURITY = "MAG BROKER SECURITY";
	
	private final static String RPC_MAG_USER_KEYS = "MAGGUSERKEYS";
	
	private final static String RPC_MAG_IMAGE_ALLOW_ANNOTATE = "MAG ANNOT IMAGE ALLOW";
	private final static String RPC_MAGJ_GET_TREATING_LIST = "MAGJ GET TREATING LIST";
	
	private final static String RPC_MAGG_REASON_LIST = "MAGG REASON LIST";
	private final static String RPC_MAGG_VERIFY_ESIG = "MAGG VERIFY ESIG";
	private final static String RPC_MAGGHSLIST = "MAGGHSLIST";
	private final static String RPC_MAGGHS = "MAGGHS";
	
	private final static String RPC_GET_TIMEOUT_PARAMETERS = "MAGG GET TIMEOUT";
	
	private final static String RPC_MAG4_FILTER_GET_LIST = "MAG4 FILTER GET LIST";
	
	private final static String RPC_MAG_IMAGE_LIST = "MAG4 IMAGE LIST";


	// we can leave QA Check off because this will allow "bad" images to go to the VA but we still
	// will get a QA error message which will prevent those images from going to the DOD
	private final static String MAG_QA_CHECK = "1"; // 1 indicates no QA check
	private final static int MAG_MAX_PATIENT_RESULT_COUNT = 100;
	
	private final static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS"); // for DICOM UID generation only
	
	/**
	 * 
	 * @param patientICN
	 * @return
	 * @throws MethodException
	 */
	public static VistaQuery createGetPatientDFNVistaQuery(String patientICN) 
	{
		VistaQuery query = new VistaQuery(RPC_CONVERT_ICN_TO_DFN);
		query.addParameter(VistaQuery.LITERAL, patientICN);
		
		logVistaQueryRequest(query);
		
		return query;
	}	
	
	public static VistaQuery createGetPatientICNVistaQuery(String patientDFN) 
	{
		VistaQuery query = new VistaQuery(RPC_CONVERT_DFN_TO_ICN);
		query.addParameter(VistaQuery.LITERAL, patientDFN);
		
		logVistaQueryRequest(query);
		
		return query;
	}	
	
	/**
	 * Create a VistQuery instance that can be used to execute a
	 * RPC_MAG_GET_STUDIES RPC call on Vista.
	 * The return from the RPC call is a list of studies matching the
	 * class, dates, package, types, specialty and origin filter fields.
	 * The response is a list of caret-delimited Strings, each of which
	 * is a study description including the study IEN.
	 * ex:
	 * 1^Class: CLIN - 
	 * Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0
	 * 1^WAS^NURSING NOTE^09/28/2001 00:01^NOTE^2^CONSULT NURSE MEDICAL WOUND SPEC INPT^NOTE^CLIN^CONSULT^NURSING^WOUND ASSESSMENT^VA^09/28/2001 01:35^IMAGPROVIDERONETWOSIX,ONETWOSIX^1752|1752^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001753.JPG^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001753.ABS^CONSULT NURSE MEDICAL WOUND SPEC INPT^3010928^11^NOTE^09/28/2001^36^M^A^^^2^1^WAS^^^711^IMAGPATIENT1055,1055^CLIN^^^
	 * 2^WAS^OPHTHALMOLOGY^08/20/2001 00:01^OPH^10^Ophthalmology^NOTE^CLIN^IMAGE^EYE CARE^^VA^08/20/2001 22:32^IMAGPROVIDERONETWOSIX,ONETWOSIX^1783|1783^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001784.DCM^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001784.ABS^Ophthalmology^3010820^11^OPH^08/20/2001^41^M^A^^^10^1^WAS^^^711^IMAGPATIENT1055,1055^CLIN^^^^
	 * 
	 * @param patientDfn
	 * @param filter
	 * @return
	 */
	public static VistaQuery createGetGroupsVistaQuery(String patientDfn, StudyFilter filter)
    {
	    String toDate = "";
		String fromDate = "";
		String studyPackage = "";
		String studyClass = "";
		String studyTypes = "";
		String studyEvent = "";
		String studySpecialtiy = "";
		String studyOrigin = "";
		
		if(filter != null) 
		{
			fromDate = VistaTranslatorUtility.convertDateToRpcFormat(filter.getFromDate());
			toDate = VistaTranslatorUtility.convertDateToRpcFormat(filter.getToDate());
			studyPackage = filter.getStudy_package();
			studyClass = filter.getStudy_class();
			studyTypes = filter.getStudy_type();
			studyEvent = filter.getStudy_event();
			studySpecialtiy = filter.getStudy_specialty();
			studyOrigin = filter.getOrigin();
		}
		
		VistaQuery query = new VistaQuery(RPC_MAG_GET_GROUPS); // really returns groups
		//							Note: a Study has 1.. Groups and a Group can have 1.. Series!
		query.addParameter(VistaQuery.LITERAL, patientDfn);
		query.addParameter(VistaQuery.LITERAL, studyPackage); // PACKAGE
		query.addParameter(VistaQuery.LITERAL, studyClass); // CLASS
		query.addParameter(VistaQuery.LITERAL, studyTypes); // TYPES
		query.addParameter(VistaQuery.LITERAL, studyEvent); // EVENT - tried WOUND ASSESSMENT
		query.addParameter(VistaQuery.LITERAL, studySpecialtiy); // SPEC - tried RADIOLOGY
		query.addParameter(VistaQuery.LITERAL, fromDate); // FROM DATE
		query.addParameter(VistaQuery.LITERAL, toDate); // TO DATE
		query.addParameter(VistaQuery.LITERAL, studyOrigin); // ORIGIN
		
		logVistaQueryRequest(query);
		
	    return query;
    }
	
	/**
	 * This version should be used at sites without P119 that do not have the new parameter (FLAGS) for deleted images
	 * 
	 * @param studyMap
	 * @param patientDfn
	 * @return
	 */
	public static VistaQuery createGetStudiesByIenVistaQuery(Map<?,?> studyMap, String patientDfn, StudyLoadLevel studyLoadLevel)
	{	
		return createGetStudiesByIenVistaQuery(studyMap, patientDfn, studyLoadLevel, null);
	}
	
	/**
	 * This version makes use of the studyDeletedImageState and should be used by Patch 119 (and later)
	 * @param studyMap
	 * @param patientDfn
	 * @param studyLoadLevel
	 * @param studyDeletedImageState
	 * @return
	 */
	public static VistaQuery createGetStudiesByIenVistaQuery(Map<?,?> studyMap, String patientDfn, 
			StudyLoadLevel studyLoadLevel, StudyDeletedImageState studyDeletedImageState)
	{	
		VistaQuery query = new VistaQuery(RPC_MAG_DOD_GET_STUDIES_BY_IEN); // IN: Groups; Out: Studies
		query.addParameter(VistaQuery.LIST, studyMap);
		query.addParameter(VistaQuery.LITERAL, patientDfn);		
		query.addParameter(VistaQuery.LITERAL, studyLoadLevel.isIncludeImages() ? "0" : "1");
		
		if(studyDeletedImageState != null)
			// VAI-678: changed "D" to DS" and "" to "S" per Zach to get "seriesDescription"
			query.addParameter(VistaQuery.LITERAL, (studyDeletedImageState == StudyDeletedImageState.includesDeletedImages ? "DS" : "S"));
				
		logVistaQueryRequest(query);
		
		return query;
	}

	/**
	 * This version should be used at sites without P119 that do not have the new parameter (FLAGS) for deleted images
	 * 
	 * @param studyMap
	 * @param patientDfn
	 * @return
	 */
	public static VistaQuery createGetSingleStudyFromBothDataStructuresByCprsIdentifierVistaQuery(Map<?,?> studyMap, String patientDfn,StudyFilter filter,  StudyLoadLevel studyLoadLevel)
	{
		VistaQuery query = new VistaQuery(RPC_MAGN_CPRS_IMAGE_LIST); // IN: Groups; Out: Studies
		
		Map<String,String> study = new HashMap<String,String>();
		StudyURN studyUrn = (StudyURN)filter.getStudyId();
		String studyIen = studyUrn.getImagingIdentifier();
		study.put("1", studyIen);
		query.addParameter(VistaQuery.LIST, study);
		query.addParameter(VistaQuery.LITERAL, "1");
		
		logVistaQueryRequest(query);
		
		return query;
	}

	/**
	 * This version should be used at sites without P119 that do not have the new parameter (FLAGS) for deleted images
	 * 
	 * @param studyMap
	 * @param patientDfn
	 * @return
	 */
	public static VistaQuery createGetStudiesFromBothDataStructuresByPatientVistaQuery(Map<?,?> studyMap, String patientDfn,StudyFilter filter,  StudyLoadLevel studyLoadLevel)
	{	
		VistaQuery query = new VistaQuery(RPC_MAGN_PATIENT_IMAGE_LIST); // IN: Groups; Out: Studies
		
		query.addParameter(VistaQuery.LITERAL, "DFN");
		query.addParameter(VistaQuery.LITERAL, patientDfn);
		query.addParameter(VistaQuery.LITERAL, "1");
		query.addParameter(VistaQuery.LITERAL, "");
		
		logVistaQueryRequest(query);
		
		return query;
	}

	/**
	 * Create a VistaQuery to get a single Study report given the IEN.
	 * 
	 * @param ien
	 * @return
	 */
	public static VistaQuery createGetReportVistaQuery(String ien)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_REPORT);
		query.addParameter(VistaQuery.LITERAL, ien);
		query.addParameter(VistaQuery.LITERAL, MAG_QA_CHECK); // QA Check
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetStudyImagesVistaQuery(String studyIen)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_GET_STUDY_IMAGES);
		query.addParameter(VistaQuery.LITERAL, studyIen);
		query.addParameter(VistaQuery.LITERAL, MAG_QA_CHECK); // NO QA CHECK
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetNetworkLocationsVistaQuery()
	{
		VistaQuery query = new VistaQuery(RPC_MAG_GET_NETLOC);
		query.addParameter(VistaQuery.LITERAL, "ALL");
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetImagingSiteParametersQuery(String workstationId)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_MAGGUSER2);
		query.addParameter(VistaQuery.LITERAL, workstationId);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createNotifyArchiveOperatorQuery(String filename, String imageIen)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_OFFLINE_IMAGE_ACCESSED);
		query.addParameter(VistaQuery.LITERAL, filename);
		query.addParameter(VistaQuery.LITERAL, imageIen);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetMagInstalledVersionsQuery()
	{
		VistaQuery query = new VistaQuery(RPC_MAG_INSTALL);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createSessionQuery(String workstationId)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_WRKS_UPDATES);
		query.addParameter(VistaQuery.LITERAL, workstationId + "^^^^^^^^^");
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createLogImageAccessQuery(boolean isDodImage, String userDuz, 
			String imageIen, String patientDFN, String userSiteNumber)
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		VistaQuery query = new VistaQuery(RPC_MAG_ACTION_LOG);
		
		StringBuilder logParamBuilder = new StringBuilder();
		
		if(isDodImage)
		{
			LOGGER.info("Creating query to log VA access to DOD image");
			// if the image is from the DOD, then the person looking at it is always from the VA, no reason
			// to look at the user site number field
			
			// need to put the DOD Image id into the proper place
			// also need to put in RDODVA to indicate user is from the VA accessing a DOD image
			// we don't put the image Id into the IEN field but the additional field since this is a DOD identifier
			logParamBuilder.append("RVDODVA^" + userDuz + "^");
			logParamBuilder.append("^Wrks^" + patientDFN + "^1^");
			logParamBuilder.append(imageIen);
			logParamBuilder.append("|");
			logParamBuilder.append(transactionContext.getTransactionId());
			logParamBuilder.append("|");
			logParamBuilder.append(transactionContext.getSiteNumber());
			logParamBuilder.append("|");
		}
		else
		{
			if(ExchangeUtil.isSiteDOD(userSiteNumber))
			{
				// image is from the VA but the user is from the DOD, so no workstation to use
				LOGGER.info("Creating query to log DOD access to VA image");
				logParamBuilder.append("RVVADOD^" + userDuz + "^");
				logParamBuilder.append(imageIen + "^DOD^");
				logParamBuilder.append(patientDFN + "^1^");				
				logParamBuilder.append(""); // no image identifier since VA image
				logParamBuilder.append("|");
				logParamBuilder.append(transactionContext.getTransactionId());
				logParamBuilder.append("|");
				logParamBuilder.append(transactionContext.getLoggerSiteNumber());
				logParamBuilder.append("|");
				logParamBuilder.append(transactionContext.getLoggerFullName());				
			}
			else
			{
				// image is from the VA and the user is from the VA (V2V)
				LOGGER.info("Creating query to log VA access to VA image");
				logParamBuilder.append("RVVAVA^" + userDuz + "^");
				logParamBuilder.append(imageIen + "^Wrks^");
				logParamBuilder.append(patientDFN + "^1^");
				logParamBuilder.append(""); // no image identifier since VA image
				logParamBuilder.append("|");
				logParamBuilder.append(transactionContext.getTransactionId());
				logParamBuilder.append("|");
				logParamBuilder.append(transactionContext.getSiteNumber());
				logParamBuilder.append("|");
				logParamBuilder.append(""); // don't need user full name since using real person DUZ
			}			
		}
        LOGGER.debug("Image Access Logging Parameter '{}'", logParamBuilder.toString());
		query.addParameter(VistaQuery.LITERAL, logParamBuilder.toString());
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createLogPatientIdMismatchQuery(String imageIen, String patientDFN)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_ACTION_LOG);
		
		StringBuilder copyParamBuilder = new StringBuilder();
		copyParamBuilder.append("IMGMM");
		copyParamBuilder.append("^^");
		copyParamBuilder.append(imageIen);
		copyParamBuilder.append("^ICN/SSN mismatch^");
		copyParamBuilder.append(patientDFN);
		copyParamBuilder.append("^1");
		query.addParameter(VistaQuery.LITERAL, copyParamBuilder.toString());
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createLogImageCopyQuery(ImageAccessLogEvent event)
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		VistaQuery query = new VistaQuery(RPC_MAG_ACTION_LOG);
		
		StringBuilder copyParamBuilder = new StringBuilder();
		copyParamBuilder.append(event.getReasonCode());
		copyParamBuilder.append("^^");
		copyParamBuilder.append(event.getDecodedImageIen());
		copyParamBuilder.append("^Copy Image^");
		copyParamBuilder.append(event.getPatientDfn());
		copyParamBuilder.append("^1");
		copyParamBuilder.append("^");
		
		if((event.getReasonDescription() != null) && (event.getReasonDescription().length() > 0))
		{			
			copyParamBuilder.append(event.getReasonDescription());		
		}
		copyParamBuilder.append("|");
		copyParamBuilder.append(transactionContext.getTransactionId());
		query.addParameter(VistaQuery.LITERAL, copyParamBuilder.toString());
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createLogImagePrintQuery(ImageAccessLogEvent event)
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		VistaQuery query = new VistaQuery(RPC_MAG_ACTION_LOG);
		
		StringBuilder copyParamBuilder = new StringBuilder();
		copyParamBuilder.append(event.getReasonCode());
		copyParamBuilder.append("^^");
		copyParamBuilder.append(event.getDecodedImageIen());
		copyParamBuilder.append("^Print Image^");
		copyParamBuilder.append(event.getPatientDfn());
		copyParamBuilder.append("^1");
		copyParamBuilder.append("^");
		
		if((event.getReasonDescription() != null) && (event.getReasonDescription().length() > 0))
		{			
			copyParamBuilder.append(event.getReasonDescription());
		}
		
		copyParamBuilder.append("|");
		copyParamBuilder.append(transactionContext.getTransactionId());
		query.addParameter(VistaQuery.LITERAL, copyParamBuilder.toString());
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	/**
	 * Create Query to get the HIS update for an image
	 * @param imageIen
	 * @return
	 */
	public static VistaQuery createGetHisUpdateQuery(String imageIen)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_IMAGE_CURRENT_INFO);
		query.addParameter(VistaQuery.LITERAL, imageIen);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createNewSOPInstanceUidQuery(String siteNumber, String imageIen)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_NEW_SOP_INSTANCE_UID);
		query.addParameter(VistaQuery.LIST, "");
		// TODO if there is a concept of product ID at VI, it should preceed the site#
		query.addParameter(VistaQuery.LITERAL, "1.2.840.113754." + siteNumber + "." + dateFormat.format(new Date()) + ".1");
		query.addParameter(VistaQuery.LITERAL, imageIen);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetImageInformationQuery(String imageId)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_GET_IMAGE_INFO);
		query.addParameter(VistaQuery.LITERAL, imageId);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetImageInformationQuery(String imageId, boolean includeDeletedImages)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_GET_IMAGE_INFO);
		query.addParameter(VistaQuery.LITERAL, imageId);
		query.addParameter(VistaQuery.LITERAL, includeDeletedImages ? "D" : "");
				
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetSysGlobalNodesQuery(String imageId)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_SYS_GLOBAL_NODE);
		query.addParameter(VistaQuery.LITERAL, imageId);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetDevFieldValues(String imageId, String flags)
	{		
		VistaQuery query = new VistaQuery(RPC_MAG_DEV_FIELD_VALUES);
		query.addParameter(VistaQuery.LITERAL, imageId);
		query.addParameter(VistaQuery.LITERAL, flags == null ? "" : flags.toUpperCase());
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	/**
	 * Create query to search for patients by name
	 * @param searchName
	 * @return
	 */
	public static VistaQuery createFindPatientQuery(String searchName)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_PAT_FIND);
		query.addParameter(VistaQuery.LITERAL, MAG_MAX_PATIENT_RESULT_COUNT + "^" + searchName.toUpperCase());
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	/**
	 * Create query to look for patient info details
	 * @param patientDfn
	 * @return
	 */
	public static VistaQuery createGetPatientInfoQuery(String patientDfn)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_PAT_INFO);
		query.addParameter(VistaQuery.LITERAL, patientDfn + "^^0^^1");
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	/**
	 * Creates a patient photo Id query
	 * @param patientDfn
	 * @return
	 */
	public static VistaQuery createGetPatientPhotosQuery(String patientDfn)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_PAT_PHOTOS);
		query.addParameter(VistaQuery.LITERAL, patientDfn);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetImagesForCprsRadExam(CprsIdentifier cprsId)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_CPRS_RAD_EXAM);
		query.addParameter(VistaQuery.LITERAL, cprsId.getCprsIdentifier());
		
		logVistaQueryRequest(query);
		
		return query;
	}

	public static VistaQuery createGetImagesForCprsRadExam(CprsIdentifier cprsId, StudyFilter filter)
	{
		//WFP-Need to still add code here.
		VistaQuery query = new VistaQuery(RPC_MAG_CPRS_RAD_EXAM);
		query.addParameter(VistaQuery.LITERAL, cprsId.getCprsIdentifier());
		
		logVistaQueryRequest(query);
		
		return query;
	}

	public static VistaQuery createGetImagesForCprsTiuNote(CprsIdentifier cprsId)
	{
		String tiuId = StringUtils.MagPiece(cprsId.getCprsIdentifier(), StringUtils.CARET, 5);
		
		VistaQuery query = new VistaQuery(RPC_MAG_CPRS_TIU_NOTE);
		query.addParameter(VistaQuery.LITERAL, tiuId);
		
		logVistaQueryRequest(query);
		
		return query;
	}

	public static VistaQuery createGetImagesForCprsTiuNote(CprsIdentifier cprsIdentifier, StudyFilter filter)
	{
		//WFP-Need to still add code here.
		String tiuId = StringUtils.MagPiece(cprsIdentifier.getCprsIdentifier(), StringUtils.CARET, 5);
		
		VistaQuery query = new VistaQuery(RPC_MAG_CPRS_TIU_NOTE);
		query.addParameter(VistaQuery.LITERAL, tiuId);
		
		logVistaQueryRequest(query);
		
		return query;
	}

	public static VistaQuery createGetImagesForCprsIdentifiers(List<CprsIdentifier> cprsIds)
	{
		VistaQuery query = new VistaQuery(RPC_MAGN_CPRS_IMAGE_LIST);
		
		Map<String, String> cprsIdentifiersParameters = new HashMap<String, String>();
		
		for(CprsIdentifier cprsId: cprsIds) 
			cprsIdentifiersParameters.put(cprsIdentifiersParameters.size() + 1 + "",  cprsId.getCprsIdentifier());
	
		query.addParameter(VistaQuery.LIST, cprsIdentifiersParameters);
		
		logVistaQueryRequest(query);
		
		return query;
	}

	public static VistaQuery createGetImagesForCprsIdentifiers(List<CprsIdentifier> cprsIds, StudyFilter filter)
	{
		VistaQuery query = new VistaQuery(RPC_MAGN_CPRS_IMAGE_LIST);
		
		Map<String, String> cprsIdentifiersParameters = new HashMap<String, String>();
		
		Boolean isTIU = false;
		
		for(CprsIdentifier cprsId: cprsIds) 
		{
			String cprsIdString = cprsId.getCprsIdentifier();

			//P185
			if (filter.isIncludeAllObjects())
			{
				cprsIdString = cprsIdString + "~2";
			}

    		if (StringUtil.Piece(cprsIdString, StringUtil.CARET, 4).equals("TIU"))
    		{
    			isTIU = true;
    		}
			
			cprsIdentifiersParameters.put(cprsIdentifiersParameters.size() + 1 + "", cprsIdString);
		}

		String imageLess = "1";
		if (filter.isIncludeImages() || isTIU)
		{
			imageLess = "0";
		}

        LOGGER.debug("ImageLess: {}", imageLess);
		
		query.addParameter(VistaQuery.LIST, cprsIdentifiersParameters);
		query.addParameter(VistaQuery.LITERAL, imageLess);
		
		logVistaQueryRequest(query);
		
		return query;
	}

	public static VistaQuery createGetImageGroupIENVistaQuery(String imageIen) 
	{	
		String arg = "^MAG(2005," + imageIen + ",0)";
		
		VistaQuery query = new VistaQuery(RPC_GET_VARIABLE_VALUE);
		query.addParameter(VistaQuery.REFERENCE, arg);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createMagBrokerSecurityQuery()
	{
		VistaQuery query = new VistaQuery(RPC_MAG_BROKER_SECURITY);
		
		logVistaQueryRequest(query);
		
		return query;
	}	

	/**
	 * 
	 * @param patientDfn
	 * @param studyFilter
	 * @param allowDeletedImages
	 * @return
	 */
	public static VistaQuery createMagImageListQuery(String patientDfn, StudyFilter studyFilter,  boolean allowDeletedImages)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_IMAGE_LIST);
		
		String controlParameter = "E"; // existing images
		String fromDate = "";
		String toDate = "";
		
		String studyPackage = "";
		String studyClass = "";
		String studyTypes = "";
		String studyEvent = "";
		String studySpecialty = "";
		String studyOrigin = "";
		
		int maximumResults = Integer.MAX_VALUE;
		
		if(studyFilter != null) 
		{
			fromDate = VistaTranslatorUtility.convertDateToRpcFormat(studyFilter.getFromDate());
			toDate = VistaTranslatorUtility.convertDateToRpcFormat(studyFilter.getToDate());
			studyPackage = studyFilter.getStudy_package();
			studyClass = studyFilter.getStudy_class();
			studyTypes = studyFilter.getStudy_type();
			studyEvent = studyFilter.getStudy_event();
			studySpecialty = studyFilter.getStudy_specialty();
			studyOrigin = studyFilter.getOrigin();
			maximumResults = studyFilter.getMaximumResults();
		}
		
		
		if((allowDeletedImages) && (studyFilter != null) && (studyFilter.isIncludeDeleted()))		
			controlParameter += "D"; // deleted images
		
		query.addParameter(VistaQuery.LITERAL, controlParameter);
		query.addParameter(VistaQuery.LITERAL, fromDate);
		query.addParameter(VistaQuery.LITERAL, toDate);
		query.addParameter(VistaQuery.LITERAL, maximumResults < Integer.MAX_VALUE ? maximumResults + "" : "");
		
		Map<String, String> filterParameters = new HashMap<String, String>();
		
		filterParameters.put(filterParameters.size() + "", "IDFN^^" + patientDfn);
		if(!"".equals(studyClass))
		{
			studyClass = studyClass.replace(',', '^'); // need to convert , to ^
			filterParameters.put(filterParameters.size() + "", "IXCLASS^^" + studyClass);
		}
		if(!"".equals(studyPackage))
		{
			studyPackage = studyPackage.replace(',', '^'); // need to convert , to ^			
			filterParameters.put(filterParameters.size() + "", "IXPKG^^" + studyPackage);
		}
		if(!"".equals(studyTypes))
		{
			studyTypes = studyTypes.replace(',', '^'); // need to convert , to ^
			filterParameters.put(filterParameters.size() + "", "IXTYPE^^" + studyTypes);
		}
		//TODO: make sure Event == Procedure - i think so?
		if(!"".equals(studyEvent))
		{
			studyEvent = studyEvent.replace(',', '^'); // need to convert , to ^
			filterParameters.put(filterParameters.size() + "", "IXPROC^^" + studyEvent);
		}
		if(!"".equals(studySpecialty))
		{
			studySpecialty = studySpecialty.replace(',', '^'); // need to convert , to ^	
			filterParameters.put(filterParameters.size() + "", "IXSPEC^^" + studySpecialty);
		}
		if(!"".equals(studyOrigin))
		{
			studyOrigin = studyOrigin.replace(',', '^'); // need to convert , to ^
			filterParameters.put(filterParameters.size() + "", "IXORIGIN^^" + studyOrigin);
		}
		query.addParameter(VistaQuery.LIST, filterParameters);
		
		return query;
	}
	
	public static VistaQuery createGetUserKeysQuery()
	{
		VistaQuery query = new VistaQuery(RPC_MAG_USER_KEYS);
		
		logVistaQueryRequest(query);
		
		return query;
	}

	public static VistaQuery createGetDivisionsQuery(String accessCode) 
	{
		VistaQuery query = new VistaQuery(RPC_XUS_GET_DIVISIONS);
		query.addParameter(VistaQuery.LITERAL, accessCode);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createAllowAnnotateQuery()
	{
		VistaQuery query = new VistaQuery(RPC_MAG_IMAGE_ALLOW_ANNOTATE);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	/**
	 * This is a MAGJ rpc that gets the treating sites for a patient and formats the result as a list rather than a string. This RPC is available to 
	 * MAG WINDOWS as part of Patch 122
	 * @param patientDfn
	 * @return
	 */
	public static VistaQuery createMagJGetTreatingSitesQuery(String patientDfn)
	{
        LOGGER.info("MagJGetTreatingSites({}) TransactionContext ({}).", patientDfn, TransactionContextFactory.get().getDisplayIdentity());
		
		VistaQuery query = new VistaQuery(RPC_MAGJ_GET_TREATING_LIST);
		query.addParameter(VistaQuery.LITERAL, patientDfn);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createLogImagingQuery(ImagingLogEvent logEvent, String patientDfn)
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		VistaQuery query = new VistaQuery(RPC_MAG_ACTION_LOG);
		
		StringBuilder sb = new StringBuilder();
		sb.append(logEvent.getAccessType());
		sb.append("^");
		sb.append(transactionContext.getDuz());
		sb.append("^");
		
		AbstractImagingURN imagingUrn = logEvent.getImagingUrn();
		if(imagingUrn != null)
		{
			boolean isDodImage = ExchangeUtil.isSiteDOD(imagingUrn.getOriginatingSiteId());
			// if this is a VA image then put the IEN in place here
			if(!isDodImage)
				sb.append(imagingUrn.getImagingIdentifier());
		}
		sb.append("^");
		sb.append(logEvent.getUserInterface());
		sb.append("^");
		sb.append(patientDfn);
		sb.append("^");
		
		if(logEvent.getImageCount() >= 0)
			sb.append(logEvent.getImageCount());
		
		sb.append("^");
		sb.append(logEvent.getAdditionalData());
		
		if(LOGGER.isDebugEnabled())
            LOGGER.debug("Imaging log event Parameter [{}]", sb.toString());
		
		query.addParameter(VistaQuery.LITERAL, sb.toString());
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetReasonsListQuery(List<ImageAccessReasonType> reasonTypes)
	{
		VistaQuery query = new VistaQuery(RPC_MAGG_REASON_LIST);
		
		StringBuilder reasons = new StringBuilder();
		
		if(reasonTypes != null)
			for(ImageAccessReasonType reasonType : reasonTypes)
				reasons.append(reasonType.getCode());
		else
			// put all options in
			for(ImageAccessReasonType reasonType : ImageAccessReasonType.values())
				reasons.append(reasonType);
		
		query.addParameter(VistaQuery.LITERAL, reasons.toString());
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createVerifyElectronicSignatureQuery(String electronicSignature)
	{		
		VistaQuery query = new VistaQuery(RPC_MAGG_VERIFY_ESIG);
		query.addEncryptedParameter(VistaQuery.LITERAL, electronicSignature);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetHealthSummariesQuery()
	{
		VistaQuery query = new VistaQuery(RPC_MAGGHSLIST);
		query.addParameter(VistaQuery.LITERAL, ""); // parameter does nothing
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetHealthSummary(HealthSummaryURN healthSummaryUrn, String patientDfn)
	{
		VistaQuery query = new VistaQuery(RPC_MAGGHS);
		query.addParameter(VistaQuery.LITERAL, patientDfn + StringUtils.CARET + healthSummaryUrn.getSummaryId());
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static VistaQuery createGetApplicationTimeoutParameters(String siteId, String applicationName) 
	{
		VistaQuery query = new VistaQuery(RPC_GET_TIMEOUT_PARAMETERS);
		query.addParameter(VistaQuery.LITERAL, applicationName);
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	public static void logVistaQueryRequest(VistaQuery vm){
        LOGGER.info("RPC Request: {}", StringUtils.displayEncodedChars(vm.toString()));
	}

	public static VistaQuery createGetFilterList(String userDuz)
	{
		VistaQuery query = new VistaQuery(RPC_MAG4_FILTER_GET_LIST);
		query.addParameter(VistaQuery.LITERAL, userDuz);
		query.addParameter(VistaQuery.LITERAL,  "1");
		
		logVistaQueryRequest(query);
		
		return query;
	}
	
	/**
	 * @param studyFilter
	 * @return
	 */
	public static VistaQuery createMagImageListQuery(StudyFilter studyFilter)
	{
		VistaQuery query = new VistaQuery(RPC_MAG_IMAGE_LIST);

		String controlParameter = "EC"; // existing images, captured date

		if ((studyFilter.getMaximumResultType() != null) && (studyFilter.getMaximumResultType().equals("%")))
			controlParameter += "S";
		
		controlParameter += "G";
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");	
		String fromDate = "";
		if (studyFilter.getFromDate() != null)
		{
	        fromDate = dateFormat.format(studyFilter.getFromDate());
			int from = Integer.parseInt(fromDate) - 17000000;
			fromDate = Integer.toString(from);
		}		
		
		String toDate = "";
		if (studyFilter.getToDate() != null)
		{
			toDate = dateFormat.format(studyFilter.getToDate());
			int to = Integer.parseInt(toDate) - 17000000;
			toDate = Integer.toString(to);
		}		
		
		String studyPackage = studyFilter.getStudy_package();
		String studyClass = studyFilter.getStudy_class();
		String studyTypes = studyFilter.getStudy_type();
		String studyEvent = studyFilter.getStudy_event();
		String studySpecialty = studyFilter.getStudy_specialty();
		String studyOrigin = studyFilter.getOrigin();
		String captureApp = studyFilter.getCaptureApp();
		String captureSavedBy = studyFilter.getCaptureSavedBy();
		String qaStatus = studyFilter.getQAStatus();
		
		int maximumResults = studyFilter.getMaximumResults();
		
		query.addParameter(VistaQuery.LITERAL, controlParameter);
		query.addParameter(VistaQuery.LITERAL, fromDate);
		query.addParameter(VistaQuery.LITERAL, toDate);
		query.addParameter(VistaQuery.LITERAL, maximumResults < Integer.MAX_VALUE ? maximumResults + "" : "");

		Map<String, String> filterParameters = new HashMap<String, String>();
		
		if ((studyClass != null) && !"".equals(studyClass))
		{
			studyClass = studyClass.replace(',', '^'); // need to convert , to ^
			filterParameters.put(filterParameters.size() + "", "IXCLASS^^" + studyClass);
		}
		
		if ((studyPackage != null) && !"".equals(studyPackage))
		{
			studyPackage = studyPackage.replace(',', '^'); // need to convert , to ^			
			filterParameters.put(filterParameters.size() + "", "IXPKG^^" + studyPackage);
		}
		
		if ((studyTypes != null) && !"".equals(studyTypes))
		{
			studyTypes = studyTypes.replace(',', '^'); // need to convert , to ^
			filterParameters.put(filterParameters.size() + "", "IXTYPE^^" + studyTypes);
		}
		
		if ((studyEvent != null) && !"".equals(studyEvent))
		{
			studyEvent = studyEvent.replace(',', '^'); // need to convert , to ^
			filterParameters.put(filterParameters.size() + "", "IXPROC^^" + studyEvent);
		}
		
		if ((studySpecialty != null) && !"".equals(studySpecialty))
		{
			studySpecialty = studySpecialty.replace(',', '^'); // need to convert , to ^	
			filterParameters.put(filterParameters.size() + "", "IXSPEC^^" + studySpecialty);
		}
		
		if ((studyOrigin != null) && !"".equals(studyOrigin))
		{
			studyOrigin = studyOrigin.replace(',', '^'); // need to convert , to ^
			filterParameters.put(filterParameters.size() + "", "IXORIGIN^^" + studyOrigin);
		}
		
		if ((captureApp != null) && !"".equals(captureApp))
		{
			captureApp = captureApp.replace(',', '^'); // need to convert , to ^			
			filterParameters.put(filterParameters.size() + "", "CAPTAPP^^" + captureApp);
		}

		if ((captureSavedBy != null) && !"".equals(captureSavedBy))
		{
			captureSavedBy = captureSavedBy.replace(',', '^'); // need to convert , to ^			
			filterParameters.put(filterParameters.size() + "", "SAVEDBY^^" + captureSavedBy);
		}

		if ((qaStatus != null) && !"".equals(qaStatus))
		{
			qaStatus = qaStatus.replace(',', '^'); // need to convert , to ^			
			filterParameters.put(filterParameters.size() + "", "ISTAT^^" + qaStatus);
		}

		if (filterParameters.size() > 0)
			query.addParameter(VistaQuery.LIST, filterParameters);			
		
		logVistaQueryRequest(query);
		
		return query;
	}
}
