/**
 * 
 * 
 * Date Created: Jan 26, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.ingest.web;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.FileTypeIdentifierStream;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.ingest.IngestRouter;
import gov.va.med.imaging.ingest.ItemStream;
import gov.va.med.imaging.ingest.business.ImageIngestParameters;
import gov.va.med.imaging.ingest.business.TIUNoteSignatureOption;
import gov.va.med.imaging.ingest.exceptions.ImageFormatNotSupportedException;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tomcat.vistarealm.encryption.EncryptionToken;
import gov.va.med.imaging.tomcat.vistarealm.encryption.TokenExpiredException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author Julian Werfel
 *
 * https://{host}.vha.med.va.gov:443/IngestWebApp/token/ingest?securityToken={token} 
 * 
 * INPUT REQUEST FORM PARAMS:
 * 	patientId: {icn}
 * 	originIndex: VA
 * 	typeIndex: ADVANCE DIRECTIVE
 * 	imageDescription_0: Image One Description 
 * 	imageDescription_1: Image Two Description 
 * 	patientTiuNoteUrn: urn:patientnote:{site}-{study}-{icn}
 * 	shortDescription: Short Description Title 
 * 	image_0:<<FILE 1>> 
 * 	image_1:<<FILE 2>>
 * 
 * OUTPUT: urn:vaimage:{site}-{image}-{study}-{icn}
 *
 */

public abstract class BaseIngestServlet
extends HttpServlet
{

	private final static Logger logger = Logger.getLogger(BaseIngestServlet.class);
	private static final long serialVersionUID = 7165456961445516376L;

	protected abstract RoutingToken createLocalRoutingToken()
	throws RoutingTokenFormatException;
	
	protected abstract boolean isFormatAllowed(ImageFormat imageFormat);
	
	protected abstract void sendResponse(HttpServletResponse response, Map<String, String> inputParameters, 
		ImageURN imageUrn, String patientTiuNoteUrn, Throwable t)
	throws IOException;
	
	protected abstract String getWebAppName();
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWebAppName() + " uploadImage");

		// Create a factory for disk-based file items
		DiskFileItemFactory factory = new DiskFileItemFactory();

		// Create a new file upload handler
		ServletFileUpload upload = new ServletFileUpload(factory);

		// Set overall request size constraint
		String patientId = null;
		String shortDescription = null;
		Map<String, String> inputParameters = new HashMap<String, String>();
		Map<String,String> imageDescriptions = new HashMap<String, String>();
		// Parse the request
		try {
			List<FileItem> items = upload.parseRequest(request);
			// Process the uploaded items
			Iterator<FileItem> iter = items.iterator();
			java.io.InputStream inputStream = null;
			if(logger.isDebugEnabled()) {
                logger.debug("Transaction Context DUZ: {}", transactionContext.getDuz());}

			String procedure = "CLIN";
			String origin = "NON-VA";
			String studyId = "";
			String createGroupString = "false";
			String typeIndex = null;
			String specialtyIndex = null;
			String procedureEventIndex = null;

			String tiuNoteTitleUrn = null;
			String patientTiuNoteUrn = null;
			String tiuNoteLocationUrn = null;
			String tiuNoteText = null;
			String consultId = null;
			String imgData = null;
			String securityToken = null;
			String captureUser = null;

			//add AuthorURN and a flag to handle the ability to auto-create TIUNotes if necessary.
			String tiuNoteAuthorUrn = null;
			TIUNoteSignatureOption signatureFlag = TIUNoteSignatureOption.EF;
			List<ItemStream> lst = new ArrayList<ItemStream>();
			while (iter.hasNext()) {
				FileItem item = iter.next();

				if (item.isFormField()) {
					String name = item.getFieldName();
					String value = item.getString();
					if(logger.isDebugEnabled()) {
                        logger.debug("name: [{}]; value: [{}]", name, value);}
					inputParameters.put(name, value);
					if ("patientId".equals(name))
						patientId = value;
					if ("shortDescription".equals(name))
						shortDescription = value;
					if ("procedure".equals(name))
						procedure = value;
					if ("originIndex".equals(name))
						origin = value;
					if ("studyUrn".equals(name))
						studyId = value;
					if ("consultUrn".equals(name))
						consultId = parseConsultIEN(value);
					if ("createGroup".equals(name))
						createGroupString = value;
					if ("typeIndex".equals(name))
						typeIndex = value;
					if ("specialtyIndex".equals(name))
						specialtyIndex = value;
					if ("procedureEventIndex".equals(name))
						procedureEventIndex = value;
					if ("tiuNoteTitleUrn".equals(name))
						tiuNoteTitleUrn = value;
					if ("tiuNoteUrn".equals(name))
						tiuNoteTitleUrn = value;
					if ("tiuNoteLocationUrn".equals(name))
						tiuNoteLocationUrn = value;
					if ("tiuNoteText".equals(name))
						tiuNoteText = value;
					if ("patientTiuNoteUrn".equals(name))
						patientTiuNoteUrn = value;
					if ("imgData".equals(name))
						imgData = value;
					if ("securityToken".equals(name))
						securityToken = value;
					if ("captureUser".equals(name))
						captureUser = value;
					if ("tiuNoteAuthorUrn".equals(name))
						tiuNoteAuthorUrn = value;
					if ("signatureFlag".equals(name)) {
						if (value.equals("DNS")) {
							signatureFlag = TIUNoteSignatureOption.DNS;
						}
						if (value.equals("ES")) {
							signatureFlag = TIUNoteSignatureOption.ES;
						}
						if (value.equals("EF")) {
							signatureFlag = TIUNoteSignatureOption.EF;
						}
					}
					if(name != null && name.startsWith("imageDescription_")){
						String[] pieces = name.split("_");
						String imageNumber = pieces[1];
						imageDescriptions.put(imageNumber, value);
					}
				} else {
					inputStream = item.getInputStream();
					String mimeType = item.getContentType();
					if (mimeType != null && mimeType.length() > 0) {						
						mimeType = mimeType.split(";")[0].trim();  //SOAPUI COMPATIBILITY
					}
					String originalFilename = item.getName();
					if (originalFilename != null && originalFilename.length() > 0) {
						originalFilename = originalFilename.trim();
					}
					String fieldName = item.getFieldName();
					if(fieldName != null && fieldName.length() > 0){
						fieldName = fieldName.trim();
					}
					
					lst.add(new ItemStream(inputStream, mimeType, originalFilename, fieldName));
				}
			}

			origin = setEmptyValueToNull(origin);
			typeIndex = setEmptyValueToNull(typeIndex);
			specialtyIndex = setEmptyValueToNull(specialtyIndex);
			procedureEventIndex = setEmptyValueToNull(procedureEventIndex);

 			if (patientTiuNoteUrn == null || patientTiuNoteUrn.isEmpty()) {
 				if(logger.isDebugEnabled()){
                    logger.debug("Parameters to create a new Patient TIU Note before Image Ingest: \nTIU Note Title URN : [{}]\nTIU Note Location URN : [{}]\nTIU Note Author URN : [{}]\nTIU Note Text : [{}]\n", tiuNoteTitleUrn, tiuNoteLocationUrn, tiuNoteAuthorUrn, tiuNoteText);
 					}
			}

 			if(logger.isDebugEnabled()){
                logger.debug("Security Token: [{}]", securityToken);}

			if ((securityToken != null) && (!securityToken.isEmpty())) {
				try {
					logger.info("Authenticating user with provided security token");

					if (securityToken.endsWith("x/x")) {
						securityToken = securityToken.substring(0, securityToken.length() - 4);
						if(logger.isDebugEnabled()){
                            logger.debug("Security token included bad trailing characters, token now [{}]", securityToken);}
					}

					EncryptionToken.decryptUserCredentials(securityToken);
				} catch (TokenExpiredException teX) {
					logger.error("Security token has expired");
					throw new ServletException("Security Token has expired");
				} catch (AesEncryptionException aesX) {
                    logger.error("Error decrypting security token, {}", aesX.getMessage());
					throw new ServletException("Cannot decrypt security token");
				}
			}

			boolean createGroup = Boolean.parseBoolean(createGroupString);
			StudyURN studyUrn = null;
			if (studyId != null && studyId.length() > 0) {
				try {
					studyUrn = URNFactory.create(studyId, StudyURN.class);
					if(logger.isDebugEnabled()){
                        logger.debug("studyURN: {}", studyUrn.toString());}
				} catch (URNFormatException urnfX) {
					throw new MethodException("Error creating StudyURN from string '" + studyId + "', " + urnfX.getMessage());
				}
			}

			boolean snapPhoto = (imgData != null);
			if (snapPhoto) {
				String[] images = imgData.split(" --end-- ");
				for (String img : images) {
					if (!img.equals("")) {
						//logger.debug(img);
						byte[] imagedata = DatatypeConverter.parseBase64Binary(img.substring(img.indexOf(",") + 1));
						inputStream = new ByteArrayInputStream(imagedata);
						lst.add(new ItemStream(inputStream));
					}
				}
			}

			if (lst.size() > 1) {
				createGroup = true;
			}

			ImageURN imageUrn = null;
			for (ItemStream itemStream : lst) {
				FileTypeIdentifierStream fileTypeIdentifierStream = new FileTypeIdentifierStream(itemStream.getInputStream());
				ImageFormat imageFormat = null;
				if (itemStream.getMimeType() != null) {
					imageFormat = ImageFormat.valueOfMimeType(itemStream.getMimeType());
				}
				else {
					imageFormat = fileTypeIdentifierStream.getImageFormat();
				}
				if ((imageFormat == null) && !snapPhoto)
					throw new MethodException("Unable to identify image, only supported images can be imported");
				boolean formatAllowed = isFormatAllowed(imageFormat);
				if (!formatAllowed && !snapPhoto)
					throw new MethodException("Image format [" + imageFormat + "] is not supported in this interface");

				if ((imageFormat != null) && formatAllowed) {
                    logger.info("Importing image with format [{}]", imageFormat);
					PatientIdentifier patientIdentifier = PatientIdentifier.fromString(patientId);
					transactionContext.setPatientID(patientIdentifier.toString());
					String imageDescription = getImageDescription(itemStream, imageDescriptions, shortDescription);
					Date date = new Date();
					ImageIngestParameters imageIngestParameters =
							new ImageIngestParameters(patientIdentifier, date, imageFormat, procedure, shortDescription,
									date, null, null, date, origin, typeIndex, specialtyIndex,
									procedureEventIndex, studyUrn, captureUser, itemStream.getOriginalFilename(),
									itemStream.getMimeType(), imageDescription, signatureFlag);

					String siteNumber = parseSiteNumber(patientId);
					if(logger.isDebugEnabled()){
                        logger.debug("Storing Image: {}", imageIngestParameters);}
					imageUrn = getRouter().storeImage(createLocalRoutingToken(), fileTypeIdentifierStream, imageIngestParameters, createGroup);
					
					transactionContext.setUrn(imageUrn.toString(SERIALIZATION_FORMAT.RAW));

					// if a group, then need to create a note and associate with the study urn
					// if a single image, then create the note and associate with image

					if (patientTiuNoteUrn != null && patientTiuNoteUrn.length() > 0) {
						logger.debug("patientTiuNoteUrn is not null.");
						// note already exists, if a single image then associate with that
						if (createGroup) {
							if (studyUrn == null) {
								// no study provided so it should be the first time
								try {
									if(logger.isDebugEnabled()){logger.debug("1st associateImageWithTIUNote call.");}
									associateImageWithTIUNote(imageUrn.getParentStudyURN(), patientTiuNoteUrn);
								} catch (URNFormatException urnfX) {
									throw new MethodException(urnfX);
								}
							}
						} else if (studyUrn == null && !createGroup) {
							// image is not part of a group, associate image with the existing note
							if(logger.isDebugEnabled()){logger.debug("2nd associateImageWithTIUNote call.");}
							associateImageWithTIUNote(imageUrn, patientTiuNoteUrn);
						}
					} else if (tiuNoteTitleUrn != null && tiuNoteTitleUrn.length() > 0) {
						// note doesn't already exist, create one using tiuNoteUrn (TIU definition)
						if(logger.isDebugEnabled()){
                            logger.debug("creating TIU Note, patientId = {} siteNumber = {}", patientId, siteNumber);}
						patientTiuNoteUrn = createTIUNote(patientIdentifier, tiuNoteTitleUrn, siteNumber, consultId, tiuNoteLocationUrn, tiuNoteText, tiuNoteAuthorUrn);
						
						if (createGroup) {
							if (studyUrn == null) {
								// no study provided so it should be the first time
								try {
									if(logger.isDebugEnabled()){logger.debug("3rd associateImageWithTIUNote call.");}
									associateImageWithTIUNote(imageUrn.getParentStudyURN(), patientTiuNoteUrn);
								} catch (URNFormatException urnfX) {
									throw new MethodException(urnfX);
								}
							}
						} else {
							// not part of a group
							if(logger.isDebugEnabled()){logger.debug("4th associateImageWithTIUNote call.");}
							associateImageWithTIUNote(imageUrn, patientTiuNoteUrn);
						}
					}

					if ((lst.size() > 1) && studyId.equals("")) {
						try {
							studyId = imageUrn.getParentStudyURN().toString(SERIALIZATION_FORMAT.RAW);
							if(logger.isDebugEnabled()){
                                logger.debug("StudyID = {}", studyId);}
							studyUrn = URNFactory.create(studyId, StudyURN.class);
						} catch (URNFormatException urnfX) {
							throw new MethodException("Error creating StudyURN from string '" + studyId + "', " + urnfX.getMessage());
						}
					}
				} else {
                    logger.info("Importing image with format [{}]", imageFormat);
					throw new ImageFormatNotSupportedException("Image with format [" + imageFormat + "] is not supported.");
				}
			}
			sendResponse(response, inputParameters, imageUrn, patientTiuNoteUrn, null);
		}
		catch(RoutingTokenFormatException rtfX)
		{
			logger.error(rtfX);
			sendResponse(response, inputParameters,null, null, rtfX);
		}
		catch(FileUploadException fuX)
		{
			logger.error(fuX);
			sendResponse(response, inputParameters, null, null, fuX);
		} 
		catch (PatientIdentifierParseException pipX)
		{
			logger.error(pipX);
			sendResponse(response, inputParameters, null, null, pipX);
		} 
		catch (MethodException mX)
		{
			logger.error(mX);
			sendResponse(response, inputParameters, null, null, mX);
		} 
		catch (ConnectionException cX)
		{
			logger.error(cX);
			sendResponse(response, inputParameters, null, null, cX);
		} catch (ImageFormatNotSupportedException ifnsX)
		{
			logger.error(ifnsX);
			sendResponse(response, inputParameters, null, null, ifnsX);
		}
	}
			
		
	private String parseSiteNumber(String patientId) {
		String site = "";
		String pat = patientId.split("-")[0];
		String[] aPat = pat.split("\\(");
		if (aPat.length > 1) {
			site = aPat[1];
		}
		return site;
	}

	private String parseConsultIEN(String consult) {
		String result = "";
		String[] cons = consult.split(" ");
		if (cons.length > 0) {
			result = cons[cons.length-1];
		}
		return result;
	}

	private String createTIUNote(PatientIdentifier patientIdentifier, String tiuNoteUrn, 
			String siteNumber, String consultId, String tiuNoteLocationUrn, String noteText, String tiuNoteAuthorUrn)
	throws MethodException, ConnectionException, ServletException
	{
		try {
			TIUItemURN noteUrn = URNFactory.create(tiuNoteUrn, TIUItemURN.class);

			TIUItemURN locationUrn = null;
			if (tiuNoteLocationUrn != null && tiuNoteLocationUrn.length() > 0)
				locationUrn = URNFactory.create(tiuNoteLocationUrn, TIUItemURN.class);

			TIUItemURN authorUrn = null;
			if (tiuNoteAuthorUrn != null && tiuNoteAuthorUrn.length() > 0) {
				if (tiuNoteAuthorUrn.contains(StringUtil.DASH)) {
					authorUrn = URNFactory.create(tiuNoteAuthorUrn, TIUItemURN.class);
				}
				else {
					authorUrn = TIUItemURN.create(siteNumber, tiuNoteAuthorUrn);
				}
			}

			ConsultURN consultUrn = null;
			if(consultId != null && consultId.length() > 0)
				consultUrn = ConsultURN.create(siteNumber, consultId, patientIdentifier.getValue());

			
			PatientTIUNoteURN patientTiuNoteUrn = null;
				
			
			patientTiuNoteUrn = getRouter().postTIUNote(noteUrn, patientIdentifier, locationUrn, new Date(), consultUrn, noteText, authorUrn);
			
			return patientTiuNoteUrn.toString();
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException(urnfX);
		}
	}
	
	private void associateImageWithTIUNote(AbstractImagingURN imagingUrn, String patientTiuNoteUrnString)
	throws MethodException, ConnectionException, ServletException	
	{
		try
		{
			PatientTIUNoteURN patientTiuNoteUrn = URNFactory.create(patientTiuNoteUrnString, PatientTIUNoteURN.class);
			getRouter().associateImageWithNote(imagingUrn, patientTiuNoteUrn);
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException(urnfX);
		}		
	}
	
	
	private String setEmptyValueToNull(String value)
	{
		if(value == null)
			return null;
		if(value.length() <= 0)
			return null;
		return value; // not null, use value		
	}

	protected synchronized IngestRouter getRouter()
	throws ServletException
	{
		IngestRouter router;
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(IngestRouter.class);
		} 
		catch (Exception x)
		{
			logger.error("Exception getting the facade router implementation.", x);
			return null;
		}
		
		return router;
	}

	/**
	 * Lookup the item (file) by field name.
	 * 
	 * imageDescription_{n}:{image description for n}
	 * imageDescription_{m}:{image description for m}
	 * 
	 * file_{n}: <file>
	 * file_{m}: <file>
	 * 
	 * Where m, n are numbers or cross referencing values (image id's).
	 * 
	 * @param itemStream the field name sent in the post form for an image/file
	 * @param imageDescriptions the map of {n},{m} to the image description text
	 * @param shortDescription the general description used for the entire ingest request
	 * @return the imageDescription if it exists or the shortDescription if not
	 */
	private String getImageDescription(ItemStream itemStream, Map<String,String> imageDescriptions, String shortDescription){
		String fieldName = itemStream.getFieldName();
		if(fieldName == null||!fieldName.contains("_")){
			return shortDescription;
		}
		String[] pieces = fieldName.split("_");
		if(pieces.length>1) {
			String imageId = pieces[1];
			String imageDescription = imageDescriptions.get(imageId);
			if(imageDescription != null){
				return imageDescription;
			}
		}
		return shortDescription;
	}

}
