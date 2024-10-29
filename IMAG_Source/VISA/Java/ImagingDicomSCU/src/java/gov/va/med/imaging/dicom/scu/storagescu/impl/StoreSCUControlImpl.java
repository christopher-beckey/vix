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

import java.io.InputStream;
import java.util.HashSet;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.spring.SpringDicomStoreSCUContext;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationAbortException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationGeneralException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationRejectException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.exceptions.DicomStoreSCUInstanceException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.storagescu.interfaces.IDicomStoreSCU;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationAbortException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationInitializationException;
import gov.va.med.imaging.dicom.scu.exceptions.AssociationRejectException;
import gov.va.med.imaging.dicom.scu.exceptions.SendInstanceException;
import gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreSCUControl;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;

/**
 *
 * This class implements the StoreSCUControl Interface.  This class works in the Dicom 
 * Generic Layer.  It calls the Dicom Toolkit Layer to implement Toolkit specific tasks.
 *
 *
 * @author William Peterson
 *
 */
public class StoreSCUControlImpl implements IStoreSCUControl {
    
   /*
     * Create a StoreSCU instance.  This lives in the Dicom Toolkit Layer.
     */
    private IDicomStoreSCU storeSCU;
    
    private static final Logger logger = Logger.getLogger (StoreSCUControlImpl.class);


    /**
     * Constructor
     */
    public StoreSCUControlImpl() {
        super();
    }    

    @Override
	public void openStoreAssociation(DicomAE remoteAE, String callingAETitle,
			HashSet<String> sopClassUIDs) throws AssociationRejectException,
			AssociationInitializationException 
    {
    	synchronized(storeSCU)
    	{
			try{
				IDicomStoreSCU dicomStoreSCU = (IDicomStoreSCU)SpringDicomStoreSCUContext.getContext().getBean("DicomStoreSCU");
				dicomStoreSCU.openStoreAssociation(callingAETitle, remoteAE, sopClassUIDs);
				setStoreSCU(dicomStoreSCU);
			} 
			catch (DicomAssociationRejectException darX) {
	            logger.error(darX.getMessage());
                logger.error("{}: Exception thrown attempting to open DICOM Association.  Association Rejected.", this.getClass().getName());
	            throw new AssociationRejectException();
			} 
			catch (DicomAssociationGeneralException dagX) {
	            logger.error(dagX.getMessage());
                logger.error("{}: Exception thrown attempting to open DICOM Association.  Association failed.", this.getClass().getName());
	           throw new AssociationInitializationException();
			}
	    }
	}

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreSCUControl#sendObject(java.io.InputStream)
     */
	@Override
    public void sendObject(InputStream dicomDataStream)
            throws SendInstanceException, AssociationAbortException {
        
        try{
        	storeSCU.sendObject(dicomDataStream);
        }
        catch(DicomAssociationAbortException abort){
            logger.error(abort.getMessage());
            logger.error("{}: \nException thrown while sending Object.", this.getClass().getName());
            //IMPROVE Add new signature for message and cause.
            throw new AssociationAbortException();
        }
        catch(DicomStoreSCUInstanceException reject){
            logger.error(reject.getMessage());
            logger.error("{}: \nException thrown while sending Object.", this.getClass().getName());
            //IMPROVE Add new signature for message and cause.
            throw new SendInstanceException();
        }
    }
    
    
    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.scu.storagescu.interfaces.IStoreSCUControl#sendObject(gov.va.med.imaging.dicom.common.interfaces.IBusinessDataSet)
     */
	@Override
    public int sendObject(IDicomDataSet dds)
    throws SendInstanceException, AssociationAbortException{
        
		int result;
        //call method in StoreSCU object to process sending of object.
        try{
        	result = storeSCU.sendObject(dds);
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
    public void closeStoreAssociation()
            throws AssociationAbortException {
        
        try{
        	storeSCU.closeStoreAssociation();
        }
        catch(DicomAssociationAbortException abort){
            logger.error(abort.getMessage());
            logger.error("{}: \nException thrown while closing Association.", this.getClass().getName());
            throw new AssociationAbortException();
        }
    }

	public synchronized IDicomStoreSCU getStoreSCU() {
			return storeSCU;
	}

	public synchronized void setStoreSCU(IDicomStoreSCU storeSCU) {
			this.storeSCU = storeSCU;
	}

	
}