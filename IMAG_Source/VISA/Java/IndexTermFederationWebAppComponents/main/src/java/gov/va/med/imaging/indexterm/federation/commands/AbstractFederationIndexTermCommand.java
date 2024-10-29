/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 7, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.indexterm.federation.commands;

import gov.va.med.imaging.indexterm.federation.FederationIndexTermContext;
import gov.va.med.imaging.indexterm.federation.FederationIndexTermRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author Administrator
 *
 */
public abstract class AbstractFederationIndexTermCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{
	
	public AbstractFederationIndexTermCommand(String methodName)
	{
		super(methodName);
	}
	
	/**
	 * 
	 * @return
	 */
	@Override
	protected FederationIndexTermRouter getRouter()
	{
		return FederationIndexTermContext.getFederationRouter();
	}
		
	@Override
	protected String getWepAppName() 
	{
		return "Federation IndexTerm WebApp";
	}
	
	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		return null;
	}
	
}
