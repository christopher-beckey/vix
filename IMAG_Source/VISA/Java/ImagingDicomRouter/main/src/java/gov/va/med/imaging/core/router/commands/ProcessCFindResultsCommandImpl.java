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

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.interfaces.IFindSCPResponseCallback;
import gov.va.med.imaging.dicom.common.spring.SpringContext;
import gov.va.med.imaging.dicom.dcftoolkit.common.utilities.DCFConstants;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.exchange.business.dicom.CFindResults;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomMap;

import java.util.HashSet;
import java.util.concurrent.LinkedBlockingQueue;

import gov.va.med.logging.Logger;

/**
 * This Router command control the creation and transmission of C-Find Results to the DICOM
 * device as C-Find Responses.
 * 
 * @author vhaiswpeterb
 *
 */
public class ProcessCFindResultsCommandImpl extends
		AbstractCommandImpl<Boolean> {

	private static final long serialVersionUID = -386257075558255964L;
    private static final int MAX_QUEUE_CAPACITY = 16;
    private CFindResults results = null;
    private DicomAE dicomAE;
    private HashSet<DicomMap> mappingSet = null;
    private IFindSCPResponseCallback cFindCallback = null;
    private LinkedBlockingQueue<IDicomDataSet> responseQueue = null;
    
    private IDicomDataSet LASTBAG = null;

	private Logger logger = Logger.getLogger(ProcessCFindResultsCommandImpl.class);

	public ProcessCFindResultsCommandImpl(CFindResults results, DicomAE dicomAE, 
				IFindSCPResponseCallback cFindCallback) {
		this.results = results;
		this.dicomAE = dicomAE;
		this.mappingSet = results.getRequestMappingSet();
		this.cFindCallback = cFindCallback;
		LASTBAG = (IDicomDataSet)SpringContext.getContext().getBean("DicomDataSet");
	}

	@Override
	public Boolean callSynchronouslyInTransactionContext()
					throws MethodException, ConnectionException {
        
		this.responseQueue = new LinkedBlockingQueue<IDicomDataSet>(MAX_QUEUE_CAPACITY);
        InternalDicomRouter router = InternalDicomContext.getRouter();
       
        router.postCFindResults(this.results, this.dicomAE, this.mappingSet, responseQueue, LASTBAG);
		
        //Perform the sending from this router command.
        int objectResultStatus = 0;
        int simpleCounter = 1;
        boolean loopDone = false;

        logger.info("{}: Dicom Toolkit layer: ...returning C-Find Responses to C-Find SCU.", this.getClass().getName());
        try{
	        //while loop.
	        while (!loopDone){
	            IDicomDataSet ddsImpl;
	       
	            //The response list should be a collection of DicomDataSet objects.
	            //Get the next dicomdataset object from the collection.
	            
	            ddsImpl = this.responseQueue.take();
	            if(ddsImpl == LASTBAG){
	            	//this.responseQueue.put(ddsImpl);
	            	loopDone = true;
	            }
	            else{
	                //Send the DicomDataSet object to the SCU via 
	                //the DicomDataServiceListener.
	            
	                objectResultStatus = this.cFindCallback.cFindResponseResult(DCFConstants.DIMSE_STATUS_PENDING, ddsImpl);
	                if(logger.isDebugEnabled()){
                        logger.debug("The returned Status from the Association Handler is: {}", objectResultStatus);}
                    logger.info("C-Find Response Number: {}", simpleCounter);
	                simpleCounter++;            
	            
	                if(objectResultStatus == DCFConstants.DIMSE_STATUS_CANCEL){
	                    //send a Cancelled Dimse Message to SCU.
	                    logger.info("...Object Result Status is CANCEL.");
	                    logger.warn("Received C-Find-Cancel from SCU.");
                        logger.warn("{}: Dicom Toolkit Layer: Cancel sending C-Find Responses.", this.getClass().getName());
	                    this.cFindCallback.cFindResponseComplete(DCFConstants.DIMSE_STATUS_CANCEL, null);
	                    return true;
	                }
	        
	                if(objectResultStatus != DCFConstants.DIMSE_STATUS_SUCCESS){
	                    logger.info("...Object Result Status is ERROR.");
	                    //REMINDER Commented this method at one time.  I believe when I throw an exception to the DCF
	                    //Toolkit, the Toolkit itself handles the release of the association.
	                    //I'm putting it back into play because other exceptions calls this method.
	                    this.cFindCallback.cFindResponseComplete(DCFConstants.DIMSE_STATUS_OUT_OF_RESOURCES, null);
	                    return true;
	                }
	            }
	            //not sure if I have to null dds before reassigning to new reference.
	            //ddsImpl = null;
	        }
        }
        catch(InterruptedException iX){
            logger.error("{}: Exception thrown during C-Find Responses.", this.getClass().getName());
            this.cFindCallback.cFindResponseComplete(DCFConstants.DIMSE_STATUS_OUT_OF_RESOURCES, null);
            throw new MethodException("Exception thrown during C-Find Responses.");                                	
        }

        logger.info("Returning CFind Complete Response.");
        this.cFindCallback.cFindResponseComplete(DCFConstants.DIMSE_STATUS_SUCCESS, null);        
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
}