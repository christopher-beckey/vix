/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian
 *
 */
@XmlRootElement(name="series")
public class ViewerStudySeriesType
{

	private String seriesUid;
	private String seriesNumber;
	private String modality; 
	
	private ViewerStudyImagesType images;
	
	public ViewerStudySeriesType()
	{
		super();
	}

	/**
	 * @return the images
	 */
	public ViewerStudyImagesType getImages()
	{
		return images;
	}

	/**
	 * @param images the images to set
	 */
	public void setImages(ViewerStudyImagesType images)
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
}
