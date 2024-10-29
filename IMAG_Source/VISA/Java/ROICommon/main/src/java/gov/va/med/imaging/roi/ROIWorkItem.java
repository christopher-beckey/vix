/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 30, 2012
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
package gov.va.med.imaging.roi;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.WorkItemTags;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIWorkItem
{
	private ROIStatus status;
	private String guid;
	private PatientIdentifier patientIdentifier;
	private final WorkItem workItem;
	private ROIWorkItemMessage workItemMessage;
	private String outputGuid;
	private int retryCount;
	private String exportQueueUrn;
	private String userDuz;
	private boolean completed;
	private String patientName;
	private String patientSsn;
	private String sendTo; // for CCP support - has | separated destination names
	
	public final static String workItemCompletedValue = "1";
	public final static String workItemNotCompletedValue = "0";
	
	public ROIWorkItem(WorkItem workItem)
	{
		super();
		this.workItem = workItem;
		this.workItemMessage = null;
		this.retryCount = 0;
		this.outputGuid = "";
		this.patientIdentifier = null;
		this.userDuz = null;
		this.exportQueueUrn = null;
		this.patientName = null;
		this.patientSsn = null;	
		this.sendTo = "";
		
		WorkItemTags tags = workItem.getTags();
		setStatus(ROIStatus.valueOfStatus(workItem.getStatus()));
		setGuid(tags.getValue(ROIWorkItemTag.guid.getTagName()));
		String patientIcnValue = tags.getValue(ROIWorkItemTag.patientIcn.getTagName());
		String patientDfnValue = tags.getValue(ROIWorkItemTag.patientDfn.getTagName());
		if(patientIcnValue != null && patientIcnValue.length() > 0)
			setPatientIdentifier(PatientIdentifier.icnPatientIdentifier(patientIcnValue));
		else
			//WFP-Site number is not available for PatientIdentifier.  Passing a null for now.
			setPatientIdentifier(PatientIdentifier.dfnPatientIdentifier(patientDfnValue, null));
		setOutputGuid(tags.getValue(ROIWorkItemTag.outputGuid.getTagName()));
		String failedCountString = tags.getValue(ROIWorkItemTag.retryCount.getTagName());
		if((failedCountString != null) 
				&& (failedCountString.length() > 0)
				&& ("null".equals(failedCountString))				
			)
		{
			setRetryCount(Integer.parseInt(failedCountString));
		}
		
		String message = workItem.getMessage();
		if(message != null)
		{
			if(message.length() == 0 || ("null".equals(message)))
				message = null;
		}
		
		String queue = tags.getValue(ROIWorkItemTag.exportQueue.getTagName());
		if(queue != null && queue.length() > 0)
			exportQueueUrn = queue;
		else
			exportQueueUrn = null;
		
		String duz = tags.getValue(ROIWorkItemTag.userDuz.getTagName());
		if(duz != null && duz.length() > 0)
			userDuz = duz;
		else
			userDuz = null;
		
		String completedValue = tags.getValue(ROIWorkItemTag.completed.getTagName());
		if(completedValue != null && completedValue.length() > 0)
			completed = workItemCompletedValue.equals(completedValue);
		else
			completed = false;
		
		String patientNameValue = tags.getValue(ROIWorkItemTag.patientName.getTagName());
		if(patientNameValue != null && patientNameValue.length() > 0)
			patientName = patientNameValue;
		else
			patientName = null;
		
		String patientSsnValue = tags.getValue(ROIWorkItemTag.filteredPatientSsn.getTagName());
		if(patientSsnValue != null && patientSsnValue.length() > 0)
			patientSsn = patientSsnValue;
		else
			patientSsn = null;

		if (tags.getTags().contains(ROIWorkItemTag.ccpHeader)) {
			for (int i=0; (i<tags.getTags().size()); i++) {
				if (tags.getTags().get(i).equals(ROIWorkItemTag.ccpHeader)) {
					String ccpHeader = tags.getTags().get(i).getValue();
					if ((ccpHeader != null) && !ccpHeader.isEmpty()) {
						if (sendTo.isEmpty()) {
							sendTo = StringUtil.STICK;
						}
						sendTo += ccpHeader; //  |<dest1>|... 
					}
				}
			}
		}
		setWorkItemMessage(ROIWorkItemMessage.fromXml(message));
		
	}
	
	public ROIStatus getStatus()
	{
		return status;
	}

	public void setStatus(ROIStatus status)
	{
		this.status = status;
	}

	public String getGuid()
	{
		return guid;
	}

	public void setGuid(String guid)
	{
		this.guid = guid;
	}

	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}

	public void setPatientIdentifier(PatientIdentifier patientIdentifier)
	{
		this.patientIdentifier = patientIdentifier;
	}

	public ROIWorkItemMessage getWorkItemMessage()
	{
		return workItemMessage;
	}

	public void setWorkItemMessage(ROIWorkItemMessage workItemMessage)
	{
		this.workItemMessage = workItemMessage;
	}

	public WorkItem getWorkItem()
	{
		return workItem;
	}
	
	public String getUserDuz()
	{
		return userDuz;
	}

	public void setUserDuz(String userDuz)
	{
		this.userDuz = userDuz;
	}

	public String getPatientName()
	{
		return patientName;
	}

	public String getPatientSsn()
	{
		return patientSsn;
	}

	public String getSendTo()
	{
		return sendTo;
	}

	public WorkItem toWorkItem()
	{
		// guid and study URN don't change
		workItem.setStatus(this.status.getStatus());
		workItem.setMessage(ROIWorkItemMessage.toXml(this.workItemMessage));
		workItem.addTag(ROIWorkItemTag.retryCount.getTagName(), getRetryCount() + "");
		workItem.addTag(ROIWorkItemTag.outputGuid.getTagName(), getOutputGuid());
		workItem.addTag(ROIWorkItemTag.completed.getTagName(), (completed == true ? workItemCompletedValue : workItemNotCompletedValue));		

		// name and SSN do not change
		
		return workItem;
	}
	
	public String getWorkItemMessageXml()
	{
		return ROIWorkItemMessage.toXml(workItemMessage);
	}
	
	private static String dateFormat = "M/d/yyyy@kk:mm:ss";
	
	public Date getLastUpdateDate()
	{
		String lastUpdateDate = workItem.getLastUpdateDate();
		if(lastUpdateDate == null || lastUpdateDate.length() <= 0)
			return null;
		//4/5/2012@08:28:50
		SimpleDateFormat format = new SimpleDateFormat(dateFormat);
		try
		{
			return format.parse(lastUpdateDate);
		} 
		catch (ParseException e)
		{
			return null;
		}
	}
	
	public Date getCreatedDate()
	{
		String createdDate = workItem.getCreatedDate();
		if(createdDate == null || createdDate.length() <= 0)
			return null;
		//4/5/2012@08:28:50
		SimpleDateFormat format = new SimpleDateFormat(dateFormat);
		try
		{
			return format.parse(createdDate);
		} 
		catch (ParseException e)
		{
			return null;
		}
	}

	public String getOutputGuid()
	{
		return outputGuid;
	}

	public void setOutputGuid(String outputGuid)
	{
		this.outputGuid = outputGuid;
	}

	public int getRetryCount()
	{
		return retryCount;
	}

	public void setRetryCount(int retryCount)
	{
		this.retryCount = retryCount;
	}

	public String getExportQueueUrn()
	{
		return exportQueueUrn;
	}

	public void setExportQueueUrn(String exportQueueUrn)
	{
		this.exportQueueUrn = exportQueueUrn;
	}

	public boolean isExportQueueUrnSpecified()
	{
		return (exportQueueUrn != null && exportQueueUrn.length() > 0);
	}

	/**
	 * Get the completed value - determines if the work item is in a state where it will no longer move. This does not indicate the work
	 * item has been completed successfully, just that it is done
	 * @return
	 */
	public boolean isCompleted()
	{
		return completed;
	}

	public void setCompleted(boolean completed)
	{
		this.completed = completed;
	}
}
