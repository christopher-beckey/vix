/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 27, 2012
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
package gov.va.med.imaging.imagegear.datasource.configuration;

import java.io.Serializable;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ImageGearConfiguration
implements Serializable
{
	private static final long serialVersionUID = -5172487710290251344L;
	
	private String groupOutputDirectory;
	private String roiOfficeName;
	private boolean debuggingEnabled;
	private int mergeOutputDirectoryRetensionDays;
	private String pdfGeneratorExePath;
	private String burnAnnotationsExePath;
	private long threadTimeoutMs;
	
	public ImageGearConfiguration()
	{
		super();
	}

	public static ImageGearConfiguration createDefaultConfiguration()
	{
		ImageGearConfiguration config = new ImageGearConfiguration();
		config.groupOutputDirectory = "C:\\temp\\output";
		config.roiOfficeName = "ROI Test Office";
		config.debuggingEnabled = false;
		config.mergeOutputDirectoryRetensionDays = 5;
		config.pdfGeneratorExePath = "";
		config.burnAnnotationsExePath = "";
		config.threadTimeoutMs = 1000 * 60 * 2;
		return config;
	}

	public boolean isDebuggingEnabled()
	{
		return debuggingEnabled;
	}

	public void setDebuggingEnabled(boolean debuggingEnabled)
	{
		this.debuggingEnabled = debuggingEnabled;
	}

	public String getGroupOutputDirectory()
	{
		return groupOutputDirectory;
	}

	public void setGroupOutputDirectory(String groupOutputDirectory)
	{
		this.groupOutputDirectory = groupOutputDirectory;
	}
	
	public String getRoiOfficeName()
	{
		return roiOfficeName;
	}

	public void setRoiOfficeName(String roiOfficeName)
	{
		this.roiOfficeName = roiOfficeName;
	}

	public int getMergeOutputDirectoryRetensionDays()
	{
		return mergeOutputDirectoryRetensionDays;
	}

	public void setMergeOutputDirectoryRetensionDays(
			int mergeOutputDirectoryRetensionDays)
	{
		this.mergeOutputDirectoryRetensionDays = mergeOutputDirectoryRetensionDays;
	}

	public String getPdfGeneratorExePath()
	{
		return pdfGeneratorExePath;
	}

	public void setPdfGeneratorExePath(String pdfGeneratorExePath)
	{
		this.pdfGeneratorExePath = pdfGeneratorExePath;
	}

	public String getBurnAnnotationsExePath()
	{
		return burnAnnotationsExePath;
	}

	public void setBurnAnnotationsExePath(String burnAnnotationsExePath)
	{
		this.burnAnnotationsExePath = burnAnnotationsExePath;
	}

	public long getThreadTimeoutMs()
	{
		return threadTimeoutMs;
	}

	public void setThreadTimeoutMs(long threadTimeoutMs)
	{
		this.threadTimeoutMs = threadTimeoutMs;
	}

}
