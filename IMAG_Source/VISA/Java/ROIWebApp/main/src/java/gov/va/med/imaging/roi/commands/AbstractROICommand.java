/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 22, 2012
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

import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.roi.ROIFacadeContext;
import gov.va.med.imaging.roi.ROIFacadeRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractROICommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{

	/**
	 * @param methodName
	 */
	public AbstractROICommand(String methodName)
	{
		super(methodName);
		getTransactionContext().setImagingSecurityContextType(ImagingSecurityContextType.MAG_WINDOWS.name());
	}
	
	@Override
	protected ROIFacadeRouter getRouter()
	{
		return ROIFacadeContext.getRoiFacadeRouter();
	}

	@Override
	protected String getWepAppName()
	{
		return "ROI WebApp";
	}

	@Override
	public String getInterfaceVersion()
	{
		return "V1";
	}

	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		return null;
	}
	
	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}
}
