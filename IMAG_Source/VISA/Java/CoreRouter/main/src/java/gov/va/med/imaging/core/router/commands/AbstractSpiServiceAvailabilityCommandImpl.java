/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 17, 2011
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
package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceExceptionHandler;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.net.URL;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * This command determines if an SPI is available and there is a way to use it to communicate
 * with a location identified by a routing token.
 * 
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractSpiServiceAvailabilityCommandImpl<E extends VersionableDataSourceSpi>
extends AbstractDataSourceExceptionHandler<Boolean>
{
	private static final long serialVersionUID = 4236272158963151131L;
	private static final Logger logger = Logger.getLogger(AbstractSpiServiceAvailabilityCommandImpl.class);
	
	private final RoutingToken routingToken;
	private final Class<E> spiType;

	/**
	 * @param router
	 * @param accessibilityDate
	 * @param priority
	 * @param processingTargetCommencementDate
	 * @param processingDurationEstimate
	 */
	public AbstractSpiServiceAvailabilityCommandImpl(RoutingToken routingToken,
			Class<E> spiType)
	{
		super();
		this.routingToken = routingToken;
		this.spiType = spiType;
	}

	public RoutingToken getRoutingToken()
	{
		return this.routingToken;
	}

	public Class<E> getSpiType()
	{
		return spiType;
	}

	public String getSiteNumber()
	{
		return this.getRoutingToken().getRepositoryUniqueId();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AsynchronousCommandProcessor#callInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext()
	throws MethodException
	{
		TransactionContext context = TransactionContextFactory.get();
        logger.info("AbstractSpiServiceAvailabilityCommandImpl.callSynchronouslyInTransactionContext() --> Determining if server [{}] is available at [{}]", this.spiType.getSimpleName(), this.routingToken.toRoutingTokenString());
		ResolvedArtifactSource resolvedSite = getCommandContext().getResolvedArtifactSource(getRoutingToken());
		
		if(resolvedSite == null)
	    {
            logger.warn("AbstractSpiServiceAvailabilityCommandImpl.callSynchronouslyInTransactionContext() --> Unable to find site with site number [{}]. Verify this is a valid VA site number. Cannot access data from this site. Return false.", getSiteNumber());
	    	return false;
	    }
        
		context.setServicedSource( getRoutingToken().toRoutingTokenString() );
		List<URL> metadataUrls = resolvedSite.getMetadataUrls();
		
		if(metadataUrls == null || metadataUrls.isEmpty())
		{
            logger.warn("AbstractSpiServiceAvailabilityCommandImpl.callSynchronouslyInTransactionContext() --> Site [{}] has no available interface URLs. Please check the protocol handlers and preferences.", getSiteNumber());
			return false;
		}
		
		//Exception lastException = null;
		// try each of the configured protocols in turn
		TransactionContext transactionContext = TransactionContextFactory.get();
		for(URL url : metadataUrls )
		{
			try
			{
				E spiResolver = getSpi(resolvedSite, url.getProtocol());
				if(spiResolver != null)
				{

					transactionContext.setDatasourceProtocol(url.getProtocol());
					String msg = "AbstractSpiServiceAvailabilityCommandImpl.callSynchronouslyInTransactionContext() --> Able to use SPI [" + this.spiType.getSimpleName() + "] to access [" +  this.routingToken.toRoutingTokenString() + "]";
					logger.info(msg);
					transactionContext.addDebugInformation(msg);
					return true;					
				}
			}
			catch(ConnectionException cX)
			{
                logger.warn("AbstractSpiServiceAvailabilityCommandImpl.callSynchronouslyInTransactionContext() --> Failed to contact site [{}] using [{}]: {}", getSiteNumber(), url.toExternalForm(), cX.getMessage());
				//lastException = cX;
			}
		}
		
		/* QN: Redundant
		if(lastException != null)
		{
			if(lastException.getClass() == ConnectionException.class)
			{
				getLogger().info("Unable to contact data source for site '" + getSiteNumber() + "' using ViX, returning Datasource Unavailable");
				return false;
			}
		}
		*/
		
		String msg = "AbstractSpiServiceAvailabilityCommandImpl.callSynchronouslyInTransactionContext() --> Cannot use SPI [" + getSpiType().getSimpleName() + "] to access [" +  getRoutingToken().toRoutingTokenString() + "]"; 
		logger.info(msg);
		transactionContext.addDebugInformation(msg);
		return false;
	}

	private E getSpi(ResolvedArtifactSource resolvedSite, String protocol)
	throws ConnectionException
	{
		return (canGenerateNewToken() ? getProvider().createVersionableDataSource(getSpiType(), resolvedSite, protocol, this)
									  : getProvider().createVersionableDataSource(getSpiType(), resolvedSite, protocol));
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

	@SuppressWarnings("unchecked")
	@Override
	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (getClass() != obj.getClass())
			return false;
		final AbstractSpiServiceAvailabilityCommandImpl<E> other = (AbstractSpiServiceAvailabilityCommandImpl<E>) obj;
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
