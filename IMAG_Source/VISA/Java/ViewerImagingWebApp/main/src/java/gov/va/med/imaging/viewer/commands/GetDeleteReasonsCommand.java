package gov.va.med.imaging.viewer.commands;


import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.ImageAccessReason;
import gov.va.med.imaging.exchange.enums.ImageAccessReasonType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.viewer.business.DeleteImageUrn;
import gov.va.med.imaging.viewer.business.DeleteImageUrnResult;
import gov.va.med.imaging.viewer.business.DeleteReasonsType;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.DeleteImageUrnResultsType;
import gov.va.med.imaging.viewer.rest.types.DeleteImageUrnsType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author vhaisltjahjb
 *
 */
public class GetDeleteReasonsCommand
extends AbstractViewerImagingCommands<List<ImageAccessReason>, DeleteReasonsType>
{
	private String siteNumber;
	private String interfaceVersion;

	public GetDeleteReasonsCommand(
			String siteNumber,
			String interfaceVersion)
	{
		super("getDeleteReasonsCommand");
		this.siteNumber = siteNumber;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<ImageAccessReason> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = 
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteNumber());
			List<ImageAccessReasonType> reasonTypes = new ArrayList<ImageAccessReasonType>();
			reasonTypes.add(ImageAccessReasonType.deleteImage);
			return getRouter().getImageAccessReasonList(routingToken, reasonTypes);
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

	
	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(DeleteReasonsType translatedResult)
	{
		return translatedResult.getDeleteReasons().length; 
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "from site [" + getSiteNumber() + "]";
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<DeleteReasonsType> getResultClass()
	{
		return DeleteReasonsType.class;
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
	protected DeleteReasonsType translateRouterResult(List<ImageAccessReason> routerResult)
	throws TranslationException, MethodException
	{
		return ViewerImagingRestTranslator.translateDeleteReasons(routerResult);
	}



}


