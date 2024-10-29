/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 7, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.tiu.federation.commands;

import gov.va.med.imaging.tiu.federation.FederationTIUContext;
import gov.va.med.imaging.tiu.federation.FederationTIURouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author Administrator
 *
 */
public abstract class AbstractFederationTIUCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{	
	public AbstractFederationTIUCommand(String methodName)
	{
		super(methodName);
	}
	
	/**
	 * 
	 * @return
	 */
	@Override
	protected FederationTIURouter getRouter()
	{
		return FederationTIUContext.getFederationRouter();
	}
		
	@Override
	protected String getWepAppName() 
	{
		return "Federation TIU WebApp";
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
