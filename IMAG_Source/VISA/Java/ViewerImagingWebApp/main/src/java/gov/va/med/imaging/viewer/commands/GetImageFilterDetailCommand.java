package gov.va.med.imaging.viewer.commands;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.viewer.ViewerImagingContext;
import gov.va.med.imaging.viewer.business.ImageFilterFieldValue;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.ImageFilterDetailResultType;
import gov.va.med.imaging.viewer.rest.types.UserInfoType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public class GetImageFilterDetailCommand 
extends AbstractViewerImagingCommands<List<ImageFilterFieldValue>, ImageFilterDetailResultType>
{
	private Logger logger = Logger.getLogger(this.getClass());

	private final String interfaceVersion;
	private final String siteId;
	private final String filterIen;
	private final String filterName;
	private final String userId;
	
	public GetImageFilterDetailCommand(
			String siteId, 
			String filterIen, 
			String filterName, 
			String userId, 
			String interfaceVersion)
	{
		super("GetImageFilterDetailCommand");
		this.siteId = siteId;
		this.filterIen = filterIen;
		this.filterName = filterName;
		this.userId = userId;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<ImageFilterFieldValue> executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			
			return ViewerImagingContext.getRouter().getImageFilterDetail(
					routingToken, 
					getFilterIen(),
					getFilterName(),
					getUserId());
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}

	private String getFilterIen() {
		return filterIen;
	}

	private String getFilterName() {
		return filterName;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return siteId + "," + userId;
	}

	@Override
	protected Class<ImageFilterDetailResultType> getResultClass() 
	{
		return ImageFilterDetailResultType.class;
	}

	@Override
	protected ImageFilterDetailResultType translateRouterResult(List<ImageFilterFieldValue> routerResult)
	{
        logger.debug("ImageFilterDetails to translate: {}", routerResult);
    	return ViewerImagingRestTranslator.translateImageFilterFieldValues(routerResult);
	}

	public String getSiteId()
	{
		return siteId;
	}
	
	public String getUserId()
	{
		return userId;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		return null;
	}

	@Override
	public String getInterfaceVersion() {
		return interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(ImageFilterDetailResultType translatedResult) {
		return 1;
	}

}
