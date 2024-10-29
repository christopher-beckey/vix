package gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name="QueryCriterionOfTest1hDOM8Xe", namespace="http://schemas.datacontract.org/2004/07/MUSEAPIData")
public class MuseOrderQueryCriteriaInputType 
implements Serializable{
	
	private static final long serialVersionUID = -4172248457680869289L;

	@XmlElement(name="Comparison")
	private String comparison = null;
	
	@XmlElement(name="Field")
	private String field = null;
	
	@XmlElement(name="QueriableTypeStr")
	private String queriableTypeStr = null;
	

	@XmlElement(name="Value", type=Object.class)
	private Object value = null;
	
	
	public MuseOrderQueryCriteriaInputType() {
	}


	/**
	 * @param comparison the comparison to set
	 */
	public void setComparison(String comparison) {
		this.comparison = comparison;
	}

	/**
	 * @param field the field to set
	 */
	public void setField(String field) {
		this.field = field;
	}

	/**
	 * @param queriableTypeStr the queriableTypeStr to set
	 */
	public void setQueriableTypeStr(String queriableTypeStr) {
		this.queriableTypeStr = queriableTypeStr;
	}

	/**
	 * @param value the value to set
	 */
	public void setValue(Object value) {
		this.value = value;
	}	
}
