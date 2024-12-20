/**
 * FederationStudyLoadLevelType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.federation.webservices.types.v3;

public class FederationStudyLoadLevelType implements java.io.Serializable {
    private java.lang.String _value_;
    private static java.util.HashMap _table_ = new java.util.HashMap();

    // Constructor
    protected FederationStudyLoadLevelType(java.lang.String value) {
        _value_ = value;
        _table_.put(_value_,this);
    }

    public static final java.lang.String _STUDY_ONLY = "STUDY_ONLY";
    public static final java.lang.String _STUDY_AND_REPORT = "STUDY_AND_REPORT";
    public static final java.lang.String _STUDY_AND_IMAGES_NO_REPORT = "STUDY_AND_IMAGES_NO_REPORT";
    public static final java.lang.String _FULL = "FULL";
    public static final FederationStudyLoadLevelType STUDY_ONLY = new FederationStudyLoadLevelType(_STUDY_ONLY);
    public static final FederationStudyLoadLevelType STUDY_AND_REPORT = new FederationStudyLoadLevelType(_STUDY_AND_REPORT);
    public static final FederationStudyLoadLevelType STUDY_AND_IMAGES_NO_REPORT = new FederationStudyLoadLevelType(_STUDY_AND_IMAGES_NO_REPORT);
    public static final FederationStudyLoadLevelType FULL = new FederationStudyLoadLevelType(_FULL);
    public java.lang.String getValue() { return _value_;}
    public static FederationStudyLoadLevelType fromValue(java.lang.String value)
          throws java.lang.IllegalArgumentException {
        FederationStudyLoadLevelType enumeration = (FederationStudyLoadLevelType)
            _table_.get(value);
        if (enumeration==null) throw new java.lang.IllegalArgumentException();
        return enumeration;
    }
    public static FederationStudyLoadLevelType fromString(java.lang.String value)
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
        new org.apache.axis.description.TypeDesc(FederationStudyLoadLevelType.class);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationStudyLoadLevelType"));
    }
    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

}
