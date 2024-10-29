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

import gov.va.med.imaging.business.exceptions.PostDicomInstanceSetException;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.DicomContext;
import gov.va.med.imaging.dicom.DicomRouter;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.spring.SpringContext;
import gov.va.med.imaging.dicom.common.stats.DicomServiceStats;
import gov.va.med.imaging.dicom.common.utils.Publisher;
import gov.va.med.imaging.dicom.dcftoolkit.common.observer.SubOperationsStatus;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationAbortException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationInitializationException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationRejectException;
import gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreSCUControl;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomInstanceSet;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.InstanceStorageInfo;
import gov.va.med.imaging.exchange.business.dicom.MoveCommandObserver;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Observer;
import java.util.concurrent.LinkedBlockingQueue;

import gov.va.med.logging.Logger;

/**
 * This Router command establishes a DICOM Association and controls the flow of retrieving, 
 * reconstituting, and sending DICOM Instances to the DICOM device.
 *  
 * @author vhaiswpeterb
 *
 */
@RouterCommandExecution(asynchronous = true, distributable = false)
public class PostDicomInstanceSetCommandImpl 
extends AbstractDicomCommandImpl<Void>
{
	private static final long serialVersionUID = 1308887187782421285L;
    private static Logger logger = Logger.getLogger(PostDicomInstanceSetCommandImpl.class);
    private static final DicomRouter router = DicomContext.getRouter();
    private static final InternalDicomRouter internalrouter = InternalDicomContext.getRouter();

	private IDicomDataSet LASTBAG = null;
    private Publisher subOperationsPublisher = null;
    private SubOperationsStatus subOperationsStatus = null;
	private String storeAETitle = null;
	private DicomInstanceSet instances = null;
	private Observer scpListener = null;
	private MoveCommandObserver moveCommand = null;
	private LinkedBlockingQueue<IDicomDataSet> queue;
	
	public PostDicomInstanceSetCommandImpl(String storeAETitle, DicomInstanceSet instances, 
			Observer scpListener, MoveCommandObserver moveCommand)
	{
		this.storeAETitle = storeAETitle;
		this.instances = instances;
		this.scpListener = scpListener;
		this.moveCommand = moveCommand;
		this.queue = new LinkedBlockingQueue<IDicomDataSet>(DicomServerConfiguration.getConfiguration().getMoveQueueCapacity());
		
		this.LASTBAG = (IDicomDataSet)SpringContext.getContext().getBean("DicomDataSet");
		this.LASTBAG.setName("LASTBAG");
	}

	@Override
	public Void callSynchronouslyInTransactionContext() throws MethodException, ConnectionException
	{
		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router Command {}", Thread.currentThread().getId(), this.getClass().getName());}

        subOperationsStatus = new SubOperationsStatus();
        //Add object Total to SubOperationsStatus object.
        subOperationsStatus.setRemainingSubOperations(this.instances.size());
        if(!DicomServerConfiguration.getConfiguration().isMoveSubOperationsEnabled()){
        	subOperationsStatus.setSubOperationsActive(false);
        }
		if(this.scpListener != null){
			//Initialize SubOperations Activity
			subOperationsPublisher = new Publisher();			
	        //Add Subscriber to Publisher.
	        subOperationsPublisher.addObserver(scpListener);
		}
		notifySubscribers();

		IStoreSCUControl scu = (IStoreSCUControl)SpringContext.getContext().getBean("StoreSCUControl");
		//Get the SOP Class UIDs needed for the association.
		HashSet<String> sopClassUIDs = this.createSOPClassUIDList();
		//Get the Connection info for the CStore SCU.
		DicomAE remoteAE = router.getRemoteAE(DicomAE.searchMode.REMOTE_AE, storeAETitle,
				DicomServerConfiguration.getConfiguration().getSiteId());
		
		//Open DICOM Association to the CStore SCU.
		try {
			if(remoteAE.getResultCode() < 0){
                logger.error("C-Store AETitle Error: {}, {}", remoteAE.getResultCode(), remoteAE.getResultMessage());
                logger.error("AETitle, {}, does not have permission to initiate a C-Store Dimse Service to the C-Storage SCP.\nThis permission is configurable using DICOM AE Security Matrix.", remoteAE.getRemoteAETitle());
				throw new AssociationInitializationException(remoteAE.getResultCode()+", "+remoteAE.getResultMessage());
			}
			scu.openStoreAssociation(remoteAE, remoteAE.getLocalAETitle(), sopClassUIDs);
			DicomServiceStats.getInstance().incrementOutboundAssociationAcceptCount(storeAETitle);

			//Start PostDicomDataSet router command.  This is an async command that watches the
			//	queue and sends anything in that queue to the SCU.  Once started, you can then
			//	start building DICOM objects and add them to the queue.
			try{
				internalrouter.postDicomDataSet(remoteAE, scu, queue, subOperationsPublisher, subOperationsStatus, 
						moveCommand);
			}
			catch(MethodException mX){
				throw new PostDicomInstanceSetException(mX);
			}
			catch(ConnectionException cX){
				//WFP-Take out all object put into the queue.  Collect their SOP Instance UIDs.
				throw new PostDicomInstanceSetException(cX);
			}
			
			//Now it's time to populate the queue.
			
			//LOOP: Cycle thru DicomInstanceSet collection.  Collection returns 
			//	InstanceStorageInfo object.
			Iterator<InstanceStorageInfo> iter = this.instances.iterator();
			while(iter.hasNext()){
				//Pass the InstanceStorageInfo object to the GetDicomDataSet router command.
				//	This will return a IDicomDataSet object.
				InstanceStorageInfo info = (InstanceStorageInfo)iter.next();
				IDicomDataSet dds = null;
				try{
					dds = router.getDicomDataSet(info);
					//Add IDicomDataSet object to queue.
					if(dds == null){
                        logger.error("Failed to create DicomDataSet for {}\n", info.getObjectIdentifier());
                        logger.error("Failed to create a DICOM object for {} to send to C-Storage SCP.\nThe result is a DICOM Object was not transmitted to the C-Storage SCP.  Refer to other logs for more detail.", info.getObjectIdentifier());
						this.subOperationsStatus.setFailedSubOperations();
						notifySubscribers();
					}
					else{
						if(!this.moveCommand.isSendDicomDataSetsAbort()){
							if(logger.isDebugEnabled()){logger.debug("Putting DicomDataSet into the Send Queue.");}
							this.queue.put(dds);
						}
						else{
							this.subOperationsStatus.addFailedSOPInstanceUID(dds.getSOPInstanceUID());
							notifySubscribers();
						}
					}
				} 
				catch (InterruptedException iX) {
					logger.error(iX.getMessage());
					if(dds != null){
						this.subOperationsStatus.addFailedSOPInstanceUID(dds.getSOPInstanceUID());
					}
					else{
						this.subOperationsStatus.setFailedSubOperations();
					}
					notifySubscribers();
				}
				catch (MethodException mX) {
					logger.error(mX.getMessage());
					if(dds != null){
						this.subOperationsStatus.addFailedSOPInstanceUID(dds.getSOPInstanceUID());
					}
					else{
						this.subOperationsStatus.setFailedSubOperations();
					}
					notifySubscribers();
				}
				catch (ConnectionException cX) {
					logger.error(cX.getMessage());
					if(dds != null){
						this.subOperationsStatus.addFailedSOPInstanceUID(dds.getSOPInstanceUID());
					}
					else{
						this.subOperationsStatus.setFailedSubOperations();
					}
					notifySubscribers();
				}
				//Check if CMove was cancelled.  If received, stop sending images and send
				//	final CMove operations message to the CMove subscriber.  Exit Loop.
				if(this.moveCommand.isCancelMoveOperation()){
					subOperationsStatus.setCompleteStatus(SubOperationsStatus.CANCEL);
					break;
				}
			}
			
			try {
				if(!this.moveCommand.isSendDicomDataSetsAbort()){
					this.queue.put(this.LASTBAG);					
				}
			} 
			catch (InterruptedException iX) {
	            logger.error(iX.getMessage());
	            logger.error("Failed to queue LAST BAG.");
				this.moveCommand.setGetDicomDataSetsDone(true);
			}
			
			while(!this.moveCommand.isSendDicomDataSetsDone() && !this.moveCommand.isSendDicomDataSetsAbort()){
				try {
					Thread.sleep(2000);
				} 
				catch (InterruptedException e) {
					//ignore.
				}
			}
			
			if(this.moveCommand.isSendDicomDataSetsAbort() && !this.queue.isEmpty()){
				Iterator<IDicomDataSet> queueIter = this.queue.iterator();
				while (queueIter.hasNext()){
					IDicomDataSet tempdds = queueIter.next();
					this.subOperationsStatus.addFailedSOPInstanceUID(tempdds.getSOPInstanceUID());
				}
			}
			            
    		//Close the DICOM Association to the CStore SCU.		    		
    		if(!this.moveCommand.isSendDicomDataSetsAbort()){
    			try{
    				if(logger.isDebugEnabled()){logger.debug("Closing C-Store Association.");}
    				scu.closeStoreAssociation();
    			}
        		catch (AssociationAbortException aaX) {
                    logger.error(aaX.getMessage());
                    logger.error("C-Store SCP Aborted the DICOM C-Store Association while closing.");
        		}
    		} 
    		
    		if(this.moveCommand.isSendDicomDataSetsAbort()){
    			subOperationsStatus.setErrorComment("C-Store SCU Association aborted.");
    			subOperationsStatus.setCompleteStatus(SubOperationsStatus.FAILURE_COMMENT);
    		}
    		else{
    			subOperationsStatus.setCompleteStatus(SubOperationsStatus.SUCCESS);
    		}
    		
		} 
		catch (AssociationRejectException arX) {
            logger.error(arX.getMessage());
            logger.error("C-Store SCP rejecting DICOM C-Store Association.");
			logger.error("The C-Store Dimse message was rejected by the C-Storage SCP.  Refer to other logs for more detail.");
            subOperationsStatus.setErrorComment(remoteAE.getRemoteAETitle()+" rejected Association Requested.\n "+arX.getMessage());
            subOperationsStatus.setCompleteStatus(SubOperationsStatus.FAILURE_COMMENT);
			DicomServiceStats.getInstance().incrementOutboundAssociationRejectCount(storeAETitle);
		} 
		catch (AssociationInitializationException aiX) {
            logger.error(aiX.getMessage());
            logger.error("Exception thrown opening DICOM C-Store Association.");
            logger.error("The C-Storage SCU Dimse Service failed to initialize.  \nLikely problem is the DICOM AE Security Matrix entry for this AETitle, {}, is configured with the wrong IP Address and/or Port#.\nRefer to other logs for more detail.", remoteAE.getRemoteAETitle());
            subOperationsStatus.setErrorComment("Association Initialization exception.\n "+aiX.getMessage());
            subOperationsStatus.setCompleteStatus(SubOperationsStatus.FAILURE_COMMENT);
		}
		catch(PostDicomInstanceSetException pdisX){
            logger.error(pdisX.getMessage());
            logger.error("Exception thrown opening DICOM C-Store Association.");
			logger.error("The C-Storage SCU Dimse Service failed to initialize.  Refer to other logs for more detail.");
            subOperationsStatus.setErrorComment("Posting Dicom Instance Set exception.\n ");
            subOperationsStatus.setCompleteStatus(SubOperationsStatus.FAILURE_COMMENT);
		}
		

		//Notify Observer with the final CMove Suboperations Response with list of failed
		//	SOP Instance UIDs.
        if(logger.isDebugEnabled()){logger.debug("Dicom Toolkit Layer: " + "Sending final C-Move Response to C-Move SCU.");}
        notifySubscribers();
    
        //Remove subscribers from Observable.
        subOperationsPublisher.deleteObservers();
		return null;
	}

	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.instances == null) ? 0 : this.instances.hashCode());
		result = prime * result + ((this.storeAETitle== null) ? 0 : this.storeAETitle.hashCode());
		result = prime * result + ((this.scpListener == null) ? 0 : this.scpListener.hashCode());
		result = prime * result + ((this.moveCommand == null) ? 0 : this.moveCommand.hashCode());

		return result;
	}

	
	@Override
	public boolean equals(Object obj)
	{
		// TODO Auto-generated method stub
		return false;
	}

	
	/**
	 * @return the Instances
	 */
	public DicomInstanceSet getInstances() {
		return this.instances;
	}

	
	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}
	
	private HashSet<String> createSOPClassUIDList(){
		HashSet<String> sopClasses = new HashSet<String>();
		
		Iterator<InstanceStorageInfo> iter = this.instances.iterator();
		
		while(iter.hasNext()){
			InstanceStorageInfo info = (InstanceStorageInfo)iter.next();
			String sopClass = info.getSopClassUID();
			if(sopClass != null){
				if(!sopClasses.contains(sopClass)){
					sopClasses.add(sopClass);
				}
			}
		}
		if(sopClasses.isEmpty()){
			if(logger.isDebugEnabled()){logger.debug("No SOP Classes from HIS. Will have to use SOP Classes from DCF configuration file.");}
		}
		else{
			if(logger.isDebugEnabled()){
                logger.debug("SOP Class UID List based on information retrieved from HIS: {}", sopClasses.toString());}
		}
		return sopClasses;
	}
	
	private void notifySubscribers(){
	    if(subOperationsPublisher != null){
	    	//Notify the Publisher to send the status object to the subscribers.
	    	subOperationsPublisher.publish(subOperationsStatus);
	    }
	}
}
