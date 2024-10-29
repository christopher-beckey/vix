/**
 * 
 */
package gov.va.med.imaging.proxy.services;

import java.net.URL;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;

/**
 * Wraps a ResolvedArtifactSource along with a type and a protocol into
 * something that looks like a ProxyService. 
 * 
 * @author vhaiswbeckec
 *
 */
public class ResolvedArtifactSourceProxyService
extends AbstractProxyService
{
	private final ResolvedArtifactSource resolvedArtifactSource;
	private final String protocol;
	private final ProxyServiceType type;
	
	/**
	 * 
	 */
	public ResolvedArtifactSourceProxyService(
		ResolvedArtifactSource resolvedArtifactSource, 
		String protocol,
		ProxyServiceType type)
	{
		assert resolvedArtifactSource != null;
		assert protocol != null;
		
		this.resolvedArtifactSource = resolvedArtifactSource;
		this.protocol = protocol;
		this.type = type;
	}
	
	private URL getURL()
	{
		if(ProxyServiceType.metadata == getProxyServiceType())
			getResolvedArtifactSource().getMetadataUrl(getProtocol());
		else if(ProxyServiceType.image == getProxyServiceType())
			getResolvedArtifactSource().getArtifactUrl(getProtocol());
		
		return null; // QN: Doon't know why this method always return null and supposedly the whole thing works
	}
	
	public ResolvedArtifactSource getResolvedArtifactSource()
	{
		return this.resolvedArtifactSource;
	}
	
	public String getProtocol()
	{
		return this.protocol;
	}

	@Override
	public String getApplicationPath()
	{
		/* Fortify change: check for null first
		OLD:
		String path = getURL().getPath();
		if(path == null)
			return null;
		
		String[] pathElements = path.split("/");
		return pathElements[0];
		
		Easy button:
		if (getURL() == null)
		   return null;
		[existing codes]
		
		Do the below instead. No testing.  May fail.
		*/
		
		URL url = getURL();
		String path = url != null ? url.getPath() : null;
		String [] subPaths = path != null && !path.isEmpty() ? path.split("/") : null;
		
		return (subPaths != null ? subPaths[0] : null);

		// Fortify change: Fortify requires implementation above instead of below; second round
		//return (getURL() != null && getURL().getPath() != null ? getURL().getPath().split("/")[0] : null);
	}

	@Override
	public String getOperationPath()
	{
		/* Fortify change: check for null first (see getApplicationPath() for additional info)
		OLD:
		String path = getURL().getPath(); // NEED FIX HERE
		if(path == null)
			return null;

		int firstSlash = path.indexOf('/');
		return firstSlash >= 0 ? path.substring(firstSlash) : null;
		*/
		
		// Do this for readability. The last one should work as well
		URL url = getURL();
		
		// Fortify change: Fortify requires implementation above instead of below; second round
		String path = url != null && url.getPath() != null ? url.getPath() : null;
		return (path != null && path.indexOf('/') >= 0 ? path.substring(path.indexOf('/')) : null);
		
		//return(getURL() != null && getURL().getPath() != null ? (getURL().getPath().indexOf('/') >= 0 ? getURL().getPath().substring(getURL().getPath().indexOf('/')) : null ) : null);
	}

	@Override
	public String getConnectionURL()
	{
		// Fortify change: check for null first (see getApplicationPath() for additional info)
		// OLD: return getURL().toExternalForm();
		URL url = getURL();
		
		return (url != null ? url.toExternalForm() : null);
		
		// Fortify change: Fortify requires implementation above instead of below; second round
		//return (getURL() != null ? getURL().toExternalForm() : null);
	}

	@Override
	public Object getCredentials()
	{
		/* Fortify change: check for null first (see getApplicationPath() for additional info)
		OLD:

		String userInfo = getURL().getUserInfo(); // NEED FIX HERE
		if(userInfo == null)
			return null;
		String[] userInfoElements = userInfo.split(":");
		return userInfoElements.length >= 2 ? userInfoElements[1] : null;
		*/
		URL url = getURL();
		
		// Fortify change: Fortify requires implementation above instead of below; second round
		String [] userInfoElements = url != null && url.getUserInfo() != null ? url.getUserInfo().split(":") : null;
		return (userInfoElements != null && userInfoElements.length >= 2 ? userInfoElements[1] : null);
	}

	@Override
	public String getHost()
	{
		// Fortify change: check for null first (see getApplicationPath() for additional info)
		// OLD: return getURL().getHost();
		URL url = getURL();
		
		return (url != null ? url.getHost() : null);
		
		// Fortify change: Fortify requires implementation above instead of below; second round
		// return (getURL() != null ? getURL().getHost() : null);
	}

	@Override
	public int getPort()
	{
		// Fortify change: check for null first (see getApplicationPath() for additional info)
		// OLD: return getURL().getPort();
		URL url = getURL();
		
		return (url != null ? url.getPort() : -1);
		
		// Fortify change: Fortify requires implementation above instead of below; second round
		// return (getURL() != null ? getURL().getPort() : -1);
	}

	@Override
	public ProxyServiceType getProxyServiceType()
	{
		return type;
	}

	@Override
	public String getUid()
	{
		/* Fortify change: check for null first (see getApplicationPath() for additional info)
		String userInfo = getURL().getUserInfo(); // NEED FIX HERE
		if(userInfo == null)
			return null;
		String[] userInfoElements = userInfo.split(":");
		return userInfoElements[0];
		*/
		
		URL url = getURL();
		String userInfo = url != null ? url.getUserInfo() : null;
		String [] uids = userInfo != null && !userInfo.isEmpty() ? userInfo.split(":") : null;
		
		return (uids != null ? uids[0] : null);
		
		// Fortify change: Fortify requires implementation above instead of below; second round
		//return (getURL() != null && getURL().getUserInfo() != null ? getURL().getUserInfo().split(":")[0] : null);
	}

}
