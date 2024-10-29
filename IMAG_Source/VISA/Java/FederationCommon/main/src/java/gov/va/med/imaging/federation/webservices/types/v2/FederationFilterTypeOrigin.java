/**
 * FederationFilterTypeOrigin.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.federation.webservices.types.v2;

public class FederationFilterTypeOrigin implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected FederationFilterTypeOrigin(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _value1 = "UNSPECIFIED";
    public static final java.lang.String _value2 = "VA";
    public static final java.lang.String _value3 = "NON-VA";
    public static final java.lang.String _value4 = "DOD";
    public static final java.lang.String _value5 = "FEE";
    public static final FederationFilterTypeOrigin value1 = new FederationFilterTypeOrigin(_value1);
    public static final FederationFilterTypeOrigin value2 = new FederationFilterTypeOrigin(_value2);
    public static final FederationFilterTypeOrigin value3 = new FederationFilterTypeOrigin(_value3);
    public static final FederationFilterTypeOrigin value4 = new FederationFilterTypeOrigin(_value4);
    public static final FederationFilterTypeOrigin value5 = new FederationFilterTypeOrigin(_value5);
    public java.lang.String getValue() { return _value_;}
    public static FederationFilterTypeOrigin fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        FederationFilterTypeOrigin enumeration = (FederationFilterTypeOrigin)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static FederationFilterTypeOrigin fromString(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        return fromValue(value);
    }
    public boolean equals(java.lang.Object obj) {return (obj == this);}
    public int hashCode() { return toString().hashCode();}
    public java.lang.String toString() { return _value_;}
    public java.lang.Object readResolve() throws java.io.ObjectStreamException { return fromValue(_value_);}
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new org.apache.axis.encoding.ser.EnumSerializer(
            _javaType, _xmlType);
    }
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new org.apache.axis.encoding.ser.EnumDeserializer(
            _javaType, _xmlType);
    }
    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(FederationFilterTypeOrigin.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", ">FederationFilterType>origin"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
