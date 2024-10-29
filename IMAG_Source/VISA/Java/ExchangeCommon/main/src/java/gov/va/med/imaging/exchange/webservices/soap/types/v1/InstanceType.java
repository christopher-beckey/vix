/**
 * InstanceType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.exchange.webservices.soap.types.v1;

public class InstanceType  implements java.io.Serializable {
    private java.lang.String imageUrn;

    private java.lang.String dicomUid;

    private java.lang.Integer dicomInstanceNumber;

    public InstanceType() {
    }

    public InstanceType(
           java.lang.String imageUrn,
           java.lang.String dicomUid,
           java.lang.Integer dicomInstanceNumber) {
           this.imageUrn = imageUrn;
           this.dicomUid = dicomUid;
           this.dicomInstanceNumber = dicomInstanceNumber;
    }


    /**
     * Gets the imageUrn value for this InstanceType.
     * 
     * @return imageUrn
     */
    public java.lang.String getImageUrn() {
        return imageUrn;
    }


    /**
     * Sets the imageUrn value for this InstanceType.
     * 
     * @param imageUrn
     */
    public void setImageUrn(java.lang.String imageUrn) {
        this.imageUrn = imageUrn;
    }


    /**
     * Gets the dicomUid value for this InstanceType.
     * 
     * @return dicomUid
     */
    public java.lang.String getDicomUid() {
        return dicomUid;
    }


    /**
     * Sets the dicomUid value for this InstanceType.
     * 
     * @param dicomUid
     */
    public void setDicomUid(java.lang.String dicomUid) {
        this.dicomUid = dicomUid;
    }


    /**
     * Gets the dicomInstanceNumber value for this InstanceType.
     * 
     * @return dicomInstanceNumber
     */
    public java.lang.Integer getDicomInstanceNumber() {
        return dicomInstanceNumber;
    }


    /**
     * Sets the dicomInstanceNumber value for this InstanceType.
     * 
     * @param dicomInstanceNumber
     */
    public void setDicomInstanceNumber(java.lang.Integer dicomInstanceNumber) {
        this.dicomInstanceNumber = dicomInstanceNumber;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof InstanceType)) return false;
        InstanceType other = (InstanceType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.imageUrn==null && other.getImageUrn()==null) || 
             (this.imageUrn!=null &&
              this.imageUrn.equals(other.getImageUrn()))) &&
            ((this.dicomUid==null && other.getDicomUid()==null) || 
             (this.dicomUid!=null &&
              this.dicomUid.equals(other.getDicomUid()))) &&
            ((this.dicomInstanceNumber==null && other.getDicomInstanceNumber()==null) || 
             (this.dicomInstanceNumber!=null &&
              this.dicomInstanceNumber.equals(other.getDicomInstanceNumber())));
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
        if (getImageUrn() != null) {
            _hashCode += getImageUrn().hashCode();
        }
        if (getDicomUid() != null) {
            _hashCode += getDicomUid().hashCode();
        }
        if (getDicomInstanceNumber() != null) {
            _hashCode += getDicomInstanceNumber().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(InstanceType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.types.soap.webservices.exchange.imaging.med.va.gov", "InstanceType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageUrn");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.types.soap.webservices.exchange.imaging.med.va.gov", "image-urn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dicomUid");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.types.soap.webservices.exchange.imaging.med.va.gov", "dicom-uid"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dicomInstanceNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.types.soap.webservices.exchange.imaging.med.va.gov", "dicom-instance-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(true);
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
