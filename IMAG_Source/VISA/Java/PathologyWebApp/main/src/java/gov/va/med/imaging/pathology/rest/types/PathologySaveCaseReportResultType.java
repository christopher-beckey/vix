/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 11, 2013
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
package gov.va.med.imaging.pathology.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author vhaiswwerfej
 *
 */
@XmlRootElement
public class PathologySaveCaseReportResultType
{
	private boolean released;
	private String message;
	
	public PathologySaveCaseReportResultType()
	{
		super();
	}
	
	/**
	 * @param released
	 * @param message
	 */
	public PathologySaveCaseReportResultType(boolean released, String message)
	{
		super();
		this.released = released;
		this.message = message;
	}

	public boolean isReleased()
	{
		return released;
	}

	public void setReleased(boolean released)
	{
		this.released = released;
	}

	public String getMessage()
	{
		return message;
	}

	public void setMessage(String message)
	{
		this.message = message;
	}

}