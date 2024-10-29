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
package gov.va.med.imaging.core.router.commands;

import java.io.IOException;
import java.io.InputStream;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.javalogs.JavaLogReader;

/**
 * @author vhaiswwerfej
 *
 */
public class GetJavaLogFileCommandImpl 
extends AbstractCommandImpl<InputStream> 
{
	private static final long serialVersionUID = 6834785634423036573L;
	private static final Logger logger = Logger.getLogger(GetJavaLogFileCommandImpl.class);
	
	private final String filename;
	
	public GetJavaLogFileCommandImpl(String filename)
	{
		super();
		this.filename = filename;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public InputStream callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException 
	{
		if(this.filename == null)
		{
			throw new MethodException("GetJavaLogFileCommandImpl.callSynchronouslyInTransactionContext() --> A file name was not given.");
		}

        logger.info("GetJavaLogFileCommandImpl.callSynchronouslyInTransactionContext() --> Loading Java log file [{}]", this.filename);
		try
		{
			return JavaLogReader.getJavaLogFile(getFilename());
		}
		catch(IOException fnfX)
		{
			String msg = "GetJavaLogFileCommandImpl.callSynchronouslyInTransactionContext() --> Encountered IOException for file [" + this.filename + "]: " + fnfX.getMessage();
			logger.error(msg);
			throw new MethodException(msg, fnfX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) 
	{
		return false;
	}

	/**
	 * @return the filename
	 */
	public String getFilename() {
		return this.filename;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString() 
	{
		return "File name: " + this.filename;
	}
}
