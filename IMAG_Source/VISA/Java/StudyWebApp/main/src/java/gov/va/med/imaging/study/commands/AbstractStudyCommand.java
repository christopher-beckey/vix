/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 16, 2012
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
package gov.va.med.imaging.study.commands;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.configuration.ImagingFacadeConfiguration;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.study.StudyFacadeContext;
import gov.va.med.imaging.study.StudyFacadeRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractStudyCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{
	/**
	 * @param methodName
	 */
	public AbstractStudyCommand(String methodName)
	{
		super(methodName);
	}
	
	@Override
	protected StudyFacadeRouter getRouter()
	{
		return StudyFacadeContext.getStudyFacadeRouter();
	}

	@Override
	protected String getWepAppName()
	{
		return "Study WebApp";
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
		getTransactionContext().setImagingSecurityContextType(ImagingSecurityContextType.MAG_WINDOWS.toString());
	}
	
	protected abstract boolean isRequiresEnterprise();
	
	protected abstract boolean isRequiresLocal();
	
	protected void checkCommandEnabled()
	throws MethodException
	{
		
		boolean enterpriseEnabled = ImagingFacadeConfiguration.getConfiguration().isEnterpriseEnabled();
		boolean localEnabled = ImagingFacadeConfiguration.getConfiguration().isLocalEnabled();
		
		if(isRequiresEnterprise() && !enterpriseEnabled)
			throw new MethodException("Operation '" + getMethodName() + "' is not available in this VISA application.");
		
		if(isRequiresLocal() && !localEnabled)
			throw new MethodException("Operation '" + getMethodName() + "' is not available in this VISA application.");
	}	
}
