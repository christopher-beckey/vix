/**
 * 
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
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.enums.IndexClass;
import gov.va.med.imaging.indexterm.rest.translator.IndexTermRestTranslator;
import gov.va.med.imaging.indexterm.rest.types.IndexTermValuesType;

/**
 * @author Julian Werfel
 *
 */
public class GetProcedureEventsCommand
extends AbstractIndexTermsCommand<List<IndexTermValue>, IndexTermValuesType>
{

	private final String siteId;
	private final String interfaceVersion;
	private final String classes;
	private final String specialties;
	
	public GetProcedureEventsCommand(String siteId, String classes, String specialties, String interfaceVersion)
	{
		super("getProcedureEvents");
		this.siteId = siteId;
		this.classes = classes;
		this.specialties = specialties; 
		this.interfaceVersion = interfaceVersion;
	}
	
	public GetProcedureEventsCommand(String siteId, String interfaceVersion)
	{
		this(siteId, null, null, interfaceVersion);
	}

	public String getClasses()
	{
		return classes;
	}

	public String getSpecialties()
	{
		return specialties;
	}

	public String getSiteId()
	{
		return siteId;
	}

	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<IndexTermValue> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			List<IndexClass> indexClasses = IndexTermRestTranslator.toIndexClasses(getClasses());
			List<IndexTermURN> specialtyURNs = IndexTermRestTranslator.toURNs(getSpecialties());
			return getRouter().getProcedureEvents(routingToken, indexClasses, specialtyURNs);
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
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

}
