/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.commands;

import gov.va.med.imaging.study.web.ViewerStudyFacadeContext;
import gov.va.med.imaging.study.web.ViewerStudyFacadeRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author Julian
 *
 */
public abstract class AbstractViewerStudyWebCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{

	/**
	 * @param methodName
	 */
	public AbstractViewerStudyWebCommand(String methodName)
	{
		super(methodName);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getRouter()
	 */
	@Override
	protected ViewerStudyFacadeRouter getRouter()
	{
		return ViewerStudyFacadeContext.getRouter();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getWepAppName()
	 */
	@Override
	protected String getWepAppName()
	{
		return "Viewer Study WebApp";
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#setAdditionalTransactionContextFields()
	 */
	@Override
	public void setAdditionalTransactionContextFields()
	{
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getRequestTypeAdditionalDetails()
	 */
	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getInterfaceVersion()
	 */
	@Override
	public String getInterfaceVersion()
	{
		return "v1";
	}

}
