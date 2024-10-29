/**
 * ActiveWorklistItemType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class ActiveWorklistItemType  implements java.io.Serializable {
    private java.lang.String examId;

    private java.lang.String rawString;

    public ActiveWorklistItemType() {
    }

    public ActiveWorklistItemType(
           java.lang.String examId,
           java.lang.String rawString) {
           this.examId = examId;
           this.rawString = rawString;
    }


    /**
     * Gets the examId value for this ActiveWorklistItemType.
     * 
     * @return examId
     */
    public java.lang.String getExamId() {
        return examId;
    }


    /**
     * Sets the examId value for this ActiveWorklistItemType.
     * 
     * @param examId
     */
    public void setExamId(java.lang.String examId) {
        this.examId = examId;
    }


    /**
     * Gets the rawString value for this ActiveWorklistItemType.
     * 
     * @return rawString
     */
    public java.lang.String getRawString() {
        return rawString;
    }


    /**
     * Sets the rawString value for this ActiveWorklistItemType.
     * 
     * @param rawString
     */
    public void setRawString(java.lang.String rawString) {
        this.rawString = rawString;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ActiveWorklistItemType)) return false;
        ActiveWorklistItemType other = (ActiveWorklistItemType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.examId==null && other.getExamId()==null) || 
             (this.examId!=null &&
              this.examId.equals(other.getExamId()))) &&
            ((this.rawString==null && other.getRawString()==null) || 
             (this.rawString!=null &&
              this.rawString.equals(other.getRawString())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getExamId() != null) {
            _hashCode += getExamId().hashCode();
        }
        if (getRawString() != null) {
            _hashCode += getRawString().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ActiveWorklistItemType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ActiveWorklistItemType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("examId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("rawString");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "rawString"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
