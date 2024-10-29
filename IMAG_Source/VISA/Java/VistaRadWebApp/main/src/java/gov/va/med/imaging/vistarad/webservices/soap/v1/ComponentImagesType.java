/**
 * ComponentImagesType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class ComponentImagesType  implements java.io.Serializable {
    private gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType[] images;

    private java.lang.String headerString;

    public ComponentImagesType() {
    }

    public ComponentImagesType(
           gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType[] images,
           java.lang.String headerString) {
           this.images = images;
           this.headerString = headerString;
    }


    /**
     * Gets the images value for this ComponentImagesType.
     * 
     * @return images
     */
    public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType[] getImages() {
        return images;
    }


    /**
     * Sets the images value for this ComponentImagesType.
     * 
     * @param images
     */
    public void setImages(gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType[] images) {
        this.images = images;
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType getImages(int i) {
        return this.images[i];
    }

    public void setImages(int i, gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType _value) {
        this.images[i] = _value;
    }


    /**
     * Gets the headerString value for this ComponentImagesType.
     * 
     * @return headerString
     */
    public java.lang.String getHeaderString() {
        return headerString;
    }


    /**
     * Sets the headerString value for this ComponentImagesType.
     * 
     * @param headerString
     */
    public void setHeaderString(java.lang.String headerString) {
        this.headerString = headerString;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ComponentImagesType)) return false;
        ComponentImagesType other = (ComponentImagesType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.images==null && other.getImages()==null) || 
             (this.images!=null &&
              java.util.Arrays.equals(this.images, other.getImages()))) &&
            ((this.headerString==null && other.getHeaderString()==null) || 
             (this.headerString!=null &&
              this.headerString.equals(other.getHeaderString())));
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
        if (getImages() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getImages());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getImages(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getHeaderString() != null) {
            _hashCode += getHeaderString().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ComponentImagesType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ComponentImagesType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("images");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "images"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamImageType"));
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("headerString");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "header-string"));
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
