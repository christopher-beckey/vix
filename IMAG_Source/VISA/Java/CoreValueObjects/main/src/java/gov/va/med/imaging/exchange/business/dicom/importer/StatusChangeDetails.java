/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 19, 2013
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswlouthj
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
package gov.va.med.imaging.exchange.business.dicom.importer;

import java.util.ArrayList;
import java.util.List;

public class StatusChangeDetails 
{
	private String requestedStatus;
	private String standardReportNumber;
	private String manuallyEnteredText;
	private String reportText;
	private String impression;
	private DiagnosticCode primaryDiagnosticCode;
	private List<SecondaryDiagnosticCode> secondaryDiagnosticCodes = new ArrayList<SecondaryDiagnosticCode>();

	public String getRequestedStatus() 
	{
		return requestedStatus;
	}
	public void setRequestedStatus(String requestedStatus) 
	{
		this.requestedStatus = requestedStatus;
	}
	public String getStandardReportNumber() 
	{
		return standardReportNumber;
	}
	public void setStandardReportNumber(String standardReportNumber) 
	{
		this.standardReportNumber = standardReportNumber;
	}
	public DiagnosticCode getPrimaryDiagnosticCode() 
	{
		return primaryDiagnosticCode;
	}
	public void setPrimaryDiagnosticCode(DiagnosticCode primaryDiagnosticCode) 
	{
		this.primaryDiagnosticCode = primaryDiagnosticCode;
	}
	public List<SecondaryDiagnosticCode> getSecondaryDiagnosticCodes() 
	{
		return secondaryDiagnosticCodes;
	}
	public void setSecondaryDiagnosticCodes(List<SecondaryDiagnosticCode> secondaryDiagonosticCodes) 
	{
		this.secondaryDiagnosticCodes = secondaryDiagonosticCodes;
	}
	public String getManuallyEnteredText() 
	{
		return manuallyEnteredText;
	}
	public void setManuallyEnteredText(String manuallyEnteredText) 
	{
		this.manuallyEnteredText = manuallyEnteredText;
	}
	public String getReportText() 
	{
		return reportText;
	}
	public void setReportText(String reportText) 
	{
		this.reportText = reportText;
	}
	public String getImpression() 
	{
		return impression;
	}
	public void setImpression(String impression) 
	{
		this.impression = impression;
	}
	
}
