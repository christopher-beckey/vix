/*
 * Created on Sep 19, 2005
// Per VHA Directive 2004-038, this routine should not be modified.
//+---------------------------------------------------------------+
//| Property of the US Government.                                |
//| No permission to copy or redistribute this software is given. |
//| Use of unreleased versions of this software requires the user |
//| to execute a written test agreement with the VistA Imaging    |
//| Development Office of the Department of Veterans Affairs,     |
//| telephone (301) 734-0100.                                     |
//|                                                               |
//| The Food and Drug Administration classifies this software as  |
//| a medical device.  As such, it may not be changed in any way. |
//| Modifications to this software may result in an adulterated   |
//| medical device under 21CFR820, the use of which is considered |
//| to be a violation of US Federal Statutes.                     |
//+---------------------------------------------------------------+
 */
package gov.va.med.imaging.dicom.scu.storagescu.impl;

import gov.va.med.imaging.dicom.common.spring.SpringContext;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationAbortException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationGeneralException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationRejectException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.exceptions.DicomStoreSCUInstanceException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.storagescu.interfaces.IDicomStoreCommitSCU;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationAbortException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationInitializationException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationRejectException;
import gov.va.med.imaging.dicom.scu.exceptions.SendInstanceException;
import gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreCommitSCUControl;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;

import gov.va.med.logging.Logger;

/**
 *
 * This class implements the IStoreCommitSCUControl Interface.  This class works in the Dicom 
 * Generic Layer.  It calls the Dicom Toolkit Layer to implement Toolkit specific tasks.
 *
 *
 * @author vhaiswtittoc
 *
 */
public class StoreCommitSCUControlImpl implements IStoreCommitSCUControl {
    
   /*
     * Create an IStoreCommitSCU instance.  This lives in the Dicom Toolkit Layer.
     */
    private IDicomStoreCommitSCU storeCommitSCU = null;
    
    private static final Logger logger = Logger.getLogger (StoreCommitSCUControlImpl.class);


    /**
     * Constructor
     */
    public StoreCommitSCUControlImpl() {
        super();
    }    
    
    
	@Override
	public void openStoreCommitAssociation(DicomAE remoteAE, String callingAETitle)
	throws AssociationRejectException, AssociationInitializationException {

		//Invoke method in DICOM Toolkit Layer.
		try{
			this.storeCommitSCU = (IDicomStoreCommitSCU)SpringContext.getContext().getBean("DicomStoreCommitSCU");
			storeCommitSCU.openStoreCommitAssociation(remoteAE, callingAETitle);
		} 
		catch (DicomAssociationRejectException darX) {
            logger.error(darX.getMessage());
            logger.error("{}: Exception thrown attempting to open DICOM Association.  Association Rejected.", this.getClass().getName());
            throw new AssociationRejectException(darX);
		} 
		catch (DicomAssociationGeneralException dagX) {
            logger.error(dagX.getMessage());
            logger.error("{}: Exception thrown attempting to open DICOM Association.  Association failed.", this.getClass().getName());
            throw new AssociationInitializationException(dagX);
		}
	}
    

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreSCUControl#sendObject(gov.va.med.imaging.dicom.common.interfaces.IBusinessDataSet)
     */
	@Override
    public int sendNERResponse(DicomAE remoteAE, StorageCommitWorkItem scWI)
    throws SendInstanceException, AssociationAbortException{
        
		int result;
        //call method in StoreSCU object to process sending of object.
        try{
        	result = storeCommitSCU.sendNERResponse(remoteAE, scWI);
        }
        catch(DicomAssociationAbortException abort){
            throw new AssociationAbortException(abort);
        }
        catch(DicomStoreSCUInstanceException dsscuiX){
            throw new SendInstanceException(dsscuiX);
        }
        return result;
    }
	

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreSCUControl#closeStoreAssociation(int)
     */
	@Override
    public void closeStoreCommitAssociation()
            throws AssociationAbortException {
        
        try{
        	storeCommitSCU.closeStoreCommitAssociation();
        }
        catch(DicomAssociationAbortException abort){
            logger.error(abort.getMessage());
            logger.error("{}: \nException thrown while closing Association.", this.getClass().getName());
            throw new AssociationAbortException(abort);
        }
    }


}
