package gov.va.med.imaging.url.exchange.configuration;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.configuration.DetectConfigNonTransientValueChanges;
import gov.va.med.logging.Logger;
import org.owasp.encoder.Encode;

import gov.va.med.imaging.url.exchange.exceptions.ExchangeConfigurationException;


/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class ExchangeConfiguration
implements Serializable, DetectConfigNonTransientValueChanges
{
	private final static long serialVersionUID = 1L;

	private static final String DEFAULT_BIA_USERNAME = "vixuser";
	private static final String DEFAULT_BIA_KEY = "vixvix1.";
	public static final String DEFAULT_BIA_SITE = "200";
	
	public final static String defaultDODXChangeApplication = "VaImagingExchange";
	public final static String defaultDODImageXChangePath = "/RetrieveImage.ashx";
	public final static String defaultDODMetadataXChangePath = "/ImageMetadataService.asmx";
	public final static String defaultDODImageHost = "";
	public final static int defaultDODImagePort = 0;
	
	public final static String defaultImageXChangeApplication = "ExchangeWebApp";//"ImagingExchangeWebApp";
	public final static String defaultImageMetadataXChangePath = "/xchange-ws/ImageMetadata.V1";
	public final static String defaultImageXChangePath = "/xchange/xchange";	
	public final static String defaultImageHost = "";
	public final static int defaultImagePort = 0;
	
	private final static Logger logger = Logger.getLogger(ExchangeConfiguration.class);
	
	private List<ExchangeSiteConfiguration> configurations;
	private List<String> emptyStudyModalities;
	private int metadataTimeout;
	
	public final static int defaultMetadataTimeout = 45000;
	
	/**
	 * 
	 */
	public ExchangeConfiguration()
	{
		super();
		configurations = new ArrayList<ExchangeSiteConfiguration>();
		emptyStudyModalities = new ArrayList<String>();
		metadataTimeout = defaultMetadataTimeout;
	}
	
	public static ExchangeConfiguration createDefaultExchangeConfiguration(String [] vaSites, 
			String biaUsername, String biaPassword, List<ExchangeSiteConfiguration> alienSites,
			List<String> emptyStudyModalities, int metadataTimeout)
	throws ExchangeConfigurationException
	{
		ExchangeConfiguration xchangeConfiguration = new ExchangeConfiguration();
		if(vaSites != null)
		{
			for(String vaSite : vaSites)
			{				
				if(vaSite != null)
				{
                    logger.debug("Adding VA template for site [{}]", vaSite);
					ExchangeSiteConfiguration site = 
						new ExchangeSiteConfiguration(
							vaSite, "", "", 
							defaultImageXChangeApplication, 
							defaultImageMetadataXChangePath, 
							defaultImageXChangePath,
							true,
							defaultImageHost,
							defaultImagePort);
					
					xchangeConfiguration.addSiteConfiguration(site);
				}
			}
		}
		xchangeConfiguration.createDODSite(biaUsername, Encode.forHtmlContent(biaPassword));
		if(alienSites != null)
		{
			for(ExchangeSiteConfiguration alienSiteConfig : alienSites)
			{
				alienSiteConfig.setImagePath(defaultDODImageXChangePath);
				alienSiteConfig.setMetadataPath(defaultDODMetadataXChangePath);
				alienSiteConfig.setXChangeApplication(defaultDODXChangeApplication);
				xchangeConfiguration.addSiteConfiguration(alienSiteConfig);
			}
		}
		//xchangeConfiguration.emptyStudyModalities.add("PR"); // we know PR studies from the DoD have 0 images
		xchangeConfiguration.emptyStudyModalities.addAll(emptyStudyModalities);
		xchangeConfiguration.metadataTimeout = metadataTimeout;
		return xchangeConfiguration;
	}

	/**
	 * Create an ExchangeConfiguration instance with a DOD and multiple VA site
	 * entries.
	 * 
	 * @param vaSites
	 * @return
	 * @throws ExchangeConfigurationException
	 */
	public static ExchangeConfiguration createDefaultExchangeConfiguration(String[] vaSites)
	throws ExchangeConfigurationException
	{
		ExchangeConfiguration xchangeConfiguration = new ExchangeConfiguration();
		/*
		xchangeConfiguration.setBiaPassword(DEFAULT_BIA_PASSWORD);
		xchangeConfiguration.setBiaUsername(DEFAULT_BIA_USERNAME);
		*/
		
		if(vaSites != null)
		{
			for(String vaSite : vaSites)
			{
                logger.debug("Adding VA template for site [{}]", vaSite);
				if(vaSite != null)
				{
					ExchangeSiteConfiguration site = 
						new ExchangeSiteConfiguration(
							vaSite, "", "", 
							defaultImageXChangeApplication, 
							defaultImageMetadataXChangePath, 
							defaultImageXChangePath,
							true,
							defaultImageHost,
							defaultImagePort);
					
					xchangeConfiguration.addSiteConfiguration(site);
				}
			}
		}
		
		xchangeConfiguration.createDODSite();		
		return xchangeConfiguration;
	}	
	
	private void createDODSite()
	{
		ExchangeSiteConfiguration site = new ExchangeSiteConfiguration(DEFAULT_BIA_SITE, 
				DEFAULT_BIA_USERNAME, DEFAULT_BIA_KEY, defaultDODXChangeApplication,
				defaultDODMetadataXChangePath, defaultDODImageXChangePath, false,
				defaultDODImageHost, defaultDODImagePort);
		addSiteConfiguration(site);
	}
	
	private void createDODSite(String biaUsername, String biaPassword)
	{
		String username = DEFAULT_BIA_USERNAME;
		String biaKey = DEFAULT_BIA_KEY;
		if(biaUsername != null)
			username = biaUsername;
		if(biaPassword != null)
			biaKey = biaPassword;
        logger.debug("Adding DOD Site with username [{}] and password [{}]", username, biaKey);
		ExchangeSiteConfiguration site = new ExchangeSiteConfiguration(DEFAULT_BIA_SITE, 
				username, biaKey, defaultDODXChangeApplication,
				defaultDODMetadataXChangePath, defaultDODImageXChangePath, false,
				defaultDODImageHost, defaultDODImagePort);
		addSiteConfiguration(site);
	}
	
	private void addSiteConfiguration(ExchangeSiteConfiguration site)
	{
		this.configurations.add(site);
	}

	public ExchangeSiteConfiguration getSiteConfiguration(String preferredSiteNumber, String alternateSiteNumber)
	throws ExchangeConfigurationException
	{
        logger.debug("Searching for Exchange data source site configuration [{}]", preferredSiteNumber);
		for(int i = 0; i < configurations.size(); i++)
		{
			ExchangeSiteConfiguration site = configurations.get(i);
			if((site != null) && (site.equals(preferredSiteNumber)))
			{
                logger.debug("Found Exchange data source site configuration [{}]", preferredSiteNumber);
				return site;
			}
		}
        logger.warn("Unable to find preferred site [{}] in exchange configuration", preferredSiteNumber);
		if((alternateSiteNumber != null) && (alternateSiteNumber.length() > 0))
		{
            logger.debug("Searching for Exchange data source site configuration with alternative site [{}]", alternateSiteNumber);
			for(int i = 0; i < configurations.size(); i++)
			{
				ExchangeSiteConfiguration site = configurations.get(i);
				if((site != null) && (site.equals(alternateSiteNumber)))
				{
                    logger.debug("Found Exchange data source site configuration for alternate site [{}]", alternateSiteNumber);
					return site;
				}
			}
		}
		String msg = "Unable to find preferred site [" + preferredSiteNumber + "]";
		if((alternateSiteNumber != null) && (alternateSiteNumber.length() > 0))
			msg += " or alternate site number [" + alternateSiteNumber + "]";
		msg += " in exchange configuration";
		throw new ExchangeConfigurationException(msg);
	}

	/**
	 * return an unmodifiable List of configurations
	 * @return
	 */
	public List<ExchangeSiteConfiguration> getConfigurations() 
	{
		return configurations;
	}

	public void setConfigurations(List<ExchangeSiteConfiguration> configurations) 
	{
		this.configurations = configurations;
	}

	public List<String> getEmptyStudyModalities()
	{
		return emptyStudyModalities;
	}

	public void setEmptyStudyModalities(List<String> emptyStudyModalities)
	{
		this.emptyStudyModalities = emptyStudyModalities;
	}

	public int getMetadataTimeout()
	{
		return metadataTimeout;
	}

	public void setMetadataTimeout(int metadataTimeout)
	{
		this.metadataTimeout = metadataTimeout;
	}

	@Override
	public boolean hasValueChangesToPersist(boolean autoStoreChanges) {
		if(configurations != null) {
			for (ExchangeSiteConfiguration configuration : configurations) {
				if (configuration.hasValueChangesToPersist(false)) return true;
			}
		}
		return false;
	}
}
