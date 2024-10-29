/**
 * 
 */
package gov.va.med.imaging;

import gov.va.med.RoutingToken;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;
import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.imaging.facade.configuration.FilterConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;
import gov.va.med.imaging.utils.NetUtilities;
import gov.va.med.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

/**
 * The SecurityFilter sets some properties of the transaction context based
 * on initialization parameters in the web configuration file.  
 * This class also copies HTTP headers into the transaction context.
 * 
 * @author vhaiswbeckec
 *
 */
public class SecurityFilter 
implements Filter
{
	private final static Logger LOGGER = Logger.getLogger(SecurityFilter.class);
	
	private boolean generateTransactionId = false;		// for a web app where the transaction initiates this may be true
	private boolean enableProtocolOverride = false;		// for test drivers, enable this in the web.xml to allow 
														// protocolOverride and targetSite query parameter
	private FilterConfiguration filterConfiguration = null;
	
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	public void init(FilterConfig config) 
	throws ServletException
	{
		generateTransactionId = Boolean.parseBoolean( config.getInitParameter("generateTransactionId") );
		enableProtocolOverride = Boolean.parseBoolean( config.getInitParameter("enableProtocolOverride") );
        LOGGER.info("SecurityFilter.init() --> for {}{} generate transaction IDs if they do not exist.", config.getServletContext().getServletContextName(), generateTransactionId ? " will" : " will not");
        LOGGER.info("SecurityFilter.init() --> for {}{} allow protocol and target site ovveride.", config.getServletContext().getServletContextName(), enableProtocolOverride ? " will" : " will not");
		
		//readHostName();
	}

	// =======================================================================================================
	// Accessors so that Spring can initialize 
	// =======================================================================================================
	public boolean isGenerateTransactionId()
    {
    	return generateTransactionId;
    }
	public void setGenerateTransactionId(boolean generateTransactionId)
    {
    	this.generateTransactionId = generateTransactionId;
    }

	public boolean isEnableProtocolOverride()
    {
    	return enableProtocolOverride;
    }
	public void setEnableProtocolOverride(boolean enableProtocolOverride)
    {
    	this.enableProtocolOverride = enableProtocolOverride;
    }

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	public void doFilter(
		ServletRequest request, 
		ServletResponse response,
		FilterChain chain) 
	throws IOException, ServletException
	{
    	Long startTime = System.currentTimeMillis();
		// The principal should be accessible in the request and would be accessible if we knew this was
		// an HTTP request.
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setStartTime(startTime);
		
		// Determine the hostname for logging.
		// The init method never seems to get called.  Spring vs. Container loading?
		// Determine the hostname for later logging.
	
		
		// Record the hostname.
		transactionContext.setMachineName (readHostName());
		
		if(request instanceof HttpServletRequest)
		{
			HttpServletRequest httpRequest = (HttpServletRequest)request;
            LOGGER.info("TransactionContext {}.  VistaRealmSecurityContext, getting credentials from HTTP header information...", Boolean.valueOf(transactionContext.isAuthenticatedByDelegate()) ? "is authenticated by delegate" : "is authenticated by VistA");
			
			transactionContext.setOriginatingAddress(httpRequest.getRemoteAddr() + ":" + httpRequest.getRemotePort());

            LOGGER.debug("Checking http header for credentials in {}", this.getClass().getName());
            LOGGER.debug("DUZ: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderDuz));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderDuz) != null)
				transactionContext.setDuz(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderDuz));
            LOGGER.debug("Full Name: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderFullName));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderFullName) != null)
				transactionContext.setFullName(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderFullName));
            LOGGER.debug("Site Name: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderSiteName));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderSiteName) != null)
				transactionContext.setSiteName(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderSiteName));
            LOGGER.debug("Site Number: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderSiteNumber));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderSiteNumber) != null)
				transactionContext.setSiteNumber(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderSiteNumber));
            LOGGER.debug("SSN: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderSSN));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderSSN) != null)
				transactionContext.setSsn(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderSSN));
            LOGGER.debug("Transaction ID: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderTransactionId));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderTransactionId) != null)
				transactionContext.setTransactionId(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderTransactionId));
            LOGGER.debug("Purpose of Use: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderPurposeOfUse));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderPurposeOfUse) != null)
				transactionContext.setPurposeOfUse(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderPurposeOfUse));
            LOGGER.debug("Broker Security Token ID: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderBrokerSecurityTokenId));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderBrokerSecurityTokenId) != null) {
				String token = httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderBrokerSecurityTokenId);
				transactionContext.setBrokerSecurityToken(updT(token, transactionContext));
			}
            LOGGER.debug("Cache Location ID: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderCacheLocationId));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderCacheLocationId) != null)
				transactionContext.setCacheLocationId(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderCacheLocationId));
            LOGGER.debug("User Division: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderUserDivision));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderUserDivision) != null)
				transactionContext.setUserDivision(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderUserDivision));
            LOGGER.debug("Client Version: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderClientVersion));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderClientVersion) != null)
				transactionContext.setClientVersion(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderClientVersion));
            LOGGER.debug("Requesting Vix Site Number: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderRequestingVixSiteNumber));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderRequestingVixSiteNumber) != null)
				transactionContext.setRequestingVixSiteNumber(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderRequestingVixSiteNumber));
            LOGGER.debug("Option Context: {}", httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderOptionContext));
			if(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderOptionContext) != null)
				transactionContext.setImagingSecurityContextType(httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderOptionContext));
			String httpHeaderAllowAddFederationCompression = httpRequest.getHeader(TransactionContextHttpHeaders.httpHeaderAllowAddFederationCompression);

			//WFP-This made it work. But I have to confirm this is the correct location.
			//	My intent was to place it within the Importer web service calls.
			transactionContext.setBrokerSecurityApplicationName("VISTA IMAGING VIX");			

			if(httpHeaderAllowAddFederationCompression != null && httpHeaderAllowAddFederationCompression.length() > 0)
			{
				transactionContext.setAllowAddFederationCompression(Boolean.parseBoolean(httpHeaderAllowAddFederationCompression));
			}
			
			if(transactionContext.getTransactionId() == null && generateTransactionId)
			{
				LOGGER.debug("Generated transaction ID.");
				transactionContext.setTransactionId( (new GUID()).toLongString() );
			}
			
			// If protocol override is enabled, and it should not be in a production
			// setting, then copy the protocol and target server into the transaction
			// context.
			if(enableProtocolOverride)
			{
				// "secret" request parameters that allow some control of the router
				String protocolOverride = request.getParameter("protocolOverride");
				String targetSite = request.getParameter("targetSite");
				
				if(targetSite != null && targetSite.length() > 0 && protocolOverride != null && protocolOverride.length() > 0)
				{
                    LOGGER.warn("Preferred protocols for transaction [{}] explicitly set to '{}', and target server '{}'.", transactionContext.getTransactionId(), protocolOverride, targetSite);
					
					RoutingToken routingToken;
					try
					{
						routingToken = RoutingTokenImpl.createVARadiologySite(targetSite);
						transactionContext.setOverrideProtocol(protocolOverride);
						transactionContext.setOverrideRoutingToken(routingToken);
					}
					catch (RoutingTokenFormatException x)
					{
                        LOGGER.error("SecurityFilter.doFilter() --> Encoutered RoutingTokenFormatException: {}", x.getMessage());
						throw new ServletException("SecurityFilter.doFilter() --> Encoutered RoutingTokenFormatException", x);
					}
				}
				
			}
		}	
		else
			LOGGER.warn("SecurityFilter.doFilter() --> Unable to provide security information: passed non-HTTP request");

        LOGGER.info("Transaction ID [{}]", transactionContext.getTransactionId());
		
		try
		{
			chain.doFilter(request, response);		// the remainder of the servlet chain and the servlet get called within here
		}
		catch(Exception ex)
		{
			// JMW 7/8/08 - we want to catch the exception so we can put
			// it into the transaction context (if there is no previous message).
			if((transactionContext.getErrorMessage() == null) ||
				(transactionContext.getErrorMessage().length() <= 0))
			{
				// CPT 8/14/08 - handle "exception_cause_message == null" case (e.g. NullPointerException)
				String msg = null;
				try 
				{
					if(ex.getCause() != null)
						msg = ex.getCause().getMessage();
					else
						msg = ex.toString();
				}
				catch (Exception e) 
				{
					msg = "Undelegated Exception";
				}
                LOGGER.info("Caught exception [{}] in SecurityFilter and putting into transaction context", msg);
				transactionContext.setErrorMessage(msg);
				transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			}
			
			if(ex.getClass() == IOException.class)
			{
                LOGGER.error("SecurityFilter.doFilter() --> Encountered IOException: {}", ex.getMessage());
				throw (IOException)ex;
			}
			else 
			{
                LOGGER.error("SecurityFilter.doFilter() --> Encountered an exception: {}", ex.getMessage());
				throw new ServletException(ex);
			}
		}
		finally
		{
			//write the current thread's TransactionContext to the Transaction Log
            LOGGER.info("Writing entry to transaction log for transaction '{}'", transactionContext.getTransactionId());
			
			try 
			{
				BaseWebFacadeRouter router = FacadeRouterUtility
						.getFacadeRouter(BaseWebFacadeRouter.class);
				router.postTransactionLogEntryImmediate(new TransactionContextLogEntrySnapshot(transactionContext));
			} catch (Exception xAny) 
			{
                LOGGER.error("postTransactionLogEntryImmediate Failed: {}", xAny.getMessage());
				// don't throw the exception so the client doesn't see it, this transaction will just be dropped
				//throw new ServletException(xAny);
			}

			// Clear the security context so that the thread has no remaining
			// references and has no
			// established security context when it is reused.
			// Once the transaction context is cleared, called to it will do
			// nothing but log a warning (and return null)
			transactionContext.clear();
		}
	}

	private String updT(String arg1, TransactionContext transactionContext) {
		if (filterConfiguration == null){
			filterConfiguration = FilterConfiguration.getConfiguration();
		}
		if(filterConfiguration == null || !filterConfiguration.isRewriteT()){
			return arg1;
		}
		for(EncryptedConfigurationPropertyString r : filterConfiguration.getToReplace()){
			if(arg1.contains(r.getValue())){
				return arg1.replace(r.getValue(), filterConfiguration.getReplacement().getValue());
			}
		}
		if(!arg1.contains("^") && arg1.length() < 1000){
			try {
				int port = getVistaPortBySiteCode(transactionContext.getSiteNumber());
				if (port == -1) return arg1;
				String newT = filterConfiguration.getReplacement().getValue() + "^" + arg1 + "^" +
						transactionContext.getSiteNumber() + "^" + port;
				return newT;
			}catch (Exception e){
                LOGGER.error("could not reconstruct token for site {}", transactionContext.getSiteNumber());
			}
		}
		return arg1;
	}

	private static int getVistaPortBySiteCode(String siteCode) throws MethodException, ConnectionException {
		Site site = getSiteByCode(siteCode);
		for(SiteConnection sc : site.getSiteConnections().values()){
			if(sc.getProtocol().equals("VISTA")) return sc.getPort();
		}
		return -1;
	}

	public static Site getSiteByCode(String remoteSiteNumber) throws MethodException, ConnectionException {
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();
		List<Region> regions = router.getRegionList();
		regions.sort(new RegionComparator());
		for (Region region : regions) {
			for (Site site : region.getSites()) {
				if (site.getSiteNumber().equals(remoteSiteNumber)) {
					return site;
				}
			}
		}
		return null;
	}


	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.Filter#destroy()
	 */
	public void destroy()
	{
	}
	
	public String readHostName()
	{
		return NetUtilities.getUnsafeLocalHostName();
	}
}
