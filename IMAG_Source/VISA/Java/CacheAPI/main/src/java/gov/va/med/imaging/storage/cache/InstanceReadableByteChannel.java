package gov.va.med.imaging.storage.cache;

import java.io.File;
import java.io.IOException;
import java.nio.channels.ReadableByteChannel;

public interface InstanceReadableByteChannel
extends ReadableByteChannel
{

	/**
	 * An abnormal close when an error has occured and the contents of the
	 * cached item are corrupt.
	 * 
	 * @throws IOException
	 */
	public abstract void error() throws IOException;

	/**
	 * Get the Checksum instance that was associated to this channel instance, if
	 * one was assigned when the channel instance was created, or null if none 
	 * was assigned.
	 * 
	 * @return
	 */
	public java.util.zip.Checksum getChecksum();

	/**
	 * Return the time that this byte channel was last accessed.
	 * @return
	 */
	public abstract long getLastAccessedTime();
	
	/**
	 * 
	 * @return
	 */
	public abstract StackTraceElement[] getInstantiatingStackTrace();

	/**
	 * Get the Cached filepath
	 * @return
	 */
	public File getCacheFile();

}