package gov.va.med.imaging.mix.webservices.rest.types.v1;

// import gov.va.med.imaging.mix.webservices.rest.types.v1.DiagnosticReportsType;

import javax.xml.bind.annotation.XmlRootElement;
/**
 * @author VACOTITTOC
 *
 * This DiagnosticReports class is a REST compliant type to include a
 * DiagnosticReport array.
 *
 */
@XmlRootElement(name="DiagnosticReports")
public class DiagnosticReports // implements Serializable, /* Iterable<ShallowStudy>,*/ Comparable<DiagnosticReport>
{	
	private DiagnosticReport [] diagnosticReports;
	
	public DiagnosticReports(DiagnosticReport[] dRs)
	{
		super();
		this.diagnosticReports = dRs;
	}

	public DiagnosticReport[] getDiagnosticReports()
	{
		return diagnosticReports;
	}

	public void setDiagnosticReports(DiagnosticReport[] dRs)
	{
		this.diagnosticReports = dRs;
	}
}
