/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jan 31, 2008
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
package gov.va.med.imaging.exchange.business.taglib.image;

import java.util.ArrayList;
import java.util.Collection;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.Tag;

import gov.va.med.logging.Logger;
import org.springframework.web.servlet.support.JspAwareRequestContext;
import org.springframework.web.servlet.support.RequestContext;

import gov.va.med.StudyURNFactory;
import gov.va.med.imaging.ImagingBaseWebFacadeRouter;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;

/**
 * @author VHAISWBECKEC
 *
 */
public class StudyImageListTag 
extends AbstractImageCollectionTag
{
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = Logger.getLogger(StudyImageListTag.class);
	
	public static final String REQUEST_CONTEXT_PAGE_ATTRIBUTE = "org.springframework.web.servlet.tags.REQUEST_CONTEXT";
	private String siteNumber;
	private String studyId;
	private String patientIcn;
	
	
	private Collection<Image> images;
	
	private RequestContext requestContext;
	
	public String getSiteNumber()
    {
    	return siteNumber;
    }
	public void setSiteNumber(String siteNumber)
    {
    	this.siteNumber = siteNumber;
    }

	public String getStudyId()
    {
    	return studyId;
    }
	public void setStudyId(String studyId)
    {
    	this.studyId = studyId;
    }

	public String getPatientIcn()
    {
    	return patientIcn;
    }
	public void setPatientIcn(String patientIcn)
    {
    	this.patientIcn = patientIcn;
    }

	/**
	 * Return the current RequestContext.
	 */
	protected synchronized final RequestContext getRequestContext()
	{
		if(this.requestContext == null)
		{
			this.requestContext = (RequestContext) this.pageContext.getAttribute(REQUEST_CONTEXT_PAGE_ATTRIBUTE);
			if (this.requestContext == null)
			{
				this.requestContext = new JspAwareRequestContext(this.pageContext);
				this.pageContext.setAttribute(REQUEST_CONTEXT_PAGE_ATTRIBUTE, this.requestContext);
			}
		}
		
		return this.requestContext;
	}

	// ==============================================================================
	// JSP Tag Lifecycle Events
	// ==============================================================================

	/**
	 * Create and expose the current RequestContext. Delegates to
	 * {@link #doStartTagInternal()} for actual work.
	 * 
	 * @see #REQUEST_CONTEXT_PAGE_ATTRIBUTE
	 * @see org.springframework.web.servlet.support.JspAwareRequestContext
	 */
	public final int doStartTag() 
	throws JspException
	{
		this.requestContext = getRequestContext();
	
		ImagingBaseWebFacadeRouter router = null;
    	
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(ImagingBaseWebFacadeRouter.class);
		} 
		catch (Exception x)
		{
			LOGGER.error("Exception getting the facade router implementation.", x);
			throw new JspException(x);
		}
    	
        StudyURN studyUrn = null;
    	try
        {
            try
            {
	            studyUrn = StudyURNFactory.create(getSiteNumber(), getStudyId(), getPatientIcn(), StudyURN.class);
            } 
        	catch (URNFormatException iufX)
            {
        		String msg = 
        			"StudyImageListTag.doStartTag() --> Error building StudyURN  [" + getSiteNumber() + "," + getStudyId() + "," + getPatientIcn() + "]";
        		LOGGER.error(msg);
        		throw new JspException(msg, iufX);
            }

        	Study study = router.getPatientStudy(studyUrn);
        	images = new ArrayList<Image>();
        	for(Series series : study.getSeries())
        	{
        		for(Image image : series)
        		{
        			images.add(image);
        		}
        	}
	    	
		    return images == null ? Tag.SKIP_BODY : super.doStartTag();
        } 
    	catch (MethodException mX)
        {
    		String msg = "StudyImageListTag.doStartTag() --> MethodException: Error when getting images for study URN [" + studyUrn + "]";
    		LOGGER.error(msg);
    		throw new JspException(msg, mX);
        } 
    	catch (ConnectionException mX)
        {
    		String msg = "StudyImageListTag.doStartTag() --> ConnectionException: Error when getting images for study URN [" + studyUrn + "]";
    		LOGGER.error(msg);
    		throw new JspException(msg, mX);
        } 
	}

	/**
	 * @see gov.va.med.imaging.exchange.business.taglib.image.AbstractImageCollectionTag#getImageCollection()
	 */
	@Override
	protected Collection<Image> getImageCollection() 
	throws JspException
	{
		return images;
	}

}
