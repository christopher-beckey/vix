/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 7, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.consult.federation.commands;

import gov.va.med.imaging.consult.federation.FederationConsultContext;
import gov.va.med.imaging.consult.federation.FederationConsultRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author Administrator
 *
 */
public abstract class AbstractFederationConsultCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{
	
	public AbstractFederationConsultCommand(String methodName)
	{
		super(methodName);
	}
		
	/**
	 * 
	 * @return
	 */
	@Override
	protected FederationConsultRouter getRouter()
	{
		return FederationConsultContext.getFederationRouter();
	}
		
	@Override
	protected String getWepAppName() 
	{
		return "Federation Consult WebApp";
	}
	
	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		return null;
	}

}
