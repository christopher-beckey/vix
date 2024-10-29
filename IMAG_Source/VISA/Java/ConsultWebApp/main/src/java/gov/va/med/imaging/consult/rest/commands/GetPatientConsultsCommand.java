/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult.rest.commands;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.consult.rest.translator.ConsultRestTranslator;
import gov.va.med.imaging.consult.rest.types.ConsultsType;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author Julian Werfel
 *
 */
public class GetPatientConsultsCommand
extends AbstractConsultCommand<List<Consult>, ConsultsType>
{
	private final String patientId;
	private final String interfaceVersion;
	private final String siteId;

	/**
	 * @param methodName
	 */
	public GetPatientConsultsCommand(String siteId, String patientId, String interfaceVersion)
	{
		super("getPatientConsults");
		this.siteId = siteId;
		this.patientId = patientId;
		this.interfaceVersion = interfaceVersion;
	}

	/**
	 * @return the patientId
	 */
	public String getPatientId()
	{
		return patientId;
	}

	/**
	 * @return the interfaceVersion
	 */
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	public String getSiteId() {
		return siteId;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<Consult> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		List<Consult> consultList = null;
		SiteConnection siteConnection = null;
		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());

			PatientIdentifier patientIdentifier = PatientIdentifier.fromString(getPatientId());
			siteConnection = getLocalSiteConnection();

			consultList =  getRouter().getPatientConsults(routingToken, patientIdentifier);
		}
		catch(PatientIdentifierParseException pipX)
		{
			throw new MethodException(pipX);
		} catch (RoutingTokenFormatException rtfX) 
		{
			throw new MethodException(rtfX);
		}
		
		
		StringBuffer buf = new StringBuffer();
		buf.append("http://");
		buf.append(siteConnection.getServer());
		buf.append(":");
		buf.append(siteConnection.getPort());
		buf.append("/IngestWebApp");			
		buf.append("/token/ingest");

		for(Consult consult : consultList)			
			consult.setSiteVixUrl(buf.toString());
		
		
		return consultList;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient [" + getPatientId() + "]";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected ConsultsType translateRouterResult(List<Consult> routerResult)
	throws TranslationException, MethodException
	{
		return ConsultRestTranslator.translateConsults(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<ConsultsType> getResultClass()
	{
		return ConsultsType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 */
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientId());
	
		return transactionContextFields;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(ConsultsType translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.getConsult().length;
	}
	
	protected SiteServiceFacadeRouter getSiteServiceRouter(){
		return SiteServiceContext.getSiteServiceFacadeRouter();
	}

	protected SiteConnection getLocalSiteConnection() throws MethodException, ConnectionException{
		Site site = getSiteServiceRouter().getSite(getSiteId());
		SiteConnection siteConnection = site.getSiteConnections().get(SiteConnection.siteConnectionVix);
		return siteConnection;
	}


}
