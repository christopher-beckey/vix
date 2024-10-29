// Copyright Laurel Bridge Software, Inc.  All rights reserved.  See distributed license file.

package gov.va.med.imaging.study.lbs;

import com.lbs.APC.AppControl;
import com.lbs.APC_a.AppControl_a;
import com.lbs.CDS.CDSException;
import com.lbs.CDS_a.CFGDB_a;
import com.lbs.DCS.*;
import com.lbs.DSS.QRServer;
import com.lbs.LOG_a.LOGClient_a;
import gov.va.med.logging.Logger;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;


public class DicomScp
	implements AssociationConfigPolicyManager, AssociationListener
{
	private AssociationManager manager;
	private final static Logger logger = Logger.getLogger(DicomScp.class);
	private static SCPThread listenerThread;
	public static AtomicBoolean semaphore = new AtomicBoolean(false);
	
    public DicomScp( )
	{
		logger.info( "Creating new DicomScp in DicomScp(args)" );
	}
    
	private void setupLaurelBridge() throws DCSException, CDSException {

		logger.info("In Setup Laurel Bridge initialization of AssocationManager, QRServer, and VerificationServer");
		// Create an AssociationManager
		// You can override association manager settings after creating,
		// e.g., tcp-port, max-number-concurrent-assocs, max-total-assocs, etc.
		// For now, it will get them from proc-cfg/java_lib/DCS/AssociationManager.
		//
		manager = new AssociationManager();
		
		// Run this line if you want AssociationManager to call
		// our getSessionSettings() each time an association is
		// requested. There can only be one association-config-policy-manager.
		// If you don't do this, you also don't need the
		// "implements AssociationConfigPolicyManager" above.
		manager.setAssociationConfigPolicyMgr( this );

		// Run this line if you want AssociationManager to call
		// our beginAssociation()/endAssociation() each time an association is
		// started/ended. There can be any number of association-listeners.
		// If you don't do this, you also don't need the
		// "implements AssociationListener" above.
		manager.addAssociationListener( this );

		// Create a QRServer object which will register as an AssociationListener,
		// and create a QRSCP object each time an association is requested.
		//LOG.info( "Creating new QRServer Object" );
		new QRServer( manager );

		// Create a VerificationServer object (creates VerificationSCP's)
		//LOG.info( "Creating new VerificationServer Object" );
		new VerificationServer( manager );
	}

	/**
	* Ask AssociationManager to loop, waiting for connection requests, and handling
	* associations. Each time a socket connect is detected, AssociationManager
	* creates an instance of AssociationAcceptor that will handle all I/O for that
	* association.
	*/
	public void runServer()
		throws DCSException
	{
		logger.info( "Starting DicomScp, runServer()  =======================================");
		manager.run();
	}

	/**
	* Implementation of AssociationConfigPolicyManager interface.
	* Here is where we optionally implement our custom policy of selecting
	* the configuration used for a particular association.
	*/
	public DicomSessionSettings getSessionSettings( AssociationAcceptor assoc )
		throws AssociationRejectedException,
			AssociationAbortedException,
			DCSException
	{
		// Get the association info from the current acceptor.
		AssociationInfo ainfo = assoc.getAssociationInfo();
		
        //LOG.debug( "###Lbs_Scp.getSessionSettings.assocInfo: "+ainfo.toString());
		// Get some fields from the association info
		String assocName = ainfo.applicationContextName();
		String called_ae  = String.format("%-20s", ainfo.calledTitle());
		String called_addr = ainfo.calledPresentationAddress();
		String calling_ae = String.format("%-20s", ainfo.callingTitle());
		String calling_addr = ainfo.callingPresentationAddress();
        if(logger.isDebugEnabled())
            logger.debug("DicomScp.getSessionSettings: \n   ainfo.calledTitle ={} at {}\n   ainfo.callingTitle={} at {}", called_ae, called_addr, calling_ae, calling_addr);
		return new DicomSessionSettings(); // not caring about the AE titles.
	}

	/**
	*
	* Invoke with the following optional arguments:
	*	-CDS_a_use_fsys     Do not require DCDS_Server.
	*						default is to expect it to
	*						be running. If this option is
	*						enabled, shutdown messages and
	*						runtime changes to debug settings
	*						are unsupported.
	*	-apc <proc-attr-name>=<value>
	*						Overrides any setting in the process
	*						configuration.
	*/
	public static void main()
	{
        logger.info("******************************* DicomScp MAIN **********************************");
		try
		{
			String[] args = new String[4];
			args[0] = "-appcfg";
			args[1] = "DicomScpConfig";
			args[2] = "-appicfg";
			args[3] = "dicom_scp_log";
            if(logger.isDebugEnabled())
                logger.debug("DicomScp configuration file: {}   log_file: {}", args[1], args[3]);

			// uncomment if you want to default to no DCDS-Server
			CFGDB_a.setFSysMode( true );
			CINFO inst = CINFO.getInstance();
			
			AppControl_a.setup(args, CINFO.getInstance() );
			LOGClient_a.setup(args);

			// install our custom DicomDataService.
			//logger.info( "Setting up DDS_a(mix) service");
			VixDicomDataService.setup();
			//logger.info( "DDS_a(mix) service set up");

			//Install custom DataDictionary for AE Title Mappings
			CustomDicomDataDictionary.setup();
			//logger.info( "CustomDicomDataDictionary set up");

			// create qr scp object
			DicomScp scp = new DicomScp();
			
			//Setup Laurel Bridge association manager once
			scp.setupLaurelBridge();
			
			// start accepting connections
			scp.runServer();

			logger.info( "DicomScp exiting!" );
			/* */
		}
		catch( Exception e )
		{
            logger.error("errorcode: -1 ERROR: {}", e);
            StringWriter sw = new StringWriter(); 
            PrintWriter pw = new PrintWriter(sw); 
            e.printStackTrace(pw); 
            String expmsg = sw.toString(); 
            if(logger.isDebugEnabled())
                logger.debug("Exception:\n{}", expmsg);
			
		Map<String, String> env = System.getenv();

        LinkedHashMap<String, String> collect =
                env.entrySet().stream()
                        .sorted(Map.Entry.comparingByKey())
                        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue,
                                (oldValue, newValue) -> oldValue, LinkedHashMap::new));

        if(logger.isDebugEnabled()) collect.forEach((k, v) -> logger.debug("{}={}", k, v));
		}
        /* */
		if ( AppControl.isInitialized() )
		{
			AppControl.instance().shutdown( 0 );
		}
        /* */
		//System.exit( 0 );
	}

	/**
	* Optional implementation of AssociationListener interface.
	*
	* Indicates that a new association has been created.
	* The AssociationAcceptor has selected configuration
	* settings for the association, and has processed the
	* A-Associate-Request PDU. The association has not yet
	* been accepted.
	* @param assoc the object handling the association.
	* @throws AssociationRejectedException Indicates that
	* the association should be rejected immediately.
	* @throws AssociationAbortedException Indicates that
	* the association should be aborted immediately.
	*/
	public void beginAssociation( AssociationAcceptor assoc )
		throws AssociationRejectedException, AssociationAbortedException
	{
	}

	/**
	* Optional implementation of AssociationListener interface.
	*
	* Indicates that an association has ended.
	* @param assoc the object handling the association.
	*/
	public void endAssociation( AssociationAcceptor assoc )
	{
	}

	public void acsePduIn(String connection_id, AssociationAcceptor acceptor, PDU pdu)
	{
		if(logger.isDebugEnabled()){
            logger.debug("acsePduIn: {} acceptor for {}", pdu.getTypeName(), (acceptor == null) ? "Null" : acceptor.getAssociationInfo().callingTitle());
		}
		String s = pdu.getTypeName();
		if (s.startsWith("RELEASE")) {
            logger.info("######=== DICOM RELEASE ===### {} for {}", s, (acceptor == null) ? "Null" : acceptor.getAssociationInfo().callingTitle());
		}
	}

	public void acsePduOut(String connection_id, AssociationAcceptor acceptor, PDU pdu)
	{
		if(logger.isDebugEnabled()){
            logger.debug("acsePduOut: {}{}", pdu.getTypeName(), (pdu.getTypeName().endsWith("-RP")) ? (System.getProperty("line.separator") + "===========================================================") : "");
		}
	}

	public void associationSocketConnected(String connection_id, String local_address, String remote_address)
	{
//		logger.debug("associationSocketConnected: " // + "connection id =" + connection_id
//		+ System.getProperty( "line.separator" ) + "local address = " + local_address
//		+ System.getProperty( "line.separator" ) + "remote address = " + remote_address );	
	}

	public void associationSocketDisconnected(String connection_id, String local_address, String remote_address)
	{
//		LOG.info("associationSocketDisconnected: connection id =" + connection_id
//		+ System.getProperty( "line.separator" ) + "local address = " + local_address
//		+ System.getProperty( "line.separator" ) + "remote address = " + remote_address);	
	}
	
	static class SCPThread extends Thread {
	   //private final static Logger logger1 = Logger.getLogger(SCPThread.class);
		public void run () {
		   DicomScp.semaphore.set(true);
		   logger.info("DicomScp/SCPThread.run() calling DicomScp.main()");
		   DicomScp.main();
		}

		@Override
		public void interrupt() {
			semaphore.getAndSet(false);
			AppControl.instance().shutdown( 0 );
			super.interrupt();
		}
	}
	
	public static String start() {
		String ret = null;
		try {
			if (semaphore.get()) {
				logger.info("****** in DicomScp.start, SCP already started.");
			    return "SCP already started";
			}
			if(logger.isDebugEnabled()) logger.debug("****** in DicomScp.start()");
			listenerThread = new SCPThread();
			if(logger.isDebugEnabled()) logger.debug("got SCPThread");
			listenerThread.start();
			ret = "SCP started";
		} catch (Exception e) {
            logger.error("in DicomScp.start, exception: {}", e);
			if(logger.isDebugEnabled()) logger.debug("DicomScp.start failure details ",e);
			ret = "Start got exception. "+e;
		}
		return ret;
	}
	
	public static String stop() {
		//logger.info("**************** in DicomScp.stop  ********************");
		String ret = null;
		if ( AppControl.isInitialized() )
		{
			semaphore.set(false);
			//AppControl.instance().shutdown( 0 );
			listenerThread.interrupt();
			ret = "SCP stopped";
		}
		else {
			ret = "AppControl is not initialized. Not started yet!";
		}
		logger.info(ret);
		return ret;
	}
	
}

