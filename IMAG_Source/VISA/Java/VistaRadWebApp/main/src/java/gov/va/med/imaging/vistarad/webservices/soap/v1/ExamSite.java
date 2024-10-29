/**
 * ExamSite.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class ExamSite  implements java.io.Serializable {
    private gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteStatus status;

    private java.lang.String siteNumber;

    private java.lang.String siteName;

    private gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType[] exam;

    public ExamSite() {
    }

    public ExamSite(
           gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteStatus status,
           java.lang.String siteNumber,
           java.lang.String siteName,
           gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType[] exam) {
           this.status = status;
           this.siteNumber = siteNumber;
           this.siteName = siteName;
           this.exam = exam;
    }


    /**
     * Gets the status value for this ExamSite.
     * 
     * @return status
     */
    public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteStatus getStatus() {
        return status;
    }


    /**
     * Sets the status value for this ExamSite.
     * 
     * @param status
     */
    public void setStatus(gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteStatus status) {
        this.status = status;
    }


    /**
     * Gets the siteNumber value for this ExamSite.
     * 
     * @return siteNumber
     */
    public java.lang.String getSiteNumber() {
        return siteNumber;
    }


    /**
     * Sets the siteNumber value for this ExamSite.
     * 
     * @param siteNumber
     */
    public void setSiteNumber(java.lang.String siteNumber) {
        this.siteNumber = siteNumber;
    }


    /**
     * Gets the siteName value for this ExamSite.
     * 
     * @return siteName
     */
    public java.lang.String getSiteName() {
        return siteName;
    }


    /**
     * Sets the siteName value for this ExamSite.
     * 
     * @param siteName
     */
    public void setSiteName(java.lang.String siteName) {
        this.siteName = siteName;
    }


    /**
     * Gets the exam value for this ExamSite.
     * 
     * @return exam
     */
    public gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType[] getExam() {
        return exam;
    }


    /**
     * Sets the exam value for this ExamSite.
     * 
     * @param exam
     */
    public void setExam(gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType[] exam) {
        this.exam = exam;
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType getExam(int i) {
        return this.exam[i];
    }

    public void setExam(int i, gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType _value) {
        this.exam[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ExamSite)) return false;
        ExamSite other = (ExamSite) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.status==null && other.getStatus()==null) || 
             (this.status!=null &&
              this.status.equals(other.getStatus()))) &&
            ((this.siteNumber==null && other.getSiteNumber()==null) || 
             (this.siteNumber!=null &&
              this.siteNumber.equals(other.getSiteNumber()))) &&
            ((this.siteName==null && other.getSiteName()==null) || 
             (this.siteName!=null &&
              this.siteName.equals(other.getSiteName()))) &&
            ((this.exam==null && other.getExam()==null) || 
             (this.exam!=null &&
              java.util.Arrays.equals(this.exam, other.getExam())));
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
        if (getStatus() != null) {
            _hashCode += getStatus().hashCode();
        }
        if (getSiteNumber() != null) {
            _hashCode += getSiteNumber().hashCode();
        }
        if (getSiteName() != null) {
            _hashCode += getSiteName().hashCode();
        }
        if (getExam() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getExam());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getExam(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ExamSite.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamSite"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("status");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "status"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", ">ExamSite>status"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "siteNumber"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteName");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "siteName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("exam");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ShallowExamType"));
        elemField.setNillable(true);
        elemField.setMaxOccursUnbounded(true);
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
