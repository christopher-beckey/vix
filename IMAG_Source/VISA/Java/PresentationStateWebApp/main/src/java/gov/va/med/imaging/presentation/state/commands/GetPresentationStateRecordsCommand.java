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
import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordType;
import gov.va.med.imaging.presentation.state.rest.types.PresentationStateRecordsType;

/**
 * @author William Peterson
 *
 */
public class GetPresentationStateRecordsCommand 
extends AbstractPresentationStateCommand<List<PresentationStateRecord>, PresentationStateRecordsType> {

	private final String siteId;
	private final String interfaceVersion;
	private final PresentationStateRecordType pStateRecordType;
	
	public GetPresentationStateRecordsCommand(String siteId, String interfaceVersion, PresentationStateRecordType pStateRecordType) {
		super("GetPresentationStateRecord");
		this.siteId = siteId;
		this.interfaceVersion = interfaceVersion;
		this.pStateRecordType = pStateRecordType;
	}

	@Override
	protected List<PresentationStateRecord> executeRouterCommand()
			throws MethodException, ConnectionException {
		RoutingToken routingToken;
		try {
			routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			PresentationStateRecord pStateRecord = PresentationStateRestTranslator.translatePSRecordType(getpStateRecordType());
			return getRouter().getPresentationStateRecords(routingToken, pStateRecord);
		} catch (RoutingTokenFormatException rtfX) {
			throw new MethodException(rtfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString() {
		return "get Presentation State Records [" + getpStateRecordType().getPStateStudyUID() + ";" + getpStateRecordType().getPStateUID() + "]";
	}

	@Override
	protected PresentationStateRecordsType translateRouterResult(
			List<PresentationStateRecord> routerResult) throws TranslationException,
			MethodException {
				
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

	public PresentationStateRecordType getpStateRecordType() {
		return pStateRecordType;
	}

}
