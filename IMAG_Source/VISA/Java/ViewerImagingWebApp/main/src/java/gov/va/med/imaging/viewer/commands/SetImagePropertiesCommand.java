package gov.va.med.imaging.viewer.commands;


import gov.va.med.RoutingToken;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.viewer.business.ImageProperty;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.ImagePropertiesType;
import gov.va.med.imaging.viewer.rest.types.SetImagePropertiesResultsType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



/**
 * @author vhaisltjahjb
 *
 */
public class SetImagePropertiesCommand
extends AbstractViewerImagingCommands<List<String>, SetImagePropertiesResultsType>
{
	private String interfaceVersion;
	private ImagePropertiesType imageProperties;

	public SetImagePropertiesCommand(
			ImagePropertiesType imageProperties,
			String interfaceVersion)
	{
		super("SetImagePropertiesCommand");
		this.setImageProperties(imageProperties);
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<String> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = createLocalRoutingToken();
			String result = getRouter().setImageProperties(
					routingToken, 
					getImageProperties()
					);
			
			String[] ret = StringUtil.split(result, StringUtil.NEW_LINE);
			return Arrays.asList(ret);
		}
		catch(Exception e)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(e);
		}
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
	public Integer getEntriesReturned(SetImagePropertiesResultsType translatedResult)
	{
		return translatedResult.getImageProperties().length; 
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "imageProperties [" + this.getImageProperties() + "] ";
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<SetImagePropertiesResultsType> getResultClass()
	{
		return SetImagePropertiesResultsType.class;
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
	protected SetImagePropertiesResultsType translateRouterResult(List<String> routerResult) 
	throws TranslationException, MethodException 
	{
		return ViewerImagingRestTranslator.translateSetImagePropertiesResults(routerResult);
	}

	public void setImageProperties(ImagePropertiesType imageProperties) {
		this.imageProperties = imageProperties;
	}

	public List<ImageProperty> getImageProperties()
	{
		return ViewerImagingRestTranslator.translateImageProperties(imageProperties);
	}



}


