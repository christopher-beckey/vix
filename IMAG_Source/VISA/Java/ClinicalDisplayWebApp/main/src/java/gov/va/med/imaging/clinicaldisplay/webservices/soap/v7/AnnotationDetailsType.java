/**
 * AnnotationDetailsType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v7;

public class AnnotationDetailsType  implements java.io.Serializable {
    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType annotation;

    private java.lang.String details;

    public AnnotationDetailsType() {
    }

    public AnnotationDetailsType(
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType annotation,
           java.lang.String details) {
           this.annotation = annotation;
           this.details = details;
    }


    /**
     * Gets the annotation value for this AnnotationDetailsType.
     * 
     * @return annotation
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType getAnnotation() {
        return annotation;
    }


    /**
     * Sets the annotation value for this AnnotationDetailsType.
     * 
     * @param annotation
     */
    public void setAnnotation(gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType annotation) {
        this.annotation = annotation;
    }


    /**
     * Gets the details value for this AnnotationDetailsType.
     * 
     * @return details
     */
    public java.lang.String getDetails() {
        return details;
    }


    /**
     * Sets the details value for this AnnotationDetailsType.
     * 
     * @param details
     */
    public void setDetails(java.lang.String details) {
        this.details = details;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof AnnotationDetailsType)) return false;
        AnnotationDetailsType other = (AnnotationDetailsType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.annotation==null && other.getAnnotation()==null) || 
             (this.annotation!=null &&
              this.annotation.equals(other.getAnnotation()))) &&
            ((this.details==null && other.getDetails()==null) || 
             (this.details!=null &&
              this.details.equals(other.getDetails())));
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
        if (getAnnotation() != null) {
            _hashCode += getAnnotation().hashCode();
        }
        if (getDetails() != null) {
            _hashCode += getDetails().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(AnnotationDetailsType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "AnnotationDetailsType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("annotation");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "Annotation"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "AnnotationType"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("details");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "details"));
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
