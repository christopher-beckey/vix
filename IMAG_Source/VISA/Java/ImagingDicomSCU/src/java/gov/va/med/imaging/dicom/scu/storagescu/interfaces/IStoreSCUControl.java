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

import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationAbortException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationInitializationException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationRejectException;
import gov.va.med.imaging.dicom.scu.exceptions.SendInstanceException;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;

import java.io.InputStream;
import java.util.HashSet;

/**
 *
 * Interface. This Interface resides in the Dicom Generic Layer.  Handles opening and 
 * closing of the Store Association.  Also handles sending of DICOM objects across an 
 * established Association.  
 *
 *
 * @author William Peterson
 *
 */
public interface IStoreSCUControl {

    
    /**
     * Open Store Association with the C-Store SCP.
     * 
     * @param remoteAE represents the remote Dicom AE for C-Store SCP.
     * @param callingAEtitle represents the called (local) AETitle of the C-Store SCU.
     * @param sopClassUIDs represents the SOP Classes to use for DICOM Association.
     * @throws AssociationRejectException
     * @throws AssociationInitializationException
     */
    public abstract void openStoreAssociation(DicomAE remoteAE, String callingAETitle,
    		HashSet<String> sopClassUIDs) throws AssociationRejectException,
    		AssociationInitializationException;
    
    
    public abstract void sendObject(InputStream fileStream)
            throws SendInstanceException, AssociationAbortException;
    
    /**
     * Send a DICOM Object to the C-Store SCP.
     * 
     * @param dds represents the generic DicomDataSet object.
     * @throws SendInstanceException
     * @throws AssociationAbortException
     */
    public abstract int sendObject(IDicomDataSet dds)
    throws SendInstanceException, AssociationAbortException;


    /**
     * Close the Association with the C-Store SCP.
     *  
     * @param reason represents why the Association is closing.
     * @throws AssociationAbortException
     */
    public abstract void closeStoreAssociation() throws AssociationAbortException;
    
}
