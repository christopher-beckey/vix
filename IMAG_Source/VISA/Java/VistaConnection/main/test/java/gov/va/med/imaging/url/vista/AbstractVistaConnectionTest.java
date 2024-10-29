package gov.va.med.imaging.url.vista;


import org.apache.logging.log4j.Level;
import gov.va.med.logging.Logger;
import org.apache.logging.log4j.core.config.Configurator;

import junit.framework.TestCase;

/**
 * An abstract test case for any test case that uses a "vista" protocol
 * 
 * @author VHAISWBECKEC
 *
 */
public abstract class AbstractVistaConnectionTest 
extends TestCase
{
	protected final static Logger logger = Logger.getLogger(AbstractVistaConnectionTest.class);
	
	
	@Override
	protected void setUp() 
	throws Exception
	{
		super.setUp();
		
		// turn logging up to max
	    Configurator.setLevel("AbstractVistaConnextionTest", Level.INFO);

	    
		String handlerPackages = System.getProperty("java.protocol.handler.pkgs");
		System.setProperty("java.protocol.handler.pkgs",
		        handlerPackages == null || handlerPackages.length() == 0 ? 
		        "gov.va.med.imaging.url" : 
		        "" + handlerPackages + "|" + "gov.va.med.imaging.url");
		
		//List<String> roles = new ArrayList<String>();
		//roles.add(VistaRealmRoles.VistaUserRole.getRoleName());
		//ClientPrincipal principal = new ClientPrincipal(
		//		"660", true, AuthenticationCredentialsType.Password, 
		//		"boating1", "boating1.", 
		//		"126", "IMAGPROVIDERONETWOSIX,ONETWOSIX", "843924956", "660", "Salt lake City", 
		//		roles, 
		//		new HashMap<String, String>()
		//);
		//TransactionContextFactory.createClientTransactionContext(principal);
	}

}
