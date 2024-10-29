/**
 * 
 */
package gov.va.med.imaging.core.router.commands.dicom.importer;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceExceptionHandler;
import gov.va.med.imaging.datasource.DicomImporterDataSourceSpi;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.net.URL;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswbeckec
 *
 */
public class GetImporterVersionCompatibleCommandImpl
extends AbstractDataSourceExceptionHandler<String>
{
	private static final long serialVersionUID = 3845559383784181438L;
	private static final Logger logger = Logger.getLogger(GetImporterVersionCompatibleCommandImpl.class);
	
	private final RoutingToken routingToken;

	/**
	 * 
	 * @param RoutingToken			routing token
	 * 
	 */
	public GetImporterVersionCompatibleCommandImpl(RoutingToken routingToken)
	{
		super();
		this.routingToken = routingToken;
	}

	public RoutingToken getRoutingToken()
	{
		return this.routingToken;
	}

	public String getSiteNumber()
	{
		return this.getRoutingToken().getRepositoryUniqueId();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AsynchronousCommandProcessor#callInTransactionContext()
	 */
	@Override
	public String callSynchronouslyInTransactionContext()
	throws MethodException
	{
		TransactionContext context = TransactionContextFactory.get();
		String siteNumber = getSiteNumber();

        logger.info("GetImporterVersionCompatibleCommandImpl.callSynchronouslyInTransactionContext() --> Starts transaction Id [{}], for site number [{}]", context.getTransactionId(), siteNumber);
		ResolvedArtifactSource resolvedSite = getCommandContext().getResolvedArtifactSource(this.routingToken);
		
		if(resolvedSite == null)
	    {
            logger.warn("GetImporterVersionCompatibleCommandImpl.callSynchronouslyInTransactionContext() --> Unable to find site with site number [{}]. Verify this is a valid VA site number.", siteNumber);
	    	return "false";
	    }
        
		context.setServicedSource( getRoutingToken().toRoutingTokenString() );
		List<URL> metadataUrls = resolvedSite.getMetadataUrls();
		if(metadataUrls == null || metadataUrls.isEmpty())
		{
            logger.warn("GetImporterVersionCompatibleCommandImpl.callSynchronouslyInTransactionContext() --> Site number [{}] has no available interface URLs. Please check protocol handlers and preferences.", siteNumber);
			return "false";
		}
		Exception lastException = null;
		// try each of the configured protocols in turn
		for(URL url : metadataUrls )
		{
			try
			{
				DicomImporterDataSourceSpi dataSourceSpi = getSpi(resolvedSite, url.getProtocol());
				if(dataSourceSpi != null)
				{
					TransactionContextFactory.get().setDatasourceProtocol(url.getProtocol());
					return "true";					
				}
			}
			catch(ConnectionException cX)
			{
                logger.warn("GetImporterVersionCompatibleCommandImpl.callSynchronouslyInTransactionContext() --> Failed to contact site number [{}] using [{}]: {}", siteNumber, url.toExternalForm(), cX.getMessage());
				lastException = cX;
			}
		}
		
		if(lastException != null)
		{
			if(lastException.getClass() == ConnectionException.class)
			{
                logger.warn("GetImporterVersionCompatibleCommandImpl.callSynchronouslyInTransactionContext() --> Unable to contact data source for site number [{}] using ViX, returning Datasource Unavailable", siteNumber);
				return "false";
			}
		}
		
		return "false";
	}

	private DicomImporterDataSourceSpi getSpi(ResolvedArtifactSource resolvedSite, String protocol)
	throws ConnectionException
	{
		return (canGenerateNewToken() ? getProvider().createVersionableDataSource(DicomImporterDataSourceSpi.class, resolvedSite, protocol, this)
									  : getProvider().createVersionableDataSource(DicomImporterDataSourceSpi.class, resolvedSite, protocol));
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AsynchronousCommandProcessor#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return this.getRoutingToken().toString();
	}

	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.routingToken == null) ? 0 : this.routingToken.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (getClass() != obj.getClass())
			return false;
		final GetImporterVersionCompatibleCommandImpl other = (GetImporterVersionCompatibleCommandImpl) obj;
		if (this.routingToken == null)
		{
			if (other.routingToken != null)
				return false;
		}
		else if (!this.routingToken.equals(other.routingToken))
			return false;
		return true;
	}
}
