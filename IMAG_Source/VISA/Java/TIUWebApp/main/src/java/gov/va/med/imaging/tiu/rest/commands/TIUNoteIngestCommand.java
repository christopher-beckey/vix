package gov.va.med.imaging.tiu.rest.commands;

import java.net.URL;
import java.util.Date;
import java.util.List;
import java.io.IOException;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.FileTypeIdentifierStream;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.exchange.business.RegionComparator;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.ingest.IngestRouter;
import gov.va.med.imaging.ingest.business.ImageIngestParameters;
import gov.va.med.imaging.ingest.business.TIUNoteSignatureOption;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.rest.types.TIUNoteInputType;
import gov.va.med.imaging.tiu.rest.types.TIUOpResultType;
import gov.va.med.imaging.tiu.rest.types.TIUPatientNoteType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.vistadatasource.session.VistaSession;

import javax.ws.rs.core.Response.Status;

/**
 * New command implementation for iMed Consent to ingest an image/file with or without a note
 * 
 * 
 * (Have nothing to do with the current Command pattern. Model as such so the resource
 *  in TIUService looks the same as other resources)
 * 
 * https://{CVIX host and port}/TIUWebApp/token/restservices/note/ingest?securityToken={token2}
 * 	 
 * ++++++++++++++++++++++++++++++++++++++++++++++++
 *
 *	Step 14: ingest (association to a note happens only if a note is created as well)
 *	a) Store image: use IngestRouter.storeImage()
 *
 *	Step 6: Create a note:
 *	PatientTIUNote createdNote = new PostTIUNoteCommand(noteInput, getInterfaceVersion()).execute();
 *	Associate image: use IngestRouter.associateImageWithNote() 
 *	(part of step 14 but do it here b/c need a note to associate)
 *
 *  Step 12: electronically file
 *	Boolean result = new GetTIUElectronicallyFileNoteCommand(patientTIUNoteUrn, getInterfaceVersion()).execute();
 *
 * @author VHAISPNGUYEQ
 *
 */
public class TIUNoteIngestCommand {
	
	private final static Logger LOGGER = Logger.getLogger(TIUNoteIngestCommand.class);
	
	private TransactionContext txContext = TransactionContextFactory.get();
	
	private static final String RPC_DELETE_IMAGE_ENTRY = "MAGG IMAGE DELETE";
	private final static String RPC_DELETE_NOTE = "TIU DELETE RECORD";
	
	private TIUNoteInputType noteInput;
	private boolean createNote;
	
	/**
	 * Default constructor
	 */
	public TIUNoteIngestCommand() {}
	
	/**
	 * Convenient constructor
	 * 
	 * @param TIUNoteInputType			container for inputs to create a ntoe with
	 * @param boolean					flag to create a note and ingest or just ingest
	 * 
	 */
	public TIUNoteIngestCommand(TIUNoteInputType noteInput, boolean createNote) {
		this.noteInput = noteInput;
		this.createNote = createNote;
	}
	
	/**
	 * Do all the works of ingesting a note and an image/file:
	 * 
	 * a) store the given image/file
	 * b) create the note with given data
	 * c) associate the created note and the stored file
	 * d) file electronically
	 * 
	 * Since the result can be either TIUPatientNoteType or TIUOpResultType,
	 * return an Object type and let the call react accordingly.
	 * 
	 * (pre-condition "noteText" MUST contain "fail" of some variation):
	 * 
	 * Use the below to force failure to test note deletion after ingested successfully:
	 	
	 	if (noteInput.getNoteText().equalsIgnoreCase("fail")) {
			LOGGER.info("TIUNoteIngestCommand.execute() --> [where failure is forced]: force failure to test cleaning up...");
			throw new MethodException("[where failure is forced]: force failure to test cleaning up.");
		}
	 
	 * @return Object		handle all possible returns
	 * 
	 */
	public Object execute() {
		
		LOGGER.info("TIUNoteIngestCommand.execute --> Start ingest process.....");
		
		txContext.setRequestType("TUIWebApp ingest");
		
		if (LOGGER.isDebugEnabled()) {
            LOGGER.debug("TIUNoteIngestCommand.execute() --> createNote [{}].\nGiven inputs: {}", createNote, noteInput);
		}
		
		String imageUrnRaw = null;
		String patientTIUNoteUrn = null;

		try {
			
			// Step 14: Ingest --> data and uploaded file are in the noteInput object
			
			// Insert "forced failure" codes here to simulate storage failure = no clean-up is needed

			ImageURN imageUrn = storeImageFile(noteInput, (createNote ? getDesiredInfo(noteInput.getTiuNoteTitleUrn(), 0) : noteInput.getSiteId()));
			
			imageUrnRaw = imageUrn.toString(SERIALIZATION_FORMAT.RAW);
			
			LOGGER.info("TIUNoteIngestCommand.execute() --> Stored image/file successfully !!!");
			
			// Short-circuit a bit --> return fast
			if (! createNote) {
				return new TIUOpResultType(Status.OK, "Ingested ImageURN [" + imageUrnRaw + "]");
			}
			
			if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("TIUNoteIngestCommand.execute() --> Stored ImageURN [{}]", imageUrnRaw);
			}

			// Step 6: Create note
			
			// Insert "forced failure" codes here to simulate note creation failure: clean-up image entry
							
			TIUPatientNoteType tiuPatientNoteType = createNote();				
			patientTIUNoteUrn = tiuPatientNoteType.getPatientTIUNoteUrn();
			
			LOGGER.info("TIUNoteIngestCommand.execute --> Created the note successfully !!!");

			if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("TIUNoteIngestCommand.execute() --> Created PatientTIUNoteUrn [{}]", getObscuredICN(patientTIUNoteUrn));
			}
				
			// No need to force association failure --> Same as "file" failure
				
			associateImageFile(imageUrn, patientTIUNoteUrn);
			
			LOGGER.info("TIUNoteIngestCommand.execute --> Associated image/file to the note successfully !!!");			
			
			// Insert "forced failure" codes here to delete image entry to enable delete note
			
			// filing MUST be last. Otherwise, a filed note can't be deleted
			// Step 12: file electronically
			
			fileElectronically(patientTIUNoteUrn);
			
			LOGGER.info("TIUNoteIngestCommand.execute --> Filed successfully !!!");

			tiuPatientNoteType.setImageUrn(imageUrnRaw);
			tiuPatientNoteType.setNumberAssociatedImages(1);
			tiuPatientNoteType.setSignatureStatus("Electronically File");
			
			LOGGER.info("TIUNoteIngestCommand.execute --> Done ingest process successfully !!! Returning TIUPatientNoteType result.");
			
			return tiuPatientNoteType;

		} catch (MethodException e) {

            LOGGER.debug("TIUNoteIngestCommand.execute() --> Exception message: [{}]. Trying to clean up...", e.getMessage());
			
			String cleanUpResult = cleanUp(imageUrnRaw, patientTIUNoteUrn);
			
			// Successful clean-up returns null
			return new TIUOpResultType(Status.INTERNAL_SERVER_ERROR, e.getMessage() + (cleanUpResult == null ? "" : cleanUpResult));
		}
	}
		
	/**
	 * Step 6: Create a note and get URN object
	 * 
	 * @return TIUPatientNoteType			result of creation
	 * @throws MethodException				standard exception
	 * 
	 */
	private TIUPatientNoteType createNote() throws MethodException {
		
		try {
			// Use this instead of tiuRouter.createTIUNote() to get a check on target VIX/S
			return new PostTIUNoteCommand(noteInput, "V1").execute();
		} catch (MethodException | ConnectionException e) {
			String errMsg = e.getMessage();
			errMsg =  "Couldn't create a note. Cause: " + errMsg.substring(errMsg.indexOf(":") + 2, errMsg.length());
			LOGGER.error(errMsg);
			throw new MethodException(errMsg);
		}		
	}
		
	/**
	 * Step 14: Helper method to ingest: store the uploaded file/image
	 * 
	 * @param TIUNoteInputType				object contains data to store file/image
	 * @param String						site id
	 * @throws MethodException
	 * 
	 */
	private ImageURN storeImageFile(TIUNoteInputType noteInput, String siteId) throws MethodException {
		
		String errMsg = null;
		
		try (FileTypeIdentifierStream fileIdStream = new FileTypeIdentifierStream(noteInput.getStreamType().getInputStream())) {
			
			IngestRouter ingestRouter = getRouter();

			if (ingestRouter == null) {
				errMsg = "Couldn't get an IngestRouter instance to store image. Can't proceed.";
                LOGGER.error("TIUNoteIngestCommand.storeImageFile() --> {}", errMsg);
				throw new IllegalArgumentException(errMsg);
			}
						
			LOGGER.debug("TIUNoteIngestCommand.storeImageFile() --> Got an IngestRouter instance.....");
			
			PatientIdentifier patientIdentifier = PatientIdentifier.fromString(noteInput.getPatientId());
		
			txContext.setPatientID(patientIdentifier.toString());
		
			RoutingToken routingToken = createLocalRoutingToken(siteId);
			
			if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("TIUNoteIngestCommand.storeImageFile() --> Got RoutingToken [{}]", routingToken);
			}
			
			// MUST use this date for 'procedureDate','capturedDate', 'documentDate'.  Nobody knows better.
			Date commonDate = new Date();
			
			ImageFormat imageFormat = fileIdStream.getImageFormat();
			
			if (imageFormat == null || ! isFormatAllowed(imageFormat)) {
				errMsg = "Can't proceed with the given file ImageFormat [" + imageFormat + "]";
                LOGGER.error("TIUNoteIngestCommand.storeImageFile() --> {}", errMsg);
				throw new IllegalArgumentException(errMsg);
			}
			
			if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("TIUNoteIngestCommand.storeImageFile() --> Got ImageFormat [{}] and format allowed [{}]", imageFormat, isFormatAllowed(imageFormat));
			}

			ImageIngestParameters imageIngestParams = new ImageIngestParameters(
				patientIdentifier,  												// patient Id object
				commonDate, 														// procedure date
				imageFormat, 														// image format
				"CLIN", 															// procedure
				noteInput.getShortDescription(),	 								// (short) description
				commonDate,															// capture date 
				null, 																// tracking number
				null, 																// acquisition device
				commonDate, 														// document date
				noteInput.getOriginIndex(),							 				// origin index
				noteInput.getTypeIndex(), 											// type index
				null,							 									// specialty index 
				null,									 							// procedure event index 
				null, 																// studyUrn
				null,							 									// capture user 
				noteInput.getStreamType().getOriginalFilename(),					// original file name 
				imageFormat.getMime(),												// mime type
				noteInput.getShortDescription(),									// OCC folks added
				TIUNoteSignatureOption.EF);											// signature flag object

			ImageURN imageUrn = ingestRouter.storeImage(routingToken, fileIdStream, imageIngestParams, false);
			
			if (imageUrn == null) {
				errMsg = "VistA returned a null ImageURN. Image/file was NOT stored.";
                LOGGER.error("TIUNoteIngestCommand.storeImageFile() --> {}", errMsg);
				throw new IllegalArgumentException(errMsg);
			}
			
			txContext.setUrn(imageUrn.toString(SERIALIZATION_FORMAT.RAW));
			
			return imageUrn;

		} catch (IOException | ConnectionException | MethodException | PatientIdentifierParseException | IllegalArgumentException e) {
			
			// PatientIdentifierParseException = can't convert given patient Id to PatientIdentifier object
			// IllegalArgumentException (sort of custom) = own message
			// ConnectionException = get raw message from store or associate image

			errMsg = e instanceof PatientIdentifierParseException ? "Couldn't convert to PatientIdentifier object." : e.getMessage();

            LOGGER.error("TIUNoteIngestCommand.storeImageFile() --> {}", errMsg);
			
			throw new MethodException(errMsg);
		}
	}
	
	/**
	 * Helper method to associate a stored image to a note using URNs
	 * 
	 * @param ImageURN					stored image URN
	 * @param String					patient TIU note URN in String
	 * @throws MethodException
	 */
	private void associateImageFile(ImageURN imageUrn, String patientTIUNoteUrn) throws MethodException {
		
		String errMsg = null;
		String urnWithObscuredIcn = getObscuredICN(patientTIUNoteUrn);
		
		try {

			IngestRouter ingestRouter = getRouter();

			if (ingestRouter == null) {
				errMsg = "Couldn't get an IngestRouter instance to associate image/file. Can't proceed.";
                LOGGER.error("TIUNoteIngestCommand.associateImageFile() --> {}", errMsg);
				throw new IllegalArgumentException(errMsg);
			}
					
			LOGGER.debug("TIUNoteIngestCommand.associateImageFile() --> Got an IngestRouter instance to associate image/file");
		
			Boolean associated = ingestRouter.associateImageWithNote(imageUrn, URNFactory.create(patientTIUNoteUrn, PatientTIUNoteURN.class));
		
			if (!associated) {
				errMsg = "Failed condition: Failed to associate file/image to note via IEN [" + getDesiredInfo(patientTIUNoteUrn, 1) + "]";
                LOGGER.error("TIUNoteIngestCommand.associateImageFile() --> {}", errMsg);
				throw new IllegalArgumentException(errMsg);				
			}

            LOGGER.info("TIUNoteIngestCommand.associateImageFile() --> Image associated: ImageURN [{}] to patientTIUNoteUrn [{}]", getObscuredICN(imageUrn.toString(SERIALIZATION_FORMAT.RAW)), urnWithObscuredIcn);
		
		} catch (ConnectionException | MethodException | URNFormatException | IllegalArgumentException e) {
			
			// URNFormatException = can't create patient note urn
			// IllegalArgumentException (sort of custom) = own message
			// ConnectionException = raw exception message

			errMsg = e instanceof URNFormatException ? "Couldn't create PatientTIUNoteURN object from given String [" + urnWithObscuredIcn + "]" 
													 : e.getMessage();
            LOGGER.error("TIUNoteIngestCommand.associateImageFile() --> {}", errMsg);
			
			throw new MethodException(errMsg);
		}	
	}
	
	/**
	 * Step 12: Helper method to file the newly created note electronically
	 * 
	 * @param String					patient TIU note URN to file
	 * @throws MethodException			standard exception
	 * 
	 */
	private void fileElectronically(String patientTIUNoteUrn) throws MethodException {
		
		String errMsg = null;
				
		try {
			
			RestBooleanReturnType fileOK = new GetTIUElectronicallyFileNoteCommand(patientTIUNoteUrn, "V1").execute();
			
			if (fileOK != null && !fileOK.isResult()) {
				errMsg = "Failed condition: Failed to file electronically via IEN [" + getDesiredInfo(patientTIUNoteUrn, 1) + "]";
                LOGGER.error("TIUNoteIngestCommand.fileElectronically() --> {}", errMsg);
				throw new MethodException(errMsg);
			}
		} catch (MethodException | ConnectionException e) {
			
			errMsg = e.getMessage();
			
			if (errMsg.contains("urn")) {
				errMsg = errMsg.substring(errMsg.indexOf("'"), errMsg.indexOf("'") + 85);
			}
			
			errMsg = "Failed to file electronically. Cause: " + errMsg;
			LOGGER.error(errMsg);
			throw new MethodException(errMsg);
		}		
	}
	
	/**
	 * Helper method to obscure ICN for logging
	 * 
	 * @param String		original patient TIU note URN
	 * @return String		result with ICN obscured
	 * 
	 */
	private String getObscuredICN(String urn) {
		
		if (StringUtil.isEmpty(urn)) {
			return null;
		}
		
		return (urn.replace(urn.substring(urn.lastIndexOf("-") + 1, urn.indexOf("V")), "***"));
	}
	
	/**
	 * Evaluate a given format against allowed formats
	 * 
	 * @param ImageFormat		given format to evaluate
	 * @return boolean			result
	 * 
	 */
	private boolean isFormatAllowed(ImageFormat imageFormat) {
		
		if (imageFormat == null) {
			return false;
		}
		
		for (ImageFormat value: ImageFormat.values()) {
			if (value == imageFormat) {
				return true;
			}
		}
		
		return false;
	}

	/**
	 * Helper method to get an IngestRouter instance
	 * 
	 * @return IngestRouter				result
	 * @throws MethodException
	 * 
	 */ 
	private IngestRouter getRouter() throws MethodException {
		
		try {
			return FacadeRouterUtility.getFacadeRouter(IngestRouter.class);
		} catch (Exception x) {
			String errMsg = "Error getting an IngestRouter instance. Can't proceed.";
            LOGGER.error("TIUNoteIngestCommand.getRouter() --> {}", errMsg);
			throw new MethodException(errMsg);
		}		
	}
	
	/**
	 * Helper method to create a required local routing token
	 * 
	 * @return RoutingToken				result
	 * @throws MethodException
	 * 
	 */
	private RoutingToken createLocalRoutingToken(String siteId) throws IllegalArgumentException {
		
		try {
			return RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
		} catch (Exception x) {
			String errMsg = "Error creating local routing token for site Id [" + siteId + "]. Can't proceed.";
            LOGGER.error("TIUNoteIngestCommand.createLocalRoutingToken() --> {}, {}", errMsg, x.getMessage());
			throw new IllegalArgumentException(errMsg);			
		}
	}

	/**
	 * Helper method to extract desired piece of info the given URN
	 * 
	 * Currently, given 'index':
	 * 
	 * 0 --> site Id
	 * 1 --> IEN
	 * 
	 * @param String 			given not title URN
	 * @param int				what piece to get
	 * @return String			result (either site Id or IEN) portion of the given URN
	 * 
	 */
	private String getDesiredInfo(String givenUrn, int index) {
		
		return StringUtil.isEmpty(givenUrn) ? null : givenUrn.split(":")[2].split("-")[index] ;	
	}
	
	/**
	 * Helper method to delete both image entry and a note
	 * 
	 * @param String						image URN
	 * @param String						patient TIU note URN
	 * @return String						null or message from either deletion
	 * 
	 */
	private String cleanUp(String imageUrn, String patientTIUNoteUrn) {
		
		String errMsg = null;
		String result = null;
		
		try {

			// Stored and associated successfully, need to delete the "association" first 
			// before we can delete an "associated" note if necessary
			if (imageUrn == null) {
				LOGGER.info("TIUNoteIngestCommand.cleanUp() --> Image/file storage didn't happen. No clean-up is necessary.");
				// Since image/file storage happened first and it failed, no need to delete note
				return result;
			} else if(! deleteImageEntry(imageUrn)) {
				// throw exception here -> can't delete a note anyway
				errMsg = "Failed to delete image entry via IEN [" + getDesiredInfo(imageUrn, 1) + "]";
                LOGGER.error("TIUNoteIngestCommand.cleanUp() --> {}", errMsg);
				throw new MethodException(errMsg);
			} else {
				LOGGER.info("TIUNoteIngestCommand.cleanUp() --> Deleted image entry successfully !!!");
			}

			if (patientTIUNoteUrn == null) {
				LOGGER.info("TIUNoteIngestCommand.cleanUp() --> Note creation didn't happen. No clean-up is necessary.");
			} else if (! deleteNote(patientTIUNoteUrn)) {
				errMsg = "Failed to delete the note via IEN [" + getDesiredInfo(patientTIUNoteUrn, 1) + "]";
                LOGGER.error("TIUNoteIngestCommand.cleanUp() --> {}", errMsg);
				throw new MethodException(errMsg);
			} else {
				LOGGER.info("TIUNoteIngestCommand.cleanUp() --> Deleted note successfully !!!");
			}

		} catch (MethodException me) {
			result = "Exception while cleaning up. Cause: " + me.getMessage().trim();
		}
		
		return result;
	}
	
	/**
	 * Helper method to delete a note from source
	 * 
	 * @param String				patient TIU note URN
	 * @return boolean				result
	 * @throws MethodException		standard exception
	 * 
	 */
	private boolean deleteNote(String patientTIUNoteUrn) throws MethodException {

		// Sample patient note URN --> urn:patientnote:994-4764219-1008689559V859134
		String siteId = getDesiredInfo(patientTIUNoteUrn, 0);
		String patientIen = getDesiredInfo(patientTIUNoteUrn, 1);
		VistaSession vistaSession = null;
		
		try {
			
			Site site = getSiteBySiteId(siteId);
			URL vistaUrl = getVistaUrl(siteId);
			
			if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("TIUNoteIngestCommand.deleteNote() --> Constructed Vista URL [{}] to connect to", vistaUrl);
			}
			
			vistaSession = VistaSession.getOrCreate(vistaUrl, site, ImagingSecurityContextType.CPRS_CONTEXT);
			VistaQuery vQuery = new VistaQuery(RPC_DELETE_NOTE);
			vQuery.addParameter(VistaQuery.LITERAL, patientIen);
			String deleteResult = vistaSession.call(vQuery);
			
			if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("TIUNoteIngestCommand.deleteNote() --> Delete note result [{}]", deleteResult);
			}
			
			// From VistA (should never be null): 
			// failure result (or something similar: [89250003^You may not DELETE the current document, given its type and status.]
			// success result: 0
			return deleteResult.equals("0"); 

		} catch (Exception e) {
			throw new MethodException(e.getMessage());
		} finally {
			if (vistaSession != null) { 
				vistaSession.close(); 
			}
		}
	}
	
	// Keep these two separate for clarity and clean separation
	
    /**
     * Helper method to delete an image entry (metadata/link info).
     * Required action if stored and associated image/file were successful
     * in order to delete a note.
     * 
     * Note: this is NOT to remove image/file at the storage location
     * 
     * Future work: delete the image at source: -->
     * gov.va.med.imaging.vista.storage.SmbStorageUtility.deleteFile(String filename, StorageCredentials storageCredentials)
     * 
     * @param String 						image URN to extract info from
     * @return boolean						result of operation
     * @throws MethodException
     * 
     */
    private boolean deleteImageEntry(String imageUrnRaw) throws MethodException {
    	
    	// Sample ImageURN --> urn:vaimage:994-73118166-73118166-***V859134
		String siteId = getDesiredInfo(imageUrnRaw, 0);
		String imageIen = getDesiredInfo(imageUrnRaw, 1);
		VistaSession vistaSession = null;
		
		try {
			Site site = getSiteBySiteId(siteId);
			URL vistaUrl = getVistaUrl(siteId);
			
			if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("TIUNoteIngestCommand.deleteImageEntry() --> Constructed Vista URL [{}] to connect to", vistaUrl);
			}
			
			vistaSession = VistaSession.getOrCreate(vistaUrl, site, ImagingSecurityContextType.MAG_WINDOWS);
			
			VistaQuery vQuery = new VistaQuery(RPC_DELETE_IMAGE_ENTRY);
			vQuery.addParameter(VistaQuery.LITERAL, imageIen + StringUtils.CARET + "1"); // 1=force delete
			vQuery.addParameter(VistaQuery.LITERAL, "0"); // GrpDelOK
			vQuery.addParameter(VistaQuery.LITERAL, "Failed to ingest"); // reason
			
			String deleteResult = vistaSession.call(vQuery);
			
			if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("TIUNoteIngestCommand.deleteImageEntry() --> Delete image entry result [{}]", deleteResult);
			}
			
			// From VistA (should never be null):
			// failure result starts with zero (0)
			// success result starts with 1 as in [1^Deletion of Image was Successful.\r\n73118168]
			return (deleteResult.startsWith("1"));

		} catch (Exception e) {
			throw new MethodException(e.getMessage());
		} finally {
			if (vistaSession != null) {
				vistaSession.close();
			}
		}
    }
    
    /**
     * Helper method to get a VistA URL to connect to for the given site Id
     * 
     * @param String						site Id
     * @return URL							object contains VistA connection info
     * @throws MethodException
     * 
     */
    private URL getVistaUrl(String siteId) throws MethodException {
    	
		try {
			Site site = getSiteBySiteId(siteId);
		
			if (site == null) {
				String errMsg = "Given site id [" + siteId + "] couldn't be mapped to a proper Site.";
                LOGGER.error("TIUNoteIngestCommand.getVistaUrl() --> {}", errMsg);
				throw new MethodException(errMsg);
			}
		
			// Sample URL: "vistaimaging://vhaispdbschy13.vha.med.va.gov:9448"
			return new URL("vistaimaging://" + site.getVistaServer() + ":" + site.getVistaPort());
			
		} catch (Exception e) {	
			throw new MethodException(e.getMessage());
		}
    }
    
    /**
     * Helper method to retrieve VistA server info for the given site Id
     * (The main logic was given by Soren)
     * 
     * @return Site					object that holds Site info
     * @throws Exception			catch all exception
     * 
     */
    private Site getSiteBySiteId(String siteId) throws Exception {
    	
    	List<Region> regions = SiteServiceContext.getSiteServiceFacadeRouter().getRegionList();
    	regions.sort(new RegionComparator());
    	   
    	for (Region region : regions) {
    	   for (Site site : region.getSites()) {
    		   if (site.getSiteNumber().equals(siteId)) {
    			   return site;
    		   }
    	   }
    	}
    	   
    	return null;
    }

}
