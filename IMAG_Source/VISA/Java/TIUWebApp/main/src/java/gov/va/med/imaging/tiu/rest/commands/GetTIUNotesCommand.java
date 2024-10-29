/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.rest.translator.TIURestTranslator;
import gov.va.med.imaging.tiu.rest.types.TIUNotesType;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUNotesCommand
extends AbstractTIUCommand<List<TIUNote>, TIUNotesType>
{

	private final String searchText;
	private final String interfaceVersion;
	private final String siteId;
	private final String titleList;
	/**
	 * @param methodName
	 * @param searchText
	 * @param interfaceVersion
	 */
	public GetTIUNotesCommand(String siteId, String searchText, String titleList,
		String interfaceVersion)
	{
		super("getNotes");
		this.searchText = searchText;
		this.interfaceVersion = interfaceVersion;
		this.siteId = siteId;
		this.titleList = titleList;
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
	
	public String getTitleList() {
		return titleList;
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<TIUNote> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		try {	
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			return getRouter().getTIUNotes(routingToken, getSearchText(), getTitleList());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting tiu notes via router", e);
		}
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "notes that match (" + getSearchText() + ")";
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected TIUNotesType translateRouterResult(List<TIUNote> routerResult)
	throws TranslationException, MethodException
	{
		return TIURestTranslator.translateTIUNotes(routerResult);
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<TIUNotesType> getResultClass()
	{
		return TIUNotesType.class;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(TIUNotesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getNote().length;
	}	
}
