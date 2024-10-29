package gov.va.med.imaging.presentation.state.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestCoreTranslator;
import gov.va.med.imaging.rest.types.RestStringArrayType;

/**
 * @author Budy Tjahjo
 *
 */
public class GetPresentationStateAnnotationsCommand 
extends AbstractPresentationStateCommand<List<String>, RestStringArrayType> {

	private final String siteId;
	private final String interfaceVersion;
	private final String studyContext;
	
	public GetPresentationStateAnnotationsCommand(String siteId, String interfaceVersion, String studyContext) {
		super("GetPresentationStateAnnotationsCommand");
		this.siteId = siteId;
		this.interfaceVersion = interfaceVersion;
		this.studyContext = studyContext;
	}

	@Override
	protected List<String> executeRouterCommand()
			throws MethodException, ConnectionException {
		RoutingToken routingToken;
		try {
			routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			return getRouter().getStudyPresentationStateDetails(routingToken, studyContext);
		} catch (RoutingTokenFormatException rtfX) {
			throw new MethodException(rtfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString() {
		return "get Presentation State Details for " + studyContext;
	}

	@Override
	protected RestStringArrayType translateRouterResult(
			List<String> routerResult)
			throws TranslationException, MethodException {
		
		return RestCoreTranslator.translateStrings(routerResult);
	}

	@Override
	protected Class<RestStringArrayType> getResultClass() {
		
		return RestStringArrayType.class;
	}

	@Override
	public String getInterfaceVersion() {
	
		return interfaceVersion;
	}

	public String getSiteId() {
		return siteId;
	}

	@Override
	public Integer getEntriesReturned(RestStringArrayType translatedResult) {
		return 1;
	}

}
