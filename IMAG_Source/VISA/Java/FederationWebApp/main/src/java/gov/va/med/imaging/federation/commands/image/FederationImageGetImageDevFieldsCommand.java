/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 1, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.federation.commands.image;

import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationImageGetImageDevFieldsCommand
extends AbstractFederationCommand<String, String>
{
	private final String imageUrn;
	private final String flags;
	private final String interfaceVersion;

	public FederationImageGetImageDevFieldsCommand(String imageUrn, String flags,
			String interfaceVersion)
	{
		super("getImageDevFields");
		this.imageUrn = imageUrn;
		this.flags = flags;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		AbstractImagingURN urn = null;
		try
		{
			urn = URNFactory.create(getImageUrn(), AbstractImagingURN.class);
			FederationRouter router = getRouter();
			getTransactionContext().setPatientID(urn.getPatientId());
			String response = router.getImageDevFields(urn, getFlags());
			getTransactionContext().setFacadeBytesSent(response == null ? 0L : response.length());
			return response;
		}
		catch(URNFormatException iurnfX)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(iurnfX);
		}
	}

	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(String translatedResult)
	{
		return null;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "image (" + getImageUrn() + ") with flags '" + getFlags() + "'.";
	}

	@Override
	protected Class<String> getResultClass()
	{
		return String.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getImageUrn());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		// patient ID set later

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	protected String translateRouterResult(String routerResult)
			throws TranslationException
	{
		return routerResult;
	}

	public String getImageUrn()
	{
		return imageUrn;
	}

	public String getFlags()
	{
		return flags;
	}

}
