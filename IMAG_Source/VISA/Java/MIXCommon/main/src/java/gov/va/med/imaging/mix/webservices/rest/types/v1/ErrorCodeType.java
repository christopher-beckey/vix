/**
 * ErrorCodeType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.mix.webservices.rest.types.v1;

public class ErrorCodeType implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected ErrorCodeType(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _AuthorizationException = "AuthorizationException";
    public static final java.lang.String _InvalidRequestException = "InvalidRequestException";
    public static final java.lang.String _TimeoutException = "TimeoutException";
    public static final java.lang.String _InternalException = "InternalException";
    public static final ErrorCodeType AuthorizationException = new ErrorCodeType(_AuthorizationException);
    public static final ErrorCodeType InvalidRequestException = new ErrorCodeType(_InvalidRequestException);
    public static final ErrorCodeType TimeoutException = new ErrorCodeType(_TimeoutException);
    public static final ErrorCodeType InternalException = new ErrorCodeType(_InternalException);
    public java.lang.String getValue() { return _value_;}
    public static ErrorCodeType fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        ErrorCodeType enumeration = (ErrorCodeType)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static ErrorCodeType fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(ErrorCodeType.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "ErrorCodeType"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
