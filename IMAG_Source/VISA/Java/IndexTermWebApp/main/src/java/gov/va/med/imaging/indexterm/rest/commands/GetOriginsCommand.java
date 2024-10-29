/**
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.rest.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.rest.translator.IndexTermRestTranslator;
import gov.va.med.imaging.indexterm.rest.types.IndexTermValuesType;

/**
 * @author Julian Werfel
 *
 */
public class GetOriginsCommand
extends AbstractIndexTermsCommand<List<IndexTermValue>, IndexTermValuesType>
{
	private final String siteId;
	private final String interfaceVersion;
	
	public GetOriginsCommand(String siteId, String interfaceVersion)
	{
		super("getOrigins");
		this.siteId = siteId;
		this.interfaceVersion = interfaceVersion;
	}

	public String getSiteId()
	{
		return siteId;
	}

	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}


	@Override
	protected List<IndexTermValue> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		
		List<IndexTermValue> indexTermList = null;
		SiteConnection siteConnection = null;

		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			siteConnection = getLocalSiteConnection();

			indexTermList = getRouter().getOrigins(routingToken);
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}

		StringBuffer buf = new StringBuffer();
		buf.append("http://");
		buf.append(siteConnection.getServer());
		buf.append(":");
		buf.append(siteConnection.getPort());
		buf.append("/IngestWebApp");			
		buf.append("/token/ingest");

		for(IndexTermValue indexTerm : indexTermList)			
			indexTerm.setSiteVixUrl(buf.toString());

		return indexTermList;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "";
	}
	
	@Override
	protected IndexTermValuesType translateRouterResult(
			List<IndexTermValue> routerResult) 
	throws TranslationException, MethodException
	{
		return IndexTermRestTranslator.translateIndexTerms(routerResult);
	}

	@Override
	protected Class<IndexTermValuesType> getResultClass()
	{
		return IndexTermValuesType.class;
	}

	@Override
	public Integer getEntriesReturned(IndexTermValuesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getIndexTerm().length;
	}

	protected SiteServiceFacadeRouter getSiteServiceRouter(){
		return SiteServiceContext.getSiteServiceFacadeRouter();
	}
	
	protected SiteConnection getLocalSiteConnection() throws MethodException, ConnectionException{
		Site site = getSiteServiceRouter().getSite(getSiteId());
		SiteConnection siteConnection = site.getSiteConnections().get(SiteConnection.siteConnectionVix);
		return siteConnection;
	}

}


