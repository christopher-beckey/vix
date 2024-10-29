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
package gov.va.med.imaging.dicom.scu.storagescu.interfaces;

import gov.va.med.imaging.dicom.scu.exceptions.AssociationAbortException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationInitializationException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationRejectException;
import gov.va.med.imaging.dicom.scu.exceptions.SendInstanceException;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;

/**
 *
 * Interface. This Interface resides in the DICOM Generic Layer.  Handles opening and 
 * closing of the Association for the Store Commit SCU.  Also handles sending a DICOM 
 * N-EVENT-REPORT through established Association.  
 *
 *
 * @author vhaiswtittoc
 *
 */
public interface IStoreCommitSCUControl {

    
    /**
     * Open Store Commit Association with the Store Commit SCU in Reverse Role Negotiation.
     * 
     * @param remoteAE represents the remote Dicom AE for the Store Commit SCU.
     * @param callingAEtitle represents the local AETitle of the Store Commit SCU.
     * @throws AssociationRejectException
     * @throws AssociationInitializationException
     */
    public abstract void openStoreCommitAssociation(DicomAE remoteAE, String callingAETitle) throws AssociationRejectException,
    		AssociationInitializationException;
        
    /**
     * Send a DICOM N-EVENT-REPORT to the the Store Commit SCU in Reverse Role Negotiation.
     * 
     * @param dds represents the generic DicomDataSet object containing the N-EVENT-REPORT.
     * @throws SendInstanceException
     * @throws AssociationAbortException
     */
    public abstract int sendNERResponse(DicomAE remoteAE, StorageCommitWorkItem scWI)
    throws SendInstanceException, AssociationAbortException;


    /**
     * Close the Association with the Store Commit SCU.
     *  
     * @param reason represents why the Association is closing.
     * @throws AssociationAbortException
     */
    public abstract void closeStoreCommitAssociation() throws AssociationAbortException;

}
