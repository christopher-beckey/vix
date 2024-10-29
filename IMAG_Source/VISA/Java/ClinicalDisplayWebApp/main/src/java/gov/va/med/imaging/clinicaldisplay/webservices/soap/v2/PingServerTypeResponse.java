/**
 * PingServerTypeResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v2;

public class PingServerTypeResponse implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected PingServerTypeResponse(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _SERVER_READY = "SERVER_READY";
    public static final java.lang.String _SERVER_UNAVAILABLE = "SERVER_UNAVAILABLE";
    public static final java.lang.String _VISTA_UNAVAILABLE = "VISTA_UNAVAILABLE";
    public static final PingServerTypeResponse SERVER_READY = new PingServerTypeResponse(_SERVER_READY);
    public static final PingServerTypeResponse SERVER_UNAVAILABLE = new PingServerTypeResponse(_SERVER_UNAVAILABLE);
    public static final PingServerTypeResponse VISTA_UNAVAILABLE = new PingServerTypeResponse(_VISTA_UNAVAILABLE);
    public java.lang.String getValue() { return _value_;}
    public static PingServerTypeResponse fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        PingServerTypeResponse enumeration = (PingServerTypeResponse)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static PingServerTypeResponse fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(PingServerTypeResponse.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">PingServerType>response"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
