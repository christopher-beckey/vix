/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 2, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.roi.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;

/**
 * This calls the async method to process ROI requests in the queue, this method should only be called by a facade and only serves the purpose 
 * of a facade always calling a sync method rather than calling the async method directly
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ProcessROIPeriodicRequestsSyncCommandImpl
extends AbstractCommandImpl<java.lang.Void>
{
	private static final long serialVersionUID = 6832149942200913072L;


	public ProcessROIPeriodicRequestsSyncCommandImpl()
	{
		super();
	}

	
	@Override
	public boolean equals(Object obj)
	{
		return false;
	}

	@Override
	protected String parameterToString()
	{
		return null;
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Void callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException
	{
		ROICommandsContext.getRouter().processROIPeriodicRequests();
		return null;
	}
}
