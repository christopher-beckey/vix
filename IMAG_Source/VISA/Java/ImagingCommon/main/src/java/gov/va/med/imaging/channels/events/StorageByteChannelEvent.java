/*
 * Copyright (c) 2005, United States Veterans Administration
 * 
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, 
 * this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list 
 * of conditions and the following disclaimer in the documentation and/or other 
 * materials provided with the distribution.
 * Neither the name of the United States Veterans Administration nor the names of its 
 * contributors may be used to endorse or promote products derived from this software 
 * without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE.
 */
package gov.va.med.imaging.channels.events;

import java.util.zip.Checksum;

/**
 * @author beckey
 * created: Sep 8, 2005 at 3:56:12 PM
 *
 * This class serves as an encapsulation of an event generated by one
 * of the WritableByteChannel classes defined in storage.
 * These events are used by the implementation of the connector so
 * that it may be notified of asynchronous operations insitigated by
 * clients.
 */
public class StorageByteChannelEvent
{
	public static StorageByteChannelEvent createStorageByteChannelCloseEvent(
			Object context, int bytesRead, int bytesWritten, Checksum crc, String mimeType)
	{
		StorageByteChannelEvent event = new StorageByteChannelEvent(context, StorageByteChannelEventType.CLOSE_EVENT);
		event.bytesRead = bytesRead;
		event.bytesWritten = bytesWritten;
		event.crc = crc;
		event.mimeType = mimeType;
		return event;
	}

	public static StorageByteChannelEvent createStorageByteChannelReadEvent(
			Object context, int bytesRead)
	{
		StorageByteChannelEvent event = new StorageByteChannelEvent(context, StorageByteChannelEventType.READ_EVENT);
		event.bytesRead = bytesRead;
		return event;
	}
	
	public static StorageByteChannelEvent createStorageByteChannelWriteEvent(
			Object context, int bytesWritten)
	{
		StorageByteChannelEvent event = new StorageByteChannelEvent(context, StorageByteChannelEventType.WRITE_EVENT);
		event.bytesWritten = bytesWritten;
		return event;
	}
	
	/* ===============================================================================================================
	 * Instance Members
	 * =============================================================================================================== */
	private StorageByteChannelEventType eventType = null;
	private Object eventContext = null;
	private int bytesRead = 0;
	private int bytesWritten = 0;
	private Checksum crc = null;
	private String mimeType = null;

	/**
	 * @param context
	 * @param type
	 */
	public StorageByteChannelEvent(Object context, StorageByteChannelEventType type)
	{
		eventContext = context;
		eventType = type;
	}

	/**
	 * @param type
	 */
	public StorageByteChannelEvent(StorageByteChannelEventType type)
	{
		eventType = type;
	}

	public Object getEventContext()
	{
		return eventContext;
	}

	public StorageByteChannelEventType getEventType()
	{
		return eventType;
	}

	public int getBytesRead()
	{
		return bytesRead;
	}

	public int getBytesWritten()
	{
		return bytesWritten;
	}

	public Checksum getCrc()
	{
		return crc;
	}

	public String getMimeType()
	{
		return mimeType;
	}

	public String toString()
	{
		StringBuffer buffy = new StringBuffer();
		buffy.append("StorageByteChannelEvent (");
		buffy.append(eventType.getShortDescription()); 
		buffy.append("bytesRead = [" + getBytesRead() + "],"); 
		buffy.append("bytesWritten = [" + getBytesWritten() + "],"); 
		buffy.append("checksumValue = [" + (getCrc() != null ? getCrc().getValue() : 0L) + "],"); 
		buffy.append("mimeType = [" + getMimeType() + "]"); 
		buffy.append(")");
		return buffy.toString();
	}
}
