package gov.va.med.imaging.mix.rest.proxy;

import gov.va.med.imaging.proxy.rest.AbstractRestClient;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
//import gov.va.med.imaging.transactioncontext.TransactionContext;
//import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
//import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;

import javax.ws.rs.core.MediaType;

/**
 * @author vacotittoc
 *
 */
public abstract class AbstractMixRestClientInThread
extends AbstractRestClient
{
	private final static int defaultMetadataConcurentQueryTimeoutMs = 50000; // pessimistic
	private final static String transactionLogHeaderTagName = "X-ConversationID";

	public AbstractMixRestClientInThread(String url, String mediaType, 
			MIXConfiguration mixConfiguration)
	{
		super(url, mediaType, getMetadataConcurrentQueryTimeoutMs(mixConfiguration));
		// set our TA Log ID under DAS request header
		gov.va.med.imaging.transactioncontext.TransactionContext transactionContext = TransactionContextFactory.get();
		this.request.header(transactionLogHeaderTagName, transactionContext.getTransactionId());
	}
	
	@Override
	protected void addTransactionHeaders()
	{
	}

	private static int getMetadataConcurrentQueryTimeoutMs(MIXConfiguration mixConfiguration)
	{
		if(mixConfiguration != null)
		{
			return mixConfiguration.getMetadataConcurentQueryTimeout();
		}
		return defaultMetadataConcurentQueryTimeoutMs;
	}
}
