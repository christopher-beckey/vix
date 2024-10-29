/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 27, 2010
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
package gov.va.med.imaging.ax.webservices.commands;

// import java.rmi.RemoteException;

import gov.va.med.imaging.ax.AxContext;
import gov.va.med.imaging.ax.AxRouter;
import gov.va.med.imaging.ax.AxWebAppRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.ax.webservices.rest.exceptions.AxMetadataException;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractAxWebserviceCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{
	public AbstractAxWebserviceCommand(String methodName)
	{
		super(methodName);
	}

	@Override
	protected AxWebAppRouter getRouter()
	{
		return AxContext.getAxRouter();
	}

	@Override
	protected String getWepAppName()
	{
		return "Ax WebApp";
	}
	
	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}
	
	public E executeMixCommand() 
	throws AxMetadataException // RemoteException
	{
		try
		{
			return super.execute();
		}
		catch(MethodException mX)
		{
			throw new AxMetadataException("MethodException, unable to complete method '" + getMethodName() + "', " + mX.getMessage(), mX);
		}
		catch(ConnectionException cX)
		{
			throw new AxMetadataException("ConnectionException, unable to complete method '" + getMethodName() + "', " + cX.getMessage(), cX);
		}
		catch(Exception ex)
		{
			throw new AxMetadataException("Exception, unable to complete method '" + getMethodName() + "', " + ex.getMessage(), ex);
		}
	}

	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		return null;
	}
}
