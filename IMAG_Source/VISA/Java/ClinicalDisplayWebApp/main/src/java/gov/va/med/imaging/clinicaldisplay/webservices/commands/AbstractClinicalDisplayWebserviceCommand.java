/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 3, 2010
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
package gov.va.med.imaging.clinicaldisplay.webservices.commands;

import java.rmi.RemoteException;

import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.clinicaldisplay.ImagingClinicalDisplayContext;
import gov.va.med.imaging.clinicaldisplay.configuration.ClinicalDisplayWebAppConfiguration;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractClinicalDisplayWebserviceCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{

	public AbstractClinicalDisplayWebserviceCommand(String methodName)
	{
		super(methodName);
	}

	@Override
	protected ClinicalDisplayRouter getRouter()
	{
		return ImagingClinicalDisplayContext.getRouter();
	}

	@Override
	protected String getWepAppName()
	{
		return "Clinical Display WebApp";
	}

	public E executeClinicalDisplayCommand() 
	throws RemoteException
	{
		try
		{
			return super.execute();
		}
		catch(MethodException mX)
		{
			throw new RemoteException("MethodException, unable to complete method '" + getMethodName() + "', " + mX.getMessage(), mX);
		}
		catch(ConnectionException cX)
		{
			throw new RemoteException("ConnectionException, unable to complete method '" + getMethodName() + "', " + cX.getMessage(), cX);
		}
		catch(Exception ex)
		{
			throw new RemoteException("Exception, unable to complete method '" + getMethodName() + "', " + ex.getMessage(), ex);
		}
	}
	
	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}
	
	protected ClinicalDisplayWebAppConfiguration getClinicalDisplayConfiguration()
	{
		return ClinicalDisplayWebAppConfiguration.getConfiguration();
	}

	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		// TODO Auto-generated method stub
		return null;
	}	
}
