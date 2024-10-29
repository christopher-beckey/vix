package gov.va.med.imaging.dicomservices.datasource.services;

import java.io.File;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import gov.va.med.imaging.url.vista.StringUtils;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.common.DicomFileMetaInfo;
import gov.va.med.imaging.dicom.common.exceptions.Part10FileException;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.interfaces.IDicomPart10File;
import gov.va.med.imaging.dicom.common.spring.SpringDicomStoreSCUContext;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationAbortException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationInitializationException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationRejectException;
import gov.va.med.imaging.dicom.scu.exceptions.SendInstanceException;
import gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreSCUControl;
import gov.va.med.imaging.dicomservices.common.stats.VixDicomServiceStatistics;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;

public class CStoreSCUPost {

	private static final Logger LOGGER = Logger.getLogger(CStoreSCUPost.class);
	
	private DicomAE dicomAE;
	private List<String> dicomFileList;
	private static ApplicationContext springFactoryContext;
	private Map<String,IDicomPart10File> dicomObjects = null;
	private static final String UNKNOWN_SOP_CLASS = "UNKNOWN";
	private static final String SCU_SPRING_CONTEXT = "dicomSCUContext.xml";

	public CStoreSCUPost(DicomAE ae, List<String> dicomFiles) {
		this.dicomAE = ae;
		this.dicomFileList = dicomFiles;
		this.dicomObjects = new HashMap<String,IDicomPart10File>();
		// initialize Spring configuration
		initializeSpring();
	}

	public void postToAE() throws ConnectionException, MethodException{
		
		boolean isAbort = false;

		//iterate thru list to collect SOP Classes
		HashSet<String> sopClassUIDs = new HashSet<String>();
		Iterator<String> iter = this.dicomFileList.iterator();
		
		while(iter.hasNext()){
			String filename = (String)iter.next();
			IDicomPart10File dicomFile = (IDicomPart10File)SpringDicomStoreSCUContext.getContext().getBean("DicomPart10File");
			dicomFile.part10File(filename);
			DicomFileMetaInfo fmi = null;
			try {
				fmi = dicomFile.getFileMetaData();
				sopClassUIDs.add(fmi.getSopClassUID());
				this.dicomObjects.put(filename, dicomFile);
			} catch (Exception e) {
				VixDicomServiceStatistics.getInstance().incrementVixSendToAEFailureCount(dicomAE.getRemoteAETitle(), UNKNOWN_SOP_CLASS);
                LOGGER.error("CStoreSCUPost.postToAE() --> This file will be skipped. Failed to open DICOM object file [{}]: {}", filename, e.getMessage());
			}
		}
		
		if(!this.dicomObjects.isEmpty()){
			//open DICOM Association with dicomAE
			IStoreSCUControl scu = (IStoreSCUControl)SpringDicomStoreSCUContext.getContext().getBean("StoreSCUControl");
			
			try {
				scu.openStoreAssociation(dicomAE, dicomAE.getLocalAETitle(), sopClassUIDs);
			} catch (AssociationRejectException arX) {
				
				VixDicomServiceStatistics.getInstance().addToVixSendToAEFailureCount(dicomAE.getRemoteAETitle(), UNKNOWN_SOP_CLASS, this.dicomObjects.size());
				deleteFiles();
				String message = "CStoreSCUPost.postToAE() --> Association Rejection to DICOM AE [" + dicomAE.getRemoteAETitle() + "]: " + arX.getMessage();
				LOGGER.error(message);
				throw new ConnectionException(message, arX);
			} catch (AssociationInitializationException aiX) {
				VixDicomServiceStatistics.getInstance().addToVixSendToAEFailureCount(dicomAE.getRemoteAETitle(), UNKNOWN_SOP_CLASS, this.dicomObjects.size());
				deleteFiles();
				String message = "CStoreSCUPost.postToAE() --> Association Initialization issue for DICOM AE [" + dicomAE.getRemoteAETitle() + "]: " + aiX.getMessage();
				LOGGER.error(message);
				throw new ConnectionException(message, aiX);
			}
			
			//iterate thru list again and send object(s)
			Iterator<String> iterator = this.dicomFileList.iterator();
			while(iterator.hasNext()){
				String filename = (String)iterator.next();
				IDicomPart10File dicomFile = (IDicomPart10File)this.dicomObjects.get(filename);
				IDicomDataSet dds = null;
				try {
					dds = dicomFile.getDicomDataSet();
					try {
						scu.sendObject(dds);
						//imagesSent++;
					} 
					catch (SendInstanceException siX) {
						VixDicomServiceStatistics.getInstance().incrementVixSendToAEFailureCount(dicomAE.getRemoteAETitle(), dds.getSOPClass());
						String message = "CStoreSCUPost.postToAE() --> Failed to send DICOM Instance with UID [" + dds.getSOPInstanceUID() + "]: " + siX.getMessage();
						LOGGER.error(message);
					} 
					catch (AssociationAbortException aaX) {
						String message = "CStoreSCUPost.postToAE() --> Association aborted to DICOM AE [" + dicomAE.getRemoteAETitle() + "]: " + aaX.getMessage();
						LOGGER.warn(message);
						isAbort = true;
						break;
					}
				} 
				catch (Part10FileException p10fX) {
                    LOGGER.error("CStoreSCUPost.postToAE() --> This file will be skipped. Failed to open DICOM object file [{}]: {}", filename, p10fX.getMessage());
					VixDicomServiceStatistics.getInstance().incrementVixSendToAEFailureCount(dicomAE.getRemoteAETitle(), UNKNOWN_SOP_CLASS);
				}
			}
			
			//close DICOM Association with dicomAE
			if(!isAbort){
				try {
					scu.closeStoreAssociation();
				} catch (AssociationAbortException aaX) {
                    LOGGER.error("CStoreSCUPost.postToAE() --> Association Aborted for DICOM AE [{}]: {}", dicomAE.getRemoteAETitle(), aaX.getMessage());
				}
			}
		}
		
		deleteFiles();
		
		if(isAbort){
			throw new ConnectionException("CStoreSCUPost.postToAE() --> Association aborted to DICOM AE [" + dicomAE.getRemoteAETitle() + "]");
		}
	}
	
	private void initializeSpring(){
		// Load default SCU spring configuration from the VixConfig directory
		LOGGER.info("CStoreSCUPost.initializeSpring() --> Loading SpringFactoryContext for DICOM Storage SCU activity using file [" + SCU_SPRING_CONTEXT + "]");
		springFactoryContext = new ClassPathXmlApplicationContext(SCU_SPRING_CONTEXT);
		SpringDicomStoreSCUContext.setContext(springFactoryContext);
	}
	
	private void deleteFiles(){
		//iterate thru list again and delete object(s)
		Iterator<String> iterator = this.dicomFileList.iterator();
		while(iterator.hasNext()){
			String filename = (String)iterator.next();
			File temp = new File(StringUtils.cleanString(filename));
			temp.delete();
			temp = null;
		}
	}	
}
