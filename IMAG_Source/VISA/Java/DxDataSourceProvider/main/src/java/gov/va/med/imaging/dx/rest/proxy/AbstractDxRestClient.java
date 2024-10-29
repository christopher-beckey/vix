package gov.va.med.imaging.dx.rest.proxy;


import gov.va.med.imaging.proxy.rest.AbstractRestClient;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;

import javax.ws.rs.core.MediaType;

/**
* @author vhaisltjahjb
*
*/
public abstract class AbstractDxRestClient
extends AbstractRestClient
{
   private final static int defaultMetadataTimeoutMs = 500000;
   private final static String transactionLogHeaderTagName = "X-ConversationID";
   private boolean serviceOnCVIX = false;
   
   public AbstractDxRestClient(String url, String mediaType) 
   {
		super(url, mediaType, defaultMetadataTimeoutMs);
		this.serviceOnCVIX = false;
		// set our TA Log ID under DAS request header (cpt 11/21/17)
		gov.va.med.imaging.transactioncontext.TransactionContext transactionContext = TransactionContextFactory.get();
		this.request.header(transactionLogHeaderTagName, transactionContext.getTransactionId());

   }
   
   public AbstractDxRestClient(String url, MediaType mediaType)
   {
		this(url, mediaType.toString());
   }

   public void setServiceOnCVIX(boolean serviceOnCVIX)
   {
	    this.serviceOnCVIX = serviceOnCVIX;
   }

   public boolean getServiceOnCVIX()
   {
	    return this.serviceOnCVIX;
   }

   @Override
   protected void addTransactionHeaders()
   {
	    if (!getServiceOnCVIX()) //das service does not need header
	    {
	    	return;
	    }
	   
	    TransactionContext transactionContext = TransactionContextFactory.get();
		
		String duz = transactionContext.getDuz();
		if(duz != null && duz.length() > 0)
			request.header( TransactionContextHttpHeaders.httpHeaderDuz, duz);
		
		String fullname = transactionContext.getFullName();
		if(fullname != null && fullname.length() > 0)
			request.header( TransactionContextHttpHeaders.httpHeaderFullName, fullname);
		
		String sitename = transactionContext.getSiteName();
		if(sitename != null && sitename.length() > 0)
			request.header( TransactionContextHttpHeaders.httpHeaderSiteName, sitename);
		
		String sitenumber = transactionContext.getSiteNumber();
		if(sitenumber != null && sitenumber.length() > 0)
			request.header( TransactionContextHttpHeaders.httpHeaderSiteNumber, sitenumber);
		
		String ssn = transactionContext.getSsn();
		if(ssn != null && ssn.length() > 0)
			request.header( TransactionContextHttpHeaders.httpHeaderSSN, ssn);
		
		String securityToken = transactionContext.getBrokerSecurityToken();
		if(securityToken != null && securityToken.length() > 0)
			request.header(TransactionContextHttpHeaders.httpHeaderBrokerSecurityTokenId, securityToken);
		
		String cacheLocationId = transactionContext.getCacheLocationId();
		if(cacheLocationId != null && cacheLocationId.length() > 0)
			request.header(TransactionContextHttpHeaders.httpHeaderCacheLocationId, cacheLocationId);
		
		String userDivision = transactionContext.getUserDivision();
		if(userDivision != null && userDivision.length() > 0)
			request.header(TransactionContextHttpHeaders.httpHeaderUserDivision, userDivision);	
		
		String transactionId = transactionContext.getTransactionId();
		if(transactionId != null && transactionId.length() > 0)
			request.header(TransactionContextHttpHeaders.httpHeaderTransactionId, transactionId);
		
		String requestingVixSiteNumber = transactionContext.getVixSiteNumber();
		if(requestingVixSiteNumber != null && requestingVixSiteNumber.length() > 0)
			request.header(TransactionContextHttpHeaders.httpHeaderRequestingVixSiteNumber, requestingVixSiteNumber);
		
		String imagingSecurityContextType = transactionContext.getImagingSecurityContextType();
		if(imagingSecurityContextType != null && imagingSecurityContextType.length() > 0)
			request.header(TransactionContextHttpHeaders.httpHeaderOptionContext, imagingSecurityContextType);
	}
       
}

