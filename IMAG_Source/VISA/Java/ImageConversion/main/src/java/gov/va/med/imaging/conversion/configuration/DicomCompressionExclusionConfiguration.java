package gov.va.med.imaging.conversion.configuration;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import gov.va.med.imaging.configuration.RefreshableConfig;
import gov.va.med.imaging.configuration.VixConfiguration;
import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;

/**
 * 
 * @author Budy Tjahjo
 *
 */


public class DicomCompressionExclusionConfiguration extends AbstractBaseFacadeConfiguration	implements RefreshableConfig
{

	private static final String DEFAULT_COMPRESSION_EXCLUSION_SOURCE = "DICOM";
	private static final String DEFAULT_COMPRESSION_EXCLUSION_TARGET = "J2K";
	
	private Map<String, String> dicomCompressionExclusionMap = new HashMap<String, String>();
	
	public DicomCompressionExclusionConfiguration() 
	{
		super();
	}

	public static DicomCompressionExclusionConfiguration loadDicomCompressionExclusionConfiguration() 
	{
		DicomCompressionExclusionConfiguration config =  new DicomCompressionExclusionConfiguration();
		return (DicomCompressionExclusionConfiguration) config.loadConfiguration();
	}


	public boolean isExluded(String source, String target) 
	{
		String targetInMap = dicomCompressionExclusionMap.get(source);
		return (targetInMap != null) && (targetInMap.toUpperCase(Locale.ENGLISH).equals(target.toUpperCase(Locale.ENGLISH)));
	}
	
	public Map<String, String> getDicomCompressionExclusionMap()
	{
		return dicomCompressionExclusionMap;
	}

	public void setDicomCompressionExclusionMap(
			Map<String, String> dicomCompressionExclusionMap)
	{
		this.dicomCompressionExclusionMap = dicomCompressionExclusionMap;
	}
	

	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration() 
	{
		dicomCompressionExclusionMap.put(DEFAULT_COMPRESSION_EXCLUSION_SOURCE, DEFAULT_COMPRESSION_EXCLUSION_TARGET);
		return this;
	}


	@Override
	public VixConfiguration refreshFromFile() 
	{
		try 
		{
			DicomCompressionExclusionConfiguration sc = (DicomCompressionExclusionConfiguration) loadConfiguration();
			getLogger().debug("DicomCompressionExclusionConfiguration.refreshFromFile() --> reloaded from file.");
			return sc;
		} catch (Exception ex) {
            getLogger().warn("DicomCompressionExclusionConfiguration.refreshFromFile() --> Encountered exception [{}]: {}", ex.getClass().getSimpleName(), ex.getMessage());
			return null;
		}
	}
}
