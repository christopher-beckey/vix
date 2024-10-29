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
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.common.spring.SpringContext;
import gov.va.med.imaging.dicom.dcftoolkit.common.mapping.BusinessObjectToDicomTranslator;
import gov.va.med.imaging.exchange.business.dicom.CFindResults;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomMap;
import gov.va.med.imaging.exchange.business.dicom.exceptions.DicomException;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ValidateVRException;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Locale;
import java.util.concurrent.LinkedBlockingQueue;

import gov.va.med.logging.Logger;

/**
 * This Router commmand takes the C-Find Results and builds a VI DICOM Dataset for each
 * result and are collected into a Queue for later processing.
 * 
 * @author vhaiswpeterb
 *
 */
@RouterCommandExecution(asynchronous = true, distributable = false)
public class PostCFindResultsCommandImpl
extends AbstractDicomCommandImpl<Void>{

    private static final long serialVersionUID = 4923784727343L;
	private Logger logger = Logger.getLogger(PostCFindResultsCommandImpl.class);
    private CFindResults results = null;
    private DicomAE dicomAE = null;
    private HashSet<DicomMap> mappingSet = null;
    private LinkedBlockingQueue<IDicomDataSet> responseQueue = null;
    private ArrayList<String> studyUIDs = null;
    private IDicomDataSet LASTBAG;

    
	public PostCFindResultsCommandImpl(CFindResults results, DicomAE dicomAE, HashSet<DicomMap> mappingSet, 
						LinkedBlockingQueue<IDicomDataSet> queue, IDicomDataSet lastBag) {
		this.results = results;
		this.dicomAE = dicomAE;
		this.mappingSet = mappingSet;
		this.responseQueue = queue;
		this.LASTBAG = lastBag;
        this.studyUIDs = new ArrayList<String>();
	}

	@Override
	public Void callSynchronouslyInTransactionContext()
			throws MethodException, ConnectionException {

	    int rowNumber = 0;
        int totalResults = 0;
        String moveSCPAETitle = null;
        try{    
    		IDicomDataSet responseDDS = null;
    		
            moveSCPAETitle = this.dicomAE.getLocalAETitle();
                		
        	//The following two lines are for informational purposes only.
            this.results.last();
            totalResults = this.results.getRow();
            if(logger.isDebugEnabled()){
                logger.debug("Number of CFind results from Data Source: {}", totalResults);}
                        
            this.results.beforeFirst();
            this.results.setFetchDirection(ResultSet.FETCH_FORWARD);
            this.results.setFetchSize(1);
            
            while(this.results.next()){
        		rowNumber = this.results.getRow();
                logger.info("{}: Converting CFind result row {} to a Dicom Dataset.", this.getClass().getName(), rowNumber);
        		responseDDS = (IDicomDataSet)SpringContext.getContext().getBean("DicomDataSet");
        		BusinessObjectToDicomTranslator.getResponseDataSetFromRow(this.results, rowNumber, this.mappingSet,
                        responseDDS, moveSCPAETitle);
       		
                try {
        			this.checkDDS(responseDDS);

        			this.responseQueue.put(responseDDS);
				} 
                catch (ValidateVRException validateX){
                    logger.error(validateX.getMessage());
                    logger.error("{}: Exception thrown validating Query Response.", this.getClass().getName());
                    logger.error("C-Find Response failed message validation.  The result is all C-Find Responses may not have been sent to the C-Find SCU.\n" +
            		"Refer to other logs for more detail.");
                }
                catch (InterruptedException iX) {
                	logger.error(iX.getMessage());
                    logger.error("{}: Exception thrown putting CFind Response into Queue.", this.getClass().getName());
                    logger.error("C-Find Response failed to be added to the Response Queue.  The result is all C-Find Responses may not have been sent to the C-Find SCU.\n" +
            		"Refer to other logs for more detail.");

				}
            }
            try{
                this.responseQueue.put(this.LASTBAG);
            }
            catch(InterruptedException iX){
            	//ignore
            }
        }           
        catch (SQLException sqle){
            logger.error(sqle.getMessage());
            logger.error("{}: Exception thrown while converting row {} to CFind Response.", this.getClass().getName(), rowNumber);
            logger.error("Failed to convert C-Find Response to a DICOM message.  The result is all C-Find Responses may not have been sent.\n" +
    		"Refer to other logs for more detail.");

            try{
                this.responseQueue.put(this.LASTBAG);
            }
            catch(InterruptedException iX){
            	//ignore
            }
            throw new MethodException();
        }   
        return null;
	}
		

	@Override
	public boolean equals(Object obj) {
		return false;
	}

	@Override
	protected String parameterToString() {
		return "";
	}	
	
	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}

	
    private void checkDDS(IDicomDataSet dds) throws ValidateVRException{
    	
    	try{
    		if(dds.containsDicomElement("0020,000D", null)){
    			String uid = dds.getStudyInstanceUID();
    
    			if(uid == null || uid.equals("")){
    				throw new ValidateVRException("Missing Study Instance UID.");
    			}
    		
    			if(this.studyUIDs.contains(uid)){
    				throw new ValidateVRException("Duplicate Study Instance UID.");
    			}
    			this.studyUIDs.add(uid);
    		}
    		
    		if(dds.containsDicomElement("0008,0052", null)){
    			String level = dds.getQueryRetrieveLevel();
    			//FUTURE Check against the C-Find-Rq Level.
    			if((level == null) || ((!level.toUpperCase(Locale.ENGLISH).equals("STUDY")))){
    				throw new ValidateVRException("Wrong Level");
    			}
    		}
    		else{
    			throw new ValidateVRException("Level attribute does not exist.");
    		}
    		
    		if(dds.containsDicomElement("0008,0054", null)){
    			String destination = dds.getDicomElement("0008,0054").getStringValue();
    			if(destination == null || destination.equals("")){
    				throw new ValidateVRException("Missing Retrieve AETitle,");
    			}
    		}
    		else{
    			throw new ValidateVRException("Retrieve AETitle Attribute does not exist.");
    		}
    	}
    	catch(DicomException dcsX){
            logger.error(dcsX.getMessage());
            logger.error("{}: Exception thrown while checking validation.", this.getClass().getName());
    		throw new ValidateVRException(dcsX.getMessage());
    	}
    	
    }	
}
