package gov.va.med.imaging.viewer.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.viewer.business.CaptureUserResult;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceService;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.CaptureUserResultsType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 * @param appFlag
 * @param fromDate
 * @param throughDate
 *
 */
public class GetCaptureUsersCommand
extends AbstractViewerImagingCommands<List<CaptureUserResult>, CaptureUserResultsType>
{
	private final static Logger logger = Logger.getLogger(GetCaptureUsersCommand.class);

	private String appFlag;
	private String fromDate;
	private String throughDate;
	private String interfaceVersion;

	public GetCaptureUsersCommand(
			String appFlag,
			String fromDate,
			String throughDate,
			String interfaceVersion)
	{
		super("GetCaptureUsersCommand");
		this.appFlag = appFlag;
		this.fromDate = fromDate;
		this.throughDate = throughDate;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<CaptureUserResult> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
            logger.info("GetCaptureUsersCommand parameters: {}", getMethodParameterValuesString());
			
			RoutingToken routingToken = createLocalRoutingToken();

			return getRouter().getCaptureUsers(
					routingToken, 
					getAppFlag(),
					getFromDate(),
					getThroughDate());

		}
		catch(Exception e)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(e);
		}
	}

	/**
	 * @return the appFlag
	 */
	public String getAppFlag()
	{
		return this.appFlag;
	}
	
	/**
	 * @return the fromDate
	 */
	public String getFromDate()
	{
		return this.fromDate;
	}

	/**
	 * @return the throughDate
	 */
	public String getThroughDate()
	{
		return this.throughDate;
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
		return "Application Flag [" + getAppFlag() + "] " +
				"From Date [" + this.getFromDate() + "] " +
				"Through Date [" + this.getThroughDate() + "] ";
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
	public Integer getEntriesReturned(CaptureUserResultsType res) 
	{
		return res.getCaptureUsers().length; 
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected CaptureUserResultsType translateRouterResult(
			List<CaptureUserResult> routerResult)
	throws TranslationException, MethodException 
	{
		return ViewerImagingRestTranslator.translateCaptureUserResults(routerResult);
	}

	@Override
	protected Class<CaptureUserResultsType> getResultClass() {
		return CaptureUserResultsType.class;
	}

}



