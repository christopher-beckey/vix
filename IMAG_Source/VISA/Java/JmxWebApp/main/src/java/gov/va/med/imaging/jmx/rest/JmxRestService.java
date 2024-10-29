/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 18, 2012
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
package gov.va.med.imaging.jmx.rest;

import java.lang.management.ManagementFactory;
import java.lang.management.ThreadInfo;
import java.lang.management.ThreadMXBean;

import gov.va.med.imaging.jmx.rest.types.MBeanAttributeType;
import gov.va.med.imaging.jmx.rest.types.StackTraceElementType;
import gov.va.med.imaging.jmx.rest.types.StackTraceElementsType;
import gov.va.med.imaging.jmx.rest.types.ThreadInfoType;
import gov.va.med.imaging.jmx.rest.types.ThreadInfosType;

import javax.management.MBeanServer;
import javax.management.ObjectName;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

/**
 * @author VHAISWWERFEJ
 *
 */
@Path("jmx")
public class JmxRestService
{

	@GET
	@Path("threads")
	@Produces("application/xml")
	public ThreadInfosType getThreads()
	{
		
		ThreadMXBean threadBean = ManagementFactory.getThreadMXBean();
		
		ThreadInfo [] threads = threadBean.dumpAllThreads(true, true);
		ThreadInfoType [] result = new ThreadInfoType[threads.length];
		for(int i = 0; i < threads.length; i++)
		{
			ThreadInfo thread = threads[i];
			result[i] = new ThreadInfoType(thread.getThreadName(), 
					thread.getThreadId(), thread.getThreadState().name(),
					thread.getLockName(), thread.getLockOwnerId(),
					thread.getLockOwnerName());
		}
		return new ThreadInfosType(result);
	}
	
	@GET
	@Path("thread/{threadName}")
	@Produces("application/xml")
	public ThreadInfoType getThreadByName(
			@PathParam("threadName") String threadName)
	throws Exception
	{
		ThreadMXBean threadBean = ManagementFactory.getThreadMXBean();
		
		ThreadInfo [] threads = threadBean.dumpAllThreads(true, true);
		for(int i = 0; i < threads.length; i++)
		{
			ThreadInfo thread = threads[i];
			if(threadName.equals(thread.getThreadName()))
			{
				return new ThreadInfoType(thread.getThreadName(), 
						thread.getThreadId(), thread.getThreadState().name(),
						thread.getLockName(), thread.getLockOwnerId(),
						thread.getLockOwnerName());
			}
		}
		throw new Exception("Thread '" + threadName + "' not found.");
	}
	
	@GET
	@Path("thread/stack/name/{threadName}")
	@Produces("application/xml")
	public StackTraceElementsType getThreadStackTraceByName(
			@PathParam("threadName") String threadName)
	throws Exception
	{
		ThreadMXBean threadBean = ManagementFactory.getThreadMXBean();
		ThreadInfo [] threads = threadBean.dumpAllThreads(true, true);
		for(int i = 0; i < threads.length; i++)
		{
			ThreadInfo threadInfo = threads[i];
			if(threadName.equals(threadInfo.getThreadName()))
			{
				StackTraceElement [] stackTraceElements = threadInfo.getStackTrace();
				StackTraceElementType [] result = new StackTraceElementType[stackTraceElements.length];
				for(int j = 0; j < stackTraceElements.length; j++)
				{
					StackTraceElement element = stackTraceElements[j];
					result[j] = new StackTraceElementType(element.getClassName(), 
							element.getMethodName(), element.getFileName(), element.getLineNumber());
				}
				return new StackTraceElementsType(result);
			}
		}
		throw new Exception("Thread '" + threadName + "' not found.");
	}
	
	@GET
	@Path("thread/stack/id/{threadId}")
	@Produces("application/xml")
	public StackTraceElementsType getThreadStackTraceById(
			@PathParam("threadId") long threadId)
	{
		ThreadMXBean threadBean = ManagementFactory.getThreadMXBean();
		ThreadInfo threadInfo = threadBean.getThreadInfo(threadId, Integer.MAX_VALUE);
		StackTraceElement [] stackTraceElements = threadInfo.getStackTrace();
		StackTraceElementType [] result = new StackTraceElementType[stackTraceElements.length];
		for(int i = 0; i < stackTraceElements.length; i++)
		{
			StackTraceElement element = stackTraceElements[i];
			result[i] = new StackTraceElementType(element.getClassName(), 
					element.getMethodName(), element.getFileName(), element.getLineNumber());
		}
		return new StackTraceElementsType(result);
	}
	
	@GET
	@Path("mbean/{objectName}/{attribute}")
	@Produces("application/xml")
	public MBeanAttributeType getJmxValue(
			@PathParam("objectName") String objectNameString,
			@PathParam("attribute") String attribute)
	throws Exception
	{
		MBeanServer server = java.lang.management.ManagementFactory.getPlatformMBeanServer();
		
		//java.lang.management.ManagementFactory.newPlatformMXBeanProxy(connection, mxbeanName, mxbeanInterface)
		//Catalina:type=RequestProcessor,worker=http-8080,name=HttpRequest1
		
		//ObjectName objectName = new ObjectName(domain, table);
		ObjectName objectName = new ObjectName(objectNameString);//"Catalina:type=RequestProcessor,worker=http-8080,name=HttpRequest1");
		Object attributeValue = server.getAttribute(objectName, attribute);// "workerThreadName");
		if(attributeValue == null)
			return new MBeanAttributeType("");
		return new MBeanAttributeType(attributeValue.toString());
	}
}
