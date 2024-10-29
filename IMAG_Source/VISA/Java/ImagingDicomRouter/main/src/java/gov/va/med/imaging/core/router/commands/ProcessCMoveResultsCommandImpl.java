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
import gov.va.med.imaging.dicom.DicomContext;
import gov.va.med.imaging.exchange.business.EmailMessage;
import gov.va.med.imaging.exchange.business.dicom.CMoveResults;
import gov.va.med.imaging.exchange.business.dicom.DicomInstanceSet;
import gov.va.med.imaging.exchange.business.dicom.DicomRequestParameters;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.MoveCommandObserver;

import java.util.Observer;

import gov.va.med.logging.Logger;

/**
 * This Router command controls the process of handling C-Move Requests.  It gets the CMove Results
 * and convert the results into a list of DICOM Instances to retrieve.  This preps for all necessary 
 * data to call another Router command to send DICOM Instances to a DICOM device.
 * 
 * @author vhaiswpeterb
 *
 */
public class ProcessCMoveResultsCommandImpl extends AbstractDicomCommandImpl<MoveCommandObserver>
{
	private static final long serialVersionUID = 8734783841937709817L;
    private static Logger logger = Logger.getLogger(ProcessCMoveResultsCommandImpl.class);

	private String storeAETitle;
	private DicomRequestParameters requestParameters;
	private Observer scpListener;

	public ProcessCMoveResultsCommandImpl(String storeAETitle, DicomRequestParameters requestParameters, Observer scpListener)
	{
		this.storeAETitle = storeAETitle;
		this.requestParameters = requestParameters;
		this.scpListener = scpListener;
	}

	@Override
	public MoveCommandObserver callSynchronouslyInTransactionContext() throws MethodException, ConnectionException
	{
		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router Command {}", Thread.currentThread().getId(), this.getClass().getName());}
				
		//Get the CMoveResults from data source.  This is basically an image list for a single 
		//	study wrapped in a HashSet collection object.
		CMoveResults moveResults = DicomContext.getRouter().getCMoveResults(this.requestParameters);
		
		//IF the result contains a duplicate, send email notification.
		if(moveResults.isDuplicateStudyInstanceUID()){
	    	// post email to queue
	        String emailRecepient = DicomServerConfiguration.getConfiguration().getDgwEmailInfo().getEMailAddress();
	        String[] eMailTOs=new String[1];
	        eMailTOs[0] = emailRecepient;
	        String threadID = " [" + Long.toString(Thread.currentThread().getId()) + "]";
	        String uid = this.requestParameters.get("0020,000D");
	        String subject = "Error: Duplicate Study Instance UID";
	        String body = this.storeAETitle + " -> " + "Duplicate Study Instance UID found in VistA Imaging Database.\n" +
									"Study Instance UID: " + uid;
	        EmailMessage email = new EmailMessage(eMailTOs, subject, body);
	    	try { 
	    		DicomContext.getRouter().postToEmailQueue(email, this.storeAETitle + "/" +threadID);	// context

	    	} catch (MethodException me) {
                logger.error("Process error while queueing Email for 'Duplicate Study Instance UID{}' - {}/{}", uid, this.storeAETitle, threadID);
	        } catch (ConnectionException ce) {
                logger.error("DB Connection error while queueing Email for 'Duplicate Study Instance UID{}' - {}/{}", uid, this.storeAETitle, threadID);
	        }

			throw new MethodException("VistA Imaging contains Duplicate Study Instance UID: " + uid);
		}
		//Copy the CMoveResults to the DicomInstanceSet.  They are both HashSets of InstanceStorageInfo.
		DicomInstanceSet instances = new DicomInstanceSet();
		instances.addAll(moveResults);

		//Create MoveCommandObserver.  This is an observer for a CMove Cancel request that could happen anytime while
		//	sending images to a CStore SCP.
		MoveCommandObserver cancelMoveObserver = new MoveCommandObserver();
		
		//Send study images from VistA Imaging to the requested SCP.
		DicomContext.getRouter().postDicomInstanceSet(this.storeAETitle, instances, this.scpListener, cancelMoveObserver);
		
		//Return the MoveCommandObserver downstream.  This is used to listen for a CMove Cancel request.
		return cancelMoveObserver;
	}
	
	
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.requestParameters == null) ? 0 : this.requestParameters.hashCode());
		result = prime * result + ((this.storeAETitle== null) ? 0 : this.storeAETitle.hashCode());
		result = prime * result + ((this.scpListener == null) ? 0 : this.scpListener.hashCode());

		return result;
	}
	
	
	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}
	
	
    /**
	 * @return the requestParameters
	 */
	public DicomRequestParameters getRequestParameters() {
		return requestParameters;
	}

		
	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return null;
	}
	
	
	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}

	
}
