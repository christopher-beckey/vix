/**
 * 
 */
package gov.va.med.imaging.dx.datasource.test;

import gov.va.med.ProtocolHandlerUtility;
import gov.va.med.imaging.datasource.DataSourceProvider;
import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.ResolvedSiteImpl;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteImpl;
import gov.va.med.imaging.tomcat.vistarealm.VistaRealmPrincipal.AuthenticationCredentialsType;
import gov.va.med.imaging.transactioncontext.ClientPrincipal;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.logging.log4j.Level;
import gov.va.med.logging.Logger;
import org.apache.logging.log4j.core.config.Configurator;

/**
 * @author vhaiswbeckec
 *
 */
public abstract class AbstractDxDataSourceTest
{
	private static List<URL> metadataUrls = null;
	private static List<URL> artifactUrls = null;
	
	protected static synchronized List<URL> getMetadataUrls()
	throws MalformedURLException
	{
		if(metadataUrls == null)
		{
			metadataUrls = new ArrayList<URL>();
			metadataUrls.add( new URL("vista://locahost:9300") );
			metadataUrls.add( new URL("vistaimaging://localhost:9300") );
			metadataUrls.add( new URL("vftp://localhost:8080") );
			metadataUrls.add( new URL("dx://localhost:1963/des_proxy_adapter/v1/filter/dmix/dataservice") );
		}
		return metadataUrls;
	}

	protected static synchronized List<URL> getArtifactUrls() 
	throws MalformedURLException
	{
		if(artifactUrls == null)
		{
			artifactUrls = new ArrayList<URL>();
			artifactUrls.add( new URL("vista://locahost:9300") );
			artifactUrls.add( new URL("vistaimaging://localhost:9300") );
			artifactUrls.add( new URL("vftp://localhost:8080") );
			artifactUrls.add( new URL("dx://localhost:1963/des_proxy_adapter/v1/filter/dmix/dataservice") );
		}
		return artifactUrls;
	}

	/**
	 * 
	 */
	protected static void initializeConnectionHandlers()
	{
		ProtocolHandlerUtility.initialize(true);
	}
	
	/**
	 * 
	 */
	protected static void initializeTransactionContext()
	{
		List<String> roles = new ArrayList<String>();
		ClientPrincipal principal = new ClientPrincipal(
				"660", true, AuthenticationCredentialsType.Password, 
				"boating1", "boating1.", 
				"126", "IMAGPROVIDERONETWOSIX,ONETWOSIX", "843924956", "660", "Salt lake City", 
				roles, 
				new HashMap<String, Object>()
		);
		TransactionContextFactory.createClientTransactionContext(principal);
	}
	
	protected static void initializeLogging()
	{
		Configurator.setRootLevel(Level.ALL);
	}
	
	private static DataSourceProvider provider;
	protected static synchronized DataSourceProvider getProvider()
	{
		if(provider == null)
			provider = new Provider();
		
		return provider;
	}

	protected static Site getVATestSite() 
	throws MalformedURLException
	{
		return new SiteImpl("660", "Salt Lake City", "SLC", "localhost", 9300, "localhost", 8080, "");
	}
	
	protected static Site getDoDTestSite() 
	throws MalformedURLException
	{
		return new SiteImpl("200", "DoD", "DOD", null, 0, "vhaiswimmixvix3", 8080, "");
	}
	
	private static ResolvedSiteImpl resolvedVASite = null;
	protected static synchronized ResolvedSite getTestVAResolvedSite() 
	throws MalformedURLException
	{
		if(resolvedVASite == null)
		{
			resolvedVASite = ResolvedSiteImpl.create(
				getVATestSite(), 
				true, 
				false, 
				true,
				getMetadataUrls(), 
				getArtifactUrls());
		}		
		return resolvedVASite;
	}
		
	private static ResolvedSiteImpl resolvedDoDSite = null;
	protected static synchronized ResolvedSite getTestDoDResolvedSite() 
	throws MalformedURLException
	{
		if(resolvedDoDSite == null)
		{
			resolvedDoDSite = ResolvedSiteImpl.create(
				getDoDTestSite(), 
				true, 
				false,
				true,
				getMetadataUrls(), 
				getArtifactUrls());
		}		
		return resolvedDoDSite;
	}
}
