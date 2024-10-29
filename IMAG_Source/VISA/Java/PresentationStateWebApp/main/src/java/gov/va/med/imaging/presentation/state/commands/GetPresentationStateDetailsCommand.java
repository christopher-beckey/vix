/**
 * 
 */
package gov.va.med.imaging.presentation.state.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.presentation.state.rest.translator.PresentationStateRestTranslator;
import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordsType;

/**
 * @author William Peterson
 *
 */
public class GetPresentationStateDetailsCommand 
extends AbstractPresentationStateCommand<List<PresentationStateRecord>, PresentationStateRecordsType> {

	private final String siteId;
	private final String interfaceVersion;
	private final PresentationStateRecordsType pStateRecords;
	
	public GetPresentationStateDetailsCommand(String siteId, String interfaceVersion, PresentationStateRecordsType psRecords) {
		super("GetPresentationStateDetails");
		this.siteId = siteId;
		this.interfaceVersion = interfaceVersion;
		this.pStateRecords = psRecords;
	}

	@Override
	protected List<PresentationStateRecord> executeRouterCommand()
			throws MethodException, ConnectionException {
		RoutingToken routingToken;
		try {
			List<PresentationStateRecord> psRecordList = PresentationStateRestTranslator.translatePSRecordsType(getPStateRecords());
			routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			return getRouter().getPresentationStateDetails(routingToken, psRecordList);
		} catch (RoutingTokenFormatException rtfX) {
			throw new MethodException(rtfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString() {
		return "get Presentation State Details for " + getPStateRecords().getPStateRecords().length + " records";
	}

	@Override
	protected PresentationStateRecordsType translateRouterResult(
			List<PresentationStateRecord> routerResult)
			throws TranslationException, MethodException {
		
		return PresentationStateRestTranslator.translatePSRecords(routerResult);
	}

	@Override
	protected Class<PresentationStateRecordsType> getResultClass() {
		
		return PresentationStateRecordsType.class;
	}

	@Override
	public String getInterfaceVersion() {
	
		return interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(PresentationStateRecordsType translatedResult) {
	
		return translatedResult == null ? 0 : translatedResult.getPStateRecords().length;
	}

	public String getSiteId() {
		return siteId;
	}

	public PresentationStateRecordsType getPStateRecords() {
		return pStateRecords;
	}

}
