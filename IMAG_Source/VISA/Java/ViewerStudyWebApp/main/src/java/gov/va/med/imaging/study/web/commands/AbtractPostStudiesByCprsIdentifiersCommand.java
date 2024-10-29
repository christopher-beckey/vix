package gov.va.med.imaging.study.web.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.study.web.ViewerStudyFacadeRouter;
import gov.va.med.imaging.study.web.rest.translator.ViewerStudyWebTranslator;
import gov.va.med.imaging.study.web.rest.types.CprsIdentifiersType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Budy Tjahjo
 *
 */
public abstract class AbtractPostStudiesByCprsIdentifiersCommand<E extends Object>
extends AbstractViewerStudyWebCommand<List<Study>, E>
{
	private final String siteId;
	private final String patientIcn;
	private final CprsIdentifiersType cprsIdentifiers;
	
	public AbtractPostStudiesByCprsIdentifiersCommand(
			String siteId, 
			String patientIcn,
			CprsIdentifiersType cprsIdentifiers)
	{
		super("postStudiesByCprsIdentifiers");
		this.siteId = siteId;
		this.patientIcn = patientIcn;
		this.cprsIdentifiers = cprsIdentifiers;
	}

	/**
	 * @return the siteId
	 */
	public String getSiteId()
	{
		return siteId;
	}

	/**
	 * @return the patientIdentifier
	 */
	public String getPatientIdentifier()
	{
		return patientIcn;
	}

	/**
	 * @return the cprsIdentifiers
	 */
	public List<CprsIdentifier> getCprsIdentifiers()
	{
		return ViewerStudyWebTranslator.translateCprsIdentifiers(cprsIdentifiers);
	}
	
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<Study> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		getLogger().debug("Called via PostStudiesByCprsIdentifiersCommand.");
		ViewerStudyFacadeRouter router = getRouter();
		try
		{
			StudyFilter filter = new StudyFilter();
			filter.setIncludeAllObjects(true);
			filter.setIncludeImages(false);
			
			for(CprsIdentifier cprsIdentifier: getCprsIdentifiers()){
				if(cprsIdentifier.getCprsIdentifier().startsWith("urn:musestudy")){
					filter.setIncludeMuseOrders(true);
					break;
				}
			}
			PatientIdentifier patientIdentifier = new PatientIdentifier(getPatientIdentifier(), PatientIdentifierType.icn);
			List<Study> studies =  router.postStudiesByCprsIdentifiers(
					patientIdentifier, 
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId()), 
					filter,
					getCprsIdentifiers());

            getLogger().debug("Number of studies: {}", studies.size());
			getLogger().debug(studies.toString());
			return studies;
		}
		catch (RoutingTokenFormatException rtfX)
		{
			throw new MethodException("RoutingTokenFormatException, unable to get studies by CPRS identifier", rtfX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient [" + getPatientIdentifier() + "] to site [" + getSiteId() + "]";
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIdentifier());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
	
		return transactionContextFields;
	}
}
