/**
 * 
 * 
 * Date Created: Feb 10, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.rest.translator.TIURestTranslator;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUElectronicallyFileNoteCommand
extends AbstractTIUCommand<Boolean, RestBooleanReturnType>
{
	private final String tiuNoteUrnString;
	private final String interfaceVersion;

	/**
	 * @param methodName
	 */
	public GetTIUElectronicallyFileNoteCommand(String tiuNoteUrnString,
		String interfaceVersion)
	{
		super("electronicallyFileNote");
		this.tiuNoteUrnString = tiuNoteUrnString;
		this.interfaceVersion = interfaceVersion;
	}

	/**
	 * @return the tiuNoteUrnString
	 */
	public String getTiuNoteUrnString()
	{
		return tiuNoteUrnString;
	}

	/**
	 * @return the interfaceVersion
	 */
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected Boolean executeRouterCommand()
	throws MethodException, ConnectionException
	{
		try {
			PatientTIUNoteURN noteUrn = TIURestTranslator.parsePatientTIUNoteUrn(getTiuNoteUrnString());
			getTransactionContext().setPatientID(noteUrn.getThePatientIdentifier().toString());
			return getRouter().electronicallyFileNote(noteUrn);
		} catch (MethodException | ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error electronically filing tiu note via router", e);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for note [" + getTiuNoteUrnString() + "]";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult)
	throws TranslationException, MethodException
	{
		return new RestBooleanReturnType(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<RestBooleanReturnType> getResultClass()
	{
		return RestBooleanReturnType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult)
	{
		return null;
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getTiuNoteUrnString());
	
		return transactionContextFields;
	}
}