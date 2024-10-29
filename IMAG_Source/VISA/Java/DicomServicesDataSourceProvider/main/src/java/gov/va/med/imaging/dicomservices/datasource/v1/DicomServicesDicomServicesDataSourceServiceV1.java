/**
 * 
 */
package gov.va.med.imaging.dicomservices.datasource.v1;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.interfaces.IDicomElement;
import gov.va.med.imaging.dicom.dcftoolkit.utilities.exceptions.DicomFileException;
import gov.va.med.imaging.dicom.dcftoolkit.utilities.reconstitution.DicomFileExtractor;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;
import gov.va.med.imaging.dicom.utilities.exceptions.GenericDicomReconstitutionException;
import gov.va.med.imaging.dicomservices.datasource.AbstractDicomServicesDicomServicesDataSourceService;
import gov.va.med.imaging.dicomservices.datasource.configuration.DicomServicesConfiguration;
import gov.va.med.imaging.dicomservices.datasource.services.CStoreSCUPost;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.exceptions.DicomException;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.url.dicomservices.DicomServicesConnection;
import gov.va.med.imaging.core.router.storage.StorageDataSourceRouter;
import gov.va.med.imaging.core.router.storage.StorageContext;
import gov.va.med.imaging.exchange.business.storage.NetworkLocationInfo;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;

/**
 * @author William Peterson
 *
 */
public class DicomServicesDicomServicesDataSourceServiceV1 
extends AbstractDicomServicesDicomServicesDataSourceService {

	private final static String SUCCESS = "0";
	private final static String FAILED = "-1";
	private final static String DATASOURCE_VERSION = "1";
	private final static String SOP_CLASS_UID_TAG = "0008,0016";
	private final static String SOP_CLASS_UID = "1.2.840.10008.5.1.4.1.1.104.1";
	private final static String TEXT_VALUE_TAG = "0040,A160";
	
	private Logger logger = Logger.getLogger(DicomServicesDicomServicesDataSourceServiceV1.class);

	private final DicomServicesConnection dicomServicesConnection;
	private static final StorageDataSourceRouter storageRouter = StorageContext.getDataSourceRouter();	

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public DicomServicesDicomServicesDataSourceServiceV1(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
		
		dicomServicesConnection = new DicomServicesConnection(getMetadataUrl());

	}
	
	@Override
	protected String getDataSourceVersion() {
		return DATASOURCE_VERSION;
	}

	@Override
	public boolean isVersionCompatible() {
		return true;
	}


	@Override
	public void postToAE(RoutingToken routingToken, DicomAE dicomAE, List<String> dicomFileList) throws MethodException, ConnectionException {

		DicomServicesConfiguration config = getDicomServicesConfiguration();

		if(!config.isDicomServicesDisabled()){
			CStoreSCUPost storeSCU = new CStoreSCUPost(dicomAE, dicomFileList);
		
			storeSCU.postToAE();
		}
		else{
			logger.info("DICOM Services are disabled.");
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.dicomservices.datasource.AbstractDicomServicesDicomServicesDataSourceService#getAEList()
	 */
	@Override
	public List<DicomAE> getAEList(RoutingToken routingToken) throws MethodException, ConnectionException {
		DicomServicesConfiguration config = getDicomServicesConfiguration();
		List<DicomAE> dicomAEs = new ArrayList<DicomAE>();

		if(!config.isDicomServicesDisabled()){
            logger.debug("localSiteRemoteAET: {}", config.getLocalSiteRemoteAETitle());
            logger.debug("Site: {}", getSite().getSiteNumber());
            logger.debug("localSiteLocalAET: {}", config.getLocalSiteLocalAETitle());
            logger.debug("localSiteHost: {}", config.getLocalSiteHost());
            logger.debug("port: {}", config.getLocalSitePort().toString());
			
			
			DicomAE localAE = new DicomAE(config.getLocalSiteRemoteAETitle(),getSite().getSiteNumber());
			localAE.setLocalAETitle(config.getLocalSiteLocalAETitle());
			localAE.setHostName(config.getLocalSiteHost());
			localAE.setPort(config.getLocalSitePort().toString());
			localAE.setStudyTimeoutSeconds(config.getLocalSitePDUTimeout());
			
			dicomAEs.add(localAE);
			
			
			List<String> remoteAEs = config.getDicomRemoteAEs();
            logger.debug("Number of Remote AEs: {}", remoteAEs.size());
			if(remoteAEs.size() > 0){
				for(String remoteAE : remoteAEs){
					DicomAE ae = new DicomAE(remoteAE, getSite().getSiteNumber());
                    logger.debug("Adding DICOM AE {} to list.", ae.getRemoteAETitle());
					dicomAEs.add(ae);
				}
			}
		}
		else{
			logger.info("DICOM Services are disabled.");
		}
		return dicomAEs;
	}
		
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.dicomservices.datasource.AbstractDicomServicesDicomServicesDataSourceService#getDicomReportText()
	 */
	@Override
	public synchronized String getDicomReportText(RoutingToken routingToken, WorkItem workItem)
			throws MethodException, ConnectionException {
		DicomServicesConfiguration config = getDicomServicesConfiguration();
		if(!config.isDicomServicesDisabled()){
            return FAILED + "^DICOM Services are disabled";
		}
		
		ImporterWorkItem importerWorkItem = ImporterWorkItem.buildShallowImporterWorkItem(workItem);
		String networkLocationIen = Integer.toString(importerWorkItem.getWorkItemDetailsReference().getNetworkLocationIen());
		logger.debug("networkLocationIen: " + networkLocationIen);

		NetworkLocationInfo networkLocationInfo = storageRouter.getNetworkLocationDetails(networkLocationIen);
		logger.debug("networkLocationInfo: " + networkLocationInfo);
		
		String mediaBundleRoot = importerWorkItem.getWorkItemDetailsReference().getMediaBundleStagingRootDirectory();
        String serverPath = networkLocationInfo.getPhysicalPath();
        String dicomPath = serverPath +  mediaBundleRoot;
        logger.debug("dicomPath: " + dicomPath);

        String rptText = "";
        String impression = "";
        
        try{
    		SmbStorageUtility util = new SmbStorageUtility();
    		
    		List<String> dcmFiles = util.getDicomFilenames(dicomPath, (StorageCredentials)networkLocationInfo);
    		for(String dcmFile : dcmFiles)
    		{
    			//if (util.fileExists(dicomFile, (StorageCredentials)networkLocationInfo)) {
        		String localDicomFile = copyToLocal(util, dicomPath, dcmFile, config.getLocalTempPath(), (StorageCredentials)networkLocationInfo);
                if (localDicomFile.isEmpty()) {
                	return FAILED + "^Unable to copy DicomFile to Local Path";
                }

                logger.debug("localDicomFile to read: " + localDicomFile);
        		DicomFileExtractor fileExtractor = new DicomFileExtractor();
        		IDicomDataSet dds = fileExtractor.getDDSFromDicomFile(localDicomFile);
        		if (dds.containsDicomElement("0040,A730", "0040,A160")) {
    	            String txt = dds.getDicomElementValue("0040,A730", "0040,A160");
    	            logger.debug("TextValue: " + txt);
    	            if ((txt != null) && !txt.isEmpty()) {
    	            	String[] rpt = txt.split("\\[IMPRESSION SECTION\\]");
    	            	if (rptText.isEmpty()) {
    	            		rptText = rpt[0];
    	            		impression = rpt.length == 1 ? rpt[0] : rpt[1];
    	            	} else {
    	            		rptText = String.join(System.lineSeparator(), rptText, rpt[0]); 
    	            		impression = String.join(System.lineSeparator(), impression, (rpt.length == 1 ? rpt[0] : rpt[1])); 
    	            	}
    	            }
        		}
	        	deleteLocalFile(localDicomFile);
    		}

    		if (rptText.isEmpty() && impression.isEmpty()) {
	            return FAILED + "^DICOM TEXT VALUE TAG not found";
    		}
    		
			return SUCCESS + "^" + rptText + "[IMPRESSION SECTION]" + impression;

//	            IDicomElement dicomElement = dds.getDicomElement(SOP_CLASS_UID_TAG);
//	            if (dicomElement != null) {
//		            if (dicomElement.getStringValue().equals(SOP_CLASS_UID)) { //Modality = SR
//		            	String textValueTag = config.getTextValueTag();
//		            	if ((textValueTag == null) || (textValueTag.isEmpty())) {
//		            		textValueTag = TEXT_VALUE_TAG;
//		            	}
//		                logger.debug("textValueTag: " + textValueTag);
//		            	IDicomElement txtElement = dds.getDicomElement(textValueTag); //SR Document Content - Text Value
//			            if (txtElement != null) {
//			            	deleteLocalFile(localDicomFile);
//			    			return SUCCESS + "^" + txtElement.getStringValue();
//			            } else {
//				            return FAILED + "^DICOM TEXT VALUE TAG not found";
//			            }
//		            } else {
//			            return FAILED + "^File is not DICOM SR";
//		            }
//	            } else {
//		            return FAILED + "^DICOM MODALITY TAG not found";
//	            }
//    		} else {
//                return FAILED + "^DICOM File not found!";
//    		}
        } catch(IOException io){
        	logger.error(io.getMessage());
            return FAILED + "^" + io.getMessage();
        } catch(DicomFileException file){
        	logger.error(file.getMessage());
            return FAILED + "^" + file.getMessage();
        } catch(DicomException de){
        	logger.error(de.getMessage());
            return FAILED + "^" + de.getMessage();
        }

	}

	private synchronized void deleteLocalFile(String localDicomFile)
		throws IOException {
		File path = new File(localDicomFile);
	    path.delete();
	}

	private synchronized String copyToLocal(SmbStorageUtility util, String dicomPath, String dicomFile, 
			String localTempPath, StorageCredentials networkLocationInfo) {
		if (localTempPath == null) {
			localTempPath = "C:\\DICOM\\TEMP\\";
		}
		try {
			File directory = new File(localTempPath);
		    if (! directory.exists()){
		        directory.mkdirs();
		    }
			String[] dcm = dicomFile.split("\\^");
		    String remoteDicomFile = dicomPath.concat(dcm[1]);
		    String localDicomFile = localTempPath.concat(dcm[1]);
			util.copyRemoteFileToLocalFile(remoteDicomFile, localDicomFile, networkLocationInfo);
			return localDicomFile;
		} catch(IOException io) {
			logger.error(io.getMessage());
			return "";
		}
	}

	public void setConfiguration(Object configuration) {
		// TODO Auto-generated method stub
		
	}

}
