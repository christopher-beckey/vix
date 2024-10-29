/**
 * ImageAccessLogEventType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v6;

public class ImageAccessLogEventType  implements java.io.Serializable {
    private java.lang.String id;

    private java.lang.String patientIcn;

    private java.lang.String reasonCode;

    private java.lang.String reasonDescription;

    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials;

    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ImageAccessLogEventTypeEventType eventType;

    public ImageAccessLogEventType() {
    }

    public ImageAccessLogEventType(
           java.lang.String id,
           java.lang.String patientIcn,
           java.lang.String reasonCode,
           java.lang.String reasonDescription,
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials,
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ImageAccessLogEventTypeEventType eventType) {
           this.id = id;
           this.patientIcn = patientIcn;
           this.reasonCode = reasonCode;
           this.reasonDescription = reasonDescription;
           this.credentials = credentials;
           this.eventType = eventType;
    }


    /**
     * Gets the id value for this ImageAccessLogEventType.
     * 
     * @return id
     */
    public java.lang.String getId() {
        return id;
    }


    /**
     * Sets the id value for this ImageAccessLogEventType.
     * 
     * @param id
     */
    public void setId(java.lang.String id) {
        this.id = id;
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
     * Gets the reasonCode value for this ImageAccessLogEventType.
     * 
     * @return reasonCode
     */
    public java.lang.String getReasonCode() {
        return reasonCode;
    }


    /**
     * Sets the reasonCode value for this ImageAccessLogEventType.
     * 
     * @param reasonCode
     */
    public void setReasonCode(java.lang.String reasonCode) {
        this.reasonCode = reasonCode;
    }


    /**
     * Gets the reasonDescription value for this ImageAccessLogEventType.
     * 
     * @return reasonDescription
     */
    public java.lang.String getReasonDescription() {
        return reasonDescription;
    }


    /**
     * Sets the reasonDescription value for this ImageAccessLogEventType.
     * 
     * @param reasonDescription
     */
    public void setReasonDescription(java.lang.String reasonDescription) {
        this.reasonDescription = reasonDescription;
    }


    /**
     * Gets the credentials value for this ImageAccessLogEventType.
     * 
     * @return credentials
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType getCredentials() {
        return credentials;
    }


    /**
     * Sets the credentials value for this ImageAccessLogEventType.
     * 
     * @param credentials
     */
    public void setCredentials(gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials) {
        this.credentials = credentials;
    }


    /**
     * Gets the eventType value for this ImageAccessLogEventType.
     * 
     * @return eventType
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ImageAccessLogEventTypeEventType getEventType() {
        return eventType;
    }


    /**
     * Sets the eventType value for this ImageAccessLogEventType.
     * 
     * @param eventType
     */
    public void setEventType(gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ImageAccessLogEventTypeEventType eventType) {
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
            ((this.id==null && other.getId()==null) || 
             (this.id!=null &&
              this.id.equals(other.getId()))) &&
            ((this.patientIcn==null && other.getPatientIcn()==null) || 
             (this.patientIcn!=null &&
              this.patientIcn.equals(other.getPatientIcn()))) &&
            ((this.reasonCode==null && other.getReasonCode()==null) || 
             (this.reasonCode!=null &&
              this.reasonCode.equals(other.getReasonCode()))) &&
            ((this.reasonDescription==null && other.getReasonDescription()==null) || 
             (this.reasonDescription!=null &&
              this.reasonDescription.equals(other.getReasonDescription()))) &&
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
        if (getId() != null) {
            _hashCode += getId().hashCode();
        }
        if (getPatientIcn() != null) {
            _hashCode += getPatientIcn().hashCode();
        }
        if (getReasonCode() != null) {
            _hashCode += getReasonCode().hashCode();
        }
        if (getReasonDescription() != null) {
            _hashCode += getReasonDescription().hashCode();
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
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ImageAccessLogEventType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("id");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientIcn");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patientIcn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("reasonCode");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "reason-code"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("reasonDescription");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "reason-description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("credentials");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("eventType");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "eventType"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">ImageAccessLogEventType>eventType"));
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
