package gov.va.med.imaging.viewer.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.viewer.business.QAReviewReportResult;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.QAReviewReportResultsType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 * @param userId
 *
 */
public class GetQAReviewReportsCommand
extends AbstractViewerImagingCommands<List<QAReviewReportResult>, QAReviewReportResultsType>
{
	private final static Logger logger = Logger.getLogger(GetQAReviewReportsCommand.class);

	private String userId;
	private String interfaceVersion;

	public GetQAReviewReportsCommand(
			String userId,
			String interfaceVersion)
	{
		super("GetQAReviewReportsCommand");
		this.userId = userId;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<QAReviewReportResult> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
            logger.info("GetQAReviewReportsCommand parameters: {}", getMethodParameterValuesString());
			
			RoutingToken routingToken = createLocalRoutingToken();

			return getRouter().getQAReviewReports(
					routingToken, 
					getUserId());

		}
		catch(Exception e)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(e);
		}
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
		return "User ID [" + getUserId() + "] ";
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
	public Integer getEntriesReturned(QAReviewReportResultsType res) 
	{
		return res.getQAReviewReports().length; 
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected QAReviewReportResultsType translateRouterResult(
			List<QAReviewReportResult> routerResult)
	throws TranslationException, MethodException 
	{
		return ViewerImagingRestTranslator.translateQAReviewReportResults(routerResult);
	}

	@Override
	protected Class<QAReviewReportResultsType> getResultClass() {
		return QAReviewReportResultsType.class;
	}

}



