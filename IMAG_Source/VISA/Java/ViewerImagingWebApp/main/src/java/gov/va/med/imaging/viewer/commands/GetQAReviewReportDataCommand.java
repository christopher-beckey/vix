package gov.va.med.imaging.viewer.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 */
public class GetQAReviewReportDataCommand
extends AbstractViewerImagingCommands<String, RestStringType>
{
	private final static Logger logger = Logger.getLogger(GetQAReviewReportDataCommand.class);

	private String flags;
	private String fromDate;
	private String throughDate;
	private String mque;
	private String interfaceVersion;

	public GetQAReviewReportDataCommand(
			String flags,
			String fromDate,
			String throughDate,
			String mque,
			String interfaceVersion)
	{
		super("GetQAReviewReportDataCommand");
		this.flags = flags;
		this.fromDate = fromDate;
		this.throughDate = throughDate;
		this.mque = mque;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
            logger.info("GetQAReviewReportDataCommand parameters: {}", getMethodParameterValuesString());
			
			RoutingToken routingToken = createLocalRoutingToken();

			return getRouter().getQAReviewReportData(
					routingToken, 
					getFlags(),
					getFromDate(),
					getThroughDate(),
					getMque());
			
		}
		catch(Exception e)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(e);
		}
	}

	private String getMque() {
		return mque;
	}

	private String getThroughDate() {
		return throughDate;
	}

	private String getFromDate() {
		return fromDate;
	}

	private String getFlags() {
		return flags;
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
		return "Flags [" + getFlags() + "], From Date [" + getFromDate() + "], Through Date [" + getThroughDate() + "], mque [" + getMque() + "]";
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
	protected RestStringType translateRouterResult(String routerResult)
			throws TranslationException, MethodException 
	{
		return new RestStringType(routerResult);
	}

	@Override
	protected Class<RestStringType> getResultClass() {
		return RestStringType.class;
	}



}



