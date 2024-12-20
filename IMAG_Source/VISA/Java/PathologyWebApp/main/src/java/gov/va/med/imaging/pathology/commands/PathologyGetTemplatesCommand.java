/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 18, 2012
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
package gov.va.med.imaging.pathology.commands;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.pathology.rest.translator.PathologyRestTranslator;
import gov.va.med.imaging.pathology.rest.types.PathologyTemplatesType;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author VHAISWWERFEJ
 *
 */
public class PathologyGetTemplatesCommand
extends AbstractPathologyCommand<List<String>, PathologyTemplatesType>
{
	private final String siteId;
	private final String apTypes;
	
	public PathologyGetTemplatesCommand(String siteId, String apTypes)
	{
		super("getTemplates");
		this.siteId = siteId;
		this.apTypes = apTypes;
	}

	public String getSiteId()
	{
		return siteId;
	}

	public String getApTypes()
	{
		return apTypes;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<String> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken =
				RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			
			List<String> apSections = new ArrayList<String>();
			String [] sections = StringUtils.Split(getApTypes(), StringUtils.CARET);
			for(String section : sections)
			{
				apSections.add(section);
			}
			return getRouter().getPathologyTemplates(routingToken, apSections);
			
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
		return "for AP sections '" + getApTypes() + "'.";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected PathologyTemplatesType translateRouterResult(
			List<String> routerResult) 
	throws TranslationException, MethodException
	{
		return PathologyRestTranslator.translateTemplates(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<PathologyTemplatesType> getResultClass()
	{
		return PathologyTemplatesType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 */
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(PathologyTemplatesType translatedResult)
	{
		return translatedResult == null ? 0 : (translatedResult.getTemplate() == null ? 0 : translatedResult.getTemplate().length);
	}

}
