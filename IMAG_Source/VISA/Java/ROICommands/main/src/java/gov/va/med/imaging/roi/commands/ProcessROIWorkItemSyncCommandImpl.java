/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 13, 2012
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
 * This calls the async method to process a single ROI request, this method should only be called by a facade and only serves the purpose 
 * of a facade always calling a sync method rather than calling the async method directly
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ProcessROIWorkItemSyncCommandImpl
extends AbstractCommandImpl<java.lang.Void>
{
	private static final long serialVersionUID = -5755075878707095253L;
	
	private final String guid;
	
	public ProcessROIWorkItemSyncCommandImpl(String guid)
	{
		this.guid = guid;
	}

	public String getGuid()
	{
		return guid;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Void callSynchronouslyInTransactionContext() 
	throws MethodException, ConnectionException
	{
		ROICommandsContext.getRouter().processROIWorkItem(getGuid());
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		if(obj instanceof ProcessROIWorkItemSyncCommandImpl)
		{
			ProcessROIWorkItemSyncCommandImpl that = (ProcessROIWorkItemSyncCommandImpl)obj;
			return this.getGuid().equals(that.getGuid());
		}
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return getGuid();
	}

}
