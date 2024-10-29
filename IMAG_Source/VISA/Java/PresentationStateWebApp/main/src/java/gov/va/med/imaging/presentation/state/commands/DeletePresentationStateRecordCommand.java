/**
 * 
 */
package gov.va.med.imaging.presentation.state.commands;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.presentation.state.rest.translator.PresentationStateRestTranslator;
import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordType;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;

/**
 * @author William Peterson
 *
 */
public class DeletePresentationStateRecordCommand 
extends AbstractPresentationStateCommand<Boolean, RestBooleanReturnType> {

	private final String siteId;
	private final String interfaceVersion;
	private final PresentationStateRecordType pStateRecordType;
	
	public DeletePresentationStateRecordCommand(String siteId, String interfaceVersion, PresentationStateRecordType pStateRecordType) {
		super("deletePresentationStateRecord");
		this.siteId = siteId;
		this.interfaceVersion = interfaceVersion;
		this.pStateRecordType = pStateRecordType;
	}

	@Override
	protected Boolean executeRouterCommand() throws MethodException,
			ConnectionException {
		
		RoutingToken routingToken;
		try {
			routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			PresentationStateRecord psRecord = PresentationStateRestTranslator.translatePSRecordType(getPStateRecordType());
			return getRouter().deletePresentationStateRecord(routingToken, psRecord);
		} catch (RoutingTokenFormatException rtfX) {
			throw new MethodException(rtfX);
		}

	}

	@Override
	protected String getMethodParameterValuesString() {
		return "deleting Presentation State Record [" + getPStateRecordType().getPStateUID() + "]";

	}

	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult)
			throws TranslationException, MethodException {
		return new RestBooleanReturnType(routerResult);
	}

	@Override
	protected Class<RestBooleanReturnType> getResultClass() {
		return RestBooleanReturnType.class;
	}

	@Override
	public String getInterfaceVersion() {
		
		return interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult) {
		
		return null;
	}

	public String getSiteId() {
		return siteId;
	}

	public PresentationStateRecordType getPStateRecordType() {
		return pStateRecordType;
	}

}
