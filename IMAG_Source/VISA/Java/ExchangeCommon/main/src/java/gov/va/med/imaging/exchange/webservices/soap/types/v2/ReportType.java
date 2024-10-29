/**
 * ReportType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.exchange.webservices.soap.types.v2;

public class ReportType  implements java.io.Serializable {
    private java.lang.String patientId;

    private java.lang.String studyId;

    private java.lang.String procedureDate;

    private gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportTypeProcedureCodes procedureCodes;

    private java.lang.String radiologyReport;

    private java.lang.String siteNumber;

    private java.lang.String siteName;

    private java.lang.String siteAbbreviation;

    public ReportType() {
    }

    public ReportType(
           java.lang.String patientId,
           java.lang.String studyId,
           java.lang.String procedureDate,
           gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportTypeProcedureCodes procedureCodes,
           java.lang.String radiologyReport,
           java.lang.String siteNumber,
           java.lang.String siteName,
           java.lang.String siteAbbreviation) {
           this.patientId = patientId;
           this.studyId = studyId;
           this.procedureDate = procedureDate;
           this.procedureCodes = procedureCodes;
           this.radiologyReport = radiologyReport;
           this.siteNumber = siteNumber;
           this.siteName = siteName;
           this.siteAbbreviation = siteAbbreviation;
    }


    /**
     * Gets the patientId value for this ReportType.
     * 
     * @return patientId
     */
    public java.lang.String getPatientId() {
        return patientId;
    }


    /**
     * Sets the patientId value for this ReportType.
     * 
     * @param patientId
     */
    public void setPatientId(java.lang.String patientId) {
        this.patientId = patientId;
    }


    /**
     * Gets the studyId value for this ReportType.
     * 
     * @return studyId
     */
    public java.lang.String getStudyId() {
        return studyId;
    }


    /**
     * Sets the studyId value for this ReportType.
     * 
     * @param studyId
     */
    public void setStudyId(java.lang.String studyId) {
        this.studyId = studyId;
    }


    /**
     * Gets the procedureDate value for this ReportType.
     * 
     * @return procedureDate
     */
    public java.lang.String getProcedureDate() {
        return procedureDate;
    }


    /**
     * Sets the procedureDate value for this ReportType.
     * 
     * @param procedureDate
     */
    public void setProcedureDate(java.lang.String procedureDate) {
        this.procedureDate = procedureDate;
    }


    /**
     * Gets the procedureCodes value for this ReportType.
     * 
     * @return procedureCodes
     */
    public gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportTypeProcedureCodes getProcedureCodes() {
        return procedureCodes;
    }


    /**
     * Sets the procedureCodes value for this ReportType.
     * 
     * @param procedureCodes
     */
    public void setProcedureCodes(gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportTypeProcedureCodes procedureCodes) {
        this.procedureCodes = procedureCodes;
    }


    /**
     * Gets the radiologyReport value for this ReportType.
     * 
     * @return radiologyReport
     */
    public java.lang.String getRadiologyReport() {
        return radiologyReport;
    }


    /**
     * Sets the radiologyReport value for this ReportType.
     * 
     * @param radiologyReport
     */
    public void setRadiologyReport(java.lang.String radiologyReport) {
        this.radiologyReport = radiologyReport;
    }


    /**
     * Gets the siteNumber value for this ReportType.
     * 
     * @return siteNumber
     */
    public java.lang.String getSiteNumber() {
        return siteNumber;
    }


    /**
     * Sets the siteNumber value for this ReportType.
     * 
     * @param siteNumber
     */
    public void setSiteNumber(java.lang.String siteNumber) {
        this.siteNumber = siteNumber;
    }


    /**
     * Gets the siteName value for this ReportType.
     * 
     * @return siteName
     */
    public java.lang.String getSiteName() {
        return siteName;
    }


    /**
     * Sets the siteName value for this ReportType.
     * 
     * @param siteName
     */
    public void setSiteName(java.lang.String siteName) {
        this.siteName = siteName;
    }


    /**
     * Gets the siteAbbreviation value for this ReportType.
     * 
     * @return siteAbbreviation
     */
    public java.lang.String getSiteAbbreviation() {
        return siteAbbreviation;
    }


    /**
     * Sets the siteAbbreviation value for this ReportType.
     * 
     * @param siteAbbreviation
     */
    public void setSiteAbbreviation(java.lang.String siteAbbreviation) {
        this.siteAbbreviation = siteAbbreviation;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ReportType)) return false;
        ReportType other = (ReportType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.patientId==null && other.getPatientId()==null) || 
             (this.patientId!=null &&
              this.patientId.equals(other.getPatientId()))) &&
            ((this.studyId==null && other.getStudyId()==null) || 
             (this.studyId!=null &&
              this.studyId.equals(other.getStudyId()))) &&
            ((this.procedureDate==null && other.getProcedureDate()==null) || 
             (this.procedureDate!=null &&
              this.procedureDate.equals(other.getProcedureDate()))) &&
            ((this.procedureCodes==null && other.getProcedureCodes()==null) || 
             (this.procedureCodes!=null &&
              this.procedureCodes.equals(other.getProcedureCodes()))) &&
            ((this.radiologyReport==null && other.getRadiologyReport()==null) || 
             (this.radiologyReport!=null &&
              this.radiologyReport.equals(other.getRadiologyReport()))) &&
            ((this.siteNumber==null && other.getSiteNumber()==null) || 
             (this.siteNumber!=null &&
              this.siteNumber.equals(other.getSiteNumber()))) &&
            ((this.siteName==null && other.getSiteName()==null) || 
             (this.siteName!=null &&
              this.siteName.equals(other.getSiteName()))) &&
            ((this.siteAbbreviation==null && other.getSiteAbbreviation()==null) || 
             (this.siteAbbreviation!=null &&
              this.siteAbbreviation.equals(other.getSiteAbbreviation())));
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
        if (getPatientId() != null) {
            _hashCode += getPatientId().hashCode();
        }
        if (getStudyId() != null) {
            _hashCode += getStudyId().hashCode();
        }
        if (getProcedureDate() != null) {
            _hashCode += getProcedureDate().hashCode();
        }
        if (getProcedureCodes() != null) {
            _hashCode += getProcedureCodes().hashCode();
        }
        if (getRadiologyReport() != null) {
            _hashCode += getRadiologyReport().hashCode();
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
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ReportType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "ReportType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "patient-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("studyId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "study-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procedureDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "procedure-date"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procedureCodes");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "procedure-codes"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", ">ReportType>procedure-codes"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("radiologyReport");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "radiology-report"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "site-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteName");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "site-name"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteAbbreviation");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "site-abbreviation"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
