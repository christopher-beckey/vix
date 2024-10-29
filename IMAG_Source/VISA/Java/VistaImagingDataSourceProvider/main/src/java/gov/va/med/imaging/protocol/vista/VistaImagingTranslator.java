package gov.va.med.imaging.protocol.vista;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.logging.Logger;

import gov.va.med.HealthSummaryURN;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.StoredStudyFilterURN;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ApplicationTimeoutParameters;
import gov.va.med.imaging.exchange.business.Division;
import gov.va.med.imaging.exchange.business.ElectronicSignatureResult;
import gov.va.med.imaging.exchange.business.HealthSummaryType;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.ImageAccessReason;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.Patient.PatientSex;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.StoredStudyFilter;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.User;
import gov.va.med.imaging.exchange.business.storage.ArtifactInstance;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ImageAccessReasonType;
import gov.va.med.imaging.exchange.enums.ObjectOrigin;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.protocol.vista.exceptions.ArtifactParsingException;
import gov.va.med.imaging.protocol.vista.exceptions.ImageParsingException;
import gov.va.med.imaging.protocol.vista.exceptions.SeriesParsingException;
import gov.va.med.imaging.protocol.vista.exceptions.StudyParsingException;
import gov.va.med.imaging.protocol.vista.exceptions.VistaParsingException;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.EncryptionUtils;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.url.vista.image.NetworkLocation;
import gov.va.med.imaging.url.vista.image.SiteParameterCredentials;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;
import gov.va.med.imaging.vistaobjects.CprsIdentifierImages;
import gov.va.med.imaging.vistaobjects.VistaGroup;
import gov.va.med.imaging.vistaobjects.VistaImage;
import gov.va.med.imaging.vistaobjects.VistaPatient;
import gov.va.med.imaging.vistaobjects.VistaPatientPhotoIDInformation;

/**
 * 
 * @author vhaiswwerfej
 * @author VHAISPNGUYEQ: cleaned up
 *
 */
@SuppressWarnings("deprecation")
public class VistaImagingTranslator 
{
	private final static Logger LOGGER = Logger.getLogger(VistaImagingTranslator.class);
	
	private static final String unknownPatient = "00000V000000";
		
	/**
	 * Convert the returned String value from an RPC call to a PatientSensitiveValue.
	 * 
	 * @param vistaResult
	 * @param patientDfn
	 * @return
	 * @throws VistaMethodException
	 */
	public static PatientSensitiveValue convertStringToPatientSensitiveValue(String vistaResult, String patientDfn)
	throws VistaMethodException
	{

		if(StringUtils.isEmpty(vistaResult) || vistaResult.equals("-1")) 
		{
			String msg = "Error response while checking sensitivity for patient DFN [" + patientDfn + "]";				
			LOGGER.error(msg);
			throw new VistaMethodException(msg);
		} 
		
		String [] lines = vistaResult.split(StringUtils.NEW_LINE);
		if(lines.length <= 0)
		{
			String msg = "Error parsing response from checking sensitivity for aptien DFN [" + patientDfn + "]";
			LOGGER.error(msg + ". VistA Response [" + vistaResult + "]");
			throw new VistaMethodException(msg);
		}
		
		int code = Integer.parseInt(lines[0].trim());
    
		LOGGER.info("Patient Sensitive level for patient DFN [" + patientDfn + "] is [" + code + "]");
		
		StringBuilder sb = new StringBuilder();
		
		// Skip the first one. Messy to use other methods. Leave as is.
		for(int i = 1; i < lines.length; i++) 
		{
			sb.append(lines[i]);
			
			if(i != (lines.length - 1))
				sb.append(StringUtils.NEW_LINE);
		}
		
		return new PatientSensitiveValue(PatientSensitivityLevel.getPatientSensitivityLevel(code), sb.toString());
	}
	
	/**
	 * Extract the name of a server share from a complete UNC path.
	 * 
	 * @param uncPath
	 * @return
	 */
	public static String extractServerShare(String uncPath) 
	{
		if(StringUtils.isEmpty(uncPath))
		{
			LOGGER.warn("Given 'uncPath' is null or empty. Return empty 'server share'");
			return "";
		}
			
		String imgPath = uncPath;
		if(imgPath.startsWith("\\\\"))
			imgPath = imgPath.substring(2);
				
		return "\\\\" + StringUtils.Piece(imgPath, "\\", 1) + "\\" + StringUtils.Piece(imgPath, "\\", 2);
	}
	
	/**
	 * Get the server share from an Image instance.
	 * The server share is the server share of one of (in preferred order)
	 * 1.) the image Full filename
	 * 2.) the image Abs filename
	 * 3.) the image Big filename 
	 * 4.) a zero length string
	 * 
	 * @param image
	 * @return
	 */
	public static String extractServerShare(Image image) 
	{
		if( image == null ) 
		{
			LOGGER.info("Image is null, returning empty server share");
			return "";
		}
		
		if(!StringUtils.isEmpty(image.getFullFilename()))
		{
			LOGGER.info("Using FULL file path [" + image.getFullFilename() + "] for image [" + image.getIen() + "] for server share.");
			return extractServerShare(image.getFullFilename().toLowerCase(Locale.ENGLISH));
		}
		
		if(!StringUtils.isEmpty(image.getAbsFilename()))
		{
			LOGGER.info("Using ABS file path [" + image.getAbsFilename() + "] for image [" + image.getIen() + "] for server share.");
			return extractServerShare( image.getAbsFilename().toLowerCase(Locale.ENGLISH) );
		}
		
		if(!StringUtils.isEmpty(image.getBigFilename()))
		{
			LOGGER.info("Using BIG file path [" + image.getBigFilename() + "] for image [" + image.getIen() + "] for server share.");
			return extractServerShare( image.getBigFilename().toLowerCase(Locale.ENGLISH) );
		}
		
		LOGGER.info("No file paths specified in image [" + image.getIen() + "]. Return empty server share.");

		return "";
	}
	
	/**
	 * 
	 * @param vistaResult
	 * @return
	 * @throws Exception
	 */
	public static String parseOptionNumber(String vistaResult) 
	throws Exception 
	{
    if(StringUtils.isEmpty(vistaResult)) 
		{
			String msg = "'vistaResult' is either null or empty.";				
			LOGGER.error( msg);
			throw new VistaMethodException(msg);
		}
    
		String [] lines = StringUtils.Split(vistaResult, StringUtils.CRLF);
		
		if(!lines[0].equals("[Data]")) 
		{
			throw new Exception("Invalid return format [" + vistaResult + "]");
		}
		
		if(lines[1].startsWith("[BEGIN_diERRORS]")) 
		{
			throw new Exception(vistaResult.substring(8));
		}
		
		if (lines.length == 1)
			throw new Exception("No option number data");
		
		String optNum = lines[1].substring(lines[1].indexOf(",^") + 2);
		if(!StringUtils.isNumeric(optNum))
			throw new Exception("Non-numeric option number");
		
		return optNum;
	}
	
	/**
	 * Takes a Vista response like:
	 * 1^Class: CLIN - 
	 * Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0
	 * 1^WAS^NURSING NOTE^09/28/2001 00:01^NOTE^2^CONSULT NURSE MEDICAL WOUND SPEC INPT^NOTE^CLIN^CONSULT^NURSING^WOUND ASSESSMENT^VA^09/28/2001 01:35^IMAGPROVIDERONETWOSIX,ONETWOSIX^1752|1752^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001753.JPG^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001753.ABS^CONSULT NURSE MEDICAL WOUND SPEC INPT^3010928^11^NOTE^09/28/2001^36^M^A^^^2^1^WAS^^^711^IMAGPATIENT1055,1055^CLIN^^^
	 * 2^WAS^OPHTHALMOLOGY^08/20/2001 00:01^OPH^10^Ophthalmology^NOTE^CLIN^IMAGE^EYE CARE^^VA^08/20/2001 22:32^IMAGPROVIDERONETWOSIX,ONETWOSIX^1783|1783^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001784.DCM^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001784.ABS^Ophthalmology^3010820^11^OPH^08/20/2001^41^M^A^^^10^1^WAS^^^711^IMAGPATIENT1055,1055^CLIN^^^^
	 * 
	 * and create a sorted set of VistaGroup instances. 
	 * 
	 * @param groupString
	 * @return
	 */
    public static SortedSet<VistaGroup> createGroupsFromGroupLines(
    	Site site, 
    	String groupString, 
    	PatientIdentifier patientId,
    	StudyDeletedImageState studyDeletedImageState)
    throws VistaParsingException
    {
    	SortedSet<VistaGroup> groups = new TreeSet<VistaGroup>();
    	
		  if(StringUtils.isEmpty(groupString)) 
		  {				
		  	LOGGER.warn("VistaImagingTranslator.parseOptionNumber() --> 'groupString' is either null or empty. Return empty Set.");
			  return groups;
		  }

    	String headerLine = "";
    	if(groupString.charAt(0) == '1') 
    	{			
			String[] lines = StringUtils.Split(groupString, StringUtils.NEW_LINE);
			// the first two lines of the response contain the response status and the metadata, respectively
			if(lines.length <= 0)
				throw new VistaParsingException("Study list contains no status, meta-data or data.");
			
			if(lines.length == 1)
				throw new VistaParsingException("Study list contains no meta-data or data.");
			
			if(lines.length == 2)
			{
				LOGGER.info("Study list contains no data.");
				return groups;
			}
			
			LOGGER.info("Found and parsing [" + lines.length + "] lines of group data");
			// parse the response status line and retain the ???
			String rpcResponseLine = lines[0].trim();
			String response = StringUtils.MagPiece(rpcResponseLine, StringUtils.CARET, 2);
			
			// the headerLine is the metadata, describes the format of the study results
			// save it and pass to the method that actually parses the study lines
			headerLine = lines[1];
			
			// for each remaining line in the response, parse a Study instance and add it
			// to our list
			for(int j = 2; j < lines.length; j++) 
			{
				VistaGroup group = null;
				
				try
				{
					String dfn = StringUtils.Piece(lines[j], "^", 35);
					
					if(LOGGER.isDebugEnabled()) LOGGER.debug("Parsing line for patient dfn: " + dfn);
					
					PatientIdentifier patientIdentifier = PatientIdentifier.dfnPatientIdentifier(dfn, site.getSiteNumber());
					group = createGroupFromGroupLine(site, headerLine, lines[j], patientIdentifier, studyDeletedImageState);
					
					if(group != null)
					{
						group.setRpcResponseMsg(response);
						
						if(!groups.add(group))
							LOGGER.warn("Duplicate group, IEN [" + group.getIen() + "] is not being added to result set.");
					}
				}
				catch (URNFormatException x)
				{
					throw new VistaParsingException(x);
				}
			}
		}
    	// QN: This should have been done while creating a group.
    	// Can't test this use case for this round = leave as is
    	// Should be removed after testing for no ill-effects
		// put the patient ICN field into the groups
		for(VistaGroup group : groups)
			group.setPatientIdentifier(patientId);
		
    	return groups;
    }
    
    /**
     * THIS SHOULD ONLY BE USED IF NOT USING GET PATIENT STUDY GRAPH RPC - This is for old (non patch 83) sites
     * 
	 * Takes a Vista response like:
	 * 1^Class: CLIN - 
	 * Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0
	 * 1^WAS^NURSING NOTE^09/28/2001 00:01^NOTE^2^CONSULT NURSE MEDICAL WOUND SPEC INPT^NOTE^CLIN^CONSULT^NURSING^WOUND ASSESSMENT^VA^09/28/2001 01:35^IMAGPROVIDERONETWOSIX,ONETWOSIX^1752|1752^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001753.JPG^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001753.ABS^CONSULT NURSE MEDICAL WOUND SPEC INPT^3010928^11^NOTE^09/28/2001^36^M^A^^^2^1^WAS^^^711^IMAGPATIENT1055,1055^CLIN^^^
	 * 2^WAS^OPHTHALMOLOGY^08/20/2001 00:01^OPH^10^Ophthalmology^NOTE^CLIN^IMAGE^EYE CARE^^VA^08/20/2001 22:32^IMAGPROVIDERONETWOSIX,ONETWOSIX^1783|1783^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001784.DCM^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001784.ABS^Ophthalmology^3010820^11^OPH^08/20/2001^41^M^A^^^10^1^WAS^^^711^IMAGPATIENT1055,1055^CLIN^^^^
	 * 
	 * 
	 * @param studyString
	 * @return
	 */
    public static SortedSet<VistaGroup> createGroupsFromGroupLinesHandleSingleImageGroup(
    	Site site, 
    	String studyString, 
    	PatientIdentifier patientId, 
    	StudyLoadLevel studyLoadLevel,
    	StudyDeletedImageState studyDeletedImageState)
    throws VistaParsingException
    {
    	SortedSet<VistaGroup> groups = new TreeSet<VistaGroup>();

    	if(StringUtils.isEmpty(studyString)) 
		{				
			LOGGER.warn("VistaImagingTranslator.createGroupsFromGroupLinesHandleSingleImageGroup() --> 'studyString' is either null or empty. Return empty Set.");
			return groups;
		}

    	String headerLine = "";
    	
    	if(studyString.charAt(0) == '1') 
    	{			
			  String [] lines = StringUtils.Split(studyString, StringUtils.NEW_LINE);
			
			  // the first two lines of the response contain the response status and the metadata, respectively
			  if(lines.length <= 0)
				  throw new VistaParsingException("Study list contains no status, meta-data or data.");
			
			  if(lines.length == 1)
				  throw new VistaParsingException("Study list contains no meta-data or data.");
			
			  if(lines.length == 2)
			  {
				  LOGGER.info("Study list contains no data.");
				  return groups;
			  }

			// parse the response status line and retain the ???
			String response = StringUtils.MagPiece(lines[0].trim(), StringUtils.CARET, 2);
			
			// the headerLine is the metadata, describes the format of the study results
			// save it and pass to the method that actually parses the study lines
			headerLine = lines[1];
			
			// for each remaining line in the response, parse a Study instance and add it to our list
			for(int j = 2; j < lines.length; j++) 
			{
				VistaGroup group = createGroupFromGroupLineHandleSingleImageGroup(
					site, headerLine, lines[j], patientId, studyLoadLevel, studyDeletedImageState);
				
				if(group != null)
				{
					group.setRpcResponseMsg(response);
					groups.add(group);
				}
			}
		}
    	
    	return groups;
    }
	
    /**
     * take one line from a VistA response and make a Study instance from it.
     * The study header describes the content of the Study string and looks something like:
     * Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0
     * 
     * A study line looks something like this:
	 * 1^WAS^NURSING NOTE^09/28/2001 00:01^NOTE^2^CONSULT NURSE MEDICAL WOUND SPEC INPT^NOTE^CLIN^CONSULT^NURSING^WOUND ASSESSMENT^VA^09/28/2001 01:35^IMAGPROVIDERONETWOSIX,ONETWOSIX^1752|1752^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001753.JPG^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001753.ABS^CONSULT NURSE MEDICAL WOUND SPEC INPT^3010928^11^NOTE^09/28/2001^36^M^A^^^2^1^WAS^^^711^IMAGPATIENT1055,1055^CLIN^^^
     * 
     * NOTE: the study line includes the data for the first image in the study, which contains much of what
     * we would consider Study data
     * 
     * @param studyHeader
     * @param studyString
     * @return
     * @throws URNFormatException 
     * @throws VistaParsingException 
     */
    private static VistaGroup createGroupFromGroupLine(
    	Site site, 
    	String studyHeader, 
    	String studyString, 
    	PatientIdentifier patientId,
    	StudyDeletedImageState studyDeletedImageState) 
    throws URNFormatException, VistaParsingException
    {
    	if(StringUtils.isEmpty(studyHeader))
    	{
    		LOGGER.warn("Given studyHeader is null or empty. Return null.");
    		return null;
    	}
    	
    	if(StringUtils.isEmpty(studyString))
    	{
    		LOGGER.warn("Given studyString is null or empty. Return null.");
    		return null;
    	}

    	String [] parts = StringUtils.Split(studyString, StringUtils.STICK);
    	
    	// do study part
    	String [] pieces = StringUtils.Split(parts[0], StringUtils.CARET);
    	String [] keys = StringUtils.Split(studyHeader, StringUtils.CARET);
    	
    	// clean up the keys (remove any ~ values)
    	for(int i = 0; i < keys.length; i++)
    		keys[i] = StringUtils.MagPiece(keys[i], StringUtils.TILDE, 1);
    	
    	int maxLength = pieces.length > keys.length ? keys.length : pieces.length;
    	
    	// create a VistaImage instance to hold the data temporarily
    	VistaImage vistaImage = VistaImage.create("^" + parts[1]);
    	
    	VistaGroup group = new VistaGroup(StudyLoadLevel.STUDY_ONLY, studyDeletedImageState);
    	
    	for(int i = 0; i < maxLength; i++) 
    		group.setValue(keys[i], pieces[i]);
    	
    	if(!StringUtil.isEmpty(group.getProcedureDateString()))
    		group.setProcedureDate(VistaTranslatorUtility.convertVistaDatetoDate(group.getProcedureDateString()));
    	
    	// set this here in case the setValue() calls overwrite it
    	group.setPatientIdentifier(patientId);
    	group.setPatientName(vistaImage.getPatientName());
    	group.setIen(vistaImage.getIen());
    	// JMW 4/26/2011 P104T4 - set the group site abbreviation from the image value
    	group.setSiteAbbr(vistaImage.getSiteAbbr());
    	
    	// setting the first image, if populating for shallow this will be needed, if full it will
    	// be trashed
    	group.setFirstVistaImage(vistaImage);
    	group.setFirstImageIen(vistaImage.getIen());
    	
    	// new fields available from Patch 93    	
    	group.setDocumentDate(vistaImage.getDocumentDate());
    	group.setSensitive(vistaImage.isSensitive());
    	group.setStudyStatus(vistaImage.getImageStatus());
    	group.setStudyViewStatus(vistaImage.getImageViewStatus());
    	group.setStudyImagesHaveAnnotations(vistaImage.isImageHasAnnotations());
    	
    	return group;
    }
    
    /**
     * Transform a VistaImage instance into an Image instance, adding the study properties.
     * 
     * @param vistaImage
     * @return
     * @throws URNFormatException 
     */
    public static Image transform(String originatingSiteId, String studyId, PatientIdentifier patientId, 
    		VistaImage vistaImage) 
    throws URNFormatException
    {
    	Image image = Image.create(originatingSiteId, vistaImage.getIen(), studyId, patientId, vistaImage.getImageModality());
    	
        image.setFullFilename(vistaImage.getFullFilename());
        image.setAbsFilename(vistaImage.getAbsFilename());
        image.setDescription(vistaImage.getDescription());
        image.setImgType(vistaImage.getImgType());
        image.setProcedure(vistaImage.getProcedure());
        image.setProcedureDate(vistaImage.getProcedureDate());
        image.setAbsLocation(vistaImage.getAbsLocation());
        image.setFullLocation(vistaImage.getFullLocation());
        image.setDicomSequenceNumberForDisplay(vistaImage.getDicomSequenceNumberForDisplay());
        image.setDicomImageNumberForDisplay(vistaImage.getDicomImageNumberForDisplay());
        image.setSiteAbbr(vistaImage.getSiteAbbr());
        image.setQaMessage(vistaImage.getQaMessage());
        image.setBigFilename(vistaImage.getBigFilename());
        image.setPatientDFN(vistaImage.getPatientDFN());
        image.setPatientName(vistaImage.getPatientName());
        image.setImageClass(vistaImage.getImageClass());
        image.setDocumentDate(vistaImage.getDocumentDate());
		    image.setCaptureDate(vistaImage.getCaptureDate());
		    image.setSensitive(vistaImage.isSensitive());
		    image.setImageStatus(vistaImage.getImageStatus());
		    image.setImageViewStatus(vistaImage.getImageViewStatus());
		    image.setAssociatedNoteResulted(vistaImage.getAssociatedNoteResulted());
		    image.setImagePackage(vistaImage.getImagePackage());
		    image.setImageHasAnnotations(vistaImage.isImageHasAnnotations());
		    image.setImageAnnotationStatus(vistaImage.getImageAnnotationStatus());
    	image.setImageAnnotationStatusDescription(vistaImage.getImageAnnotationStatusDescription());
		
    	return image;
    }
    
    /**
     * Transform a Collection of VistaImage instances into a SortedSet of Image instances,
     * adding the study and patient key data.
     * 
     * @param originatingSiteId
     * @param studyId
     * @param patientIcn
     * @param vistaImages
     * @return
     * @throws URNFormatException
     */
    public static SortedSet<Image> transform(
    	String originatingSiteId, 
    	String studyId, 
    	PatientIdentifier patientId, 
    	Collection<VistaImage> vistaImages) 
    throws URNFormatException
    {
    	SortedSet<Image> result = new TreeSet<Image>();
    	
    	for(VistaImage vistaImage : vistaImages)
    		if(!result.add(transform(originatingSiteId, studyId, patientId, vistaImage)))
    			LOGGER.warn("Duplicate image, IEN [" + vistaImage.getIen() + "] is not being added during transform.");
    	
    	return result;
    }
    
    /**
     * THIS SHOULD ONLY BE USED IF NOT USING GET PATIENT STUDY GRAPH RPC - This is for old (non patch 83) sites
     * 
     * take one line from a VistA response and make a Study instance from it.
     * The study header describes the content of the Study string and looks something like:
     * Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0
     * 
     * A study line looks something like this:
	 * 1^WAS^NURSING NOTE^09/28/2001 00:01^NOTE^2^CONSULT NURSE MEDICAL WOUND SPEC INPT^NOTE^CLIN^CONSULT^NURSING^WOUND ASSESSMENT^VA^09/28/2001 01:35^IMAGPROVIDERONETWOSIX,ONETWOSIX^1752|1752^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001753.JPG^\\ISW-IMGGOLDBACK\image1$\DM\00\17\DM001753.ABS^CONSULT NURSE MEDICAL WOUND SPEC INPT^3010928^11^NOTE^09/28/2001^36^M^A^^^2^1^WAS^^^711^IMAGPATIENT1055,1055^CLIN^^^
     * 
     * NOTE: the study line includes the data for the first image in the study, which contains much of what
     * we would consider Study data
     * 
     * @param studyHeaderString
     * @param studyString
     * @return
     * @throws VistaParsingException 
     */
    public static VistaGroup createGroupFromGroupLineHandleSingleImageGroup(
    	Site site, 
    	String studyHeaderString, 
    	String studyString, 
    	PatientIdentifier patientId, 
    	StudyLoadLevel studyLoadLevel,
    	StudyDeletedImageState studyDeletedImageState) 
    throws VistaParsingException
    {
    	if(StringUtils.isEmpty(studyHeaderString))
    	{
    		LOGGER.warn("Given studyHeader is null or empty. Return null.");
    		return null;
    	}
    	
    	if(StringUtils.isEmpty(studyString))
    	{
    		LOGGER.warn("Given studyString is null or empty. Return null.");
    		return null;
    	}
    	
		if(LOGGER.isDebugEnabled()) LOGGER.debug("Given studyString [" + studyString + "]");
		
    	String [] parts = StringUtils.Split(studyString, StringUtils.STICK);
    	
    	// do study part
    	String [] pieces = StringUtils.Split(parts[0], StringUtils.CARET);
    	String [] keys = StringUtils.Split(studyHeaderString, StringUtils.CARET);
    	
    	// clean up the keys (remove any ~ values)
    	for(int i = 0; i < keys.length; i++)
    		keys[i] = StringUtils.MagPiece(keys[i], StringUtils.TILDE, 1);
    	
    	int maxLength = pieces.length > keys.length ? keys.length : pieces.length;
    	
    	String imageString = "^" + parts[1];
    	

  		if(LOGGER.isDebugEnabled()) LOGGER.debug("imageString: " + imageString);
    	
    	VistaGroup study = new VistaGroup( studyLoadLevel, studyDeletedImageState );
    	
    	for(int i = 0; i < maxLength; i++) 
    	{
    		study.setValue(keys[i], pieces[i]);
    	}
    	
    	if(!StringUtil.isEmpty(study.getProcedureDateString()))
    	{
    		study.setProcedureDate(VistaTranslatorUtility.convertVistaDatetoDate(study.getProcedureDateString()));
    	}
    	
    	// set patient Icn since not getting from these VistA RPC calls
    	study.setPatientIdentifier(patientId);
    	
		VistaImage vistaImage = VistaImage.create(imageString);
		study.setIen(vistaImage.getIen());
		
    	// if the study is a single image study, then set the first image
    	if(vistaImage.getImgType() != 11 || !studyLoadLevel.isIncludeImages())
    	{
    		study.setFirstVistaImage(vistaImage);
    		study.setFirstImageIen(vistaImage.getIen());
    		study.setPatientName(vistaImage.getPatientName());
    	}
    	
    	study.setStudyImagesHaveAnnotations(vistaImage.isImageHasAnnotations());
    	
    	if (parts.length == 3) 
    	{
    		String altExamNbr = StringUtils.Piece(parts[2], StringUtils.CRSTRING, 1);
    		study.setAlternateExamNumber(altExamNbr);
    	}
    	
    	return study;
    }
    
    /**
     * Transform a collection of VistaGroup instances into a sorted set of Study instances.
     * 
     * @param objectOrigin
     * @param site
     * @param groups
     * @return
     * @throws URNFormatException
     */
    public static SortedSet<Study> transform(ObjectOrigin objectOrigin, Site site, Collection<VistaGroup> groups) 
    throws URNFormatException
    {
    	SortedSet<Study> studySet = new TreeSet<Study>();
    	
    	for(VistaGroup group : groups)
    		studySet.add(transform(objectOrigin, site, group));
    	
    	return studySet;
    }
    
    /**
     * Transform a single VistaGroup instance into a Study instance.
     * 
     * @param group
     * @return
     * @throws URNFormatException 
     */
    public static Study transform(ObjectOrigin objectOrigin, Site site, VistaGroup group) 
    throws URNFormatException
    {
    	Study study = Study.create(objectOrigin, site.getSiteNumber(), group.getIen(), 
    			group.getPatientIdentifier(), group.getStudyLoadLevel(), group.getStudyDeletedImageState());
    	
    	// copy the "dynamic" properties first and then copy the named properties
    	// some of the named properties may overwrite the "dynamic" properties
    	for( Enumeration<String> propertyKeyEnumerator = group.getKeys(); propertyKeyEnumerator.hasMoreElements(); )
    	{
    		String propertyKey = propertyKeyEnumerator.nextElement();
    		study.setValue(propertyKey, group.getValue(propertyKey));
    	}
    	
    	study.setAlienSiteNumber(group.getAlienSiteNumber());
    	study.setCaptureBy(group.getCaptureBy());
    	study.setCaptureDate(group.getCaptureDate());
    	study.setDescription(group.getDescription());
    	study.setErrorMessage(group.getErrorMessage());
    	study.setEvent(group.getEvent());
    	
    	if(group.getFirstVistaImage() != null)
    	{
    		Image firstImage = transform(site.getSiteNumber(), group.getIen(), group.getPatientIdentifier(), group.getFirstVistaImage());
    		study.setFirstImage(firstImage);
    	}
    	
    	study.setFirstImageIen(group.getFirstImageIen());
    	study.setImageCount(group.getImageCount());
    	study.setImagePackage(group.getImagePackage());
    	study.setImageType(group.getImageType());
    	study.setNoteTitle(group.getNoteTitle());
    	study.setOrigin(group.getOrigin());
    	study.setPatientName(group.getPatientName());
    	study.setProcedure(group.getProcedure());
    	study.setProcedureDate(group.getProcedureDate());
    	study.setProcedureDateString(group.getProcedureDateString());
    	study.setRadiologyReport(group.getRadiologyReport());
    	study.setRpcResponseMsg(group.getRpcResponseMsg());
    	study.setSiteAbbr(site.getSiteAbbr());
    	study.setSiteName(site.getSiteName());
    	study.setSpecialty(group.getSpecialty());
    	study.setStudyClass(group.getStudyClass());
    	study.setStudyUid(group.getStudyUid());
    	study.setGroupIen(group.getIen());
    	
    	if (group.getAlternateExamNumber() != null)
    	{
    		study.setAlternateExamNumber(group.getAlternateExamNumber());
    	}
    	
    	return study;
    }
    
	private final static String CONTEXT_NEXT = "NEXT_CONTEXTID";
	private final static String GROUP_IEN_KEY = "GROUP_IEN";

    private final static String STUDY_UID_KEY = "STUDY_UID";
	private final static String STUDY_PAT_KEY = "STUDY_PAT";
	private final static String STUDY_IEN_KEY = "STUDY_IEN";
	private final static String STUDY_INFO_KEY = "STUDY_INFO";
	private final static String STUDY_NEXT = "NEXT_STUDY";
	private final static String STUDY_MODALITY = "STUDY_MODALITY";
	private final static String STUDY_ERROR = "STUDY_ERR";
	
	private final static String SERIES_UID_KEY = "SERIES_UID";
	private final static String SERIES_IEN_KEY = "SERIES_IEN";
	private final static String SERIES_NEXT = "NEXT_SERIES";
	private final static String SERIES_NUMBER_KEY = "SERIES_NUMBER";
	private final static String SERIES_MODALITY = "SERIES_MODALITY";
	private final static String SERIES_DESCRIPTION = "SERIES_DESCRIPTION";
	private final static String SERIES_CLASS_INDEX_KEY = "SERIES_CLASS_INDEX";
	private final static String SERIES_PROCEVENT_INDEX_KEY = "SERIES_PROC/EVENT_INDEX";
	private final static String SERIES_SPECSUBSPEC_INDEX_KEY = "SERIES_SPEC/SUBSPEC_INDEX";

	private final static String IMAGE_UID_KEY = "IMAGE_UID";
	private final static String IMAGE_IEN_KEY = "IMAGE_IEN";
	private final static String IMAGE_NUMBER_KEY = "IMAGE_NUMBER";
	private final static String IMAGE_INFO_KEY = "IMAGE_INFO";
	private final static String IMAGE_NEXT = "NEXT_IMAGE";
	private final static String IMAGE_ERROR = "IMAGE_ERR";

	private final static String ARTIFACTINSTANCE_NEXT = "NEXT_ARTIFACTINSTANCE";
	private final static String ARTIFACTINSTANCE_PK_KEY = "ARTIFACTINSTANCE_PK";
	private final static String ARTIFACTINSTANCE_ARTIFACT_KEY = "ARTIFACTINSTANCE_ARTIFACT";
	private final static String ARTIFACTINSTANCE_ARTIFACTFORMAT_KEY = "ARTIFACTINSTANCE_ARTIFACTFORMAT";
	private final static String ARTIFACTINSTANCE_STORAGEPROVIDERTYPE_KEY = "ARTIFACTINSTANCE_STORAGEPROVIDERTYPE";	
	private final static String ARTIFACTINSTANCE_CREATEDATETIME_KEY = "ARTIFACTINSTANCE_CREATEDATETIME";
	private final static String ARTIFACTINSTANCE_FILEREF_KEY =  "ARTIFACTINSTANCE_FILEREF";
	private final static String ARTIFACTINSTANCE_DISKVOLUME_KEY = "ARTIFACTINSTANCE_DISKVOLUME";
	private final static String	ARTIFACTINSTANCE_PHYSICALREFERENCE_KEY = "ARTIFACTINSTANCE_PHYSICALREFERENCE";
	private final static String ARTIFACTINSTANCE_FILEPATH_KEY = "ARTIFACTINSTANCE_FILEPATH";
	
	/**
	 * Convert a String, as returned from VistA Imaging, into a sorted set of Study instances.
	 * 
	 * @param site
	 * @param vistaResult
	 * @param studyLoadLevel
	 * @return
	 */
	public static SortedSet<Study> createStudiesFromGraph(Site site, String vistaResult, 
			StudyLoadLevel studyLoadLevel, StudyDeletedImageState studyDeletedImageState) 
	{
    
    if(StringUtils.isEmpty(vistaResult)) 
		{				
			LOGGER.warn("VistaImagingTranslator.createGroupsFromGroupLinesHandleSingleImageGroup() --> 'vistaResult' String is either null or empty. Return empty Set.");
			return new TreeSet<Study>();
		}

		return createStudiesFromGraph(site, StringUtils.Split(vistaResult, StringUtils.NEW_LINE), studyLoadLevel, studyDeletedImageState);
	}
	
	// the definition of the levels in the hierarchy of data returned from the Vista RPC call
	private static VistaImagingParser.OntologyDelimiterKey[] studyOntologyDelimiterKeys = 
	new VistaImagingParser.OntologyDelimiterKey[] 
	{
		new VistaImagingParser.OntologyDelimiterKey(STUDY_NEXT, new String[] {STUDY_MODALITY}),
		new VistaImagingParser.OntologyDelimiterKey(SERIES_NEXT),
		new VistaImagingParser.OntologyDelimiterKey(IMAGE_NEXT),
		new VistaImagingParser.OntologyDelimiterKey(ARTIFACTINSTANCE_NEXT)
	};
	
	/**
	 * 
	 * @param site
	 * @param studyLines - a String array originally from Vista in a form that defies simple description.
	 *        "lines" are CR delimited lines of text
	 *        "parts" are delimited by the vertical bar '|' character
	 *        "pieces" are delimited by the caret '^' character
	 *        Each line consists of 1..n parts.  The first part (index=0) is a key.
	 *        Each part consists of 1..n pieces.
	 *        Prior to calling this method, the parts have been parsed into a String array.
	 *  Example of a single image study:
	 *        11
	 *        NEXT_STUDY||712
	 *        STUDY_IEN|712
	 *        STUDY_PAT|1011|9217103663V710366|IMAGPATIENT1011,1011
	 *        NEXT_SERIES
	 *        SERIES_IEN|712
	 *        NEXT_IMAGE
	 *        IMAGE_IEN|713
	 *        IMAGE_INFO|B2^713^\\isw-werfelj-lt\image1$\DM\00\07\DM000713.TGA^\\isw-werfelj-lt\image1$\DM\00\07\DM000713.ABS^040600-28  CHEST SINGLE VIEW^3000406.1349^3^CR^04/06/2000^^M^A^^^1^1^SLC^^^1011^IMAGPATIENT1011,1011^CLIN^^^^
	 *        IMAGE_ABSTRACT|\\isw-werfelj-lt\image1$\DM\00\07\DM000713.ABS
	 *        IMAGE_FULL|\\isw-werfelj-lt\image1$\DM\00\07\DM000713.TGA
	 *        IMAGE_TEXT|\\isw-werfelj-lt\image1$\DM\00\07\DM000713.TXT
	 *  The first line is the number of lines in the response.
	 *  
	 *  The keys "NEXT_STUDY", "NEXT_SERIES", and "NEXT_IMAGE" make up the "study ontology" definition, really
	 *  just the demarcation of the levels of the hierarchy.  The VistaImagingParser will use those keys as delimiters
	 *  when parsing the String returned from Vista into a hierarchy of lines.
	 *       
	 * @return
	 */
	public static SortedSet<Study> createStudiesFromGraph(Site site, String [] studyLines, 
			StudyLoadLevel studyLoadLevel, StudyDeletedImageState studyDeletedImageState) 
	{		
		SortedSet<Study> studySet = new TreeSet<Study>();
		
		if( studyLines == null || studyLines.length <= 1 )
		{
			LOGGER.error("Given array 'studyLines' is null. Return empty Set.");
			return studySet;		// i.e. return an empty Set
		}
		
		String studyCountLine = studyLines[0].trim();

		try
		{
	      int expectedLineCount = Integer.parseInt(studyCountLine);
	      if(expectedLineCount != studyLines.length)
		  	LOGGER.warn("The expected number of lines [" + expectedLineCount + 
						"] does not match the actual number [" + (studyLines.length) + 
						"], continuing....");
		} 
		catch (NumberFormatException e)
		{
			LOGGER.warn("Unable to parse the first line (containing number of lines) in the VistA response. Line was [" + 
					studyCountLine + "], Continuing....");
		}
		
		// drop the first line
		String [] realLines = new String[studyLines.length - 1];
		System.arraycopy(studyLines, 1, realLines, 0, realLines.length);
		
		// create a Vista Parser using the hierarchy levels defined by the ontology delimiter keys 
		VistaImagingParser parser = new VistaImagingParser(studyOntologyDelimiterKeys);
		
		List<VistaImagingParser.ParsedVistaLine> parsedStudyLines = parser.parse(realLines, true);

		// if there are any parsed lines that have the root key
		if(parsedStudyLines != null && parsedStudyLines.size() > 0)
			for(VistaImagingParser.ParsedVistaLine studyLine : parsedStudyLines)
			{
				try
				{
					Study study = createStudy(site, studyLine, studyLoadLevel, studyDeletedImageState);
					
					if(study != null)
						studySet.add(study);
				}
				catch (Exception ex)
				{
					LOGGER.warn("Exception [" + ex.getClass().getSimpleName() + "] while creating a study:  " + ex.getMessage());
				}
			}
		
		// add the complete Study with Series and Image instances attached
		// to the list of Study
		
		return studySet;
	}

	/**
	 * 
	 * @param site
	 * @param studyLine
	 * @return
	 * @throws URNFormatException 
	 */
	private static Study createStudy(Site site, VistaImagingParser.ParsedVistaLine studyLine, 
			StudyLoadLevel studyLoadLevel, StudyDeletedImageState studyDeletedImageState) 
	throws URNFormatException, StudyParsingException
  {
		if(studyLine == null)
			throw new StudyParsingException("Gievn studyLine is null.");
		
	    VistaImagingParser.ParsedVistaLine errorProp = studyLine.getProperty(STUDY_ERROR);
	    if(errorProp != null)
	    {
	    	String badIEN = studyLine.isValueAtIndexExists(1) ? studyLine.getValueAtIndex(1) : null;

	    	String errorMsg = errorProp.isValueAtIndexExists(1) ? errorProp.getValueAtIndex(1) : "";

        PatientIdentifier unknown = PatientIdentifier.icnPatientIdentifier(unknownPatient);

		    Study study = Study.create(ObjectOrigin.VA, site.getSiteNumber(), badIEN, 
		    		unknown, studyLoadLevel, studyDeletedImageState);

	    	LOGGER.warn("STUDY Error for study Ien [" + badIEN + "], [" + errorMsg + "]" );
	    	study.setErrorMessage(errorMsg);

        // JMW 7/17/08 - we now return the study but keep the error message to use later
	    	return study;
	    }

		String dataStructure = null;
		boolean isStudyInNewDataStructure = false;
		if(studyLine.isValueAtIndexExists(1))
		{
			dataStructure = studyLine.getValueAtIndex(1);
			
			if(dataStructure != null && dataStructure.length() > 0)
			{
				if(dataStructure.equals("NEW"))
				{
					isStudyInNewDataStructure = true;
				}
			}
		}
		
		VistaImagingParser.ParsedVistaLine ienProp = studyLine.getProperty(STUDY_IEN_KEY);
		
		// Seems to be unused???  What for then?
		int index = 0;
		while (ienProp.isValueAtIndexExists(index)) 
		{
			ienProp.getValueAtIndex(index);
			index++;
		}

		// We must have the IEN to create a Study: either the first value of the STUDY_IEN line
	    // or the second value from the NEXT_STUDY line
	    String ien = ienProp != null ? ienProp.getValueAtIndex(0) : studyLine.getValueAtIndex(1);
	    
	    if(LOGGER.isDebugEnabled()) LOGGER.debug("Parsed IEN [" + ien + "] from line");

	    int imageCount = 0;
	    int numberOfDicomImages = -1;
	    
	    if(ienProp.isValueAtIndexExists(1))
	    {
	    	String imageCountString = ienProp.getValueAtIndex(1);
		    

	    	if(LOGGER.isDebugEnabled()) LOGGER.debug("ImageCountString: " + imageCountString);
		    
	    	if(imageCountString != null && imageCountString.length() > 0)
	    	{
	    		imageCount = Integer.parseInt(imageCountString);
	    	}
	    }

	    String firstImageIen = ienProp.isValueAtIndexExists(2) ? ienProp.getValueAtIndex(2) : "";

	    // JMW 10/6/2010 P104 - the CPT code is present in the 3rd piece of the STUDY_IEN field
	    String cptCode = ienProp.isValueAtIndexExists(3) ? ienProp.getValueAtIndex(3) : "";

	    // JMW 10/29/2010 P104 - if site the image is physically stored at is in the 4th piece of the STUDY_IEN field
	    String consolidatedSiteNumber = ienProp.isValueAtIndexExists(4) ? ienProp.getValueAtIndex(4) : site.getSiteNumber();
	    	    
	    // JMW 7/21/2018 - if there is a 6th piece of the STUDY_IEN line it is the number of images in the study which are DICOM images (or potentially)
	    // get that value
	    if(ienProp.isValueAtIndexExists(5))
	    {
	    	String numberOfDicomImagesString = ienProp.getValueAtIndex(5);
	    	
	    	if(numberOfDicomImagesString != null && numberOfDicomImagesString.length()> 0) 
	    	{
	    		numberOfDicomImages = Integer.parseInt(numberOfDicomImagesString);
	    	}
	    }
      
	    VistaImagingParser.ParsedVistaLine uidProp = studyLine.getProperty(STUDY_UID_KEY);
	    String studyUid = uidProp != null ? uidProp.getValueAtIndex(0) : null;
	    
	    String patientIcn = null;
	    String patientName = null;
	    String patientDfn = null;
	    

	    VistaImagingParser.ParsedVistaLine patientProp = studyLine.getProperty(STUDY_PAT_KEY);
	    
	    if(patientProp != null)
	    {
	    	patientIcn = patientProp.getValueAtIndex(1);
	    	patientName = patientProp.getValueAtIndex(2);
	    }
	    
	    PatientIdentifier patientId = patientIcn != null && patientIcn.length() > 0 && !patientIcn.startsWith("-1") 
	    								? PatientIdentifier.icnPatientIdentifier(patientIcn) 
	    								: PatientIdentifier.dfnPatientIdentifier(patientDfn, site.getSiteNumber());
	    
	    Study study = Study.create(ObjectOrigin.VA, site.getSiteNumber(), ien, 
	    		patientId, studyLoadLevel, studyDeletedImageState, isStudyInNewDataStructure, false);

	    study.setSiteName(site.getSiteName());
	    study.setSiteAbbr(site.getSiteAbbr());
	    study.setStudyUid(studyUid);
    	study.setPatientName(patientName);
    	study.setCptCode(cptCode);
    	study.setConsolidatedSiteNumber(consolidatedSiteNumber);
    	
    	if(LOGGER.isDebugEnabled()) LOGGER.debug("study.numberOfDicomImages set to [" + numberOfDicomImages + "]");
    	
    	study.setNumberOfDicomImages(numberOfDicomImages);
    	
    	if(LOGGER.isDebugEnabled()) {
            LOGGER.debug("VistaImagingTranslator.createStudy() --> numberOfDicomImages was set to [{}]", numberOfDicomImages);}
    	
	    if(!studyLoadLevel.isIncludeImages())
	    {
	    	if(LOGGER.isDebugEnabled()) LOGGER.debug("Study is not loaded with images, setting image count to [" + imageCount + 
    			"] and first image IEN to [" + firstImageIen + "]");
        
	    	study.setFirstImageIen(firstImageIen);
	    }
	    
	    //Viewer requires image count
	    study.setImageCount(imageCount);

	    VistaImagingParser.ParsedVistaLine modalityProp = studyLine.getProperty(STUDY_MODALITY);
	    if(modalityProp != null)
	    {
	    	String [] modalities = modalityProp.getValueAtIndex(0).split(",", -1);

	    	for(String modality : modalities)
	    		study.addModality(modality);
	    }

	    VistaImagingParser.ParsedVistaLine studyInfoProp = studyLine.getProperty(STUDY_INFO_KEY);
	    if(studyInfoProp != null) 
	    {
  			String [] studyInfo = StringUtils.Split(studyInfoProp.getValueAtIndex(0), StringUtils.CARET);
	    	study.setNoteTitle(studyInfo[2]);
	    	study.setProcedureDateString(studyInfo[3]);
	    	
	    	if(study.getProcedureDateString() != null && study.getProcedureDateString().length() > 0)
	    		study.setProcedureDate(VistaTranslatorUtility.convertVistaDatetoDate(study.getProcedureDateString()));
	    	
	    	study.setProcedure(studyInfo[4]);
	    	study.setDescription(studyInfo[6]);
	    	study.setImagePackage(studyInfo[7]);
	    	study.setStudyClass(studyInfo[8]);
	    	study.setImageType(studyInfo[9]);
	    	study.setSpecialty(studyInfo[10]);
	    	study.setEvent(studyInfo[11]);
	    	study.setOrigin(studyInfo[12]);
	    	study.setCaptureDate(studyInfo[13]);
	    	study.setCaptureBy(studyInfo[14]);
	    	study.setAlternateExamNumber(studyInfoProp.getValueAtIndex(1));
	    	
	    	String studyCprsId = studyInfoProp.isValueAtIndexExists(2) ? studyInfoProp.getValueAtIndex(2) : null;
	    	studyCprsId = studyCprsId != null ? studyCprsId : ((StudyURN) study.getGlobalArtifactIdentifier()).toString();
	    	study.setContextId(studyCprsId);
	    	
	    	if(LOGGER.isDebugEnabled()) LOGGER.debug("study CPRS Identifier: " + studyCprsId);

	    }

	    String altFirstImageIen = "";
	    for(Iterator<VistaImagingParser.ParsedVistaLine> seriesIter = studyLine.childIterator(); seriesIter.hasNext();)
	    {
	    	VistaImagingParser.ParsedVistaLine seriesLine = seriesIter.next();
			  try 
			  {
			  	Series series = createSeries(site, study, seriesLine, altFirstImageIen, isStudyInNewDataStructure);
			    if(studyLoadLevel.IsIncludeSeries())
			    	study.addSeries(series);
			  }
			  catch (Exception ex)
			  {
				  LOGGER.warn("Exception [" + ex.getClass().getSimpleName() + "] while creating a series for study IEN [" + study.getStudyIen() + "]: " + ex.getMessage());
			  }
	    }
	    
	    if(StringUtils.isEmpty(firstImageIen))
	    {
	    	firstImageIen = altFirstImageIen;
      }
	    
	    if(!studyLoadLevel.isIncludeImages())
	    {
		    // this is a special case, if the load level was not full
	    	// if the study is a single image study, then older studies may not have an image node,
	    	// it might just be the parent node and it represents the image node. in this case
	    	// the imageCount and firstImageIen will not have been provided in the RPC call,
	    	// the firstImageIen is the same as the group ien and the imageCount is 1
	    	if(imageCount == 0)
	    	{

	    		if(LOGGER.isDebugEnabled()) LOGGER.debug("StudyLoadLevel was not full and image count was 0, setting image count to 1 indicating single image group with no child node");
	    		
	    		imageCount = 1;
	    	}
	    	
	    	if(firstImageIen.length() == 0)
	    	{

	    		if(LOGGER.isDebugEnabled()) LOGGER.debug("StudyLoadLevel was not full and first Image Ien is missing, setting value to [" + ien + "], indicating single image group with no child node");
	    		
	    		firstImageIen = ien;
	    	}
	    }

	    return study;
    }
	
	/**
	 * 
	 * @param site
	 * @param parentStudy
	 * @param seriesLine
	 * @return
	 * @throws URNFormatException 
	 */
	private static Series createSeries(Site site, Study parentStudy, VistaImagingParser.ParsedVistaLine seriesLine,
			String altFirstImageIen, boolean isSeriesInNewDataStructure) 
	throws URNFormatException, SeriesParsingException
    {
		if(seriesLine == null)
			throw new SeriesParsingException("'seriesLine' is null.");
		
		Series series = new Series();
		
		VistaImagingParser.ParsedVistaLine uidProp = seriesLine.getProperty(SERIES_UID_KEY);
		series.setSeriesUid(uidProp != null ? uidProp.getValueAtIndex(0) : "");
    
		VistaImagingParser.ParsedVistaLine ienProp = seriesLine.getProperty(SERIES_IEN_KEY);
		series.setSeriesIen(ienProp != null ? ienProp.getValueAtIndex(0) : "");
	    
		VistaImagingParser.ParsedVistaLine numberProp = seriesLine.getProperty(SERIES_NUMBER_KEY);
		series.setSeriesNumber(numberProp != null ? numberProp.getValueAtIndex(0) : "");
   
		VistaImagingParser.ParsedVistaLine modalityProp = seriesLine.getProperty(SERIES_MODALITY);
		if(modalityProp != null)
		{
			String modality = modalityProp.getValueAtIndex(0);
			if(!"*".equals(modality))
	     		series.setModality(modality);
	    }
	    
	    // Add "description" for VAI-678
	    // If null, set to empty String to force showing up in the result (XML)
	    
	    VistaImagingParser.ParsedVistaLine descProp = seriesLine.getProperty(SERIES_DESCRIPTION);
	    series.setDescription(descProp != null ? descProp.getValueAtIndex(0) : "");
	    
	    if(parentStudy.isStudyInNewDataStructure())
	    {
			VistaImagingParser.ParsedVistaLine classIndexProp = seriesLine.getProperty(SERIES_CLASS_INDEX_KEY);
			parentStudy.setStudyClass(classIndexProp != null ? classIndexProp.getValueAtIndex(0) : "");
		    
			VistaImagingParser.ParsedVistaLine procEventProp = seriesLine.getProperty(SERIES_PROCEVENT_INDEX_KEY);
			parentStudy.setEvent(procEventProp != null ? procEventProp.getValueAtIndex(0) : "");
			
			VistaImagingParser.ParsedVistaLine specProp = seriesLine.getProperty(SERIES_SPECSUBSPEC_INDEX_KEY);
			parentStudy.setSpecialty(specProp != null ? specProp.getValueAtIndex(0) : "");

	    }
	    
	    series.setSeriesInNewDataStructure(parentStudy.isStudyInNewDataStructure());
	    
	    for(Iterator<VistaImagingParser.ParsedVistaLine> imageIter = seriesLine.childIterator(); imageIter.hasNext();)
	    {
	    	  VistaImagingParser.ParsedVistaLine imageLine = imageIter.next();
	    	  try
	    	  {
	    		  Image image = createImage(site, parentStudy, series, imageLine, altFirstImageIen, isSeriesInNewDataStructure);
	    		
	    		  if(image != null)
	    			  series.addImage(image);
	    	  }
			  catch (Exception ex)
	    	  {
				  LOGGER.warn("Exception [" + ex.getClass().getSimpleName() + "] while creating an image for series IEN [" + series.getSeriesIen() + "]: " + ex.getMessage());
			  }
	    }
	    
		return series;
    }
	
	/**
	 * 
	 * @param site
	 * @param parentStudy
	 * @param parentSeries
	 * @param seriesLine
	 * @return
	 * @throws URNFormatException 
	 */
	private static Image createImage(
		Site site, 
		Study parentStudy, 
		Series parentSeries, 
		VistaImagingParser.ParsedVistaLine imageLine,
		String altFirstImageIen,
		boolean isImageInNewDataStructure) 
	throws URNFormatException, ImageParsingException
  {
		if(imageLine == null)
		{
			throw new ImageParsingException("Given 'imageLine' is null.");
		}
		
		VistaImagingParser.ParsedVistaLine ienProp = imageLine.getProperty(IMAGE_IEN_KEY);
		String imageIen = ienProp != null ? ienProp.getValueAtIndex(0) : null;
	   
		if(StringUtils.isEmpty(altFirstImageIen))
	    {
	    	altFirstImageIen = imageIen;
	    }
	    
    	VistaImagingParser.ParsedVistaLine uidProp = imageLine.getProperty(IMAGE_UID_KEY);
    	String imageUid = uidProp != null ? uidProp.getValueAtIndex(0) : "";	    
	    
	    VistaImagingParser.ParsedVistaLine numberProp = imageLine.getProperty(IMAGE_NUMBER_KEY);
	    String imageNumber = numberProp != null ? numberProp.getValueAtIndex(0) : "";
	    
	    VistaImagingParser.ParsedVistaLine infoProp = imageLine.getProperty(IMAGE_INFO_KEY);
	    String imageInfoLine = infoProp != null ? infoProp.getValueAtIndex(0) : null;
	    String consolidatedSiteNumber = (infoProp != null && infoProp.isValueAtIndexExists(1)) ? infoProp.getValueAtIndex(1) : site.getSiteNumber();
	    
	    if(imageInfoLine == null)
	    {
	    	LOGGER.warn("No IMAGE_INFO details for image IEN [" + imageIen + "], indicates this image was deleted, excluding from result");
	    	return null;
	    }
	    
	    String groupIen = null;
	    VistaImagingParser.ParsedVistaLine groupIenProp = imageLine.getProperty(GROUP_IEN_KEY);
	    if(groupIenProp != null)
	    {
	    	groupIen = groupIenProp.getValueAtIndex(0);
	    	parentStudy.setGroupIen(groupIenProp.getValueAtIndex(0));
	    }
	    
	    VistaImagingParser.ParsedVistaLine imageErrorProp = imageLine.getProperty(IMAGE_ERROR);
	    String errorMessage = imageErrorProp != null ? imageErrorProp.getValueAtIndex(0) : null;


	    // JMW 2/6/08 - No longer getting these values from the graph, getting them from the info key	 
	    // JMW 3/7/08 - setting these values at the end so that they overwrite the values we got 
	    // from VistA - not entirely sure about this but sometimes VistA doesn't have the right 
	    // abbreviation (if the site has not set it properly)
	    // JMW 1/21/10 - want to use site abbreviation from VistA for consolidated sites so they have the actual value - this could
	    // cause problems if site doesn't set value properly, but should not have functional impact - only visual impact.
	    //image.setSiteAbbr(site.getSiteAbbr());
	    // JMW 4/9/10 - not sure why setSiteNumber is commented out...
		//image.setSiteNumber(site.getSiteNumber());
	    
	    Image image = Image.create(
				site.getSiteNumber(), 
				imageIen, 
	    		groupIen == null ? parentStudy.getStudyIen() : groupIen, 
	    		parentStudy.getPatientIdentifier(), 
				parentSeries.getModality(), 
				isImageInNewDataStructure);
	    
	    image.setImageUid(imageUid);
	    image.setImageNumber(imageNumber);
	    image.setConsolidatedSiteNumber(consolidatedSiteNumber);
	    
	    updateImageWithImageLine(image, imageInfoLine);
	    
	    image.setErrorMessage(errorMessage != null ? errorMessage : null);

	    if(parentStudy.getFirstImage() == null)
    	{
    		parentStudy.setFirstImage(image);
    		parentStudy.setFirstImageIen(image.getIen());
    	}
	    
	    if(isImageInNewDataStructure)
	    {
		    Map<String,ArtifactInstance> fullProviderMap = new HashMap<String,ArtifactInstance>();
		    Map<String,ArtifactInstance> thumbnailProviderMap = new HashMap<String,ArtifactInstance>();
		    	    
		    for( Iterator<VistaImagingParser.ParsedVistaLine> instanceIter = imageLine.childIterator(); instanceIter.hasNext(); )
		    {
		    	VistaImagingParser.ParsedVistaLine instanceLine = instanceIter.next();
		    	try
		    	{
		    		createArtifactInstanceForImage(site, parentStudy, parentSeries, image, fullProviderMap, thumbnailProviderMap, instanceLine);	    	
		    	}
		    	catch(Exception ex)
		    	{
		    		LOGGER.warn("Exception [" + ex.getClass().getSimpleName() + "] while creating an artifact for image IEN [" + image.getIen() + "]: " + ex.getMessage());
		    	}
		    }
		    
		    //WFP-add code later to identify other than Magnetic for absLocation and fullLocation
		    ArtifactInstance fullImageInfo = getBestProviderImageUNC(fullProviderMap);
		    ArtifactInstance thumbnailImageInfo = getBestProviderImageUNC(thumbnailProviderMap);

		    if(fullImageInfo == null)
		    	throw new ImageParsingException("Full Resolution artifact instance is null for image IEN [" + image.getIen() + "]");
		    
		    if(thumbnailImageInfo == null)
		    	throw new ImageParsingException("Thumbnail artifact instance is null for image IEN [" + image.getIen() + "]");
		    
		    if(image != null)
		    {
			    image.setFullFilename(fullImageInfo.getAbsoluteFilespec());
				image.setFullLocation("M");
				image.setFullDiskVolumeIen(String.valueOf(fullImageInfo.getDiskVolume()));
				image.setFullFilepath(fullImageInfo.getFilePath());
				image.setFullFilespec(fullImageInfo.getFileRef());
				image.setFullArtifactIen(String.valueOf(fullImageInfo.getArtifactId()));
				image.setAbsFilename(thumbnailImageInfo.getAbsoluteFilespec());
				image.setAbsLocation("M");
				image.setAbsDiskVolumeIen(String.valueOf(thumbnailImageInfo.getDiskVolume()));
				image.setAbsFilepath(thumbnailImageInfo.getFilePath());
				image.setAbsFilespec(thumbnailImageInfo.getFileRef());
				image.setAbsArtifactIen(String.valueOf(thumbnailImageInfo.getArtifactId()));
		    }
	    }

	    return image;
    }
	
	/**
	 * 
	 * @param site
	 * @param parentStudy
	 * @param parentSeries
	 * @param parentImage
	 * @param seriesLine
	 * @param isStudyInNewDataStructure
	 * @return
	 * @throws URNFormatException 
	 */
	private static void createArtifactInstanceForImage(
		Site site, 
		Study parentStudy, 
		Series parentSeries, 
		Image image,
		Map<String,ArtifactInstance> dicomProviderMap,
		Map<String,ArtifactInstance> jpegProviderMap,
		VistaImagingParser.ParsedVistaLine artifactInstanceLine) 
	throws URNFormatException, ArtifactParsingException
  {
		if(artifactInstanceLine == null)
			throw new ArtifactParsingException("artifactInstanceLine is null.");
		
		VistaImagingParser.ParsedVistaLine artifactInsIenProp = artifactInstanceLine.getProperty(ARTIFACTINSTANCE_PK_KEY);
		String artifactInstanceIen = artifactInsIenProp != null ? artifactInsIenProp.getValueAtIndex(0) : null;
    
		VistaImagingParser.ParsedVistaLine imageFormatProp = artifactInstanceLine.getProperty(ARTIFACTINSTANCE_ARTIFACTFORMAT_KEY);
		String imageFormat = imageFormatProp != null ? imageFormatProp.getValueAtIndex(0) : null;
		
		VistaImagingParser.ParsedVistaLine artifactIenProp = artifactInstanceLine.getProperty(ARTIFACTINSTANCE_ARTIFACT_KEY);
		String artifactIen = artifactIenProp != null ? artifactIenProp.getValueAtIndex(0) : null;


    	VistaImagingParser.ParsedVistaLine storageProviderTypeProp = artifactInstanceLine.getProperty(ARTIFACTINSTANCE_STORAGEPROVIDERTYPE_KEY);
    	String storageProviderType = storageProviderTypeProp != null ? storageProviderTypeProp.getValueAtIndex(0) : null;

      VistaImagingParser.ParsedVistaLine creationDateProp = artifactInstanceLine.getProperty(ARTIFACTINSTANCE_CREATEDATETIME_KEY);
	    
	    if(creationDateProp != null)
	    {
	    	String creationDate = creationDateProp.getValueAtIndex(0);
	    	if(creationDate != null && creationDate.length() > 0)
	    	{
	    		image.setCaptureDate(VistaTranslatorUtility.convertVistaDatetoDate(creationDate));
	    	}

	    }	        
	    
	    VistaImagingParser.ParsedVistaLine fileRefProp = artifactInstanceLine.getProperty(ARTIFACTINSTANCE_FILEREF_KEY);
	    String fileRef = fileRefProp != null ? fileRefProp.getValueAtIndex(0) : null;

	    VistaImagingParser.ParsedVistaLine diskVolumeProp = artifactInstanceLine.getProperty(ARTIFACTINSTANCE_DISKVOLUME_KEY);
	    String diskVolumeIen = diskVolumeProp != null ? diskVolumeProp.getValueAtIndex(0) : null;
	    
	    VistaImagingParser.ParsedVistaLine diskPhysicalRefProp = artifactInstanceLine.getProperty(ARTIFACTINSTANCE_PHYSICALREFERENCE_KEY);
	    String diskPhysicalRef = diskPhysicalRefProp != null ? diskPhysicalRefProp.getValueAtIndex(0) : null;
	      	    
	    VistaImagingParser.ParsedVistaLine filePathProp = artifactInstanceLine.getProperty(ARTIFACTINSTANCE_FILEPATH_KEY);
	    String filePath = filePathProp != null ? filePathProp.getValueAtIndex(0) : null;
	    
	    String artifactUNC = createUNCForImageInNewDataStructure(diskPhysicalRef, fileRef, filePath);
	    
	    ArtifactInstance info = new ArtifactInstance();
	    info.setAbsoluteFilespec(artifactUNC);
	    info.setDiskVolume(new Integer(diskVolumeIen));
	    info.setFileRef(fileRef);
	    info.setFilePath(filePath);
	    info.setId(new Integer(artifactInstanceIen));
	    info.setArtifactId(new Integer(artifactIen));
	    
	    if(dicomProviderMap == null || jpegProviderMap == null)
	    	throw new ArtifactParsingException("DICOM Map or JPEG Map is null.");
	    
	    // Fortify change: check for null first.
	    if(imageFormat != null) 
	    {
	    	if (imageFormat.equals("DICOM"))
	    	{
	    		dicomProviderMap.put(storageProviderType, info);
	    	}
	    	else if(imageFormat.endsWith("JPEG")) 
	    	{
	    		jpegProviderMap.put(storageProviderType, info);
	    	}
	    }
	    //else: What'd the default value be ????
    }

	private static void updateImageWithImageLine(Image image, String imageLine)
	throws ImageParsingException
	{
		try
		{
			if((image != null) && (imageLine != null))
			{
				VistaImage vistaImage = VistaImage.create(imageLine);
				image.setFullFilename(vistaImage.getFullFilename());
				image.setAbsFilename(vistaImage.getAbsFilename());
				image.setDescription(vistaImage.getDescription());
				image.setImgType(vistaImage.getImgType());
				image.setProcedure(vistaImage.getProcedure());
				image.setProcedureDate(vistaImage.getProcedureDate());
				image.setAbsLocation(vistaImage.getAbsLocation());
				image.setFullLocation(vistaImage.getFullLocation());
				image.setDicomSequenceNumberForDisplay(vistaImage.getDicomSequenceNumberForDisplay());
				image.setDicomImageNumberForDisplay(vistaImage.getDicomImageNumberForDisplay());
				image.setSiteAbbr(vistaImage.getSiteAbbr());
				image.setBigFilename(vistaImage.getBigFilename());
				image.setPatientDFN(vistaImage.getPatientDFN());
				image.setPatientName(vistaImage.getPatientName());
				image.setImageClass(vistaImage.getImageClass());
				image.setDocumentDate(vistaImage.getDocumentDate());
				image.setCaptureDate(vistaImage.getCaptureDate());
				image.setSensitive(vistaImage.isSensitive());
				image.setImageStatus(vistaImage.getImageStatus());
				image.setImageViewStatus(vistaImage.getImageViewStatus());
				image.setAssociatedNoteResulted(vistaImage.getAssociatedNoteResulted());
				image.setImagePackage(vistaImage.getImagePackage());
				image.setImageHasAnnotations(vistaImage.isImageHasAnnotations());
				image.setImageAnnotationStatus(vistaImage.getImageAnnotationStatus());
				image.setImageAnnotationStatusDescription(vistaImage.getImageAnnotationStatusDescription());
			}
			else
				throw new ImageParsingException("imageLine or image object is null.");
		}
		catch(VistaParsingException vpX)
		{
			throw new ImageParsingException(vpX.getMessage(), vpX);
		}
	}
	
	/**
	 * Convert a String, as returned from VistA Imaging, into a sorted set of Study instances.
	 * 
	 * @param site
	 * @param vistaResponse
	 * @param studyLoadLevel
	 * @return
	 */
	public static SortedSet<Study> createFilteredStudiesFromGraph(Site site, String vistaResponse, 
			StudyLoadLevel studyLoadLevel, StudyFilter studyFilter, StudyDeletedImageState studyDeletedImageState) 
	{
		return createFilteredStudiesFromGraph(site, StringUtils.Split(vistaResponse, StringUtils.NEW_LINE), 
				  							  studyLoadLevel, studyFilter, studyDeletedImageState);
	}
	
	/**
	 * 
	 * @param site
	 * @param studyLines - a String array originally from Vista in a form that defies simple description.
	 *        "lines" are CR delimited lines of text
	 *        "parts" are delimited by the vertical bar '|' character
	 *        "pieces" are delimited by the caret '^' character
	 *        Each line consists of 1..n parts.  The first part (index=0) is a key.
	 *        Each part consists of 1..n pieces.
	 *        Prior to calling this method, the parts have been parsed into a String array.
	 *  Example of a single image study:
	 *        11
	 *        NEXT_STUDY||712
	 *        STUDY_IEN|712
	 *        STUDY_PAT|1011|9217103663V710366|IMAGPATIENT1011,1011
	 *        NEXT_SERIES
	 *        SERIES_IEN|712
	 *        NEXT_IMAGE
	 *        IMAGE_IEN|713
	 *        IMAGE_INFO|B2^713^\\isw-werfelj-lt\image1$\DM\00\07\DM000713.TGA^\\isw-werfelj-lt\image1$\DM\00\07\DM000713.ABS^040600-28  CHEST SINGLE VIEW^3000406.1349^3^CR^04/06/2000^^M^A^^^1^1^SLC^^^1011^IMAGPATIENT1011,1011^CLIN^^^^
	 *        IMAGE_ABSTRACT|\\isw-werfelj-lt\image1$\DM\00\07\DM000713.ABS
	 *        IMAGE_FULL|\\isw-werfelj-lt\image1$\DM\00\07\DM000713.TGA
	 *        IMAGE_TEXT|\\isw-werfelj-lt\image1$\DM\00\07\DM000713.TXT
	 *  The first line is the number of lines in the response.
	 *  
	 *  The keys "NEXT_STUDY", "NEXT_SERIES", and "NEXT_IMAGE" make up the "study ontology" definition, really
	 *  just the demarcation of the levels of the hierarchy.  The VistaImagingParser will use those keys as delimiters
	 *  when parsing the String returned from Vista into a hierarchy of lines.
	 *       
	 * @return
	 */
	public static SortedSet<Study> createFilteredStudiesFromGraph(Site site, String [] studyLines, 
			StudyLoadLevel studyLoadLevel, StudyFilter studyFilter, StudyDeletedImageState studyDeletedImageState) 
	{		
		SortedSet<Study> studySet = new TreeSet<Study>();
		
		if(studyLines == null || studyLines.length <= 1)
			return studySet;		// i.e. return an empty Set
		
		String studyCountLine = studyLines[0].trim();
		try
        {
	        int expectedLineCount = Integer.parseInt(studyCountLine);
	        if(expectedLineCount != studyLines.length)
				LOGGER.warn("The expected number of lines [" + expectedLineCount + 
						"] does not match the actual number [" + (studyLines.length) + 
						"], continuing....");
        } 
		catch (NumberFormatException e)
		{
			LOGGER.warn("Unable to parse the first line (containing number of lines) in the VistA response.  Line was '" + 
					studyCountLine + "', continuing....");
		}
		
		// drop the first line
		String [] realLines = new String[studyLines.length - 1];
		System.arraycopy(studyLines, 1, realLines, 0, realLines.length);
		
		// create a Vista Parser using the hierarchy levels defined by the ontology delimiter keys 
		VistaImagingParser parser = new VistaImagingParser(studyOntologyDelimiterKeys);
		
		List<VistaImagingParser.ParsedVistaLine> parsedStudyLines = parser.parse(realLines, true);

		// if there are any parsed lines that have the root key
		if(parsedStudyLines != null && parsedStudyLines.size() > 0)
			for(VistaImagingParser.ParsedVistaLine studyLine : parsedStudyLines)
			{
				try
				{
					Study study = createFilteredStudy(site, studyLine, studyLoadLevel, studyFilter, studyDeletedImageState);
					if(study != null)
						studySet.add(study);
				}
				catch (Exception ex)
				{
					LOGGER.warn("Exception [" + ex.getClass().getSimpleName() + "] while creating a study: " + ex.getMessage());
				}
			}
			// add the complete Study with Series and Image instances attached
			// to the list of Study
		
		return studySet;
	}

	/**
	 * 
	 * @param site
	 * @param studyLine
	 * @return
	 * @throws URNFormatException 
	 */
	private static Study createFilteredStudy(Site site, VistaImagingParser.ParsedVistaLine studyLine, 
			StudyLoadLevel studyLoadLevel, StudyFilter studyFilter, StudyDeletedImageState studyDeletedImageState) 
	throws URNFormatException, StudyParsingException
    {
	    VistaImagingParser.ParsedVistaLine errorProp = studyLine.getProperty(STUDY_ERROR);
	    
	    if(errorProp != null)
	    {
	    	String badIEN = studyLine.isValueAtIndexExists(1) ? studyLine.getValueAtIndex(1) : null;
	    	String errorMsg = errorProp.isValueAtIndexExists(1) ? errorProp.getValueAtIndex(1) : "";
	    	
	    	PatientIdentifier unknown = PatientIdentifier.icnPatientIdentifier(unknownPatient);

		    Study study = Study.create(ObjectOrigin.VA, site.getSiteNumber(), badIEN, 
		    		unknown, studyLoadLevel, studyDeletedImageState);

	    	LOGGER.warn("STUDY Error for study IEN [" + badIEN + "]: " + errorMsg );

	    	study.setErrorMessage(errorMsg);
	    	// JMW 7/17/08 - we now return the study but keep the error message to use later
	    	return study;
	    }

		String dataStructure = null;
		boolean isStudyInNewDataStructure = false;
		
		if(studyLine.isValueAtIndexExists(1))
		{
			dataStructure = studyLine.getValueAtIndex(1);
			if((dataStructure != null) && (dataStructure.length() > 0))
			 	if(dataStructure.equals("NEW"))
					isStudyInNewDataStructure = true;
		}
		

		VistaImagingParser.ParsedVistaLine ienProp = studyLine.getProperty(STUDY_IEN_KEY);
		// we must have the IEN to create a Study
	    String ien = ienProp != null ? ienProp.getValueAtIndex(0) : studyLine.getValueAtIndex(1);
	    
	    if(LOGGER.isDebugEnabled()) LOGGER.debug("IEN from parsed line: " + ien);
      
	    int imageCount = 0;
	    
	    if(ienProp.isValueAtIndexExists(1))
	    {
	    	String imageCountString = ienProp.getValueAtIndex(1);
	    	if((imageCountString != null) && (imageCountString.length() > 0))
	    		imageCount = Integer.parseInt(imageCountString);
	    }
	    
	    String firstImageIen = ienProp.isValueAtIndexExists(2) ? ienProp.getValueAtIndex(2) : "";

	    // JMW 10/6/2010 P104 - the CPT code is present in the 3rd piece of the STUDY_IEN field
	    String cptCode = ienProp.isValueAtIndexExists(3) ? ienProp.getValueAtIndex(3) : "";

	    // JMW 10/29/2010 P104 - if site the image is physically stored at is in the 4th piece of the STUDY_IEN field
	    String consolidatedSiteNumber = ienProp.isValueAtIndexExists(4) ? ienProp.getValueAtIndex(4) : site.getSiteNumber();
	    	    
	    VistaImagingParser.ParsedVistaLine uidProperty = studyLine.getProperty(STUDY_UID_KEY);
	    String studyUid = uidProperty != null ? uidProperty.getValueAtIndex(0) : null;
	    
	    String patientIcn = null;
	    String patientName = null;
	    String patientDfn = null;
	   
	    VistaImagingParser.ParsedVistaLine patientProp = studyLine.getProperty(STUDY_PAT_KEY);
	    if(patientProp != null)
	    {
	    	patientIcn = patientProp.getValueAtIndex(1);
	    	patientName = patientProp.getValueAtIndex(2);
	    }
	    
	    PatientIdentifier patientId = null;
	    if(patientIcn != null && patientIcn.length() > 0 && !patientIcn.startsWith("-1"))
	    	patientId = PatientIdentifier.icnPatientIdentifier(patientIcn);
	    else
	    	patientId = PatientIdentifier.dfnPatientIdentifier(patientDfn, site.getSiteNumber());
	    
	    Study study = Study.create(ObjectOrigin.VA, site.getSiteNumber(), ien, 
	    		patientId, studyLoadLevel, studyDeletedImageState, isStudyInNewDataStructure, false);

	    study.setSiteName(site.getSiteName());
	    study.setSiteAbbr(site.getSiteAbbr());
	    study.setStudyUid(studyUid);
    	study.setPatientName(patientName);
    	study.setCptCode(cptCode);
    	study.setConsolidatedSiteNumber(consolidatedSiteNumber);
 
	    if(!studyLoadLevel.isIncludeImages())
	    {
	    	if(LOGGER.isDebugEnabled())
	    		LOGGER.debug("Study is not loaded with images, setting image count to [" + imageCount + 
    			"] and first image IEN to [" + firstImageIen + "]");

	    	study.setImageCount(imageCount);
	    	study.setFirstImageIen(firstImageIen);
	    }
	    
	    VistaImagingParser.ParsedVistaLine modalityProp = studyLine.getProperty(STUDY_MODALITY);
	    if(modalityProp != null)
	    {
	    	String [] modalities = modalityProp.getValueAtIndex(0).split(",", -1);
	    	for(String modality : modalities)
	    		study.addModality(modality);
	    }

	    VistaImagingParser.ParsedVistaLine studyInfoProperty = studyLine.getProperty(STUDY_INFO_KEY);
	    if(studyInfoProperty != null) 
	    {
			
	    	String [] studyInfo = StringUtils.Split(studyInfoProperty.getValueAtIndex(0), StringUtils.CARET);
	    	study.setNoteTitle(studyInfo[2]);
	    	study.setProcedureDateString(studyInfo[3]);
	    	
	    	if(study.getProcedureDateString() != null && study.getProcedureDateString().length() > 0)
	    	{
	    		study.setProcedureDate(VistaTranslatorUtility.convertVistaDatetoDate(study.getProcedureDateString()));
	    	}
	    	
	    	study.setProcedure(studyInfo[4]);
	    	study.setDescription(studyInfo[6]);
	    	study.setImagePackage(studyInfo[7]);
	    	study.setStudyClass(studyInfo[8]);
	    	study.setImageType(studyInfo[9]);
	    	study.setSpecialty(studyInfo[10]);
	    	study.setEvent(studyInfo[11]);
	    	study.setOrigin(studyInfo[12]);
	    	study.setCaptureDate(studyInfo[13]);
	    	study.setCaptureBy(studyInfo[14]);	    	
	    	study.setAlternateExamNumber(studyInfoProperty.getValueAtIndex(1));
	    	String studyCprsId = null;
	    	
	    	if(studyInfoProperty.isValueAtIndexExists(2))
	    	{
	    		studyCprsId = studyInfoProperty.getValueAtIndex(2);
	    	}
	    	
	    	if(LOGGER.isDebugEnabled()) LOGGER.debug("study CPRS Identifier [" + studyCprsId + "]");
	    	
	    	if((studyFilter.isIncludeEncounterOrders() && studyCprsId != null) ||
	    		(studyFilter.isIncludePatientOrders() && (StringUtils.isEmpty(studyCprsId))))
	    	{
	    		
	    		if(LOGGER.isDebugEnabled()) LOGGER.debug("Collecting study [" + study.getStudyIen() +"]");
	    	}
	    	else
	    	{
	    		if(LOGGER.isDebugEnabled()){LOGGER.debug("Not collecting study [" + study.getStudyIen() + "]");}
	    		return null;
	    	}
	    	
	    	if(studyCprsId != null)
	    	{
	    		study.setContextId(studyCprsId);
	    	}
	    	else
	    	{
	    		StudyURN artifactIdentifier = (StudyURN)study.getGlobalArtifactIdentifier();
	    		study.setContextId(artifactIdentifier.toString());
	    	}
	    }

	    String altFirstImageIen = "";
	    
	    for(Iterator<VistaImagingParser.ParsedVistaLine> seriesIter = studyLine.childIterator(); seriesIter.hasNext();)
	    {
    		VistaImagingParser.ParsedVistaLine seriesLine = seriesIter.next();
	    	try
	    	{
	    		Series series = createSeries(site, study, seriesLine, altFirstImageIen, isStudyInNewDataStructure);
	    		if(studyLoadLevel.IsIncludeSeries())
	    			study.addSeries(series);
	    	}
			catch (Exception ex)
	    	{
				LOGGER.error("Exception [" + ex.getClass().getSimpleName() + "] while creating a series for study IEN [" + study.getStudyIen() + "] with series Line: [" + seriesLine + "]: " + ex.getMessage());
			}
	    }
	    
	    if(StringUtils.isEmpty(firstImageIen))
	    	firstImageIen = altFirstImageIen;
	    
	    if(!studyLoadLevel.isIncludeImages())
	    {
		    // this is a special case, if the load level was not full
	    	// if the study is a single image study, then older studies may not have an image node,
	    	// it might just be the parent node and it represents the image node. in this case
	    	// the imageCount and firstImageIen will not have been provided in the RPC call,
	    	// the firstImageIen is the same as the group ien and the imageCount is 1
	    	if(imageCount == 0)
	    	{
	    		if(LOGGER.isDebugEnabled()) LOGGER.debug("StudyLoadLevel was not full and image count was 0, setting image count to 1 indicating single image group with no child node");
	    		imageCount = 1;
	    	}
	    	
	    	if(firstImageIen.length() == 0)
	    	{
	    		if(LOGGER.isDebugEnabled()) LOGGER.debug("StudyLoadLevel was not full and first Image IEN is missing. Setting value to [" + ien + "], indicating single image group with no child node");
	    		firstImageIen = ien;
	    	}
	    }

	    return study;
    }
	
	/**
     * Converts RPC data from VistA into Image object
     * 
     * @param imageString
     * @return Image object representing VistA string data or null if the String cannot be used to
     * 			build a valid Image instance
	 * @throws URNFormatException 
	 * @throws VistaParsingException 
     */
    private static Image vistaImageStringToImage(String imageString, String oriSiteId, 
    		String studyId, PatientIdentifier patientId) 
    throws URNFormatException, VistaParsingException 
    {       
        return StringUtils.isEmpty(imageString) ? null : transform(oriSiteId, studyId, patientId, VistaImage.create(imageString));
    }
    
    /**
     * @param imageString
     * @return List of image objects based on imageList information
     * @throws URNFormatException 
     * @throws VistaParsingException 
     */
    public static List<Image> VistaImageStringListToImageList(String imageString, String originatingSiteId, 
    		String studyId, PatientIdentifier patientId) 
    throws URNFormatException
    {
    	List<Image> images = new LinkedList<Image>();
    	
    	if(StringUtils.isEmpty(imageString)) 
    	{
    		return images;
    	}
    	
    	String [] lines = StringUtils.Split(imageString, StringUtils.NEW_LINE);
    	
    	for(int i = 1; i < lines.length; i++) 
    	{
    		try
    		{
	    		images.add(vistaImageStringToImage(lines[i], originatingSiteId, studyId, patientId));
    		}
    		catch(VistaParsingException vpX)
    		{
    			// if there is a parsing exception, just throw away this image, not the entire list
    			LOGGER.error("[VistParsingException] --> parsing image line [" + lines[i] + "]: " + vpX.getMessage());
    		}
    	}
    	
    	return images;
    }
    
    /**
     * 
     * @param networkLocationString
     * @param site
     * @return
     */
    public static List<NetworkLocation> VistaNetworkLocationsToNetworkLocationsList(String networkLocationString, 
    		Site site, SiteParameterCredentials siteParameterCredentials)
    {
    	List<NetworkLocation> networkLocations = new ArrayList<NetworkLocation>();
    	
    	String [] shares = StringUtils.Split(networkLocationString, StringUtils.NEW_LINE);
		
		// skip first element (response message)
		for(int i = 1; i < shares.length; i++) 
		{
			networkLocations.add(VistaNetworkLocationStringToNetworkLocation(shares[i], site, siteParameterCredentials));
		}
		
		return networkLocations;
    }
    
    /**
     	5^\\delphidevm\image2$^MAG^1^^^^^EHR^1^1|100
    	1)5^
    	2)\\delphidevm\image2$^
    	3)MAG^
    	4)1^
    	5)^
    	6)^
    	7)^
    	8)^
    	9)EHR^
    	10)1^
    	11)1|100
 
     * @param networkLocationString
     * @param site
     * @return
     */
    public static NetworkLocation VistaNetworkLocationStringToNetworkLocation(String networkLocationString, 
    		Site site, SiteParameterCredentials siteParameterCredentials)
    {
//		5^\\delphidevm\image2$^MAG^1^^^^^EHR^1^1|100
//    	1)5^
//    	2)\\delphidevm\image2$^
//    	3)MAG^
//    	4)1^
//    	5)^
//    	6)^
//    	7)^
//    	8)^
//    	9)EHR^
//    	10)1^
//    	11)1|100
    	
    	StringUtils.Piece(networkLocationString, StringUtils.CARET, 1);
    	String path =  StringUtils.Piece(networkLocationString, StringUtils.CARET, 2);
		String user = StringUtils.Piece(networkLocationString, StringUtils.CARET, 5);
		
		if(user == null) 
			user = "";
		
		String pass = StringUtils.Piece(networkLocationString, StringUtils.CARET, 6);
		
		if(pass == null)
		{
			pass = "";
		}
		else if(pass.length() > 0)
		{
			try
			{
				pass = EncryptionUtils.decrypt(pass);
			}
			catch(Exception ex)
			{
				LOGGER.warn("Exception [" + ex.getClass().getSimpleName() + "] decrypting password [" + pass + "] for share path [" + path + "]");
			}			
		}
		
		if(siteParameterCredentials != null) 
		{ 
			if(pass.equals("")) 
			{
				pass = siteParameterCredentials.getPassword();
			}
			
			if(user.equals("")) 
			{
				user = siteParameterCredentials.getUsername();
			}
		}
    	return new NetworkLocation(path, user, pass, site.getSiteNumber());
    }
    
    public static SiteParameterCredentials VistaImagingSiteParametersStringToSiteCredentials(String imagingSiteParametersString)
    {
    String [] parameters = StringUtils.Split(imagingSiteParametersString, StringUtils.NEW_LINE);			
		String username = StringUtils.Piece(parameters[2], StringUtils.CARET, 1);
		String pass = parameters[2];			
		pass = pass.substring(username.length() + 1);
		pass = pass.substring(0, pass.length() - 1); // remove trailing \n character
		
		if(pass != null && pass.length() > 0)
		{
			pass = EncryptionUtils.decrypt(pass);
		}
		return new SiteParameterCredentials(username, pass);
    }
    
    public static List<String> convertVistaVersionsToVersionNumbers(String magVersionString)
    {    	
    	if(StringUtils.isEmpty(magVersionString))
    		return new ArrayList<String>();
    	
    	String [] versions = StringUtils.Split(magVersionString, StringUtils.NEW_LINE);
    	List<String> magVersionList = new ArrayList<String>(versions.length);
    	
		for(int i = 0; i < versions.length; i++) 
		{		
			String [] versionDetails = StringUtils.Split(versions[i], StringUtils.CARET);
			if(versionDetails[0] != null)
			{
				String [] versionPieces = StringUtils.Split(versionDetails[0], StringUtils.SPACE);
				if(versionPieces[0] != null)
					magVersionList.add(versionPieces[0]);
			}
		}
    	
		return magVersionList;
    }
    
    /**
     * Converts data received from a HIS update VistA query into a key-value hashmap.
     * Input data looks like:
     *  
     *  21 data fields returned:
     *  
		0008,0018^1.2.840.113754.660.20080219103530278.1
		0008,0020^20030509
		0008,0050^050903-170
		0008,0090^IMAGPROVIDERONETWOEIGHT,ONETWOEIGHT\1A
		0008,1030^NM
		0008,1050^IMAGPROVIDERONETWOEIGHT,ONETWOEIGHT
		0010,0010^IMAGPATIENT720,720
		0010,0020^000000720
		0010,0030^19320000
		0010,0032^000000
		0010,0040^M
		0010,1000^1006170580V294705
		0010,1040^430 GRISWOLD DR^^^SALT LAKE CITY^UTAH^33461
		0020,000D^1.3.46.670589.8.2021400214009.2001.1.170.8
		0020,000E^1.2.840.114234.1.21.1.2155594979.20030206.1545.2
		0032,1020^660
		0032,1032^IMAGPROVIDERONETWOSIX,ONETWOSIX
		0032,1060^RADIOGRAPHIC PROCEDURE
		0032,1064 0008,0100^76499
		0032,1064 0008,0102^C4
		0032,1064 0008,0104^RADIOGRAPHIC PROCEDURE
     * 
     * @param vistaHisUpdateString
     * @return
     */
    public static HashMap<String, String> convertVistaHisUpdateToHashmap(String vistaHisUpdateString)
    {
    	HashMap<String, String> hisUpdate = new HashMap<String, String>();
    	
    	if(StringUtils.isEmpty(vistaHisUpdateString))
    		return hisUpdate;
    	
    	String [] fields = StringUtils.Split(vistaHisUpdateString, StringUtils.NEW_LINE);		
	
    	for(int i = 1; i < fields.length; i++) 
    	{
			String fullField = fields[i].trim();
			hisUpdate.put(StringUtils.MagPiece(fullField, StringUtils.CARET, 1), 
						  StringUtils.MagPieceCount(fullField, StringUtils.CARET, 1, 0));
		}
    	
    	return hisUpdate;
    }
    
    /**
     * 
     * @param vistaResult
     * @param study
     * @return
     * @throws VistaParsingException 
     */
    public static SortedSet<VistaImage> createImageGroupFromImageLines(String vistaResult, Study study) 
    throws VistaParsingException
    {
    	if(vistaResult == null)
    		return null;
    	
    	SortedSet<VistaImage> images = new TreeSet<VistaImage>();
    	
    	String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
    	
    	for(int i = 1; i < lines.length; i++)
    	{
    		images.add(VistaImage.create(lines[i]));    		
    	}
    	
    	return images;    	
    }
    
    /**
     * 
     * @param studyString
     * @param patientIcn
     * @param siteNumber
     * @return
     * @throws VistaParsingException
     */ 		
    public static List<Image> createImagesForFirstImagesFromVistaGroupList(
    		    	String studyString, 
    		    	PatientIdentifier patientId, 
    		    	String siteNumber)
    throws VistaParsingException
    {
    	List<Image> images = new ArrayList<Image>();
    	
    	if(StringUtils.isEmpty(studyString))
    		return images;
    	
    	if(studyString.charAt(0) == '1') 
    	{			
			String[] lines = StringUtils.Split(studyString, StringUtils.NEW_LINE);
			// the first two lines of the response contain the response status and the metadata, respectively
			if(lines.length <= 0)
				throw new VistaParsingException("Study list contains no status, meta-data or data.");
			
			if(lines.length == 1)
				throw new VistaParsingException("Study list contains no meta-data or data.");
			
			if(lines.length == 2)
			{
				LOGGER.info("Study list contains no data.");
				return images;
			}
			
			// parse the response status line and retain the ???
			String rpcResponseLine = lines[0].trim();
			StringUtils.MagPiece(rpcResponseLine, StringUtils.CARET, 2);
			
			// for each remaining line in the response, parse a Study instance and add it
			// to our list
			String studyIen = null;
			for(int j = 2; j < lines.length; j++) 
			{
				String imagePiece = StringUtils.MagPiece(lines[j], StringUtils.STICK, 2);
				// this next test will deal with trailing blank lines
				if(imagePiece != null && imagePiece.length() > 0)
				{
					String imageLine = "B1^" + imagePiece;
					VistaImage vistaImage = VistaImage.create(imageLine);
					studyIen = studyIen == null ? vistaImage.getIen() : studyIen;
					
					try
					{
						images.add(transform(siteNumber, studyIen, patientId, vistaImage));
					}
					catch (URNFormatException x)
					{
						LOGGER.error("URNFormatException parsing line [" + imageLine + "]: " + x.getMessage());
					}
				}
			}
		}
    	
    	return images;
    }
    
    /**
     * Converts the RPC response into a list of patient objects
     * @param findPatientResults
     * @return
     */
    public static List<VistaPatient> convertFindPatientResultsToVistaPatient(String findPatientResults)
    {
    	List<VistaPatient> vistaPatients = new ArrayList<VistaPatient>();
    	String[] lines = StringUtils.Split(findPatientResults, StringUtils.NEW_LINE);
    	
    	if(lines.length == 1)
    	{
    		LOGGER.error("Error finding patients [" + findPatientResults + "]");
    	}
    	else 
    	{
    		for(int i = 1; i < lines.length; i++)    		
    		{
    			String [] patientPieces = StringUtils.Split(lines[i], StringUtils.CARET);
    			String rawPatientInfo = patientPieces[0];
    			boolean sensitive = rawPatientInfo != null && rawPatientInfo.contains(" *SENSITIVE* ");
    			
    			String dfn = patientPieces[1];
    			if(dfn != null)
    				dfn = dfn.trim();
    			
    			vistaPatients.add(new VistaPatient(dfn, sensitive));
    		}
    	}
    	
    	return vistaPatients;
    }
    
    /**
     * Converts a date string from a patient info query into a Date object
     * @param dateString
     * @return
     * @throws ParseException
     */
    public static Date convertPatientDetailsDateStringToDate(String dateString)
    throws ParseException
    {
      // length is 10 = 4-digit year
    	return new SimpleDateFormat(dateString.length() == 10 ? "MM/dd/yyyy" : "MM/dd/yy", Locale.US).parse(dateString);
    }
    
    /**
     * Converts a patient Info response from VistA into a Patient object
     * 
     * Position 1 = dfn, 2 = patientName, 3 = patientSex, 4 = patientDob, 5 = SSN, 7 = veteranStatus, 10 = patientIcn 
     * 
     * @param patientInfoResults
     * @return
     * @throws ParseException
     */
    public static Patient convertPatientInfoResultsToPatient(String patientInfoResults, boolean sensitive)
    throws ParseException
    {
String [] pieces = StringUtils.Split(patientInfoResults, StringUtils.CARET);
    	
    	// patientName = pieces[2], patientIcn = pieces[10], veteranStatus = pieces[7], 
    	// patientSex = pieces[3], patientDob = pieces[4], pieces[5], dfn = pieces[1], sensitive
    	return new Patient(pieces[2], pieces[10], pieces[7], 
    			PatientSex.valueOfPatientSex(pieces[3]), 
    			convertPatientDetailsDateStringToDate(pieces[4]),
    			formatSsn(pieces[5]), pieces[1], sensitive);
    }
    
    private static String formatSsn(String ssn) 
    {
      ssn += "";
    	if (ssn.length() >= 9)
    	{
    		String part1 = ssn.substring(0, 3);
    		String part2 = ssn.substring(3, 5);
    		String part3 = ssn.substring(5);
    		
    		ssn = part1 + "-" + part2 + "-" + part3;
    	}
    	
    	return ssn;
	}

	/**
     * Extracts the first photo Id filename from the RPC response from VistA
     * @param vistaResult
     * @return
     */
    public static String extractPatientPhotoIdFilenameFromVistaResult(String vistaResult)
    {
    	if(vistaResult == null)
    		return null;
    	
    	String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
    	
    	return lines.length < 2 ? null : StringUtils.Split(lines[1], StringUtils.CARET)[2];
    }
    
    /**
     * Creates a list of images from an RPC response from VistA for a list of images associated with a TIU note
     * @param vistaResult
     * @param patientIcn
     * @param site
     * @return
     * @throws VistaParsingException 
     */
    public static List<Image> createImageListFromTiuNoteResponse(
    	String vistaResult,
    	String studyId,
    	PatientIdentifier patientId, 
    	Site site) 
    throws VistaParsingException
    {
    	return extractImageListFromVistaResult(vistaResult, studyId, patientId, site);
    }
    
    /**
     * Creates a list of images from an RPC response from VistA for a list of images associated with a Radiology consult
     * @param vistaResult
     * @param patientIcn
     * @param site
     * @return
     * @throws VistaParsingException 
     */
    public static List<Image> createImageListFromRadExamResponse(
    	String vistaResult, 
    	String studyId,
    	PatientIdentifier patientId, 
    	Site site) 
    throws VistaParsingException
    {
    	return extractImageListFromVistaResult(vistaResult, studyId, patientId, site);
    }

    /**
     * 
     * @param vistaResult
     * @param patientIcn
     * @param site
     * @return
     * @throws VistaParsingException 
     */
	private static List<Image> extractImageListFromVistaResult(
		String vistaResult, 
		String studyId, 
		PatientIdentifier patientId, 
		Site site) 
	throws VistaParsingException
	{
    	if(StringUtils.isEmpty(vistaResult)) 
    	{
    		LOGGER.warn("Given 'vistaResult' String is either null or empty. Return null.");
    		return null;
    	}
    	
    	if(site == null) 
    	{
    		LOGGER.warn("Given 'site' is null. Return null.");
    		return null;
    	}

		List<Image> images = new ArrayList<Image>();
    	
		List<VistaImage> vistaImages = extractVistaImageListFromVistaResult(vistaResult);

		for(VistaImage vistaImage : vistaImages)
		{
			Image image = null;
			
			try
			{
				image = transform(site.getSiteNumber(), studyId, patientId, vistaImage);
	    		images.add(image);
			}
			catch (URNFormatException x)
			{
				LOGGER.error("Exception parsing VistaImage [" + vistaImage.toString() + "]: " + x.getMessage());
			} 
		}
		
    	return images;
    }
    
    /**
     * 
     * @param vistaResult
     * @param patientIcn
     * @param site
     * @return
     * @throws VistaParsingException 
     */
	public static List<VistaImage> extractVistaImageListFromVistaResult(String vistaResult) 
	throws VistaParsingException
	{
    	if(StringUtils.isEmpty(vistaResult)) 
    	{
    		LOGGER.warn("Given 'vistaResult' String is either null or empty. Return null.");
    		return null;
    	}
      
    	List<VistaImage> images = new ArrayList<VistaImage>();
    	
    	String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
    	
    	for(String line : lines)
    	{
    		VistaImage image = VistaImage.create(line);
    		if(image != null)
    			images.add(image);
    	}
    	
    	return images;
	}

	
	public static CprsIdentifierImages extractCprsImageListFromVistaResult(
			Site site,
			PatientIdentifier patientId,
			String vistaResult,
			StudyFilter filter) 
	throws VistaParsingException, TranslationException, URNFormatException
	{
if(vistaResult == null)
    		return null;
		
    	CprsIdentifierImages cprsIdImages = new CprsIdentifierImages();
    	String [] cprsIdLines = StringUtils.Split(vistaResult,CONTEXT_NEXT);
		if(LOGGER.isDebugEnabled()){LOGGER.debug(" extractCprsImageListFromVistaResult - cprsIdLines.length = " + cprsIdLines.length);}
    	
    	for(int i = 1; i < cprsIdLines.length; i++)
    	{
        	String cprsIdLine = cprsIdLines[i];
    		String [] lines = StringUtils.Split(cprsIdLine, StringUtils.NEW_LINE);
    		String cprsId = StringUtil.Piece(lines[0], StringUtil.STICK, 2);
    		
    		if(LOGGER.isDebugEnabled()) LOGGER.debug("cprsId = " + cprsId);
    		
    		Boolean err = StringUtil.Piece(lines[0], StringUtil.STICK, 3).equals("0");

    		if (err) 
    		{
        		String errMsg = StringUtil.Piece(lines[0], StringUtil.STICK, 4);
            	if(LOGGER.isDebugEnabled()) LOGGER.debug("cprsId error = " + errMsg);
				cprsIdImages.getErrorVistaImages().put(cprsId, errMsg);
    		}
    		else
    		{
    			List<Study> studyList = new ArrayList<Study>();
        		Boolean isTIU = StringUtil.Piece(cprsId, StringUtil.CARET, 4).equals("TIU");
        		Boolean isRA = StringUtil.Piece(cprsId, StringUtil.CARET, 4).equals("RA");
    	    	
				if(LOGGER.isDebugEnabled()) LOGGER.debug("Patch 185 and beyond: " + filter.isIncludeAllObjects());

				//P185 + up
        		if (filter.isIncludeAllObjects())
        		{
					if (isRA || isTIU) 
					{
						studyList = TranslateRadAndTIUStudies(
								site, patientId, cprsIdImages,  
								cprsId, lines, filter, isRA, isTIU);
					}
	    			else
	    			{
	            		String errMsg = "Package unknown for CPRS Identifier.";
	                	if(LOGGER.isDebugEnabled()){LOGGER.debug("CPRS Identifier: "+cprsId+", error: " + errMsg);}
	    				cprsIdImages.getErrorVistaImages().put(cprsId, errMsg);    				
	    			}
        		}
        		//pre 185
        		else
        		{
        			if (isTIU) 
        			{
        				studyList = TranslateTiuStudies(
        						site, patientId, cprsIdImages,  
        						cprsId, lines);
        			}
        			else if(isRA)
        			{
						studyList = TranslateRadAndTIUStudies(
								site, patientId, cprsIdImages,  
								cprsId, lines, filter, isRA, isTIU);
        			}
        			else
        			{
                		String errMsg = "Package unknown for CPRS Identifier.";
                    	if(LOGGER.isDebugEnabled()) LOGGER.debug("CPRS Identifier: " + cprsId + ", error: " + errMsg);
        				cprsIdImages.getErrorVistaImages().put(cprsId, errMsg);    				
        			}
        		}
        		
				    cprsIdImages.getVistaStudies().put(cprsId, studyList);
    		}
    	}
    	
    	AddStudiesWithErrors(site, patientId, cprsIdImages);
    	
    	return cprsIdImages;
	}

	public static List<Study> TranslateRadStudies(
			Site site,
			PatientIdentifier patientId,
			CprsIdentifierImages cprsIdImages,
			String cprsIdentifier,
			String [] lines)
	{
		StudyDeletedImageState studyDeletedImageState =  StudyDeletedImageState.cannotIncludeDeletedImages;

		String lineCount = StringUtil.Piece(lines[0], "|", 4);
		String studyLines = lineCount + StringUtils.NEW_LINE;
		studyLines += AddStudyLines(lines);
		if(LOGGER.isDebugEnabled()){LOGGER.debug("studyLines = " + studyLines);}
		
		SortedSet<Study> studies = VistaImagingTranslator.createStudiesFromGraph(
				site, studyLines, StudyLoadLevel.STUDY_ONLY_NOSERIES, studyDeletedImageState);
	
		List<Study> studyList = cprsIdImages.getVistaStudies().get(cprsIdentifier);
		
		if (studyList == null) {
			studyList = new ArrayList<Study>();
		}
		
		for(Study study: studies)
		{
			study.setContextId(cprsIdentifier);
			studyList.add(study);
			if (Integer.parseInt(study.getStudyIen()) >= cprsIdImages.getLastStudyIen()) {
				cprsIdImages.setLastStudyIen(Integer.parseInt(study.getStudyIen()));
			}
		}
		
		return studyList;
    }

    /**
     * 
     * @param vistaResult
     * @param patientIcn
     * @param site
     * @return
     * @throws VistaParsingException 
     */
	public static CprsIdentifierImages extractCprsImageListFromVistaResult(String vistaResult) 
	throws VistaParsingException
	{
    	if(StringUtils.isEmpty(vistaResult)) 
    	{
    		LOGGER.warn("Given 'vistaResult' String is either null or empty. Return null.");
    		return null;
    	}
    	
    	CprsIdentifierImages cprsIdImages = new CprsIdentifierImages();
    	
    	String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
    	
    	if(LOGGER.isDebugEnabled()) LOGGER.debug("vistaResult [" + 0 + "] = " + lines[0]);
    	
    	if(StringUtil.Piece(lines[0], "^", 1).equals("0")) 
    	{
        	LOGGER.info("RPC [MAGN CPRS IMAGE LIST] error: " + StringUtil.Piece(lines[0], "^", 1));
    		return null;
    	}
    	
    	for(int i = 1; i < lines.length; i++)
    	{
			if(LOGGER.isDebugEnabled()) LOGGER.debug("vistaResult [" + i + "] = " + lines[i]);

    		String cprsId = StringUtil.Piece(lines[i], "|", 1);
    		boolean isErrorRecord = StringUtil.Piece(lines[i], "|", 2).equals("0");
    		String imageInfo = StringUtil.Piece(lines[i], "|", 3);
    		String groupIen = StringUtil.Piece(imageInfo, "^", 25);
    		
    		if(isErrorRecord) 
    		{
    			cprsIdImages.getErrorVistaImages().put(cprsId, imageInfo);
    		}
    		else
    		{
    			List<VistaImage> images = cprsIdImages.getVistaImages().get(cprsId);
    			if (images == null) 
    			{
    		    	images = new ArrayList<VistaImage>();
    		    	cprsIdImages.getVistaImages().put(cprsId, images);
    			}
    			
        		VistaImage image = VistaImage.create(imageInfo);
        		if(image != null) 
        		{
        			images.add( image );
        		}
        		
        		String group = cprsIdImages.getVistaImageGroups().get(cprsId);
        		if (group == null) 
        		{
        			cprsIdImages.getVistaImageGroups().put(cprsId, groupIen);
    			}
    		}
    	}
    	
    	return cprsIdImages;
	}

	@SuppressWarnings("rawtypes")
	public static void AddStudiesWithErrors(
			Site site,
			PatientIdentifier patientId,
			CprsIdentifierImages cprsIdImages)
	throws VistaParsingException, TranslationException{
		
		StudyDeletedImageState studyDeletedImageState =  StudyDeletedImageState.cannotIncludeDeletedImages;

		Set set = cprsIdImages.getErrorVistaImages().entrySet();
	    Iterator iterator = set.iterator();
    	int maxStudyIen = cprsIdImages.getLastStudyIen();

	    while(iterator.hasNext()) 
	    {	    	
			try
			{
				maxStudyIen++;
				Study study = Study.create(ObjectOrigin.UNKNOWN, site.getSiteNumber(), 
						maxStudyIen + "", patientId, StudyLoadLevel.STUDY_AND_IMAGES, 
						studyDeletedImageState);
				Map.Entry mentry = (Map.Entry)iterator.next();
				String cprsId = mentry.getKey().toString();
				String errMsg = mentry.getValue().toString();
				study.setErrorMessage(errMsg); //add error message  
				study.setContextId(cprsId);
				
				List<Study> studyList = cprsIdImages.getVistaStudies().get(cprsId);
	    		
				if (studyList == null) 
				{
					studyList = new ArrayList<Study>();
	    		}
				
				studyList.add(study);
				cprsIdImages.getVistaStudies().put(cprsId, studyList);
			}
			catch (URNFormatException x)
			{
				LOGGER.error("Unable to create a Study from the given key elements");
				throw new TranslationException("Unable to create a Study from the given key elements");
			}
		}
	}

	public static String AddStudyLines(String [] lines)
	{
		List<String> lineList = new ArrayList<String>();
		
		//Remove empty lines. Skip the first one. Messy to use other methods.  Leave as is.
		for(int i = 1; i < lines.length; i++)
		{
			String line = lines[i];
			line = StringUtil.Piece(line, StringUtil.CRCHAR, 1);
			line = StringUtil.Piece(line, StringUtil.NEW_LINECHAR, 1);
			
			if (!line.trim().isEmpty())
				lineList.add(line);
		}
		
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < lineList.size(); i++)
		{
			sb.append(lineList.get(i) + StringUtils.NEW_LINE);
		}
		
		return sb.toString().substring(0, sb.length() - 1); // remove the extra new line;
	}
	
	public static List<Study> TranslateTiuStudies(
			Site site,
			PatientIdentifier patientId,
			CprsIdentifierImages cprsIdImages,
			String cprsId,
			String[] lines)
	throws VistaParsingException, URNFormatException
	{
		String headerLine = "Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0";
		
		String studyLines = "1" + StringUtils.NEW_LINE + headerLine + StringUtils.NEW_LINE;
		studyLines += AddStudyLines(lines);
		
		if(LOGGER.isDebugEnabled()) LOGGER.debug("TIU studyLines = " + studyLines);
		
		SortedSet<VistaGroup> groups = VistaImagingTranslator.createGroupsFromGroupLinesHandleSingleImageGroup(
				site, studyLines, patientId, StudyLoadLevel.FULL, 
				StudyDeletedImageState.cannotIncludeDeletedImages);
		
		SortedSet<Study> studies = VistaImagingTranslator.transform(ObjectOrigin.VA, site, groups);
		
		List<Study> studyList = cprsIdImages.getVistaStudies().get(cprsId);
		
		if (studyList == null) {
			studyList = new ArrayList<Study>();
		}
		
		for(Study study: studies)
		{
			study.setContextId(cprsId);
			studyList.add(study);

			SortedSet<Image> images = new TreeSet<Image>();						
			
			Image img = study.getFirstImage();
			if (img != null)
			{
				images.add(img);
				VistaImagingCommonUtilities.addImagesToStudyAsSeries(study, images);
			}
			
			if (Integer.parseInt(study.getStudyIen()) >= cprsIdImages.getLastStudyIen()) {
				cprsIdImages.setLastStudyIen(Integer.parseInt(study.getStudyIen()));
			}
		}
		
		return studyList;
	}
	
	public static List<Study> TranslateRadAndTIUStudies(
			Site site,
			PatientIdentifier patientId,
			CprsIdentifierImages cprsIdImages,
			String cprsId,
			String [] lines,
			StudyFilter filter,
			boolean isRA,
			boolean isTIU) {
		
		StudyDeletedImageState studyDeletedImageState =  StudyDeletedImageState.cannotIncludeDeletedImages;
		
		String lineCount = StringUtil.Piece(lines[0], "|", 4);
		String studyLines = lineCount + StringUtils.NEW_LINE;
		studyLines += AddStudyLines(lines);
		
		StudyLoadLevel metaDataLevel = filter != null && filter.isIncludeImages() ? StudyLoadLevel.STUDY_AND_IMAGES : StudyLoadLevel.STUDY_ONLY_NOSERIES;

		if(LOGGER.isDebugEnabled()) LOGGER.debug("RAD/TIU study to translate: " + studyLines + ", studyloadlevel: " + metaDataLevel.getDescription());

		SortedSet<Study> studies = VistaImagingTranslator.createStudiesFromGraph(
				site, studyLines, metaDataLevel, studyDeletedImageState);
	
		List<Study> studyList = cprsIdImages.getVistaStudies().get(cprsId);
		
		if (studyList == null) 
		{
			studyList = new ArrayList<Study>();
		}
		
		for(Study study: studies)
		{
			study.setContextId(cprsId);
			studyList.add(study);
			
			if (Integer.parseInt(study.getStudyIen()) >= cprsIdImages.getLastStudyIen()) 
			{
				cprsIdImages.setLastStudyIen(Integer.parseInt(study.getStudyIen()));
			}
		}
		
		return studyList;
    }

	/**
     * Extract the group parent IEN from an RPC response for the 0 node of an image
     * @param vistaResult
     * @return The IEN of the parent group image or null if this image represents a group image
     */
    public static String extractGroupIenFromNode0Response(String vistaResult)
    {
    	String [] pieces = StringUtils.Split(vistaResult, StringUtils.CARET);

    	// if there is no 10th piece, then this is a group image and does not have a parent
    	// 10th piece of result is group IEN if passed image data
    	return pieces.length < 10 ? null :  pieces[9];
    }
    
    public static List<String> translateUserKeys(String vistaResult)
    {
    	List<String> result = new ArrayList<String>();
    	String [] keys = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
		
		// trim whitespace, including CR and/or LF characters
		if(keys != null)
		{
			for(int index = 0; index < keys.length; ++index)
			{
				result.add(keys[index].trim());
			}
		}

		return result;
    }

	public static List<Division> translateDivisions(String vistaResult) 
	{
    	List<Division> result = new ArrayList<Division>();
    	String [] divisions = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
		
		// trim whitespace, including CR and/or LF characters
		if(divisions != null)
		{
			for(int i = 1; i < divisions.length; i++)
			{
				String [] fields = StringUtils.Split(divisions[i], StringUtils.CARET);
				result.add(new Division(fields[0].trim(), fields[1].trim(), fields[2].trim()));
			}
		}

		return result;
	}
	
	/**
	 * Position 0 = duz, 1 = name, 4 = title, 5 = service
	 * 
	 * @param vistaResult
	 * @return
	 */
	public static User translateUser(String vistaResult)
	{
    	if(StringUtils.isEmpty(vistaResult)) 
    	{
    		LOGGER.warn("VistaImagingTranslator.translateUser() --> Given 'vistaResult' String is either null or empty. Return null.");
    		return null;
    	}

		String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);

		//duz, name, title, service
		return new VistaUser(lines[0].trim(), lines[1].trim(), lines[4].trim(), lines[5].trim());
	}
	
	public static List<String> convertTreatingSiteListToSiteNumbers(String vistaResult, 
			boolean includeTrailingCharactersForSite200)
	{
		List<String> result = new ArrayList<String>();
		StringBuilder initialSiteList = new StringBuilder();
		StringBuilder convertedSiteList = new StringBuilder();
		String prefix = "";
		
		if(vistaResult != null)
		{
			String [] lines = StringUtils.Split(vistaResult.trim(), StringUtils.NEW_LINE);
			if(lines.length <= 0)
			{
				LOGGER.warn("Got empty string results from VistA for treating sites, this shouldn't happen!");
			}
			else if(lines.length > 0)
			{
				String headerLine = lines[0].trim();
				
				if(headerLine.startsWith("0"))
				{
					LOGGER.info("Patient has no treating sites, " + vistaResult);
				}
				else
				{
					if(LOGGER.isDebugEnabled()) LOGGER.debug("Treating sites header line, " + headerLine);
					
					for(int i = 1; i < lines.length; i++)
					{
						String [] pieces = StringUtils.Split(lines[i], StringUtils.CARET);
						
						String initialSiteNumber = pieces[0].trim();
						String convertedSiteNumber = extractUnnecessarySiteNumberCharacters(initialSiteNumber, 
								includeTrailingCharactersForSite200);
						initialSiteList.append(prefix);
						initialSiteList.append(initialSiteNumber);
						convertedSiteList.append(prefix);
						convertedSiteList.append(convertedSiteNumber);
						result.add(convertedSiteNumber);
						prefix = ", ";
					}					
				}
			}
		}
		
		LOGGER.info("Converted site list [" + initialSiteList.toString() + "] to [" + convertedSiteList.toString() + "]");
		// put into a hashset to exclude duplicate entries
		return new ArrayList<String>(new HashSet<String>(result));
	}
	
	/**
	 * This method looks at the site number and extracts unnecessary characters. If the site
	 * number starts with letters, they are excluded.  Any letters after numbers are excluded and
	 * any numbers following that are also excluded.
	 * 
	 * ex: ABC200T1 translates to 200
	 * @param rawSiteNumber
	 * @return
	 */
	private static String extractUnnecessarySiteNumberCharacters(String rawSiteNumber, 
			boolean includeTrailingCharactersForSite200)
	{
    	if(StringUtils.isEmpty(rawSiteNumber)) 
    	{
    		LOGGER.warn("VistaImagingTranslator.extractUnnecessarySiteNumberCharacters() --> Given 'rawSiteNumber' String is either null or empty. Return null.");
    		return null;
    	}

		StringBuilder result = null;
		
		for(int i = 0; i < rawSiteNumber.length(); i++)
		{
			char ch = rawSiteNumber.charAt(i);
			int c = (int) ch;
			// check if the character is a letter
			if((c < 48) || (c > 57))
			{
				if(result != null)
				{
					// we have already added some numbers to the result so we are looking at trailing characters
					String sNumber = result.toString();
					// if the current site number is 200
					if(sNumber.startsWith(ExchangeUtil.getDodSiteNumber()))
					{
						// if we want to include trailing characters for 200
						if(includeTrailingCharactersForSite200)
							result.append(ch);	// add the character
						else
							return result.toString(); // return the value
					}
					else
					{
						// not site 200 so just return the value
						return result.toString();
					}
				}
			}
			else
			{
				if(result == null)
					result = new StringBuilder();
				
				result.append(ch);
			}
		}
		
		return result == null ? "" : result.toString();
	}	
	
	/**
	 * 
	 * Position 0 = reasonCode, 1 = description, 2 = types, 4 = global code
	 * 
	 		1^Ok
			13^All images were removed from the group^D^^13
			6^Authorized release of medical records or health information (ROI)^CP^^6
			2^Clinical care for other VA patients^CP^^2
			1^Clinical care for the patient whose images are being downloaded^CP^^1
			7^Corrupt image^D^^7
			4^For approved teaching purposes by VA staff^CP^^4
			5^For use in approved VA publications^CP^^5
			3^For use in approved research by VA staff^CP^^3
			14^HIMS document correction^DS^^14
			12^Image is incorrectly included in an image group^S^^12
			8^Low quality image^DS^^8
			9^Wrong case/exam/accession number^DS^^9
			10^Wrong note title^D^^10
			11^Wrong patient^D^^11
	 * 
	 * @param site
	 * @param vistaResult
	 * @return
	 * @throws MethodException
	 */
	public static List<ImageAccessReason> translateImageAccessReasons(Site site, String vistaResult)
	throws MethodException
	{
		List<ImageAccessReason> reasons = new ArrayList<ImageAccessReason>();
		
    	if(StringUtils.isEmpty(vistaResult)) 
    	{
    		LOGGER.warn("Given 'vistaResult' String is either null or empty. Return empty List.");
    		return reasons;
    	}

    	if(site == null) 
    	{
    		LOGGER.warn("Given 'site' is null. Return empty List.");
    		return reasons;
    	}

		if(vistaResult.startsWith("0"))
		{
			LOGGER.warn("Error retrieving the image access reason list");
			throw new MethodException("Error retrieving the image access reason list [" + vistaResult + "]");
		}
		
		RoutingToken routingToken = site.createRoutingToken();
		
		String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
		
		for(int i = 1; i < lines.length; i++)
		{
			String [] pieces = StringUtils.Split(lines[i].trim(), StringUtils.CARET);
			
			// Fixed potential ArrayIndexOutOfBoundsException from this line "1^Ok"
			if(pieces.length == 2)
				reasons.add(new ImageAccessReason(routingToken, Integer.parseInt(pieces[0]), pieces[1], 
						translateReasons(null), null));
			else
				reasons.add(new ImageAccessReason(routingToken, Integer.parseInt(pieces[0]), pieces[1],
						translateReasons(pieces[2]), pieces[4]));
		}
		
		return reasons;
	}
	
	private static List<ImageAccessReasonType> translateReasons(String types)
	{
		List<ImageAccessReasonType> result = new ArrayList<ImageAccessReasonType>();
		if(types != null)
		{
			char [] charArray = types.toCharArray();
			
			for(int i = 0; i < charArray.length; i++)
			{				
				String reasonCode = String.valueOf(charArray[i]);
				ImageAccessReasonType reasonType =
					ImageAccessReasonType.getFromCode(reasonCode);
				if(reasonType == null)
				{
					LOGGER.warn("Could not find an ImageAccessReasonType for code '" + reasonCode + "'.");
				}
				else
				{
					result.add(reasonType);
				}
			}
		}
		
		return result;
	}
	
	public static ElectronicSignatureResult translateElectronicSignature(String vistaResult)
	{
		if(StringUtils.isEmpty(vistaResult))
			return null;
		
		String [] pieces = StringUtils.Split(vistaResult.trim(), StringUtils.CARET);
		
		if("0".equals(pieces[0]))
		{
			TransactionContextFactory.get().addDebugInformation("verifyElectronicSignature() failed for VistA result [" + vistaResult + "]");
			LOGGER.error("Error verifying e-signature for VistA result [" + vistaResult + "]");
			return new ElectronicSignatureResult(false, pieces[1]);
		}
		else
		{
			return new ElectronicSignatureResult(true, pieces[1]);
		}
	}
	
	public static List<HealthSummaryType> translateHealthSummaries(String vistaResult, Site site)
	throws MethodException
	{
		List<HealthSummaryType> result = new ArrayList<HealthSummaryType>();
		
    	if(StringUtils.isEmpty(vistaResult)) 
    	{
    		LOGGER.warn("Given 'vistaResult' String is either null or empty. Return empty List.");
    		return result;
    	}
    	
    	if(site == null) 
    	{
    		LOGGER.warn("Given 'site' is null. Return empty List.");
    		return result;
    	}

		String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
		
		for(int i = 1; i < lines.length; i++)
		{
			String [] pieces = StringUtils.Split(lines[i].trim(), StringUtils.CARET);

			try
			{
				HealthSummaryURN healthSummaryUrn = HealthSummaryURN.create(site.getSiteNumber(), pieces[1]);
				result.add(new HealthSummaryType(healthSummaryUrn, pieces[0]));
			}
			catch(URNFormatException urnfX)
			{
				throw new MethodException(urnfX);
			}
		}
		
		return result;
	}
	
	public static String translateHealthSummary(String vistaResult)
	throws MethodException
	{
    	if(StringUtils.isEmpty(vistaResult)) 
    	{
    		LOGGER.warn("VistaImagingTranslator.translateHealthSummary() --> Given 'vistaResp' String is either null or empty. Return null.");
    		return null;
    	}

		if(!vistaResult.startsWith("1"))
		{
			LOGGER.warn("VistaImagingTranslator.translateHealthSummary() --> 'vistaResult' does not start with the desired value.");
			throw new MethodException(vistaResult);
		}
		
		String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
		StringBuilder result = new StringBuilder();
		
		for(int i = 1; i < lines.length; i++)
		{
			result.append(lines[i].trim() + StringUtils.NEW_LINE);
		}
		
		return result.toString();
	}

	public static ApplicationTimeoutParameters translateApplicationTimeoutParameters(String vistaResult)
	throws MethodException
	{		
		// Handle case where the result is blank / null. We don't need to log this; this occurs regularly
    	if(StringUtils.isEmpty(vistaResult)) 
    	{
    		return new ApplicationTimeoutParameters(0);
    	}

		// Initialize the timeout to 0
		int timeoutInSeconds = 0;

		// try to parse the returned value into an integer. If successful,
		// update the timeoutInSeconds variable
		try 
		{
			timeoutInSeconds = Integer.parseInt(vistaResult) * 60;
		} 
		catch (Exception e) 
		{
			// Log the exception
            LOGGER.info("Unable to parse importer application timeout value from RPC result: {}", vistaResult, e);
		}

		// Return the instance. The timeout value will either be what was
		// returned from VistA, or 0
		return new ApplicationTimeoutParameters(timeoutInSeconds);
	}
	
	/**
     * Position 1 = IEN, 2 = filename, 8 = dateString, 20 = patientName
     * 
     * Extracts the first photo Id filename from the RPC response from VistA
     * @param vistaResult
     * @return
     */
    public static VistaPatientPhotoIDInformation extractPatientPhotoIdInformationFromVistaResult(String vistaResult)
    {
    	/**
    	 1^1
		B2^12539^\\delphidevm\image1$\ECG0\00\00\01\25\ECG00000012539.JPG^\\delphidevm\image1$\ECG0\00\00\01\25\ECG00000012539.ABS^PHOTO ID^3131219.094^18^PHOTO ID^12/19/2013 09:40^^M^A^^^1^1^EHR^^^3^ZZ PATIENT,TEST THREE^ADMIN/CLIN^12/19/2013 09:41:24^12/19/2013^0^0:0^^^0^0^0^
    	 */
    	
    if(StringUtils.isEmpty(vistaResult))
    		return null;
    	
    	String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
    	
    	if(lines.length < 2)
    		return null;
    	
    	String [] linePieces = StringUtils.Split(lines[1], StringUtils.CARET);
    	
    	Date date = null;
    	try
    	{
    		// 12/19/2013 09:40
    		date = new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(linePieces[8]);
    	}
    	catch(ParseException pX)
    	{
    		LOGGER.warn("Error parsing patient photo ID date: " + pX.getMessage());
    	}
      
    	return new VistaPatientPhotoIDInformation(linePieces[20], linePieces[2], date, linePieces[1]);
    }
    
    private static String createUNCForImageInNewDataStructure(String networkLocation, String fileRef, String filePath)
    {
		StringBuilder sb = new StringBuilder();
		
		sb.append(networkLocation);
		sb.append(filePath);
		sb.append(fileRef);

		return sb.toString();			
    }
    
   private static ArtifactInstance getBestProviderImageUNC(Map<String,ArtifactInstance> imageProviderMap)
    {    	
    	return imageProviderMap.containsKey("RAID") ? imageProviderMap.get("RAID") : imageProviderMap.get("JUKEBOX");
    }

	public static List<Study> ConvertVistaResultToStudyList(
			Site site,
			String vistaResult,
			StudyFilter filter)
	{
		List<Study> studyList = new ArrayList<Study>();
		
		if(StringUtils.isEmpty(vistaResult))
    		return studyList;
		
		StudyDeletedImageState studyDeletedImageState =  StudyDeletedImageState.includesDeletedImages;
		StudyLoadLevel studyLoadLevel = StudyLoadLevel.STUDY_ONLY_NOSERIES;
		
		SortedSet<Study> studies = createStudiesFromGraph(
				site, 
				StringUtils.Split(vistaResult, StringUtils.NEW_LINE), 
				studyLoadLevel, 
				studyDeletedImageState);
	
		studyList.addAll(studies);
		
		return studyList;
    }

    public static SortedSet<VistaGroup> createGroupsFromGroupLines(
        	Site site, 
        	String groupList, 
        	StudyDeletedImageState studyDeletedImageState)
    throws VistaParsingException
    {
    	SortedSet<VistaGroup> groups = new TreeSet<VistaGroup>();    	
    	String headerLine = "";
    	
    	if(groupList.charAt(0) == '1') 
    	{			
			String[] lines = StringUtils.Split(groupList, StringUtils.NEW_LINE);
			// the first two lines of the response contain the response status and the metadata, respectively
			if(lines.length <= 0)
				throw new VistaParsingException("Study list contains no status, meta-data or data.");
			
			if(lines.length == 1)
				throw new VistaParsingException("Study list contains no meta-data or data.");
			
			if(lines.length == 2)
			{
				LOGGER.info("Study list contains no data.");
				return groups;
			}
			
			LOGGER.info("Found and parsing [" + lines.length + "] lines of group data");
			// parse the response status line and retain the ???
			String rpcResponseLine = lines[0].trim();
			String response = StringUtils.MagPiece(rpcResponseLine, StringUtils.CARET, 2);
			
			// the headerLine is the metadata, describes the format of the study results
			// save it and pass to the method that actually parses the study lines
			headerLine = lines[1];
			
			// for each remaining line in the response, parse a Study instance and add it
			// to our list
			for(int j = 2; j < lines.length; j++) 
			{
				VistaGroup group = null;
				
				try
				{
					String dfn = StringUtils.Piece(lines[j], "^", 35);
					
					if(LOGGER.isDebugEnabled()) LOGGER.debug("Parsing line for patient dfn: " + dfn);
					
					PatientIdentifier patientIdentifier = PatientIdentifier.dfnPatientIdentifier(dfn, site.getSiteNumber());
					group = createGroupFromGroupLine(site, headerLine, lines[j], patientIdentifier, studyDeletedImageState);
					
					if(group != null)
					{
						group.setRpcResponseMsg(response);
						
						if(!groups.add(group))
							LOGGER.warn("Duplicate group, IEN [" + group.getIen() + "] is not being added to result set.");
					}
				}
				catch (URNFormatException x)
				{
					throw new VistaParsingException(x);
				}
			}
		}
    	
    	return groups;
    }

    public static List<StoredStudyFilter> translateFilters(String vistaResult, RoutingToken routingToken)
    throws URNFormatException
    {
    	/*
			15
			16^NST ORIGIN^20095
			15^Clinical All^20095
			14^Admin All^20095 
    	 */
    if(StringUtils.isEmpty(vistaResult))
    		return null;
    	
    	String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
    	
    	List<StoredStudyFilter> result = new ArrayList<StoredStudyFilter>();
    	
    	for(int i = 1; i < lines.length; i++)
    	{
    		String [] pieces = StringUtils.Split(lines[i], StringUtils.CARET);

    		StoredStudyFilter storedStudyFilter = new StoredStudyFilter();
    		
    		StoredStudyFilterURN urn = StoredStudyFilterURN.create(routingToken.getRepositoryUniqueId(), pieces[0]);    	    	
    		storedStudyFilter.setStoredStudyFilterUrn(urn);
    		storedStudyFilter.setName(pieces[1]);
    		result.add(storedStudyFilter);
    	}    
      
      return result;
    }

}
