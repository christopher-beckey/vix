package gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name="criteria")
public class MuseOrderCriteriaInputType 
implements Serializable{
	
	private static final long serialVersionUID = -243193305419770277L;

	@XmlElement(name="QueryCriterionOfTest1hDOM8Xe", type=MuseOrderQueryCriteriaInputType.class, namespace="http://schemas.datacontract.org/2004/07/MUSEAPIData")
	private MuseOrderQueryCriteriaInputType query = null;
	
	
	public MuseOrderCriteriaInputType() {
	}

	/**
	 * @param query the query to set
	 */
	public void setQuery(MuseOrderQueryCriteriaInputType query) {
		this.query = query;
	}

}
