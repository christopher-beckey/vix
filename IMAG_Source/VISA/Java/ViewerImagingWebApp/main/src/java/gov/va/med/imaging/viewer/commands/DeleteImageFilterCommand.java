package gov.va.med.imaging.viewer.commands;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.viewer.ViewerImagingContext;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public class DeleteImageFilterCommand 
extends AbstractViewerImagingCommands<String, RestStringType>
{
	private Logger logger = Logger.getLogger(this.getClass());

	private final String interfaceVersion;
	private final String siteId;
	private final String filterIen;
	
	public DeleteImageFilterCommand(String siteId, String filterIen, String interfaceVersion)
	{
		super("DeleteImageFilterCommand");
		
		this.siteId = siteId;
		this.filterIen = filterIen;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		try {
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			return ViewerImagingContext.getRouter().deleteImageFilter(routingToken,getFilterIen());
		} catch (MethodException e) {
			return "0^" + e.getMessage();
		}
		catch(RoutingTokenFormatException rtfX)
		{
			return "0^" + rtfX.getMessage();
		}
	
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return getFilterIen();
	}

	@Override
	protected Class<RestStringType> getResultClass() 
	{
		return RestStringType.class;
	}

	@Override
	protected RestStringType translateRouterResult(String routerResult)
	{
    	return new RestStringType(routerResult);
	}

	public String getSiteId()
	{
		return siteId;
	}

	public String getFilterIen() {
		return filterIen;
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
	public Integer getEntriesReturned(RestStringType translatedResult) {
		return 1;
	}

}
