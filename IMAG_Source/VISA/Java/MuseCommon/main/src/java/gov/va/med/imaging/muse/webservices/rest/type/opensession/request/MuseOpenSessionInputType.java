package gov.va.med.imaging.muse.webservices.rest.type.opensession.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement (name="OpenSessionIn")
public class MuseOpenSessionInputType 
implements Serializable{
	
	private static final long serialVersionUID = 7678630870411835829L;

	@XmlElement(name="password")
	private String password = null;
	
	@XmlElement(name="siteNumber")
	private String siteNumber = null;
	
	@XmlElement(name="userName")
	private String userName = null;
	
	public MuseOpenSessionInputType(){
		
	}

	/**
	 * @param password the password to set
	 */
	public void setPassword(String password) {
		this.password = password;
	}

	/**
	 * @param siteNumber the siteNumber to set
	 */
	public void setSiteNumber(String siteNumber) {
		this.siteNumber = siteNumber;
	}

	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}	
}
