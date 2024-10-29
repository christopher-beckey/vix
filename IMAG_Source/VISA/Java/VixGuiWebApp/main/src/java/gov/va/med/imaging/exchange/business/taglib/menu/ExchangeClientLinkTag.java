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
public class ExchangeClientLinkTag 
extends AbstractLinkTag
{
	private static final long serialVersionUID = 1L;
	private static final String[] permissableRoles = new String[]{"developer"};
	
	private final static String href = "/Vix/secure/ExchangeTestClient.jspx";
	private final static String elementBody = "Exchange";
	
	private String targetSiteNumber;
	private String siteNumber;
	private String patientId;
	private final static String protocolOverride = "exchange";

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

}
