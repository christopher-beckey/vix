/**
 * ExamTypeDetails.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class ExamTypeDetails  implements java.io.Serializable {
    private java.lang.String examId;

    private java.lang.String headerString1;

    private java.lang.String headerString2;

    private java.lang.String rawString;

    private int imageCount;

    private java.lang.String patientIcn;

    private java.lang.String siteNumber;

    private java.lang.String siteName;

    private java.lang.String siteAbbreviation;

    private java.lang.String modality;

    private java.lang.String cptCode;

    private boolean allImagesCached;

    public ExamTypeDetails() {
    }

    public ExamTypeDetails(
           java.lang.String examId,
           java.lang.String headerString1,
           java.lang.String headerString2,
           java.lang.String rawString,
           int imageCount,
           java.lang.String patientIcn,
           java.lang.String siteNumber,
           java.lang.String siteName,
           java.lang.String siteAbbreviation,
           java.lang.String modality,
           java.lang.String cptCode,
           boolean allImagesCached) {
           this.examId = examId;
           this.headerString1 = headerString1;
           this.headerString2 = headerString2;
           this.rawString = rawString;
           this.imageCount = imageCount;
           this.patientIcn = patientIcn;
           this.siteNumber = siteNumber;
           this.siteName = siteName;
           this.siteAbbreviation = siteAbbreviation;
           this.modality = modality;
           this.cptCode = cptCode;
           this.allImagesCached = allImagesCached;
    }


    /**
     * Gets the examId value for this ExamTypeDetails.
     * 
     * @return examId
     */
    public java.lang.String getExamId() {
        return examId;
    }


    /**
     * Sets the examId value for this ExamTypeDetails.
     * 
     * @param examId
     */
    public void setExamId(java.lang.String examId) {
        this.examId = examId;
    }


    /**
     * Gets the headerString1 value for this ExamTypeDetails.
     * 
     * @return headerString1
     */
    public java.lang.String getHeaderString1() {
        return headerString1;
    }


    /**
     * Sets the headerString1 value for this ExamTypeDetails.
     * 
     * @param headerString1
     */
    public void setHeaderString1(java.lang.String headerString1) {
        this.headerString1 = headerString1;
    }


    /**
     * Gets the headerString2 value for this ExamTypeDetails.
     * 
     * @return headerString2
     */
    public java.lang.String getHeaderString2() {
        return headerString2;
    }


    /**
     * Sets the headerString2 value for this ExamTypeDetails.
     * 
     * @param headerString2
     */
    public void setHeaderString2(java.lang.String headerString2) {
        this.headerString2 = headerString2;
    }


    /**
     * Gets the rawString value for this ExamTypeDetails.
     * 
     * @return rawString
     */
    public java.lang.String getRawString() {
        return rawString;
    }


    /**
     * Sets the rawString value for this ExamTypeDetails.
     * 
     * @param rawString
     */
    public void setRawString(java.lang.String rawString) {
        this.rawString = rawString;
    }


    /**
     * Gets the imageCount value for this ExamTypeDetails.
     * 
     * @return imageCount
     */
    public int getImageCount() {
        return imageCount;
    }


    /**
     * Sets the imageCount value for this ExamTypeDetails.
     * 
     * @param imageCount
     */
    public void setImageCount(int imageCount) {
        this.imageCount = imageCount;
    }


    /**
     * Gets the patientIcn value for this ExamTypeDetails.
     * 
     * @return patientIcn
     */
    public java.lang.String getPatientIcn() {
        return patientIcn;
    }


    /**
     * Sets the patientIcn value for this ExamTypeDetails.
     * 
     * @param patientIcn
     */
    public void setPatientIcn(java.lang.String patientIcn) {
        this.patientIcn = patientIcn;
    }


    /**
     * Gets the siteNumber value for this ExamTypeDetails.
     * 
     * @return siteNumber
     */
    public java.lang.String getSiteNumber() {
        return siteNumber;
    }


    /**
     * Sets the siteNumber value for this ExamTypeDetails.
     * 
     * @param siteNumber
     */
    public void setSiteNumber(java.lang.String siteNumber) {
        this.siteNumber = siteNumber;
    }


    /**
     * Gets the siteName value for this ExamTypeDetails.
     * 
     * @return siteName
     */
    public java.lang.String getSiteName() {
        return siteName;
    }


    /**
     * Sets the siteName value for this ExamTypeDetails.
     * 
     * @param siteName
     */
    public void setSiteName(java.lang.String siteName) {
        this.siteName = siteName;
    }


    /**
     * Gets the siteAbbreviation value for this ExamTypeDetails.
     * 
     * @return siteAbbreviation
     */
    public java.lang.String getSiteAbbreviation() {
        return siteAbbreviation;
    }


    /**
     * Sets the siteAbbreviation value for this ExamTypeDetails.
     * 
     * @param siteAbbreviation
     */
    public void setSiteAbbreviation(java.lang.String siteAbbreviation) {
        this.siteAbbreviation = siteAbbreviation;
    }


    /**
     * Gets the modality value for this ExamTypeDetails.
     * 
     * @return modality
     */
    public java.lang.String getModality() {
        return modality;
    }


    /**
     * Sets the modality value for this ExamTypeDetails.
     * 
     * @param modality
     */
    public void setModality(java.lang.String modality) {
        this.modality = modality;
    }


    /**
     * Gets the cptCode value for this ExamTypeDetails.
     * 
     * @return cptCode
     */
    public java.lang.String getCptCode() {
        return cptCode;
    }


    /**
     * Sets the cptCode value for this ExamTypeDetails.
     * 
     * @param cptCode
     */
    public void setCptCode(java.lang.String cptCode) {
        this.cptCode = cptCode;
    }


    /**
     * Gets the allImagesCached value for this ExamTypeDetails.
     * 
     * @return allImagesCached
     */
    public boolean isAllImagesCached() {
        return allImagesCached;
    }


    /**
     * Sets the allImagesCached value for this ExamTypeDetails.
     * 
     * @param allImagesCached
     */
    public void setAllImagesCached(boolean allImagesCached) {
        this.allImagesCached = allImagesCached;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ExamTypeDetails)) return false;
        ExamTypeDetails other = (ExamTypeDetails) obj;
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
            ((this.headerString1==null && other.getHeaderString1()==null) || 
             (this.headerString1!=null &&
              this.headerString1.equals(other.getHeaderString1()))) &&
            ((this.headerString2==null && other.getHeaderString2()==null) || 
             (this.headerString2!=null &&
              this.headerString2.equals(other.getHeaderString2()))) &&
            ((this.rawString==null && other.getRawString()==null) || 
             (this.rawString!=null &&
              this.rawString.equals(other.getRawString()))) &&
            this.imageCount == other.getImageCount() &&
            ((this.patientIcn==null && other.getPatientIcn()==null) || 
             (this.patientIcn!=null &&
              this.patientIcn.equals(other.getPatientIcn()))) &&
            ((this.siteNumber==null && other.getSiteNumber()==null) || 
             (this.siteNumber!=null &&
              this.siteNumber.equals(other.getSiteNumber()))) &&
            ((this.siteName==null && other.getSiteName()==null) || 
             (this.siteName!=null &&
              this.siteName.equals(other.getSiteName()))) &&
            ((this.siteAbbreviation==null && other.getSiteAbbreviation()==null) || 
             (this.siteAbbreviation!=null &&
              this.siteAbbreviation.equals(other.getSiteAbbreviation()))) &&
            ((this.modality==null && other.getModality()==null) || 
             (this.modality!=null &&
              this.modality.equals(other.getModality()))) &&
            ((this.cptCode==null && other.getCptCode()==null) || 
             (this.cptCode!=null &&
              this.cptCode.equals(other.getCptCode()))) &&
            this.allImagesCached == other.isAllImagesCached();
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
        if (getHeaderString1() != null) {
            _hashCode += getHeaderString1().hashCode();
        }
        if (getHeaderString2() != null) {
            _hashCode += getHeaderString2().hashCode();
        }
        if (getRawString() != null) {
            _hashCode += getRawString().hashCode();
        }
        _hashCode += getImageCount();
        if (getPatientIcn() != null) {
            _hashCode += getPatientIcn().hashCode();
        }
        if (getSiteNumber() != null) {
            _hashCode += getSiteNumber().hashCode();
        }
        if (getSiteName() != null) {
            _hashCode += getSiteName().hashCode();
        }
        if (getSiteAbbreviation() != null) {
            _hashCode += getSiteAbbreviation().hashCode();
        }
        if (getModality() != null) {
            _hashCode += getModality().hashCode();
        }
        if (getCptCode() != null) {
            _hashCode += getCptCode().hashCode();
        }
        _hashCode += (isAllImagesCached() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ExamTypeDetails.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamTypeDetails"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("examId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("headerString1");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "header-string-1"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("headerString2");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "header-string-2"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("rawString");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "raw-string"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageCount");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "image-count"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientIcn");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "patient-icn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteName");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site-name"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteAbbreviation");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site-abbreviation"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("modality");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "modality"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("cptCode");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "cpt-code"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("allImagesCached");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "all-images-cached"));
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
