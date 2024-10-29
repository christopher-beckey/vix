/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 9, 2012
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
package gov.va.med.imaging.roi;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIStudy
implements Serializable
{
	private static final long serialVersionUID = -5147900723967097561L;
	private String studyUrn;
	private String procedure;
	private String description;
	private Date procedureDate;
	private int vistaImageType;
	private List<ROIImage> images;
	private boolean processedByDicomExport;
	private String errorMessage = null;
	private ROIStatus failedStatus = null; // the status where the error occured
	
	public ROIStudy()
	{
		super();
		images = null;
		processedByDicomExport = false;
	}
	
	public ROIStudy(String studyUrn)
	{
		this();
		this.studyUrn = studyUrn;
	}
	
	public ROIStudy(String studyUrn, String procedure, Date procedureDate,
			int vistaImageType)
	{
		this();
		this.studyUrn = studyUrn;
		this.procedure = procedure;
		this.procedureDate = procedureDate;
		this.vistaImageType = vistaImageType;
	}

	public String getStudyUrn()
	{
		return studyUrn;
	}

	public void setStudyUrn(String studyUrn)
	{
		this.studyUrn = studyUrn;
	}

	public String getProcedure()
	{
		return procedure;
	}

	public void setProcedure(String procedure)
	{
		this.procedure = procedure;
	}

	public Date getProcedureDate()
	{
		return procedureDate;
	}

	public void setProcedureDate(Date procedureDate)
	{
		this.procedureDate = procedureDate;
	}

	public int getVistaImageType()
	{
		return vistaImageType;
	}

	public void setVistaImageType(int vistaImageType)
	{
		this.vistaImageType = vistaImageType;
	}

	public List<ROIImage> getImages()
	{
		return images;
	}

	public void setImages(List<ROIImage> images)
	{
		this.images = images;
	}

	public boolean isProcessedByDicomExport()
	{
		return processedByDicomExport;
	}

	public void setProcessedByDicomExport(boolean processedByDicomExport)
	{
		this.processedByDicomExport = processedByDicomExport;
	}

	public String getErrorMessage()
	{
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage)
	{
		this.errorMessage = errorMessage;
	}
	
	public boolean isError()
	{
		return (errorMessage != null);
	}

	public ROIStatus getFailedStatus()
	{
		return failedStatus;
	}

	public void setFailedStatus(ROIStatus failedStatus)
	{
		this.failedStatus = failedStatus;
	}

	public void setError(Throwable t, ROIStatus failedStatus)
	{
		this.errorMessage = t.getMessage();
		this.failedStatus = failedStatus;
	}

	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}
}
