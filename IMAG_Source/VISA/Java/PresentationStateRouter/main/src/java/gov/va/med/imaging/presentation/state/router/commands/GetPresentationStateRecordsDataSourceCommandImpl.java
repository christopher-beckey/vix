/**
 * 
 */
package gov.va.med.imaging.presentation.state.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.presentation.state.datasource.PresentationStateDataSourceSpi;

import java.util.List;

/**
 * @author William Peterson
 * 
 * Get Presentation State Records from Data Source.
 *
 */
public class GetPresentationStateRecordsDataSourceCommandImpl 
extends AbstractPresentationStateDataSourceCommandImpl<List<PresentationStateRecord>> {

	private static final long serialVersionUID = 1988149031268178750L;
	private final PresentationStateRecord pStateRecord;

	public GetPresentationStateRecordsDataSourceCommandImpl(
			RoutingToken routingToken, PresentationStateRecord pStateRecord) {
		super(routingToken);
		this.pStateRecord = pStateRecord;
	}

	@Override
	protected String getSpiMethodName() {
		return "getPSRecords";
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
	protected List<PresentationStateRecord> getCommandResult(
			PresentationStateDataSourceSpi spi) throws ConnectionException,
			MethodException {
		return spi.getPSRecords(getRoutingToken(), getPStateRecord());
	}

	public PresentationStateRecord getPStateRecord() {
		return pStateRecord;
	}


}
