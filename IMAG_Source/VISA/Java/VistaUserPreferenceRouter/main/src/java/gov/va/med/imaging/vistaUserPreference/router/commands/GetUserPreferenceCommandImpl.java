/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: Budy Tjahjo
 */
package gov.va.med.imaging.vistaUserPreference.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.vistaUserPreference.datasource.VistaUserPreferenceDataSourceSpi;

/**
 * @author Budy Tjahjo
 *
 */
public class GetUserPreferenceCommandImpl
extends AbstractUserPreferenceDataSourceCommandImpl<List<String>>
{
	private static final long serialVersionUID = -4603914542263562727L;
	
	private final RoutingToken globalRoutingToken;
	private final String entity;
	private final String key;
	
	/**
	 * @param globalRoutingToken
	 * @param userID
	 * @param key
	 */
	public GetUserPreferenceCommandImpl(
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
	 * @return the key
	 */
	public String getKey()
	{
		return this.key;
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
		return "getUserPreference";
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
		return new Object[] {getRoutingToken(), getEntity(), getKey()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<String> getCommandResult(VistaUserPreferenceDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getUserPreference(getRoutingToken(), getEntity(), getKey());
	}
}
