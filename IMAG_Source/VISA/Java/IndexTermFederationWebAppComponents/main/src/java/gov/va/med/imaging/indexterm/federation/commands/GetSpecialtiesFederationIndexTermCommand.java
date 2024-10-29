/**
 * 
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.federation.commands;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.enums.IndexClass;
import gov.va.med.imaging.indexterm.federation.translator.IndexTermFederationRestTranslator;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexClassAndURNType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexClassArrayType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexTermValueArrayType;
import gov.va.med.imaging.rest.types.RestStringArrayType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author Julian Werfel
 *
 */
public class GetSpecialtiesFederationIndexTermCommand
extends AbstractFederationIndexTermCommand<List<IndexTermValue>,FederationIndexTermValueArrayType>
{

	private final String routingTokenString;
	private final String interfaceVersion;
	private final FederationIndexClassAndURNType classAndURNType;
	
	public GetSpecialtiesFederationIndexTermCommand(String routingTokenString, 
			FederationIndexClassAndURNType indexTermClassAndURNType, String interfaceVersion)
	{
		super("getProcedureEvents");
		this.routingTokenString = routingTokenString;
		this.classAndURNType = indexTermClassAndURNType;
		this.interfaceVersion = interfaceVersion;
	}
	
	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}
	
	public FederationIndexClassAndURNType getFederationIndexClassAndURNType(){
		return this.classAndURNType;
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<IndexTermValue> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			List<IndexClass> indexClasses = new ArrayList<IndexClass>();
			List<IndexTermURN> specialtyURNs = new ArrayList<IndexTermURN>();
			FederationIndexClassAndURNType requestBodyType = getFederationIndexClassAndURNType();
			
			if(requestBodyType != null){
				if(requestBodyType.getFederationIndexClasses() != null && requestBodyType.getFederationIndexClasses().getValues().length > 0){
					FederationIndexClassArrayType indexClassesType = requestBodyType.getFederationIndexClasses();
					indexClasses = IndexTermFederationRestTranslator.translateIndexTermClasses(indexClassesType);
				}
				if(requestBodyType.getFederationIndexTermURNs() != null && requestBodyType.getFederationIndexTermURNs().getValue().length > 0){
					RestStringArrayType stringsType = requestBodyType.getFederationIndexTermURNs();
					specialtyURNs = IndexTermFederationRestTranslator.translateIndexTermURNs(stringsType);
				}
			}
			return getRouter().getSpecialties(routingToken, indexClasses, specialtyURNs);
			
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
		return "acquisition sites from " + getRoutingTokenString();
	}

	@Override
	protected FederationIndexTermValueArrayType translateRouterResult(List<IndexTermValue> routerResult) throws TranslationException, MethodException {
		return IndexTermFederationRestTranslator.translateIndexTermValuesType(routerResult);
	}

	@Override
	protected Class<FederationIndexTermValueArrayType> getResultClass() {
		return FederationIndexTermValueArrayType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
				new HashMap<WebserviceInputParameterTransactionContextField, String>();
			
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		
		return transactionContextFields;
	}

	@Override
	public Integer getEntriesReturned(FederationIndexTermValueArrayType translatedResult) {
		return translatedResult == null ? 0 : translatedResult.getValues().length;
	}

	@Override
	public void setAdditionalTransactionContextFields() {
		// TODO Auto-generated method stub
		
	}
}
