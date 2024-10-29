/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * @date Jul 6, 2010
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author vhaiswbeckec
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

package gov.va.med.log4j;

import java.io.Serializable;

import org.apache.logging.log4j.core.Filter;
import org.apache.logging.log4j.core.Layout;
import org.apache.logging.log4j.core.LogEvent;
import org.apache.logging.log4j.core.appender.AbstractAppender;

//import org. apache.log4j.AppenderSkeleton;
//import org. apache.log4j.spi.LoggingEvent;

/**
 * An Appender implementation that throws everything away.
 * @author vhaiswbeckec
 *
 */
public class NullAppender
extends AbstractAppender
{
	protected NullAppender(String name, Filter filter, Layout<? extends Serializable> layout) {
		super(name, filter, layout);
		// TODO Auto-generated constructor stub
	}

	/* (non-Javadoc)
	 * @see org. apache.log4j.AppenderSkeleton#append(org. apache.log4j.spi.LoggingEvent)
	 */
//	@Override
//	protected void append(LoggingEvent arg0)
//	{
//	}

	/* (non-Javadoc)
	 * @see org. apache.log4j.Appender#close()
	 */
//	@Override
//	public void close()
//	{
//	}

	public boolean requiresLayout()
	{
		return false;
	}

	@Override
	public void append(LogEvent event) {
		// TODO Auto-generated method stub
		
	}
}
