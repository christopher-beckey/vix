/**
 * 
 */
package gov.va.med.imaging.core;

import gov.va.med.RoutingToken;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.CommandContext;
import gov.va.med.imaging.core.interfaces.router.CommandFactory;
import gov.va.med.imaging.datasource.*;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import java.lang.reflect.Method;
import java.util.List;
import gov.va.med.logging.Logger;

/**
 * This class encapsulates the context within which a Command
 * is running.  There is one instance of this class per command factory,
 * and there is usually one command factory per VM.  Multiple instances
 * won't break anything, just be horrendously inefficient.
 * 
 * @author vhaiswbeckec
 *
 */
public class CommandContextImpl 
implements CommandContext
{
	private final RouterImpl router;
	private final CommandFactory commandFactory;
	private final SiteResolutionDataSourceSpi siteResolver;
	private final List<RoutingOverrideSpi> routingOverrideServices;
	private final TransactionLoggerDataSourceSpi transactionLoggerService;
	private ResolvedSite localSite;

	private static final Logger logger = Logger.getLogger(CommandContextImpl.class);

	/**
	 * @param router
	 * @param commandFactory
	 */
	public CommandContextImpl(
		RouterImpl router,
		CommandFactory commandFactory)
	{
		super();
		// it is imperative that the local fields storing the parameters
		// are saved before calling any methods defined in this class because
		// the methods in this class rely on those values
		this.router = router;
		this.commandFactory = commandFactory;
		this.siteResolver = router.getSiteResolver();
		
		try
		{
			this.routingOverrideServices = getProvider().createRoutingOverrideServices();
		} 
		catch (ConnectionException x)
		{
			String msg = "CommandContextImpl() --> Failed to get routing override services during CommandContext initialization.";
			logger.error(msg);
			throw new ExceptionInInitializerError(msg);
		}
		try
		{
			this.transactionLoggerService = getProvider().createTransactionLoggerDataSource ();
		} 
		catch (ConnectionException x)
		{
			String msg = "CommandContextImpl() --> Failed to get routing override services during CommandContext initialization.";
			logger.error(msg);
			throw new ExceptionInInitializerError(msg);
		}

		IAppConfiguration appConfig = router.getAppConfiguration();
		
		if(appConfig != null)
		{
			String localSiteNumber = appConfig.getLocalSiteNumber();
			
			if(localSiteNumber != null && localSiteNumber.length() > 0)
			{
				try
				{
					localSite = getSiteResolver().resolveSite(localSiteNumber);
				}
				catch (Exception x)
				{
                    logger.warn("CommandContextImpl() --> Error when trying to get the local resolved site. Configured site number is [{}]: {}", localSiteNumber, x.getMessage());
					localSite = null;
				}
			}
			else
				logger.info("CommandContextImpl() --> Local site is not configured.  This message should not be seen if this is a site ViX.");
		}
	}

	public DataSourceProvider getProvider()
	{
		return getRouter().getProvider();
	}
	
	/**
	 * This will return a ResolvedSite instance representing the local site that
	 * this VIX is configured to represent as configured in the AppConfiguration 
	 * or null if this VIX does not represent a Site.
	 * 
	 * @return
	 */
	public ResolvedSite getLocalSite()
	{
		return this.localSite;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.router.CommandContext#getTransactionLoggerService()
	 */
	@Override
	public TransactionLoggerDataSourceSpi getTransactionLoggerService() 
	{
		return this.transactionLoggerService;
	}

	/**
	 * @return the logger
	 */
	protected Logger getLogger()
	{
		return this.logger;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.CommandContext#getRouter()
	 */
	public RouterImpl getRouter()
	{
		return this.router;
	}

	/**
	 * @return the siteResolver
	 */
	public SiteResolutionDataSourceSpi getSiteResolver()
	{
		return siteResolver;
	}

	/**
	 * @return the routingOverrideServices
	 */
	public List<RoutingOverrideSpi> getRoutingOverrideServices()
	{
		return this.routingOverrideServices;
	}

	/**
	 * @return the value of the application configuration cache enabled flag
	 */
	public boolean isCachingEnabled()
	{
		return true;
	}

	/**
	 * A necessary short-term evil.
	 * Return the RouterImpl reference, assuring that it is of the known type.
	 * Use getRouter() or refactor methods into the Command implementation hierarchy.
	 * 
	 * @deprecated
	 * @return
	 */
	public RouterImpl getRouterImpl()
	{
		return (RouterImpl)this.router;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.CommandContext#getCommandFactory()
	 */
	public CommandFactory getCommandFactory()
	{
		return this.commandFactory;
	}

	// =================================================================================
	// Site Resolution Methods
	// =================================================================================


	/**
	 * This method may be used by the internal methods to resolve the RoutingToken to 
	 * a ResolvedArtifactSource.  
	 * This method will make the calls to the routingOverrideServices.
	 * 
	 * This is the main entry point.
	 * 
	 * @param routingToken
	 * @param spi
	 * @param method
	 * @param parameters
	 * @return
	 * @throws MethodException
	 */
	public ResolvedArtifactSource getResolvedArtifactSource(
		RoutingToken routingToken, 
		Class<? extends VersionableDataSourceSpi> spi, 
		Method method, 
		Object[] parameters) 
	throws MethodException
	{
		if( WellKnownOID.VA_DOCUMENT.isApplicable(routingToken.getHomeCommunityId()) ||
			WellKnownOID.VA_RADIOLOGY_IMAGE.isApplicable(routingToken.getHomeCommunityId())// ||
			//WellKnownOID.BHIE_RADIOLOGY.isApplicable(routingToken.getHomeCommunityId()) )
			)
		{
			// call the VA site specific version
			return getSite(routingToken.getRepositoryUniqueId(), spi, method, parameters);
		}
		else
		{
			ResolvedArtifactSource resolved = getResolvedArtifactSource(routingToken);
			
			try
			{
				if( getRoutingOverrideServices() == null || getRoutingOverrideServices().size() == 0)
					return resolved;
				else
					for(RoutingOverrideSpi overrideService : getRoutingOverrideServices() )
						resolved = overrideService.resolve(resolved, spi, method, parameters, siteResolver);
			} 
			catch (MethodException e)
			{
				String msg = "CommandContextImpl.getResolvedArtifactSource(1) --> Configured artifact source resolution service failed to resolve routing token [" + routingToken.toString() + "]: " + e.getMessage();
				logger.error(msg);
				throw new MethodException(msg, e);
			} 
			catch (ConnectionException e)
			{
				String msg = "CommandContextImpl.getResolvedArtifactSource(1) --> Configured site resolution service is unable to contact data source: " + e.getMessage();
				logger.error(msg);
				throw new MethodConnectionException(msg, e);
			}
			
			return resolved;
		}
	}
	
	/**
	 * 
	 * @param routingToken
	 * @return
	 * @throws MethodException
	 */
	public ResolvedArtifactSource getResolvedArtifactSource(RoutingToken routingToken) 
	throws MethodException
	{
		ResolvedArtifactSource resolved = null;
		try
		{
			resolved = getSiteResolver().resolveArtifactSource(routingToken);
		} 
		catch (Exception e)
		{
			String msg = "CommandContextImpl.getResolvedArtifactSource(2) --> Configured artifact source resolution service failed to resolve routing token [" + routingToken.toString() + "]: " + e.getMessage();
			logger.error(msg);
			throw new MethodException(msg, e);
		} 

		return resolved;	
	}
	
	/**
	 * This method may be used by the internal methods to resolve the Site to 
	 * a ResolvedSite.  This method will make the calls to the routingOverrideServices.
	 * 
	 * @param spi
	 * @param method
	 * @param parameters
	 * @return
	 * @throws MethodException 
	 */
	private ResolvedArtifactSource getSite(
		String siteNumber, 
		Class<? extends VersionableDataSourceSpi> spi, 
		Method method, 
		Object[] parameters) 
	throws MethodException
	{
		ResolvedArtifactSource resolvedSite = getSite(siteNumber);
		try
		{
			if( getRoutingOverrideServices() == null || getRoutingOverrideServices().size() == 0)
				return resolvedSite;
			else
				for(RoutingOverrideSpi overrideService : getRoutingOverrideServices() )
					resolvedSite = overrideService.resolve(resolvedSite, spi, method, parameters, siteResolver);
		} 
		catch (Exception e)
		{
			String msg = "CommandContextImpl.getSite(1) --> Configured site resolution service is unable to contact site [" + siteNumber + "]: " + e.getMessage();
			getLogger().error(msg);
			throw new MethodException(msg, e);
		} 

		return resolvedSite;
	}
	
	/**
	 * 
	 * @param siteNumber
	 * @return
	 * @throws MethodException
	 */
	private ResolvedSite getSite(String siteNumber) 
	throws MethodException
	{

		ResolvedSite resolvedSite = null;
		try
		{
			resolvedSite = getSiteResolver().resolveSite(siteNumber);
		} 
		catch (Exception e)
		{
			String msg = "CommandContextImpl.getSite(2) --> Configured site resolution service is unable to contact site [" + siteNumber + "]: " + e.getMessage();
			getLogger().error(msg);
			throw new MethodException(msg, e);
		} 

		return resolvedSite;
	}
}
