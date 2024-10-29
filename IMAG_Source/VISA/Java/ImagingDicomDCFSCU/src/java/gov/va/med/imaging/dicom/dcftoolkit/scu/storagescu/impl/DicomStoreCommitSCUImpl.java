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
package gov.va.med.imaging.dicom.dcftoolkit.scu.storagescu.impl;

import gov.va.med.imaging.dicom.common.Constants;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationAbortException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationGeneralException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationRejectException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.exceptions.DicomStoreSCUConfigurationException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.exceptions.DicomStoreSCUInitializationException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.exceptions.DicomStoreSCUInstanceException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.storagescu.interfaces.IDicomStoreCommitSCU;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitElement;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import gov.va.med.logging.Logger;

import com.lbs.APC.AppControl;
import com.lbs.APC_a.AppControl_a;
import com.lbs.CDS.CFGAttribute;
import com.lbs.CDS.CFGGroup;
import com.lbs.CDS.NotFoundException;
import com.lbs.CDS_a.CFGDB_a;
import com.lbs.DCS.AcceptedPresentationContext;
import com.lbs.DCS.AssociationAbortedException;
import com.lbs.DCS.AssociationInfo;
import com.lbs.DCS.AssociationRejectedException;
import com.lbs.DCS.AssociationRequester;
import com.lbs.DCS.AttributeTag;
import com.lbs.DCS.DCM;
import com.lbs.DCS.DCSException;
import com.lbs.DCS.DicomAEElement;
import com.lbs.DCS.DicomASElement;
import com.lbs.DCS.DicomATElement;
import com.lbs.DCS.DicomCSElement;
import com.lbs.DCS.DicomDAElement;
import com.lbs.DCS.DicomDSElement;
import com.lbs.DCS.DicomDTElement;
import com.lbs.DCS.DicomDataSet;
import com.lbs.DCS.DicomElement;
import com.lbs.DCS.DicomFDElement;
import com.lbs.DCS.DicomFLElement;
import com.lbs.DCS.DicomISElement;
import com.lbs.DCS.DicomLOElement;
import com.lbs.DCS.DicomLTElement;
import com.lbs.DCS.DicomOBElement;
import com.lbs.DCS.DicomOFElement;
import com.lbs.DCS.DicomOWElement;
import com.lbs.DCS.DicomPNElement;
import com.lbs.DCS.DicomSHElement;
import com.lbs.DCS.DicomSLElement;
import com.lbs.DCS.DicomSQElement;
import com.lbs.DCS.DicomSSElement;
import com.lbs.DCS.DicomSTElement;
import com.lbs.DCS.DicomSessionSettings;
import com.lbs.DCS.DicomTMElement;
import com.lbs.DCS.DicomUIElement;
import com.lbs.DCS.DicomULElement;
import com.lbs.DCS.DicomUNElement;
import com.lbs.DCS.DicomUSElement;
import com.lbs.DCS.DicomUTElement;
import com.lbs.DCS.DimseMessage;
import com.lbs.DCS.DimseStatus;
import com.lbs.DCS.IOTimeoutException;
import com.lbs.DCS.NoDataException;
import com.lbs.DCS.RequestedPresentationContext;
import com.lbs.DCS.UID;
import com.lbs.DCS.VRValidator;
import com.lbs.DCS.ValidationErrorList;
import com.lbs.DCS.VerificationSCU;
import com.lbs.DDS.DDSException;
import com.lbs.DDS.DicomDataService;
import com.lbs.DSS.StoreCommitSCU;
import com.lbs.LOG_a.LOGClient_a;

import com.lbs.DSS.FailedSopSequence;
import com.lbs.DSS.FailureReason;
import com.lbs.DSS.ReferencedSopSequence;
import com.lbs.DSS.StoreCommitRequest;
import com.lbs.DSS.StoreCommitResult;

/**
 *
 * Implements the DicomStoreCommitSCU Interface. This implementation directly calls the DCF Toolkit.
 *
 * @author Csaba Titton
 *
 */
public class DicomStoreCommitSCUImpl extends AssociationRequester implements IDicomStoreCommitSCU {

	private static int sendTimeoutSeconds = 30;		// for sending N-EVENT-REPORT 
	private static int receiveTimeoutSeconds = 30;	// for sending N-EVENT-REPORT 
    private int pduTimeout_ = 300;

	/*
     * Create in case of arguments from a main().
     */
    private String args[];
    
    /*
     * Create the AssociationInfo instance.  This contains all information relating to 
     * the Association.
     */
    private AssociationInfo ainfo;
    
    /*
     * This is DCFToolkit specific.  This helps with session settings.
     */
    private DicomSessionSettings session;
    
    /*
     * DCF Toolkit specific instance.
     */
    private StoreCommitSCU scScu;
        
    /*
     * Create a Table to track the accepted Presentation Context IDs.
     */
    private Hashtable<Integer, AcceptedPresentationContext> acceptedContexts_map;
        
	private Logger logger = Logger.getLogger(this.getClass());
//	private DicomSessionSettings session_settings_ = null;


    /**
     * Constructor
     */
    public DicomStoreCommitSCUImpl() throws DCSException{
        super();
    }
    
    public DicomStoreCommitSCUImpl(String[] args) throws DCSException{
        this.args = args;
        try {
			setup();
		} 
        catch (DicomStoreSCUInitializationException dsscuiX) {
        	throw new DCSException("Failed to initialize N-EVENT_REPORT SCU.");
		}
    }

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.dcftoolkit.storagescu.interfaces.IDicomStoreSCU#openStoreAssociation(java.lang.String, gov.va.med.imaging.dicom.dcftoolkit.StoreSCPInfo)
     */
    public void openStoreCommitAssociation(DicomAE remoteAE, String scuAETitle)
            throws DicomAssociationRejectException, DicomAssociationGeneralException {
        
        logger.info("Starting the Association for N-EVENT-REPORT...");
        
        try{
            //Build DicomSessionSettings object.
            this.buildDicomSessionSettings();

            //Initialize ainfo instance variable.
            this.ainfo = new AssociationInfo();
            //Build AssociationInfo object.
            this.buildNERAssociationInfo(scuAETitle, remoteAE);

            //Initialize StoreCommitSCU object.
            scScu = new StoreCommitSCU(this.ainfo, this.session);
            //Request Association with SCP.
            scScu.requestAssociation();
            scScu.setConnected(true); // connected(true);
            //Build acceptedAssociationContext list.
            this.buildAcceptedPresentationContextList();
            logger.info("... successfully established Association for Store Commit Responder to {} on TCP/Port: {}/{}", scuAETitle, remoteAE.getHostName(), remoteAE.getPort());

        }
        catch(DicomStoreSCUConfigurationException configError){
            logger.error(configError.getMessage());
            logger.error("{}: Exception thrown while opening Store Commit N-EVENT-REPORT Association.", this.getClass().getName());
            throw new DicomAssociationGeneralException("Failure to open Association for Store Commit N-EVENT-REPORT.", configError);
        }
        catch(DCSException dcse){
            logger.error(dcse.getMessage());
            logger.error("{}: Exception thrown while opening Association for Store Commit N-EVENT-REPORT.", this.getClass().getName());
            throw new DicomAssociationGeneralException("Failure to open Association.", dcse);
        }
    }

    
    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.dcftoolkit.storagescu.interfaces.IDicomStoreSCU#sendObject(java.lang.String)
     */
    public int sendNERResponse(DicomAE remoteAE, StorageCommitWorkItem scWI)
            throws DicomStoreSCUInstanceException, DicomAssociationAbortException {
        
        int responseStatus = 0;
        logger.info(": Dicom Toolkit Layer: ...sending DICOM N-EVENT-REPORT ...");
                
//        try{
//            logger.info(": ... across network ...");
            int context_id = 1;
            AcceptedPresentationContext usedPresentationContext;
            usedPresentationContext = this.getSpecificAcceptedPresentationContext(context_id);
            
            //wait & get the status from the returned DimseMessage object.
            responseStatus = buildAndSendCommitResponse(remoteAE, scWI);

            switch(responseStatus){
            
            case (DimseStatus.DIMSE_SUCCESS):
                logger.info("... Sent DICOM N-EVENT-REPORT via Presentation Context = {} [SOP Class = {}; Transfer Syntax = {}].", context_id, usedPresentationContext.abstractSyntax(), usedPresentationContext.transferSyntax());
                logger.debug("N-EVENT-REPORT_RSP DIMSE Status is Success.");
            	return Constants.SUCCESS;
            default:
                logger.debug("N-EVENT-REPORT_RSP DIMSE Status is Rejected.");
                return Constants.REJECT;
            }
//        }
//        catch(AssociationAbortedException aaX){
//            logger.error(aaX.getMessage());
//            logger.error(this.getClass().getName()+": " +
//                    "Exception thrown while sending an N-Event-Report.\n"+
//                    "Association was aborted.");
//            logger.error("Trace: ", aaX);
//            throw new DicomAssociationAbortException("Association was aborted.", aaX); 	
//        }
//        catch(AssociationRejectedException arX){
//            logger.error(arX.getMessage());
//            logger.error(this.getClass().getName()+": " +
//                    "Exception thrown while sending an N-Event-Report.\n"+
//                    "Association was released.");
//            throw new DicomAssociationAbortException("Association was released.", arX);
//        }
//        catch(NoDataException ndX){
//            logger.error(ndX.getMessage());
//            logger.error(this.getClass().getName()+": " +
//                    "Exception thrown while sending an N-Event-Report.\n"+
//                    "Non-Data PDU was received.  Likely Association was released or aborted.");
//            throw new DicomAssociationAbortException("Non-Data PDU was received.", ndX);
//        }
//        catch(IOTimeoutException iotoX){
//            logger.error(iotoX.getMessage());
//            logger.error(this.getClass().getName()+": " +
//                    "Exception thrown while sending an N-Event-Report.\n"+
//                    "IO Timeout occurred.");
//            if(scScu.getConnected()){
//            	throw new DicomStoreSCUInstanceException("Failure to send N-EVENT-REPORT.");
//            }
//            throw new DicomAssociationAbortException("Timeout occurred.", iotoX);
//        }
//        catch(DCSException dcs){
//            logger.error(dcs.getMessage());
//            logger.error(this.getClass().getName()+": " +
//                    "Exception thrown while sending an Object.");
//            if(scScu.getConnected()){
//            	throw new DicomStoreSCUInstanceException("Failure to send Object.");
//            }
//            throw new DicomAssociationAbortException("Association is not established.", dcs);
//        }
    }
    
	private Integer buildAndSendCommitResponse (DicomAE remoteAE, StorageCommitWorkItem scWI)
	{
		try
			{ 
				StoreCommitResult result = new StoreCommitResult();
				int event_type_id = -1;
		
				// Compose the Storage Commitment N-EVENT-REPORT
				event_type_id = createStoreCommitResult( scWI, result );
		
				DimseMessage n_event_report_req = new DimseMessage();
				n_event_report_req.data( result.data_set() );
				n_event_report_req.eventTypeId( event_type_id );
		
				n_event_report_req.commandField( DimseMessage.N_EVENT_REPORT_RQ );
				n_event_report_req.affectedSopclassUid( UID.SOPCLASSSTORECOMMITPUSHMODEL );
				n_event_report_req.affectedSopinstanceUid( UID.SOPINSTANCESTORAGECOMMITMENTPUSHMODEL );
				n_event_report_req.dataSetType( 0x0100 );
				n_event_report_req.context_id( 1 ); //There will only ever be one context id requested.
		
				// nERreporter.requestAssociation();

				// issue the N-EVENT-REPORT request (send the DIMSE message)
				nEventReportRq( n_event_report_req, sendTimeoutSeconds, receiveTimeoutSeconds );

				// nERreporter.releaseAssociation();
				
				return 0;
			}
			catch( Exception e )
			{
            	logger.error("Error during N-EVENT-REPORT send: ", e );
				return -2;
			}
		}

	
	    private int createStoreCommitResult( StorageCommitWorkItem scWI, StoreCommitResult result )
		throws DCSException
		{
			int event_type_id = 1;
		
			int sopSequenceCount = scWI.getStorageCommitElements().size();
			Vector <StorageCommitElement> successSopSequenceSCEVector = new Vector <StorageCommitElement> ();
			Vector <StorageCommitElement> failedSopSequenceSCEVector = new Vector <StorageCommitElement> ();
			Vector successSopSequenceVector = new Vector();
			Vector failedSopSequenceVector = new Vector();
		
			//Run through the list of Referenced SOP Sequences that were in the N-ACTION-RQ and build the content for the message.
			for( int i = 0; i<sopSequenceCount; i++ )
			{
				StorageCommitElement elem = scWI.getStorageCommitElements().get(i);		
				
				if (elem.getCommitStatus()=='C') {
					successSopSequenceSCEVector.add( elem );
				} else {
					failedSopSequenceSCEVector.add( elem );
					event_type_id = 2;
				}
			}
		
			int successSeqCount = successSopSequenceSCEVector.size();
			int failedSeqCount = failedSopSequenceSCEVector.size();

			if( successSeqCount > 0 )
			{
				for( int j = 0; j<successSeqCount; j++ ) {
					ReferencedSopSequence successSopSequenceItem = new ReferencedSopSequence();
					StorageCommitElement scE = successSopSequenceSCEVector.elementAt(j);
					successSopSequenceItem.referencedSopclassUid(scE.getSopClassUid());
					successSopSequenceItem.referencedSopinstanceUid(scE.getSopInstanceUID());
					successSopSequenceItem.dataset().insert(DCM.E_REFERENCED_SOPCLASS_UID, scE.getSopClassUid());
					successSopSequenceItem.dataset().insert(DCM.E_REFERENCED_SOPINSTANCE_UID, scE.getSopInstanceUID());
					successSopSequenceVector.add(successSopSequenceItem);
				}
				
				ReferencedSopSequence[] successSopSeq = new ReferencedSopSequence[successSeqCount];
				successSopSequenceVector.copyInto( successSopSeq );
				result.referencedSopSequence( successSopSeq );
			}
		
			if( failedSeqCount > 0 )
			{
				for( int j = 0; j<failedSeqCount; j++ ) {
					FailedSopSequence failedSopSequenceItem = new FailedSopSequence();
					StorageCommitElement scE = failedSopSequenceSCEVector.elementAt(j);
					failedSopSequenceItem.referencedSopclassUid(scE.getSopClassUid());
					failedSopSequenceItem.referencedSopinstanceUid(scE.getSopInstanceUID());
					int failureCode=0;
					switch (scE.getFailureReason()) {
						case 'N': failureCode= 0x0112; // no such object instance /not in our DB/
						case 'R': failureCode= 0x0213; // Resource limitation /No archive done yet/
						case 'D': failureCode= 0x0210; // duplicate invocation /of the same SOP Instance UID in SC request/
						case 'P': failureCode= 0x0110; // Processing failure /software issue/
						default: failureCode= 0x0110;  // Processing failure
						// Note: when an item is not committed just because of not being archived yet by the BP or the 
						// Archiver process (failureCode='U' will rightfully fall in the default case (Processing Error=0x0110),
						// as DICOM does not define the "Not Done Yet" case specifically.
					}
					failedSopSequenceItem.failureReason(failureCode);
					failedSopSequenceItem.dataset().insert(DCM.E_REFERENCED_SOPCLASS_UID, scE.getSopClassUid());
					failedSopSequenceItem.dataset().insert(DCM.E_REFERENCED_SOPINSTANCE_UID, scE.getSopInstanceUID());
					failedSopSequenceVector.add(failedSopSequenceItem);
				}
				FailedSopSequence[] failedSopSeq = new FailedSopSequence[failedSeqCount];
				failedSopSequenceVector.copyInto( failedSopSeq );
				result.failedSopSequence( failedSopSeq );
			}
		
			//Set the transaction UID and optionally the move AE in the result
			try
			{
				result.transactionUid( scWI.getTransactionUID());
				if (!scWI.getMoveAE().isEmpty())
					result.retrieveAeTitle(new String[] {scWI.getMoveAE()});
			}
			catch( DCSException e )
			{
				logger.debug("No transaction UID in Store Commit N-EVENT-REPORT response" );
				result.transactionUid( null );
			}
		
			//return the event type id 1 for all successes, 2 for 1 or more failures
			return event_type_id;
		}

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.dcftoolkit.storagescu.interfaces.IDicomStoreSCU#closeStoreAssociation(int)
     */
    public void closeStoreCommitAssociation() throws DicomAssociationAbortException {
	
        logger.info(": ... Closing Association for Store Commit N-EVENT-REPORT.");
        try{
        	if(scScu.getConnected()){
        		//Terminate the Association.
        		scScu.releaseAssociation();
        	}    
        }
        catch(DCSException dcs){
            //If exception from releasing the connection,
        	//	issue an Abort.  If Abort, notify downstream.
            logger.error(dcs.getMessage());
            logger.error("Exception thrown while closing Association for Store Commit N-EVENT-REPORT.");
            scScu.abortAssociation();
            throw new DicomAssociationAbortException("Problem when closing Association.", dcs);
        }
    }
   
    
    public boolean VerifyAssociation(String callingAETitle, String calledAETitle, String addr)
    throws DicomAssociationRejectException{

		//FUTURE Clean this up to accept the same arguments as the openAssociation method.
		boolean test = false;
		try{
			VerificationSCU checkSCU = new VerificationSCU(callingAETitle, calledAETitle, addr);
			
			checkSCU.requestAssociation();
			logger.info("Successfully requested an Association with SCP.");
			checkSCU.cEcho(60);
			logger.info("Successfully received a C-ECHO-RSP.");
			checkSCU.releaseAssociation();
			logger.info("Successfully release the Association.");
			test = true;
		}
		catch(DCSException dcse){
			test = false;
			logger.error(dcse.getMessage());
			logger.error("Exception thrown while verifying Store Commit N-EVENT-REPORT Association.");
			throw new DicomAssociationRejectException("Failure verifying Store Commit N-EVENT-REPORT Association.", dcse);
		}
			return test;
	}


    
    private void setup()throws DicomStoreSCUInitializationException{ 
                    
        //Go through standard DCF Initialization process.
        logger.info("Starting Setup method for Store Commit N-EVENT-REPORT ...");
        try
        {
            AppControl_a.setupORB( args );
            CFGDB_a.setFSysMode( true );
            CFGDB_a.setup( args );
            AppControl_a.setup( args, CINFO.instance() );
            LOGClient_a.setConsoleMode( true );
            LOGClient_a.setup( args );   
        }
        catch( Exception e )
        {
            if (AppControl.isInitialized())
                AppControl.instance().shutdown( 0 );
            
            throw new DicomStoreSCUInitializationException(
                    "Failure to initialize SCU Dicom Toolkit.", e);
        }
     }
    
    /**
     * Build the session settings for this Association.
     * @throws DicomStoreSCUConfigurationException
     */
    private void buildDicomSessionSettings() throws DicomStoreSCUConfigurationException{
        
        try{
            //Get the DicomSessionSettings object from Config file.
            //Assign it to its instance variable.
            //      "The group "java_lib/DCS/default_session_cfg" from the current process 
            //      configuration is used to initialize the object".
            session = new DicomSessionSettings();
        }
        catch(DCSException dcs){
            logger.error(dcs.getMessage());
            logger.error("Exception thrown while building Dicom Session Settings.");
            throw new DicomStoreSCUConfigurationException(
                    "Failure to build Dicom Session Settings.");
        }
    }
    
    /**
     * Build the Association and the Requested Presentation Context list for an N-EVENT-REPORT.
     * 
     * @param scuAET represents the calling AETitle.
     * @param remoteAE represents info needed to establish a physical connection to the requesting Storage Commit SCU.
     * @throws DicomStoreSCUConfigurationException
     */
    private void buildNERAssociationInfo(String scuAET, DicomAE remoteAE) throws DicomStoreSCUConfigurationException{
        
        Vector<RequestedPresentationContext> pcIDs;
        RequestedPresentationContext ctx;
        String classUID_;
        String versionName_;
        
        this.ainfo.callingTitle(scuAET);
        this.ainfo.calledTitle(remoteAE.getRemoteAETitle());
		//Get the info for the AE that sent the N-ACTION
		String called_host = remoteAE.getHostName();
		String called_port = remoteAE.getPort();
		ainfo.calledPresentationAddress( called_host + ":" + called_port );

		try {				
			//There will only ever be one context id requested.
			ctx = new RequestedPresentationContext(
				(byte)1, // the context id (odd #: 1..255)
				UID.SOPCLASSSTORECOMMITPUSHMODEL,
				new String[] { UID.TRANSFERLITTLEENDIAN, UID.TRANSFERLITTLEENDIANEXPLICIT },
				(byte[]) null,
				(short)0,  // SCU role negotiation if 0
				(short)1); // SCP role negotiation if 0
			ainfo.addRequestedPresentationContext( ctx );
		} 
		catch (DCSException de) {
            logger.error(de.getMessage());
            logger.error("Exception thrown while creating Presentation Context List.");
            throw new DicomStoreSCUConfigurationException(
                    "Failure to create Presentation Context List.", de);
		}
        classUID_ = DicomServerConfiguration.getConfiguration().getImplementationClassUID();
        versionName_ = DicomServerConfiguration.getConfiguration().getImplementationVersionName();
        this.pduTimeout_ = DicomServerConfiguration.getConfiguration().getPduTimeout();
        
        this.ainfo.callingImplementationClassUid(classUID_);
        this.ainfo.callingImplementationVersionName(versionName_);
        this.ainfo.setRequesterMode(true);
        
        //Build the Requested Presentation Context list.
        pcIDs = new Vector<RequestedPresentationContext>();
        pcIDs.add(ctx);
        logger.debug(pcIDs.toString());
        this.ainfo.requestedPresentationContextList(pcIDs);
        logger.debug("N-EVENT-REPORT Association Info: Class UID = {};  Version: {}; PDU Timeout: {}", classUID_, versionName_, this.pduTimeout_);
    }
            
    /**
     * Build a collection of accepted Presentation Context IDs returned from the 
     * C-Store SCP during the establishing of the Association.
     * 
     * @throws DCSException
     */
    private void buildAcceptedPresentationContextList()
        throws DCSException
    {
        acceptedContexts_map = new Hashtable<Integer, AcceptedPresentationContext>();


        //NOTE Compile warning about Generic Collection.  Cannot correct due to DCF Toolkit.
        Vector<AcceptedPresentationContext> accepted_ctx_list = 
        			(Vector<AcceptedPresentationContext>)this.ainfo.acceptedPresentationContextList();

        for ( int i = 0; i < accepted_ctx_list.size(); i++ )
        {
            AcceptedPresentationContext ctx =
                (AcceptedPresentationContext)accepted_ctx_list.elementAt( i );
            Integer pcid = new Integer(ctx.id());
            acceptedContexts_map.put(pcid, ctx);
        }
    }

    private AcceptedPresentationContext getSpecificAcceptedPresentationContext(int context_id){
        
        AcceptedPresentationContext ctx = null;
        ctx = acceptedContexts_map.get(context_id);
        
        return ctx;
    }

	/**
	* Called by requestAssociation().  Perform any actions
	* required by a specific SCU depending upon the Accepted
	* or Rejected Presentation Contexts.
	* The base class method does nothing.
	*/
//	@SuppressWarnings("unchecked")
    protected void checkAcceptedPresentationContext()
		throws DCSException
	{
//    	logger.debug("NEventReporter.checkAcceptedPresentationContext()");
//		ainfo_ = getAssociationInfo();
	
		Vector accepted_ctx_list = ainfo.acceptedPresentationContextList();
	
		//There should be exactly 1 accepted presentation context.
		if( accepted_ctx_list.size() != 1 )
		{
			return;
		}

		AcceptedPresentationContext ctx = (AcceptedPresentationContext) accepted_ctx_list.elementAt( 0 );
        logger.debug("NEventReport checkAcceptedPresentationContext context: {}, {}", ctx.abstractSyntax(), ctx.id());
	}


    public DimseMessage nEventReportRq(DimseMessage n_event_report_req, int send_timeout_seconds, int receive_timeout_seconds )
		throws DCSException
	{
		String newline = System.getProperty( "line.separator" );

        logger.debug("n_event_report_req = {}{}{}send_timeout_seconds = {}{}receive_timeout_seconds = {}", newline, n_event_report_req.toString(), newline, send_timeout_seconds, newline, receive_timeout_seconds);

		if ( !scScu.getConnected() ){
			throw new DCSException("invalid SC response (NEventReportRq) state: not connected");
		}
		
		scScu.sendDimseMessage(n_event_report_req, send_timeout_seconds);
	
		// read response.....
		DimseMessage rsp = scScu.receiveDimseMessage((short) 1, receive_timeout_seconds);

        logger.debug("received NEventReport response message: {}{}", newline, rsp.toString());

		return rsp;
	}

}
