/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 10, 2012
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
package gov.va.med.imaging.roi.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement
public class ROIStudyType
{
	private ROIImageType [] images;
	private String studyId;
	private String errorMessage;
	private boolean processedByDicomExport;
	private String failedStatus;
	
	public ROIStudyType()
	{
		super();
		errorMessage = null;
		processedByDicomExport = false;
		failedStatus = null;		
	}

	public ROIImageType[] getImages()
	{
		return images;
	}

	public void setImages(ROIImageType[] images)
	{
		this.images = images;
	}

	public String getStudyId()
	{
		return studyId;
	}

	public void setStudyId(String studyId)
	{
		this.studyId = studyId;
	}

	public String getErrorMessage()
	{
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage)
	{
		this.errorMessage = errorMessage;
	}

	public boolean isProcessedByDicomExport()
	{
		return processedByDicomExport;
	}

	public void setProcessedByDicomExport(boolean processedByDicomExport)
	{
		this.processedByDicomExport = processedByDicomExport;
	}

	public String getFailedStatus()
	{
		return failedStatus;
	}

	public void setFailedStatus(String failedStatus)
	{
		this.failedStatus = failedStatus;
	}

}
