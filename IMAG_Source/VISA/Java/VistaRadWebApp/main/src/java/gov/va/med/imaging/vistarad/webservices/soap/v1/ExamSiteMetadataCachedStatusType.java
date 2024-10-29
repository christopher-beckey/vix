/**
 * ExamSiteMetadataCachedStatusType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class ExamSiteMetadataCachedStatusType  implements java.io.Serializable {
    private java.lang.String siteNumber;

    private java.lang.String patientIcn;

    private boolean isCached;

    public ExamSiteMetadataCachedStatusType() {
    }

    public ExamSiteMetadataCachedStatusType(
           java.lang.String siteNumber,
           java.lang.String patientIcn,
           boolean isCached) {
           this.siteNumber = siteNumber;
           this.patientIcn = patientIcn;
           this.isCached = isCached;
    }


    /**
     * Gets the siteNumber value for this ExamSiteMetadataCachedStatusType.
     * 
     * @return siteNumber
     */
    public java.lang.String getSiteNumber() {
        return siteNumber;
    }


    /**
     * Sets the siteNumber value for this ExamSiteMetadataCachedStatusType.
     * 
     * @param siteNumber
     */
    public void setSiteNumber(java.lang.String siteNumber) {
        this.siteNumber = siteNumber;
    }


    /**
     * Gets the patientIcn value for this ExamSiteMetadataCachedStatusType.
     * 
     * @return patientIcn
     */
    public java.lang.String getPatientIcn() {
        return patientIcn;
    }


    /**
     * Sets the patientIcn value for this ExamSiteMetadataCachedStatusType.
     * 
     * @param patientIcn
     */
    public void setPatientIcn(java.lang.String patientIcn) {
        this.patientIcn = patientIcn;
    }


    /**
     * Gets the isCached value for this ExamSiteMetadataCachedStatusType.
     * 
     * @return isCached
     */
    public boolean isIsCached() {
        return isCached;
    }


    /**
     * Sets the isCached value for this ExamSiteMetadataCachedStatusType.
     * 
     * @param isCached
     */
    public void setIsCached(boolean isCached) {
        this.isCached = isCached;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ExamSiteMetadataCachedStatusType)) return false;
        ExamSiteMetadataCachedStatusType other = (ExamSiteMetadataCachedStatusType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.siteNumber==null && other.getSiteNumber()==null) || 
             (this.siteNumber!=null &&
              this.siteNumber.equals(other.getSiteNumber()))) &&
            ((this.patientIcn==null && other.getPatientIcn()==null) || 
             (this.patientIcn!=null &&
              this.patientIcn.equals(other.getPatientIcn()))) &&
            this.isCached == other.isIsCached();
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
        if (getSiteNumber() != null) {
            _hashCode += getSiteNumber().hashCode();
        }
        if (getPatientIcn() != null) {
            _hashCode += getPatientIcn().hashCode();
        }
        _hashCode += (isIsCached() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ExamSiteMetadataCachedStatusType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamSiteMetadataCachedStatusType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientIcn");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "patient-icn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("isCached");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "is-cached"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
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
