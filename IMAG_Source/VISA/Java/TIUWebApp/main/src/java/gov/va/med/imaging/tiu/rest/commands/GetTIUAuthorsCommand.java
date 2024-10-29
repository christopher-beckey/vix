/**
 * 
 * 
 * Date Created: Feb 7, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.commands;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.rest.translator.TIURestTranslator;
import gov.va.med.imaging.tiu.rest.types.TIUAuthorsType;

import java.util.List;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUAuthorsCommand
extends AbstractTIUCommand<List<TIUAuthor>, TIUAuthorsType>
{

	private final String searchText;
	private final String interfaceVersion;
	private final String siteId;
	/**
	 * @param methodName
	 * @param searchText
	 * @param interfaceVersion
	 */
	public GetTIUAuthorsCommand(String siteId, String searchText,
		String interfaceVersion)
	{
		super("getAuthors");
		this.searchText = searchText;
		this.interfaceVersion = interfaceVersion;
		this.siteId = siteId;
	}
	/**
	 * @return the searchText
	 */
	public String getSearchText()
	{
		return searchText;
	}
	/**
	 * @return the interfaceVersion
	 */
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}
	
	public String getSiteId() {
		return siteId;
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<TIUAuthor> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		try {
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			return getRouter().getTIUAuthors(routingToken, getSearchText());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting tiu authors via router", e);
		}
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "authors that match (" + getSearchText() + ")";
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected TIUAuthorsType translateRouterResult(List<TIUAuthor> routerResult)
	throws TranslationException, MethodException
	{
		return TIURestTranslator.translateTIUAuthors(routerResult);
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<TIUAuthorsType> getResultClass()
	{
		return TIUAuthorsType.class;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(TIUAuthorsType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getAuthor().length;
	}	
}
