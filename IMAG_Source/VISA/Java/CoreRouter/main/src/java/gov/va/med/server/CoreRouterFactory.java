package gov.va.med.server;

import gov.va.med.imaging.ImagingMBean;
import gov.va.med.imaging.core.interfaces.router.RouterStatisticsAdvice;
import gov.va.med.server.ServerLifecycleEvent.EventType;

import java.lang.management.ManagementFactory;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.management.DynamicMBean;
import javax.management.MBeanException;
import javax.management.MBeanServer;
import javax.management.ObjectName;
import javax.naming.Context;
import javax.naming.Name;
import javax.naming.RefAddr;
import javax.naming.Reference;
import javax.naming.spi.ObjectFactory;

import gov.va.med.logging.Logger;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * This class implements the JNDI SPI ObjectFactory interface, providing 
 * a way to create Router and AppConfiguration instances and make them 
 * available as Resources.
 * The app server may create many copies of the class, however only one instance
 * of the application context (and consequently the router and app configuration)
 * should be created.  To accomplish this, the application context reference (Spring) 
 * is a static.  References to the beans managed by Spring (Router and App Configuration)
 * are managed by the Spring context as singletons.  The result is that the creation
 * of Router and App Configuration as Singleton or Prototype is defined in the Spring context.
 * 
 * @author VHAISWBECKEC
 *
 */
public class CoreRouterFactory
implements ObjectFactory
{
	public static final String LIFECYCLE_ADAPTER_BEAN_NAME = "serverLifecycleAdapter";
	public static final String CORE_ROUTER_BEAN_NAME = "router";
	public static final String COMMAND_FACTORY_BEAN_NAME = "commandFactory";
	public static final String ROUTER_STATISTICS_BEAN_NAME = "routerStatisticsAdvice";
	public static final String APPLICATION_CONFIGURATION_BEAN_NAME = "appConfiguration";
	public static final String[] CONTEXT_FILENAMES = new String[]{"coreContext.xml"};
	
	private static final Logger logger = Logger.getLogger(CoreRouterFactory.class);
	private static ApplicationContext coreApplicationContext;
	
	public CoreRouterFactory() {}
	
	/**
	 * If we are running in an app server (which is the only reason we'd be using this class)
	 * then we MUST get cache manager references through this method so that the manager
	 * will properly get the app server lifecycle messages.
	 * 
	 * @return
	 * @throws MBeanException
	 * @throws CacheException
	 */
	private synchronized static ApplicationContext getApplicationContext() 
	{
		if(coreApplicationContext == null)
		{
			coreApplicationContext = new ClassPathXmlApplicationContext( CONTEXT_FILENAMES );
            logger.info("CoreRouterFactory.getApplicationContext() --> Core VIX context [{}] created.", coreApplicationContext.hashCode());
			
			// get a reference to the server specific lifecycle listener as a server-agnostic
			// reference and then register ourselves as interested in lifecycle events
			// NOTE: there is a bit of strangeness with what is a static reference
			// versus the instance references.  This arises from the fact that Tomcat is creating
			// multiple instances of this factory but we want one real instance to manage
			// creation correctly.
			try
            {
	            // register ourselves as a server lifecycle listener
	            // we'll get messages when the server is starting up or shutting
	            // down
				ServerAdapterImpl.getSingleton().addServerLifecycleListener(
		            new ServerLifecycleListener()
		            {
						@Override
	                    public void serverLifecycleEvent(ServerLifecycleEvent event)
	                    {
							// this instance delegates to the static serverLifecycleEvent
							// method
							CoreRouterFactory.serverLifecycleEvent(event);
	                    }
		            }
		        );
	            
	            //registerResourceMBeans();
            } 
			catch (BeansException bX)
            {
				StringBuffer sb = new StringBuffer();
				sb.append("CoreRouterFactory.getApplicationContext() --> Unable to obtain a reference to the bean named [");
				sb.append(LIFECYCLE_ADAPTER_BEAN_NAME);
				sb.append("], check the context files [");
				for(String contextFilename : CONTEXT_FILENAMES)
					sb.append(contextFilename + " ");
				sb.append("]");
				
				logger.error(sb.toString());
				throw bX;
            }
		}
		
		return coreApplicationContext;
	}
	
	/**
	 * Receives notification of server lifecycle events (START and STOP)
	 * @see gov.va.med.server.ServerLifecycleListener#serverLifecycleEvent(gov.va.med.server.ServerLifecycleEvent)
	 */
    private static void serverLifecycleEvent(ServerLifecycleEvent event)
    {
    	if( event.getEventType() == EventType.START )
        	logger.info("CoreRouterFactory.serverLifecycleEvent() --> START event received !!!");
    	else if( event.getEventType() == EventType.STOP )
        	logger.info("CoreRouterFactory.serverLifecycleEvent() --> STOPT event received !!!");
    }

	
	/**
	 * 
	 * @return
	 * @throws MBeanException
	 */
	private static synchronized gov.va.med.imaging.core.interfaces.Router getRouter() 
	{
		ApplicationContext appContext = getApplicationContext();
		
		String msg = "CoreRouterFactory.getRouter() --> " + 
			(appContext == null ? "failed to obtain" : "obtained") + 
			" a reference to APPLICATION context when getting router";
		logger.info(msg);
		
		gov.va.med.imaging.core.interfaces.Router router = 
			(gov.va.med.imaging.core.interfaces.Router)appContext.getBean(CORE_ROUTER_BEAN_NAME);
		
		msg = "CoreRouterFactory.getRouter() --> " + 
			(router == null ? "failed to obtain" : "obtained") + 
			" a reference to ROUTER from application context." + 
			"Router implementation is of type [" + (router == null ? "<null>" : router.getClass().getName()) + "]";
		logger.info(msg);

		gov.va.med.imaging.core.interfaces.router.RouterStatisticsAdvice routerStatistics = 
			(gov.va.med.imaging.core.interfaces.router.RouterStatisticsAdvice)appContext.getBean(ROUTER_STATISTICS_BEAN_NAME);
		registerRouterStatisticsMBean(routerStatistics);
		
		return router;
	}
	
	/**
	 * @return
	 */
	private static synchronized gov.va.med.imaging.core.interfaces.router.CommandFactory getCommandFactory()
	{
		ApplicationContext appContext = getApplicationContext();
		
		String msg = "CoreRouterFactory.getCommandFactory() --> " + 
		(appContext == null ? "failed to obtain" : "obtained") + 
		" a reference to APPLICATION context when getting command factory";
		logger.info(msg);
	
		gov.va.med.imaging.core.interfaces.router.CommandFactory commandFactory = 
			(gov.va.med.imaging.core.interfaces.router.CommandFactory)appContext.getBean(COMMAND_FACTORY_BEAN_NAME);
		
		msg = CoreRouterFactory.class.getSimpleName() + 
			(commandFactory == null ? 
			" failed to obtain a reference to command factory from application context" : 
			" obtained a reference to command factory of type [" + commandFactory.getClass().getName() + "]" 
			);
		logger.info(msg);
	
		return commandFactory;
	}
	
	private static ObjectName routerStatisticsMBeanName = null;
	/**
	 * This method should only be called once, else MBean exceptions will occur.
	 * @param routerStatistics 
	 */
	private static synchronized void registerRouterStatisticsMBean(RouterStatisticsAdvice routerStatistics)
    {
		if(routerStatisticsMBeanName != null)
			return;
		
		MBeanServer mBeanServer = ManagementFactory.getPlatformMBeanServer();
		
		if(routerStatistics instanceof DynamicMBean)
		{
			try
            {
				// VistaImaging.ViX:type=Cache,name=ImagingExchangeCache
				Hashtable<String, String> mBeanProperties = new Hashtable<String, String>();
				mBeanProperties.put( "type", "RouterStatistics" );
				mBeanProperties.put( "name", Integer.toHexString(routerStatistics.hashCode()) );
				routerStatisticsMBeanName = new ObjectName(ImagingMBean.VIX_MBEAN_DOMAIN_NAME, mBeanProperties);
	            mBeanServer.registerMBean(routerStatistics, routerStatisticsMBeanName);
            } 
			catch (Exception e){ Logger.getLogger(CoreRouterFactory.class).error(e.toString()); }
		}
    }
	
	/**
	 * 
	 * @return
	 */
	private static synchronized gov.va.med.imaging.core.interfaces.IAppConfiguration getApplicationConfiguration() 
	{
		ApplicationContext appContext = getApplicationContext();
		
		String msg = "CoreRouterFactory.getApplicationConfiguration() --> " + 
			(appContext == null ? " failed to obtain" : " obtained") + 
			" a reference to application CONTEXT when getting application configuration.";
		logger.info(msg);
		
		
		gov.va.med.imaging.core.interfaces.IAppConfiguration applicationConfiguration = 
			(gov.va.med.imaging.core.interfaces.IAppConfiguration)appContext.getBean(APPLICATION_CONFIGURATION_BEAN_NAME);
		
		msg = "CoreRouterFactory.getApplicationConfiguration() --> " + 
			(applicationConfiguration == null ? " failed to obtain" : " obtained") + 
			" a reference to application CONFIGURATION from application context.";
		logger.info(msg);
	
		return applicationConfiguration;
	}
	
	/**
     * @param obj The possibly null object containing location or
     *  reference information that can be used in creating an object
     * @param name The name of this object relative to <code>nameCtx</code>
     * @param nameCtx The context relative to which the <code>name</code>
     *  parameter is specified, or <code>null</code> if <code>name</code>
     *  is relative to the default initial context
     * @param environment The possibly null environment that is used in
     *  creating this object
     *  
     *  For the following element in server.xml:
     * <Resource
     * auth="Container"
     * description="Core application (Spring) context"
     * name="CoreRouterContext"
     * type="org.springframework.context.ApplicationContext"
     * instance-name="CoreRouterContext"
     * factory="gov.va.med.server.tomcat.CoreRouterContextFactory"
     * />
     *  
     *  nameCts = 'org.apache.naming.NamingContext@787d6a'
     *  name.toString = 'ImagingExchangeCache'
     *  
     *  Reference factory classname[org.apache.naming.factory.ResourceFactory],  factory class location [null]
     *  RefAddr type [description] = [Caching mechanism for ViXS]
     *  RefAddr type [scope] = [Shareable]
     *  RefAddr type [auth] = [Container]
     *  RefAddr type [factory] = [gov.va.med.imaging.storage.cache.impl.tomcat.CacheFactory]
     *  
     *  javax.naming.Name [.ImagingExchangeCache]
	 */
	public Object getObjectInstance(
			Object obj, 
			Name name, 
			Context nameCtx, 
			Hashtable<?, ?> environment
	) 
	throws Exception
	{
        // We only know how to deal with <code>javax.naming.Reference</code>s
        // that specify a class name of "gov.va.med.imaging.storage.cache.Cache"
        if( (obj == null) || !(obj instanceof Reference) )
            return null;

        // The JNDI defines the Reference class to represent reference. 
        // A reference contains information on how to construct a copy of the object. 
        // The JNDI will attempt to turn references looked up from the directory into the Java objects that they 
        // represent so that JNDI clients have the illusion that what is stored in the directory are Java objects.
        Reference ref = (Reference) obj;
        
        // Best guess; the properties of the Reference instance come from the server.xml file, Resource element:
        // <Resource
        // auth="Container"
        // description="Core application (Spring) context"
        // name="CoreRouterContext"
        // type="org.springframework.context.ApplicationContext"
        // instance-name="CoreRouterContext"
        // factory="gov.va.med.server.tomcat.CoreRouterContextFactory"/>

        logger.info("CoreRouterFactory.getObjectInstance() --> Reference {}], [{}] ", name.toString(), nameCtx.toString());
        logger.info("CoreRouterFactory.getObjectInstance() --> Begin Reference contents ====================== ");
        logger.info(dumpReferenceContents(ref));
        logger.info("CoreRouterFactory.getObjectInstance() --> End   Reference contents ====================== ");
        
        //System.out.println(dumpName(name));
		String resourceName = name.toString();
		
		// this reference will contain the reference that is being requested
    	Object implementation = null;

        logger.info("CoreRouterFactory.getObjectInstance() -->  getting reference to [{}], expected type is [{}]", resourceName, ref.getClassName());

		// The router implementation is determined by the Spring context
        if( gov.va.med.imaging.core.interfaces.Router.class.getName().equals(ref.getClassName()) )
        {
    		implementation = getRouter();
        }
        
        // The command factory may be substituted by changing the context.xml (Spring context) file.
        else if(gov.va.med.imaging.core.interfaces.router.CommandFactory.class.getName().equals(ref.getClassName()))
        {
    		implementation = getCommandFactory();
        }
        
        else if( gov.va.med.imaging.core.interfaces.IAppConfiguration.class.getName().equals(ref.getClassName()) )
        {
        	implementation = getApplicationConfiguration();
        }

        logger.warn("CoreRouterFactory.getObjectInstance() --> reference to [{}] is [{}", resourceName, implementation == null ? "null" : implementation.getClass().getName() + "]");
    	
    	return implementation;
	}

	public String dumpReferenceContents(Reference ref)
	{
		StringBuilder sb = new StringBuilder();

		sb.append("Reference classname[" + ref.getClassName() + "]\n");
		sb.append("Reference factory classname[" + ref.getFactoryClassName() + 
				"],  factory class location [" + ref.getFactoryClassLocation() + "]\n");
		
		for( Enumeration<RefAddr> enumRefAddr = ref.getAll(); enumRefAddr.hasMoreElements(); )
		{
			RefAddr refAddr = enumRefAddr.nextElement();
			sb.append("  RefAddr type [" + refAddr.getType() + "] = [" + refAddr.getContent().toString() + "]\n");
		}
		
		return sb.toString();
	}
}
