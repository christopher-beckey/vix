/**
 * ImageAccessLogEventType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v2;

public class ImageAccessLogEventType  implements java.io.Serializable {
    private java.lang.String imageId;

    private java.lang.String patientIcn;

    private java.lang.String reason;

    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials;

    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventTypeEventType eventType;

    public ImageAccessLogEventType() {
    }

    public ImageAccessLogEventType(
           java.lang.String imageId,
           java.lang.String patientIcn,
           java.lang.String reason,
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials,
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventTypeEventType eventType) {
           this.imageId = imageId;
           this.patientIcn = patientIcn;
           this.reason = reason;
           this.credentials = credentials;
           this.eventType = eventType;
    }


    /**
     * Gets the imageId value for this ImageAccessLogEventType.
     * 
     * @return imageId
     */
    public java.lang.String getImageId() {
        return imageId;
    }


    /**
     * Sets the imageId value for this ImageAccessLogEventType.
     * 
     * @param imageId
     */
    public void setImageId(java.lang.String imageId) {
        this.imageId = imageId;
    }


    /**
     * Gets the patientIcn value for this ImageAccessLogEventType.
     * 
     * @return patientIcn
     */
    public java.lang.String getPatientIcn() {
        return patientIcn;
    }


    /**
     * Sets the patientIcn value for this ImageAccessLogEventType.
     * 
     * @param patientIcn
     */
    public void setPatientIcn(java.lang.String patientIcn) {
        this.patientIcn = patientIcn;
    }


    /**
     * Gets the reason value for this ImageAccessLogEventType.
     * 
     * @return reason
     */
    public java.lang.String getReason() {
        return reason;
    }


    /**
     * Sets the reason value for this ImageAccessLogEventType.
     * 
     * @param reason
     */
    public void setReason(java.lang.String reason) {
        this.reason = reason;
    }


    /**
     * Gets the credentials value for this ImageAccessLogEventType.
     * 
     * @return credentials
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials getCredentials() {
        return credentials;
    }


    /**
     * Sets the credentials value for this ImageAccessLogEventType.
     * 
     * @param credentials
     */
    public void setCredentials(gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) {
        this.credentials = credentials;
    }


    /**
     * Gets the eventType value for this ImageAccessLogEventType.
     * 
     * @return eventType
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventTypeEventType getEventType() {
        return eventType;
    }


    /**
     * Sets the eventType value for this ImageAccessLogEventType.
     * 
     * @param eventType
     */
    public void setEventType(gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventTypeEventType eventType) {
        this.eventType = eventType;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ImageAccessLogEventType)) return false;
        ImageAccessLogEventType other = (ImageAccessLogEventType) obj;
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
            ((this.patientIcn==null && other.getPatientIcn()==null) || 
             (this.patientIcn!=null &&
              this.patientIcn.equals(other.getPatientIcn()))) &&
            ((this.reason==null && other.getReason()==null) || 
             (this.reason!=null &&
              this.reason.equals(other.getReason()))) &&
            ((this.credentials==null && other.getCredentials()==null) || 
             (this.credentials!=null &&
              this.credentials.equals(other.getCredentials()))) &&
            ((this.eventType==null && other.getEventType()==null) || 
             (this.eventType!=null &&
              this.eventType.equals(other.getEventType())));
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
        if (getPatientIcn() != null) {
            _hashCode += getPatientIcn().hashCode();
        }
        if (getReason() != null) {
            _hashCode += getReason().hashCode();
        }
        if (getCredentials() != null) {
            _hashCode += getCredentials().hashCode();
        }
        if (getEventType() != null) {
            _hashCode += getEventType().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ImageAccessLogEventType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ImageAccessLogEventType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-Id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientIcn");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patientIcn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("reason");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "reason"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("credentials");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("eventType");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "eventType"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">ImageAccessLogEventType>eventType"));
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
