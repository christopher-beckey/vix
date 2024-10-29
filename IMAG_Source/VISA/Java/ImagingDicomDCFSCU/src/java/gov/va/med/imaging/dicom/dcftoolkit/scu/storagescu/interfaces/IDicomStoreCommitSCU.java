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
package gov.va.med.imaging.dicom.dcftoolkit.scu.storagescu.interfaces;

import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationAbortException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationGeneralException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationRejectException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.exceptions.DicomStoreSCUInstanceException;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;

import java.util.HashSet;

/**
 *
 * Interface.  The Implementation handles Dicom Toolkit Layer N-EVENT-REPORT SCU activity.  
 * This includes opening the DICOM Store Commit Association, sending a DICOM 
 * N-EVENT-REPORT through established Association and closing the Association.  
 *
 * @author vhaiswtittoc
 *
 */
public interface IDicomStoreCommitSCU {
    
    /**
     * Open Store Commit Association with the Store Commit SCU in Reverse Role Negotiation.
     * 
     * @param remoteAE represents the remote Dicom AE for the Store Commit SCU.
     * @param callingAEtitle represents the local AETitle of the Store Commit SCU.
     * @throws DicomAssociationRejectException
     * @throws DicomAssociationGeneralException
     */
    public abstract void openStoreCommitAssociation(DicomAE remoteAE, String scuAETitle)
            throws DicomAssociationRejectException, DicomAssociationGeneralException;

    
    /**
      * Send a DICOM N-EVENT-REPORT to the the Store Commit SCU in Reverse Role Negotiation.
     * 
     * @param dds represents the generic DicomDataSet object containing the N-EVENT-REPORT.
     * @throws DicomStoreSCUInstanceException
     * @throws DicomAssociationAbortException
     */
    public abstract int sendNERResponse(DicomAE remoteAE, StorageCommitWorkItem scWI)
            throws DicomStoreSCUInstanceException, DicomAssociationAbortException;

    
    /**
     * Close the Association with the Store Commit SCU.
     * 
     * @throws DicomAssociationAbortException
     */
    public abstract void closeStoreCommitAssociation()
            throws DicomAssociationAbortException;


    public boolean VerifyAssociation(String callingAETitle, String calledAETitle, String addr)
    throws DicomAssociationRejectException;
    
}
