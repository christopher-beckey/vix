/**
 * 
  Property of ISI Group, LLC
  Date Created: May 9, 2014
  Developer:  Julian Werfel
 */
package gov.va.med.imaging.hydra.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="series")
public class HydraSeriesType
{

	private String seriesUid;
	private String seriesNumber;
	private String modality;
	private int imageCount;
	
	private HydraImagesType images;
	
	public HydraSeriesType()
	{
		super();
	}

	public HydraSeriesType(String seriesUid, String seriesNumber,
			String modality, int imageCount, HydraImagesType images) {
		super();
		this.seriesUid = seriesUid;
		this.seriesNumber = seriesNumber;
		this.modality = modality;
		this.imageCount = imageCount;
		this.images = images;
	}

	public String getSeriesUid() {
		return seriesUid;
	}

	public void setSeriesUid(String seriesUid) {
		this.seriesUid = seriesUid;
	}

	public String getSeriesNumber() {
		return seriesNumber;
	}

	public void setSeriesNumber(String seriesNumber) {
		this.seriesNumber = seriesNumber;
	}

	public String getModality() {
		return modality;
	}

	public void setModality(String modality) {
		this.modality = modality;
	}

	public HydraImagesType getImages() {
		return images;
	}

	public void setImages(HydraImagesType images) {
		this.images = images;
	}

	public int getImageCount()
	{
		return imageCount;
	}

	public void setImageCount(int imageCount)
	{
		this.imageCount = imageCount;
	}
}
