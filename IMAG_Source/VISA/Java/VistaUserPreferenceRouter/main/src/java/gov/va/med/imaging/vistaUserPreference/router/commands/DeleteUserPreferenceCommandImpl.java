/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.vistaUserPreference.datasource.VistaUserPreferenceDataSourceSpi;

/**
 * @author Budy Tjahjo
 *
 */
public class DeleteUserPreferenceCommandImpl
extends AbstractUserPreferenceDataSourceCommandImpl<String>
{
	private static final long serialVersionUID = -4703914542263567027L;

	private final RoutingToken globalRoutingToken;
	private final String entity;
	private final String key;
	
	/**
	 * @param globalRoutingToken
	 * @param userID
	 * @param key
	 */
	public DeleteUserPreferenceCommandImpl(
			RoutingToken globalRoutingToken,
			String entity,
			String key)
	{
		super(globalRoutingToken);
		this.globalRoutingToken = globalRoutingToken;
		this.entity = entity;
		this.key = key;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getRoutingToken()
	 */
	@Override
	public RoutingToken getRoutingToken()
	{
		return globalRoutingToken;
	}

	/**
	 * @return the entity
	 */
	public String getEntity()
	{
		return entity;
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "deleteUserPreference";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, String.class, String.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getRoutingToken(), this.getEntity(), this.getKey()};
	}

	private String getKey() {
		return key;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected String getCommandResult(VistaUserPreferenceDataSourceSpi spi)
			throws ConnectionException, MethodException {
		return spi.deleteUserPreference(getRoutingToken(), this.getEntity(), this.getKey());
	}

}
