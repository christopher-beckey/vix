/**
 * 
 * 
 * Date Created: Jan 7, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.tiu.rest.commands;

import gov.va.med.RoutingToken;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.rest.translator.TIURestTranslator;

/**
 * @author vhaisltjahjb
 *
 */
public class GetTIUNoteIsValidCommand
extends AbstractTIUCommand<Boolean, RestBooleanReturnType>
{
	private final String siteId;
	private final String tiuNoteUrnString;
	private final String patientTiuNoteUrnString;
	private final String typeIndex;
	private final String interfaceVersion;
	/**
	 * @param siteId
	 * @param tiuNoteUrnString
	 * @param patientTiuNoteUrnString
	 * @param interfaceVersion
	 */
	public GetTIUNoteIsValidCommand(String siteId, String tiuNoteUrnString, String patientTiuNoteUrnString, String typeIndex, String interfaceVersion)
	{
		super("isNoteValid");
		this.siteId = siteId;
		this.tiuNoteUrnString = tiuNoteUrnString;
		this.patientTiuNoteUrnString = patientTiuNoteUrnString;
		this.typeIndex = typeIndex;
		this.interfaceVersion = interfaceVersion;
	}
	
	/**
	 * @return the siteId
	 */
	public String getSiteId()
	{
		return siteId;
	}

	/**
	 * @return the tiuNoteUrnString
	 */
	public String getTiuNoteUrnString()
	{
		return tiuNoteUrnString;
	}

	/**
	 * @return the patientTiuNoteUrnString
	 */
	public String getPatientTiuNoteUrnString()
	{
		return patientTiuNoteUrnString;
	}
	
	/**
	 * @return the typeIndex
	 */
	public String getTypeIndex()
	{
		return typeIndex;
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
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			TIUItemURN noteUrn = null;
			PatientTIUNoteURN patientNoteUrn = null;
			
			if (getTiuNoteUrnString() != null)
				noteUrn = URNFactory.create(getTiuNoteUrnString(), TIUItemURN.class);
			
			if (getPatientTiuNoteUrnString() != null)
				patientNoteUrn = TIURestTranslator.parsePatientTIUNoteUrn(getPatientTiuNoteUrnString());
			
			return getRouter().isTiuNoteValid(routingToken, noteUrn, patientNoteUrn, getTypeIndex());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error checking if tiu note is valid via router", e);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for tiu note def [" + getTiuNoteUrnString() + "] and note [" + getPatientTiuNoteUrnString() + "] in site [" + getSiteId() + "]";
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
	

}
