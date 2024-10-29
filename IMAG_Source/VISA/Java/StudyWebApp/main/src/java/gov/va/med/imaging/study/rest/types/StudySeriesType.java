/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 1, 2012
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
package gov.va.med.imaging.study.rest.types;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement
@XmlType(propOrder={"seriesUid", "seriesNumber", "modality", "description", "images"})
public class StudySeriesType
{
	private String seriesUid;
	private String seriesNumber;
	private String modality;
	private String description;
	
	private StudyImagesType images;
	
	public StudySeriesType()
	{
		super();
	}

	/**
	 * @return the images
	 */
	public StudyImagesType getImages()
	{
		return images;
	}

	/**
	 * @param images the images to set
	 */
	public void setImages(StudyImagesType images)
	{
		this.images = images;
	}

	/**
	 * @return the seriesUid
	 */
	public String getSeriesUid()
	{
		return seriesUid;
	}

	/**
	 * @param seriesUid the seriesUid to set
	 */
	public void setSeriesUid(String seriesUid)
	{
		this.seriesUid = seriesUid;
	}

	/**
	 * @return the seriesNumber
	 */
	public String getSeriesNumber()
	{
		return seriesNumber;
	}

	/**
	 * @param seriesNumber the seriesNumber to set
	 */
	public void setSeriesNumber(String seriesNumber)
	{
		this.seriesNumber = seriesNumber;
	}

	/**
	 * @return the modality
	 */
	public String getModality()
	{
		return modality;
	}

	/**
	 * @param modality the modality to set
	 */
	public void setModality(String modality)
	{
		this.modality = modality;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Override
	public String toString() {
		return "StudySeriesType [seriesUid=" + seriesUid + ", seriesNumber=" + seriesNumber + ", modality=" + modality
				+ ", description=" + description + ", images=" + images + "]";
	}

}
