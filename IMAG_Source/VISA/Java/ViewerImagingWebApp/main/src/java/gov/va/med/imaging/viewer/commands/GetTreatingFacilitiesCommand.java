package gov.va.med.imaging.viewer.commands;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.PatientNotFoundException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.viewer.business.TreatingFacilityResult;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceService;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.TreatingFacilityResultsType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaisltjahjb
 * @param List<TreatingFacilityResult>
 * @param TreatingFacilityResultsType
 *
 */
public class GetTreatingFacilitiesCommand
extends AbstractViewerImagingCommands<List<TreatingFacilityResult>, TreatingFacilityResultsType>
{
	private final static Logger logger = Logger.getLogger(ViewerImagingDataSourceService.class);
	private final static String CVIX_SITE_NUMBER = "2001";

	private String siteNumber;
	private String patientIcn;
	private String patientDfn;
	private String interfaceVersion;

	public GetTreatingFacilitiesCommand(
			String siteNumber,
			String patientIcn,
			String patientDfn,
			String interfaceVersion)
	{
		super("GetTreatingFacilitiesCommand");
		this.siteNumber = siteNumber;
		this.patientIcn = patientIcn;
		this.patientDfn = patientDfn;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<TreatingFacilityResult> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
            logger.info("GetTreatingFacilitiesCommand for patient '{}", getPatientIdentifier());

			RoutingToken routingToken = null;

			if ((getSiteNumber() == null) || getSiteNumber().isEmpty())
			{
				routingToken = createLocalRoutingToken();
			}
			else
			{
				routingToken = 
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteNumber());
			}
			
			if(ExchangeUtil.isSiteDOD(routingToken.getRepositoryUniqueId())
				|| routingToken.getRepositoryUniqueId().startsWith(CVIX_SITE_NUMBER))
			{
				return getRouter().getCvixTreatingFacilities(
						routingToken, 
						getPatientIcn(),
						getPatientDfn());
			}
			else
			{
				return getRouter().getTreatingFacilities(
						routingToken, 
						getPatientIcn(),
						getPatientDfn());
			}

		}
		catch(PatientNotFoundException pnfX)
		{
            logger.warn("Patient '{}' not found, indicates patient returning empty result set.", getPatientIdentifier());
			return null;		
		}
		catch(Exception e)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(e);
		}
	}

	private PatientIdentifier getPatientIdentifier() {
		PatientIdentifier patientIdentifier = null;
		if ((getPatientIcn() != null) && (!getPatientIcn().isEmpty()))
		{
			patientIdentifier = 
					PatientIdentifier.icnPatientIdentifier(getPatientIcn());
		}
		else if ((getPatientDfn() != null) && (!getPatientDfn().isEmpty()))
		{
			patientIdentifier = 
					PatientIdentifier.dfnPatientIdentifier(getPatientDfn(), this.siteNumber);
		}
		return patientIdentifier;
	}

	/**
	 * @return the siteNumber
	 */
	public String getSiteNumber()
	{
		return this.siteNumber;
	}
	
	/**
	 * @return the patientDfn
	 */
	public String getPatientDfn()
	{
		return this.patientDfn;
	}

	/**
	 * @return the patientIcn
	 */
	public String getPatientIcn()
	{
		return this.patientIcn;
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
		return "from site [" + getSiteNumber() + "] " +
				"icn [" + this.getPatientIcn() + "] " +
				"dfn [" + this.getPatientDfn() + "] ";
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
	public Integer getEntriesReturned(TreatingFacilityResultsType res) 
	{
		return res.getTreatingFacilities().length; 
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected TreatingFacilityResultsType translateRouterResult(
			List<TreatingFacilityResult> routerResult)
	throws TranslationException, MethodException 
	{
		return ViewerImagingRestTranslator.translateTreatingFacilityResults(routerResult);
	}

	@Override
	protected Class<TreatingFacilityResultsType> getResultClass() {
		return TreatingFacilityResultsType.class;
	}


}



