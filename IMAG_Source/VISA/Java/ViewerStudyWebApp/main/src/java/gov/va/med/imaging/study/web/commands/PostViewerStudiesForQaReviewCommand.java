/**
 * 
 * Date Created: May 14, 2018
 * Developer: Budy Tjahjo
 */
package gov.va.med.imaging.study.web.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.study.web.ViewerStudyFacadeRouter;
import gov.va.med.imaging.study.web.rest.translator.ViewerStudyWebTranslator;
import gov.va.med.imaging.study.web.rest.types.ViewerQAStudyFilterType;
import gov.va.med.imaging.study.web.rest.types.ViewerStudyStudiesType;
import gov.va.med.imaging.tomcat.vistarealm.StringUtils;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author vhaisltjahjb
 *
 */
public class PostViewerStudiesForQaReviewCommand
extends AbstractViewerStudyWebCommand<List<Study>, ViewerStudyStudiesType>
{
	private final String siteId;
	private final ViewerQAStudyFilterType filterType;

	/**
	 * @param siteId
	 * @param filterType
	 */
	
	public PostViewerStudiesForQaReviewCommand(String siteId,
		ViewerQAStudyFilterType filterType)
	{
		super("postViewerStudiesForQaReview");
		this.siteId = siteId;
		this.filterType = filterType;
	}	
	

	/**
	 * @return the filterType
	 */
	public ViewerQAStudyFilterType getFilterType()
	{
		return filterType;
	}

	/**
	 * @return the siteId
	 */
	public String getSiteId()
	{
		return siteId;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<Study> executeRouterCommand()
		throws MethodException, ConnectionException
	{
		getLogger().debug("Called via PostViewerStudiesForQaReviewCommand.");
		ViewerStudyFacadeRouter router = getRouter();
		try
		{
			StudyFilter filter = ViewerStudyWebTranslator.translate(getFilterType());
			filter.setIncludeAllObjects(true);
			filter.setIncludePatientOrders(true);
			filter.setIncludeEncounterOrders(true);
			filter.setIncludeMuseOrders(true);
			
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			getLogger().debug("call postViewerStudiesForQaReview command.");
			List<Study> result = router.postViewerStudiesForQaReview(routingToken, filter);
			return result;

		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for site [" + getSiteId() + "]";
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected ViewerStudyStudiesType translateRouterResult(List<Study> routerResult)
		throws TranslationException, MethodException
	{
		getLogger().debug("hitting PostViewerStudiesForQaReviewCommand.translateRouterResult method.");
		getLogger().debug("attempting to hit ViewerStudyWebTranslator.translateStudies method.");
		return ViewerStudyWebTranslator.translateStudies(routerResult);
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<ViewerStudyStudiesType> getResultClass()
	{
		return ViewerStudyStudiesType.class;
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 */
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, "");
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
	
		return transactionContextFields;
	}
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(ViewerStudyStudiesType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getStudy().length;
	}
	
	

}
