/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 21, 2010
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
package gov.va.med.imaging.vixserverhealth.taglib;

import gov.va.med.imaging.vixserverhealth.web.VixServerHealthView;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.IterationTag;
import javax.servlet.jsp.tagext.TagSupport;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class VixServerHealthViewAttributeCollectionTag 
extends BodyTagSupport
{
	private static final long serialVersionUID = 1L;
	private Logger logger = Logger.getLogger(this.getClass());
	private String emptyResultMessage = null;
	
	private Map<String, String> healthAttributes;
	private Iterator<String> healthAttributeKeyIterator;
	private String currentKey;
	
	/**
	 * The message to show if the site list is empty
	 * @return
	 */
	public String getEmptyResultMessage()
    {
    	return emptyResultMessage;
    }

	public void setEmptyResultMessage(String emptyResultMessage)
    {
    	this.emptyResultMessage = emptyResultMessage;
    }
	
	private AbstractVixServerHealthTag getParentJavaLogTag()
	{
		return (AbstractVixServerHealthTag)TagSupport.findAncestorWithClass(this, AbstractVixServerHealthTag.class);
	}

	/**
	 * 
	 * @return
	 * @throws JspException
	 */
	private VixServerHealthView getVixServerHealthView() 
	throws JspException
	{
		AbstractVixServerHealthTag healthViewTag = getParentJavaLogTag();
		if(healthViewTag == null)
			throw new JspException("A VIX Server Health View Property tag does not have an ancestor VIX Server Health View tag.");
		
		VixServerHealthView view = healthViewTag.getVixServerHealthView();
		
		if(view == null)
			throw new JspException("A VIX Server Health View Property tag was unable to get the filename from its parent tag.");
		
		return view;
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
		healthAttributes = getVixServerHealthView().getRawHealthAttributes();
		
		if(healthAttributes == null || healthAttributes.size() < 1)
		{
	    	if(getEmptyResultMessage() != null)
	    		try{pageContext.getOut().write(getEmptyResultMessage());}
	    		catch(IOException ioX){logger.error("Unable to write empty result set message.");}
	    		
			return BodyTag.SKIP_BODY;
		}
		
		// in order to sort the keys, put all of the keys in a list and then sort the list
		List<String> keys = new ArrayList<String>(healthAttributes.keySet().size());
		keys.addAll(healthAttributes.keySet());
		Collections.sort(keys);		
		
		// then get an iterator to the sorted keys
		healthAttributeKeyIterator = keys.iterator();// healthAttributes.keySet().iterator();
		
		currentKey = healthAttributeKeyIterator.next();
		return BodyTag.EVAL_BODY_INCLUDE;
	}

	/**
	 * 
	 * @return
	 */
	public String getCurrentAttributeKey()
	{
		return currentKey;
	}
	
	public String getCurrentAttributeValue()
	{
		return healthAttributes.get(currentKey);
	}
	
	@Override
    public int doAfterBody() 
	throws JspException
    {
		if(healthAttributeKeyIterator.hasNext())
		{
			currentKey = healthAttributeKeyIterator.next();
			return IterationTag.EVAL_BODY_AGAIN;
		}
		else
		{
			currentKey = null;
			return IterationTag.SKIP_BODY;
		}
    }
}
