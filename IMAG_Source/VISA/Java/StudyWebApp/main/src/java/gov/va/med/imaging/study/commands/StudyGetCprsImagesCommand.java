package gov.va.med.imaging.study.commands;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.study.StudyFacadeRouter;
import gov.va.med.imaging.study.rest.translator.RestStudyTranslator;
import gov.va.med.imaging.study.rest.types.StudiesType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class StudyGetCprsImagesCommand
extends AbstractStudyCommand<List<Study>, StudiesType>
{

	private final String siteId;
	private final String patientIcn;
	private final String cprsIdentifier;
	
	public StudyGetCprsImagesCommand(String siteId, String patientIcn, String cprsIdentifier)
	{
		super("getCprsImagesCommand");
		this.siteId = siteId;
		this.patientIcn = patientIcn;
		this.cprsIdentifier = cprsIdentifier;
	}

	public String getSiteId() {
		return siteId;
	}

	public String getPatientIcn() {
		return patientIcn;
	}

	public String getCprsIdentifier() {
		return cprsIdentifier;
	}

	@Override
	protected boolean isRequiresEnterprise() {
		return false;
	}

	@Override
	protected boolean isRequiresLocal() {
		return false;
	}

	@Override
	protected List<Study> executeRouterCommand() 
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
		CprsIdentifier cprsIdentifier = new CprsIdentifier(getCprsIdentifier());
		
		StudyFacadeRouter router = getRouter();
		return router.getStudiesByCprsIdentifier(getPatientIcn(), routingToken, cprsIdentifier);
	}

	@Override
	protected String getMethodParameterValuesString() {
		return "from site '" + getSiteId() + "', for patient '" + getPatientIcn() + ", Identifier '" + getCprsIdentifier() + "'";
	}

	@Override
	protected StudiesType translateRouterResult(List<Study> routerResult) 
	throws TranslationException, MethodException 
	{
		return RestStudyTranslator.translateStudies(routerResult);
	}

	@Override
	protected Class<StudiesType> getResultClass() {
		return StudiesType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() 
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
				new HashMap<WebserviceInputParameterTransactionContextField, String>();
			
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIcn());

			return transactionContextFields;
	}

	@Override
	public Integer getEntriesReturned(StudiesType translatedResult) {
		return translatedResult == null ? 0 : translatedResult.getStudies().length;
	}
	
	
}
