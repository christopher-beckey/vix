/**
 * 
  Property of ISI Group, LLC
  Date Created: May 13, 2014
  Developer:  Julian Werfel
 */
package gov.va.med.imaging.hydra.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="patient")
public class HydraPatientType
{
	private String patientName;
	private String patientIcn;
	private String veteranStatus;
	private String patientSex;
	private Date dob;	
	private String ssn;
	private String dfn;
	private boolean sensitive;
	
	public HydraPatientType()
	{
		super();
	}

	public HydraPatientType(String patientName, String patientIcn,
			String veteranStatus, String patientSex, Date dob, String ssn,
			String dfn, boolean sensitive)
	{
		super();
		this.patientName = patientName;
		this.patientIcn = patientIcn;
		this.veteranStatus = veteranStatus;
		this.patientSex = patientSex;
		this.dob = dob;
		this.ssn = ssn;
		this.dfn = dfn;
		this.sensitive = sensitive;
	}

	public String getPatientName()
	{
		return patientName;
	}

	public void setPatientName(String patientName)
	{
		this.patientName = patientName;
	}

	public String getPatientIcn()
	{
		return patientIcn;
	}

	public void setPatientIcn(String patientIcn)
	{
		this.patientIcn = patientIcn;
	}

	public String getVeteranStatus()
	{
		return veteranStatus;
	}

	public void setVeteranStatus(String veteranStatus)
	{
		this.veteranStatus = veteranStatus;
	}

	public String getPatientSex()
	{
		return patientSex;
	}

	public void setPatientSex(String patientSex)
	{
		this.patientSex = patientSex;
	}

	public Date getDob()
	{
		return dob;
	}

	public void setDob(Date dob)
	{
		this.dob = dob;
	}

	public String getSsn()
	{
		return ssn;
	}

	public void setSsn(String ssn)
	{
		this.ssn = ssn;
	}

	public String getDfn()
	{
		return dfn;
	}

	public void setDfn(String dfn)
	{
		this.dfn = dfn;
	}

	public boolean isSensitive()
	{
		return sensitive;
	}

	public void setSensitive(boolean sensitive)
	{
		this.sensitive = sensitive;
	}
}
