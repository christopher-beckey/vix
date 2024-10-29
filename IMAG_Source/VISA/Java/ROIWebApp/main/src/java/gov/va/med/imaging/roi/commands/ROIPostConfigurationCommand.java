/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 19, 2013
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
package gov.va.med.imaging.roi.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.PeriodicCommandList;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.roi.commands.periodic.DeleteOldCompletedROIWorkItemsCommandImpl;
import gov.va.med.imaging.roi.commands.periodic.PeriodicROICommandStarter;
import gov.va.med.imaging.roi.commands.periodic.ProcessROIPeriodicRequestsCommandImpl;
import gov.va.med.imaging.roi.commands.periodic.configuration.ROIPeriodicCommandConfiguration;
import gov.va.med.imaging.roi.rest.translator.ROIRestTranslator;
import gov.va.med.imaging.roi.rest.types.ROIConfigurationType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIPostConfigurationCommand
extends AbstractROICommand<ROIPeriodicCommandConfiguration, ROIConfigurationType>
{
	private final ROIConfigurationType roiConfigurationType;
	
	public ROIPostConfigurationCommand(ROIConfigurationType configuration)
	{
		super("postConfiguration");
		this.roiConfigurationType = configuration;
	}

	public ROIConfigurationType getRoiConfigurationType()
	{
		return roiConfigurationType;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected ROIPeriodicCommandConfiguration executeRouterCommand()
	throws MethodException, ConnectionException
	{
		
		ROIPeriodicCommandConfiguration configuration = ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration();	
		configuration.setPeriodicROIProcessingEnabled(getRoiConfigurationType().isPeriodicROIProcessingEnabled());
		configuration.setProcessWorkItemImmediately(getRoiConfigurationType().isProcessWorkItemImmediately());
		configuration.setExpireCompletedItemsEnabled(getRoiConfigurationType().isExpireCompletedItemsEnabled());

		int val = getRoiConfigurationType().getExpireCompletedItemsAfterDays();
		if(val > 0)
			configuration.setExpireCompletedItemsAfterDays(val);
		else
            getLogger().warn("Cannot set Expire Completed Items After Days to value '{}'.", val);
		
		val = getRoiConfigurationType().getProcessingWorkItemWaitTime();
		if(val > 0)
			configuration.setProcessingWorkItemWaitTime(val);
		else
            getLogger().warn("Cannot set Processing Work Item Wait time to value '{}'.", val);
		
		getLogger().info("Updating ROIPeriodicCommandConfiguration with properties");
		configuration.storeConfiguration();
		FacadeConfigurationFactory.getConfigurationFactory().clearConfiguration(ROIPeriodicCommandConfiguration.class);
		
		// even though not changing the credentials, need to terminate these commands and maybe restart them depending on the new configuration
		PeriodicCommandList.get().terminateScheduledPeriodicCommand(ProcessROIPeriodicRequestsCommandImpl.class);
		PeriodicCommandList.get().terminateScheduledPeriodicCommand(DeleteOldCompletedROIWorkItemsCommandImpl.class);
					
		PeriodicROICommandStarter.startROIPeriodicCommands();
		
		return ROIPeriodicCommandConfiguration.getROIPeriodicCommandConfiguration();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected ROIConfigurationType translateRouterResult(
			ROIPeriodicCommandConfiguration routerResult)
	throws TranslationException, MethodException
	{
		return ROIRestTranslator.translate(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<ROIConfigurationType> getResultClass()
	{
		return ROIConfigurationType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 */
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
				new HashMap<WebserviceInputParameterTransactionContextField, String>();
			
		return transactionContextFields;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(ROIConfigurationType translatedResult)
	{
		return null;
	}

}
