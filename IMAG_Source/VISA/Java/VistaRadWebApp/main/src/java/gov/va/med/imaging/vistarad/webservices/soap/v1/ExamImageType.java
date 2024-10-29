/**
 * ExamImageType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class ExamImageType  implements java.io.Serializable {
    private java.lang.String imageId;

    private boolean imageCached;

    private java.lang.String requestQueryString;

    public ExamImageType() {
    }

    public ExamImageType(
           java.lang.String imageId,
           boolean imageCached,
           java.lang.String requestQueryString) {
           this.imageId = imageId;
           this.imageCached = imageCached;
           this.requestQueryString = requestQueryString;
    }


    /**
     * Gets the imageId value for this ExamImageType.
     * 
     * @return imageId
     */
    public java.lang.String getImageId() {
        return imageId;
    }


    /**
     * Sets the imageId value for this ExamImageType.
     * 
     * @param imageId
     */
    public void setImageId(java.lang.String imageId) {
        this.imageId = imageId;
    }


    /**
     * Gets the imageCached value for this ExamImageType.
     * 
     * @return imageCached
     */
    public boolean isImageCached() {
        return imageCached;
    }


    /**
     * Sets the imageCached value for this ExamImageType.
     * 
     * @param imageCached
     */
    public void setImageCached(boolean imageCached) {
        this.imageCached = imageCached;
    }


    /**
     * Gets the requestQueryString value for this ExamImageType.
     * 
     * @return requestQueryString
     */
    public java.lang.String getRequestQueryString() {
        return requestQueryString;
    }


    /**
     * Sets the requestQueryString value for this ExamImageType.
     * 
     * @param requestQueryString
     */
    public void setRequestQueryString(java.lang.String requestQueryString) {
        this.requestQueryString = requestQueryString;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ExamImageType)) return false;
        ExamImageType other = (ExamImageType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.imageId==null && other.getImageId()==null) || 
             (this.imageId!=null &&
              this.imageId.equals(other.getImageId()))) &&
            this.imageCached == other.isImageCached() &&
            ((this.requestQueryString==null && other.getRequestQueryString()==null) || 
             (this.requestQueryString!=null &&
              this.requestQueryString.equals(other.getRequestQueryString())));
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
        if (getImageId() != null) {
            _hashCode += getImageId().hashCode();
        }
        _hashCode += (isImageCached() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        if (getRequestQueryString() != null) {
            _hashCode += getRequestQueryString().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ExamImageType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamImageType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "image-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageCached");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "image-cached"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("requestQueryString");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "request-query-string"));
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
