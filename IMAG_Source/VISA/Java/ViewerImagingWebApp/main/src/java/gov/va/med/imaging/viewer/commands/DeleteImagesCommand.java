package gov.va.med.imaging.viewer.commands;


import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.viewer.business.DeleteImageUrn;
import gov.va.med.imaging.viewer.business.DeleteImageUrnResult;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.DeleteImageUrnResultsType;
import gov.va.med.imaging.viewer.rest.types.DeleteImageUrnsType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;



/**
 * @author vhaisltjahjb
 *
 */
public class DeleteImagesCommand
extends AbstractViewerImagingCommands<List<DeleteImageUrnResult>, DeleteImageUrnResultsType>
{
	private String siteNumber;
	private String interfaceVersion;
	private final DeleteImageUrnsType imageUrns;

	public DeleteImagesCommand(
			String siteNumber,
			DeleteImageUrnsType imageUrns,
			String interfaceVersion)
	{
		super("deleteImageCommand");
		this.siteNumber = siteNumber;
		this.imageUrns = imageUrns;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<DeleteImageUrnResult> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = 
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteNumber());
			return getRouter().deleteImages(
					routingToken, 
					getImageUrns()
					);
		}
		catch(Exception e)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(e);
		}
	}

	/**
	 * @return the siteNumber
	 */
	public String getSiteNumber()
	{
		return this.siteNumber;
	}
	
	/**
	 * @return the imageUrns
	 */
	public List<DeleteImageUrn> getImageUrns()
	{
		return ViewerImagingRestTranslator.translateImageUrns(imageUrns);
	}
	
	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(DeleteImageUrnResultsType translatedResult)
	{
		return translatedResult.getImageUrns().length; 
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "from site [" + getSiteNumber() + "] " +
				"imageUrns [" + this.getImageUrns() + "] ";
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<DeleteImageUrnResultsType> getResultClass()
	{
		return DeleteImageUrnResultsType.class;
	}


	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected DeleteImageUrnResultsType translateRouterResult(List<DeleteImageUrnResult> routerResult)
	throws TranslationException, MethodException
	{
		return ViewerImagingRestTranslator.translateDeleteImageUrnResults(routerResult);
	}



}


