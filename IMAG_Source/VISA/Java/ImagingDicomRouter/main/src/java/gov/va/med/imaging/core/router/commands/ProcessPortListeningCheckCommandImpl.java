/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 10, 2011
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
package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.dicom.common.stats.DicomServiceStats;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.InstrumentConfig;

import java.io.IOException;
import java.net.DatagramSocket;
import java.net.ServerSocket;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWPETERB
 *
 */
@RouterCommandExecution(asynchronous = true, distributable = false)
public class ProcessPortListeningCheckCommandImpl extends
		AbstractCommandImpl<Boolean> {

	//private static final long serialVersionUID = -5951980171292687832L;
	private Logger logger = Logger.getLogger(ProcessPortListeningCheckCommandImpl.class);

	/**
	 * 
	 */
	public ProcessPortListeningCheckCommandImpl() {
		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext()
			throws MethodException, ConnectionException {
		
		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router Command {}", Thread.currentThread().getId(), this.getClass().getName());}
		
		// First, loop over all the instruments and check the listener on each configured port
		for (InstrumentConfig instrument : DicomServerConfiguration.getConfiguration().getInstruments())
		{
			checkListener(instrument.getPort());
		}
		
		// Finally, also check the default DICOM listener (query retrieve, etc)
		checkListener(DicomServerConfiguration.getConfiguration().getDicomListenerPort());
		
		return true;
	}

	private void checkListener(int listenerPort)
	{
		ServerSocket ss = null;
	    DatagramSocket ds = null;
	    try {
	        ss = new ServerSocket(listenerPort);
	        ss.setReuseAddress(true);
	        ds = new DatagramSocket(listenerPort);
	        ds.setReuseAddress(true);
	    	if(logger.isDebugEnabled()){
                logger.debug("{} checked and is not listening.", listenerPort);}
			DicomServiceStats.getInstance().setCurrentPortStatus(listenerPort, DicomServiceStats.DOWN);
	    }
	    catch (IOException e){
	    	if(logger.isDebugEnabled()){
                logger.debug("{} checked and is listening.", listenerPort);}
	    	DicomServiceStats.getInstance().setCurrentPortStatus(listenerPort, DicomServiceStats.UP);
	    }
	    finally{
	        if (ds != null){
	            ds.close();
	        }
	        if (ss != null){
	            try{
	                ss.close();
	            } 
	            catch (IOException e){
	                /* should not be thrown */
	            }
	        }
	    }

	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#getNewPeriodicInstance()
	 */
	@Override
	public Command<Boolean> getNewPeriodicInstance() throws MethodException {
		ProcessPortListeningCheckCommandImpl command = new ProcessPortListeningCheckCommandImpl();
		command.setPeriodic(true);
		command.setPeriodicExecutionDelay(this.getPeriodicExecutionDelay());
		command.setCommandContext(this.getCommandContext());
		return command;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) {
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString() {
		return "";
	}

}
