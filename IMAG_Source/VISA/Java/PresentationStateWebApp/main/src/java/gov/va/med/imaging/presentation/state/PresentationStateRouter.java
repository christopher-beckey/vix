/**
 * 
 */
package gov.va.med.imaging.presentation.state;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;

/**
 * @author William Peterson
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface PresentationStateRouter 
extends FacadeRouter {

	@FacadeRouterMethod(asynchronous=false, commandClassName="DeletePresentationStateRecordDataSourceCommand")
	public abstract Boolean deletePresentationStateRecord(RoutingToken routingToken, PresentationStateRecord pStateRecord)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPresentationStateDetailsDataSourceCommand")
	public abstract List<PresentationStateRecord> getPresentationStateDetails(RoutingToken routingToken, List<PresentationStateRecord> pStateRecords)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPresentationStateRecordsDataSourceCommand")
	public abstract List<PresentationStateRecord> getPresentationStateRecords(RoutingToken routingToken, PresentationStateRecord pStateRecord)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyPresentationStateDetailsDataSourceCommand")
	public abstract List<String> getStudyPresentationStateDetails(RoutingToken routingToken, String studyContext)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="PostPresentationStateDetailDataSourceCommand")
	public abstract Boolean postPresentationStateDetail(RoutingToken routingToken, PresentationStateRecord pStateRecord)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="PostPresentationStateRecordDataSourceCommand")
	public abstract Boolean postPresentationStateRecord(RoutingToken routingToken, PresentationStateRecord pStateRecord)
	throws MethodException, ConnectionException;

}
