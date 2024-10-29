/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 21, 2011
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
package gov.va.med.imaging.exchange.transactionlog;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.access.TransactionLogEntry;

/**
 * Transaction log entry that has a list of its children transaction log entries
 * 
 * @author VHAISWWERFEJ
 *
 */
public class GroupedTransactionLogEntry
implements TransactionLogEntry
{
	private final TransactionLogEntry entry;
	private final List<GroupedTransactionLogEntry> childEntries = 
		new ArrayList<GroupedTransactionLogEntry>();
	
	public GroupedTransactionLogEntry(TransactionLogEntry entry)
	{
		this.entry = entry;
	}
	
	public boolean isChildCommand()
	{
		return (getParentCommandId() != null && getParentCommandId().length() > 0);
	}
	
	public void addChildCommand(GroupedTransactionLogEntry childEntry)
	{
		childEntries.add(childEntry);
	}

	public List<GroupedTransactionLogEntry> getChildEntries()
	{
		return childEntries;
	}

	@Override
	public Long getStartTime()
	{
		return entry.getStartTime();
	}

	@Override
	public Long getElapsedTime()
	{
		return entry.getElapsedTime();
	}

	@Override
	public String getPatientIcn()
	{
		return entry.getPatientIcn();
	}

	@Override
	public String getQueryType()
	{
		return entry.getQueryType();
	}

	@Override
	public String getQueryFilter()
	{
		return entry.getQueryFilter();
	}

	@Override
	public String getCommandClassName()
	{
		return entry.getCommandClassName();
	}

	@Override
	public Integer getItemCount()
	{
		return entry.getItemCount();
	}

	@Override
	public Long getFacadeBytesSent()
	{
		return entry.getFacadeBytesSent();
	}

	@Override
	public Long getFacadeBytesReceived()
	{
		return entry.getFacadeBytesReceived();
	}

	@Override
	public Long getDataSourceBytesSent()
	{
		return entry.getDataSourceBytesSent();
	}

	@Override
	public Long getDataSourceBytesReceived()
	{
		return entry.getDataSourceBytesReceived();
	}

	@Override
	public String getQuality()
	{
		return entry.getQuality();
	}

	@Override
	public String getMachineName()
	{
		return entry.getMachineName();
	}

	@Override
	public String getRequestingSite()
	{
		return entry.getRequestingSite();
	}

	@Override
	public String getOriginatingHost()
	{
		return entry.getOriginatingHost();
	}

	@Override
	public String getUser()
	{
		return entry.getUser();
	}

	@Override
	public String getTransactionId()
	{
		return entry.getTransactionId();
	}

	@Override
	public String getUrn()
	{
		return entry.getUrn();
	}

	@Override
	public String getErrorMessage()
	{
		return entry.getErrorMessage();
	}

	@Override
	public String getModality()
	{
		return entry.getModality();
	}

	@Override
	public String getPurposeOfUse()
	{
		return entry.getPurposeOfUse();
	}

	@Override
	public String getDatasourceProtocol()
	{
		return entry.getDatasourceProtocol();
	}

	@Override
	public Boolean isCacheHit()
	{
		return entry.isCacheHit();
	}

	@Override
	public String getResponseCode()
	{
		return entry.getResponseCode();
	}

	@Override
	public String getExceptionClassName()
	{
		return entry.getExceptionClassName();
	}

	@Override
	public String getRealmSiteNumber()
	{
		return entry.getRealmSiteNumber();
	}

	@Override
	public Long getTimeToFirstByte()
	{
		return entry.getTimeToFirstByte();
	}

	@Override
	public String getVixSoftwareVersion()
	{
		return entry.getVixSoftwareVersion();
	}

	@Override
	public String getRespondingSite()
	{
		return entry.getRespondingSite();
	}

	@Override
	public Integer getDataSourceItemsReceived()
	{
		return entry.getDataSourceItemsReceived();
	}

	@Override
	public Boolean isAsynchronousCommand()
	{
		return entry.isAsynchronousCommand();
	}

	@Override
	public String getCommandId()
	{
		return entry.getCommandId();
	}

	@Override
	public String getParentCommandId()
	{
		return entry.getParentCommandId();
	}

	@Override
	public String getRemoteLoginMethod()
	{
		return entry.getRemoteLoginMethod();
	}

	@Override
	public String getFacadeImageFormatSent()
	{
		return entry.getFacadeImageFormatSent();
	}

	@Override
	public String getFacadeImageQualitySent()
	{
		return entry.getFacadeImageQualitySent();
	}

	@Override
	public String getDataSourceImageFormatReceived()
	{
		return entry.getDataSourceImageFormatReceived();
	}

	@Override
	public String getDataSourceImageQualityReceived()
	{
		return entry.getDataSourceImageQualityReceived();
	}

	@Override
	public String getClientVersion()
	{
		return entry.getClientVersion();
	}

	@Override
	public String getDataSourceMethod()
	{
		return entry.getDataSourceMethod();
	}

	@Override
	public String getDataSourceVersion()
	{
		return entry.getDataSourceVersion();
	}

	@Override
	public String getDebugInformation()
	{
		return entry.getDebugInformation();
	}

	@Override
	public String getDataSourceResponseServer()
	{
		return entry.getDataSourceResponseServer();
	}

	@Override
	public String getThreadId()
	{
		return entry.getThreadId();
	}

	@Override
	public String getVixSiteNumber()
	{
		return entry.getVixSiteNumber();
	}

	@Override
	public String getRequestingVixSiteNumber()
	{
		return entry.getRequestingVixSiteNumber();
	}

	@Override
	public String getSecurityTokenApplicationName() {
		return entry.getSecurityTokenApplicationName();
	}

	@Override
	public String toString()
	{
		StringBuilder sb = new StringBuilder();
		sb.append("Command '" + getCommandId() + "' has parent '" + getParentCommandId() + "'.");
		sb.append("\n");
		for(TransactionLogEntry childEntry : childEntries)
		{
			sb.append("\t");
			sb.append(childEntry.toString());
			//sb.append("Child Command '" + childEntry.getCommandId() +"' with parent '" + childEntry.getParentCommandId() + "'");
			sb.append("\n");
		}
		return sb.toString();
	}

}
