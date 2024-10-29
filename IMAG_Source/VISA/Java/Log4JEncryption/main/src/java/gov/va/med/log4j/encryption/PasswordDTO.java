package gov.va.med.log4j.encryption;

public class PasswordDTO {
	
	public String userPassword;
	public String shareUserPassword;
	public String defaultMusePassword;
	public String fileSystemCacheConfigurator;
	public String sqlCacheConnectionPassword;
	
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	public String getShareUserPassword() {
		return shareUserPassword;
	}
	public void setShareUserPassword(String shareUserPassword) {
		this.shareUserPassword = shareUserPassword;
	}
	public String getDefaultMusePassword() {
		return defaultMusePassword;
	}
	public void setDefaultMusePassword(String defaultMusePassword) {
		this.defaultMusePassword = defaultMusePassword;
	}
	public String getFileSystemCacheConfigurator() {
		return fileSystemCacheConfigurator;
	}
	public void setFileSystemCacheConfigurator(String fileSystemCacheConfigurator) {
		this.fileSystemCacheConfigurator = fileSystemCacheConfigurator;
	}
	public String getSqlCacheConnectionPassword() {
		return sqlCacheConnectionPassword;
	}
	public void setSqlCacheConnectionPassword(String sqlCacheConnectionPassword) {
		this.sqlCacheConnectionPassword = sqlCacheConnectionPassword;
	}
}
