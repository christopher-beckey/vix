/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 12, 2018
  Developer:  vhaisltjahjb
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
package gov.va.med.imaging.federation.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.exchange.business.PersistentEntity;
import gov.va.med.imaging.exchange.business.WorkItemTags;

/**
 * @author vhaisltjahjb
 *
 */
@XmlRootElement
public class FederationWorkItemType
{
	private int id;
	private String type;
	private String subtype;
	private String status;
	private String placeId;
	private int priority;
	private String message;
	private String createdDate;
	private String creatingUser = "";
	private String creatingUserDisplayName = "";
	private String creatingApplication = "";
	private String lastUpdateDate;
	private String updatingUser = "";
	private String updatingUserDisplayName = "";
	private String updatingApplication = "";
	private String patientIcn;
	private String contextId;
	
	public FederationWorkItemType()
	{
		super();
	}

	public FederationWorkItemType(String type, String subtype, String status, String placeId, 
			String creatingUser, String creatingApplication, String patientIcn, String contextId) 
	{
		super();
		this.type = type;
		this.subtype = subtype;
		this.status = status;
		this.placeId = placeId;
		this.creatingUser = creatingUser;
		this.creatingApplication = creatingApplication;
		this.patientIcn = patientIcn;
		this.contextId = contextId;
	}


//	public void addTag(String key, String value)
//	{
//		if (getTags() == null)
//		{
//			setTags(new WorkItemTags());
//		}
//		
//		getTags().addTag(key, value);
//		
//	}
//
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getSubtype() {
		return subtype + "";
	}
	public void setSubtype(String subtype) {
		this.subtype = subtype;
	}
	public String getStatus() {
		return status + "";
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getPlaceId() {
		return placeId + "";
	}
	public void setPlaceId(String placeId) {
		this.placeId = placeId;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	public String getMessage() {
		return message + "";
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getCreatedDate() {
		return createdDate;
	}
	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}
	public String getCreatingUser() {
		return creatingUser + "";
	}
	public void setCreatingUser(String creatingUser) {
		this.creatingUser = creatingUser;
	}
	public String getCreatingApplication() {
		return creatingApplication + "";
	}
	public void setCreatingApplication(String creatingApplication) {
		this.creatingApplication = creatingApplication;
	}
	public String getLastUpdateDate() {
		return lastUpdateDate;
	}
	public void setLastUpdateDate(String lastUpdateDate) {
		this.lastUpdateDate= lastUpdateDate;
	}
	public String getUpdatingUser() {
		return updatingUser + "";
	}
	public void setUpdatingUser(String updatingUser) {
		this.updatingUser = updatingUser;
	}
	public String getUpdatingApplication() {
		return updatingApplication + "";
	}
	public void setUpdatingApplication(String updatingApplication) {
		this.updatingApplication = updatingApplication;
	}
//	public WorkItemTags getTags() {
//		return tags;
//	}
//	public void setTags(WorkItemTags tags) {
//		this.tags = tags;
//	}

	public void setCreatingUserDisplayName(String creatingUserDisplayName) {
		this.creatingUserDisplayName = creatingUserDisplayName;
	}

	public String getCreatingUserDisplayName() {
		return creatingUserDisplayName;
	}

	public void setUpdatingUserDisplayName(String updatingUserDisplayName) {
		this.updatingUserDisplayName = updatingUserDisplayName;
	}

	public String getUpdatingUserDisplayName() {
		return updatingUserDisplayName;
	}
	
	public String getPatientIcn() {
		return patientIcn;
	}
	public void setPatientIcn(String patientIcn) {
		this.patientIcn = patientIcn;
	}

	public String getContextId() {
		return contextId;
	}
	public void setContextId(String contextId) {
		this.contextId = contextId;
	}
}
