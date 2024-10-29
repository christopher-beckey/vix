/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 19, 2010
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
package gov.va.med.imaging.clinicaldisplay.webservices.commands;

import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractClinicalDisplayGetImageDevFieldsCommand
extends AbstractClinicalDisplayWebserviceCommand<String, String>
{
	private final String imageId;
	private final String flags;
	
	public AbstractClinicalDisplayGetImageDevFieldsCommand(String imageId, String flags)
	{
		super("getImageDevFields");
		this.imageId = imageId;
		this.flags = flags;
	}

	public String getImageId()
	{
		return imageId;
	}

	public String getFlags()
	{
		return flags;
	}

	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		AbstractImagingURN urn = null;
		try
		{
			TransactionContext transactionContext = getTransactionContext();
			urn = URNFactory.create(imageId, AbstractImagingURN.class);
			transactionContext.setPatientID(urn.getPatientId());
			ClinicalDisplayRouter rtr = getRouter(); 
			String response = rtr.getImageDevFields(urn, flags);
			transactionContext.setFacadeBytesSent(response == null ? 0L : response.length());
			return response;
		}
		catch (ClassCastException e)
        {
			String msg = "'" + imageId + "' is not a valid image identifier (ImageURN).";
			getLogger().info(msg);
			throw new MethodException("ClassCaseException, unable to translate image Id", e);
        } 
		catch(URNFormatException iurnfX)
		{
            getLogger().info("FAIlED getImageInformation transaction ({}), unable to translate image Id", getTransactionId(), iurnfX);
			throw new MethodException("URNFormatException, unable to translate image Id", iurnfX);
		}
	}

	@Override
	public Integer getEntriesReturned(String translatedResult)
	{
		return null;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for image '" + getImageId() + "' with flags '" + getFlags() + "'.";
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getImageId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}

	@Override
	protected String translateRouterResult(String routerResult)
			throws TranslationException
	{
		return routerResult;
	}

}
