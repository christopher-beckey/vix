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
 * Create new Presentation State Detail into Data Source.
 *
 */
public class PostPresentationStateDetailDataSourceCommandImpl 
extends AbstractPresentationStateDataSourceCommandImpl<Boolean> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3485008139028405113L;
	private final PresentationStateRecord pStateRecord;
	
	
	public PostPresentationStateDetailDataSourceCommandImpl(
			RoutingToken routingToken, PresentationStateRecord pStateRecord) {
		super(routingToken);
		this.pStateRecord = pStateRecord;
	}

	@Override
	protected String getSpiMethodName() {
		return "postPSDetail";
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
		return spi.postPSDetail(getRoutingToken(), getPStateRecord());
	}

	public PresentationStateRecord getPStateRecord() {
		return pStateRecord;
	}

}
