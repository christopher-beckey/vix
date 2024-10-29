/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 2, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.musedatasource.configuration;

import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.imaging.configuration.DetectConfigNonTransientValueChanges;
import gov.va.med.imaging.muse.DefaultMuseValues;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Muse datasource configuration details. This includes all of the information used to 
 * communicate with a Muse Server Web application
 * 
 * 
 * @author William Peterson
 *
 */
public class MuseConfiguration
implements Serializable, DetectConfigNonTransientValueChanges
{

	private static final long serialVersionUID = -9112285957427501278L;
	// This is a regular expression for patient filtering which should not match any string
	private static final String DEFAULT_NO_MATCH_EXPRESSION = "a^";

	private List<MuseServerConfiguration> servers;
	
	private EncryptedConfigurationPropertyString museAPIKey;
	
	private String museApplicationName;

	private String musePatientFilterRegularExpression;

	private int preExpirationMinutes = 2;
	
	private String expirationDateFormat = "yyyy-MM-dd'T'HHmmss.nZ";

	private boolean enableSessionCache = true;
	
	public MuseConfiguration(){
		super();
	}

	public static MuseConfiguration createDefaultConfiguration() {

		MuseConfiguration config = new MuseConfiguration();
		
		config.museAPIKey = new EncryptedConfigurationPropertyString(DefaultMuseValues.MUSE_API_KEY);
		
		config.museApplicationName = DefaultMuseValues.defaultApplication;

		config.musePatientFilterRegularExpression = DefaultMuseValues.defaultMusePatientFilterRegEx;
		
		config.servers = new ArrayList<MuseServerConfiguration>();
		
		MuseServerConfiguration museServer = MuseServerConfiguration.createDefaultConfiguration();
		config.servers.add(museServer);
		
		config.setExpirationDateFormat("yyyy-MM-dd'T'HHmmss.nZ");
		
		config.setPreExpirationMinutes(2);
		
		config.setEnableSessionCache(true);
		
		return config;
	}
	
	/**
	 * @param museAPIKey the museAPIKey to set
	 */
	public void setMuseAPIKey(EncryptedConfigurationPropertyString museAPIKey) {
		this.museAPIKey = museAPIKey;
	}

	/**
	 * @return the museAPIKey
	 */
	public String getMuseAPIKey() {
		return museAPIKey.getValue();
	}
	

	/**
	 * @return the museApplicationName
	 */
	public String getMuseApplicationName() {
		return museApplicationName;
	}


	/**
	 * @param museApplicationName the museApplicationName to set
	 */
	public void setMuseApplicationName(String museApplicationName) {
		this.museApplicationName = museApplicationName;
	}

	/**
	 * @return the servers
	 */
	public List<MuseServerConfiguration> getServers() {
		return servers;
	}

	public int getPreExpirationMinutes() {
		return preExpirationMinutes;
	}

	public void setPreExpirationMinutes(int preExpirationMinutes) {
		this.preExpirationMinutes = preExpirationMinutes;
	}

	public String getExpirationDateFormat() {
		return expirationDateFormat;
	}

	public void setExpirationDateFormat(String expirationDateFormat) {
		this.expirationDateFormat = expirationDateFormat;
	}
	
	/**
	 * @param servers the servers to set
	 */
	public void setServers(List<MuseServerConfiguration> servers) {
		this.servers = servers;
	}

	public boolean addServer(MuseServerConfiguration server){
		return servers.add(server);
	}
	
	public boolean removeServer(MuseServerConfiguration server){
		return servers.remove(server);
	}

	public String getMusePatientFilterRegularExpression() {
		return musePatientFilterRegularExpression;
	}

	public void setMusePatientFilterRegularExpression(String musePatientFilterRegularExpression) {
		this.musePatientFilterRegularExpression = musePatientFilterRegularExpression;
	}

	public boolean isEnableSessionCache() {
		return enableSessionCache;
	}

	public void setEnableSessionCache(boolean enableSessionCache) {
		this.enableSessionCache = enableSessionCache;
	}

	@Override
	public boolean hasValueChangesToPersist(boolean autoStoreChanges) {
		if(museAPIKey.isUnencryptedAtRest()) return true;
		if(servers == null) return false;
		for(MuseServerConfiguration configuration : servers){
			if(configuration.hasValueChangesToPersist(false)) return true;
		}
		return false;
	}
}
