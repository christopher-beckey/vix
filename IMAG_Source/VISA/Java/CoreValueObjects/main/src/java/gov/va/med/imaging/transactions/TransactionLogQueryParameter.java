package gov.va.med.imaging.transactions;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "parameter")
@XmlAccessorType(XmlAccessType.FIELD)
public class TransactionLogQueryParameter {
    @XmlElement(name = "name")
    private String name;

    @XmlElement(name = "type")
    private TransactionLogQueryParameterType type;

    @XmlElement(name = "value")
    private String value;

    public TransactionLogQueryParameter() {
    }

    public TransactionLogQueryParameter(String name, TransactionLogQueryParameterType type, String value) {
        this.name = name;
        this.type = type;
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public TransactionLogQueryParameterType getType() {
        return type;
    }

    public void setType(TransactionLogQueryParameterType type) {
        this.type = type;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
