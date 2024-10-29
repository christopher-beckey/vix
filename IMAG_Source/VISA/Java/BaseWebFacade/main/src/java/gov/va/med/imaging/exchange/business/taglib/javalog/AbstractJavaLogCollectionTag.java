/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 16, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.exchange.business.taglib.javalog;

import gov.va.med.imaging.exchange.business.taglib.exceptions.MissingRequiredArgumentException;
import gov.va.med.imaging.javalogs.JavaLogFile;

import java.io.IOException;
import java.util.Collection;
import java.util.Iterator;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.IterationTag;

import gov.va.med.logging.Logger;


/**
 * Abstract collection tag to read the list of Java Log Files on the VIX
 * 
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractJavaLogCollectionTag 
extends BodyTagSupport 
{
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = Logger.getLogger(AbstractJavaLogCollectionTag.class);
	
	private String emptyResultMessage;
	private Collection<JavaLogFile> files;
	private Iterator<JavaLogFile> fileIterator;
	private JavaLogFile currentFile;
	
	protected abstract Collection<JavaLogFile> getFiles()
	throws JspException, MissingRequiredArgumentException;
	
	/**
	 * The message to show if the site list is empty
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
		try
        {
			this.files = getFiles();
        } 
		catch (MissingRequiredArgumentException e)
        {
            LOGGER.warn("AbstractJavaLogCollectionTag.doStartTag() --> Encountered MissingRequiredArgumentException: {}", e.getMessage());
			
			// Fortify change: can't expose messages for some reason
			try
			{
				pageContext.getOut().write("AbstractJavaLogCollectionTag.doStartTag() --> Encountered MissingRequiredArgumentException");
			}
			catch (IOException ioX)
			{ 
				LOGGER.error("AbstractJavaLogCollectionTag.doStartTag() --> Unable to write exception message.");
				throw new JspException("AbstractJavaLogCollectionTag.doStartTag() --> Unable to write exception message.", ioX);
			}
			
			return BodyTag.SKIP_BODY;
        }
		
		if(this.files == null || this.files.size() < 1)
		{
	    	if(getEmptyResultMessage() != null)
				try
				{
					pageContext.getOut().write(getEmptyResultMessage());
				}
				catch (IOException ioX)
				{ 
					LOGGER.error("AbstractJavaLogCollectionTag.doStartTag() --> Unable to write empty result set message.");
					throw new JspException("AbstractJavaLogCollectionTag.doStartTag() --> Unable to write exception message.", ioX);
				}

			return BodyTag.SKIP_BODY;
		}
		
		this.fileIterator = this.files.iterator();
		this.currentFile = this.fileIterator.next();
		
		return BodyTag.EVAL_BODY_INCLUDE;
	}
	
	/**
	 * @return the currentFile
	 */
	public JavaLogFile getCurrentFile() {
		return this.currentFile;
	}

	@Override
    public int doAfterBody() 
	throws JspException
    {
		if(this.fileIterator != null && this.fileIterator.hasNext())
		{
			this.currentFile = this.fileIterator.next();
			return IterationTag.EVAL_BODY_AGAIN;
		}
		else
		{
			this.currentFile = null;
			return IterationTag.SKIP_BODY;
		}
    }
}
