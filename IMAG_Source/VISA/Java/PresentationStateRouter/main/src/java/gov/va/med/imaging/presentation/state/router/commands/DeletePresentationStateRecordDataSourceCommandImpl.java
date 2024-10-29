/**
 * 
 */
package gov.va.med.imaging.presentation.state.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.presentation.state.datasource.PresentationStateDataSourceSpi;

/**
 * @author William Peterson
 * 
 * Delete Presentation State Record from Data Source.
 *
 */
public class DeletePresentationStateRecordDataSourceCommandImpl 
extends AbstractPresentationStateDataSourceCommandImpl<Boolean> {

	private static final long serialVersionUID = 1364507095920189181L;
	private final PresentationStateRecord pStateRecord;
	
	public DeletePresentationStateRecordDataSourceCommandImpl(
			RoutingToken routingToken, PresentationStateRecord pStateRecord) {
		super(routingToken);
		this.pStateRecord = pStateRecord;
	}

	@Override
	protected String getSpiMethodName() {
		return "deletePSRecord";
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
		return spi.deletePSRecord(getRoutingToken(), getPStateRecord());
	}

	public PresentationStateRecord getPStateRecord() {
		return pStateRecord;
	}

}
