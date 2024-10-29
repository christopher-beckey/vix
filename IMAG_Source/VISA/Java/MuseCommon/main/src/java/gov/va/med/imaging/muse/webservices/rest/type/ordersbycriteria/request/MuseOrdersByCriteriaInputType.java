package gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement (name="GetTestsByCriteriaIn")
public class MuseOrdersByCriteriaInputType 
implements Serializable{
	
	private static final long serialVersionUID = 8942192212554682184L;

	@XmlElement(name="Token", namespace="http://schemas.datacontract.org/2004/07/MUSEAPIRESTInterfaces")
	private String token = null;
	
	@XmlElement(name="criteria", type=MuseOrderCriteriaInputType.class)
	private MuseOrderCriteriaInputType criteria = null;

	public MuseOrdersByCriteriaInputType() {
	}

	/**
	 * @param token the token to set
	 */
	public void setToken(String token) {
		this.token = token;
	}


	/**
	 * @param criteria the criteria to set
	 */
	public void setCriteria(MuseOrderCriteriaInputType criteria) {
		this.criteria = criteria;
	}
	
}
