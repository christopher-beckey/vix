package gov.va.med.imaging.viewer.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.PatientNotFoundException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.viewer.business.CaptureUserResult;
import gov.va.med.imaging.viewer.business.ImageFilterResult;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceService;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.CaptureUserResultsType;
import gov.va.med.imaging.viewer.rest.types.ImageFilterResultsType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 * @param List<ImageFilterResult>
 * @param ImageFilterResultsType
 *
 */
public class GetImageFiltersCommand
extends AbstractViewerImagingCommands<List<ImageFilterResult>, ImageFilterResultsType>
{
	private final static Logger logger = Logger.getLogger(ViewerImagingDataSourceService.class);

	private String siteNumber;
	private String userId;
	private String interfaceVersion;

	public GetImageFiltersCommand(
			String siteNumber,
			String userId,
			String interfaceVersion)
	{
		super("GetImageFiltersCommand");
		this.siteNumber = siteNumber;
		this.userId = userId;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<ImageFilterResult> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
            logger.info("GetImageFiltersCommand parameters: {}", getMethodParameterValuesString());
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());

			return getRouter().getImageFilters(
					routingToken, 
					getUserId());

		}
		catch(Exception e)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(e);
		}
	}

	private String getSiteId() {
		return siteNumber;
	}

	/**
	 * @return the userId
	 */
	public String getUserId()
	{
		return this.userId;
	}
	
	@Override
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "Site Number [" + getSiteId() + ", User ID [" + getUserId() + "] ";
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
	public Integer getEntriesReturned(ImageFilterResultsType res) 
	{
		return res.getImageFilters().length; 
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected ImageFilterResultsType translateRouterResult(
			List<ImageFilterResult> routerResult)
	throws TranslationException, MethodException 
	{
		return ViewerImagingRestTranslator.translate(routerResult);
	}

	@Override
	protected Class<ImageFilterResultsType> getResultClass() {
		return ImageFilterResultsType.class;
	}

}



