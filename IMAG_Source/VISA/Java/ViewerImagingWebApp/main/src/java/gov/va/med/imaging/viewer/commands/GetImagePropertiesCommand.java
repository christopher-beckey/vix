package gov.va.med.imaging.viewer.commands;


import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.ImageAccessReason;
import gov.va.med.imaging.exchange.enums.ImageAccessReasonType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.viewer.business.DeleteReasonsType;
import gov.va.med.imaging.viewer.business.ImageProperty;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.ImagePropertiesType;
import gov.va.med.imaging.viewer.rest.types.ImagePropertyType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author vhaisltjahjb
 *
 */
public class GetImagePropertiesCommand
extends AbstractViewerImagingCommands<List<ImageProperty>, ImagePropertiesType>
{
	private final String imageIEN;
	private final String props;
	private final String flags;
	private final String interfaceVersion;

	public GetImagePropertiesCommand(
			String imageIEN, 
			String props, 
			String flags,
			String interfaceVersion)
	{
		super("getImagePropertiesCommand");
		this.imageIEN = imageIEN;
		this.props = props;
		this.flags = flags;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<ImageProperty> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = createLocalRoutingToken();
			return getRouter().getImageProperties(routingToken, getImageIEN(), getProps(), getFlags());
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
	public Integer getEntriesReturned(ImagePropertiesType translatedResult)
	{
		return translatedResult.getImageProperties().length; 
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "from imageIen [" + this.getImageIEN() + "], flags [" + this.getFlags() + "], props [" + this.getProps() + "]";
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<ImagePropertiesType> getResultClass()
	{
		return ImagePropertiesType.class;
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
	protected ImagePropertiesType translateRouterResult(List<ImageProperty> routerResult)
	throws TranslationException, MethodException
	{
		return ViewerImagingRestTranslator.translateImageProperties(routerResult);
	}

	public String getImageIEN() {
		return imageIEN;
	}

	public String getProps() {
		return props;
	}

	public String getFlags() {
		return flags;
	}



}


