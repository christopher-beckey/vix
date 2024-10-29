/**
 * 
 */
package gov.va.med.imaging.presentation.state.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.presentation.state.datasource.PresentationStateDataSourceSpi;

import java.io.IOException;
import java.util.List;

/**
 * @author Budy Tjahjo
 * 
 * Get Presentation State Details from Data Source.
 *
 */
public class GetStudyPresentationStateDetailsDataSourceCommandImpl 
extends AbstractPresentationStateDataSourceCommandImpl<List<String>> {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9180174711026118724L;
	private final String studyContext;

	public GetStudyPresentationStateDetailsDataSourceCommandImpl(
			RoutingToken routingToken, String studyContext) {
		super(routingToken);
		
		this.studyContext = studyContext;
	}

	@Override
	protected String getSpiMethodName() {
		return "getStudyPSDetails";
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[] {RoutingToken.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[] {getRoutingToken(), studyContext};
	}

	@Override
	protected List<String> getCommandResult(PresentationStateDataSourceSpi spi)
	throws ConnectionException, MethodException  {
		return spi.getStudyPSDetails(getRoutingToken(), studyContext);
	}

}
