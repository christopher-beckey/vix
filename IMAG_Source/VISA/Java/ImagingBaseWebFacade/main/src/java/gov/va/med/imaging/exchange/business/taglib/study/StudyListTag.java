/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jan 30, 2008
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
package gov.va.med.imaging.exchange.business.taglib.study;

import java.text.DateFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import javax.servlet.jsp.JspException;

import gov.va.med.logging.Logger;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.GlobalArtifactIdentifierFactory;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.ImagingBaseWebFacadeRouter;
import gov.va.med.imaging.TransactionContextHelper;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.taglib.TagUtility;
import gov.va.med.imaging.exchange.enums.PatientSensitivityLevel;

/**
 * NOTE: this class uses code from the Spring Framework to get the
 * context.  Because we must derive from AbstractStudyListTag and
 * therefore cannot derive from spring's RequestContextAwareTag 
 * we do the stuff that RequestContextAwareTag does for us in the
 * doStartTag() method.
 * 
 * @author VHAISWBECKEC
 * 
 */
public class StudyListTag 
extends AbstractStudyListTag 
{
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = Logger.getLogger(StudyListTag.class);
	
	private String siteNumber;
	private String patientId;
	private String fromDate;
	private String toDate;
	private GlobalArtifactIdentifier studyId;
	private String patientSensitiveLevel;
	
	// ==============================================================================
	// Properties that may be set from the JSP
	// ==============================================================================
	
	/**
     * @return the siteNumber
     */
    public String getSiteNumber()
    {
    	return siteNumber;
    }
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
    public void setPatientId(String patientId)
    {
    	this.patientId = patientId;
    }
    
	public String getFromDate()
    {
    	return fromDate;
    }
	public void setFromDate(String fromDate)
    {
    	this.fromDate = fromDate;
    }
	
	public String getToDate()
    {
    	return toDate;
    }
	public void setToDate(String toDate)
    {
    	this.toDate = toDate;
    }
	
	public String getStudyId()
    {
    	return studyId.toString();
    }
	@SuppressWarnings("unchecked")
	public void setStudyId(String studyId) 
	throws JspException
    {
    	try
		{
			this.studyId = GlobalArtifactIdentifierFactory.create(studyId);
		}
		catch (Throwable x)
		{
			throw new JspException("StudyListTag.setStudyId() --> Encountered exception [" + x.getClass().getSimpleName() + "], study Id [" + studyId + "]: " + x.getMessage());
		}
    }
	
	// ==============================================================================
	// JSP Tag Lifecycle Events
	// ==============================================================================

	/**
	 * @return the patientSensitiveLevel
	 */
	public String getPatientSensitiveLevel() {
		return patientSensitiveLevel;
	}
	/**
	 * @param patientSensitiveLevel the patientSensitiveLevel to set
	 */
	public void setPatientSensitiveLevel(String patientSensitiveLevel) {
		this.patientSensitiveLevel = patientSensitiveLevel;
	}
	/**
	 * @see gov.va.med.imaging.exchange.business.taglib.study.AbstractStudyListTag#getStudyList()
	 */
	@Override
	protected synchronized Collection<Study> getCollection() 
	throws JspException
	{
		// this reference may be overriden by the 'real' study list
		// but it must not be null so we know we have at least tried to
		// get the studies
		List<Study> studyList = new ArrayList<Study>();		
		
		if( getSiteNumber() != null && !getSiteNumber().isEmpty() && 
			getPatientId() != null && !getPatientId().isEmpty() )
		{
	    	ImagingBaseWebFacadeRouter router = null;
	    	
			try
			{
				router = FacadeRouterUtility.getFacadeRouter(ImagingBaseWebFacadeRouter.class);
			} 
			catch (Exception x)
			{
				String msg = "StudyListTag.getCollection() --> Encountered exception [" + x.getClass().getSimpleName() + "] while getting the facade router implementation: " + x.getMessage();
				LOGGER.error(msg);
				throw new JspException(msg, x);
			}
	    	
	    	DateFormat df = TagUtility.getClientDateFormat(pageContext.getRequest());
	    	
	    	Date from = new Date(0L);
	    	if(getFromDate() != null && getFromDate().length() > 0)
	    		try
	    		{
	    			from = df.parse(getFromDate());
	    		}
	    		catch(ParseException pX)
	    		{
	    			from = new Date(0L);
	    			String msg = "StudyListTag.getCollection() --> From date [" + getFromDate() + "] is not in the correct format 'MM/dd/yyyy' and is being ignored.";
	    			LOGGER.error(msg, pX);
	    			appendMessage(msg);
	    		}
	    		
	    	Date to = new Date();//Long.MAX_VALUE); 
	    	if(getToDate() != null && getToDate().length() > 0)
	    		try
	    		{
	    			to = df.parse(getToDate());
	    		}
	    		catch(ParseException pX)
	    		{
	    			to = new Date(Long.MAX_VALUE);
	    			String msg = "StudyListTag.getCollection() --> To date [" + getToDate() + "] is not in the correct format 'MM/dd/yyyy' and is being ignored.";
	    			LOGGER.error(msg, pX);
	    			appendMessage(msg);
	    		}
	
	    	StudyFilter filter = new StudyFilter( from, to, studyId );
	    	
	    	if((this.patientSensitiveLevel != null) &&(this.patientSensitiveLevel.length() > 0))
	    	{
	    		int sensitiveLevel = Integer.parseInt(patientSensitiveLevel);
	    		filter.setMaximumAllowedLevel(PatientSensitivityLevel.getPatientSensitivityLevel(sensitiveLevel));
                getLogger().info("StudyListTag.getCollection() --> Setting allowed sensitive level to [{}]", sensitiveLevel);
	    	}
	    	try 
	    	{
				TransactionContextHelper.setTransactionContextFields("getPatientStudies", getPatientId());
	    		// only need shallow study list, not full graph
	    		studyList = router.getPatientStudyList(
	    			RoutingTokenImpl.createVARadiologySite(getSiteNumber()),
	    			PatientIdentifier.icnPatientIdentifier(getPatientId()), 
	    			filter
	    		);
	    	}
			catch (Exception ex)
			{
				studyList = null;
				String msg = "StudyListTag.getCollection() --> Encountered exception [" + ex.getClass().getSimpleName() + "]: " + ex.getMessage();
				LOGGER.error(msg);
				throw new JspException(msg, ex);
			}
		}
		
		return studyList;
	}
}
