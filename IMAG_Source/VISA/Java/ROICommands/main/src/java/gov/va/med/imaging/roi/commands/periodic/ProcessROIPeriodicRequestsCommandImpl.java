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

import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.GUID;
import gov.va.med.imaging.core.annotations.routerfacade.RouterCommandExecution;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InvalidUserCredentialsException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.notifications.NotificationFacade;
import gov.va.med.imaging.notifications.NotificationTypes;
import gov.va.med.imaging.roi.commands.mbean.ROICommandsStatistics;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;
import gov.va.med.imaging.roi.commands.periodic.processor.AnnotateImagesROIWorkItemProcessor;
import gov.va.med.imaging.roi.commands.periodic.processor.CacheImagesROIWorkItemProcessor;
import gov.va.med.imaging.roi.commands.periodic.processor.MergeImagesROIWorkItemProcessor;
import gov.va.med.imaging.roi.commands.periodic.processor.NewROIWorkItemProcessor;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * This is the main periodic command for ROI that searches for all work items and executes them.  When nothing is left it reschedules itself
 * 
 * @author VHAISWWERFEJ
 *
 */
@RouterCommandExecution(asynchronous=true, distributable=true)
public class ProcessROIPeriodicRequestsCommandImpl
extends AbstractCommandImpl<java.lang.Void>
{
	
	private static final long serialVersionUID = 3250754638650501774L;

	public ProcessROIPeriodicRequestsCommandImpl()
	{
		super();
	}

	@Override
	public Void callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException
	{
		try
		{
			setRunning(true);
			// if this is being called periodically then set a new transaction ID
			if(isPeriodic())
			{
				TransactionContext transactionContext = TransactionContextFactory.get(); 
				transactionContext.setTransactionId( (new GUID()).toLongString() );
				transactionContext.setRequestType("ROI Periodic Processing");
				// only doing this on periodic retries
				ROICommandsContext.getRouter().processOldUnfinishedROIRequests();
			}
			
			//if(PeriodicROICommandRunStatus.getPeriodicCommandRunStatus().isPeriodicROIProcessingEnabled())
			//{
				processNewWorkItems();
				processCacheImagesWorkItems();
				processAnnotateImagesWorkItems();
				processMergeImagesWorkItems();
			//}
			return null;
		}
		finally
		{
			setRunning(false);
		}		
	}
	
	private void processNewWorkItems()
	throws InvalidUserCredentialsException
	{
		NewROIWorkItemProcessor processor = new NewROIWorkItemProcessor();
		processor.processWorkItems();
	}
	
	private void processCacheImagesWorkItems()
	throws InvalidUserCredentialsException
	{
		CacheImagesROIWorkItemProcessor processor = new CacheImagesROIWorkItemProcessor();
		processor.processWorkItems();
	}
	
	private void processAnnotateImagesWorkItems()
	throws InvalidUserCredentialsException
	{
		AnnotateImagesROIWorkItemProcessor processor = new AnnotateImagesROIWorkItemProcessor();
		processor.processWorkItems();
	}
	
	private void processMergeImagesWorkItems()
	throws InvalidUserCredentialsException
	{
		MergeImagesROIWorkItemProcessor processor = new MergeImagesROIWorkItemProcessor();
		processor.processWorkItems();
	}

	@Override
	public boolean equals(Object obj)
	{
		// this method takes no input parameters so this command is always the same as a currently running version
		return true;
	}

	@Override
	protected String parameterToString()
	{
		return "";
	}
	
	@Override
	public Command<Void> getNewPeriodicInstance() 
	throws MethodException
	{
		ProcessROIPeriodicRequestsCommandImpl command = new ProcessROIPeriodicRequestsCommandImpl();
		command.setPeriodic(true);
		command.setPeriodicExecutionDelay(this.getPeriodicExecutionDelay());
		command.setPriority(this.getPriority().ordinal());
		command.setChildCommand(this.isChildCommand());
		command.setCommandContext(getCommandContext());
		return command;
	}

	private static boolean running = false;
	public static synchronized void setRunning(boolean newValue)
	{
		running = newValue;
	}
	
	public static boolean isRunning()
	{
		return running;
	}

	@Override
	public List<Class<? extends MethodException>> getFatalPeriodicExceptionClasses()
	{
		List<Class<? extends MethodException>> fatalExceptions = new ArrayList<Class<? extends MethodException>>();
		fatalExceptions.add(InvalidUserCredentialsException.class);
		return fatalExceptions;
	}

	@Override
	public void handleFatalPeriodicException(Throwable t)
	{
        getLogger().error("ROIPeriodicCommand had a fatal exception ({}) and is shutting down.", t.getClass().getName());
		ROICommandsStatistics stats = ROICommandsStatistics.getRoiCommandsStatistics();
		stats.setRoiPeriodicProcessing(false);
		stats.setRoiPeriodicProcessingError("Fatal exception when processing ROI requests. ROI periodic processing will be disabled, " + t.getMessage());
		
		String subject = "Invalid VIX ROI service account credentials";
		String message = "The ProcessROIPeriodicRequests periodic command has shut down due to invalid VIX ROI service account credentials.";
		NotificationFacade.sendNotification(NotificationTypes.InvalidServiceAccountCredentials, subject, message);
		
	}
}
