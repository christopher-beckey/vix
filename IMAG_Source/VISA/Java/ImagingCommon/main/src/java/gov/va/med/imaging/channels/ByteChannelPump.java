/**
 * 
 */
package gov.va.med.imaging.channels;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.SelectableChannel;
import java.nio.channels.WritableByteChannel;
import java.util.ArrayList;
import java.util.List;

/**
 * A class that is used to push bytes from an input stream to an output stream.
 * Based upon the type of streams (network, memory, or file) the buffer size is
 * optimized. 
 * Use the getByteStreamPump(TRANSFER_TYPE) static method to get an optimized
 * byte stream pump.
 * Once the reference to the ByteStreamPump is obtained, call either:
 * xfer(InputStream inStream, OutputStream outStream) or,
 * xfer(InputStream inStream, OutputStream[] outStream)
 * to transfer the input stream content to the output stream(s).
 * e.g.
 * ByteStreamPump bsp = ByteStreamPump.getByteStreamPump(TRANSFER_TYPE.FileToNetwork);
 * bsp.xfer(inFile, outResponse);
 * 
 * @see ByteStreamPump
 * 
 * @author VHAISWBECKEC
 *
 */
public class ByteChannelPump 
extends AbstractBytePump
{
	// ============================================================================================================
	// Factory Methods
	// ============================================================================================================
	public static ByteChannelPump getByteChannelPump()
	{
		return getByteChannelPump((String)null);
	}

	public static ByteChannelPump getByteChannelPump(Class<?> clazz)
	{
		return getByteChannelPump(clazz.getName());
	}

	public static ByteChannelPump getByteChannelPump(TRANSFER_TYPE transferType)
	{
		return getByteChannelPump(transferType.toString());
	}

	public static ByteChannelPump getByteChannelPump(String name)
	{
		return new ByteChannelPump(name);
	}
	
	private static ByteBuffer getBuffer(BUFFER_SIZE bufferSize)
	{
		return ByteBuffer.allocateDirect(bufferSize.getSize());
	}
	
	private static ByteBuffer getBuffer(String name)
	{
		BUFFER_SIZE bufferSize = getBufferSize(name, MEDIUM.ChannelToChannel);
		return getBuffer(bufferSize);
	}
	
	// ============================================================================================================
	// Instance Constructor, Fields and Methods
	// ============================================================================================================
	// once the read channel is at least 75% full flip and do the write
	private int bufferFlipPercentage = 75;
	private boolean detectZeroBytesInBlockingMode = false;
	
	private ByteChannelPump(String name)
	{
		super(name);
	}
	
	public boolean isDetectZeroBytesInBlockingMode()
	{
		return this.detectZeroBytesInBlockingMode;
	}

	public void setDetectZeroBytesInBlockingMode(boolean detectZeroBytesInBlockingMode)
	{
		this.detectZeroBytesInBlockingMode = detectZeroBytesInBlockingMode;
	}

	public int xfer(ReadableByteChannel inChannel, WritableByteChannel outChannel) 
	throws IOException
	{
		ByteBuffer buffy = getBuffer(getName());
		int flipThreshold = (buffy.capacity() * bufferFlipPercentage) / 100;
		
		// the read may or may not fill the buffer
		// whether it is faster to continue to read until the buffer is full or
		// is faster to immediately write to the output channel depends on how full
		// the buffer is
		boolean readChannelDrained = false;
		int totalBytesRead = 0;
		// from http://java.sun.com/javase/6/docs/api/
		// "It is guaranteed, however, that if a channel is in blocking mode and there is at 
		// least one byte remaining in the buffer then this method will block until at least 
		// one byte is read."
		// In at least one case the channel is repeatedly returning 0 bytes when it should be done.
		boolean blockingMode = (inChannel instanceof SelectableChannel) && 
			((SelectableChannel)inChannel).isBlocking(); 
		
		for( int bytesRead = inChannel.read(buffy); !readChannelDrained;	bytesRead = inChannel.read(buffy) )	{
			totalBytesRead += bytesRead;
			
			readChannelDrained = bytesRead < 0 || (blockingMode && bytesRead == 0 && this.detectZeroBytesInBlockingMode);
			if(buffy.position() > flipThreshold || readChannelDrained)
			{
				buffy.flip();
				// a non-blocking buffer may not write all bytes in one call
				while(buffy.remaining() > 0)
					outChannel.write(buffy);
				buffy.clear();
			}
		}
		
		return totalBytesRead;
	}
}
