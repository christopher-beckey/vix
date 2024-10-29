package gov.va.med.imaging.transactions;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "orderParameter")
@XmlAccessorType(XmlAccessType.FIELD)
public class TransactionLogQueryOrder {
    @XmlElement(name = "name")
    private String name;

    @XmlElement(name = "ascending")
    private boolean ascending;

    public TransactionLogQueryOrder() {
    }

    public TransactionLogQueryOrder(String name, boolean ascending) {
        this.name = name;
        this.ascending = ascending;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isAscending() {
        return ascending;
    }

    public void setAscending(boolean ascending) {
        this.ascending = ascending;
    }
}
