
package gov.va.med.imaging.transactions;

import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;

/**
 * @author Administrator
 *
 */
public abstract class AbstractTransactionLogStatsGroupConfiguration
extends AbstractBaseFacadeConfiguration
{
	protected TransactionLogStatsSearchableCommandGroup group = null;
	
	public AbstractTransactionLogStatsGroupConfiguration()
	{
		super();
	}

	/**
	 * @return the group
	 */
	public TransactionLogStatsSearchableCommandGroup getGroup()
	{
		return group;
	}

	/**
	 * @param group the group to set
	 */
	public void setGroup(TransactionLogStatsSearchableCommandGroup group)
	{
		this.group = group;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration#loadDefaultConfiguration()
	 */
	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration()
	{
		this.group = null;
		return this;
	}

}
