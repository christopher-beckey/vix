package gov.va.med.imaging.study.commands;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.StoredStudyFilter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.study.StudyFacadeRouter;
import gov.va.med.imaging.study.rest.translator.RestStudyTranslator;
import gov.va.med.imaging.study.rest.types.StoredFiltersType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class GetStoredFiltersCommand
extends AbstractStudyCommand<List<StoredStudyFilter>, StoredFiltersType>
{

	private final String siteId;
	
	public GetStoredFiltersCommand(String siteId)
	{
		super("getStoredFilters");
		this.siteId = siteId;
	}
	
	public String getSiteId() {
		return siteId;
	}

	@Override
	protected boolean isRequiresEnterprise() {
		return false;
	}

	@Override
	protected boolean isRequiresLocal() {
		return true;
	}

	@Override
	protected List<StoredStudyFilter> executeRouterCommand() 
	throws MethodException, ConnectionException 
	{

		RoutingToken routingToken = null;
		if(getSiteId() == null || getSiteId().length() <= 0)
		{
			routingToken = getLocalRoutingToken();
		}
		else
		{
			try
			{
				routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			}
			catch (RoutingTokenFormatException rtfX)
			{
				throw new MethodException(rtfX);
			}
		}
		
		StudyFacadeRouter router = getRouter();
		return router.getStoredFilters(routingToken);
	}

	@Override
	protected String getMethodParameterValuesString() {
		return "from site '" + getSiteId() + "'";
	}

	@Override
	protected StoredFiltersType translateRouterResult(List<StoredStudyFilter> routerResult)
	throws TranslationException, MethodException 
	{
		return RestStudyTranslator.translateStoredFilters(routerResult);
	}

	@Override
	protected Class<StoredFiltersType> getResultClass() {
		return StoredFiltersType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
				new HashMap<WebserviceInputParameterTransactionContextField, String>();
			
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

			return transactionContextFields;
	}

	@Override
	public Integer getEntriesReturned(StoredFiltersType translatedResult) {
		return translatedResult == null ? 0 : translatedResult.getStoredFilters().length;
	}

}
