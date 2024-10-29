/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 27, 2012
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

import gov.va.med.logging.Logger;

import gov.va.med.imaging.notifications.NotificationFacade;
import gov.va.med.imaging.notifications.NotificationTypes;
import gov.va.med.imaging.roi.commands.mbean.ROICommandsStatistics;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;
import gov.va.med.imaging.roi.commands.periodic.configuration.ROIPeriodicCommandConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextMemento;
import gov.va.med.server.ServerAgnosticEngineAdapter;

/**
 * @author VHAISWWERFEJ
 *
 */
public class PeriodicROICommandStarter
{
	private static ServerAgnosticEngineAdapter engineAdapter = null;
	private final static Logger logger = Logger.getLogger(PeriodicROICommandStarter.class);
	
	public synchronized static void setEngineAdapter(ServerAgnosticEngineAdapter engineAdapter)
	{
		PeriodicROICommandStarter.engineAdapter = engineAdapter;
	}
	
	public static ROIPeriodicCommandsCredentialsState currentCredentialsState = ROIPeriodicCommandsCredentialsState.unknown;
	
	public static void startROIPeriodicCommands()
	{
		logger.info("Initializing ROI periodic commands");
		
		
		// set up a security realm for the commands
		ROIPeriodicCommandConfiguration config = ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration();
		
		//PeriodicROICommandRunStatus.getPeriodicCommandRunStatus().setPeriodicROIProcessingEnabled(config.isPeriodicROIProcessingEnabled());
		ROICommandsStatistics stats = ROICommandsStatistics.getRoiCommandsStatistics();
		stats.setRoiProcessWorkItemImmediately(config.isProcessWorkItemImmediately());
		if(config.isPeriodicROIProcessingEnabled() || config.isExpireCompletedItemsEnabled())
		{			
			String accessCode = config.getAccessCode().getValue();
			String verifyCode = config.getVerifyCode().getValue();
			if(accessCode == null || accessCode.length() <=0)
			{
				logger.error("Missing access code, disabling periodic commands.");
				stats.setRoiCompletedItemsPurgeProcessing(false);
				stats.setRoiPeriodicProcessing(false);
				stats.setRoiPeriodicProcessingError("Missing access code");
				currentCredentialsState = ROIPeriodicCommandsCredentialsState.invalid;
				return;
			}
			if(verifyCode == null || verifyCode.length() <=0)
			{
				logger.error("Missing verify code, disabling periodic commands.");
				stats.setRoiCompletedItemsPurgeProcessing(false);
				stats.setRoiPeriodicProcessing(false);
				stats.setRoiPeriodicProcessingError("Missing verify code");
				currentCredentialsState = ROIPeriodicCommandsCredentialsState.invalid;
				return;
			}

			TransactionContextMemento memento = TransactionContextFactory.get().getMemento();
			try
			{
				// Authenticate on the main thread.
				if(engineAdapter.authenticate(accessCode, verifyCode.getBytes()) == null)
				{
					stats.setRoiPeriodicProcessing(false);
					stats.setRoiCompletedItemsPurgeProcessing(false);
					stats.setRoiPeriodicProcessingError("Invalid credentials for ROI periodic processing, cannot process requests");
					// if null is returned that means the authentication failed, do not start the periodic command and send out an email notification
					logger.error("Authentication of user for ROI Periodic command failed, cannot start periodic command!");
					// send an email notification
					
					// if nothing is enabled then no real reason to send a notification
					if(config.isExpireCompletedItemsEnabled() || config.isPeriodicROIProcessingEnabled())
					{
						logger.info("Sending email notification about invalid credentials for ROI periodic processing.");
						String subject = "Invalid VIX ROI service account credentials";
						String message = "The credentials used for periodic processing of Release of Information (ROI) disclosures is invalid. ROI disclosures will not be processed until the credentials are corrected.";
						NotificationFacade.sendNotification(NotificationTypes.InvalidServiceAccountCredentials, subject, message);
					}
					currentCredentialsState = ROIPeriodicCommandsCredentialsState.invalid;
				}
				else
				{
					currentCredentialsState = ROIPeriodicCommandsCredentialsState.valid;
					if(config.isExpireCompletedItemsEnabled())
					{
						stats.setRoiCompletedItemsPurgeProcessing(true);
						logger.info("Starting purgeCompletedROIWorkItems periodic command");
						ROICommandsContext.getROIPeriodicRouter().purgeCompletedROIWorkItems();
					}
					else
					{
						logger.info("purgeCompletedROIWorkItems is disabled in configuration file, purge will not be run.");
						stats.setRoiCompletedItemsPurgeProcessing(false);
					}
					if(config.isPeriodicROIProcessingEnabled())
					{
						stats.setRoiPeriodicProcessing(true);
						stats.setRoiPeriodicProcessingError(null);
						logger.info("Starting processROIPeriodicRequests periodic command");
						ROICommandsContext.getROIPeriodicRouter().processROIPeriodicRequests();
					}
					else
					{
						logger.info("processROIPeriodicRequests is disabled in configuration file, ROI work items will not be processed periodically.");
						stats.setRoiPeriodicProcessing(false);
						stats.setRoiPeriodicProcessingError("ROI Periodic processing disabled");
					}
				}
			}
			finally
			{
				TransactionContextFactory.restoreTransactionContext(memento);
			}
		}
		else
		{
			logger.info("Neither processROIPeriodicRequests nor purgeCompletedROIWorkItems is enabled, neither will not be run periodically.");
			stats.setRoiPeriodicProcessing(false);
			stats.setRoiCompletedItemsPurgeProcessing(false);
			stats.setRoiPeriodicProcessingError("ROI Periodic processing disabled");
			currentCredentialsState = ROIPeriodicCommandsCredentialsState.unknown;
		}
	}
}
