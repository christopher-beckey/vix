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

import java.util.concurrent.LinkedBlockingQueue;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.common.Constants;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.stats.DicomServiceStats;
import gov.va.med.imaging.dicom.common.utils.Publisher;
import gov.va.med.imaging.dicom.dcftoolkit.common.observer.SubOperationsStatus;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationAbortException;
import gov.va.med.imaging.dicom.scu.exceptions.SendInstanceException;
import gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreSCUControl;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.MoveCommandObserver;

/**
 * This Router command pulls VI DICOM Dataset objects off of a Queue and transmit these objects
 * to a DICOM device that already has an established DICOM Association.
 * 
 * @author vhaiswpeterb
 *
 */
@RouterCommandExecution(asynchronous = true, distributable = false)
public class PostDicomDataSetCommandImpl 
extends AbstractDicomCommandImpl<Void> {

	private static final long serialVersionUID = -5404268896761858533L;
	private static Logger logger = Logger.getLogger(PostDicomDataSetCommandImpl.class);

	private IStoreSCUControl scu = null;
	private DicomAE remoteAE = null;
	private LinkedBlockingQueue<IDicomDataSet> queue = null;
    private Publisher subOperationsPublisher = null;
    private SubOperationsStatus subOperationsStatus = null;
	private MoveCommandObserver moveCommand = null;
	
	public PostDicomDataSetCommandImpl(DicomAE remoteAE, IStoreSCUControl scu, 
			LinkedBlockingQueue<IDicomDataSet> queue, Publisher subOperationsPublisher, 
			SubOperationsStatus subOperationsStatus, MoveCommandObserver cancelMove){
		this.scu = scu;
		this.remoteAE = remoteAE;
		this.queue = queue;
		this.subOperationsPublisher = subOperationsPublisher;
		this.subOperationsStatus = subOperationsStatus;
		this.moveCommand = cancelMove;
	}

	@Override
	public Void callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException {

		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router Command {}", Thread.currentThread().getId(), this.getClass().getName());}
		
		//LOOP: Cycle thru the queue.
		//Check if CMove is cancelled.
		while(!this.moveCommand.isCancelMoveOperation() && !this.moveCommand.isSendDicomDataSetsAbort()){
			IDicomDataSet dds = null;
			try {
				if(logger.isDebugEnabled()){logger.debug("Taking DicomDataSet out of Send Queue and sending to Storage SCU.");}
				dds = (IDicomDataSet)this.queue.take();
			} 
			catch (InterruptedException iX) {
	            logger.error(iX.getMessage());
	            logger.error("Exception thrown attempting to take DicomDataSet from Send Queue.");		
	            logger.error("Failed to fetch DICOM Object from the Send Queue.  The result is a DICOM Object was not transmitted to the C-Storage SCP.\n" +
	            		"Refer to other logs for more detail.");
			}
			if(dds != null){
				if(dds.getName().equals("LASTBAG")){
					break;
				}	
				int result;
				//Send object to the SCU.
				try {
					if(logger.isDebugEnabled()){logger.debug("Sending DicomDataSet object.");}
					result = this.scu.sendObject(dds);
				} 
				catch (SendInstanceException siX) {
		            logger.error(siX.getMessage());
		            logger.error("C-Store SCP failed during DICOM object send.");		
		            logger.error("Failed to transmitted DICOM Object to C-Storage SCP.  Refer to other logs for more detail.");
		            result = Constants.FAILURE;
				} 
				catch (AssociationAbortException aaX) {
		            logger.error(aaX.getMessage());
		            logger.error("C-Store SCP aborted the DICOM C-Store Association "+
		            		"while sending DICOM objects.");
		            logger.error("The C-Storage SCP aborted the DICOM Association.  The result is all associated DICOM Objects may not have been transmitted.\n" +
		            		"Refer to other logs for more detail.");
	            	//subOperationsStatus.addFailedSOPInstanceUID(dds.getSOPInstanceUID());
	            	//notifySubscribers();
	            	//DicomServiceStats.getInstance().incrementOutboundObjectRejectedCount(scu.getRemoteAE().getRemoteAETitle());
	        		this.moveCommand.setSendDicomDataSetsAbort(true);
	            	//throw new ConnectionException(aaX.getMessage());	            	
		            result = Constants.ABORT;
				}
	           
				//Update the status object.
				//Notify Observer with result.
				switch(result){
	            
				//P116 - Confirm each case contains the correct response.
	            case (Constants.SUCCESS):
	                if(logger.isDebugEnabled()){logger.debug("C-Store-RSP Dimse Status is Success.");}
	            	subOperationsStatus.setSuccessfulSubOperations();
	            	notifySubscribers();
	            	DicomServiceStats.getInstance().incrementOutboundObjectTransmittedCount(this.remoteAE.getRemoteAETitle());
	            	break;
	            case (Constants.WARNING):
	                if(logger.isDebugEnabled()){logger.debug("C-Store-RSP Dimse Status is Warning.");}
	            	subOperationsStatus.setWarningSubOperations();
	            	notifySubscribers();
	            	DicomServiceStats.getInstance().incrementOutboundObjectTransmittedCount(this.remoteAE.getRemoteAETitle());

	            	break;
	            case (Constants.REJECT):
	                if(logger.isDebugEnabled()){logger.debug("C-Store-RSP Dimse Status is Rejected.");}
	            	subOperationsStatus.addFailedSOPInstanceUID(dds.getSOPInstanceUID());
	            	notifySubscribers();
	            	DicomServiceStats.getInstance().incrementOutboundObjectRejectedCount(this.remoteAE.getRemoteAETitle());
	            	break;
	            case (Constants.ABORT):
	                if(logger.isDebugEnabled()){logger.debug("C-Store-RSP Dimse Status is Abort.");}
	            	subOperationsStatus.addFailedSOPInstanceUID(dds.getSOPInstanceUID());
	            	notifySubscribers();
	            	DicomServiceStats.getInstance().incrementOutboundObjectRejectedCount(this.remoteAE.getRemoteAETitle());
	            	//throw new ConnectionException("C-Store SCU DICOM Association Aborted.");
	            	break;
	            case (Constants.FAILURE):
	            	if(logger.isDebugEnabled()){logger.debug("C-Store-RSP Dimse Status is Failure.");}
	            	subOperationsStatus.addFailedSOPInstanceUID(dds.getSOPInstanceUID());
	            	DicomServiceStats.getInstance().incrementOutboundObjectRejectedCount(this.remoteAE.getRemoteAETitle());
	            	notifySubscribers();
	            	break;
	            default:
	                if(logger.isDebugEnabled()){logger.debug("C-Store-RSP Dimse Status is Failure.");}
	            	subOperationsStatus.addFailedSOPInstanceUID(dds.getSOPInstanceUID());
	            	DicomServiceStats.getInstance().incrementOutboundObjectRejectedCount(this.remoteAE.getRemoteAETitle());
	            	notifySubscribers();
	            	break;
	            }
			}
		}
		this.moveCommand.setSendDicomDataSetsDone(true);
		return null;
	}
	
	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		return super.equals(obj);
	}

	@Override
	protected String parameterToString() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}
	
	private void notifySubscribers(){
	    if(subOperationsPublisher != null){
	    	//Notify the Publisher to send the status object to the subscribers.
	    	subOperationsPublisher.publish(subOperationsStatus);
	    }
	}
}
