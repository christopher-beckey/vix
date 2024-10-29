/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 29, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.roi.commands.periodic;

import gov.va.med.server.ServerAgnosticEngine;
import gov.va.med.server.ServerAgnosticEngineAdapter;
import gov.va.med.server.ServerLifecycleEvent;

/**
 * @author VHAISWWERFEJ
 *
 */
public class PeriodicROICommandEngineAdapter
extends gov.va.med.imaging.core.interfaces.router.AbstractFacadeRouterImpl
implements ServerAgnosticEngine
{
	
	/* (non-Javadoc)
	 * @see gov.va.med.server.ServerAgnosticEngine#setServerAgnosticEngineAdapter(gov.va.med.server.ServerAgnosticEngineAdapter)
	 */
	@Override
	public void setServerAgnosticEngineAdapter(
			ServerAgnosticEngineAdapter engineAdapter)
	{		
		PeriodicROICommandStarter.setEngineAdapter(engineAdapter);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.server.ServerAgnosticEngine#serverEvent(gov.va.med.server.ServerLifecycleEvent)
	 */
	@Override
	public void serverEvent(ServerLifecycleEvent event)
	{
		if (event.getEventType().equals(ServerLifecycleEvent.EventType.START)) 
		{
			PeriodicROICommandStarter.startROIPeriodicCommands();
			/*
			logger.info("Initializing ROI periodic commands");
			// set up a security realm for the commands
			ROIPeriodicCommandConfiguration config = ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration();
			
			//PeriodicROICommandRunStatus.getPeriodicCommandRunStatus().setPeriodicROIProcessingEnabled(config.isPeriodicROIProcessingEnabled());
			ROICommandsStatistics stats = ROICommandsStatistics.getRoiCommandsStatistics();
			
			if(config.isPeriodicROIProcessingEnabled())
			{
				String siteId = getRouter().getAppConfiguration().getLocalSiteNumber();
				String accessCode = config.getAccessCode().getValue();
				String verifyCode = config.getVerifyCode().getValue();
				if(siteId == null || siteId.length() <=0)
				{
					logger.error("Missing site ID, disabling periodic commands.");
					return;
				}
				if(accessCode == null || accessCode.length() <=0)
				{
					logger.error("Missing access code, disabling periodic commands.");
					return;
				}
				if(verifyCode == null || verifyCode.length() <=0)
				{
					logger.error("Missing verify code, disabling periodic commands.");
					return;
				}
	
				// Authenticate on the main thread.
				if(engineAdapter.authenticate(accessCode, verifyCode.getBytes()) == null)
				{
					stats.setRoiPeriodicProcessing(false);
					stats.setRoiPeriodicProcessingError("Invalid credentials for ROI periodic processing, cannot process requests");
					// if null is returned that means the authentication failed, do not start the periodic command and send out an email notification
					logger.error("Authentication of user for ROI Periodic command failed, cannot start periodic command!");
					// send an email notification
				}
				else
				{
					stats.setRoiPeriodicProcessing(true);
					ROICommandsContext.getROIPeriodicRouter().processROIPeriodicRequests();
				}
				// Clear out context on main thread
				TransactionContextFactory.get().clear();
			}
			else
			{
				stats.setRoiPeriodicProcessing(false);
				stats.setRoiPeriodicProcessingError("ROI Periodic processing disabled");
			}*/
		}
		
	}
}


