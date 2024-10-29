package gov.va.med.imaging.tomcat.vistarealm;


import java.util.HashMap;

import javax.management.AttributeNotFoundException;
import javax.management.InstanceNotFoundException;
import javax.management.MBeanException;
import javax.management.MBeanServer;
import javax.management.MBeanServerFactory;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.management.ReflectionException;

import org.apache.catalina.Container;
import org.apache.catalina.Server;
import org.apache.catalina.Service;
import org.apache.catalina.core.StandardServer;
import gov.va.med.logging.Logger;

public class RealmAuthentication
{
    private HashMap<String, VistaAccessVerifyRealm> realms = null;
    
    private static final Logger logger = Logger.getLogger (RealmAuthentication.class);

    public RealmAuthentication()
    {
    	// TODO: Fix this! 
    	// For now, log in to the Realm
		realms = new HashMap<String, VistaAccessVerifyRealm>();
    	//StandardServer server = (StandardServer)ServerFactory.getServer();
    	StandardServer server = getServer();
    	
    	if (server != null) 
    	{
        	for (Service service : server.findServices())
        	{
        		addVistaRealmsToList(service);
        	}
    	}
    }
    
    
	public static StandardServer getServer()
	{
		try
		{
			MBeanServer mBeanServer = MBeanServerFactory.findMBeanServer(null).get(0);
			ObjectName name = new ObjectName("Catalina","type","Server");
			return (StandardServer) mBeanServer.getAttribute(name, "managedResource");
		}
		catch (MalformedObjectNameException e)
		{
			return null;
		}
		catch (MBeanException e)
		{
			return null;
		}
		catch (AttributeNotFoundException e)
		{
			return null;
		}
		catch (InstanceNotFoundException e)
		{
			return null;
		}
		catch (ReflectionException e)
		{
			return null;
		}
	
	}
	

    

	public void authenticate(String siteId, String accessCode, String verifyCode)
	{
    	// Try to log in to the configured site...
    	realms.get(siteId).authenticate(accessCode, verifyCode);
	}
	
	private void addVistaRealmsToList(Service service)
	{
		recurseContainers(service.getContainer());
	}

	private void recurseContainers(Container container)
	{
		try
		{
			Container[] childContainers = container.findChildren();
	
			for (Container childContainer : container.findChildren())
			{
				recurseContainers(childContainer);
			}
	
			if (container instanceof org.apache.catalina.core.StandardHost ||
				container instanceof org.apache.catalina.core.StandardEngine ||
				container instanceof org.apache.catalina.core.StandardService)
				return;
			
			if (container.getRealm() instanceof VistaAccessVerifyRealm)
			{
				VistaAccessVerifyRealm realm = (VistaAccessVerifyRealm) container.getRealm();
				if (!realms.containsKey(realm.getSiteNumber()))
				{
					realms.put(realm.getSiteNumber(), realm);
				}
			}
		}
		catch (Throwable t)
		{
			logger.error(t.getMessage(), t);
		}
	}
}
