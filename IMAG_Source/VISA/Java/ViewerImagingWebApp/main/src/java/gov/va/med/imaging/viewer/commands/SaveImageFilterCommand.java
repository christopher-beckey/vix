package gov.va.med.imaging.viewer.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.viewer.business.ImageFilterFieldValue;
import gov.va.med.imaging.viewer.rest.types.ImageFilterFieldValueType;
import gov.va.med.imaging.viewer.rest.types.ImageFilterFieldValuesType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



/**
 * @author vhaisltjahjb
 *
 */
public class SaveImageFilterCommand
extends AbstractViewerImagingCommands<String, RestStringType>
{
	private final String interfaceVersion;
	private String siteNumber;
	private final ImageFilterFieldValuesType imageFilterFieldValues;

	public SaveImageFilterCommand(
			String siteNumber,
			ImageFilterFieldValuesType imageFilterFieldValues,
			String interfaceVersion)
	{
		super("SaveImageFilterCommand");
		this.siteNumber = siteNumber;
		this.imageFilterFieldValues = imageFilterFieldValues;
		this.interfaceVersion = interfaceVersion;
	}

	
	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = 
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteNumber());
			return getRouter().saveImageFilter(
					routingToken, 
					getImageFilterFieldValues()
					);
		}
		catch(Exception e)
		{
			return "0" + e.getMessage();
		}
	}


	public List<ImageFilterFieldValue> getImageFilterFieldValues() 
	{
		List<ImageFilterFieldValue> result = new ArrayList<ImageFilterFieldValue>();
		
		ImageFilterFieldValueType[] filterType = imageFilterFieldValues.getImageFilterFieldValues();
		
		for(int i=0; i<filterType.length; i++)
		{
			ImageFilterFieldValue filterFieldValue = new ImageFilterFieldValue(
					filterType[i].getFieldName(),
					filterType[i].getFieldValue());
			result.add(filterFieldValue);
		}
			
		return result;
	}


	/**
	 * @return the siteNumber
	 */
	public String getSiteNumber()
	{
		return this.siteNumber;
	}
	

	/**
	 * @return the imageFilterFieldValues Size
	 */
	public int getImageFilterFieldValuesSize()
	{
		return imageFilterFieldValues.getImageFilterFieldValues().length;
	}
	
	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "from site [" + getSiteNumber() + "] " +
				"imageUrns size [" + this.getImageFilterFieldValuesSize() + "] ";
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

	@Override
	public Integer getEntriesReturned(RestStringType translatedResult) {
		return 1;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected RestStringType translateRouterResult(
			String routerResult)
	throws TranslationException, MethodException 
	{
		return new RestStringType(routerResult);
	}

	@Override
	protected Class<RestStringType> getResultClass() {
		return RestStringType.class;
	}

	


}


