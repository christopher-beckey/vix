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
package gov.va.med.imaging.roi.web;

import gov.va.med.imaging.core.router.PeriodicCommandList;
import gov.va.med.imaging.core.router.periodiccommands.PeriodicCommandConfiguration;
import gov.va.med.imaging.core.router.periodiccommands.PeriodicCommandEngineAdapter;
import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.roi.commands.periodic.DeleteOldCompletedROIWorkItemsCommandImpl;
import gov.va.med.imaging.roi.commands.periodic.PeriodicROICommandStarter;
import gov.va.med.imaging.roi.commands.periodic.ProcessROIPeriodicRequestsCommandImpl;
import gov.va.med.imaging.roi.commands.periodic.configuration.ROIPeriodicCommandConfiguration;
import gov.va.med.imaging.router.commands.ProcessViewerPreCacheWorkItemsCommandImpl;

import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

public class UpdateROIConfigurationServlet
extends HttpServlet
{
	private final static Logger logger = Logger.getLogger(UpdateROIConfigurationServlet.class);

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws IOException
	{
		String accessCode = request.getParameter("accessCode");
		String verifyCode = request.getParameter("verifyCode");
		String securityToken = request.getParameter("securityToken");
		try
		{
			// Initial check to see if access or verify codes have been provided
			boolean codesSpecified = ((accessCode != null) && (accessCode.length() != 0) && (verifyCode != null) && (verifyCode.length() != 0));

			// Separate check to handle their lengths being < 6
			if ((codesSpecified) && ((accessCode.trim().length() < 6) || (verifyCode.trim().length() < 6))) {
				throw new IllegalArgumentException("Access and/or verify code trimmed lengths must be at least six characters long");
			}
			
			String periodicProcessingEnabled = request.getParameter("periodicProcessingEnabled");
			String completedItemPurgeProcessingEnabled = request.getParameter("completedItemPurgeProcessingEnabled");
			String expiredCompletedItemsAfterDays = request.getParameter("expiredCompletedItemsAfterDays");
			String processDisclosuresImmediately = request.getParameter("processDisclosuresImmediately");
			String processingWorkItemWaitTime = request.getParameter("processingWorkItemWaitTime");
			
			ROIPeriodicCommandConfiguration configuration = ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration();
			// Don't set these values if they're not present
			if (codesSpecified)
			{
				configuration.setAccessCode(new EncryptedConfigurationPropertyString(accessCode));
				configuration.setVerifyCode(new EncryptedConfigurationPropertyString(verifyCode));
			}
			configuration.setPeriodicROIProcessingEnabled("TRUE".equalsIgnoreCase(periodicProcessingEnabled));
			configuration.setProcessWorkItemImmediately("TRUE".equalsIgnoreCase(processDisclosuresImmediately));
			configuration.setExpireCompletedItemsEnabled("TRUE".equalsIgnoreCase(completedItemPurgeProcessingEnabled));
			
			int val = parseStringInt(expiredCompletedItemsAfterDays);
			if(val > 0)
				configuration.setExpireCompletedItemsAfterDays(val);
			else
                logger.warn("Cannot set Expire Completed Items After Days to value '{}'.", expiredCompletedItemsAfterDays);
			
			val = parseStringInt(processingWorkItemWaitTime);
			if(val > 0)
				configuration.setProcessingWorkItemWaitTime(val);
			else
                logger.warn("Cannot set Processing Work Item Wait time to value '{}'.", processingWorkItemWaitTime);
			
			
			logger.info("Updating ROIPeriodicCommandConfiguration with new access and verify codes");
			configuration.storeConfiguration();
			FacadeConfigurationFactory.getConfigurationFactory().clearConfiguration(ROIPeriodicCommandConfiguration.class);
			
			// no matter what terminate the two commands, need to restart them with the new credentials if they are re-enabled.
			PeriodicCommandList.get().terminateScheduledPeriodicCommand(ProcessROIPeriodicRequestsCommandImpl.class);
			PeriodicCommandList.get().terminateScheduledPeriodicCommand(DeleteOldCompletedROIWorkItemsCommandImpl.class);
						
			PeriodicROICommandStarter.startROIPeriodicCommands();
			
			
			//Update access/verify codes in PeriodicCommandConfiguration as well. They are using the same a/v codes as ROI
			PeriodicCommandConfiguration config = PeriodicCommandConfiguration.getConfiguration();
			if (codesSpecified) {
				config.setAccessCode(new EncryptedConfigurationPropertyString(accessCode));
				config.setVerifyCode(new EncryptedConfigurationPropertyString(verifyCode));
			}
			config.storeConfiguration();

			//Terminate all Periodic Commands 
//			List<PeriodicCommandDefinition> commandDefinitions = PeriodicCommandConfiguration.getConfiguration().getCommandDefinitions();
//			for (PeriodicCommandDefinition definition : commandDefinitions) 
//			{
//				String commandImpl = definition.getCommandClassName() + "Impl";
//				logger.info("Terminating periodic command: " + commandImpl);
//				PeriodicCommandList.get().terminateScheduledPeriodicCommand((Class<? extends AbstractCommandImpl<?>>) Class.forName(commandImpl));
//			}			
			PeriodicCommandList.get().terminateScheduledPeriodicCommand(ProcessViewerPreCacheWorkItemsCommandImpl.class);
			
			//Restart periodic commands with new a/v codes
			logger.info("Restarting periodic commands");
			PeriodicCommandEngineAdapter.initializeAndStartPeriodicCommands();
			if(codesSpecified) response.sendRedirect("ConfigureROI.jsp?result=Successfully updated ROI and SCP " +
					"Configurations&securityToken="+securityToken);
			else response.sendRedirect("ConfigureROI.jsp?result=Successfully updated ROI Configurations&securityToken="+securityToken);
		}catch(IllegalArgumentException illegalArgumentException){
            logger.warn("Error updating ROIPeriodicCommandConfiguration, {}", illegalArgumentException.getMessage(), illegalArgumentException);
			response.sendRedirect("ConfigureROI.jsp?error=Access Verify codes not valid&securityToken="+securityToken);
		}
		catch(Exception ex)
		{
            logger.error("Error updating ROIPeriodicCommandConfiguration, {}", ex.getMessage(), ex);
			response.sendRedirect("ConfigureROI.jsp?error=Error updating ROI Configuration&securityToken="+securityToken);
		}
	}
	
	private int parseStringInt(String stringValue)
	{
		try
		{
			int val = Integer.parseInt(stringValue);
			if(val <= 0)
				val = -1;
			return val;
		}
		catch(NumberFormatException nfX)
		{
			return -1;
		}
	}

}
