package gov.va.med.imaging.exchange.business;



public class MuseOpenSessionResults {
	
	private String ErrorMessage = null;
	private String Exception = null;
	private String Status = null;
	private String BinaryToken = null;
	private String Expiration = null;
	private String Password = null;
	private String SiteNumber = null;
	private String UserName = null;

	
	public MuseOpenSessionResults(){
		
	}


	/**
	 * @return the errorMessage
	 */
	public String getErrorMessage() {
		return ErrorMessage;
	}


	/**
	 * @param errorMessage the errorMessage to set
	 */
	public void setErrorMessage(String errorMessage) {
		ErrorMessage = errorMessage;
	}


	/**
	 * @return the exception
	 */
	public String getException() {
		return Exception;
	}


	/**
	 * @param exception the exception to set
	 */
	public void setException(String exception) {
		Exception = exception;
	}


	/**
	 * @return the status
	 */
	public String getStatus() {
		return Status;
	}


	/**
	 * @param status the status to set
	 */
	public void setStatus(String status) {
		Status = status;
	}


	/**
	 * @return the binaryToken
	 */
	public String getBinaryToken() {
		return BinaryToken;
	}


	/**
	 * @param binaryToken the binaryToken to set
	 */
	public void setBinaryToken(String binaryToken) {
		BinaryToken = binaryToken;
	}


	/**
	 * @return the expiration
	 */
	public String getExpiration() {
		return Expiration;
	}


	/**
	 * @param expiration the expiration to set
	 */
	public void setExpiration(String expiration) {
		Expiration = expiration;
	}


	/**
	 * @return the password
	 */
	public String getPassword() {
		return Password;
	}


	/**
	 * @param password the password to set
	 */
	public void setPassword(String password) {
		Password = password;
	}


	/**
	 * @return the siteNumber
	 */
	public String getSiteNumber() {
		return SiteNumber;
	}


	/**
	 * @param siteNumber the siteNumber to set
	 */
	public void setSiteNumber(String siteNumber) {
		SiteNumber = siteNumber;
	}


	/**
	 * @return the userName
	 */
	public String getUserName() {
		return UserName;
	}


	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName) {
		UserName = userName;
	}
	
	

}
