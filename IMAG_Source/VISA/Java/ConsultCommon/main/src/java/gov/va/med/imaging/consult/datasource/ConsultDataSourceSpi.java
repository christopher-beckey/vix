/**
 * 
 * 
 * Date Created: Feb 11, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult.datasource;

import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.annotations.SPI;

/**
 * @author Julian Werfel
 *
 */
@SPI(description="Defines the interface for Consult services")
public interface ConsultDataSourceSpi
extends VersionableDataSourceSpi
{
	public abstract List<Consult> getPatientConsults(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier)
	throws MethodException, ConnectionException;

}
