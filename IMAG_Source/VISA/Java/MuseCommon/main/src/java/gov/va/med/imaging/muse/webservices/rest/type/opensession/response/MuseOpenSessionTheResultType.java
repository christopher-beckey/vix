package gov.va.med.imaging.muse.webservices.rest.type.opensession.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name="TheResult")
public class MuseOpenSessionTheResultType 
implements Serializable{
	
	private static final long serialVersionUID = 4540848110028010930L;

	@XmlElement(name="BinaryToken")
	private String binaryToken = null;
	
	@XmlElement(name="Expiration")
	private String expiration = null;

	@XmlElement(name="Password")
	private String password = null;
	
	@XmlElement(name="SiteNumber")
	private String siteNumber = null;
	
	@XmlElement(name="UserName")
	private String userName = null;

	/**
	 * @return the binaryToken
	 */
	public String getBinaryToken() {
		return binaryToken;
	}

	/**
	 * @return the expiration
	 */
	public String getExpiration() {
		return expiration;
	}

	/**
	 * @return the password
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * @return the siteNumber
	 */
	public String getSiteNumber() {
		return siteNumber;
	}

	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}
}
