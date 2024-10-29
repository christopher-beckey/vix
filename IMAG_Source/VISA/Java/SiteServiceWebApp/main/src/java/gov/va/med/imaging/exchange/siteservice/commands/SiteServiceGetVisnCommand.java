/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 5, 2012
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

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.exchange.siteservice.rest.translator.SiteServiceRestTranslator;
import gov.va.med.imaging.exchange.siteservice.rest.types.SiteServiceVisnType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

/**
 * @author VHAISWWERFEJ
 *
 */
public class SiteServiceGetVisnCommand
extends AbstractSiteServiceCommand<Region, SiteServiceVisnType>
{

	private final String visnNumber;
	
	/**
	 * @param methodName
	 */
	public SiteServiceGetVisnCommand(String visnNumber)
	{
		super("getVisn");
		this.visnNumber = visnNumber;
	}

	public String getVisnNumber()
	{
		return visnNumber;
	}

	@Override
	protected Region executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		return getRouter().getRegion(getVisnNumber());
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for VISN [" + getVisnNumber() + "]";
	}

	@Override
	protected SiteServiceVisnType translateRouterResult(Region routerResult)
	throws TranslationException, MethodException
	{
		return SiteServiceRestTranslator.translate(routerResult);
	}

	@Override
	protected Class<SiteServiceVisnType> getResultClass()
	{
		return SiteServiceVisnType.class;
	}

	@Override
	public Integer getEntriesReturned(SiteServiceVisnType translatedResult)
	{
		return translatedResult == null ? 0 : 1;
	}

}
