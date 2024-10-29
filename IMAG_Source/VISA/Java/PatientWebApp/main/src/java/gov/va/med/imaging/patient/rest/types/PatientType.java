/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 3, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.patient.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement
public class PatientType
{
	private String patientName;
	private String patientIcn;
	private String veteranStatus;
	private String patientSex;
	private Date dob;	
	private String ssn;
	private String dfn;
	private boolean sensitive;
	
	public PatientType()
	{
		super();
	}

	public PatientType(String patientName, String patientIcn,
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
