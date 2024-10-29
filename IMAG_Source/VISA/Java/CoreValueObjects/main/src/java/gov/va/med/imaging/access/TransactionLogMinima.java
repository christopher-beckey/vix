/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jul 1, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
package gov.va.med.imaging.access;

import gov.va.med.imaging.exchange.enums.ByteTransferPath;
import gov.va.med.imaging.exchange.enums.ByteTransferType;

/**
 * @author VHAISWBECKEC
 *
 * A TransactionLogEntry derivation that may be used to build the
 * arithmetic mean of the bytesTransferred, elapsedTime and itemCount
 * properties of some number of TransactionLogEntry instances. 
 */
public class TransactionLogMinima 
extends TransactionLogStatistics
{
	private ByteTransferPath byteTransferPath = ByteTransferPath.DS_IN_FACADE_OUT;
	private long minBytesSent = Long.MAX_VALUE;
	private long minBytesReceived = Long.MAX_VALUE;
	private long minElapsedTime = Long.MAX_VALUE;
	private int minItemCount = Integer.MAX_VALUE;
	private long minStartTime = Long.MAX_VALUE;
	private int minDataSourceItemsReceived = Integer.MAX_VALUE;
	
	/**
	 * MT Constructor.  Assumes you're interested in DS Bytes Received, Facade Bytes Sent.
	 */
	public TransactionLogMinima ()
	{
		this.byteTransferPath = ByteTransferPath.DS_IN_FACADE_OUT;
	}
	
	/**
	 * Instantiate with the type of bytes transferred path you're interested in gathering statistics on.  Choose from
	 * ByteTransferPath.DS_IN_FACADE_OUT or ByteTransferPath.FACADE_IN_DS_OUT.
	 * @param byteTransferPath The ByteTransferPath type of bytes transferred path that you're interested in gathering statistics on.
	 */
	public TransactionLogMinima (ByteTransferPath byteTransferPath)
	{
		this.byteTransferPath = byteTransferPath;
	}
	
	/**
	 * @see gov.va.med.imaging.access.TransactionLogStatistics#update(gov.va.med.imaging.access.TransactionLogEntry)
	 */
	@Override
	public void update(TransactionLogEntry entry)
	{
		if(entry == null)
			return;
		
		Long bytesSent = null;
		Long bytesReceived = null;
		
		switch (byteTransferPath)
		{
		   case DS_IN_FACADE_OUT:
			    bytesSent = getByteCount (entry, ByteTransferType.FACADE_BYTES_SENT);
			    bytesReceived = getByteCount (entry, ByteTransferType.DATASOURCE_BYTES_RECEIVED);
		        break;
		        
		   case FACADE_IN_DS_OUT:
			    bytesSent = getByteCount (entry, ByteTransferType.DATASOURCE_BYTES_SENT);
			    bytesReceived = getByteCount (entry, ByteTransferType.FACADE_BYTES_RECEIVED);
		        break;
		        
           default:
		        bytesSent = null;
	            bytesReceived = null;
	            break;
		}

		minBytesSent = 
			Math.min(minBytesSent, bytesSent == null ? 0 : bytesSent.longValue() );
		minBytesReceived = 
			Math.min(minBytesReceived, bytesReceived == null ? 0 : bytesReceived.longValue() );
		minElapsedTime =
			Math.min(minElapsedTime, entry.getElapsedTime() == null ? 0 : entry.getElapsedTime().longValue() );
		minItemCount =
			Math.min(minItemCount, entry.getItemCount() == null ? 0 : entry.getItemCount().intValue() );
		minStartTime = 
			Math.min(minStartTime, entry.getStartTime() == null ? 0 : entry.getStartTime() );
		minDataSourceItemsReceived = 
			Math.min(minDataSourceItemsReceived, entry.getDataSourceItemsReceived() == null ? 0 : entry.getDataSourceItemsReceived());
	}

	/**
	 * @see gov.va.med.imaging.access.TransactionLogEntry#getFacadeBytesSent()
	 */
	@Override
	public Long getFacadeBytesSent()
	{
		return minBytesSent;
	}

	/**
	 * @see gov.va.med.imaging.access.TransactionLogEntry#getFacadeBytesReceived()
	 */
	@Override
	public Long getFacadeBytesReceived()
	{
		return minBytesReceived;
	}

	/**
	 * @see gov.va.med.imaging.access.TransactionLogEntry#getDataSourceBytesSent()
	 */
	@Override
	public Long getDataSourceBytesSent()
	{
		return minBytesSent;
	}

	/**
	 * @see gov.va.med.imaging.access.TransactionLogEntry#getDataSourceBytesReceived()
	 */
	@Override
	public Long getDataSourceBytesReceived()
	{
		return minBytesReceived;
	}

	/**
	 * @see gov.va.med.imaging.access.TransactionLogEntry#getElapsedTime()
	 */
	@Override
	public Long getElapsedTime()
	{
		return minElapsedTime;
	}

	/**
	 * @see gov.va.med.imaging.access.TransactionLogEntry#getItemCount()
	 */
	@Override
	public Integer getItemCount()
	{
		return minItemCount;
	}

	/**
	 * @see gov.va.med.imaging.access.TransactionLogEntry#getStartTime()
	 */
	@Override
	public Long getStartTime()
	{
		return minStartTime;
	}

	/**
	 * @see gov.va.med.imaging.access.TransactionLogEntry#getTransactionId()
	 */
	@Override
	public String getTransactionId()
	{
		return "Minima";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.access.TransactionLogEntry#getDataSourceItemsReceived()
	 */
	@Override
	public Integer getDataSourceItemsReceived() 
	{
		return minDataSourceItemsReceived;
	}

	@Override
	public String getSecurityTokenApplicationName() {
		return null;
	}
}