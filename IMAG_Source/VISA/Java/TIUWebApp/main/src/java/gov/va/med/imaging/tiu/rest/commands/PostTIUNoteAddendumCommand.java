/**
 * 
 * 
 * Date Created: Feb 14, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.commands;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.rest.translator.TIURestTranslator;
import gov.va.med.imaging.tiu.rest.types.TIUNoteAddendumInputType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author Julian Werfel
 *
 */
public class PostTIUNoteAddendumCommand
extends AbstractTIUCommand<PatientTIUNoteURN, RestStringType>
{
	private final String noteUrnString;
	private final TIUNoteAddendumInputType addendumInput;
	private final String interfaceVersion;
	
	public PostTIUNoteAddendumCommand(String noteUrnString, TIUNoteAddendumInputType addendumInput, String interfaceVersion)
	{
		super("createNoteAddendum");
		this.noteUrnString = noteUrnString;
		this.addendumInput = addendumInput;
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
	 * @return the addendumInput
	 */
	public TIUNoteAddendumInputType getAddendumInput()
	{
		return addendumInput;
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
	protected PatientTIUNoteURN executeRouterCommand()
	throws MethodException, ConnectionException
	{
		try {
			PatientTIUNoteURN noteUrn = TIURestTranslator.parsePatientTIUNoteUrn(getNoteUrnString());
			getTransactionContext().setPatientID(noteUrn.getThePatientIdentifier().toString());
			Date date = TIURestTranslator.parseDate(getAddendumInput().getDate());
			String addendumText = getAddendumInput().getAddendumText();
			if (addendumText == null)
				addendumText = "";
			return getRouter().createTIUNoteAddendum(noteUrn, date, addendumText);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error creating tiu note addendum via router", e);
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
	protected RestStringType translateRouterResult(
		PatientTIUNoteURN routerResult)
	throws TranslationException, MethodException
	{
		return new RestStringType(routerResult.toString());
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
