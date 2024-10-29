/**
 * 
 */
package gov.va.med.server.tomcat;

import gov.va.med.server.GlobalNamingServer;

import javax.management.AttributeNotFoundException;
import javax.management.InstanceNotFoundException;
import javax.management.MBeanException;
import javax.management.MBeanServer;
import javax.management.MBeanServerFactory;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.management.ReflectionException;

import org.apache.catalina.Server;
//import org.apache.catalina.ServerFactory;
import org.apache.catalina.core.StandardServer;

/**
 * @author vhaiswbeckec
 * 
 */
public class TomcatNamingServer 
implements GlobalNamingServer
{
	/* (non-Javadoc)
	 * @see gov.va.med.server.tomcat.GlobalNamingServer#getGlobalContext()
	 */
	public javax.naming.Context getGlobalContext()
	{
		//Server server = ServerFactory.getServer();
		Server server = getServer();
		javax.naming.Context globalContext = null; 

		if( (server != null) && (server instanceof StandardServer) )
			globalContext = ((StandardServer) server).getGlobalNamingContext();
		
		return globalContext;
	}
	
	public static Server getServer()
	{
		try
		{
			MBeanServer mBeanServer = MBeanServerFactory.findMBeanServer(null).get(0);
			ObjectName name = new ObjectName("Catalina","type","Server");
			return (Server)mBeanServer.getAttribute(name, "managedResource");
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

}
