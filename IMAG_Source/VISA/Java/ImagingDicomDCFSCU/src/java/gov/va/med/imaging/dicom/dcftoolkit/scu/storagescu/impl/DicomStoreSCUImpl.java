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

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import gov.va.med.logging.Logger;

import com.lbs.CDS.CFGAttribute;
import com.lbs.CDS.NotFoundException;
import com.lbs.DCS.AcceptedPresentationContext;
import com.lbs.DCS.AssociationInfo;
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
import com.lbs.DCS.IOException;
import com.lbs.DCS.IOReadException;
import com.lbs.DCS.IOTimeoutException;
import com.lbs.DCS.IOWriteException;
import com.lbs.DCS.NoDataException;
import com.lbs.DCS.RequestedPresentationContext;
import com.lbs.DCS.StoreDimseStatus;
import com.lbs.DCS.UID;
import com.lbs.DCS.VRValidator;
import com.lbs.DCS.ValidationErrorList;
import com.lbs.DCS.VerificationSCU;

import gov.va.med.imaging.dicom.common.Constants;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationAbortException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationGeneralException;
import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationRejectException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.exceptions.DicomStoreSCUConfigurationException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.exceptions.DicomStoreSCUInstanceException;
import gov.va.med.imaging.dicom.dcftoolkit.scu.storagescu.interfaces.IDicomStoreSCU;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;


/**
 *
 * Implements the DicomStoreSCU Interface.  The Publisher for the Listener pattern is 
 * in this class.  This implementation directly calls the DCF Toolkit.
 *
 * @author William Peterson
 *
 */
public class DicomStoreSCUImpl implements IDicomStoreSCU {
    
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
    private SpecializedStoreSCU scu;
    
    private HashSet<String> objectsSOPClasses;
 
    /*
     * Create a Table to track the accepted Presentation Context IDs.
     */
    private Hashtable<Integer, AcceptedPresentationContext> acceptedContexts_map;
    
    private int pduTimeout = 60;
    
	private Logger logger = Logger.getLogger(DicomStoreSCUImpl.class);


    /**
     * Constructor
     */
    public DicomStoreSCUImpl() throws DCSException{
        super();
        ainfo = new AssociationInfo();
        session = new DicomSessionSettings();
        acceptedContexts_map = new Hashtable<Integer, AcceptedPresentationContext>();
    }

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.dcftoolkit.storagescu.interfaces.IDicomStoreSCU#openStoreAssociation(java.lang.String, gov.va.med.imaging.dicom.dcftoolkit.StoreSCPInfo)
     */
    @Override
    public void openStoreAssociation(String scuAETitle, DicomAE remoteAE)
            throws DicomAssociationRejectException, DicomAssociationGeneralException {
        
        logger.info("Starting a DICOM Association.");
        try{
        
            //Build DicomSessionSettings object.
            this.buildDicomSessionSettings();
            //Build AssociationInfo object.
            this.buildAssociationInfo(scuAETitle, remoteAE);
            //Initialize StoreSCU object.
            scu = new SpecializedStoreSCU(ainfo, session);
            //Request Association with SCP.
            scu.requestAssociation();
//            scu.setConnected(true); // connected(true);
            
            //FUTURE Determined the method below is not used.  The original purpose was to
            //  create a Presentation Context Map based on the SOP Class UID String.  Upon
            //  further study, it is not needed.  The Accepted Presentation Contexts are
            //  within the AssociationInfo object.  Additionally with the current code, the
            //  sendObject() method does not give the ability to explicitly select the desired
            //  Transfer Syntax.  If this needs to be explicitly selected, the sendObject() 
            //  method must call and control the DimseMessage class instead of the StoreSCU
            //  class.
            //Build acceptedAssociationContext list.
            this.buildAcceptedPresentationContextList();

        }
        catch(DicomStoreSCUConfigurationException configError){
            logger.error(configError.getMessage());
            logger.error("{}: Exception thrown while opening Association.", this.getClass().getName());
            throw new DicomAssociationGeneralException("Failure to open Association.", configError);
        }
        catch(DCSException dcse){
            logger.error(dcse.getMessage());
            logger.error("{}: Exception thrown while opening Association.", this.getClass().getName());
            throw new DicomAssociationGeneralException("Failure to open Association.", dcse);
        }
    }

    @Override
	public void openStoreAssociation(String scuAETitle, DicomAE remoteAE,
			HashSet<String> sopClassUIDs)
			throws DicomAssociationRejectException,
			DicomAssociationGeneralException {

        logger.info("Starting a DICOM Association.");
        try{
            this.objectsSOPClasses = sopClassUIDs;
            //Build DicomSessionSettings object.
            this.buildDicomSessionSettings();
            //Build AssociationInfo object.
            this.buildAssociationInfo(scuAETitle, remoteAE);
            //Initialize StoreSCU object.
            scu = new SpecializedStoreSCU(ainfo, session);
            //Request Association with SCP.
            scu.requestAssociation();
            //scu.setConnected(true); // connected(true);
            
            //FUTURE Determined the method below is not used.  The original purpose was to
            //  create a Presentation Context Map based on the SOP Class UID String.  Upon
            //  further study, it is not needed.  The Accepted Presentation Contexts are
            //  within the AssociationInfo object.  Additionally with the current code, the
            //  sendObject() method does not give the ability to explicitly select the desired
            //  Transfer Syntax.  If this needs to be explicitly selected, the sendObject() 
            //  method must call and control the DimseMessage class instead of the StoreSCU
            //  class.
            //Build acceptedAssociationContext list.
            this.buildAcceptedPresentationContextList();

        }
        catch(DicomStoreSCUConfigurationException dsscucX){
            logger.error(dsscucX.getMessage());
            logger.error("{}: Exception thrown while opening Association.", this.getClass().getName());
            throw new DicomAssociationGeneralException("Failure to open Association.", dsscucX);
        }
        catch(DCSException dcsX){
            logger.error(dcsX.getMessage());
            logger.error("{}: Exception thrown while opening Association.", this.getClass().getName());
            throw new DicomAssociationGeneralException("Failure to open Association.", dcsX);
        }
	}
    

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.dcftoolkit.storagescu.interfaces.IDicomStoreSCU#sendObject(java.io.InputStream)
     */
    @Override
    public void sendObject(InputStream dicomInstance)
            throws DicomStoreSCUInstanceException {

    	throw new DicomStoreSCUInstanceException("Not used in VISA.");
    }

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.dcftoolkit.storagescu.interfaces.IDicomStoreSCU#sendObject(java.lang.String)
     */
    @Override
    public int sendObject(IDicomDataSet dds)
            throws DicomStoreSCUInstanceException, DicomAssociationAbortException {
        
        DimseMessage cStoreRsp = null;
        AcceptedPresentationContext ctx = null;
        int responseStatus = 0;
        logger.info("{}: Dicom Toolkit Layer:...sending DICOM object.", this.getClass().getName());
        
        //This simply add Dashes to the Patient ID if configured.  I saved it for the end as
        //	not to get mixed with anything else in the log or VistA HIS.  This is strictly
        // 	for outgoing objects.
        dds.changeDataPresentation();
       
        if(!scu.getConnected()){
        	throw new DicomAssociationAbortException("Association is no longer established.");
        }
        try{
            //Retrieve the toolkit DicomDataSet from the generic DicomDataSet
            DicomDataSet unwrappedDDS = (DicomDataSet) dds.getDicomDataSet();
            
            String transferSyntax = dds.getReceivedTransferSyntax();
            String abstractSyntax = null;
            if(unwrappedDDS.containsElement(DCM.E_SOPCLASS_UID)){
                abstractSyntax = unwrappedDDS.getElementStringValue(DCM.E_SOPCLASS_UID).trim();  
            }
            else{
                logger.error("{}: DICOM Toolkit layer: No Abstract Syntax was found in the DicomDataSet.", this.getClass().getName());
                throw new DCSException("No Abstract Syntax in DICOM Dataset.");
            }
            ctx = this.determineBestAcceptedPresentationContext(abstractSyntax, transferSyntax);
            
            this.removeSelectedBadVRElements(unwrappedDDS);

            logger.debug("{} DICOM DataSet being sent to SCU:", this.getClass().getName());
            
            //Wrap the DicomDataSet into a CStore Dimse Message.  This can be done by
            // invoking the Cstore method in the StoreSCU object.
            logger.info("{}: ...sending across network.", this.getClass().getName());
            cStoreRsp = scu.cStore(unwrappedDDS, ctx, this.pduTimeout, this.pduTimeout);
            logger.info("{}: ...received response from network.", this.getClass().getName());
            
            logger.info("...Sent DICOM Object: ");
            logger.info("Object sent via Presentation Context: {}", ctx.getId());
            logger.info("Object sent via SOP Class: {}", ctx.getAbstractSyntax());
            logger.info("Object sent via Transfer Syntax: {}", ctx.getTransferSyntaxUID());

            if(cStoreRsp == null){
            	throw new NoDataException("CStore Response was null.");
            }

            //Read the status from the returned DimseMessage object.
            responseStatus = cStoreRsp.status();
            
            //Update the status object.
            switch(responseStatus){
            
            case (DimseStatus.DIMSE_SUCCESS):
                logger.info("C-Store-RSP Dimse Status is Success.");
            	return Constants.SUCCESS;
            case (StoreDimseStatus.COERCION_OF_DATA_ELEMENTS):
            case (StoreDimseStatus.DATA_SET_NOT_MATCH_SOP):
            case (StoreDimseStatus.ELEMENTS_DISCARDED):
                logger.info("C-Store-RSP Dimse Status is Warning.");
            	return Constants.WARNING;
            default:
                logger.info("C-Store-RSP Dimse Status is Rejected.");
                return Constants.REJECT;
            }
        }
        catch(NoDataException ndX){
            logger.error(ndX.getMessage());
            logger.error("{}: Exception thrown while sending an Object.\nNon-Data PDU was received.  Likely Association was released or aborted.", this.getClass().getName());
            // this.scu.setConnected(false);
            throw new DicomAssociationAbortException("Non-Data PDU was received.", ndX);
        }
        catch(IOReadException iorX){
            logger.error(iorX.getMessage());
            logger.error("{}: Exception thrown while sending an Object.\nNon-Data PDU was received.  Likely Association was released or aborted.", this.getClass().getName());
            // this.scu.setConnected(false);
            throw new DicomAssociationAbortException("Non-Data PDU was received.", iorX);
        }
        catch(IOWriteException iowX){
            logger.error(iowX.getMessage());
            logger.error("{}: Exception thrown while sending an Object.\nNon-Data PDU was received.  Likely Association was released or aborted.", this.getClass().getName());
            // this.scu.setConnected(false);
            throw new DicomAssociationAbortException("Non-Data PDU was received.", iowX);
        }
        catch(IOTimeoutException iotoX){
            logger.error(iotoX.getMessage());
            logger.error("{}: Exception thrown while sending an Object.\nIO Timeout occurred.", this.getClass().getName());
            // this.scu.setConnected(false);
            throw new DicomAssociationAbortException("Timeout occurred.", iotoX);
        }
        catch(IOException ioX){
            logger.error(ioX.getMessage());
            logger.error("{}: Exception thrown while sending an Object.\nNon-Data PDU was received.  Likely Association was released or aborted.", this.getClass().getName());
            // this.scu.setConnected(false);
            throw new DicomAssociationAbortException("Non-Data PDU was received.", ioX);
        }
        catch(DCSException dcs){
            logger.error(dcs.getMessage());
            logger.error("{}: Exception thrown while sending an Object.", this.getClass().getName());
            // this.scu.setConnected(false);
            throw new DicomAssociationAbortException("Association is no longer established.", dcs);
        }
    }
    

    /* (non-Javadoc)
     * @see gov.va.med.imaging.dicom.dcftoolkit.storagescu.interfaces.IDicomStoreSCU#closeStoreAssociation(int)
     */
    @Override
    public void closeStoreAssociation()
            throws DicomAssociationAbortException {

        logger.info("{}: Closing Association.", this.getClass().getName());
        try{
        	if(scu.getConnected()){
        		//Terminate the Association.
        		scu.releaseAssociation();
        		// this.scu.setConnected(false);
        	}    
        }
        catch(DCSException dcs){
            //If exception from releasing the connection,
        	//	issue an Abort.  If Abort, notify downstream.
            logger.error(dcs.getMessage());
            logger.error("{}: Exception thrown while closing Association.", this.getClass().getName());
            // TFS 63864 - replaced scu.abortAssociation() with scu.close()
            scu.close();
            throw new DicomAssociationAbortException("Problem when closing Association.", dcs);
        }
    }
    
    @Override
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
            logger.error("{}: Exception thrown while verifying Association.", this.getClass().getName());
			throw new DicomAssociationRejectException("Failure verifying Association.", dcse);
		}
			return test;
	}
    
    /**
     * Build the session settings for this Association.
     * @throws DicomStoreSCUConfigurationException
     */
    private void buildDicomSessionSettings() throws DicomStoreSCUConfigurationException{
        
            //Get the DicomSessionSettings object from Config file.
            //Assign it to its instance variable.
            //Found out from DCF Developers guide the following automatically pulls from the 
            // config file.
            //      "The group "java_lib/DCS/default_session_cfg" from the current process 
            //      configuration is used to initialize the object".
            //Extract supported_sop_classes CFGGroup from the DicomSessionSettings object.
           session.getSupportedSopClasses();
            //Extract supported_transfer_syntaxes CFGGroup from the DicomSessionSettings object.
           session.getSupportedTransferSyntaxes();
    }
    
    /**
     * Build the Association and the Requested Presentation Context list.
     * 
     * @param scuAET represents the calling AETitle.
     * @param scp represents info needed to establish a physical connection to the C-Store SCP.
     * @throws DicomStoreSCUConfigurationException
     */
    private void buildAssociationInfo(String scuAET, DicomAE remoteAE) throws DicomStoreSCUConfigurationException{
        
        Vector<RequestedPresentationContext> pcIDs;
        
        //Initialize instance variable.
        String classUID_;
        String versionName_;
        int pduTime_;
        
        ainfo.calledPresentationAddress(remoteAE.getHostName() + ":" + remoteAE.getPort());
        ainfo.callingTitle(scuAET);
        ainfo.calledTitle(remoteAE.getRemoteAETitle());
        
        classUID_ = DicomServerConfiguration.getConfiguration().getImplementationClassUID();
        versionName_ = DicomServerConfiguration.getConfiguration().getImplementationVersionName();
        pduTime_ = DicomServerConfiguration.getConfiguration().getPduTimeout();
        logger.debug("C-Store Association Info: Class UID: {}", classUID_);
        logger.debug("C-Store Association Info: Version: {}", versionName_);
        logger.debug("C-Store Association Info: PDU Timeout: {}", pduTime_);
        logger.info("Successfully read the Configuration file for Store SCU.");
        
        ainfo.callingImplementationClassUid(classUID_);
        ainfo.callingImplementationVersionName(versionName_);
        ainfo.callingMaxPDULength(pduTime_);
        ainfo.setRequesterMode(true);
        
        //Build the Requested Presentation Context list.
        pcIDs = this.buildPresentationContextList();
        logger.debug(pcIDs.toString());
        ainfo.requestedPresentationContextList(pcIDs);
    }
    
    /**
     * Build the Presentation Context ID List for the Association.  The list is based on
     * a external configuration file via the DCF Toolkit.  Each Presentation Context ID gets
     * a single Transfer Syntax.
     * 
     * @return represents a collection of the PCIDs.
     * @throws DicomStoreSCUConfigurationException
     */
    private Vector<RequestedPresentationContext> buildPresentationContextList()
            throws DicomStoreSCUConfigurationException{
        
        Vector<RequestedPresentationContext> idList = new Vector<RequestedPresentationContext>();
        CFGAttribute sopClassAttribute;
        CFGAttribute transferSyntaxAttribute;
        Object sopClassArray[];
        String transferSyntaxArray[];

        try{
        	if(this.objectsSOPClasses == null ||this.objectsSOPClasses.isEmpty()){
        		sopClassAttribute =  session.getSupportedSopClasses().getAttribute("sop_class");
        		sopClassArray = sopClassAttribute.getValues();
        	}
        	else{
        		if(!this.objectsSOPClasses.contains(UID.SOPCLASSSECONDARYCAPTURE)){
        			this.objectsSOPClasses.add(UID.SOPCLASSSECONDARYCAPTURE);
        		}
        		sopClassArray = this.objectsSOPClasses.toArray();
        	}
        
            transferSyntaxAttribute = session.getSupportedTransferSyntaxes().getAttribute("transfer_syntax");
            transferSyntaxArray = transferSyntaxAttribute.getValues();
            
            int pcid = 1;
            for(int sopClassCount=0; sopClassCount < sopClassArray.length; sopClassCount++){  
            	for(int tsCount=0; tsCount < transferSyntaxArray.length; tsCount++){
            		String[] singleTS = new String[1];
            		singleTS[0] = transferSyntaxArray[tsCount];
            		idList.add(new RequestedPresentationContext(pcid, 
            				(String)sopClassArray[sopClassCount], singleTS));
            		pcid +=2;
            	}
            }
            return idList;
        }
        catch(NotFoundException nfe){
            logger.error(nfe.getMessage());
            logger.error("{}: Exception thrown while creating Presentation Context List.", this.getClass().getName());
            throw new DicomStoreSCUConfigurationException(
                    "Failure to create Presentation Context List.", nfe);
        }
        catch(DCSException dcs){
            logger.error(dcs.getMessage());
            logger.error("{}: Exception thrown while creating Presentation Context List.", this.getClass().getName());
            throw new DicomStoreSCUConfigurationException(
                    "Failure to create Presentation Context List.", dcs);
        }
    }
    
    /**
     * Build a collection of accepted Presentation Contexts returned from the 
     * C-Store SCP during the establishing of the Association. The collection is put 
     * into a map object.  The key is the Presentation Context ID.
     * 
     * @throws DCSException
     */
    private void buildAcceptedPresentationContextList()
        throws DCSException
    {

        //INFO Compile warning about Generic Collection.  Cannot correct due to DCF Toolkit.
        @SuppressWarnings("unchecked")
		Vector<AcceptedPresentationContext> accepted_ctx_list = 
        			(Vector<AcceptedPresentationContext>)ainfo.acceptedPresentationContextList();

        for ( int i = 0; i < accepted_ctx_list.size(); i++ )
        {
            AcceptedPresentationContext ctx =
                (AcceptedPresentationContext)accepted_ctx_list.elementAt( i );
            Integer pcid = new Integer(ctx.id());
            acceptedContexts_map.put(pcid, ctx);
        }
    }

    
    /**
     * Determines the best accepted Presentation Context to use to send the object to the SCU.  The
     * general idea is to use the same transfer syntax that was used to store the object in VistA 
     * Imaging.  If this was not accepted by the SCU, then use the Implicit VR Little Endian 
     * transfer syntax.
     * 
     * @param abstractSyntax represents the abstract syntax of the object.
     * @param transferSyntax represents the transfer syntax of the object.
     * @return the best accepted Presentation Context to be used to send the object.
     * @throws DCSException
     */
    private AcceptedPresentationContext determineBestAcceptedPresentationContext(String abstractSyntax, String transferSyntax)
    					throws DCSException{
        
        AcceptedPresentationContext ctx = null;

        if(abstractSyntax == null || abstractSyntax.isEmpty()){
            logger.error("{} DICOM Toolkit layer: Cannot send image because Abstract Syntax does not exist.", this.getClass().getName());
            throw new DCSException("Abstract Syntax does not exist.");        	
        }
        if(transferSyntax == null || transferSyntax.isEmpty()){
        	//Set to Explicit VR Little Endian as a default when receiving a DICOM dataset
        	//	from Reconstitution.  This is because reconstituted DICOM dataset did not have
        	//	an assigned Transfer Syntax.  Picked Explicit VR as default because I like it
        	//	more than Implicit VR.
        	transferSyntax = UID.EXPLICIT_VR_LITTLE_ENDIAN;
        }
        abstractSyntax = abstractSyntax.trim();
        transferSyntax = transferSyntax.trim();
                
        if(this.isPresentationContextAccepted(abstractSyntax, transferSyntax)){
        	ctx = this.getAcceptedPresentationContext(abstractSyntax, transferSyntax);
        }
        else if(this.isPresentationContextAccepted(abstractSyntax, UID.IMPLICIT_VR_LITTLE_ENDIAN)){
        	ctx = this.getAcceptedPresentationContext(abstractSyntax, UID.IMPLICIT_VR_LITTLE_ENDIAN);
        }
        else{
            logger.error("{} DICOM Toolkit layer: Cannot send image because Abstract Syntax or Transfer Syntax was not accepted by SCU. The syntax pair is {} and {}", this.getClass().getName(), abstractSyntax, transferSyntax);
            throw new DCSException("Abstract Syntax or Transfer Syntax not accepted by SCU.");
        }
        logger.debug("Sending the DICOM object using Presentation Context ID {}. This PCID represents syntax pair {} and {}", ctx.id(), ctx.abstractSyntax(), ctx.transferSyntax());
        return ctx;
    }

    /**
     * Is the Presentation Context valid for use?
     * 
     * @param sopClass represents an abstract syntax of the object.
     * @param transferSyntax represents a transfer syntax of the object.
     * @return True or False.
     */
    private boolean isPresentationContextAccepted(String sopClass, String transferSyntax){
        Iterator<Integer> contextID = this.acceptedContexts_map.keySet().iterator();
        Integer id;
        while(contextID.hasNext()){
        	id = contextID.next();
            AcceptedPresentationContext ctx = this.acceptedContexts_map.get(id);
            if(ctx.abstractSyntax().equals(sopClass) && ctx.getTransferSyntaxUID().equals(transferSyntax)){
                return true;
            }
        }
        return false;
    }

    /**
     * Get the accepted Presentation Context.
     * 
     * @param abstractSyntax represents the abstract syntax of the object.
     * @param transferSyntax represents the transfer syntax to be used to send the object to SCU.
     * @return
     */
    private AcceptedPresentationContext getAcceptedPresentationContext(String abstractSyntax, String transferSyntax){
        Iterator<Integer> contextID = this.acceptedContexts_map.keySet().iterator();
        Integer id;
        while(contextID.hasNext()){
        	id = contextID.next();
            AcceptedPresentationContext ctx = this.acceptedContexts_map.get(id);
            if(ctx.abstractSyntax().equals(abstractSyntax) && ctx.getTransferSyntaxUID().equals(transferSyntax)){
                return ctx;
            }
        }
        return null;
    }

    
	private void removeSelectedBadVRElements(DicomDataSet dds){
		ArrayList<String> removeList = DicomServerConfiguration.getConfiguration().getRemovedElements();
		if(removeList != null){
			Iterator<String> iter = removeList.iterator();
			while(iter.hasNext()){
				String tagNumber  = iter.next();
				try{
					AttributeTag tag = new AttributeTag(tagNumber);
					if(dds.containsElement(tag)){
						DicomElement element = dds.findElement(tag);
						short vr = element.vr();
	
						try{
							switch (vr){
								case DCM.VR_AE: 
									VRValidator.instance().validateAE((DicomAEElement)element);
									break;
								case DCM.VR_AS: 
									VRValidator.instance().validateAS((DicomASElement)element);
									break;
								case DCM.VR_AT: 
									VRValidator.instance().validateAT((DicomATElement)element);
									break;
								case DCM.VR_CS: 
									VRValidator.instance().validateCS((DicomCSElement)element);
									break;
								case DCM.VR_DA: 
									VRValidator.instance().validateDA((DicomDAElement)element);
									break;
								case DCM.VR_DS: 
									VRValidator.instance().validateDS((DicomDSElement)element);
									break;
								case DCM.VR_DT: 
									VRValidator.instance().validateDT((DicomDTElement)element);
									break;
								case DCM.VR_FD: 
									VRValidator.instance().validateFD((DicomFDElement)element);
									break;
								case DCM.VR_FL: 
									VRValidator.instance().validateFL((DicomFLElement)element);
									break;
								case DCM.VR_IS: 
									VRValidator.instance().validateIS((DicomISElement)element);
									break;
								case DCM.VR_LO: 
									VRValidator.instance().validateLO((DicomLOElement)element);
									break;
								case DCM.VR_LT: 
									VRValidator.instance().validateLT((DicomLTElement)element);
									break;
								case DCM.VR_PN: 
									VRValidator.instance().validatePN((DicomPNElement)element);
									break;
								case DCM.VR_SH: 
									VRValidator.instance().validateSH((DicomSHElement)element);
									break;
								case DCM.VR_SL: 
									VRValidator.instance().validateSL((DicomSLElement)element);
									break;
								case DCM.VR_SQ: 
									ValidationErrorList list = VRValidator.instance().validateSQ((DicomSQElement)element,"0");
									if(list.hasErrors()){
										throw new DCSException();
									}
									break;
								case DCM.VR_SS: 
									VRValidator.instance().validateSS((DicomSSElement)element);
									break;
								case DCM.VR_ST: 
									VRValidator.instance().validateST((DicomSTElement)element);
									break;
								case DCM.VR_TM: 
									VRValidator.instance().validateTM((DicomTMElement)element);
									break;
								case DCM.VR_UI: 
									VRValidator.instance().validateUI((DicomUIElement)element);
									break;
								case DCM.VR_UL: 
									VRValidator.instance().validateUL((DicomULElement)element);
									break;
								case DCM.VR_UN: 
									VRValidator.instance().validateUN((DicomUNElement)element);
									break;
								case DCM.VR_US: 
									VRValidator.instance().validateUS((DicomUSElement)element);
									break;
								case DCM.VR_UT: 
									VRValidator.instance().validateUT((DicomUTElement)element);
									break;
								case DCM.VR_OB: 
									VRValidator.instance().validateOB((DicomOBElement)element);
									break;
								case DCM.VR_OW: 
									VRValidator.instance().validateOW((DicomOWElement)element);
									break;
								case DCM.VR_OF: 
									VRValidator.instance().validateOF((DicomOFElement)element);
									break;
							}
						}
						catch(DCSException dcsX){
							dds.insert(tag, "");
						}
					}
				}
				catch(DCSException dcsX){
					//Do nothing with exception.
				}
			}
		}
	}	
}
