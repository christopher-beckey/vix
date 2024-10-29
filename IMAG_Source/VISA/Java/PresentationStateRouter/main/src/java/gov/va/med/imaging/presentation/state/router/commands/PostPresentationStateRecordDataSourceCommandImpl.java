package gov.va.med.imaging.presentation.state.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.presentation.state.datasource.PresentationStateDataSourceSpi;

/**
 * @author William Peterson
 * 
 * Create new Presentation State Record into Data Source.
 *
 */

public class PostPresentationStateRecordDataSourceCommandImpl 
extends AbstractPresentationStateDataSourceCommandImpl<Boolean> {

	private static final long serialVersionUID = 8846611641416765226L;
	private final PresentationStateRecord pStateRecord;

	public PostPresentationStateRecordDataSourceCommandImpl(
			RoutingToken routingToken, PresentationStateRecord pStateRecord) {
		super(routingToken);
		this.pStateRecord = pStateRecord;
	}

	@Override
	protected String getSpiMethodName() {
		return "postPSRecord";
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[] {RoutingToken.class, PresentationStateRecord.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[] {getRoutingToken(), getPStateRecord()};
	}

	@Override
	protected Boolean getCommandResult(PresentationStateDataSourceSpi spi)
			throws ConnectionException, MethodException {
		return spi.postPSRecord(getRoutingToken(), getPStateRecord());
	}

	public PresentationStateRecord getPStateRecord() {
		return pStateRecord;
	}

}
