package gov.va.med.imaging.mix.rest.proxy;

import gov.va.med.imaging.proxy.rest.AbstractRestClient;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;

/**
 * @author vacotittoc
 *
 */
public abstract class AbstractMixRestClient
extends AbstractRestClient
{
	private final static int defaultMetadataTimeoutMs = 600000;
	private final static String transactionLogHeaderTagName = "X-ConversationID";

	public AbstractMixRestClient(String url, String mediaType, 
			MIXConfiguration mixConfiguration)
	{
		super(url, mediaType, getMetadataTimeoutMs(mixConfiguration));
		// set our TA Log ID under DAS request header
		gov.va.med.imaging.transactioncontext.TransactionContext transactionContext = TransactionContextFactory.get();
		this.request.header(transactionLogHeaderTagName, transactionContext.getTransactionId());
	}
	
	@Override
	protected void addTransactionHeaders()
	{
	}

	private static int getMetadataTimeoutMs(MIXConfiguration mixConfiguration)
	{
		if(mixConfiguration != null)
		{
			return mixConfiguration.getMetadataTimeout();
		}
		return defaultMetadataTimeoutMs;
	}
}
