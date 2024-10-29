package gov.va.med.imaging.storage.cache.impl.filesystem;

import gov.va.med.imaging.storage.cache.InstanceReadableByteChannel;
import gov.va.med.imaging.storage.cache.TracableComponent;
import gov.va.med.imaging.storage.cache.exceptions.InstanceUnavailableException;
import gov.va.med.imaging.storage.cache.impl.AbstractByteChannelFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.util.zip.Checksum;

import gov.va.med.logging.Logger;

/**
 * A class that simply wraps a FileChannel that will be used for reading,
 * and releases a lock when the channel is closed.
 * 
 * @author VHAISWBECKEC
 *
 */
public class InstanceReadableByteChannelImpl 
implements InstanceReadableByteChannel, TracableComponent
{
	private static final Logger LOGGER = Logger.getLogger (AbstractByteChannelFactory.class);
	
	private final AbstractByteChannelFactory factory;
	private final File file;
	private final FileChannel wrappedChannel;
	private final FileInputStream inStream;
	private FileLock lock;
	private long openedTime;					// keep this so that we could close the files ourselves if the client does not
	private long lastAccessedTime;
	private java.util.zip.Checksum checksum;
	private StackTraceElement[] instantiatingStackTrace;
	
	InstanceReadableByteChannelImpl(AbstractByteChannelFactory factory, File file) 
	throws IOException, InstanceUnavailableException
	{
		this(factory, file, null);
	}
	
	public InstanceReadableByteChannelImpl(AbstractByteChannelFactory factory, File file, Checksum checksum) 
	throws IOException, InstanceUnavailableException
	{
		this.factory = factory;
		this.file = file;
		this.checksum = checksum;

        LOGGER.debug("InstanceReadableByteChannelImpl() -->  Opening [{}]", file.getPath());
		// trace the channel instantiation so we can tattle-tale later if its not closed
		if(this.factory.isTraceChannelInstantiation())
			instantiatingStackTrace = Thread.currentThread().getStackTrace();
		
		inStream = new FileInputStream(file);
		this.wrappedChannel = inStream.getChannel();
		
		openedTime = System.currentTimeMillis();
		lastAccessedTime = openedTime;
		
		// try to acquire a shared lock on the file
		//lock = wrappedChannel.tryLock(0L, Long.MAX_VALUE, true);
	}

	File getFile()
	{
		return this.file;
	}
	
	public File getCacheFile()
	{
		return this.file;
	}

	@Override
	public StackTraceElement[] getInstantiatingStackTrace()
	{
		return instantiatingStackTrace;
	}
	
	public java.util.zip.Checksum getChecksum()
	{
		return this.checksum;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.storage.cache.impl.filesystem.InstanceReadableByteChannel#error()
	 */
	public void error() 
	throws IOException
	{
		close(true);
	}
	
	/**
	 * A normal close, the cache item contents are valid.
	 */
	public void close() 
	throws IOException
	{
		close(false);
	}
	
	private void close(boolean errorClose) 
	throws IOException
	{
		IOException ioX = null;
        LOGGER.debug("InstanceReadableByteChannelImpl.close() --> closing [{}] {} delete", file.getPath(), errorClose ? "WITH" : "without");

		try{if(lock != null) lock.release();}				// the lock release must occur before the close
		catch(IOException e)
		{LOGGER.warn(e); ioX = e;} // the lock may already be released through some error or other timeout, log it but keep going
		
		try{ wrappedChannel.close(); }
		catch(IOException e)
		{LOGGER.warn(e);} // the channel may already be closed through some error or other timeout, log it but keep going

		try{ inStream.close(); }
		catch(IOException e)
		{LOGGER.warn(e);} // the stream may already be closed through some error or other timeout, log it but keep going
		
		if( errorClose && ! this.file.delete() )
            LOGGER.warn("InstanceReadableByteChannelImpl.close() --> Unable to delete cache item. File [{}] may be corrupt and should be manually deleted.", file.getAbsolutePath());
		
		// the following two operations really must occur regardless of the 
		// success of the previous IO operations, else channels will repeatedly be closed when they are already closed
		this.factory.readableByteChannelClosed(this, errorClose);

        LOGGER.debug("InstanceReadableByteChannelImpl.close() -->  [{}] was closed {} delete", file.getPath(), errorClose ? "WITH" : "without");
		if(ioX != null)
			throw ioX;
	}
	

	public boolean isOpen()
	{
		return wrappedChannel != null && wrappedChannel.isOpen();
	}

	public int read(ByteBuffer dst) 
	throws IOException
	{
		int bytesRead = 0;
		
		lastAccessedTime = System.currentTimeMillis();
		bytesRead = wrappedChannel.read(dst);
		
		Checksum localChecksumRef = getChecksum();		// just for performance
		if(localChecksumRef != null)
		{
			ByteBuffer localBuffer = dst.asReadOnlyBuffer();
			for(localBuffer.flip(); localBuffer.hasRemaining(); localChecksumRef.update(localBuffer.get()) );
		}
		
		return bytesRead;
	}

	public long getLastAccessedTime()
	{
		return lastAccessedTime;
	}
}