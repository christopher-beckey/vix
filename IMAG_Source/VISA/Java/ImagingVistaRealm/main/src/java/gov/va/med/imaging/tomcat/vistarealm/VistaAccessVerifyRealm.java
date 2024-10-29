/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created:
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:
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

import gov.va.med.imaging.tomcat.vistarealm.broker.NewRpcBroker;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.ConnectionFailedException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.MethodException;

import java.security.Principal;
import java.security.cert.X509Certificate;
import java.util.*;
import java.util.concurrent.locks.ReentrantLock;
import org.apache.catalina.LifecycleState;
import org.apache.catalina.CredentialHandler;
import org.apache.catalina.Container;
import org.apache.catalina.Realm;
import org.apache.catalina.realm.GenericPrincipal;
import gov.va.med.logging.Logger;
import org.ietf.jgss.GSSContext;

/**
 * This class implements a Tomcat Realm using Vista as the backing authorization
 * repository. The roles of the users authenticated under this realm are limited
 * to three known roles, these are: 1.) clinical-display-user - a special user
 * logged into a clinical display workstation 2.) vista-user - a user
 * authenticated against a Vista system and having the user key therein 3.)
 * administrator - a user authenticated against a Vista system and having the
 * exchange administrator user key therein
 * 
 * This Realm will delegate authentication to its container parent realm after
 * authentication against Vista. This is done whether the Vista authentication
 * was successful or not. Practically this means that "special" users may be
 * added to the parent realm or that additional roles may be added to Vista
 * users by including them in the parent context realm.
 * 
 * Portions of this code and the comments are copied verbatim from
 * Tomcat/Catalina source.
 * 
 * A quick discussion of Realm calling sequence in Tomcat (or at least how I
 * think they work). -startup- 1.) constructor() 2.) setContainer() 3.)
 * MBeanRegistration.preRegister() 4.) MBeanRegistration.postRegister() 5.)
 * Lifecycle.start() 6.) backgroundProcess() runs periodically from here to
 * Lifecycle.stop()
 * 
 * -on client call- 1.) findSecurityConstraints() - determines if the web.xml
 * file has defined security-constraint elements for the resource should return
 * an array of applicable constraints (in descending order of specificity) 2.)
 * hasUserDataPermission() - to check the web.xml specified requirements for
 * data integrity and security in transmission 3.) authenticate() - depending on
 * the presented credentials, may call one of the four authenticate methods if
 * the user exists, should return a Principal realization 4.)
 * hasResourcePermission() - determines if the authenticated user has permission
 * to the specific resource named - on server stop - 1.) Lifecycle.stop()
 * 
 * Initialization Sequence:
 * 
 * =========================================================================
 * server.xml Realm element example with just required properties specified
 * <Realm
 * className="gov.va.med.imaging.tomcat.vistarealm.VistaRealm"
 * siteNumber = "660"
 * siteAbbreviation = "SLC"
 * siteName = "Salt Lake City, UT"
 * vistaServer = "localhost"
 * vistaPort = "9300"
 * />
 * 
 * =========================================================================
 * server.xml Realm element example with all properties specified
 * <Realm
 * className="gov.va.med.imaging.tomcat.vistarealm.VistaRealm"
 * siteNumber="660"
 * siteAbbreviation="SLC"
 * siteName="Salt Lake City, UT"
 * vistaServer="localhost"
 * vistaPort="9300"
 * usingPrincipalCache="true"
 * usingSecurityConstraintCache="true"
 * principalCacheLifespan="60000"
 * securityConstraintCacheLifespan="600000"
 * refreshPrincipalCacheEntryOnUse="true"
 * refreshSecurityConstraintCacheEntryOnUse="true"
 * vistaConnectDelayKludge="1000"
 * userId=null
 * password=null
 * showPasswordsInLogging=false
 * setCprsContext=false
 * defaultSsn="000-00-0000"
 * bseRealm="200"
 * generateBseToken=true
 * />
 * 
 * @author VHAISWBECKEC
 * 
 */
public class VistaAccessVerifyRealm
extends AbstractVistaRealmImpl
implements Realm, org.apache.catalina.Lifecycle, VistaRealmSite, VistaRealm, VistaAccessVerifyRealmMBean
{
	// Known Roles are now defined in the VistaRealmRoles Enum in the
	// VistaRealmClient project.
	// Partially this was for a code cleanup, and partially to make them
	// available
	// outside of the realm itself.

	private Container parentContainer;
	private Realm parentContainerRealm;

	// properties affecting which VistA server we connect to
	private String vistaServer = null;		// this MUST be initialized to null
	private Integer vistaPort = null;		// this MUST be initialized to null
	
	private Boolean authenticateAgainstVista = Boolean.TRUE;
	
	// User identification properties, if these are provided then
	// the user identification provided to the authenticate() will be
	// ignored and these values used.
	private String userId = null;
	private String password = null;
	private Boolean showPasswordsInLogging = Boolean.FALSE;
	private Boolean generateBseToken = Boolean.TRUE;
	private Boolean setCprsContext = Boolean.FALSE;
	private final Map<String, List<String>> additionalUserRoles = new HashMap<String, List<String>>();
	private final Map<String, List<String>> additionalRoleRoles = new HashMap<String, List<String>>();
	private String defaultSsn = null;
	private String bseRealm = null;

	// If we need to do a Vista connection for authentication then delay for
	// some amount of time after the connection to allow Vista to get its act together again. This is most
	// definitely a kludge to work around a problem we can't directly address.
	private int vistaConnectDelayKludge = 1000;
	private static final int maxVistaConnectDelayKludge = 3000;
	private static final int minVistaConnectDelayKludge = 0;
	private static final String ALEXDELARGE = "alexdelarge";
		
	private Logger logger = Logger.getLogger(this.getClass());
	private CredentialHandler credentialHandler;

	@Override
    protected Logger getLogger()
    {
	    return logger;
    }
	/**
	 * 
	 */
	public VistaAccessVerifyRealm()
	{
        logger.info("{} ctor()", VistaAccessVerifyRealm.class.getCanonicalName());
	}

	// ===========================================================================================================
	// JavaBean Property Accessors
	// These properties may be set from the server configuration.
	// ===========================================================================================================

	/**
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


	/**
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

	/**
     * @see gov.va.med.imaging.tomcat.vistarealm.VistaRealm#getVistaConnectDelayKludge()
     */
	public int getVistaConnectDelayKludge()
	{
		return this.vistaConnectDelayKludge;
	}

	public void setVistaConnectDelayKludge(int vistaConnectDelayKludge)
	{
		vistaConnectDelayKludge = Math.max(minVistaConnectDelayKludge, vistaConnectDelayKludge);
		vistaConnectDelayKludge = Math.min(maxVistaConnectDelayKludge, vistaConnectDelayKludge);

		this.vistaConnectDelayKludge = vistaConnectDelayKludge;
	}

	/**
	 * If this property is false then this realm will simply delegate the
	 * authentication to its parent and create a VistaRealmPrincipal instance
	 * on the ThreadLocal.
	 * 
	 * @return
	 */
	public Boolean getAuthenticateAgainstVista()
	{
		return this.authenticateAgainstVista;
	}
	public void setAuthenticateAgainstVista(Boolean authenticateAgainstVista)
	{
		this.authenticateAgainstVista = authenticateAgainstVista;
	}
	
	
	/**
	 * @return the userid
	 */
	public String getUserId()
	{
		return this.userId;
	}
	/**
	 * @return the password
	 */
	public String getPassword()
	{
		return this.password;
	}
	/**
	 * @param userid the userid to set
	 */
	public void setUserId(String userid)
	{
		this.userId = userid;
	}
	/**
	 * @param password the password to set
	 */
	public void setPassword(String password)
	{
		this.password = password;
	}
	
	/**
	 * @return the showPasswordsInLogging
	 */
	public Boolean getShowPasswordsInLogging()
	{
		return this.showPasswordsInLogging;
	}
	/**
	 * @param showPasswordsInLogging the showPasswordsInLogging to set
	 */
	public void setShowPasswordsInLogging(Boolean showPasswordsInLogging)
	{
		this.showPasswordsInLogging = showPasswordsInLogging;
	}
	
	public Boolean getGenerateBseToken()
	{
		return generateBseToken;
	}
	public void setGenerateBseToken(Boolean generateBseToken)
	{
		this.generateBseToken = generateBseToken;
	}
	/**
	 * @return the setCprsContext
	 */
	public Boolean getSetCprsContext()
	{
		return this.setCprsContext;
	}
	/**
	 * Set to TRUE to use the CPRS VistA context, otherwise use the IMAGING VistA context
	 * 
	 * @param setCprsContext the setCprsContext to set
	 */
	public void setSetCprsContext(Boolean setCprsContext)
	{
		this.setCprsContext = setCprsContext;
	}

	// ============================================
	// The following accessors are a means of adding additional roles to a 
	// specific user or role
	// ============================================
	
	/**
	 * @return the additionalUserRoles
	 */
	public String getAdditionalUserRoles()
	{
		return makeAdditionalRoleString(additionalUserRoles);
	}
	
	/**
	 * @return the additionalRoleRoles
	 */
	public String getAdditionalRoleRoles()
	{
		return makeAdditionalRoleString(additionalRoleRoles);
	}
	
	/**
	 * @param additionalUserRoles the additionalUserRoles to set
	 */
	public void setAdditionalUserRoles(String rawValue)
	{
		try
		{
			parseAdditionalRoleString(rawValue, this.additionalUserRoles);
		}
		catch (Exception x)
		{
			x.printStackTrace();
		}
	}
	
	/**
	 * @param additionalRoleRoles the additionalRoleRoles to set
	 */
	public void setAdditionalRoleRoles(String rawValue)
	{
		try
		{
			parseAdditionalRoleString(rawValue, this.additionalRoleRoles);
		}
		catch (Exception x)
		{
			x.printStackTrace();
		}
	}
	
	private String makeAdditionalRoleString(Map<String, List<String>> map)
	{
		StringBuilder sb = new StringBuilder();
		
		for(Map.Entry<String, List<String>> additionalRoles : map.entrySet())
		{
			sb.append(additionalRoles.getKey());
			sb.append("->");
			boolean firstRole = true;
			for(String role : additionalRoles.getValue())
			{
				if(!firstRole) sb.append(',');
				sb.append(role);
			}
			sb.append(';');
		}
		return sb.toString();
	}

	/**
	 * Parse a string in a form like "identifier1:role1,role2;identifier2=role3,role4;"
	 * into a Map<String,List<String>> where
	 * the identifier(s) end up as the key and
	 * the role(s) are the values
	 * 
	 * @param rawValue
	 * @param destinationMap
	 * @throws Exception 
	 */
	private void parseAdditionalRoleString(String rawValue, Map<String, List<String>> destinationMap) 
	throws Exception
	{
		// nothing to do ?
		if(rawValue == null || rawValue.length() == 0)
			return;
		
		String[] roleMappings = rawValue.split(";");
		// again, nothing to do ?
		if(roleMappings.length == 0)
			return;
		
		for(String roleMapping : roleMappings)
		{
			String[] keyValuePairs = roleMapping.trim().split(":");
			if(keyValuePairs.length < 2)
				throw new Exception("Additional role properties must be in the form 'identifier1:role1,role2;identifier2=role3,role4;'");
			String key = keyValuePairs[0].trim();
			String[] roles = keyValuePairs[1].trim().split(",");
			if(roles.length < 1)
				throw new Exception("Additional role properties must be in the form 'identifier1:role1,role2;identifier2=role3,role4;'.  No role specified.");
			List<String> roleList = new ArrayList<String>();
			for(String role : roles)
				roleList.add(role);
			destinationMap.put(key, roleList);
		}
	}
	
	/**
	 * A default SSN, if supplied, will be inserted only when the SSN is not obtained from an
	 * authentication repository.  By default it is null, and that is expected to be true in
	 * production settings.
	 * 
	 * @return the defaultSSN
	 */
	public String getDefaultSsn()
	{
		return this.defaultSsn;
	}
	/**
	 * testSsn
	 * @param defaultSsn the defaultSSN to set
	 */
	public void setDefaultSsn(String defaultSsn)
	{
		this.defaultSsn = defaultSsn;
	}
	public String getBseRealm()
	{
		return bseRealm;
	}
	public void setBseRealm(String bseRealm)
	{
		this.bseRealm = bseRealm;
	}
	// ============================================================================================
	// Read-Only properties, used by JMX for monitoring
	// ============================================================================================
	/**
     * @see gov.va.med.imaging.tomcat.vistarealm.VistaRealm#isInitialized()
     */
	@Override
	public boolean isInitialized()
	{
		getLogger().debug("isInitialized");
		
		boolean result = true;
		
		Container container = this.getContainer();
		String containerName = container == null ? null : container.getName();
        getLogger().debug("containerName = {}", containerName);
		
		if (this.getSiteAbbreviation() == null)
		{
            getLogger().warn("VistaRealm[{}] - site abbreviation is not set and must be before authentication will succeed.", containerName);
			result = false;
		}
		if (this.getSiteName() == null)
		{
            getLogger().warn("VistaRealm[{}] - site name is not set and must be before authentication will succeed.", containerName);
			result = false;
		}
		if (this.getSiteNumber() == null)
		{
            getLogger().warn("VistaRealm[{}] - site number is not set and must be before authentication will succeed.", containerName);
			result = false;
		}
		if (this.getVistaPort() == null)
		{
            getLogger().warn("VistaRealm[{}] - vista port is not set and must be before authentication will succeed.", containerName);
			result = false;
		}
		if (this.getVistaServer() == null)
		{
            getLogger().warn("VistaRealm[{}] - vista server is not set and must be before authentication will succeed.", containerName);
			result = false;
		}

		return result;
	}

	// ===========================================================================================================
	// Realm implementation
	// ===========================================================================================================

	/**
	 * A Container is an object that can execute requests received from a
	 * client, and return responses based on those requests. Engine -
	 * Representation of the entire Catalina servlet engine. Host -
	 * Representation of a virtual host containing a number of Contexts. Context -
	 * Representation of a single ServletContext, which will typically contain
	 * one or more Wrappers for the supported servlets. Wrapper - Representation
	 * of an individual servlet definition.
	 */

	@Override
	public void setContainer(Container container)
	{
		super.setContainer(container);

		// if the container has a parent then get its realm
		// this class will authenticate against that realm as well as its own
		// authentication repository
		if (getContainer() != null)
		{
            getLogger().info("Container name is '{}' container type is '{}'", getContainer().getName(), getContainer().getClass().getName());
			
			parentContainer = getContainer().getParent();
			if (parentContainer != null)
			{
                getLogger().info("Parent container name is '{}' parent container type is '{}'", parentContainer.getName(), parentContainer.getClass().getName());
				parentContainerRealm = parentContainer.getRealm();
                getLogger().info("Parent container realm type is '{}'", parentContainerRealm == null ? "null" : "" + parentContainerRealm.getClass().getName());
			}
			else
			{
				getLogger().info("Parent container is null.  Delegation to parent realm will be disabled.");
			}
		}
	}
	
	public synchronized Container getParentContainer()
	{
		if(parentContainer == null)
			parentContainer = getContainer() == null ? null : getContainer().getParent();
		
		return parentContainer;
	}
	
	public synchronized Realm getParentContainerRealm()
	{
		if(parentContainerRealm == null)
		{
			Container parentContainer = getParentContainer();
			parentContainerRealm = parentContainer == null ? null : parentContainer.getRealm();
		}
		
		return parentContainerRealm;
	}
	
	/**
     * @see java.lang.Object#toString()
     * 
     * Returns a String like:
     * VistaRealm [660-SLC Salt Lake City, UT vista:slc.vista.med.va.gov:9300]
     */
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

	/*
	 * ======================================================================================
	 * Authentication Methods
	 * ======================================================================================
	 */

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
	public Principal authenticate(String username, String password)
	{
		VistaRealmPrincipal principal = null;
		boolean appendParentRealmRoles = true;

		logger.debug("Authenticating via VistaAccessVerifyRealm.");
		
		String inhibitParentDelegationProperty = 
			RealmDelegationContext.getRealmDelegationProperties().get(RealmDelegationContext.INHIBIT_PARENT_DELEGATION);
		boolean inhibitParentDelegation = Boolean.parseBoolean(inhibitParentDelegationProperty);
		String inhibitThisAuthenticationProperty = 
			RealmDelegationContext.getRealmDelegationProperties().get(RealmDelegationContext.INHIBIT_THIS_AUTHENTICATION);
		boolean inhibitThisAuthentication = Boolean.parseBoolean(inhibitThisAuthenticationProperty);
		
		if(!inhibitThisAuthentication)
		{
			inhibitThisAuthentication = RealmErrorContext.getSkipVistaAuthentication();
		}

		// System.err.println("Begin stack trace from VistaRealm.authenticate()
		// - THIS IS NOT A THROWN EXCEPTION, just a stack trace");
		// Thread.dumpStack();
		// System.err.println("End stack trace from VistaRealm.authenticate()");
		String specifiedSiteId = null;
		if(username.contains("||"))
		{
			int loc = username.indexOf("||");
			specifiedSiteId = username.substring(0, loc);
			username = username.substring(loc + 2);
            getLogger().info("Using site [{}] specified in username", specifiedSiteId);
		}
		
		VistaRealmSite authenticationSite = this;
		if(authenticationSite == null || authenticationSite.getVistaServer() == null || authenticationSite.getVistaServer().length() <= 0 || authenticationSite.getVistaPort() <= 0)
		{
			getLogger().warn("authentication site not specified, site required for authentication");
			return null;
		}

        getLogger().info("Realm '{}'-authenticate ({}, {}", authenticationSite.getSiteNumber(), username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>)");
		
		// If a userId property is provided then override the supplied username and password
		// with the property values.
		// This is used, usually with authType=NONE where a service account is attached to 
		// a facade.
		if(getUserId() != null)
		{
            getLogger().info("Realm '{}'-authenticate overriding UID/PWD", authenticationSite.getSiteNumber());
			username = getUserId();
			password = getPassword();
            getLogger().info("Realm '{}'-authenticate ({}, {}", authenticationSite.getSiteNumber(), username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>)");
		}

        getLogger().debug("inhibitParentDelegation = {}", inhibitParentDelegation);
        getLogger().debug("inhibitThisAuthentication = {}", inhibitThisAuthentication);
        getLogger().debug("defaultSsn = {}", getDefaultSsn());

		// get a lock that is mapped to the user name
		// this will prevent multiple threads from authenticating the same user at the same time
		// and should result in succeeding threads getting a cache hit instead of a VistA call
		ReentrantLock lock = getUsernameLock(username);
		try {
			if (lock != null) {
				lock.lock();
			} else {
                getLogger().error("Unable to acquire lock for username '{}', this could potentially lead to concurrency problems.", username);
			}
			return synchronizedAuthenticate(username, password, principal, appendParentRealmRoles, inhibitParentDelegation, inhibitThisAuthentication, authenticationSite);
		} finally {
			if (lock != null) {
				try {
					lock.unlock();
				} catch (IllegalMonitorStateException imsX) {
					getLogger().error("Unexpected error unlocking username lock, this may indicate that the VistaRealm is getting confused with multiple threads under the same security context.");
				}
			}
		}
	}

	private VistaRealmPrincipal synchronizedAuthenticate(String username, String password, VistaRealmPrincipal principal, boolean appendParentRealmRoles, boolean inhibitParentDelegation, boolean inhibitThisAuthentication, VistaRealmSite authenticationSite) {
		// if the principal cache is turned on then
		// look in the principal cache first,
		// if it is there then check the password and return it
		if (isUsingPrincipalCache().booleanValue())
		{
			FullyQualifiedPrincipalName fqPrincipal = new FullyQualifiedPrincipalName(authenticationSite.getSiteNumber(), username);
			PrincipalCacheValue cacheEntry = getPrincipalCacheEntry( fqPrincipal );
			if (cacheEntry != null)
			{
				principal = cacheEntry.getPrincipal().clone(); // clone the
				// Principal so that each thread has its own copy, added clone
				// on 15Oct2007 CTB

				// make sure that the PWD supplied in the call matches that in
				// the cache.
				if (principal.getVerifyCode().equals(password))
				{
                    getLogger().info("User ({}, {}) found in VistaRealmPrincipal cache", username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>");

					// if the principal is found in the cache then it has all
					// the roles it should have
					appendParentRealmRoles = false;
					if (isRefreshPrincipalCacheEntryOnUse().booleanValue())
						cacheEntry.touch();

					// clear the application properties, all application
					// properties are assumed to be
					// local to the transaction context
					principal.clearApplicationProperties();
				}
				else
				{
					principal = null; // NOTE: big security hole if this is not nulled out
                    getLogger().warn("User ({}, {}) found in VistaRealmPrincipal cache WITH DIFFERENT PASSWORD!", username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>)");
				}
			}
			else
                getLogger().info("Principal '{}' not found in cache.", fqPrincipal.toString());
		}
		else
			getLogger().info("Principal cache is not being used.");

		// if we have not been configured then do not try to do Vista connect.
		// do not try to authenticate alexdelarge in vista, it waits for timeout hence causes delay respond
		if (isInitialized() && getAuthenticateAgainstVista().booleanValue() && !inhibitThisAuthentication && !username.equalsIgnoreCase(ALEXDELARGE))
		{
			// if the principal is not already set then try to retrieve the
			// information from VistA
			if (principal == null)
			{
				//RpcBroker broker = new RpcBroker();
				NewRpcBroker broker = new NewRpcBroker();

				try
				{
					principal = new VistaRealmPrincipal(authenticationSite.getSiteNumber(), false,
							VistaRealmPrincipal.AuthenticationCredentialsType.Password);
					principal.setAccessCode(username);
					principal.setVerifyCode(password);
					principal.setPreemptiveAuthorization(this);

					// the localConnect() method sets fields in the principal
					// instance
					if(getSetCprsContext().booleanValue())
					{
						broker.localConnectWithoutImaging(authenticationSite, principal);
						// JMW 10/5/2009 - get the broker security token using the non-VistA Imaging RPC
						if(getGenerateBseToken())
						{
							String brokerSecurityToken = broker.getBrokerSecurityTokenWithoutImaging(bseRealm);
							principal.setSecurityToken(brokerSecurityToken);
						}
					}
					else
					{
						broker.localConnect(authenticationSite, principal);
						// security keys are mapped to application roles
						String[] securityKeys = broker.getUserKeys();
						// get the mapped roles and add them to the Principal
						principal.addRoles(VistaRealmRoles.getMappedRoleNames(securityKeys));
						if(getGenerateBseToken())
						{
							// JMW 12/21/2010 - need to get broker security token if VistA Imaging installed as well
							String brokerSecurityToken = broker.getBrokerSecurityTokenWithImaging(bseRealm);
							principal.setSecurityToken(brokerSecurityToken);
						}
					}

					if (getLogger().isDebugEnabled())
						for (String roleName : principal.getRoles())
                            getLogger().debug("Authenticated user '{}has role '{}'.", username, roleName);

                    getLogger().info("authenticate ({}, {}), user authenticated in Vista", username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>");

					principal.setAuthenticatedByVista(Boolean.TRUE);
				} catch (ConnectionFailedException e)
				{
                    getLogger().error("authenticate of ({}, {}), failed due to connection problem", username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>", e);
					principal = null;
					RealmErrorContext.setExceptionMessage(e);
				} catch (InvalidCredentialsException e)
				{
                    getLogger().info("authenticate of ({}, {}), failed due to invalid credentials", username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>");
					principal = null;
					RealmErrorContext.setExceptionMessage(e);
				} catch (MethodException e)
				{
                    getLogger().error("authenticate of ({}, {}), failed due to method exception (possible change in Vista version?)", username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>", e);
					principal = null;
					RealmErrorContext.setExceptionMessage(e);
				} finally
				{
					try
					{
						broker.disconnect();
					} catch (Exception x)
					{
					}
					// kludge ...
					int delay = getVistaConnectDelayKludge();
					if (delay > 0 && delay < 3000)
						try
						{
							Thread.sleep(delay);
						} catch (InterruptedException iX)
						{
						}
				}
			}
		}
		// VistaRealm connection to the local VistA has not been configured,
		// show a message to remind operations
		else
		{
			if(inhibitThisAuthentication)
			{
				getLogger().debug("This authentication has been inhibited");
			}
			else
			{
				getLogger().debug("VistaRealm has not been configured, set all Vista related properties in the configuration console before attempting ViXS transactions.");
			}
		}


		// if the principal has not had the parent realm roles appended to its
		// list and
		// there is a parent container realm (i.e. we're the realm for a context
		// and the realm for the server is available)
		// then delegate to it for additional users and/or roles
		if (appendParentRealmRoles && getParentContainerRealm() != null && !inhibitParentDelegation)
		{
			getLogger().info("Appending parent realm roles, parent container realm exists.");

			Principal parentRealmPrincipal = getParentContainerRealm().authenticate(username, password);
			if (parentRealmPrincipal != null)
			{
				if (parentRealmPrincipal instanceof GenericPrincipal)
				{
					GenericPrincipal gp = (GenericPrincipal) parentRealmPrincipal;
					if (principal == null)
					{
                        getLogger().info("authenticate ({}, {}), successfully authenticated against delegate (parent container) realm.", username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>");

						principal = new VistaRealmPrincipal(authenticationSite.getSiteNumber(), true,
								VistaRealmPrincipal.AuthenticationCredentialsType.Password);
						principal.setAccessCode(username);
						principal.setVerifyCode(password);
						principal.setPreemptiveAuthorization(this);
					}

					for (String gpRole : gp.getRoles())
						if (isKnownRole(gpRole))
							principal.addRole(gpRole);

					if (principal.getRoles().size() == 0)
					{
                        getLogger().info("authenticate ({}, {}) is a valid user but had no roles defined, hence persona non grata.", username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>");
						principal = null;
					}
					else
                        getLogger().info("authenticate ({}, {}), roles from delegated parent may have been added.", username, getShowPasswordsInLogging().booleanValue() ? password : "<password not shown>");
				}
				else
				{
					getLogger().warn("VistaRealm attempted to delegate to ancestor container realm but did not get a GenericPrincipal instance returned.");
				}
			}
		}
		else
		{
			if(inhibitParentDelegation)
			{
				getLogger().info("Parent realm delegation inhibited.");
			}
			else
			{
                getLogger().info("Parent realm roles will not be appended, {}, {}.", appendParentRealmRoles ? "append parent roles is enabled" : "append parent roles is disabled", getParentContainerRealm() != null ? "parent container realm exists" : "parent container realm does not exist");
			}
		}

		if (principal != null)
			addAdditionalMappedRoles(principal);

		// used mostly for testing, stuff an default SSN when none exists in the Principal instance
		// Fortify change: annoying, pointless null checks
		if (principal != null) {
			String defaultSSN = getDefaultSsn();
			if (defaultSSN != null) {
				if ((principal.getSsn() == null) || (principal.getSsn().length() == 0)) {
                    getLogger().warn("A default SSN ({}) is being set on the user principal, this is a test feature and should not be used in production.", defaultSSN);
					principal.setSsn(defaultSSN);
				}
			}
		}

		// set the thread local security context, if we have a Principal
		if (principal != null)
		{
			// put the principal into the cache (if it is turned on)
			if( isUsingPrincipalCache().booleanValue() )
			{
				VistaRealmPrincipal principalClone = principal.clone();
				FullyQualifiedPrincipalName fqpn = new FullyQualifiedPrincipalName(principalClone);

                getLogger().info("Caching fully qualified principal name '{}'.", fqpn.toString());
				PrincipalCacheValue principalCacheValue = new PrincipalCacheValue(principalClone);
				addPrincipalCacheEntryIfUnique(fqpn, principalCacheValue);
			}

			// set the thread local security context for later access from
			// application code
			VistaRealmSecurityContext.set(principal);
            getLogger().info("VistaRealmSecurityContext set on thread ({})", Thread.currentThread().getName());
		}

		return principal;
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
	 * Add the mapped roles from this classes additional role fields.
	 * 
	 * @param principal
	 */
	private void addAdditionalMappedRoles(VistaRealmPrincipal principal)
	{
		List<String> additionalRoles = new ArrayList<String>();
		List<String> additionalUserIdMappedRoles = this.additionalUserRoles.get(principal.getName());
		if(additionalUserIdMappedRoles != null)
			additionalRoles.addAll( additionalUserIdMappedRoles );
		
		for(String role : principal.getRoles())
		{
			List<String> additionalRoleMappedRoles = this.additionalRoleRoles.get(role);
			if(additionalRoleMappedRoles != null)
				additionalRoles.addAll( additionalRoleMappedRoles );
		}
		
		principal.addRoles(additionalRoles);
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
	public Principal authenticate(String username, byte[] credentials)
	{
		return authenticate(username, new String(credentials));
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
	public Principal authenticate(String username, String clientDigest, String nOnce, String nc, String cnonce, String qop, String realm,
	        String md5a2)
	{
        getLogger().info("authenticate ({}, digest)", username);
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
	public Principal authenticate(X509Certificate certs[])
	{
		getLogger().debug("Authenticating using X509 certificate.");
		return null;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.vistaPort == null) ? 0 : this.vistaPort.hashCode());
		result = prime * result + ((this.vistaServer == null) ? 0 : this.vistaServer.hashCode());
		return result;
	}
	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		VistaAccessVerifyRealm other = (VistaAccessVerifyRealm) obj;
		if (this.vistaPort == null)
		{
			if (other.vistaPort != null)
				return false;
		}
		else if (!this.vistaPort.equals(other.vistaPort))
			return false;
		if (this.vistaServer == null)
		{
			if (other.vistaServer != null)
				return false;
		}
		else if (!this.vistaServer.equals(other.vistaServer))
			return false;
		return true;
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
