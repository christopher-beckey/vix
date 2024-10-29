package gov.va.med.imaging.dicom.dcftoolkit.common.impl;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;

import gov.va.med.logging.Logger;

import com.lbs.DCS.DCSException;
import com.lbs.DCS.DicomDataSet;
import com.lbs.DCS.DicomFileInput;
import com.lbs.DCS.DicomSessionSettings;
import com.lbs.DCS.DicomStreamReader;
import com.lbs.DCS.FileMetaInformation;

import gov.va.med.imaging.dicom.common.DicomFileMetaInfo;
import gov.va.med.imaging.dicom.common.exceptions.Part10FileException;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.interfaces.IDicomPart10File;
import gov.va.med.imaging.dicom.dcftoolkit.common.DataSetByteReader;
import gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.Part10Files;
import gov.va.med.imaging.exchange.business.dicom.exceptions.DicomException;
import gov.va.med.imaging.url.vista.StringUtils;

public class DicomPart10FileImpl implements IDicomPart10File {

	private String filename = null;
	private IDicomDataSet dds = null;
	private DicomFileMetaInfo fmi = null;
	private InputStream ddsInputStream = null;
	
    private static Logger logger = Logger.getLogger(DicomPart10FileImpl.class);

	
	
	public DicomPart10FileImpl() {
		super();
	}
	
	@Override
	public DicomFileMetaInfo getFileMetaData() throws Part10FileException {
		if(this.dds == null){
			try{
				extractDataSet();
			}
			catch(DicomException dX){
				throw new Part10FileException(dX.getMessage());
			}
		}
		return this.fmi;
	}

	@Override
	public IDicomDataSet getDicomDataSet() throws Part10FileException {
		if(this.dds == null){
			try{
				extractDataSet();
			}
			catch(DicomException dX){
				throw new Part10FileException(dX.getMessage());
			}
		}
		return this.dds;
	}

	@Override
	public InputStream getInputStream() throws Part10FileException {
		if(this.dds == null){
			try{
				extractDataSet();
			}
			catch(DicomException dX){
				throw new Part10FileException(dX.getMessage());
			}
		}
		try{
			extractInputStream();
		}
		catch(DicomException dX){
			throw new Part10FileException(dX.getMessage());
		}
		return this.ddsInputStream;
	}

	private void extractDataSet() throws DicomException{
		
    	String fromTSUID = null;
    	DicomDataSet dataSet = null;
    	FileMetaInformation metadata = null;
		this.fmi = new DicomFileMetaInfo();
    	DicomSessionSettings dSS = null;
		FileInputStream fis = null;
		DicomStreamReader dsr = null;
		DicomFileInput fileIn = null;

		
    	try {
  			// first open file, and read dataset
			dSS = new DicomSessionSettings();
			try 
			{
				fis = new FileInputStream(StringUtils.cleanString(this.filename));
				//fis = new FileInputStream(this.filename);
			} 
			catch(FileNotFoundException fnfX)
			{
                logger.error("File [{}] not found.", this.filename);
				logger.error(fnfX.getMessage(), fnfX);
	    		throw new DicomException(fnfX);
				
			}
			catch (Exception X) 
			{
                logger.error("Exception thrown opening File [{}] .", this.filename);
				logger.error(X.getMessage(), X);		
	    		throw new DicomException(X);
			}
			finally
			{
	        	// Fortify change: added finally block; second round
	        	try { if(fis != null) { fis.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
			}
			
			dsr = new DicomStreamReader(fis, dSS);
			fileIn = new DicomFileInput(dsr, null, dSS);			
			fileIn.open();
    		dataSet = fileIn.readDataSet();
 			metadata = fileIn.fileMetaInformation();
 			
 			this.dds = new DicomDataSetImpl(dataSet); 			

    		if(metadata != null){
    			try{
    				this.dds.setSourceAET(metadata.sourceAeTitle());
    				this.fmi.setSourceAET(metadata.sourceAeTitle());
    			}
    			catch(DCSException dcsX){
    				logger.warn("Source AET not available from DICOM object.");
    			}
    			try{
    				fromTSUID = metadata.transferSyntaxUid();
    				this.dds.setReceivedTransferSyntax(fromTSUID);
    				this.fmi.setTransfersyntaxUID(metadata.transferSyntaxUid());
    			}
    			catch(DCSException dcsX){
    				logger.warn("Transfer Syntax UID not available from DICOM object.");
    				
    			}
    			try{
    				this.fmi.setImplementationClassUID(metadata.implementationClassUid());
    			}
    			catch(DCSException dcsX){
    				logger.warn("Implementation Class UID not available from DICOM object.");
    				
    			}
    			try{
    				this.fmi.setImplementationVersionName(metadata.implementationVersionName());
    			}
    			catch(DCSException dcsX){
    				logger.warn("Implementation Version Name not available from DICOM object.");
    				
    			}
    			try{
    				this.fmi.setSopClassUID(metadata.mediaStorageSopclassUid());
                    logger.debug("Confirming SOP Class is {}", metadata.mediaStorageSopclassUid());
    			}
    			catch(DCSException dcsX){
    				logger.warn("Media Storage SOP Class UID not available from DICOM object.");    				
    			}
 			}   			
		} 
    	catch (DCSException dcsX) 
		{
    		String message = "";
   			message = "Failed to open or read DICOM object file, " + filename;
    		
    		logger.error(message);
            throw new DicomException(message, dcsX);
		} 
    	finally
    	{
    		try
    		{
    			// Fortify change: check for null first
    			
    			if(fileIn != null)
    				fileIn.close();
    		}
    		catch(DCSException dcsX){
    			logger.error("Failed to close properly.");
    		}
    	}
    	
    	//fileIn = null;
	}

	
	private void extractInputStream() throws DicomException{
		
		DataSetByteReader dbr = null;
		ReadableByteChannel ddsMessageChannel = null;
		
    	// Fortify change: instantiate separately to close later; second round 
		InputStream dbrInStream = null;

		try {
			dbr = Part10Files.getDicomFileReadableByteChannel(this.dds, this.fmi);
			dbrInStream = dbr.getInputStream();
			ddsMessageChannel = Channels.newChannel(dbrInStream);
			this.ddsInputStream = Part10Files.getDicomFileInputStream(ddsMessageChannel);
		} 
    	catch (DCSException dcsX) 
		{
    		String message = "";
   			message = "Failed to open or read DICOM object file, " + this.filename;
    		
    		logger.error(message);
            throw new DicomException(message, dcsX);
		} 
		catch (Exception X) {
    		String message = "";
   			message = "Failed to open or read DICOM object file, " + this.filename;
    		
    		logger.error(message);
            throw new DicomException(message, X);
		}		
    	finally
    	{
        	// Fortify change: added and shorten; second round
			try 
			{
				if(dbrInStream != null)
					dbrInStream.close();
				
    		// Fortify change: check for null first
				if(this.ddsInputStream != null)
					this.ddsInputStream.close();
				
				if(ddsMessageChannel != null)
					ddsMessageChannel.close();
				
				if(dbr != null)
					dbr.closeInputStream();
				
			} catch (Exception X) {
				throw new DicomException(X.getMessage());
			}
    	}
		
		/* QN: Really don't need these
		this.ddsInputStream = null;
		ddsMessageChannel = null;
		dbr = null;
		*/	
	}

	@Override
	public void part10File(String filename) {
		this.filename = filename;
		
	}

}