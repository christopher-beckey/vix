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
public class PostUserPreferenceCommandImpl
extends AbstractUserPreferenceDataSourceCommandImpl<String>
{
	private static final long serialVersionUID = -4703914542263567727L;

	private final RoutingToken globalRoutingToken;
	private final String entity;
	private final String key;
	private final String value;
	
	/**
	 * @param globalRoutingToken
	 * @param filterFields
	 */
	public PostUserPreferenceCommandImpl(
			RoutingToken globalRoutingToken,
			String entity,
			String key,
			String value)
	{
		super(globalRoutingToken);
		this.globalRoutingToken = globalRoutingToken;
		this.entity = entity;
		this.key = key;
		this.value = value;
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

	/**
	 * @return the key
	 */
	public String getKey()
	{
		return key;
	}
	/**
	 * @return the value
	 */
	public String getValue()
	{
		return value;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "postUserPreference";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, String.class, String.class, String.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getRoutingToken(), this.getEntity(), this.getKey(), this.getValue()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected String getCommandResult(VistaUserPreferenceDataSourceSpi spi)
			throws ConnectionException, MethodException {
		return spi.postUserPreference(getRoutingToken(), this.getEntity(), this.getKey(), this.getValue());
	}
}
