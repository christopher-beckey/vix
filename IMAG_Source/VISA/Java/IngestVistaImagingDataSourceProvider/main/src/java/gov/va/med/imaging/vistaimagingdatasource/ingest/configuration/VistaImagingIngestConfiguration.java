/**
 * 
 * 
 * Date Created: Dec 6, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.vistaimagingdatasource.ingest.configuration;

import java.io.Serializable;

/**
 * @author Administrator
 *
 */
public class VistaImagingIngestConfiguration
implements Serializable
{

	private static final long serialVersionUID = -7633091755680836538L;
	private String thumbnailMakerExe;
	private String tempImageDirectory;
	private String imageConverterExe;
	private String videoConverterExe;
	private String gifInfoExe;
	private String conversionWorkingFolder;
	private boolean convertMP4ToAVI;
	
	public VistaImagingIngestConfiguration()
	{
		super();
		this.thumbnailMakerExe = "";
		this.tempImageDirectory = "";
		this.imageConverterExe = "";
		this.videoConverterExe = "";
		this.gifInfoExe = "";
		this.conversionWorkingFolder = "";
		this.convertMP4ToAVI = true;
	}

	/**
	 * @return the thumbnailMakerExe
	 */
	public String getThumbnailMakerExe()
	{
		return thumbnailMakerExe;
	}

	/**
	 * @param thumbnailMakerExe the thumbnailMakerExe to set
	 */
	public void setThumbnailMakerExe(String thumbnailMakerExe)
	{
		this.thumbnailMakerExe = thumbnailMakerExe;
	}

	/**
	 * @return the tempImageDirectory
	 */
	public String getTempImageDirectory()
	{
		return tempImageDirectory;
	}

	/**
	 * @param tempImageDirectory the tempImageDirectory to set
	 */
	public void setTempImageDirectory(String tempImageDirectory)
	{
		this.tempImageDirectory = tempImageDirectory;
	}

	public String getImageConverterExe() {
		return imageConverterExe;
	}

	public void setImageConverterExe(String imageConverterExe) {
		this.imageConverterExe = imageConverterExe;
	}

	public String getVideoConverterExe() {
		return videoConverterExe;
	}

	public void setVideoConverterExe(String videoConverterExe) {
		this.videoConverterExe = videoConverterExe;
	}

	public String getConversionWorkingFolder() {
		return conversionWorkingFolder;
	}

	public void setConversionWorkingFolder(String conversionWorkingFolder) {
		this.conversionWorkingFolder = conversionWorkingFolder;
	}

	public String getGifInfoExe() {
		return gifInfoExe;
	}

	public void setGifInfoExe(String gifInfoExe) {
		this.gifInfoExe = gifInfoExe;
	}

	public boolean isConvertMP4ToAVI() {
		return convertMP4ToAVI;
	}

	public void setConvertMP4ToAVI(boolean convertMP4ToAVI) {
		this.convertMP4ToAVI = convertMP4ToAVI;
	}
}
