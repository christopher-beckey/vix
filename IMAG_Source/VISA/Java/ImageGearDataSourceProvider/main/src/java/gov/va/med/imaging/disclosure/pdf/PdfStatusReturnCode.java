/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 29, 2012
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
package gov.va.med.imaging.disclosure.pdf;

/**
 * @author VHAISWWERFEJ
 *
 */
public enum PdfStatusReturnCode
{
	/*
	 * ReturnCode = 0 is SUCCESS

DELPHI_ERROR-1  = ValidateInput: JobID is blank
DELPHI_ERROR-2  = ValidateInput: Patient Name is blank
DELPHI_ERROR-3  = ValidateInput: PatSSN is blank
DELPHI_ERROR-4  = ValidateInput: PatDOB is blank
DELPHI_ERROR-5  = ValidateInput: PatICN is blank
DELPHI_ERROR-6  = ValidateInput: ManifestRoot is blank
DELPHI_ERROR-7  = ValidateInput: Manifest Patient Dir is blank
DELPHI_ERROR-8  = ValidateInput: ROI Office Name is blank
DELPHI_ERROR-9  = ValidateInput: DisclosureDate is blank
DELPHI_ERROR-10 = ValidateInput: DisclosureTime is blank
DELPHI_ERROR-11 = ValidateInput: exception raised
DELPHI_ERROR-12 = Build_Manifest_Path: cannot create Manifest Root folder
DELPHI_ERROR-13 = Build_Manifest_Path: cannot create directory
DELPHI_ERROR-14 = Build_Manifest_Path: cannot create directory

	 */
	
	success(0, "Success"),
	missingJobId(1, "Job ID is blank"),
	missingPatientName(2, "Patient name is blank"),
	missingPatientSsn(3, "Patient SSN is blank"),
	missingPatientDob(4, "Patient DOB is blank"),
	missingPatientIcn(5, "Patient ICN is blank"),
	missingManifestRoot(6, "Manifest root is blank"),
	missingPatientDir(7, "Manifest patient dir is blank"),
	missingRoiOfficeName(8, "ROI Office Name is blank"),
	missingDisclosureDate(9, "Disclosure Date is blank"),
	missingDisclosureTime(10, "Disclosure Time is blank"),
	exceptionRaised(11, "Exception Raised"),
	cannotCreateManifestRoot(12, "Cannot create manifest root folder"),
	cannotCreateDirectory(13, "Cannot create directory"),
	cannotCreateDirectory14(14, "Cannot create directory");
	
	final int code;
	final String description;
	
	PdfStatusReturnCode(int code, String description)
	{
		this.code = code;
		this.description = description;
	}

	public int getCode()
	{
		return code;
	}

	public String getDescription()
	{
		return description;
	}

	public static PdfStatusReturnCode getFromCode(int code)
	{
		for(PdfStatusReturnCode returnCode : values())
		{
			if(returnCode.code == code)
				return returnCode;
		}
		return null;
	}
}
