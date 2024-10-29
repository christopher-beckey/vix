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

import java.io.InputStream;
import java.util.HashSet;

/**
 *
 * Interface.  The Implementation handles Dicom Toolkit Layer C-Store SCU activity.  
 * This includes opening the DICOM Store Association, sending DICOM objects over that 
 * Association, and closing the Association.  
 *
 * @author William Peterson
 *
 */
public interface IDicomStoreSCU {
    
    /**
     * Open a DICOM Store Association with a C-Store SCP.  
     * 
     * @param scuAETitle represents the calling AETitle.
     * @param remoteAE represents the C-Store SCP information.
     * @throws DicomAssociationRejectException
     * @throws DicomAssociationGeneralException
     */
    public abstract void openStoreAssociation(String scuAETitle, DicomAE remoteAE)
            throws DicomAssociationRejectException, DicomAssociationGeneralException;

    /**
     * Open a DICOM Store Association with a C-Store SCP.  
     * 
     * @param scuAETitle represents the calling AETitle.
     * @param remoteAE represents the C-Store SCP information.
     * @param sopClassUIDs represents the list of SOP Class UIDs wanted for Association Negotiation.
     * @throws DicomAssociationRejectException
     * @throws DicomAssociationGeneralException
     */
    public abstract void openStoreAssociation(String scuAETitle, DicomAE remoteAE, 
    		HashSet<String> sopClassUIDs)
    		throws DicomAssociationRejectException, DicomAssociationGeneralException;

    
    public abstract void sendObject(InputStream dicomInstance) 
            throws DicomStoreSCUInstanceException, DicomAssociationAbortException;
    
    /**
     * Send a DicomDataSet object to the C-Store SCP.
     * 
     * @param dds represents the DicomDataSet object.
     * @throws DicomStoreSCUInstanceException
     * @throws DicomAssociationAbortException
     */
    public abstract int sendObject(IDicomDataSet dds)
            throws DicomStoreSCUInstanceException, DicomAssociationAbortException;

    
    /**
     * Close the DICOM C-Store Association with the C-Store SCP.
     * 
     * @throws DicomAssociationAbortException
     */
    public abstract void closeStoreAssociation()
            throws DicomAssociationAbortException;


    public boolean VerifyAssociation(String callingAETitle, String calledAETitle, String addr)
    throws DicomAssociationRejectException;
    
}
