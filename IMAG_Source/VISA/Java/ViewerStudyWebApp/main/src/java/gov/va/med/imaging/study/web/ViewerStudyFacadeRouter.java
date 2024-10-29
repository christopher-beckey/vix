/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;

import java.util.List;

/**
 * @author Julian
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface ViewerStudyFacadeRouter
extends FacadeRouter
{
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudiesByCprsIdentifierAndFilterCommand")
	public abstract List<Study> getStudiesByCprsIdentifier(String patientIcn, RoutingToken routingToken, 
			CprsIdentifier cprsIdentifier, StudyFilter filter)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetUserTokenCommand")
	public abstract String getUserToken(String appName)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetUserStsTokenCommand")
	public abstract String getUserStsToken(String appName, String stsToken)
			throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetShallowStudyListBySiteNumberCommand")
	public abstract List<Study> getShallowStudyListBySiteNumber(RoutingToken routingToken,
		String patientIcn, 
		StudyFilter filter)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyWithImagesArtifactResultsBySiteNumberCommand")
	public abstract ArtifactResults getStudyWithImagesByStudyURN(RoutingToken routingToken,
			PatientIdentifier patientIdentifier, 
			StudyFilter filter, 
			boolean includeRadiology, 
			boolean includeDocuments)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyOnlyArtifactResultsBySiteNumberCommand")
	public abstract ArtifactResults getStudyOnlyByStudyURN(RoutingToken routingToken,
			PatientIdentifier patientIdentifier, 
			StudyFilter filter, 
			boolean includeRadiology, 
			boolean includeDocuments)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostStudiesByCprsIdentifiersAndFilterCommand")
	public abstract List<Study> postStudiesByCprsIdentifiers(
			PatientIdentifier patientIdentifier,
			RoutingToken routingToken,
			StudyFilter filter,
			List<CprsIdentifier> cprsIdentifiers)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="PostViewerStudiesForQaReviewCommand")
	public abstract List<Study> postViewerStudiesForQaReview(
			RoutingToken routingToken,
			StudyFilter filter)
	throws MethodException, ConnectionException;

}
