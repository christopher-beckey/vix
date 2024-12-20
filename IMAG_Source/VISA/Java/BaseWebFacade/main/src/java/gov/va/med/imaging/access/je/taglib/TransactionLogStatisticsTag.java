/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jul 1, 2008
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
package gov.va.med.imaging.access.je.taglib;

import gov.va.med.imaging.access.TransactionLogEntry;
import gov.va.med.imaging.access.TransactionLogStatistics;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.BodyTagSupport;

/**
 * @author VHAISWBECKEC
 * This tag MUST live within a TransactionLogTag, which maintains the 
 * collection and the enumeration of the collection.
 * This tag, and its derivations, must appear after a TransactionLogEntriesTag
 * otherwise the enumeration needed to calculate the statistics will never occur.
 */
public abstract class TransactionLogStatisticsTag 
extends BodyTagSupport
implements TransactionLogEntryParent
{
	private static final long serialVersionUID = 1L;

	/**
	 * An instance of TransactionLogStatistics is a derivation of
	 * TransactionLogEntry, the properties return calculated statistics
	 * rather than the individual entry properties.
	 * 
	 * @return
	 */
	public abstract TransactionLogStatistics getTransactionLogStatistics();
	
	protected TransactionLogTag getTransactionLogParent()
	{
		return (TransactionLogTag)BodyTagSupport.findAncestorWithClass(this, TransactionLogTag.class);
	}

	/**
     * @see javax.servlet.jsp.tagext.TagSupport#doStartTag()
     */
    @Override
    public int doStartTag() 
    throws JspException
    {
	    return getTransactionLogStatistics() == null ? BodyTag.SKIP_BODY : BodyTag.EVAL_BODY_INCLUDE;
    }

	/**
	 * The fact that this class implements the TransactionLogEntryParent interface 
	 * (i.e. this method) means that the property tags may be used to display
	 * the statistical data.
     * @see gov.va.med.imaging.access.je.taglib.TransactionLogEntryParent#getTransactionLogEntry()
     */
    @Override
    public TransactionLogEntry getTransactionLogEntry()
    {
	    return getTransactionLogStatistics();
    }
}
