package gov.va.med.imaging.transactions;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;

@XmlType(name = "type")
@XmlEnum
public enum TransactionLogQueryParameterType {
    DO_NOT_USE,
    EQUAL_TO,
    NOT_EQUAL_TO,
    LESS_THAN,
    LESS_THAN_OR_EQUAL_TO,
    GREATER_THAN,
    GREATER_THAN_OR_EQUAL_TO,
    LIKE;

    public String value() {
        return name();
    }

    public static TransactionLogQueryParameterType fromValue(String value) {
        return valueOf(value);
    }
}
