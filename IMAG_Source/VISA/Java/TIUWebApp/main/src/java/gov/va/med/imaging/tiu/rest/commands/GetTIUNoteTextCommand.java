/**
 * 
 * 
 * Date Created: Feb 13, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.rest.translator.TIURestTranslator;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUNoteTextCommand
extends AbstractTIUCommand<String, RestStringType>
{
	private final String noteUrnString;
	private final String interfaceVersion;
	
	public GetTIUNoteTextCommand(String noteUrnString, String interfaceVersion)
	{
		super("getNoteText");
		this.noteUrnString = noteUrnString;
		this.interfaceVersion = interfaceVersion;
	}

	/**
	 * @return the noteUrnString
	 */
	public String getNoteUrnString()
	{
		return noteUrnString;
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
	protected String executeRouterCommand()
	throws MethodException, ConnectionException
	{
		try {
			PatientTIUNoteURN noteUrn = TIURestTranslator.parsePatientTIUNoteUrn(getNoteUrnString());
			getTransactionContext().setPatientID(noteUrn.getThePatientIdentifier().toString());
			String result = getRouter().getTIUNoteText(noteUrn);
			getTransactionContext().setFacadeBytesSent(result == null ? 0 : new Long(result.length()));
			return result;
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting tiu note text via router", e);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for note (" + getNoteUrnString() + ")";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected RestStringType translateRouterResult(String routerResult)
	throws TranslationException, MethodException
	{
		return new RestStringType(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<RestStringType> getResultClass()
	{
		return RestStringType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(RestStringType translatedResult)
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getNoteUrnString());
	
		return transactionContextFields;
	}

}
