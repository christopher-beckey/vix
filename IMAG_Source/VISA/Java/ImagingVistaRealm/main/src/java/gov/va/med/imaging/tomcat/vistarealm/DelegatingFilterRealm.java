/**
 * 
 */
package gov.va.med.imaging.tomcat.vistarealm;

import java.beans.PropertyChangeListener;
import java.io.IOException;
import java.security.Principal;
import java.security.cert.X509Certificate;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.catalina.CredentialHandler;
import org.apache.catalina.Wrapper;
import org.apache.catalina.Container;
import org.apache.catalina.Context;
import org.apache.catalina.Realm;
import org.apache.catalina.connector.Request;
import org.apache.catalina.connector.Response;
import org.apache.tomcat.util.descriptor.web.SecurityConstraint;
import gov.va.med.logging.Logger;
import org.ietf.jgss.GSSContext;

/**
 * This Realm delegates all of its calls, other than lifecycle methods,
 * to the parent container's realm.  Before delegating to the parent container
 * realm, it sets some thread local variables, depending on its configuration.
 * 
 *  This realm is used by the ClinicalDisplay, VistaRad, and AWIV to skip the Vista
 *  AccessVerifyRealm and go straight to the server realm.  Otherwise the access verify
 *  realm would have to wait for a reply from VistA, which always fails to authenticate,
 *  before checking the server's realm. 
 * 
 * @author vhaiswbeckec
 *
 */
public class DelegatingFilterRealm
implements Realm
{
	private Container container;
	private Container parentContainer;
	private Realm parentContainerRealm;
	private Logger logger = Logger.getLogger(this.getClass());
	private Set<PropertyChangeListener> propertyChangeListeners = 
		new HashSet<PropertyChangeListener>();
	
	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#setContainer(org.apache.catalina.Container)
	 */
	@Override
	public void setContainer(Container container)
	{
		this.container = container;
		parentContainer = container.getParent();
		if (parentContainer != null)
			parentContainerRealm = parentContainer.getRealm();
	}
	
	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#getContainer()
	 */
	@Override
	public Container getContainer()
	{
		return this.container;
	}
	
	public Container getParentContainer()
	{
		return this.parentContainer;
	}

	public Realm getParentContainerRealm()
	{
		return this.parentContainerRealm;
	}	
	
	private final static String propertyNameRegex = "([a-zA-Z0-9]+)";
	private final static String propertyValueRegex = "\"([a-zA-Z0-9]+)\"";
	private final static String propertyNameValuePairRegex =
		propertyNameRegex + "=" + propertyValueRegex + "[;]?";
	private final static Pattern propertyNameValuePairPattern = 
		Pattern.compile(propertyNameValuePairRegex);
	
	private Map<String, String> delegatedProperties = new HashMap<String, String>();
		
	/**
	 * The delegated properties are passed as a semicolon separated
	 * string of name/value pairs.  The format must follow:
	 * <name>="<value>";[<name>="<value>"]...
	 * 
	 * @param propertyString
	 */
	public void setDelegatedProperties(String propertyString)
	{
        Logger.getLogger(this.getClass()).info("Delegated properties string '{}'.", propertyString);
		if(propertyString == null)
			return;
		delegatedProperties.clear();
		
		Matcher propertiesMatcher = propertyNameValuePairPattern.matcher(propertyString);
		while( propertiesMatcher.find() )
		{
			String name = propertiesMatcher.group(1);
			String value = propertiesMatcher.group(2);
			
			delegatedProperties.put(name, value);
            Logger.getLogger(this.getClass()).info("Property '{}' = '{}'.", name, value);
		}
	}
	
	public Map<String, String> getDelegatedProperties()
	{
		return this.delegatedProperties;
	}

	private void setRealmContext()
	{
		RealmDelegationContext.getRealmDelegationProperties().clear();
		RealmDelegationContext.getRealmDelegationProperties().putAll(delegatedProperties);
	}

	private void unsetRealmContext()
	{
		RealmDelegationContext.unsetRealmDelegationContext();
	}
	
	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#addPropertyChangeListener(java.beans.PropertyChangeListener)
	 */
	@Override
	public void addPropertyChangeListener(PropertyChangeListener propertyChangeListener)
	{
		propertyChangeListeners.add(propertyChangeListener);
	}
	
	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#removePropertyChangeListener(java.beans.PropertyChangeListener)
	 */
	@Override
	public void removePropertyChangeListener(PropertyChangeListener propertyChangeListener)
	{
		propertyChangeListeners.remove(propertyChangeListener);
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(java.security.cert.X509Certificate[])
	 */
	@Override
	public Principal authenticate(X509Certificate[] certificate)
	{
		setRealmContext();
		Principal principal = 
			getParentContainerRealm() == null ? null : getParentContainerRealm().authenticate(certificate);
		unsetRealmContext();
		return principal;
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(java.lang.String, java.lang.String)
	 */
	@Override
	public Principal authenticate(String uid, String pwd)
	{
		logger.debug("Breadcrumb thru DelegatingFilterRealm class.");
		setRealmContext();
		Principal principal = 
			getParentContainerRealm() == null ? null : getParentContainerRealm().authenticate(uid, pwd);
		unsetRealmContext();
		return principal;
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(java.lang.String)
	 */
	@Override
	public Principal authenticate(String uid)
	{
		logger.debug("Breadcrumb thru DelegatingFilterRealm class.");
		setRealmContext();
		Principal principal = 
			getParentContainerRealm() == null ? null : getParentContainerRealm().authenticate(uid);
		unsetRealmContext();
		return principal;
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(org.ietf.jgss.GSSContext;, java.lang.String)
	 */
	@Override
	public Principal authenticate(GSSContext gssContext, boolean storeCreds)
	{
		setRealmContext();
		Principal principal = 
			getParentContainerRealm() == null ? null : getParentContainerRealm().authenticate(gssContext, storeCreds);
		unsetRealmContext();
		return principal;
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(java.lang.String, byte[])
	@Override
	public Principal authenticate(String uid, byte[] arg1)
	{
		logger.debug("Breadcrumb thru DelegatingFilterRealm class.");
		setRealmContext();
		Principal principal = 
			getParentContainerRealm() == null ? null : getParentContainerRealm().authenticate(uid, arg1);
		unsetRealmContext();
		return principal;
	}
	 */

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Principal authenticate(String arg0, String arg1, String arg2, String arg3, String arg4, String arg5,
		String arg6, String arg7)
	{
		setRealmContext();
		Principal principal = 
			getParentContainerRealm() == null ? null : 
			getParentContainerRealm().authenticate(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
		unsetRealmContext();
		return principal;
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#backgroundProcess()
	 */
	@Override
	public void backgroundProcess(){}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#findSecurityConstraints(org.apache.catalina.connector.Request, org.apache.catalina.Context)
	 */
	@Override
	public SecurityConstraint[] findSecurityConstraints(Request arg0, Context arg1)
	{
		return getParentContainerRealm() == null ? null : getParentContainerRealm().findSecurityConstraints(arg0, arg1);
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#getInfo()
	 */
	//@Override
	public String getInfo()
	{
		return getInfoMsg();
	}
	
	private String infoMsg;
	private synchronized String getInfoMsg()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(this.getClass().getSimpleName());
		sb.append("->");
		
		infoMsg = sb.toString();
		return infoMsg;
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#hasResourcePermission(org.apache.catalina.connector.Request, org.apache.catalina.connector.Response, org.apache.catalina.deploy.SecurityConstraint[], org.apache.catalina.Context)
	 */
	@Override
	public boolean hasResourcePermission(Request arg0, Response arg1, SecurityConstraint[] arg2, Context arg3)
		throws IOException
	{
		return getParentContainerRealm() == null ? null : getParentContainerRealm().hasResourcePermission(arg0, arg1, arg2, arg3);
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#hasRole(org.apache.catalina.Wrapper, java.security.Principal, java.lang.String)
	 */
	@Override
	public boolean hasRole(Wrapper wrapper, Principal arg0, String arg1)
	{
		return getParentContainerRealm() == null ? null : getParentContainerRealm().hasRole(wrapper, arg0, arg1);
	}


	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#getRoles(java.security.Principal)
	 */
	//@Override
	//public String[] getRoles(Principal principal)
	//{
	//	return getParentContainerRealm() == null ? null : getParentContainerRealm().getRoles(principal);
	//}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#hasUserDataPermission(org.apache.catalina.connector.Request, org.apache.catalina.connector.Response, org.apache.catalina.deploy.SecurityConstraint[])
	 */
	@Override
	public boolean hasUserDataPermission(Request arg0, Response arg1, SecurityConstraint[] arg2) throws IOException
	{
		return getParentContainerRealm() == null ? null : getParentContainerRealm().hasUserDataPermission(arg0, arg1, arg2);
	}
	
	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#isAvailable()
	*/
	//@Override
	//public boolean isAvailable()
	//{
	//	return getParentContainerRealm() == null ? null : getParentContainerRealm().isAvailable();
	//}
	
	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#setCredentialHandler(org.apache.catalina.CredentialHandler)
	*/
	@Override
	public void setCredentialHandler(CredentialHandler credentialHandler)
	{
		if (getParentContainerRealm() != null)
			getParentContainerRealm().setCredentialHandler(credentialHandler);
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#getCredentialHandler()
	*/
	@Override
	public CredentialHandler getCredentialHandler()
	{
		return getParentContainerRealm() == null ? null : getParentContainerRealm().getCredentialHandler();
	}

}
