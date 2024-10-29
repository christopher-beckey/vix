/**
 * 
 */
package gov.va.med.imaging.ax;

import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;

//import java.util.List;
//
//import gov.va.med.PatientIdentifier;
//import gov.va.med.RoutingToken;
//import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
//import gov.va.med.imaging.core.interfaces.FacadeRouter;
//import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
//import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
//import gov.va.med.imaging.exchange.business.ArtifactResults;
//import gov.va.med.imaging.exchange.business.Patient;
//import gov.va.med.imaging.exchange.business.StudyFilter;

/**
 * @author VACOTITTOC
 *
 */
@FacadeRouterInterface(extendsClassName="gov.va.med.imaging.ImagingBaseWebFacadeRouterImpl")
@FacadeRouterInterfaceCommandTester
public interface AxRouter
extends gov.va.med.imaging.ImagingBaseWebFacadeRouter
{
//	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyWithImagesArtifactResultsBySiteNumberCommand")
//	public abstract ArtifactResults getStudyWithImages(RoutingToken routingToken,
//			PatientIdentifier patientIdentifier, 
//			StudyFilter filter, 
//			boolean includeRadiology, 
//			boolean includeDocuments)
//	throws MethodException, ConnectionException;
//
//	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientListCommand")
//	public abstract List<Patient> getPatientList(String patientName,
//			RoutingToken routingToken)
//	throws MethodException, ConnectionException;
//	
//	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyOnlyArtifactResultsBySiteNumberCommand")
//	public abstract ArtifactResults getStudyOnlyArtifactResultsFromSite(RoutingToken routingToken,
//			PatientIdentifier patientIdentifier, StudyFilter filter,
//			boolean includeRadiology, boolean includeDocuments)
//	throws MethodException, ConnectionException;
	
}
