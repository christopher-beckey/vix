/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 17, 2008
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
package gov.va.med.imaging.conversion.configuration;

import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import gov.va.med.imaging.utils.XmlUtilities;
import gov.va.med.logging.Logger;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.IImageConversionConfiguration;
import gov.va.med.imaging.core.interfaces.exceptions.ApplicationConfigurationException;
import gov.va.med.imaging.exchange.business.ImageFormatAllowableConversionList;
import gov.va.med.imaging.exchange.enums.ImageFormat;

/**
 * Image conversion configuration. Contains options for using in Image conversion.
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ImageConversionConfiguration 
implements IImageConversionConfiguration 
{
	private static final String IMAGE_CONVERSION_CONFIG_FILENAME = "ImageConversionConfig.xml";
	private final static Logger LOGGER = Logger.getLogger(ImageConversionConfiguration.class);

	protected boolean downSamplingEnabled;
	protected boolean noLosslessCompression;
	protected boolean decompressionEnabled;
	
	protected List<ImageFormatAllowableConversionList> formatConfigurations = new ArrayList<ImageFormatAllowableConversionList>();
	
	private String vixConfigurationDirectory;
	private String imageConversionConfigurationFilespec;
	
	private final ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();
	protected final Lock readLock = rwl.readLock();
    protected final Lock writeLock = rwl.writeLock();	
	
	public ImageConversionConfiguration()
	{
		super();
	}
	
	public void init() 
	throws ApplicationConfigurationException
	{
		getImageConversionConfigurationFilespec();
	}
	
	@Override
	public boolean loadImageConversionConfigurationFromFile() 
	{
		boolean success = false;
		
		try
		{
			success = this.loadAppConfigurationFromFile(this.getImageConversionConfigurationFilespec()); // uses read lock
		}
		catch (ApplicationConfigurationException ex) 
		{
            LOGGER.warn("ImageConversionConfiguration.loadImageConversionConfigurationFromFile() --> Encountered ApplicationConfigurationException: {}", ex.getMessage());
		}
		
		return success;
	}	

	/**
	 * @param fileSpec - the file that contains the application configuration
	 * @return true if the configuration was successfully loaded from the file specified by appConfigurationFilespec
	 */
	private boolean loadAppConfigurationFromFile(String fileSpec) 
	{
        LOGGER.info("ImageConversionConfiguration.loadAppConfigurationFromFile() --> Loading image conversion configuration from file [{}]", fileSpec);
		
		boolean success = false;
		ImageConversionConfiguration imageConversionConfiguration = null;

		if (fileSpec != null)
		{
			// Fortify change: added clean string for good measure
			File configFile = new File(StringUtil.cleanString(fileSpec));
			
			if (configFile.exists())
			{
				// Fortify change: added try-with-resources
				try (FileInputStream inStream = new FileInputStream(configFile)) {
					imageConversionConfiguration = XmlUtilities.deserializeXMLDecoderContent(ImageConversionConfiguration.class, inStream);
					
					if (imageConversionConfiguration != null) {
						this.assignState(imageConversionConfiguration); // this method obtains a write lock
                        LOGGER.info("ImageConversionConfiguration: loaded ImageConversion configuration from: {}", fileSpec);
						success = true;
					}
				} catch (Exception ex) {
					LOGGER.error(ex.getMessage());
				}
			}
		}

        LOGGER.info("Image conversion configuration from file [{}] loaded.", fileSpec);
		
		return success;
	}
	
	/**
	 * @param imageConversionConfiguration - the AppConfiguration object that contains the state to use
	 * This public method takes the state of the passed appConfiguration param and overlays it onto the current instance
	 */
	private void assignState(ImageConversionConfiguration imageConversionConfiguration)
	{
		if (imageConversionConfiguration != null)
		{
			this.writeLock.lock();
			imageConversionConfiguration.readLock.lock();
			try
			{
				this.downSamplingEnabled = imageConversionConfiguration.downSamplingEnabled;
				this.noLosslessCompression = imageConversionConfiguration.noLosslessCompression;
				this.decompressionEnabled = imageConversionConfiguration.decompressionEnabled;
				
				this.formatConfigurations.addAll(imageConversionConfiguration.formatConfigurations);
			}
			finally
			{
				this.writeLock.unlock();
				imageConversionConfiguration.readLock.unlock();
			}
		}
	}
	
	private String getImageConversionConfigurationFilespec() 
	throws ApplicationConfigurationException
	{
		String fileSpec = null;
		this.readLock.lock();
		
		try 
		{
			fileSpec = this.imageConversionConfigurationFilespec;
		}
		finally 
		{
			this.readLock.unlock();
		}

		if (fileSpec == null)
		{
			fileSpec = this.getVixConfigurationDirectory();
			// add the trailing file separator character if necessary
			if (!fileSpec.endsWith("\\") || !fileSpec.endsWith("/"))
			{
				fileSpec += "/";
			}
			fileSpec += IMAGE_CONVERSION_CONFIG_FILENAME;

			this.setAppConfigurationFilespec(fileSpec);
		}
		
		return fileSpec;
	}
	
	private void setAppConfigurationFilespec(String fileSpec) 
	{
		this.writeLock.lock();
		
		try 
		{
			this.imageConversionConfigurationFilespec = fileSpec;
		}
		finally 
		{
			this.writeLock.unlock();
		}
	}
	
	private String getVixConfigurationDirectory() 
	throws ApplicationConfigurationException
	{
		String configDir = null;
		this.readLock.lock();
		
		try 
		{
			configDir = this.vixConfigurationDirectory;
		}
		finally 
		{
			this.readLock.unlock();
		}
		
		if (configDir == null)
		{
			configDir = System.getenv("vixconfig");
			
			if (configDir == null)
			{
				throw new ApplicationConfigurationException("ImageConversionConfiguration.getVixConfigurationDirectory() --> The vixconfig has not been set.");
			}

			this.setVixConfigurationDirectory(configDir);
		}
		
		return configDir;
	}
	
	private void setVixConfigurationDirectory(String vixConfigurationDirectory) 
	{
		this.writeLock.lock();
		
		try 
		{
			this.vixConfigurationDirectory = vixConfigurationDirectory;
		}
		finally 
		{
			this.writeLock.unlock();
		}
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.IImageConversionConfiguration#isDecompressionEnabled()
	 */
	@Override
	public boolean isDecompressionEnabled() 
	{
		this.readLock.lock();
		
		try 
		{
			return this.decompressionEnabled;
		}
		finally 
		{
			this.readLock.unlock();
		}
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.IImageConversionConfiguration#isDownSamplingEnabled()
	 */
	@Override
	public boolean isDownSamplingEnabled() 
	{
		this.readLock.lock();
		
		try 
		{
			return this.downSamplingEnabled;
		}
		finally 
		{
			this.readLock.unlock();
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.IImageConversionConfiguration#isNoLosslessCompression()
	 */
	@Override
	public boolean isNoLosslessCompression() 
	{
		this.readLock.lock();
		
		try 
		{
			return this.noLosslessCompression;
		}
		finally 
		{
			this.readLock.unlock();
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.IImageConversionConfiguration#setDecompressionEnabled(boolean)
	 */
	@Override
	public void setDecompressionEnabled(boolean enabled) 
	{
		this.writeLock.lock();
		
		try 
		{
			this.decompressionEnabled = enabled;
		}
		finally 
		{
			this.writeLock.unlock();
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.IImageConversionConfiguration#setDownSamplingEnabled(boolean)
	 */
	@Override
	public void setDownSamplingEnabled(boolean enabled) 
	{
		this.writeLock.lock();
		
		try 
		{
			this.downSamplingEnabled = enabled;
		}
		finally 
		{
			this.writeLock.unlock();
		}
	}	

	@Override
	public List<ImageFormatAllowableConversionList> getFormatConfigurations() 
	{
		this.readLock.lock();
		
		try 
		{
			return this.formatConfigurations;
		}
		finally 
		{
			this.readLock.unlock();
		}		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.IImageConversionConfiguration#setNoLosslessCompression(boolean)
	 */
	@Override
	public void setNoLosslessCompression(boolean enabled) 
	{
		this.writeLock.lock();
		
		try 
		{
			this.noLosslessCompression = enabled;
		}
		finally 
		{
			this.writeLock.unlock();
		}
	}
	
	public void setFormatConfigurations(
			List<ImageFormatAllowableConversionList> formatConfigurations) 
	{
		this.writeLock.lock();		
		try 
		{
			this.formatConfigurations = formatConfigurations;
		}
		finally 
		{
			this.writeLock.unlock();
		}
	}
	
	@Override
	public ImageFormatAllowableConversionList getFormatConfiguration(ImageFormat format) 
	{	
		this.readLock.lock();
		
		if(format == null)
		{
			LOGGER.warn("ImageConversionConfiguration.getFormatConfiguration() --> Given ImageFormat object is null. Retur null conversion list.");
			return null;
		}

        LOGGER.info("ImageConversionConfiguration.getFormatConfiguration() --> Searching for conversion format for given image format [{}]", format);
		try 
		
		{			
			for(ImageFormatAllowableConversionList list : formatConfigurations)
			{
				if(list.getImageFormat() == format)
					return list;
			}
			return null;
		}
		finally 
		{
			this.readLock.unlock();
		}
	}

	@Override
	public boolean saveImageConversionConfigurationToFile() {
		boolean success = false;
		// Fortify change: moved out for readability and added clean string for good measure
		String configFileName = null;
		
		try 
		{
			configFileName = StringUtil.cleanString(this.getImageConversionConfigurationFilespec());
		} 
		catch (ApplicationConfigurationException e) 
		{
			throw new IllegalArgumentException("ImageConversionConfiguration.saveAppConfigurationToFile() --> Can't get config file: " + e.getMessage());
		}

		this.readLock.lock();
		
		// Fortify change: added try-with-resources
		try (FileOutputStream outStream = new FileOutputStream(configFileName); 
			 BufferedOutputStream bufferOutStream = new BufferedOutputStream(outStream);
			 XMLEncoder xmlEncoder = new XMLEncoder(bufferOutStream) )
		{
			xmlEncoder.writeObject(this);
            LOGGER.info("ImageConversionConfiguration.saveAppConfigurationToFile() --> Configuration saved to: {}", configFileName);
			success = true;
		}
		catch (Exception ex)
		{
            LOGGER.warn("ImageConversionConfiguration.saveAppConfigurationToFile --> Encountered exception [{}]: {}", ex.getClass().getSimpleName(), ex.getMessage());
		}
		finally
		{
			this.readLock.unlock();
		}
		
		return success;
	}
	
	public static void main(String [] args)
	{
		ImageConversionConfiguration config = new ImageConversionConfiguration();
		try
		{
			config.init();
		}
		catch(ApplicationConfigurationException acX)
		{
			acX.printStackTrace();
		}
		setBasicConfiguration(config);
		config.saveImageConversionConfigurationToFile();
	}
	
	private static void setBasicConfiguration(ImageConversionConfiguration config)
	{
		config.setDecompressionEnabled(true);
		config.setDownSamplingEnabled(false);
		config.setNoLosslessCompression(false);
		
		// Create the default conversion options allowed for each format
		// The order of items in these lists is NOT relevant
		
		// JMW 8/18/08 - can't actually compress a TGA into a compressed TGA
		ImageFormatAllowableConversionList tgaList = 
			new ImageFormatAllowableConversionList(ImageFormat.TGA, false);
		tgaList.add(ImageFormat.DICOM);
		tgaList.add(ImageFormat.DICOMJPEG);
		tgaList.add(ImageFormat.DICOMJPEG2000);
		tgaList.add(ImageFormat.J2K);
		tgaList.add(ImageFormat.TGA);
		tgaList.add(ImageFormat.JPEG);		
		config.formatConfigurations.add(tgaList);
		
		ImageFormatAllowableConversionList dicomList = 
			new ImageFormatAllowableConversionList(ImageFormat.DICOM, true);
		dicomList.add(ImageFormat.DICOM);
		dicomList.add(ImageFormat.DICOMJPEG);
		dicomList.add(ImageFormat.DICOMJPEG2000);
		dicomList.add(ImageFormat.TGA);
		dicomList.add(ImageFormat.J2K);
		dicomList.add(ImageFormat.JPEG);		
		config.formatConfigurations.add(dicomList);
		
		ImageFormatAllowableConversionList dicomJpgList = 
			new ImageFormatAllowableConversionList(ImageFormat.DICOMJPEG, true);
		dicomJpgList.add(ImageFormat.DICOM);
		dicomJpgList.add(ImageFormat.DICOMJPEG);
		dicomJpgList.add(ImageFormat.DICOMJPEG2000);
		dicomJpgList.add(ImageFormat.TGA);
		dicomJpgList.add(ImageFormat.J2K);
		dicomJpgList.add(ImageFormat.JPEG);		
		config.formatConfigurations.add(dicomJpgList);
		
		ImageFormatAllowableConversionList dicomJ2kList = 
			new ImageFormatAllowableConversionList(ImageFormat.DICOMJPEG2000, true);
		dicomJ2kList.add(ImageFormat.DICOM);
		dicomJ2kList.add(ImageFormat.DICOMJPEG);
		dicomJ2kList.add(ImageFormat.DICOMJPEG2000);
		dicomJ2kList.add(ImageFormat.TGA);
		dicomJ2kList.add(ImageFormat.J2K);
		dicomJ2kList.add(ImageFormat.JPEG);		
		config.formatConfigurations.add(dicomJ2kList);
		
		ImageFormatAllowableConversionList j2kList = 
			new ImageFormatAllowableConversionList(ImageFormat.J2K, true);
		j2kList.add(ImageFormat.DICOM);
		j2kList.add(ImageFormat.DICOMJPEG);
		j2kList.add(ImageFormat.DICOMJPEG2000);
		j2kList.add(ImageFormat.TGA);
		j2kList.add(ImageFormat.J2K);
		j2kList.add(ImageFormat.JPEG);		
		config.formatConfigurations.add(j2kList);
		
		ImageFormatAllowableConversionList dicomPdfList = 
			new ImageFormatAllowableConversionList(ImageFormat.DICOMPDF, false);
		dicomPdfList.add(ImageFormat.DICOMPDF);
		config.formatConfigurations.add(dicomPdfList);
		
		ImageFormatAllowableConversionList jpgList = 
			new ImageFormatAllowableConversionList(ImageFormat.JPEG, false);
		jpgList.add(ImageFormat.JPEG);
		jpgList.add(ImageFormat.BMP);
		config.formatConfigurations.add(jpgList);
		
		ImageFormatAllowableConversionList pdfList = 
			new ImageFormatAllowableConversionList(ImageFormat.PDF, false);
		pdfList.add(ImageFormat.PDF);
		config.formatConfigurations.add(pdfList);
		
		ImageFormatAllowableConversionList docList = 
			new ImageFormatAllowableConversionList(ImageFormat.DOC, false);
		docList.add(ImageFormat.DOC);
		config.formatConfigurations.add(docList);
		
		ImageFormatAllowableConversionList aviList = 
			new ImageFormatAllowableConversionList(ImageFormat.AVI, false);
		aviList.add(ImageFormat.AVI);
		config.formatConfigurations.add(aviList);
		
		ImageFormatAllowableConversionList bmpList = 
			new ImageFormatAllowableConversionList(ImageFormat.BMP, false);
		bmpList.add(ImageFormat.BMP);
		bmpList.add(ImageFormat.JPEG);
		config.formatConfigurations.add(bmpList);
		
		ImageFormatAllowableConversionList htmlList = 
			new ImageFormatAllowableConversionList(ImageFormat.HTML, false);
		htmlList.add(ImageFormat.HTML);
		config.formatConfigurations.add(htmlList);
		
		ImageFormatAllowableConversionList mp3List = 
			new ImageFormatAllowableConversionList(ImageFormat.MP3, false);
		mp3List.add(ImageFormat.MP3);
		config.formatConfigurations.add(mp3List);
		
		ImageFormatAllowableConversionList mpgList = 
			new ImageFormatAllowableConversionList(ImageFormat.MPG, false);
		mpgList.add(ImageFormat.MPG);
		config.formatConfigurations.add(mpgList);
		
		ImageFormatAllowableConversionList rtfList = 
			new ImageFormatAllowableConversionList(ImageFormat.RTF, false);
		rtfList.add(ImageFormat.RTF);
		config.formatConfigurations.add(rtfList);
		
		ImageFormatAllowableConversionList txtList = 
			new ImageFormatAllowableConversionList(ImageFormat.TEXT_PLAIN, false);
		txtList.add(ImageFormat.TEXT_PLAIN);
		config.formatConfigurations.add(txtList);
		
		ImageFormatAllowableConversionList tiffList = 
			new ImageFormatAllowableConversionList(ImageFormat.TIFF, false);
		tiffList.add(ImageFormat.TIFF);
		config.formatConfigurations.add(tiffList);
		
		ImageFormatAllowableConversionList wavList = 
			new ImageFormatAllowableConversionList(ImageFormat.WAV, false);
		wavList.add(ImageFormat.WAV);
		config.formatConfigurations.add(wavList);
		
		ImageFormatAllowableConversionList docXList = 
			new ImageFormatAllowableConversionList(ImageFormat.DOCX, false);
		docXList.add(ImageFormat.DOCX);
		config.formatConfigurations.add(docXList);
		
		ImageFormatAllowableConversionList xmlList = 
				new ImageFormatAllowableConversionList(ImageFormat.XML, false);
		xmlList.add(ImageFormat.XML);
		config.formatConfigurations.add(xmlList);
	}
}
