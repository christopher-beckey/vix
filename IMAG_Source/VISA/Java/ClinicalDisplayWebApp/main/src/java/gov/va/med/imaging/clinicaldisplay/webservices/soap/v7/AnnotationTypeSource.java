/**
 * AnnotationTypeSource.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v7;

public class AnnotationTypeSource implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected AnnotationTypeSource(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _ClinicalDisplay = "ClinicalDisplay";
    public static final java.lang.String _VistARad = "VistARad";
    public static final java.lang.String _ClinicalCapture = "ClinicalCapture";
    public static final AnnotationTypeSource ClinicalDisplay = new AnnotationTypeSource(_ClinicalDisplay);
    public static final AnnotationTypeSource VistARad = new AnnotationTypeSource(_VistARad);
    public static final AnnotationTypeSource ClinicalCapture = new AnnotationTypeSource(_ClinicalCapture);
    public java.lang.String getValue() { return _value_;}
    public static AnnotationTypeSource fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        AnnotationTypeSource enumeration = (AnnotationTypeSource)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static AnnotationTypeSource fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(AnnotationTypeSource.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">AnnotationType>source"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
