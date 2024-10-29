/**
 * 
 */
package gov.va.med.cache.gui.client;

import com.google.gwt.i18n.client.Messages;

/**
 * @author VHAISWBECKEC
 *
 */
public interface ClientMessages 
extends Messages 
{
	String cacheClearMessage(String cacheName);
	String groupDeleteMessage(String cacheGroupSemantic, String groupName);
	String instanceDeleteMessage(String instanceName);
	
	String cacheInfoURI();
	String cacheInfoProtocol();
	String cacheInfoLocation();
	
	String regionInfoUsed();
	String regionInfoTotal();
	String regionInfoEvictionStrategies();

	String groupInfoSize();
	String groupInfoLastAccessed();

	String instanceInfoSize();
	String instanceInfoLastAccessed();
	String instanceInfoChecksum();
	
	String halSays(String cacheName);

	String cacheElement();
	String cacheDescriptionElement();
	String cacheDescriptionItemCollectionElement();
	String cacheDescriptionItemElement();

	String regionElement();
	String regionDescriptionElement();
	String regionDescriptionItemCollectionElement();
	String regionDescriptionItemElement();

	String groupElement();
	String groupDescriptionElement();
	String groupDescriptionItemCollectionElement();
	String groupDescriptionItemElement();

	String instanceElement();
	String instanceDescriptionElement();
	String instanceDescriptionItemCollectionElement();
	String instanceDescriptionItemElement();
}
