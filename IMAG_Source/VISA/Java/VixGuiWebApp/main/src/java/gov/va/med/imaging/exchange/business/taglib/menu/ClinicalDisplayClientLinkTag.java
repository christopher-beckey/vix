/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jul 14, 2008
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
package gov.va.med.imaging.exchange.business.taglib.menu;

import java.util.HashMap;
import java.util.Map;

/**
 * @author VHAISWBECKEC
 *
 */
public class ClinicalDisplayClientLinkTag 
extends AbstractLinkTag
{
	private static final long serialVersionUID = 1L;
	private static final String[] permissableRoles = new String[]{"developer"};
	
	private final static String href = "/Vix/secure/ClinicalDisplayTestClient.jspx";
	private final static String elementBody = "Clinical Display";
	
	private String targetSiteNumber;
	private String siteNumber;
	private String patientId;
	private String fromDate;
	private String toDate;
	private String studyId;
	private String studyPackage;
	private String studyClass;
	private String studyType;
	private String studyEvent;
	private String studySpecialty;
	private String originId;
	private final static String protocolOverride = "cdtp";

	// The accessor methods, being simple generated methods, are at the end of this file
	
	@Override
	protected String getHref()
	{
		return href;
	}
	
	@Override
	protected String[] getPermissableRoles(String href)
    {
    	return permissableRoles;
    }
    
	@Override
	protected Map<String, String> getQueryParameters()
	{
		Map<String, String> queryParameters = new HashMap<String, String>();
		
		queryParameters.put("protocolOverride", protocolOverride);
		
		if(getSiteNumber() != null && getSiteNumber().length() > 0)
			queryParameters.put("siteNumber", getSiteNumber());
		
		if(getTargetSiteNumber() != null && getTargetSiteNumber().length() > 0)
			queryParameters.put("targetSiteNumber", getTargetSiteNumber());
		
		if(getPatientId() != null && getPatientId().length() > 0)
			queryParameters.put("patientId", getPatientId());
		
		if(getFromDate() != null && getFromDate().length() > 0)
			queryParameters.put("fromDate", getFromDate());
		
		if(getToDate() != null && getToDate().length() > 0)
			queryParameters.put("toDate", getToDate());
		
		if(getStudyId() != null && getStudyId().length() > 0)
			queryParameters.put("studyId", getStudyId());
		
		if(getStudyPackage() != null && getStudyPackage().length() > 0)
			queryParameters.put("studyPackage", getStudyPackage());
		
		if(getStudyClass() != null && getStudyClass().length() > 0)
			queryParameters.put("studyClass", getStudyClass());
		
		if(getStudyType() != null && getStudyType().length() > 0)
			queryParameters.put("studyType", getStudyType());
		
		if(getStudyEvent() != null && getStudyEvent().length() > 0)
			queryParameters.put("studyEvent", getStudyEvent());
		
		if(getStudySpecialty() != null && getStudySpecialty().length() > 0)
			queryParameters.put("studySpecialty", getStudySpecialty());
		
		if(getOriginId() != null && getOriginId().length() > 0)
			queryParameters.put("originId", getOriginId());
		
		return queryParameters;
	}

	/**
     * @see gov.va.med.imaging.exchange.business.taglib.menu.AbstractLinkTag#getAnchorBody()
     */
    @Override
    protected String getAnchorBody()
    {
	    return elementBody;
    }

	/**
     * @return the targetSiteNumber
     */
    public String getTargetSiteNumber()
    {
    	return targetSiteNumber;
    }

	/**
     * @param targetSiteNumber the targetSiteNumber to set
     */
    public void setTargetSiteNumber(String targetSiteNumber)
    {
    	this.targetSiteNumber = targetSiteNumber;
    }

	/**
     * @return the siteNumber
     */
    public String getSiteNumber()
    {
    	return siteNumber;
    }

	/**
     * @param siteNumber the siteNumber to set
     */
    public void setSiteNumber(String siteNumber)
    {
    	this.siteNumber = siteNumber;
    }

	/**
     * @return the patientId
     */
    public String getPatientId()
    {
    	return patientId;
    }

	/**
     * @param patientId the patientId to set
     */
    public void setPatientId(String patientId)
    {
    	this.patientId = patientId;
    }

	/**
     * @return the fromDate
     */
    public String getFromDate()
    {
    	return fromDate;
    }

	/**
     * @param fromDate the fromDate to set
     */
    public void setFromDate(String fromDate)
    {
    	this.fromDate = fromDate;
    }

	/**
     * @return the toDate
     */
    public String getToDate()
    {
    	return toDate;
    }

	/**
     * @param toDate the toDate to set
     */
    public void setToDate(String toDate)
    {
    	this.toDate = toDate;
    }

	/**
     * @return the studyId
     */
    public String getStudyId()
    {
    	return studyId;
    }

	/**
     * @param studyId the studyId to set
     */
    public void setStudyId(String studyId)
    {
    	this.studyId = studyId;
    }

	/**
     * @return the studyPackage
     */
    public String getStudyPackage()
    {
    	return studyPackage;
    }

	/**
     * @param studyPackage the studyPackage to set
     */
    public void setStudyPackage(String studyPackage)
    {
    	this.studyPackage = studyPackage;
    }

	/**
     * @return the studyClass
     */
    public String getStudyClass()
    {
    	return studyClass;
    }

	/**
     * @param studyClass the studyClass to set
     */
    public void setStudyClass(String studyClass)
    {
    	this.studyClass = studyClass;
    }

	/**
     * @return the studyType
     */
    public String getStudyType()
    {
    	return studyType;
    }

	/**
     * @param studyType the studyType to set
     */
    public void setStudyType(String studyType)
    {
    	this.studyType = studyType;
    }

	/**
     * @return the studyEvent
     */
    public String getStudyEvent()
    {
    	return studyEvent;
    }

	/**
     * @param studyEvent the studyEvent to set
     */
    public void setStudyEvent(String studyEvent)
    {
    	this.studyEvent = studyEvent;
    }

	/**
     * @return the studySpecialty
     */
    public String getStudySpecialty()
    {
    	return studySpecialty;
    }

	/**
     * @param studySpecialty the studySpecialty to set
     */
    public void setStudySpecialty(String studySpecialty)
    {
    	this.studySpecialty = studySpecialty;
    }

	/**
     * @return the originId
     */
    public String getOriginId()
    {
    	return originId;
    }

	/**
     * @param originId the originId to set
     */
    public void setOriginId(String originId)
    {
    	this.originId = originId;
    }
	
	
	
}
