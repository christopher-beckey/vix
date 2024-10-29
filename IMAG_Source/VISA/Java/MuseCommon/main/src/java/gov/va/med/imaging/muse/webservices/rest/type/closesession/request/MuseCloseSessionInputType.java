package gov.va.med.imaging.muse.webservices.rest.type.closesession.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement (name="CloseSessionIn")
public class MuseCloseSessionInputType 
implements Serializable{
	
	private static final long serialVersionUID = 442651337901247774L;
	
	@XmlElement(name="Token", namespace="http://schemas.datacontract.org/2004/07/MUSEAPIRESTInterfaces")
	private String token = null;

	/**
	 * @param token the token to set
	 */
	public void setToken(String token) {
		this.token = token;
	}
}
