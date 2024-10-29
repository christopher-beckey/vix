/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 4, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.router.commands.dd.provider;

import java.lang.reflect.Method;

import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.Router;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.CommandContext;
import gov.va.med.imaging.core.interfaces.router.CommandFactory;
import gov.va.med.imaging.datasource.DataDictionaryDataSourceSpi;
import gov.va.med.imaging.datasource.DataSourceProvider;
import gov.va.med.imaging.datasource.SiteResolutionDataSourceSpi;
import gov.va.med.imaging.datasource.TransactionLoggerDataSourceSpi;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.StudyFilter;

/**
 * @author VHAISWWERFEJ
 *
 */
public class DataDictionaryCommandContext 
implements CommandContext
{
	private static final Logger logger = Logger.getLogger(DataDictionaryCommandContext.class);
	
	private final CommandContext commandContext;
	private final DataDictionaryDataSourceSpi dataDictionaryService;
	
	public DataDictionaryCommandContext(CommandContext commandContext)
	{
		this.commandContext = commandContext;
		ResolvedArtifactSource resolvedArtifactSource = null;
		
		if(getLocalSite() != null)
		{
			try
			{
				resolvedArtifactSource = 
					getSiteResolver().resolveArtifactSource(getLocalSite().getArtifactSource().createRoutingToken());
			}
			catch (Exception e)
			{
				String msg = "DataDictionaryCommandContext() --> Failed to create resolvedArtifactSource to create local services during DataDictionaryCommandContext initialization: " + e.getMessage();
				logger.error(msg);
				throw new ExceptionInInitializerError(msg);
			}
		}
		
		if(resolvedArtifactSource != null)
		{
			try
			{
				this.dataDictionaryService = getProvider().createLocalDataSource(DataDictionaryDataSourceSpi.class, resolvedArtifactSource);
			}
			catch(ConnectionException x)
			{
				String msg = "DataDictionaryCommandContext() --> Failed to get Data Dictionary services during DataDictionaryCommandContext initialization: " + x.getMessage();
				logger.error(msg);
				throw new ExceptionInInitializerError(msg);
			}
		}
		else
		{
			// if everything is configured properly this should not happen. If this does happen verify VixConfig.xml is available - this is
			// the site number used to get the local site
			logger.error("DataDictionaryCommandContext() --> Could not initialize local services in DataDictionaryCommandContext, likely cannot find local site.  Return null.");
			dataDictionaryService = null;
		}
	}

	@Override
	public Router getRouter() 
	{
		return commandContext.getRouter();
	}

	@Override
	public DataSourceProvider getProvider() 
	{
		return commandContext.getProvider();
	}

	@Override
	public SiteResolutionDataSourceSpi getSiteResolver() 
	{
		return commandContext.getSiteResolver();
	}

	@Override
	public CommandFactory getCommandFactory() 
	{
		return commandContext.getCommandFactory();
	}

	@Override
	public TransactionLoggerDataSourceSpi getTransactionLoggerService() 
	{
		return commandContext.getTransactionLoggerService();
	}

	@Override
	public boolean isCachingEnabled() 
	{
		return commandContext.isCachingEnabled();
	}

	@Override
	public ResolvedSite getLocalSite() 
	{
		return commandContext.getLocalSite();
	}

	@Override
	public ResolvedArtifactSource getResolvedArtifactSource(
			RoutingToken routingToken) 
	throws MethodException 
	{
		return commandContext.getResolvedArtifactSource(routingToken);
	}

	@Override
	public ResolvedArtifactSource getResolvedArtifactSource(
			RoutingToken routingToken,
			Class<? extends VersionableDataSourceSpi> spi, Method method,
			Object[] parameters) 
	throws MethodException 
	{
		return commandContext.getResolvedArtifactSource(routingToken, spi, method, parameters);
	}

	public DataDictionaryDataSourceSpi getDataDictionaryService()
	{
		return dataDictionaryService;
	}
}
