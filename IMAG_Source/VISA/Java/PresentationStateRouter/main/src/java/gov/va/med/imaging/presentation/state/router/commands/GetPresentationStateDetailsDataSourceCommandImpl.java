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
 * Get Presentation State Details from Data Source.
 *
 */
public class GetPresentationStateDetailsDataSourceCommandImpl 
extends AbstractPresentationStateDataSourceCommandImpl<List<PresentationStateRecord>> {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9180174711026008724L;
	private final List<PresentationStateRecord> pStateRecords;

	public GetPresentationStateDetailsDataSourceCommandImpl(
			RoutingToken routingToken, List<PresentationStateRecord> pStateRecords) {
		super(routingToken);
		
		this.pStateRecords = pStateRecords;
	}

	@Override
	protected String getSpiMethodName() {
		return "getPSDetails";
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[] {RoutingToken.class, List.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[] {getRoutingToken(), getpStateRecords()};
	}

	@Override
	protected List<PresentationStateRecord> getCommandResult(
			PresentationStateDataSourceSpi spi) throws ConnectionException,
			MethodException {
		return spi.getPSDetails(getRoutingToken(), getpStateRecords());
	}

	public List<PresentationStateRecord> getpStateRecords() {
		return pStateRecords;
	}

}
