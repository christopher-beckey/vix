/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Oct 14, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
package gov.va.med.server;

import gov.va.med.imaging.StackTraceAnalyzer;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;
import gov.va.med.logging.Logger;

/**
 * The central gateway of the server agnostic mechanism.  Components of Visa
 * register interest in events here.  Server-specific lifecycle classes send messages 
 * to this singleton.
 * This class also provides access to authentication/authorization services.
 * 
 * @author VHAISWBECKEC
 *
 */
public class ServerAdapterImpl 
implements ClusterEventAdapter, ServerAdapter
{
	private final static Logger LOGGER = Logger.getLogger(ServerAdapterImpl.class);
	
	private static ServerAdapterImpl singleton;
	private Set<ServerLifecycleListener> serverEventListeners = new HashSet<ServerLifecycleListener>();
	private Set<ClusterEventListener> clusterEventListeners = new HashSet<ClusterEventListener>();
	private ClusterMessageSender clusterMessageSender;
	private GlobalNamingServer globalNamingServer;
	private ServerAuthentication serverAuthentication;

	public static synchronized ServerAdapter getSingleton()
	{
		return singleton = singleton != null ? singleton : new ServerAdapterImpl();
	}
	
	/**
	 * 
	 */
	private ServerAdapterImpl()
	{
		LOGGER.info("ServerAdapterImpl() -> Instance created !!!");
		/*
		StackTraceAnalyzer stackAnalyzer = new StackTraceAnalyzer( (new Throwable()).getStackTrace() );
		
		LOGGER.info(
			"ServerAdapterImpl()--> Instance [" + this.hashCode() + "] of ServerAdapter has been created, probably by " + 
			stackAnalyzer.getFirstElementNotInPackage("gov.va.med.server") + 
			"' by class loader '" + this.getClass().hashCode() + "'." +
			"' of type '" + this.getClass().getClassLoader().getClass().getName() + "'.");
		*/
	}
	
	
	/**
	 * @return the logger
	 */
	public Logger getLogger()
	{
		return LOGGER;
	}

	/**
	 * Add a new listener (on the application side) that gets notified of cluster status changes.
	 * 
	 * @see gov.va.med.server.ClusterEventAdapter#addClusterEventListener(gov.va.med.server.ClusterEventListener)
	 */
	@Override
	public void addClusterEventListener(ClusterEventListener listener)
	{
		clusterEventListeners.add(listener);
	}

	/**
	 * Remove a listener (on the application side) that gets notified of cluster status changes.
	 * 
	 * @see gov.va.med.server.ClusterEventAdapter#removeClusterEventListener(gov.va.med.server.ClusterEventListener)
	 */
	@Override
	public void removeClusterEventListener(ClusterEventListener listener)
	{
		clusterEventListeners.remove(listener);
	}

	public void setClusterMessageSender(ClusterMessageSender sender)
	{
		if(sender == this.clusterMessageSender)
			return;		// silently ignore
		
		if(sender != null && clusterMessageSender != null)
		{
			LOGGER.warn("ServerAdapterImpl.setClusterMessageSender() --> Change cluster message sender request is ignored.");
			return;
		}
		
		if(sender == null && clusterMessageSender != null)
		{
			LOGGER.warn("ServerAdapterImpl.setClusterMessageSender() --> Set the cluster message sender to null: allowed but intentional?");
			return;
		}
		
		clusterMessageSender = sender;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.server.ServerAdapter#getClusterMessageSender()
	 */
	public ClusterMessageSender getClusterMessageSender()
	{
		return clusterMessageSender;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.server.ServerAdapter#getGlobalNamingServer()
	 */
	public GlobalNamingServer getGlobalNamingServer()
	{
		return this.globalNamingServer;
	}

	/**
	 * @param globalNamingServer the globalNamingServer to set
	 */
	public void setGlobalNamingServer(GlobalNamingServer globalNamingServer)
	{
		// disregard repetitive sets, avoid logging any changes
		if(globalNamingServer == this.globalNamingServer)
			return;
		
		// disallow resetting the global naming server
		if(globalNamingServer == null && this.globalNamingServer != null)
		{
			LOGGER.warn("ServerAdapterImpl.setGlobalNamingServer() --> Reset the global naming server to null request is ignored.");
		}
		else if(globalNamingServer != null && this.globalNamingServer != null)
		{
			LOGGER.info("ServerAdapterImpl.setGlobalNamingServer() --> Changing the global naming server after it has been set.");
			this.globalNamingServer = globalNamingServer;
		}
		else
		{
			LOGGER.info("ServerAdapterImpl.setGlobalNamingServer() --> Setting global naming server for the first time.");
			this.globalNamingServer = globalNamingServer;
		}
	}

	/**
	 * @return the serverAuthentication
	 */
	@Override
	public ServerAuthentication getServerAuthentication()
	{
		return this.serverAuthentication;
	}

	/**
	 * @param serverAuthentication the serverAuthentication to set
	 */
	@Override
	public void setServerAuthentication(ServerAuthentication serverAuthentication)
	{
		// disregard repetitive sets, avoid logging any changes
		if(serverAuthentication == this.serverAuthentication)
			return;
		
		// disallow resetting the global naming server
		if(serverAuthentication == null && this.serverAuthentication != null)
		{
			LOGGER.warn("ServerAdapterImpl.setServerAuthentication() --> Reset the serverAuthentication to null request is ignored.");
		}
		else if(serverAuthentication != null && this.serverAuthentication != null)
		{
			LOGGER.info("ServerAdapterImpl.setServerAuthentication() --> Changing the serverAuthentication after it has been set.");
			this.serverAuthentication = serverAuthentication;
		}
		else
		{
			LOGGER.info("ServerAdapterImpl.setServerAuthentication() --> Setting serverAuthentication for the first time.");
			this.serverAuthentication = serverAuthentication;
		}
	}


	/* (non-Javadoc)
	 * @see gov.va.med.server.ServerAdapter#addServerLifecycleListener(gov.va.med.server.ServerLifecycleListener)
	 */
	public void addServerLifecycleListener(ServerLifecycleListener listener)
	{
        LOGGER.info("ServerAdapterImpl.addServerLifecycleListener() --> Adding listener [{}]", listener.toString());
		serverEventListeners.add(listener);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.server.ServerAdapter#removeServerLifecycleListener(gov.va.med.server.ServerLifecycleListener)
	 */
	public void removeServerLifecycleListener(ServerLifecycleListener listener)
	{
        LOGGER.info("ServerAdapterImpl.removeServerLifecycleListener() --> Removing listener [{}]", listener.toString());
		serverEventListeners.remove(listener);
	}

	/**
	 * 
	 * @param event
	 */
	public void notifyClusterEventListeners(ClusterEvent event)
	{
		for(ClusterEventListener listener : clusterEventListeners)
			listener.clusterEvent(event);
	}
	
	private boolean serverStarted = false;
	/**
	 * Called from the server-specific adapters to notify us of a server event.
	 * @param applicationEvent
	 */
	public synchronized void serverLifecycleEvent(ServerLifecycleEvent applicationEvent)
	{
		if( applicationEvent.getEventType() == ServerLifecycleEvent.EventType.AFTER_START && !serverStarted)
		{
			serverStarted = true;
		}
		
		if( applicationEvent.getEventType() == ServerLifecycleEvent.EventType.AFTER_STOP && serverStarted)
		{
			serverStarted = false;
		}
		
		notifyServerLifecycleListeners(applicationEvent);
	}

	/**
	 * 
	 * @param event
	 */
	private void notifyServerLifecycleListeners(ServerLifecycleEvent event)
	{
        LOGGER.info("ServerAdapterImpl.notifyServerLifecycleListeners() --> Notifying server lifecycle listeners of event [{}]", event.toString());
		for(ServerLifecycleListener listener : serverEventListeners)
			listener.serverLifecycleEvent(event);
	}
	
	/**
	 * 
	 * @param msg
	 * @return
	 */
	public boolean sendMessageToCluster(Serializable msg)
	{
        LOGGER.info("ServerAdapterImpl.sendMessageToCluster() --> Sending message [{}] to cluster.", msg.toString());
		return clusterMessageSender.sendMessageToCluster(msg);
	}
}
