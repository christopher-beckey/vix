/**
 * 
  Property of ISI Group, LLC
  Date Created: May 13, 2014
  Developer:  Julian Werfel
 */
package gov.va.med.imaging.hydra.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="patients")
public class HydraPatientsType
{
	private HydraPatientType [] patient;
	
	public HydraPatientsType()
	{
		super();
	}

	public HydraPatientsType(HydraPatientType[] patient)
	{
		super();
		this.patient = patient;
	}

	public HydraPatientType[] getPatient()
	{
		return patient;
	}

	public void setPatient(HydraPatientType[] patient)
	{
		this.patient = patient;
	}
}
