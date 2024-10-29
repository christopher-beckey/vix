/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 8, 2012
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
package gov.va.med.imaging.exchange.siteservice.commands;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.siteservice.rest.translator.SiteServiceRestTranslator;
import gov.va.med.imaging.exchange.siteservice.rest.types.SiteServiceSitesType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

import java.util.List;


/**
 * Command to retrieve the list of sites that match the specified site IDs
 * 
 * @author VHAISWWERFEJ
 *
 */
public class SiteServiceGetSitesCommand
extends AbstractSiteServiceCommand<List<Site>, SiteServiceSitesType>
{
	private final String [] siteIds;
	
	/**
	 * 
	 * @param delimitedSiteIds caret delimited site IDs
	 */
	public SiteServiceGetSitesCommand(String delimitedSiteIds)
	{
		super("getSites");
		siteIds = StringUtil.split(delimitedSiteIds, StringUtil.CARET);
	}

	public String[] getSiteIds()
	{
		return siteIds;
	}

	@Override
	protected List<Site> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		return getRouter().getSites(siteIds);
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		StringBuilder sb = new StringBuilder();
		sb.append("for sites [");
		String prefix = "";
		for(String siteId : siteIds)
		{
			sb.append(prefix);
			sb.append(siteId);
			prefix = ", ";
		}
		sb.append("]");
		return sb.toString();
	}

	@Override
	protected SiteServiceSitesType translateRouterResult(
			List<Site> routerResult) 
	throws TranslationException, MethodException
	{
		return SiteServiceRestTranslator.translateSites(routerResult);
	}

	@Override
	protected Class<SiteServiceSitesType> getResultClass()
	{
		return SiteServiceSitesType.class;
	}

	@Override
	public Integer getEntriesReturned(SiteServiceSitesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getSites().length;
	}

}
