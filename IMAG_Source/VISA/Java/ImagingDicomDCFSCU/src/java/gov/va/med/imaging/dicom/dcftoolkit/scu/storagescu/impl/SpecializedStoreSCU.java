/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 4, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWPETERB
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
package gov.va.med.imaging.dicom.dcftoolkit.scu.storagescu.impl;


import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomAssociationAbortException;

import gov.va.med.logging.Logger;

import com.lbs.DCS.AcceptedPresentationContext;
import com.lbs.DCS.AssociationInfo;
import com.lbs.DCS.CINFO;
import com.lbs.DCS.DCM;
import com.lbs.DCS.DCSException;
import com.lbs.DCS.DicomDataSet;
import com.lbs.DCS.DicomSessionSettings;
import com.lbs.DCS.DimseMessage;
import com.lbs.DCS.IOException;
import com.lbs.DCS.IOReadException;
import com.lbs.DCS.IOTimeoutException;
import com.lbs.DCS.IOWriteException;
import com.lbs.DCS.NoDataException;
import com.lbs.DSS.StoreSCU;

/**
 * @author VHAISWPETERB
 *
 */
public class SpecializedStoreSCU extends StoreSCU {

	private DimseMessage last_request_message;

    private static Logger logger = Logger.getLogger (SpecializedStoreSCU.class);


	/**
	 * Constructor
	 * 
	 * @param ainfo
	 * @throws DCSException
	 */
	public SpecializedStoreSCU(AssociationInfo ainfo) throws DCSException {
		super(ainfo);
		this.last_request_message = null;

	}

	/**
	 * Constructor
	 * 
	 * @param ainfo
	 * @param session_settings
	 * @throws DCSException
	 */
	public SpecializedStoreSCU(AssociationInfo ainfo,
			DicomSessionSettings session_settings) throws DCSException {
		super(ainfo, session_settings);
		this.last_request_message = null;

	}
	
	/**
	 * Send the object to the SCU.  Created this extra method to control the Presentation Context
	 * that will be used.
	 * 
	 * @param ds represents the DICOM Dataset.
	 * @param ctx represents the Presentation Context for sending the object.
	 * @param send_timeout_seconds represents the sending timeout.
	 * @param receive_timeout_seconds represents the receiving timeout.
	 * @return the returned DIMSE message.
	 * @throws IOWriteException
	 * @throws DCSException
	 */
	public DimseMessage cStore(DicomDataSet ds, AcceptedPresentationContext ctx, 
			int send_timeout_seconds, int receive_timeout_seconds)
			throws IOTimeoutException, IOReadException, IOWriteException, IOException, NoDataException, DCSException{
		String newline = System.getProperty( "line.separator" );
		if( CINFO.testDebugFlags( CINFO.df_SHOW_GENERAL_FLOW ) )
		{
            logger.debug("StoreSCU.cStore{}{}{}send_timeout_seconds = {}{}receive_timeout_seconds = {}", newline, ds.toString(), newline, send_timeout_seconds, newline, receive_timeout_seconds);
		}

		if (!getConnected())
		{
			throw new DCSException( "invalid state: not connected" );
		}

		DimseMessage msg = new DimseMessage();

		String sop_class_uid    = ds.getElementStringValue( DCM.E_SOPCLASS_UID );
		String sop_instance_uid = ds.getElementStringValue( DCM.E_SOPINSTANCE_UID );

		msg.commandField( DimseMessage.C_STORE_RQ );
		msg.affectedSopclassUid( sop_class_uid );
		msg.affectedSopinstanceUid( sop_instance_uid );
		msg.dataSetType( 0x0100 );
		msg.priority( 0 );
		msg.context_id(ctx.getId());

		msg.data( ds );

		this.last_request_message = msg;
		try
		{
			sendDimseMessage( msg, send_timeout_seconds );
		}
        catch(IOReadException iorX){
            this.setConnected(false);
            throw iorX;
        }
        catch(IOWriteException iowX){
            this.setConnected(false);
            throw iowX;
        }
        catch(IOTimeoutException iotoX){
            this.setConnected(false);
            throw iotoX;
        }
        catch(IOException ioX){
            this.setConnected(false);
            throw ioX;
        }
        catch(DCSException dcs){
            this.setConnected(false);
            throw dcs;
        }


		// read response.....
		DimseMessage rsp = null;
		try{
			rsp = receiveDimseMessage( (short)ctx.getId(), receive_timeout_seconds );
		}
        catch(IOReadException iorX){
            this.setConnected(false);
            throw iorX;
        }
        catch(IOTimeoutException iotoX){
            this.setConnected(false);
            throw iotoX;
        }
        catch(IOException ioX){
            this.setConnected(false);
            throw ioX;
        }
        catch(DCSException dcs){
            this.setConnected(false);
            throw dcs;
        }

		if( CINFO.testDebugFlags( CINFO.df_SHOW_GENERAL_FLOW ) )
		{
            logger.debug("received response message: {}{}", newline, rsp.toString());
		}

		return rsp;		
	}


	
	/* (non-Javadoc)
	 * @see com.lbs.DSS.StoreSCU#getLastRequestMessage()
	 */
	@Override
	public DimseMessage getLastRequestMessage() {
		return this.last_request_message;
	}	
}
