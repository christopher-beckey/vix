/**
 * ImageAccessLogEventTypeEventType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v5;

public class ImageAccessLogEventTypeEventType implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected ImageAccessLogEventTypeEventType(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _IMAGE_ACCESS = "IMAGE_ACCESS";
    public static final java.lang.String _IMAGE_COPY = "IMAGE_COPY";
    public static final java.lang.String _IMAGE_PRINT = "IMAGE_PRINT";
    public static final java.lang.String _PATIENT_ID_MISMATCH = "PATIENT_ID_MISMATCH";
    public static final java.lang.String _LOG_RESTRICTED_ACCESS = "LOG_RESTRICTED_ACCESS";
    public static final ImageAccessLogEventTypeEventType IMAGE_ACCESS = new ImageAccessLogEventTypeEventType(_IMAGE_ACCESS);
    public static final ImageAccessLogEventTypeEventType IMAGE_COPY = new ImageAccessLogEventTypeEventType(_IMAGE_COPY);
    public static final ImageAccessLogEventTypeEventType IMAGE_PRINT = new ImageAccessLogEventTypeEventType(_IMAGE_PRINT);
    public static final ImageAccessLogEventTypeEventType PATIENT_ID_MISMATCH = new ImageAccessLogEventTypeEventType(_PATIENT_ID_MISMATCH);
    public static final ImageAccessLogEventTypeEventType LOG_RESTRICTED_ACCESS = new ImageAccessLogEventTypeEventType(_LOG_RESTRICTED_ACCESS);
    public java.lang.String getValue() { return _value_;}
    public static ImageAccessLogEventTypeEventType fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        ImageAccessLogEventTypeEventType enumeration = (ImageAccessLogEventTypeEventType)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static ImageAccessLogEventTypeEventType fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(ImageAccessLogEventTypeEventType.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">ImageAccessLogEventType>eventType"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
