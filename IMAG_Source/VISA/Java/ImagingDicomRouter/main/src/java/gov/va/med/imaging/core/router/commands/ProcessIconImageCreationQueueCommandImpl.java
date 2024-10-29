/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: 
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswpeterb
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

*/

package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.core.router.facade.InternalContext;
import gov.va.med.imaging.core.router.storage.StorageBusinessRouter;
import gov.va.med.imaging.core.router.storage.StorageContext;
import gov.va.med.imaging.core.router.storage.StorageDataSourceRouter;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.exchange.business.DurableQueue;
import gov.va.med.imaging.exchange.business.DurableQueueMessage;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.InstanceFile;
import gov.va.med.imaging.exchange.business.dicom.SOPInstance;
import gov.va.med.imaging.exchange.business.dicom.UIDActionConfig;
import gov.va.med.imaging.exchange.business.storage.Artifact;
import gov.va.med.imaging.exchange.business.storage.ArtifactDescriptor;
import gov.va.med.imaging.exchange.business.storage.KeyList;
import gov.va.med.imaging.exchange.business.storage.Place;
import gov.va.med.imaging.exchange.business.storage.StorageServerConfiguration;
import gov.va.med.imaging.exchange.business.storage.StorageServerDatabaseConfiguration;
import gov.va.med.imaging.notifications.NotificationFacade;
import gov.va.med.imaging.notifications.NotificationTypes;
import gov.va.med.imaging.storage.IconImageCreation;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import gov.va.med.logging.Logger;

@RouterCommandExecution(asynchronous = true, distributable = false)
public class ProcessIconImageCreationQueueCommandImpl extends
		AbstractCommandImpl<Boolean> {

	private static final long serialVersionUID = -5951980171292687832L;
	private static final String ASYNC_ICON_QUEUE = "ASYNC_ICON_QUEUE";
	private Logger logger = Logger.getLogger(ProcessIconImageCreationQueueCommandImpl.class);
	private static final DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
	private static final StorageServerConfiguration storageConfig = StorageServerConfiguration.getConfiguration();
    private DurableQueue iconQueue;


	public ProcessIconImageCreationQueueCommandImpl() {

	}

	@Override
	public Boolean callSynchronouslyInTransactionContext()
			throws MethodException, ConnectionException {
		// Block Icon Image creation (processing) if not enabled on this box
		if (config.isIconProcessingEnabled()) {
			logger.info("Checking " + ASYNC_ICON_QUEUE + " for icon image creation requests");
			createIconImage();
		}
		return true;
	}

	@Override
	public boolean equals(Object obj) {
		return false;
	}

	@Override
	protected String parameterToString() {
		return "";
	}

	@Override
	public Command<Boolean> getNewPeriodicInstance() throws MethodException {
		ProcessIconImageCreationQueueCommandImpl command = new ProcessIconImageCreationQueueCommandImpl();
		command.setPeriodic(true);
		command.setPeriodicExecutionDelay(this.getPeriodicExecutionDelay());
		command.setCommandContext(this.getCommandContext());
		return command;
	}
	
    private void createIconImage() throws MethodException, ConnectionException
    {
        StorageBusinessRouter storageBusinessRouter = StorageContext.getBusinessRouter();
        StorageDataSourceRouter storageDataSourceRouter = StorageContext.getDataSourceRouter();
        StorageServerDatabaseConfiguration storageDbConfig = StorageServerDatabaseConfiguration.getConfiguration();
         //
         // Get the next Icon Image creation message
         //
         RoutingToken routingToken = getCommandContext().getLocalSite().getArtifactSource().createRoutingToken();
         Place place = StorageServerDatabaseConfiguration.getConfiguration().getPlace(getLocalSiteId());
         DurableQueueMessage message = InternalContext.getRouter().dequeueDurableQueueMessage(routingToken, getIconQueue().getId(), Integer.toString(place.getId()));

         while (message != null)
         {
            // Parse the message and get the artifact stream for the DICOM object
        	if(logger.isDebugEnabled()){
                logger.debug("{}: Getting and parsing Icon Image Queue message.", this.getClass().getName());}
            String[] fields = StringUtil.split(message.getMessage(),StringUtil.CARET); 
            String artifactToken = fields[0]; 
            String sopInstanceIEN = fields[1];
            String sopClassUID = fields[2];
            int retryCount = new Integer(fields[3]).intValue();
            if(logger.isDebugEnabled()){
                logger.debug("{}: Getting Artifact stream from Storage for SOP Instance IEN {} [{}].", this.getClass().getName(), sopInstanceIEN, sopClassUID); }
            Artifact artifact = storageDataSourceRouter.getArtifactByToken(artifactToken);
            InputStream artifactStream = storageBusinessRouter.getArtifactStream(artifactToken);
            
            //Write the InputStream to local disk.
     		String iconFolder = storageConfig.getIconImageFolder();
    		String dicomFile = iconFolder+"\\Abstract_"+sopInstanceIEN+".dcm";
    		String iconFile = iconFolder+"\\Abstract_"+sopInstanceIEN+".jpg";
    		String currentFile = dicomFile;
    		FileInputStream iconStream = null;
 
    		// Fortify change: bring out of 'try' block to close later
    		FileOutputStream outputStream = null;
    		
    		boolean realIcon = true;
     		try{
    			// check if icon can be created or must be canned
    			UIDActionConfig uAC = config.getSopUIDActionConfiguration(sopClassUID);
    			
    			if ((uAC!=null) && (uAC.getIconFilename().contains("."))) {
    				// get canned icon file
    				if(logger.isDebugEnabled()){
                        logger.debug("{}: Use canned icon image.", this.getClass().getName());}
    				iconFile = config.getCannedIconFolder() + uAC.getIconFilename();
    				realIcon = false;
    			} 
    			else {
    				// Icon Image Creation.
    				if(logger.isDebugEnabled()){
                        logger.debug("{}: Create icon image for DICOM object.", this.getClass().getName());}
        			outputStream = new FileOutputStream(new File(StringUtil.cleanString(dicomFile)));
        			writeFileToDisk(artifactStream, outputStream);
        			//Close the streams
        			outputStream.close();
        			artifactStream.close();

	    			// Call Icon Image Creation object (which calls a dll)to make the icon.
        			if(logger.isDebugEnabled()){
                        logger.debug("{}: Call DLL to create icon image.", this.getClass().getName());}
        			int dllReturn = IconImageCreation.createIconImage(dicomFile, iconFile);
	    			if(dllReturn != 0){
                        logger.error("{}: Failed to create icon image.", this.getClass().getName());
	    				throw new IOException(); 
	    			}
    			}
    			//Open an InputStream to the new file
    			currentFile = iconFile;
    			iconStream = new FileInputStream(new File(StringUtil.cleanString(iconFile)));
            
    			KeyList keyList = new KeyList(artifact.getKeyListId(), artifact.getKeyList()); 
    			String placeId = getLocalSiteId();
    			String createdBy = "Asynchronous Icon Service"; 
    			ArtifactDescriptor artifactDescriptor = storageDbConfig.getArtifactDescriptorByTypeAndFormat("MedicalImageAbstract", "JPEG");
	            String iconToken = storageBusinessRouter.postArtifactByStream(iconStream, null, artifactDescriptor, placeId, keyList, createdBy);
	            
	            // Create a dummy sopInstance
	            SOPInstance sopInstance = new SOPInstance();
	            sopInstance.setIEN(sopInstanceIEN);
	             
	            // Create the instance file for the artifact
	            if(logger.isDebugEnabled()){
                    logger.debug("{}: Create Instance file for icon image artifact.", this.getClass().getName());}
	            InstanceFile iconInstanceFile = new InstanceFile();
	            iconInstanceFile.setArtifactToken(iconToken);
	            iconInstanceFile.setIsOriginal("0"); // No
	            iconInstanceFile.setIsConfidential("0"); // No
	            iconInstanceFile.setDeletedBy("");
	            iconInstanceFile.setDeleteDateTime("");
	            iconInstanceFile.setDeleteReason("");
	            iconInstanceFile.setCompressionMethod("none");
	            iconInstanceFile.setCompressionRatio("1.0");
	            iconInstanceFile.setDerivationDesc("Derived");
	    
	            InternalDicomRouter router = InternalDicomContext.getRouter();
	            iconInstanceFile = router.postInstanceFile(sopInstance, iconInstanceFile);
	            if(logger.isDebugEnabled()){
                    logger.debug("{}: Successfully stored Icon Image file.", this.getClass().getName());}
    		}
    		catch (FileNotFoundException fnfX)
    		{
                logger.error("Icon Image Creation: Could not find file {}.", currentFile);
                logger.error("{}: {}", this.getClass().getName(), fnfX.getMessage(), fnfX);
    			requeue(retryCount, routingToken, message, artifactToken, sopInstanceIEN, sopClassUID);
    		}
    		catch (IOException ioX)
    		{
                logger.error("Icon Image Creation: IO problem with file {}.", currentFile);
                logger.error("{}: {}", this.getClass().getName(), ioX.getMessage(), ioX);
    			requeue(retryCount, routingToken, message, artifactToken, sopInstanceIEN, sopClassUID);
    		}
    		catch (Exception X)
    		{
                logger.error("Icon Image Creation: General Exception with file {}.", currentFile);
                logger.error("{}: {}", this.getClass().getName(), X.getMessage(), X);
    			requeue(retryCount, routingToken, message, artifactToken, sopInstanceIEN, sopClassUID);
    			rethrowIfFatalException(X);
    		}
     		// Fortify change: added this block to ensure streams are closed and reworked a bit
     		finally
     		{
            	try{ if(iconStream != null) { iconStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/;}
            	try{ if(outputStream != null) { outputStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/;}
            	try{ if(artifactStream != null) { artifactStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/;}
     		            	
     			// Clean up.  Kept these = don't know if they should be removed after Fortify change
            	File dFile = new File(StringUtil.cleanString(dicomFile));
     			if(dFile.exists())
     			{
     				dFile.delete();
     			}
     			
     			if (realIcon) 
     			{
     				File iFile = new File(StringUtil.cleanString(iconFile));
     				if(iFile.exists())
     				{
     					iFile.delete();
     				}
     			}
     		}
     		
            if(logger.isDebugEnabled()){
                logger.debug("{}: Completed processing Image SOP Instance IEN {} [SOP Class= {}].", this.getClass().getName(), sopInstanceIEN, sopClassUID);}
            message = InternalContext.getRouter().dequeueDurableQueueMessage(routingToken, getIconQueue().getId(), Integer.toString(place.getId()));
         }
         logger.info("Completed processing entries in " + ASYNC_ICON_QUEUE + " for Icon Image Creation.  Back to sleep.");
    }
    
    
    private void requeue(int retryCount, RoutingToken routingToken, DurableQueueMessage message, 
    							String artifactToken, String sopInstanceIEN, String sopClassUID) throws ConnectionException, MethodException{
		if(retryCount < getIconQueue().getNumRetries()){
	    	retryCount++;
			message.setMessage(artifactToken + "^" + sopInstanceIEN + "^" + sopClassUID + "^" + String.valueOf(retryCount));
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.SECOND, getIconQueue().getRetryDelayInSeconds());
			message.setMinDeliveryDateTime(cal.getTime());
			try {
				InternalContext.getRouter().enqueueDurableQueueMessage(routingToken, message);
                logger.info("Icon Image creation request requeued for {}.", sopInstanceIEN);
			} 
			catch (Exception X) {
                logger.error("Failed to requeue Image SOP Instance IEN {} to create Icon Image. No Icon Image will be created.", sopInstanceIEN);
				rethrowIfFatalException(X);
			}
		}
		else{
			//false, log message and throw away the message.
            logger.error("Failed to create Icon Image for {} after maximum number of retries. No Icon Image will be created.", sopInstanceIEN);
		}		
    }
    
    
	private void writeFileToDisk(InputStream inputStream, FileOutputStream outputStream) throws FileNotFoundException, IOException
	{
		byte buf[]=new byte[1024];
		int len;
		while((len=inputStream.read(buf))>0)
		{
			outputStream.write(buf,0,len);
		}
	}	

	private DurableQueue getIconQueue() throws ConnectionException, MethodException{
		if (iconQueue == null)
		{
			RoutingToken routingToken = getCommandContext().getLocalSite().getArtifactSource().createRoutingToken();
			iconQueue = InternalContext.getRouter().getDurableQueueByName(routingToken, ASYNC_ICON_QUEUE);
		}
		return iconQueue;
	}
	
	public List<Class<? extends MethodException>> getFatalPeriodicExceptionClasses()
	{
		List<Class<? extends MethodException>> fatalExceptions = new ArrayList<Class<? extends MethodException>>();
		fatalExceptions.add(InvalidUserCredentialsException.class);
		return fatalExceptions;
	}
	
	/**
	 * This method is called when a periodic command has thrown a fatal exception as defined by the list in getFatalPeriodicExceptionClasses(). At the point when this method is called
	 * the periodic command has already stopped executing and will not execute again.  This method is meant to allow the command to alert someone of the failure (such as by sending 
	 * an email message)
	 * @param t
	 */
	public void handleFatalPeriodicException(Throwable t)
	{
		String subject = "Invalid HDIG service account credentials";
		String message = "The ProcessIconImageCreationQueue periodic command has shut down due to invalid HDIG service account credentials.";
		NotificationFacade.sendNotification(NotificationTypes.InvalidServiceAccountCredentials, subject, message);
	}

}
