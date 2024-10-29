/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 15, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.patient;

import gov.va.med.HealthSummaryURN;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.HealthSummaryType;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.PatientMeansTestResult;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;

import java.util.List;

/**
 * @author vhaiswlouthj
 *
 */
@FacadeRouterInterface()
@FacadeRouterInterfaceCommandTester
public interface PatientRouter 
extends FacadeRouter
{
	
    // Patient Lookup
	@FacadeRouterMethod(asynchronous=false)
	public abstract List<Patient> getPatientList(String searchCriteria, RoutingToken routingToken) 
	throws MethodException, ConnectionException;

	// Log Sensitive Patient Access
	@FacadeRouterMethod(asynchronous=false)
	public abstract PatientSensitiveValue getPatientSensitivityLevel(RoutingToken routingToken, PatientIdentifier patientIdentifier) 
	throws MethodException, ConnectionException;

	// Log Sensitive Patient Access
	@FacadeRouterMethod(asynchronous=false)
	public abstract Boolean postSensitivePatientAccess(RoutingToken routingToken, PatientIdentifier patientIdentifier) 
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientInformationCommand")
	public abstract Patient getPatientInformation(RoutingToken routingToken, PatientIdentifier patientIdentifier)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetHealthSummaryTypeListCommand")
	public abstract List<HealthSummaryType> getHealthSummaries(RoutingToken routingToken)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientHealthSummaryCommand")
	public abstract String getHealthSummary(HealthSummaryURN healthSummaryUrn, PatientIdentifier patientIdentifier)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientMeansTestCommand")
	public abstract PatientMeansTestResult getPatientMeansTest(RoutingToken routingToken, PatientIdentifier patientIdentifier)
	throws ConnectionException, MethodException;

}
