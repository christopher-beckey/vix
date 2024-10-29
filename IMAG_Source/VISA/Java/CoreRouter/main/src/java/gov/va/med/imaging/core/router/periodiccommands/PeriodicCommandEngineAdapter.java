package gov.va.med.imaging.core.router.periodiccommands;

import java.security.Principal;
import java.util.List;

import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.core.router.queue.ScheduledPriorityQueueElement;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.notifications.NotificationFacade;
import gov.va.med.imaging.notifications.NotificationTypes;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextMemento;
import gov.va.med.server.ServerAgnosticEngine;
import gov.va.med.server.ServerAgnosticEngineAdapter;
import gov.va.med.server.ServerLifecycleEvent;

import gov.va.med.logging.Logger;

public class PeriodicCommandEngineAdapter extends
		gov.va.med.imaging.core.interfaces.router.AbstractFacadeRouterImpl
		implements ServerAgnosticEngine {

	private static final Logger LOGGER = Logger.getLogger(PeriodicCommandEngineAdapter.class);
	
	private static ServerAgnosticEngineAdapter engineAdapter;
	private static PeriodicCommandEngineAdapter periodicCommandEngineAdapter;

	public PeriodicCommandEngineAdapter() {
		super();
		periodicCommandEngineAdapter = this;
	}

	protected Logger getLogger() {
		return LOGGER;
	}

	@SuppressWarnings("unchecked")
	public static void initializePeriodicCommand(Class returnClass,
			String commandClassName, Object[] commandParameters,
			ScheduledPriorityQueueElement.Priority priority, int delayInterval) 
	{
		Class<?>[] commandParameterTypes = periodicCommandEngineAdapter.deriveParameterTypesFromParameters(commandParameters);
		Command cmd = periodicCommandEngineAdapter.getCommandFactory().createCommand(returnClass,
				commandClassName, null, commandParameterTypes, commandParameters);
		cmd.setPriority(priority.ordinal());
		cmd.setPeriodicExecutionDelay(delayInterval);
		cmd.setPeriodic(true);
		// Send each command to the black box for asynchronous
		// execution.
		periodicCommandEngineAdapter.getRouter().doAsynchronously(cmd);
	}
	
	private Class<?>[] deriveParameterTypesFromParameters(Object[] initArgs)
	throws IllegalArgumentException
	{
		if(initArgs == null || initArgs.length == 0)
			return new Class<?>[]{};
		
		Class<?>[] parameterTypes = new Class<?>[initArgs.length];
		
		for(int n = 0; n<initArgs.length; ++n)
		{
			if(initArgs[n] == null)
				throw new IllegalArgumentException("PeriodicCommandEngineAdapter.deriveParameterTypesFromParameters() --> The parameter list contains a null value, such ambigious types are not allowed.");
			parameterTypes[n] = initArgs[n] == null ? java.lang.Void.class : initArgs[n].getClass();
		}
		
		return parameterTypes;
	}

	@Override
	@SuppressWarnings("unchecked")
	public void serverEvent(ServerLifecycleEvent event) 
	{
		if (event.getEventType().equals(ServerLifecycleEvent.EventType.START)) 
		{
			initializeAndStartPeriodicCommands();
		}
	}

	public static void initializeAndStartPeriodicCommands() 
	{	
		TransactionContext transactionContext = TransactionContextFactory.get();
		TransactionContextMemento memento = transactionContext.getMemento();

		try
		{
			// set up a security realm for the commands
			String accessCode = null;
			String verifyCode = null;
			
			//Hdig and site vix are mutually exclusive,
			//if no Dicom config, potentially this is vix periodic processes (use ROI creds)
			if (DicomServerConfiguration.isConfigurationExist())
			{
				// set up a security realm for the commands
				DicomServerConfiguration config = DicomServerConfiguration.getConfiguration();
				accessCode = config.getAccessCodeString();
				verifyCode = config.getVerifyCodeString();
			}
			else
			{
				PeriodicCommandConfiguration perconfig = PeriodicCommandConfiguration.getConfiguration();
				
				if ((perconfig != null) && (perconfig.getAccessCode() != null) && (perconfig.getAccessCode() != null))
				{
					accessCode = perconfig.getAccessCode().getValue();
					verifyCode = perconfig.getVerifyCode().getValue();
				}
			}

			// Authenticate on the main thread.
			// Fortify change: check for null first
			// OLD: Principal principal = engineAdapter.authenticate(accessCode, verifyCode.getBytes());
			
			Principal principal = null;
			
			if(engineAdapter == null)
			{
				LOGGER.info("PeriodicCommandEngineAdapter.initializeAndStartPeriodicCommands() --> engineAdapter is null; thus 'principal' remains null.");
			}
			else
			{
				if ((accessCode != null) && (verifyCode != null)) {
					principal = engineAdapter.authenticate(accessCode, verifyCode.getBytes());
				}
			}
			
			// If a principal was returned, authentication was successful, so we can 
			// go ahead and start the periodic commands. If it's null, however, the 
			// credentials were invalid. 
			if (principal != null)
			{
				// Kick off each of the periodic commands...
				List<PeriodicCommandDefinition> commandDefinitions = PeriodicCommandConfiguration.getConfiguration().getCommandDefinitions();

                LOGGER.info("PeriodicCommandEngineAdapter.initializeAndStartPeriodicCommands() --> Attempting to start [{}] periodic command(s)", commandDefinitions.size());
				
				for (PeriodicCommandDefinition definition : commandDefinitions) 
				{
					initializePeriodicCommand(definition.getReturnClass(),
							definition.getCommandClassName(), 
							definition.getCommandParameters(),
							ScheduledPriorityQueueElement.Priority.NORMAL,
							Integer.parseInt(definition.getPeriodicDelayInterval())
							);
				}
			}
			else
			{
				// Send notification
				String subject = "Periodic command initialization failure: invalid service account credentials";
				String message = "The system was unable to start periodic commands because the service account credentials" +
								 " are invalid or can't be authenticated because of 'engineAdapter' was not set (thus null).";
				NotificationFacade.sendNotification(NotificationTypes.InvalidServiceAccountCredentials, subject, message);
			}
		}
		catch (Exception e)
		{
            LOGGER.warn("PeriodicCommandEngineAdapter.initializeAndStartPeriodicCommands() --> Exception starting periodic command(s): {}", e.getMessage());
		}
		finally
        {
              TransactionContextFactory.restoreTransactionContext(memento);
        }
	}


	@Override
	public void setServerAgnosticEngineAdapter(ServerAgnosticEngineAdapter engineAdapter) 
	{
		PeriodicCommandEngineAdapter.engineAdapter = engineAdapter;
	}

	public static PeriodicCommandEngineAdapter getSingletonInstance() 
	{
		return periodicCommandEngineAdapter;
	}
}
