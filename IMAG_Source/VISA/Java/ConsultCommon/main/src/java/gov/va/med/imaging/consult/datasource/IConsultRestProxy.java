package gov.va.med.imaging.consult.datasource;

import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;

public interface IConsultRestProxy
{
	public abstract List<Consult> getPatientConsults(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier)
	throws MethodException, ConnectionException;

}
