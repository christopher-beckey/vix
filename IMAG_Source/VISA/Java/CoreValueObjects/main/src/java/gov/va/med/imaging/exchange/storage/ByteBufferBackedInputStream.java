/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 14, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.exchange.storage;

import gov.va.med.imaging.NullOutputStream;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.channels.ChecksumValue;
import gov.va.med.imaging.channels.AbstractBytePump.TRANSFER_TYPE;
import gov.va.med.imaging.channels.exceptions.ChecksumFormatException;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.storage.exceptions.CannotCalculateChecksumException;
import gov.va.med.imaging.exchange.storage.exceptions.ChecksumNotProvidedException;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.zip.Adler32;
import java.util.zip.CheckedInputStream;

import gov.va.med.logging.Logger;

/**
 * Object that holds an input stream or a ByteBuffer representing an image. This object handles
 * all conversions to and from a buffer to allow conversion of an image without corrupting the data.
 * 
 * Putting an InputStream into this object DOES NOT require the object be loaded into a buffer
 * 
 * This does NOT extend ByteBufferBackedObject because when conversion is called, it is REQUIRED to have the object
 * in the buffer and if this object extended ByteBufferBackedObject, it would not necessarily be guaranteed
 * 
 * @author vhaiswwerfej
 *
 */
public class ByteBufferBackedInputStream 
implements DataSourceInputStream
{
	private static final Logger logger = Logger.getLogger(ByteBufferBackedInputStream.class);
	
	protected final InputStream inputStream;
	protected boolean inputStreamDepleted;
	protected ByteBuffer buffer;
	
	private int size;
	private ChecksumValue calculatedChecksum;
	private final ChecksumValue providedChecksum;	
	private String storageSiteNumber;
	private String storageUsername;
	private String storagePassword;
		
	/**
	 *
	 * @param inputStream
	 * @param size
	 * @param readIntoBuffer
	 * @param providedChecksum
	 */
	public ByteBufferBackedInputStream(InputStream inputStream, int size, boolean readIntoBuffer, 
			ChecksumValue providedChecksum)
	throws IOException
	{
        logger.debug("ByteBufferBackedInputStream(1) --> Creating from InputStream of size [{}], readIntoBuffer [{}], providedChecksum [{}]", size, readIntoBuffer, providedChecksum == null ? "<null>" : providedChecksum.toString());
		this.size = size;
		this.inputStream = inputStream;
		this.providedChecksum = providedChecksum;
		this.inputStreamDepleted = false;
		
		if(readIntoBuffer)
			readInputStreamIntoBuffer();
	}
	
	public ByteBufferBackedInputStream(InputStream inputStream, int size, boolean readIntoBuffer, 
			String providedChecksum)
	throws IOException
	{
        logger.debug("ByteBufferBackedInputStream(2) --> Creating from InputStream of size [{}], readIntoBuffer [{}], providedChecksum [{}]", size, readIntoBuffer, providedChecksum);
		this.size = size;
		this.inputStream = inputStream;
		ChecksumValue checksumValue = null;
		if(providedChecksum != null)
		{
			try
			{
				checksumValue = new ChecksumValue(providedChecksum);
			}
			catch(ChecksumFormatException cfX)
			{
                logger.warn("ByteBufferBackedInputStream(2) --> Error converting checksum from string [{}] into checksum. Will use null value.", providedChecksum);
				checksumValue = null;
			}
		}		
		this.providedChecksum = checksumValue;
		this.inputStreamDepleted = false;
		
		if(readIntoBuffer)
			readInputStreamIntoBuffer();
	}
	
	public ByteBufferBackedInputStream(InputStream inputStream, int size, boolean readIntoBuffer)
	throws IOException
	{
        logger.debug("ByteBufferBackedInputStream(3) --> Creating from InputStream of size [{}], readIntoBuffer [{}]", size, readIntoBuffer);
		
		this.size = size;
		this.inputStream = inputStream;		
		this.providedChecksum = null;
		this.inputStreamDepleted = false;
		
		if(readIntoBuffer)
			readInputStreamIntoBuffer();
	}
	
	public ByteBufferBackedInputStream(InputStream inputStream, int size)
	{
        logger.debug("ByteBufferBackedInputStream(4) --> Creating from InputStream of size [{}]", size);
		
		this.size = size;
		this.inputStream = inputStream;
		this.providedChecksum = null;
		this.inputStreamDepleted = false;
	}
	
	/**
	 * Construct a ByteBufferBackedInputStream
	 * @param inputStream
	 * @param size
	 * @param providedChecksum
	 */
	public ByteBufferBackedInputStream(InputStream inputStream, int size, ChecksumValue providedChecksum)	
	{
        logger.debug("ByteBufferBackedInputStream(5) --> Creating from InputStream of size [{}], providedChecksum [{}]", size, providedChecksum == null ? "<null>" : providedChecksum.toString());
		
		this.size = size;
		this.inputStream = inputStream;
		this.providedChecksum = providedChecksum;
		this.inputStreamDepleted = false;
	}
	
	/**
	 * Construct a ByteBufferBackedInputStream
	 * @param inputStream
	 * @param size
	 * @param providedChecksum
	 */
	public ByteBufferBackedInputStream(InputStream inputStream, int size, String providedChecksum)	
	{
        logger.debug("ByteBufferBackedInputStream(6) --> Creating from InputStream of size [{}], providedChecksum [{}]", size, providedChecksum);
		
		this.size = size;
		this.inputStream = inputStream;
		ChecksumValue checksumValue = null;

		try
		{
			checksumValue = new ChecksumValue(providedChecksum);
		}
		catch(ChecksumFormatException cfX)
		{
            logger.warn("ByteBufferBackedInputStream(6) --> Error converting checksum from string [{}] into checksum. Will use null value.", providedChecksum);
			checksumValue = null;
		}
		this.providedChecksum = checksumValue;
		this.inputStreamDepleted = false;
	}
	
	/**
	 * Construct a ByteBufferBackedInputStream
	 * @param byteBuffer Buffer containing object contents
	 * @param size The size of the buffer
	 */
	public ByteBufferBackedInputStream(ByteBuffer byteBuffer, int size)
	{
        logger.debug("ByteBufferBackedInputStream(7) --> Creating from ByteBuffer of size [{}]", size);

		this.inputStream = null;
		this.buffer = byteBuffer;
		this.size = size;
		this.providedChecksum = null;
	}
	
	/**
	 * Compares the provided checksum to the calculated checksum. If the checksum has not already
	 * been calculated, it will be calculated calling calculateChecksum()
	 */
	public boolean validateChecksum()
	throws ChecksumNotProvidedException, CannotCalculateChecksumException
	{
		if(providedChecksum == null)
			throw new ChecksumNotProvidedException("ByteBufferBackedInputStream.validateChecksum() --> No checksum was provided.");
		
		if(calculatedChecksum == null)
			calculateChecksum();
		
		return providedChecksum.equals(calculatedChecksum);
	}
	
	/**
	 * Calculate the checksum for the image. If the image is not in a buffer it will be loaded into a buffer
	 * in order to calculate the checksum
	 * @return
	 */
	private ChecksumValue calculateChecksum()
	throws CannotCalculateChecksumException
	{
		if(calculatedChecksum == null)
		{
			if(buffer == null)
			{			
				logger.debug("ByteBufferBackedInputStream.calculateChecksum() --> Calculating checksum from object not already in buffer.");
				try
				{
					readInputStreamIntoBuffer();
				}
				catch(IOException ioX)
				{
					String msg = "ByteBufferBackedInputStream.calculateChecksum() --> IOException calculating checksum: " + ioX.getMessage();
					logger.error(msg);
					throw new CannotCalculateChecksumException(msg, ioX);
				}
			}
			else
			{
				// image is in buffer but checksum was not previously calculated, calculate now I guess
				try
				{
					CheckedInputStream checkedStream = 
						new CheckedInputStream(getInputStreamFromBuffer(), new Adler32());
					NullOutputStream nullOutStream = new NullOutputStream();
					ByteStreamPump pump = getByteStreamPump();
					pump.xfer(checkedStream, nullOutStream);
					this.calculatedChecksum = new ChecksumValue(checkedStream.getChecksum());
					checkedStream.close();
					nullOutStream.close();					
				}
				catch(IOException ioX)
				{
					String msg = "ByteBufferBackedInputStream.calculateChecksum() --> IOException calculating checksum from buffer: " + ioX.getMessage();
					logger.error(msg);
					throw new CannotCalculateChecksumException(msg, ioX);
				}
			}
		}
		return calculatedChecksum;
	}
	
	/**
	 * This method should only be used if NO conversion will be done. If the object was loaded with an 
	 * input stream, this method returns the actual input stream and risks corrupting the image if there
	 * are problems when using the stream.  If the image was already loaded into a buffer, an input stream to the
	 * buffer will be returned.
	 * <br>
	 * <br>
	 * <strong>WARNING:</strong>
	 * If the object has been loaded into a buffer, this method will return a NEW InputStream each time this method 
	 * is called! DO NOT use this method to continuously get a handle to an input stream, it will always give a new
	 * version if the image is in a buffer. USE THIS METHOD WITH CARE!
	 * 
	 * @return Input stream to the object
	 */
	public InputStream getInputStream()
	{

		if(isInputStreamReadable())
		{
			return inputStream;
		}

		return openInputStreamToBuffer(buffer);
	}	
	
	/**
	 * If its possible the input stream was never read, then call this method to ensure it gets closed.
	 * This method handles any exceptions that might occur.  If the object is in a buffer, this method does
	 * nothing
	 */
	public void closeSafely()
	{
		try
		{
			if((inputStream != null) && (!inputStreamDepleted))
				inputStream.close();
		}
		catch(Exception ex)
		{
            logger.warn("ByteBufferBackedInputStream.closeSafely() --> Exception closing input stream: {}", ex.getMessage());
		}
	}
	
	private InputStream openInputStreamToBuffer(ByteBuffer byteBuffer)
	{
		return new ByteArrayInputStream(byteBuffer.array(), 0, size);
	}
	
	/**
	 * This method should be used if an input stream is required but its ok to come from a buffer.  If the image
	 * is not already in a buffer, it will be loaded into a buffer.  This method will never return the originating 
	 * input stream (if one was used originally)
	 * @return
	 */
	public InputStream getInputStreamFromBuffer()
	throws IOException
	{
		return openInputStreamToBuffer(getByteBuffer());		
	}
	
	/**
	 * Return the internal ByteBuffer to the input.  If the input is not already in a buffer, 
	 * it will be loaded into a buffer
	 * @return
	 * @throws IOException
	 */
	private ByteBuffer getByteBuffer()
	throws IOException
	{
		if(buffer == null)
		{
			readInputStreamIntoBuffer();
		}
		return buffer;
	}
	
	/**
	 * This creates a copy of the internal buffer.  This is done by creating a NEW ByteBuffer object and
	 * then copying the bytes from the internal ByteBuffer into the new buffer.  The new buffer does NOT share
	 * any data with the internal buffer, they are completely independent.
	 * @return
	 * @throws IOException
	 */
	public ByteBuffer getByteBufferCopy()
	throws IOException
	{
		ByteBuffer bb = getByteBuffer();		
		ByteBuffer newBuffer = ByteBuffer.allocate(bb.capacity());

		return newBuffer.put(bb.array().clone());		
	}
	
	/**
	 * Return the ByteBuffer for the object, if the object is not in the buffer it is read from the stream into
	 * the buffer
	 * @return
	 * @throws IOException
	 */
	private ByteBuffer getBuffer()
	throws IOException
	{
		return getByteBuffer();
	}
	
	private ByteStreamPump getByteStreamPump()
	{
		return ByteStreamPump.getByteStreamPump(TRANSFER_TYPE.NetworkToByteArray);
	}
	
	/**
	 * Read the input stream into the buffer.  This should only be called if the buffer is null and if there is
	 * data in the input stream.
	 * @throws IOException
	 */
	private void readInputStreamIntoBuffer()
	throws IOException
	{
		if(!this.isInputStreamReadable())
		{
			throw new IOException("ByteBufferBackedInputStream.readInputStreamIntoBuffer() --> Attempting to read input stream into buffer but stream is null or already read.");
		}

		ByteStreamPump pump = getByteStreamPump();
		
		ByteArrayOutputStream baos = null;
		
		if(this.size > 0)
		{
			baos = new ByteArrayOutputStream(this.size);
		}
		else
		{
			baos = new ByteArrayOutputStream();
		}
		
		CheckedInputStream cis = new CheckedInputStream(inputStream, new Adler32());
		
		this.size = pump.xfer(cis, baos);
		this.calculatedChecksum = new ChecksumValue(cis.getChecksum());
		this.buffer = ByteBuffer.allocate(size);
		this.buffer.put(baos.toByteArray());
		
		if(isCloseInputStreamWhenReadComplete())
		{
			inputStream.close();
		}

		inputStreamDepleted = true;

        logger.debug("ByteBufferBackedInputStream.readInputStreamIntoBuffer() --> Read input stream into buffer, read [{}] bytes and calculated checksum [{}]", this.size, calculatedChecksum);
	}
	
	/**
	 * Method that can be overridden (depending on the type of input stream provided) that determines if 
	 * the input stream should be closed when a file has been read from the stream into a buffer. In certain 
	 * cases (ZIP streams), the stream should not be closed after the read because there might be more 
	 * data in the input stream (the next file).
	 * If this method returns false, it is expected the input stream is closed elsewhere
	 * @return
	 */
	protected boolean isCloseInputStreamWhenReadComplete()
	{
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.storage.DataSourceInputStream#getCalculatedChecksum()
	 */
	public ChecksumValue getCalculatedChecksum() 
	throws CannotCalculateChecksumException
	{
		return calculateChecksum();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.storage.DataSourceInputStream#getProvidedChecksum()
	 */
	public ChecksumValue getProvidedChecksum() 
	{
		return providedChecksum;
	}	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.storage.DataSourceInputStream#isChecksumProvided()
	 */
	public boolean isChecksumProvided()
	{
		return (providedChecksum == null ? false : true);
	}	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.storage.DataSourceInputStream#getSize()
	 */
	public int getSize() 
	{
		return size;
	}
	
	protected boolean isInputStreamReadable()
	{
		if(inputStream == null)
			return false;
		if(inputStreamDepleted)
			return false;
		
		return true;
	}
	
	/**
	 * Determines if the object is readable, either from the input stream or from the buffer. If the input stream 
	 * has been read and the buffer is null this will return false.  If either can be used, this will return true
	 * @return
	 */
	public boolean isReadable()
	{		
		if((inputStream == null) || (inputStreamDepleted))
		{
			// the input stream is empty or was read, the buffer should be loaded or else it can't be read
			if(buffer != null)
				return true;
			return false;
		}
		
		if((inputStream != null) && (!inputStreamDepleted))
			return true;
		return false;
	}
	
	/**
	 * Returns a ByteBufferBackedObject for this object, if the object is in the input stream it will be
	 * read into a buffer
	 * @return
	 * @throws IOException
	 */
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.storage.DataSourceInputStream#toBufferedObject()
	 */
	public ByteBufferBackedObject toBufferedObject()
	throws IOException
	{
		return new ByteBufferBackedObject( getBuffer(), getSize());	
	}
	
	/**
	 * Determines if the object is stored in a buffer
	 * @return
	 */
	public boolean isBuffered()
	{
		return (buffer != null);
	}

	String filePath = null;
	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getStorageSiteNumber() {
		return storageSiteNumber;
	}

	public void setStorageSiteNumber(String storageSiteNumber) {
		this.storageSiteNumber = storageSiteNumber;
	}

	public String getStorageUsername() {
		return storageUsername;
	}

	public void setStorageUsername(String storageUsername) {
		this.storageUsername = storageUsername;
	}

	public String getStoragePassword() {
		return storagePassword;
	}

	public void setStoragePassword(String storagePassword) {
		this.storagePassword = storagePassword;
	}
}
