/**
 * 
 * Date Created: Aug 6, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.consult.federation;

import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;

/**
 * @author Administrator
 *
 */

@FacadeRouterInterface(extendsClassName="gov.va.med.imaging.BaseWebFacadeRouterImpl")
@FacadeRouterInterfaceCommandTester
public interface FederationConsultRouter
extends gov.va.med.imaging.BaseWebFacadeRouter 
//extends FacadeRouter
{
	
	@FacadeRouterMethod(asynchronous = false, commandClassName = "GetConsultsForPatientCommand")
	public abstract List<Consult> getPatientConsults(RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier)	
			throws MethodException, ConnectionException;
		
}