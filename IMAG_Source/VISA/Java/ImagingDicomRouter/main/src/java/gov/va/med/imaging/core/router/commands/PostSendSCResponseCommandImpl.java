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

import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.DicomContext;
import gov.va.med.imaging.dicom.DicomRouter;
import gov.va.med.imaging.dicom.common.Constants;
import gov.va.med.imaging.dicom.common.spring.SpringContext;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationAbortException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationInitializationException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationRejectException;
import gov.va.med.imaging.dicom.scu.exceptions.SendInstanceException;
import gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreCommitSCUControl;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;

import gov.va.med.logging.Logger;

/**
 * This Router command pulls VI DICOM Dataset objects off of a Queue and transmit these objects
 * to a DICOM device that already has an established DICOM Association.
 * 
 * @author vhaiswtittoc
 *
 */
@RouterCommandExecution(asynchronous = true, distributable = false)
public class PostSendSCResponseCommandImpl 
extends AbstractDicomCommandImpl<Integer> {

	private static final long serialVersionUID = -5404268896761858533L;
	private static final DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
	private static Logger logger = Logger.getLogger(PostSendSCResponseCommandImpl.class);
    private static final DicomRouter router = DicomContext.getRouter();
    private int result;
   
	public int getResult() {
		return result;
	}

	public void setResult(int result) {
		this.result = result;
	}

	private IStoreCommitSCUControl scScu = null;
	private StorageCommitWorkItem scWI;
	
	public PostSendSCResponseCommandImpl(StorageCommitWorkItem scWI, StorageCommitWaiter scWaiter){
		this.scWI = scWI;
		this.addListener(scWaiter);
	}

	@Override
	public Integer callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException {

		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router Command {}", Thread.currentThread().getId(), this.getClass().getName());}
		
		scScu = (IStoreCommitSCUControl)SpringContext.getContext().getBean("StoreCommitSCUControl");
		
		// Get the Connection info for the CStore SCU -- RemoteAE with IP and port
		DicomAE remoteAE = router.getRemoteAE(DicomAE.searchMode.APP_NAME, scWI.getApplicationName(), config.getSiteId()); // find entry by unique appName (AE NAME in M)

		// Get the local C-MOVE AE and store in SC WI
		String moveAE = "";
		try {
			DicomAE qrAE = router.getRemoteAE(DicomAE.searchMode.SERVICE_AND_ROLE, "C-MOVE", "SCU"); // finds the first hit in AE Sec. Mx.
			if ((qrAE!=null) && (qrAE.getLocalAETitle()!=null))
				moveAE=qrAE.getLocalAETitle();
		} catch (Exception e) {
            logger.error("Error getting local C-MOVE AE for SC Responses:{}", e.getMessage());
		}
		scWI.setMoveAE(moveAE);
						
		result=Constants.SUCCESS;

		// open association toward SC SCU requesting Reversed Role negotiation
		try {
			scScu.openStoreCommitAssociation(remoteAE, remoteAE.getLocalAETitle());
		} 
		catch (AssociationInitializationException aie) {
            logger.error("SC SCU initialization error:{}", aie.getMessage());
            logger.error("{}: Establishing Association failed during SC Response send.", this.getClass().getName());
            result = Constants.FAILURE;
		}
		catch (AssociationRejectException are) {
            logger.error("SC SCU rejection error:{}", are.getMessage());
            logger.error("{}: Establishing Association failed during SC Response send.", this.getClass().getName());
            result = Constants.ABORT;
		}

		if (result==Constants.SUCCESS) {
			// send N-EVENT-REPORT and wait for response
			try {
				result = this.scScu.sendNERResponse(remoteAE, scWI);
			} 
			catch (SendInstanceException siX) {
		        logger.error(siX.getMessage());
                logger.error("{}: N-Event-Report SCP failed during SC Response send.", this.getClass().getName());
		        result = Constants.FAILURE;
			} 
			catch (AssociationAbortException aaX) {
		        logger.error(aaX.getMessage());
                logger.error("{}: N-Event-Report SCP aborted the DICOM Association while sending DICOM response to SC requester.", this.getClass().getName());
			    result = Constants.ABORT;
				}
			}
				
		// close association
//		if (result==Constants.SUCCESS) {
			try {
				scScu.closeStoreCommitAssociation();
			}	
			catch (AssociationAbortException aaX) {
	            logger.error(aaX.getMessage());
                logger.error("{}: N-Event-Report SCP aborted the DICOM Association while sending DICOM response to SC requester.", this.getClass().getName());
	            result = Constants.ABORT;
//			}
		}
		
		switch(result){
			//P116 - Confirm each case contains the correct response.
            case (Constants.SUCCESS):
                if(logger.isDebugEnabled()){logger.debug("N-Event-Report Dimse Status is Success.");}
            	break;
            case (Constants.WARNING):
                if(logger.isDebugEnabled()){logger.debug("N-Event-Report Dimse Status is Warning.");}
            	break;
            case (Constants.REJECT):
                if(logger.isDebugEnabled()){logger.debug("N-Event-Report Dimse Status is Rejected.");}
            	break;
            case (Constants.ABORT):
                if(logger.isDebugEnabled()){logger.debug("N-Event-Report Dimse Status is Abort.");}
            	return result;	            	
            default:
                if(logger.isDebugEnabled()){logger.debug("N-Event-Report Dimse Status is Failure.");}
		}

		return result;
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
	
}
