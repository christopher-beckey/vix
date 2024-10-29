package gov.va.med.imaging.core.router.periodiccommands;

import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;

public class PeriodicPreCacheConfiguration 
extends AbstractBaseFacadeConfiguration 
{
	private static PeriodicPreCacheConfiguration periodicPreCacheConfiguration = null;
	private String startingDaysForDodStudies;

	public PeriodicPreCacheConfiguration() 
	{
	}

	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration() {
		return this;
	}

	public synchronized static PeriodicPreCacheConfiguration getConfiguration() {
		if (periodicPreCacheConfiguration == null) {
			PeriodicPreCacheConfiguration config = new PeriodicPreCacheConfiguration();
			periodicPreCacheConfiguration = (PeriodicPreCacheConfiguration) config
					.loadConfiguration();
		}
		return periodicPreCacheConfiguration;
	}

	public void setStartingDaysForDodStudies(String startingDaysForDodStudies) {
		this.startingDaysForDodStudies = startingDaysForDodStudies;
	}

	public String getStartingDaysForDodStudies() {
		return this.startingDaysForDodStudies;
	}
}
