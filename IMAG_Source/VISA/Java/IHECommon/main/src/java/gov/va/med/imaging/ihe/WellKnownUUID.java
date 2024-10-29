/**
 * 
 */
package gov.va.med.imaging.ihe;

import java.net.URI;

/**
 * @author vhaiswbeckec
 *
 */
public interface WellKnownUUID
{
	public URI getUrn();
	public String getUrnAsString(); 
	public String getName();
	public Enum<?> getType();

}
