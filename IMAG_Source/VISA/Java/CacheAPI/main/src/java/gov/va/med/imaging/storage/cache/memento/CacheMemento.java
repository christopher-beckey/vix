/**
 * 
 */
package gov.va.med.imaging.storage.cache.memento;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;

/**
 * @author VHAISWBECKEC
 *
 */
public abstract class CacheMemento
implements Serializable
{
	private static final long serialVersionUID = -75707646507196869L;
	private String name;
	private String locationUri;			// stored as a String but really a URI in the cache implementations
	private boolean enabled;
	private boolean initialized;
	private ByteChannelFactoryMemento byteChannelFactoryMemento = null;
	private EvictionTimerMemento evictionTimerMemento;
	private List<? extends EvictionStrategyMemento> evictionStrategyMementos = new ArrayList<EvictionStrategyMemento>();
	private String networkStorageDomain;
	private String networkStorageUserLogin;
	private EncryptedConfigurationPropertyString networkStorageUserPassword;
	
	public String getName()
	{
		return this.name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getLocationUri()
	{
		return this.locationUri;
	}

	public void setLocationUri(String locationUri)
	{
		this.locationUri = locationUri;
	}

	public boolean isInitialized()
	{
		return this.initialized;
	}

	public void setInitialized(boolean initialized)
	{
		this.initialized = initialized;
	}

	public boolean isEnabled()
	{
		return this.enabled;
	}

	public void setEnabled(boolean enabled)
	{
		this.enabled = enabled;
	}

	public ByteChannelFactoryMemento getByteChannelFactoryMemento()
	{
		return this.byteChannelFactoryMemento;
	}
	
	public void setByteChannelFactoryMemento(ByteChannelFactoryMemento byteChannelConfiguration)
	{
		this.byteChannelFactoryMemento = byteChannelConfiguration;
	}
	
	public void setEvictionTimerMemento(EvictionTimerMemento memento)
	{
		this.evictionTimerMemento = memento;
	}
	
	public EvictionTimerMemento getEvictionTimerMemento()
	{
		return evictionTimerMemento;
	}

	public List<? extends EvictionStrategyMemento> getEvictionStrategyMementos()
	{
		return this.evictionStrategyMementos;
	}

	public void setEvictionStrategyMementos(List<? extends EvictionStrategyMemento> evictionStrategies)
	{
		this.evictionStrategyMementos = evictionStrategies;
	}
	
	public abstract List<? extends RegionMemento> getRegionMementos();
	public abstract void setRegionMementos(List<? extends RegionMemento> regionMementos);
	
	public String getNetworkStorageDomain() {
		return networkStorageDomain;
	}

	public void setNetworkStorageDomain(String networkStorageDomain) {
		this.networkStorageDomain = networkStorageDomain;
	}
	
	
	public String getNetworkStorageUserLogin() {
		return networkStorageUserLogin;
	}

	public void setNetworkStorageUserLogin(String networkStorageUserLogin) {
		this.networkStorageUserLogin = networkStorageUserLogin;
	}

	public EncryptedConfigurationPropertyString getNetworkStorageUserPassword() {
		return networkStorageUserPassword;
	}

	public void setNetworkStorageUserPassword(EncryptedConfigurationPropertyString networkStorageUserPassword) {
		this.networkStorageUserPassword = networkStorageUserPassword;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "CacheMemento [name=" + name + ", locationUri=" + locationUri
				+ ", enabled=" + enabled + "]";
	}
	
	
}
