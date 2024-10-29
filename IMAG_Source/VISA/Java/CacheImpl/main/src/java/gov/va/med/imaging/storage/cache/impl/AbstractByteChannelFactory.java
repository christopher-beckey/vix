/**
 * 
 */
package gov.va.med.imaging.storage.cache.impl;


import gov.va.med.imaging.StackTraceAnalyzer;
import gov.va.med.imaging.channels.ChecksumFactory;
import gov.va.med.imaging.storage.cache.*;
import gov.va.med.imaging.storage.cache.exceptions.CacheStateException;
import gov.va.med.imaging.storage.cache.memento.ByteChannelFactoryMemento;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.management.*;
import javax.management.openmbean.*;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWBECKEC
 *
 * A factory class that provides some management of instance file channels.
 * 
 */
public abstract class AbstractByteChannelFactory<T> 
implements DynamicMBean, CacheLifecycleListener
{
	private final static Logger LOGGER = Logger.getLogger(AbstractByteChannelFactory.class);
	
	public static final long defaultMaxChannelOpenDuration = 300000L;	// default to 5 minutes (for remote jukeboxes)
	public static final long defaultSweepTime = 10000L;
	public static final boolean defaultTraceChannelInstantiation = true;
	public static final String defaultChecksumAlgorithmName = "Adler32";
	
	private DateFormat df = new SimpleDateFormat("ddMMMyyyy hh:mm:ss");
	private long maxChannelOpenDuration = defaultMaxChannelOpenDuration;
	private long sweepTime = defaultSweepTime;
	private boolean traceChannelInstantiation = defaultTraceChannelInstantiation;
	private String checksumClassName;
	private ChannelCleanupThread cleanupThread;
	
	/**
	 * 
	 * @param memento
	 */
	protected AbstractByteChannelFactory(ByteChannelFactoryMemento memento)
	{
		this(
			memento == null ? defaultMaxChannelOpenDuration : memento.getMaxChannelOpenDuration(), 
			memento == null ? defaultSweepTime : memento.getSweepTime(),
			memento == null ? null : memento.getChecksumAlgorithmName()
		);
	}
	
	/**
	 * 
	 * @param maxChannelOpenDuration - the maximum time a channel is allowed to be open
	 * @param sweepTime - the delay in the background thread that looks for open channels
	 */
	protected AbstractByteChannelFactory(Long maxChannelOpenDuration, Long sweepTime, String checksumClassname)
	{
		setMaxChannelOpenDuration(maxChannelOpenDuration == null ? defaultMaxChannelOpenDuration : maxChannelOpenDuration.longValue());
		setSweepTime(sweepTime == null ? defaultSweepTime : sweepTime.longValue());
		setChecksumClassname(checksumClassname);
	}

	/**
	 * @return the log
	 */
	public Logger getLogger()
	{
		return LOGGER;
	}

	// ==================================================================================================
	// InstanceByteChannelFactory Implementation
	// Behavioral Modification Methods
	// ==================================================================================================
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.filesystem.InstanceByteChannelFactoryImplMBean#getMaxChannelOpenDuration()
	 */
	public long getMaxChannelOpenDuration()
	{
		return maxChannelOpenDuration;
	}
	public void setMaxChannelOpenDuration(long maxChannelOpenDuration)
	{
		if(maxChannelOpenDuration > 0L)
			this.maxChannelOpenDuration = maxChannelOpenDuration;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.filesystem.InstanceByteChannelFactoryImplMBean#getSweepTime()
	 */
	public long getSweepTime()
	{
		return sweepTime;
	}
	public void setSweepTime(long sweepTime)
	{
		if(sweepTime > 0L)
			this.sweepTime = sweepTime;
	}

	public void setChecksumClassname(String checksumClassName)
	{
		try
		{
			if( checksumClassName == null || ChecksumFactory.getFactory().get(checksumClassName) != null )
				this.checksumClassName = checksumClassName;
			else
                LOGGER.warn("AbstractByteChannelFactory.setChecksumClassname() --> Specified checksum [{}] is not a known algorithm and is not a class name found on the classpath.", checksumClassName);
		} 
		catch (Exception x)
		{
            LOGGER.warn("AbstractByteChannelFactory.setChecksumClassname() --> Unable to use specified checksum [{}]", checksumClassName);
		} 
	}
	
	public String getChecksumClassname()
	{
		return checksumClassName;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.filesystem.InstanceByteChannelFactoryImplMBean#getCurrentlyOpenReadableByteChannels()
	 */
	public int getCurrentlyOpenReadableByteChannels()
	{
		return openReadChannels.size();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.filesystem.InstanceByteChannelFactoryImplMBean#getCurrentlyOpenWritableByteChannels()
	 */
	public int getCurrentlyOpenWritableByteChannels()
	{
		return openWriteChannels.size();
	}

	/**
	 * If traceChannelInstantiation is set then the factory will record
	 * the stack trace when a channel is instantiated and report the stack
	 * trace when the channel is closed due to a timeout. 
	 * 
	 * @return
	 */
	public boolean isTraceChannelInstantiation()
	{
		return this.traceChannelInstantiation;
	}

	public void setTraceChannelInstantiation(boolean traceChannelInstantiation)
	{
		this.traceChannelInstantiation = traceChannelInstantiation;
	}

	// =============================================================================================================================
	// Open Read/Write Channels list management.
	// All access to these maps should go through the calls provided below so that correct
	// synchronization may be provided.
	// =============================================================================================================================
	private Map<InstanceWritableByteChannel, InstanceByteChannelListener> openWriteChannels = 
		Collections.synchronizedMap( new HashMap<InstanceWritableByteChannel, InstanceByteChannelListener>() );
	private Map<InstanceReadableByteChannel, InstanceByteChannelListener> openReadChannels = 
		Collections.synchronizedMap( new HashMap<InstanceReadableByteChannel, InstanceByteChannelListener>() );
	
	/**
	 * @return the openWriteChannels
	 */
	protected Map<InstanceWritableByteChannel, InstanceByteChannelListener> getOpenWriteChannels()
	{
		return this.openWriteChannels;
	}

	/**
	 * @return the openReadChannels
	 */
	protected Map<InstanceReadableByteChannel, InstanceByteChannelListener> getOpenReadChannels()
	{
		return this.openReadChannels;
	}

	protected void putWritableChannel(InstanceWritableByteChannel writable, InstanceByteChannelListener listener)
	{
		openWriteChannels.put(writable, listener);
	}

	protected void putReadableChannel(InstanceReadableByteChannel readable, InstanceByteChannelListener listener)
	{
		openReadChannels.put(readable, listener);
	}
	
	/**
	 * Look through our internal list of open writable channels and return a
	 * reference to the byte channel that is open on the given file,
	 * or return null if not open.
	 * 
	 * @param instanceFile
	 * @return
	 */
	abstract protected InstanceWritableByteChannel getOpenWritableByteChannel(T instanceFile);
	
	/**
	 * Look through our internal list of open readable channels and return a
	 * reference to the byte channel that is open on the given file,
	 * or return null if not open.
	 * 
	 * @param instanceFile
	 * @return
	 */
	abstract protected InstanceReadableByteChannel getOpenReadableByteChannel(T instanceFile);
	
	// ==================================================================================================
	// InstanceByteChannelFactory Implementation
	// Statistics Gathering Methods
	// ==================================================================================================
	/**
	 * This is NOT an idempotent method, it REMOVES the writable map entry.
	 * 
	 * @param writable
	 */
	private void notifyTimeoutWritableChannelListeners(InstanceWritableByteChannel writable)
	{
		writableByteChannelClosed(writable, true);
	}
	
	/**
	 * This is NOT an idempotent method, it REMOVES the readable map entry.
	 * 
	 * @param readable
	 */
	private void notifyTimeoutReadableChannelListeners(InstanceReadableByteChannel readable)
	{
		readableByteChannelClosed(readable, true);
	}
	
	
	/**
	 * Any should call this to remove the writable byte channel,
	 * else the listeners will get timeout signals. 
	 * 
	 * NOTE: it would be better if this method were protected and the bytes channels
	 * were "friend" classes but this isn't C++, so we declare them public.
	 * 
	 * @param writable
	 */
	public void writableByteChannelClosed(InstanceWritableByteChannel writable, boolean errorClose)
	{
		InstanceByteChannelListener listener = openWriteChannels.get(writable);
		openWriteChannels.remove(writable);
		
		if(listener != null)
		{
			if(errorClose)
				listener.writeChannelIdleTimeout(writable);
			else
				listener.writeChannelClose(writable);
		}
	}
	/**
	 * A 'normal' close should call this to remove the readable byte channel,
	 * else the listeners will get timeout signals. 
	 * 
	 * NOTE: it would be better if this method were protected and the bytes channels
	 * were "friend" classes but this isn't C++, so we declare them public.
	 * 
	 * @param readable
	 */
	public void readableByteChannelClosed(InstanceReadableByteChannel readable, boolean errorClose)
	{
		InstanceByteChannelListener listener = openReadChannels.get(readable);
		openReadChannels.remove(readable);
		
		if(listener != null)
		{
			if(errorClose)
				listener.readChannelIdleTimeout(readable);
			else
				listener.readChannelClose(readable);
		}
	}
	
	// ==========================================================================================
	// State persistence implementation
	// ==========================================================================================
	/**
	 * Create a Serializable representation of our state that may be
	 * used later to recreate our state.
	 * 
	 * @return
	 */
	public ByteChannelFactoryMemento createMemento()
	{
		ByteChannelFactoryMemento memento = new ByteChannelFactoryMemento();
		
		memento.setMaxChannelOpenDuration(getMaxChannelOpenDuration());
		memento.setSweepTime(getSweepTime());
		memento.setChecksumAlgorithmName(getChecksumClassname());
		
		return memento;
	}

	public void restoreMemento(ByteChannelFactoryMemento memento)
	{
		setMaxChannelOpenDuration( memento.getMaxChannelOpenDuration() );
		setSweepTime( memento.getSweepTime() );
		setChecksumClassname(memento.getChecksumAlgorithmName());
	}
	
	// ===============================================================================================
	// CacheLifecycleListener 
	// ===============================================================================================
	public void cacheLifecycleEvent(CacheLifecycleEvent event) throws CacheStateException
	{
		if(event == CacheLifecycleEvent.START)
		{
			if(this.sweepTime > 0L && this.maxChannelOpenDuration > 0L)
			{
				cleanupThread = new ChannelCleanupThread();
				cleanupThread.start();
			}
		}
		else if (event == CacheLifecycleEvent.STOP)
		{
			if(cleanupThread != null)
				cleanupThread.kill();
		}
	}

	// ===============================================================================================
	// JMX (management) related methods (DynamicMBean implementation)
	// ===============================================================================================
	
	/**
	 * @see javax.management.DynamicMBean#getMBeanInfo()
	 */
	private MBeanInfo openMBeanInfo;
	public synchronized MBeanInfo getMBeanInfo()
	{
		if(openMBeanInfo == null)
		{
			openMBeanInfo = new OpenMBeanInfoSupport(
					getClass().getName(),
                    "Byte channel factory for file system based cache implementations.",
                    new OpenMBeanAttributeInfo[] 
                    {
						new OpenMBeanAttributeInfoSupport("maxChannelOpenDuration", "Maximum time in milliseconds between channel usage", SimpleType.LONG, true, true, false),
						new OpenMBeanAttributeInfoSupport("sweepTime", "Time to delay between sweeping open channels", SimpleType.LONG, true, true, false),
						new OpenMBeanAttributeInfoSupport("traceChannelInstantiation", "Trace the code that opened channels", SimpleType.BOOLEAN, true, true, true),
						new OpenMBeanAttributeInfoSupport("checksumClassName", "The class or algorithm name for checksum calculation", SimpleType.STRING, true, true, false),
						new OpenMBeanAttributeInfoSupport("openReadableByteChannels", "Number of read channels currently open", SimpleType.INTEGER, true, false, false),
						new OpenMBeanAttributeInfoSupport("openWritableByteChannels", "Number of write channels currently open", SimpleType.INTEGER, true, false, false)
                    },
                    new OpenMBeanConstructorInfo[]{},
                    new OpenMBeanOperationInfo[]{},
                    new MBeanNotificationInfo[]{}
			);
		}
		
		return openMBeanInfo;
	}

	/**
	 * @see javax.management.DynamicMBean#getAttribute(java.lang.String)
	 */
	public Object getAttribute(String attribute) 
	throws AttributeNotFoundException, MBeanException, ReflectionException
	{
		if( "maxChannelOpenDuration".equals(attribute) )
			return new Long(getMaxChannelOpenDuration());
		else if( "sweepTime".equals(attribute) )
			return new Long(getSweepTime());
		else if( "traceChannelInstantiation".equals(attribute) )
			return new Boolean(isTraceChannelInstantiation());
		else if( "checksumClassName".equals(attribute) )
			return getChecksumClassname();
		else if( "openReadableByteChannels".equals(attribute) )
			return new Integer(getCurrentlyOpenReadableByteChannels());
		else if( "openWritableByteChannels".equals(attribute) )
			return new Integer(getCurrentlyOpenWritableByteChannels());
		else
		{
			String msg = "AbstractByteChannelFactory.getAttribute() --> Attribute [" + attribute + "] not found";
			LOGGER.error(msg);
			throw new AttributeNotFoundException(msg);
		}
	}

	/**
	 * @see javax.management.DynamicMBean#getAttributes(java.lang.String[])
	 */
	public AttributeList getAttributes(String[] attributes)
	{
		AttributeList list = new AttributeList();
		
		for(String attribute : attributes)
			try
			{
				list.add( new Attribute(attribute, getAttribute(attribute)) );
			} 
			catch (Exception x)
			{
                LOGGER.warn("AbstractByteChannelFactory.getAttributes() --> Encountered an exception: {}", x.getMessage());
			} 
		return list;
	}

	/**
	 * @see javax.management.DynamicMBean#setAttribute(javax.management.Attribute)
	 */
	public void setAttribute(Attribute attribute) 
	throws AttributeNotFoundException, InvalidAttributeValueException, MBeanException, ReflectionException
	{
		try
		{
			if( "maxChannelOpenDuration".equals(attribute.getName()) )
				setMaxChannelOpenDuration( (Long)attribute.getValue() );
			else if( "sweepTime".equals(attribute.getName()) )
				setSweepTime( (Long)attribute.getValue() );
			else if( "traceChannelInstantiation".equals(attribute.getName()) )
				setTraceChannelInstantiation( (Boolean)attribute.getValue() );
			else if( "checksumClassName".equals(attribute.getName()) )
				setChecksumClassname((String)attribute.getValue() );
			else
			{
				String msg = "AbstractByteChannelFactory.getAttribute() --> Attribute [" + attribute + "] not found";
				LOGGER.error(msg);
				throw new AttributeNotFoundException("AbstractByteChannelFactory.setAttributes() --> Attribute [" + attribute + "] not found.");
			}
		} 
		catch (ClassCastException x)
		{
			String msg = "AbstractByteChannelFactory.setAttributes() --> Attribute [" + attribute + "] value was of incorrect type: " + x.getMessage();
			LOGGER.error(msg); 
			throw new InvalidAttributeValueException(msg);
		}
	}

	/**
	 * @see javax.management.DynamicMBean#setAttributes(javax.management.AttributeList)
	 */
	public AttributeList setAttributes(AttributeList attributes)
	{
		for(int index = 0; index < attributes.size(); ++index)
		{
			Attribute attribute = (Attribute)attributes.get(index);
			
			try
			{
				setAttribute(attribute);
			} 
			catch (Exception x)
			{
                LOGGER.warn("AbstractByteChannelFactory.setAttributes() --> Encountered an exception: {}", x.getMessage());
			} 
		}
		
		return attributes;
	}
	
	/**
	 * @see javax.management.DynamicMBean#invoke(java.lang.String, java.lang.Object[], java.lang.String[])
	 */
	public Object invoke(String actionName, Object[] params, String[] signature) 
	throws MBeanException, ReflectionException
	{
		return null;
	}

	// ===============================================================================================
	// The thread that monitors and cleans up channels that have been left hanging
	// ===============================================================================================
	/**
	 * 
	 * @author VHAISWBECKEC
	 *
	 */
	class ChannelCleanupThread 
	extends Thread
	{
		private boolean running = true;
		
		ChannelCleanupThread()
		{
			this.setDaemon(true);
		}
		
		public void kill()
		{
			this.running = false;
			this.interrupt();
		}

		@Override
		public void run()
		{
			while(running)
			{
				long minOpenTime = System.currentTimeMillis() - getMaxChannelOpenDuration();

                LOGGER.info("ChannelCleanupThread.run() --> Sweeping write channels open before time [{}]", df.format(minOpenTime));
				
				try
				{
					List<InstanceWritableByteChannel> writeChannelKillList = new ArrayList<InstanceWritableByteChannel>();
					try
					{
						// do the kill/close in two loops to avoid concurrent modification exceptions
						for( InstanceWritableByteChannel writeChannel:openWriteChannels.keySet() )
						{
							if( writeChannel.getLastAccessedTime() < minOpenTime )
							{
                                LOGGER.warn("ChannelCleanupThread.run() --> Writable Byte Channel [{}] has remained open past the maximum allowable, forcing close!", writeChannel.toString());
								writeChannelKillList.add(writeChannel);
								
								if(isTraceChannelInstantiation() && writeChannel instanceof TracableComponent)
								{
									StackTraceElement[] instantiatingStackTrace = 
										((TracableComponent)writeChannel).getInstantiatingStackTrace();
									warnInstantiatingStackTrace(instantiatingStackTrace);
								}
							}
						}
					}
					catch(ConcurrentModificationException cmX)
					{
						// note that if we get a concurrent modification (i.e. another thread is opening or closing readable channels)
						// then log it but don't fail 'cause we can always close the channel later
						LOGGER.warn("ChannelCleanupThread.run() --> Concurrent modification exception while iterating open WRITE channels. Some overdue channels may not be closed immediately.");
					}

                    LOGGER.info("ChannelCleanupThread.run() --> Closing [{}] write channels due to inactivity timeout", writeChannelKillList.size());
					for(InstanceWritableByteChannel deadChannel:writeChannelKillList)
					{
						try
						{
							deadChannel.error();
						} 
						catch (IOException e)
						{
                            LOGGER.warn("ChannelCleanupThread.run() --> Encountered IOException: {}", e.getMessage());
						}
						notifyTimeoutWritableChannelListeners(deadChannel);
						openWriteChannels.remove(deadChannel);
					}

                    LOGGER.info("ChannelCleanupThread.run() --> Sweeping read channels open before time [{}]", df.format(minOpenTime));
					List<InstanceReadableByteChannel> readChannelKillList = new ArrayList<InstanceReadableByteChannel>();
					
					// do the kill/close in two loops to avoid concurrent modification exceptions
					try
					{
						for( InstanceReadableByteChannel readChannel:openReadChannels.keySet() )
						{
							if( readChannel.getLastAccessedTime() < minOpenTime )
							{
                                LOGGER.warn("ChannelCleanupThread.run() --> Readable Byte Channel [{}] has remained open past the maximum allowable, notifying listeners", readChannel.toString());
								readChannelKillList.add(readChannel);
								
								if(isTraceChannelInstantiation() && readChannel instanceof TracableComponent)
								{
									StackTraceElement[] instantiatingStackTrace = 
										((TracableComponent)readChannel).getInstantiatingStackTrace();
									warnInstantiatingStackTrace(instantiatingStackTrace);
								}
							}
						}
					}
					catch(ConcurrentModificationException cmX)
					{
						// note that if we get a concurrent modification (i.e. another thread is opening or closing readable channels)
						// then log it but don't fail 'cause we can always close the channel later
						LOGGER.warn("ChannelCleanupThread.run() --> Concurrent modification exception while iterating open READ channels. Some overdue channels may not be closed immediately.");
					}

                    LOGGER.info("Closing {} read channels due to inactivity timeout", readChannelKillList.size());
					for(InstanceReadableByteChannel deadChannel:readChannelKillList)
					{
						try
						{
							deadChannel.close();
						} 
						catch (IOException e)
						{
                            LOGGER.warn("ChannelCleanupThread.run() --> Encountered IOException: {}", e.getMessage());
						}
						notifyTimeoutReadableChannelListeners(deadChannel);
						openReadChannels.remove(deadChannel);
					}
					
					sleep(getSweepTime());
				} 
				catch (InterruptedException e)
				{
					// if someone interrupts us then run the thread out, we're done
					break;
				}
			}
		}
		
		/*
		 * Log warning about who is leaving channels open, if the info is available, else
		 * jujst log messages that a channel was left open.
		 */
		private void warnInstantiatingStackTrace(StackTraceElement[] instantiatingStackTrace)
		{
			if(instantiatingStackTrace != null)
			{
				StackTraceAnalyzer stAnalyzer = new StackTraceAnalyzer(instantiatingStackTrace);
				StackTraceElement element = stAnalyzer.getFirstElementNotInPackageHierarchy("gov.va.med.imaging.storage.cache");
				if(element != null)
                    LOGGER.warn("ChannelCleanupThread.warnInstantiatingStackTrace() --> Method [{}.{}] (or something it calls) is opening channels that are not being closed.Entire call stack is:\n{}", element.getClassName(), element.getMethodName(), stAnalyzer.toString());
				else
                    LOGGER.warn("ChannelCleanupThread.warnInstantiatingStackTrace() --> Some method in this stack trace is opening channels that are not being closed:\n{}", stAnalyzer.toString());
			}
			else
				LOGGER.warn("ChannelCleanupThread.warnInstantiatingStackTrace() --> Stack Trace analysis of channel instantiating method is not available.  Turn TraceChannelInstantiation on to find the offending code.");
			
		}
	}		// end ChannelCleanup

}
