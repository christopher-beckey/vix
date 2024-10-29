/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 25, 2011
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
package gov.va.med.imaging.exchange.business.dd;

public class DataDictionaryFileField
{
	private final String fileNumber;
	private final String fieldNumber;
	private final String fieldName;
	private String pointerFileNumber;
	
	public DataDictionaryFileField(String fileNumber, String fieldNumber, String fieldName)
	{
		super();
		this.fileNumber = fileNumber;
		this.fieldNumber = fieldNumber;
		this.fieldName = fieldName;
	}
	
	public String getFileNumber()
	{
		return fileNumber;
	}
	
	public String getFieldNumber()
	{
		return fieldNumber;
	}
	
	public String getFieldName()
	{
		return fieldName;
	}

	public void setPointerFileNumber(String filePointer) {
		this.pointerFileNumber = filePointer;
	}

	public String getPointerFileNumber() {
		return pointerFileNumber;
	}
}
