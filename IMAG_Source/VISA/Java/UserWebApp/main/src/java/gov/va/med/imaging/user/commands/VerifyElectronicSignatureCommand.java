/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 5, 2012
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
package gov.va.med.imaging.user.commands;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.ElectronicSignatureResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.rest.types.RestCoreTranslator;
import gov.va.med.imaging.user.UserContext;

/**
 * @author VHAISWWERFEJ
 *
 */
public class VerifyElectronicSignatureCommand
extends AbstractUserCommand<ElectronicSignatureResult, RestBooleanReturnType>
{
	private final String siteId;
	private final String electronicSignature;

	/**
	 * @param methodName
	 */
	public VerifyElectronicSignatureCommand(String siteId, String electronicSignature)
	{
		super("verifyElectronicSignature");
		this.siteId = siteId;
		this.electronicSignature = electronicSignature;
	}

	public String getElectronicSignature()
	{
		return electronicSignature;
	}

	public String getSiteId()
	{
		return siteId;
	}

	@Override
	protected ElectronicSignatureResult executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken =
				RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			return UserContext.getRouter().verifyElectronicSignature(routingToken, getElectronicSignature());
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "to site '" + getSiteId() + "'";
	}

	@Override
	protected RestBooleanReturnType translateRouterResult(ElectronicSignatureResult routerResult)
	throws TranslationException, MethodException
	{		
		return RestCoreTranslator.translate(routerResult.isSuccess());
	}

	@Override
	protected Class<RestBooleanReturnType> getResultClass()
	{
		return RestBooleanReturnType.class;
	}

}
