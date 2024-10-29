/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jan 22, 2008
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
package gov.va.med.imaging.exchange.business.taglib.patient;

import gov.va.med.imaging.exchange.business.Patient;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.IterationTag;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TryCatchFinally;

import gov.va.med.logging.Logger;

import org.springframework.web.servlet.support.RequestContext;

/**
 * This class must be subclassed with something that will set the
 * List of Study instances to display.
 * 
 * @author VHAISWBECKEC
 *
 */
public abstract class AbstractPatientListTag 
extends BodyTagSupport
implements TryCatchFinally
{
	private  static final Logger LOGGER = Logger.getLogger(AbstractPatientListTag.class);
	
	public static final String REQUEST_CONTEXT_PAGE_ATTRIBUTE = "org.springframework.web.servlet.tags.REQUEST_CONTEXT";
	/**
	 * {@link javax.servlet.jsp.PageContext} attribute for page-level
	 * {@link RequestContext} instance.
	 */
	private static final long serialVersionUID = 1L;
	private String emptyResultMessage;
    private Iterator<Patient> patientIterator;
    private Patient currentPatient;
	
	/**
     * @return the studyList
     */
    protected abstract List<Patient> getPatientList()
    throws JspException;

	/**
	 * The message to show if the study list is empty
	 * @return
	 */
	public String getEmptyResultMessage()
    {
    	return this.emptyResultMessage;
    }

	public void setEmptyResultMessage(String emptyResultMessage)
    {
    	this.emptyResultMessage = emptyResultMessage;
    }
	
	/**
     * @see javax.servlet.jsp.tagext.TagSupport#doStartTag()
     */
    @Override
    public int doStartTag() 
    throws JspException
    {
    	List<Patient> patientList = getPatientList();
    	
    	if(patientList != null && patientList.size() > 0)
    	{
    		this.patientIterator = patientList.iterator();
    		currentPatient = patientIterator.next();
    	    return Tag.EVAL_BODY_INCLUDE;
    	}
    	
    	if(getEmptyResultMessage() != null)
			try
			{
				pageContext.getOut().write(getEmptyResultMessage());
			}
			catch (IOException ioX)
			{ 
				LOGGER.warn("AbstractPatientListTag.doStartTag() --> Unable to write empty result message.");
			}

    	return Tag.SKIP_BODY;
    }

    Patient getCurrentPatient()
    {
    	return this.currentPatient;
    }
        
	@Override
    public int doAfterBody() 
	throws JspException
    {
	    if(this.patientIterator != null && this.patientIterator.hasNext())
	    {
	    	this.currentPatient = this.patientIterator.next();
	    	return IterationTag.EVAL_BODY_AGAIN;
	    }
	    else
	    {
	    	this.currentPatient = null;
	    	return IterationTag.SKIP_BODY;
	    }
    }

	/**
     * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
     */
    @Override
    public int doEndTag() 
    throws JspException
    {
	    return Tag.EVAL_PAGE;
    }

	// ==============================================================================
	// TryCatchFinally Events
	// ==============================================================================

	/**
	 * @see javax.servlet.jsp.tagext.TryCatchFinally#doCatch(java.lang.Throwable)
	 */
	@Override
    public void doCatch(Throwable t) 
	throws Throwable
    {
        LOGGER.error("AbstractPatientListTag.doCatch() --> Exception: {}", t.getMessage());
		throw new JspException(t);
    }

	@Override
    public void doFinally() {}
}
