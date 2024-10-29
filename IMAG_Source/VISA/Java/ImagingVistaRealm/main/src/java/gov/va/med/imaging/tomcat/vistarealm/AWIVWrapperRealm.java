/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 24, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.tomcat.vistarealm;

import gov.va.med.imaging.tomcat.vistarealm.exceptions.ConnectionFailedException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.MethodException;

import java.security.Principal;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;
import java.util.WeakHashMap;
import java.util.concurrent.locks.ReentrantLock;

import org.apache.catalina.LifecycleState;
import org.apache.catalina.CredentialHandler;
import org.apache.catalina.Container;
import gov.va.med.logging.Logger;
import org.ietf.jgss.GSSContext;

/**
 * 
 * This realm is used for authentication done by the AWIVWrapper web app.  This is throw away code which will
 * not be needed after the September 30, 2009 OMB demo. The purpose of this realm is to authenticate a user
 * where they input uid/pwd (access/verify) and authenticate against a VistA system that does not have 
 * VistA Imaging isntalled.  So this realm will not make any Imaging specific RPC calls. The roles assigned
 * to the user after authentication will be configured as part of this realm configuration. This realm differs from
 * the ExternalCommunityCertificateRealm in that it requires input uid/pwd and does not use a certificate.
 * 
 * This realm does not use any MAG RPC calls (so it can be run against station 200).
 * 
 * User roles should be configured as they will not be loaded from the database
 * 
 * server.xml Realm element example with all properties specified
 * <Realm
 * className="gov.va.med.imaging.tomcat.vistarealm.AWIVWrapperRealm"
 * siteNumber="660"
 * siteAbbreviation="SLC"
 * siteName="Salt Lake City, UT"
 * usingPrincipalCache="true"
 * principalCacheLifespan="60000"
 * refreshPrincipalCacheEntryOnUse="true"
 * vistaConnectDelayKludge="1000"
 * vistaServer="localhost"
 * vistaPort="9300"
 * serviceAccountRoles=
 * />
 * 
 * @author vhaiswwerfej
 *
 */
public class AWIVWrapperRealm 
extends AbstractVistaRealmImpl
implements VistaRealm, VistaRealmSite, AWIVWrapperRealmMBean
{
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	private String vistaServer = null;
	private Integer vistaPort = null;
	private int vistaConnectDelayKludge = 1000;
	private static final int maxVistaConnectDelayKludge = 3000;
	private static final int minVistaConnectDelayKludge = 0;
	
	private List<VistaRealmRoles> serviceAccountRoles = null;
	private CredentialHandler credentialHandler;
	
	public AWIVWrapperRealm()
	{
        logger.info("{} ctor()", AWIVWrapperRealm.class.getCanonicalName());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tomcat.vistarealm.VistaRealm#getVistaConnectDelayKludge()
	 */
	@Override
	public int getVistaConnectDelayKludge() 
	{
		return vistaConnectDelayKludge;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tomcat.vistarealm.VistaRealm#getVistaPort()
	 */
	@Override
	public Integer getVistaPort() 
	{
		return vistaPort;
	}
	public void setVistaPort(Integer vistaPort)
	{
		if(this.vistaPort == null)
			this.vistaPort = vistaPort;
		else
            getLogger().error("The vista port may not be changed once it has been set, attempt to change from '{}' to '{}' is being ignored.", this.vistaPort, vistaPort);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tomcat.vistarealm.VistaRealm#getVistaServer()
	 */
	@Override
	public String getVistaServer() 
	{
		return vistaServer;		
	}
	public void setVistaServer(String localVistaServer)
	{
		if(this.vistaServer == null)
			this.vistaServer = localVistaServer;
		else
            getLogger().error("The vista server may not be changed once it has been set, attempt to change from '{}' to '{}' is being ignored.", this.vistaServer, localVistaServer);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tomcat.vistarealm.VistaRealm#setVistaConnectDelayKludge(int)
	 */
	@Override
	public void setVistaConnectDelayKludge(int vistaConnectDelayKludge) 
	{
		vistaConnectDelayKludge = Math.max(minVistaConnectDelayKludge, vistaConnectDelayKludge);
		vistaConnectDelayKludge = Math.min(maxVistaConnectDelayKludge, vistaConnectDelayKludge);

		this.vistaConnectDelayKludge = vistaConnectDelayKludge;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tomcat.vistarealm.AbstractVistaRealmImpl#getLogger()
	 */
	@Override
	protected Logger getLogger() 
	{
		return logger;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.tomcat.vistarealm.AbstractVistaRealmImpl#isInitialized()
	 */
	@Override
	public boolean isInitialized() 
	{
		Container container = this.getContainer();
		String containerName = container == null ? null : container.getName();
		
		if (getVistaPort() == null)
		{
            getLogger().warn("VistaRealm[{}] - vista port is not set and must be before authentication will succeed.", containerName);
			return false;
		}
		if (getVistaServer() == null)
		{
            getLogger().warn("VistaRealm[{}] - vista server is not set and must be before authentication will succeed.", containerName);
			return false;
		}
		if (getSiteAbbreviation() == null)
		{
            logger.warn("VistaRealm[{}] - site abbreviation is not set and must be before authentication will succeed.", containerName);
			return false;
		}
		if (getSiteName() == null)
		{
            logger.warn("VistaRealm[{}] - site name is not set and must be before authentication will succeed.", containerName);
			return false;
		}
		if (getSiteNumber() == null)
		{
            logger.warn("VistaRealm[{}] - site number is not set and must be before authentication will succeed.", containerName);
			return false;
		}
		if (getServiceAccountRolesNames() == null)
		{
            logger.warn("VistaRealm[{}] - service account role names is not set and must be before authentication will succeed.", containerName);
			return false;
		}
		return true;
	}

	/**
	 * Return the Principal associated with the specified username and
	 * credentials, if there is one; otherwise return <code>null</code>.
	 * 
	 * @param username
	 *            Username of the Principal to look up
	 * @param credentials
	 *            Password or other credentials to use in authenticating this
	 *            username
	 */
	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(java.lang.String, byte[])
	 */
	public Principal authenticate(String username, byte[] credentials) {
		return authenticate(username, new String(credentials));
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(java.lang.String)
	 */
	@Override
	public Principal authenticate(String uid)
	{
		return null;
	}

	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(org.ietf.jgss.GSSContext;, java.lang.String)
	 */
	@Override
	public Principal authenticate(GSSContext gssContext, boolean storeCreds)
	{
		return null;
	}


	/**
	 * Return the Principal associated with the specified username, which
	 * matches the digest calculated using the given parameters using the method
	 * described in RFC 2069; otherwise return <code>null</code>.
	 * 
	 * @param username
	 *            Username of the Principal to look up
	 * @param digest
	 *            Digest which has been submitted by the client
	 * @param nonce
	 *            Unique (or supposedly unique) token which has been used for
	 *            this request
	 * @param realm
	 *            Realm name
	 * @param md5a2
	 *            Second MD5 digest used to calculate the digest : MD5(Method +
	 *            ":" + uri)
	 */
	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Principal authenticate(String username, String clientDigest, String nOnce, 
			String nc, String cnonce, String qop, String realm,
	        String md5a2) {
        logger.info("authenticate ({}, digest)", username);
		return null;
	}

	/**
	 * Return the Principal associated with the specified username and
	 * credentials, if there is one; otherwise return <code>null</code>.
	 * 
	 * @param username
	 *            Username of the Principal to look up, A valid VistaImaging
	 *            access code
	 * @param credentials
	 *            Password or other credentials to use in authenticating this
	 *            username, The verify code matching the given access code
	 */
	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(java.lang.String, java.lang.String)
	 */
	@Override
	public Principal authenticate(String username, String password) 
	{
		// AWIV is deprecated; return null to satisfy fortify
		return null;
	}

	/**
	 * Return the Principal associated with the specified chain of X509 client
	 * certificates. If there is none, return <code>null</code>.
	 * 
	 * For this method to be called the client must have presented an X509
	 * certificate, which has been signed by a trusted Certificate Authority. At
	 * this point, all we need to do is get the user name from the certificate
	 * and assign the role.
	 * 
	 * @param certs
	 *            Array of client certificates, with the first one in the array
	 *            being the certificate of the client itself.
	 */
	/* (non-Javadoc)
	 * @see org.apache.catalina.Realm#authenticate(java.security.cert.X509Certificate[])
	 */
	@Override
	public Principal authenticate(X509Certificate[] arg0) {
		logger.debug("Authenticating using X509 certificate.");
		return null;
	}
	
	private WeakHashMap<ReentrantLock, String> userSpecificSynchronizationMap = 
		new WeakHashMap<ReentrantLock, String>();
	
	private ReentrantLock getUsernameLock(String username)
	{
		if(username == null)
			return null;
		
		synchronized(userSpecificSynchronizationMap)
		{
			for(ReentrantLock userLock : userSpecificSynchronizationMap.keySet())
			{
				String knownUser = userSpecificSynchronizationMap.get(userLock);
				if(username.equals(knownUser))
					return userLock;
			}
			ReentrantLock userLock = new ReentrantLock(true);
			userSpecificSynchronizationMap.put(userLock, username);
			return userLock;
		}
	}
	
	public List<String> getServiceAccountRolesNames()
	{
		if(this.serviceAccountRoles == null)
			return null;
		List<String> roleNames = new ArrayList<String>(serviceAccountRoles.size());
		for(VistaRealmRoles role : this.serviceAccountRoles)
			roleNames.add(role.getRoleName());
		return roleNames;
	}
	
	public void setServiceAccountRoles(String serviceAccountRoles)
	{
		if(serviceAccountRoles == null)
			return;
		String[] serviceAccountRoleNames = serviceAccountRoles.split(",");
		this.serviceAccountRoles = new ArrayList<VistaRealmRoles>(serviceAccountRoleNames.length);
		for(String serviceAccountRoleName : serviceAccountRoleNames)
		{
			VistaRealmRoles role = VistaRealmRoles.getRoleByName(serviceAccountRoleName);
			if(role == null)
                logger.error("Unknown role name '{}' configured in CertificateRealm.", serviceAccountRoleName);
			else
				this.serviceAccountRoles.add(role);
		}
	}
	
	 @Override
	    public String toString()
	    {
	    	StringBuilder sb = new StringBuilder();
	    	
	    	sb.append(this.getClass().getSimpleName());
	    	sb.append(" [");
	    	sb.append(this.getSiteAbbreviation());
	    	sb.append("-");
	    	sb.append(this.getSiteNumber());
	    	sb.append(" ");
	    	sb.append(this.getSiteName());
	    	sb.append(" vista:");
	    	sb.append(this.getVistaServer());
	    	sb.append(":");
	    	sb.append(this.getVistaPort());
	    	sb.append("]");
	    	
		    return sb.toString();
	    }

		/* (non-Javadoc)
		 * @see org.apache.catalina.Realm#isAvailable()
		*/
		public boolean isAvailable()
		{
			return true;
		}

		/* (non-Javadoc)
		 * @see org.apache.catalina.Realm#getRoles(java.security.Principal)
		 */
		public String[] getRoles(Principal principal)
		{
			return null;
		}

		/* (non-Javadoc)
		 * @see org.apache.catalina.Realm#setCredentialHandler(org.apache.catalina.CredentialHandler)
		*/
		@Override
		public void setCredentialHandler(CredentialHandler credentialHandler)
		{
			this.credentialHandler = credentialHandler;
		}
		
		/* (non-Javadoc)
		 * @see org.apache.catalina.Realm#getCredentialHandler()
		*/
		@Override
		public CredentialHandler getCredentialHandler()
		{
			return credentialHandler;
		}

		/* (non-Javadoc)
		 * @see org.apache.catalina.Lifecycle#getStateName()
		*/
		@Override
		public String getStateName()
		{
			return null; //getParentContainerRealm() == null ? null : getParentContainerRealm().getStateName();
		}

		/* (non-Javadoc)
		 * @see org.apache.catalina.Lifecycle#getState()
		*/
		@Override
		public LifecycleState getState()
		{
			return null; //getParentContainerRealm() == null ? null : getParentContainerRealm().getState();
		}
		
		/* (non-Javadoc)
		 * @see org.apache.Lifecycle.destroy()
		*/
		@Override
		public void destroy()
		{
		}
		
		/* (non-Javadoc)
		 * @see org.apache.Lifecycle.init()
		*/
		@Override
		public void init()
		{
		}
}
