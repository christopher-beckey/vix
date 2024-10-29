/**
 * StudyType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.mix.webservices.rest.types.v1;

public class StudyType  implements java.io.Serializable {
    private java.lang.String studyId;

    private java.lang.String dicomUid;

    private java.lang.String description;

    private gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeProcedureCodes procedureCodes;

    private java.lang.String procedureDate;

    private java.lang.String procedureDescription;

    private java.lang.String patientId;

    private java.lang.String patientName;

    private java.lang.String siteNumber;

    private java.lang.String siteName;

    private java.lang.String siteAbbreviation;

    private int imageCount;

    private int seriesCount;

    private java.lang.String specialtyDescription;
    
	private java.lang.String reportContent; // added for MIX

    private gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType modalities;

    private gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries componentSeries;

    public StudyType() {
    }

    public StudyType(
           java.lang.String studyId,
           java.lang.String dicomUid,
           java.lang.String description,
           gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeProcedureCodes procedureCodes,
           java.lang.String procedureDate,
           java.lang.String procedureDescription,
           java.lang.String patientId,
           java.lang.String patientName,
           java.lang.String siteNumber,
           java.lang.String siteName,
           java.lang.String siteAbbreviation,
           int imageCount,
           int seriesCount,
           java.lang.String specialtyDescription,
           java.lang.String reportContent,
           gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType modalities,
           gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries componentSeries) {
           this.studyId = studyId;
           this.dicomUid = dicomUid;
           this.description = description;
           this.procedureCodes = procedureCodes;
           this.procedureDate = procedureDate;
           this.procedureDescription = procedureDescription;
           this.patientId = patientId;
           this.patientName = patientName;
           this.siteNumber = siteNumber;
           this.siteName = siteName;
           this.siteAbbreviation = siteAbbreviation;
           this.imageCount = imageCount;
           this.seriesCount = seriesCount;
           this.specialtyDescription = specialtyDescription;
           this.reportContent = reportContent;
           this.modalities = modalities;
           this.componentSeries = componentSeries;
    }


    /**
     * Gets the studyId value for this StudyType.
     * 
     * @return studyId
     */
    public java.lang.String getStudyId() {
        return studyId;
    }


    /**
     * Sets the studyId value for this StudyType.
     * 
     * @param studyId
     */
    public void setStudyId(java.lang.String studyId) {
        this.studyId = studyId;
    }


    /**
     * Gets the dicomUid value for this StudyType.
     * 
     * @return dicomUid
     */
    public java.lang.String getDicomUid() {
        return dicomUid;
    }


    /**
     * Sets the dicomUid value for this StudyType.
     * 
     * @param dicomUid
     */
    public void setDicomUid(java.lang.String dicomUid) {
        this.dicomUid = dicomUid;
    }


    /**
     * Gets the description value for this StudyType.
     * 
     * @return description
     */
    public java.lang.String getDescription() {
        return description;
    }


    /**
     * Sets the description value for this StudyType.
     * 
     * @param description
     */
    public void setDescription(java.lang.String description) {
        this.description = description;
    }


    /**
     * Gets the procedureCodes value for this StudyType.
     * 
     * @return procedureCodes
     */
    public gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeProcedureCodes getProcedureCodes() {
        return procedureCodes;
    }


    /**
     * Sets the procedureCodes value for this StudyType.
     * 
     * @param procedureCodes
     */
    public void setProcedureCodes(gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeProcedureCodes procedureCodes) {
        this.procedureCodes = procedureCodes;
    }


    /**
     * Gets the procedureDate value for this StudyType.
     * 
     * @return procedureDate
     */
    public java.lang.String getProcedureDate() {
        return procedureDate;
    }


    /**
     * Sets the procedureDate value for this StudyType.
     * 
     * @param procedureDate
     */
    public void setProcedureDate(java.lang.String procedureDate) {
        this.procedureDate = procedureDate;
    }


    /**
     * Gets the procedureDescription value for this StudyType.
     * 
     * @return procedureDescription
     */
    public java.lang.String getProcedureDescription() {
        return procedureDescription;
    }


    /**
     * Sets the procedureDescription value for this StudyType.
     * 
     * @param procedureDescription
     */
    public void setProcedureDescription(java.lang.String procedureDescription) {
        this.procedureDescription = procedureDescription;
    }


    /**
     * Gets the patientId value for this StudyType.
     * 
     * @return patientId
     */
    public java.lang.String getPatientId() {
        return patientId;
    }


    /**
     * Sets the patientId value for this StudyType.
     * 
     * @param patientId
     */
    public void setPatientId(java.lang.String patientId) {
        this.patientId = patientId;
    }


    /**
     * Gets the patientName value for this StudyType.
     * 
     * @return patientName
     */
    public java.lang.String getPatientName() {
        return patientName;
    }


    /**
     * Sets the patientName value for this StudyType.
     * 
     * @param patientName
     */
    public void setPatientName(java.lang.String patientName) {
        this.patientName = patientName;
    }


    /**
     * Gets the siteNumber value for this StudyType.
     * 
     * @return siteNumber
     */
    public java.lang.String getSiteNumber() {
        return siteNumber;
    }


    /**
     * Sets the siteNumber value for this StudyType.
     * 
     * @param siteNumber
     */
    public void setSiteNumber(java.lang.String siteNumber) {
        this.siteNumber = siteNumber;
    }


    /**
     * Gets the siteName value for this StudyType.
     * 
     * @return siteName
     */
    public java.lang.String getSiteName() {
        return siteName;
    }


    /**
     * Sets the siteName value for this StudyType.
     * 
     * @param siteName
     */
    public void setSiteName(java.lang.String siteName) {
        this.siteName = siteName;
    }


    /**
     * Gets the siteAbbreviation value for this StudyType.
     * 
     * @return siteAbbreviation
     */
    public java.lang.String getSiteAbbreviation() {
        return siteAbbreviation;
    }


    /**
     * Sets the siteAbbreviation value for this StudyType.
     * 
     * @param siteAbbreviation
     */
    public void setSiteAbbreviation(java.lang.String siteAbbreviation) {
        this.siteAbbreviation = siteAbbreviation;
    }


    /**
     * Gets the imageCount value for this StudyType.
     * 
     * @return imageCount
     */
    public int getImageCount() {
        return imageCount;
    }


    /**
     * Sets the imageCount value for this StudyType.
     * 
     * @param imageCount
     */
    public void setImageCount(int imageCount) {
        this.imageCount = imageCount;
    }


    /**
     * Gets the seriesCount value for this StudyType.
     * 
     * @return seriesCount
     */
    public int getSeriesCount() {
        return seriesCount;
    }


    /**
     * Sets the seriesCount value for this StudyType.
     * 
     * @param seriesCount
     */
    public void setSeriesCount(int seriesCount) {
        this.seriesCount = seriesCount;
    }


    /**
     * Gets the specialtyDescription value for this StudyType.
     * 
     * @return specialtyDescription
     */
    public java.lang.String getSpecialtyDescription() {
        return specialtyDescription;
    }


    /**
     * Sets the specialtyDescription value for this StudyType.
     * 
     * @param specialtyDescription
     */
    public void setSpecialtyDescription(java.lang.String specialtyDescription) {
        this.specialtyDescription = specialtyDescription;
    }

    /**
     * Gets the report content value for this StudyType.
     * 
     * @return reportContent
     */
    public java.lang.String getReportContent() {
		return reportContent;
	}

    /**
     * Sets the report content value for this StudyType.
     * 
     * @param reportContent
     */
	public void setReportContent(java.lang.String reportContent) {
		this.reportContent = reportContent;
	}

    /**
     * Gets the modalities value for this StudyType.
     * 
     * @return modalities
     */
    public gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType getModalities() {
        return modalities;
    }

    /**
     * Sets the modalities value for this StudyType.
     * 
     * @param modalities
     */
    public void setModalities(gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType modalities) {
        this.modalities = modalities;
    }

    /**
     * Gets the componentSeries value for this StudyType.
     * 
     * @return componentSeries
     */
    public gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries getComponentSeries() {
        return componentSeries;
    }

    /**
     * Sets the componentSeries value for this StudyType.
     * 
     * @param componentSeries
     */
    public void setComponentSeries(gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries componentSeries) {
        this.componentSeries = componentSeries;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof StudyType)) return false;
        StudyType other = (StudyType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.studyId==null && other.getStudyId()==null) || 
             (this.studyId!=null &&
              this.studyId.equals(other.getStudyId()))) &&
            ((this.dicomUid==null && other.getDicomUid()==null) || 
             (this.dicomUid!=null &&
              this.dicomUid.equals(other.getDicomUid()))) &&
            ((this.description==null && other.getDescription()==null) || 
             (this.description!=null &&
              this.description.equals(other.getDescription()))) &&
            ((this.procedureCodes==null && other.getProcedureCodes()==null) || 
             (this.procedureCodes!=null &&
              this.procedureCodes.equals(other.getProcedureCodes()))) &&
            ((this.procedureDate==null && other.getProcedureDate()==null) || 
             (this.procedureDate!=null &&
              this.procedureDate.equals(other.getProcedureDate()))) &&
            ((this.procedureDescription==null && other.getProcedureDescription()==null) || 
             (this.procedureDescription!=null &&
              this.procedureDescription.equals(other.getProcedureDescription()))) &&
            ((this.patientId==null && other.getPatientId()==null) || 
             (this.patientId!=null &&
              this.patientId.equals(other.getPatientId()))) &&
            ((this.patientName==null && other.getPatientName()==null) || 
             (this.patientName!=null &&
              this.patientName.equals(other.getPatientName()))) &&
            ((this.siteNumber==null && other.getSiteNumber()==null) || 
             (this.siteNumber!=null &&
              this.siteNumber.equals(other.getSiteNumber()))) &&
            ((this.siteName==null && other.getSiteName()==null) || 
             (this.siteName!=null &&
              this.siteName.equals(other.getSiteName()))) &&
            ((this.siteAbbreviation==null && other.getSiteAbbreviation()==null) || 
             (this.siteAbbreviation!=null &&
              this.siteAbbreviation.equals(other.getSiteAbbreviation()))) &&
            this.imageCount == other.getImageCount() &&
            this.seriesCount == other.getSeriesCount() &&
            ((this.specialtyDescription==null && other.getSpecialtyDescription()==null) || 
             (this.specialtyDescription!=null &&
             this.specialtyDescription.equals(other.getSpecialtyDescription()))) &&
            ((this.reportContent==null && other.getReportContent()==null) || 
             (this.reportContent!=null &&
             this.reportContent.equals(other.getReportContent()))) &&
            ((this.modalities==null && other.getModalities()==null) || 
             (this.modalities!=null &&
              this.modalities.equals(other.getModalities()))) &&
            ((this.componentSeries==null && other.getComponentSeries()==null) || 
             (this.componentSeries!=null &&
              this.componentSeries.equals(other.getComponentSeries())));
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
        if (getStudyId() != null) {
            _hashCode += getStudyId().hashCode();
        }
        if (getDicomUid() != null) {
            _hashCode += getDicomUid().hashCode();
        }
        if (getDescription() != null) {
            _hashCode += getDescription().hashCode();
        }
        if (getProcedureCodes() != null) {
            _hashCode += getProcedureCodes().hashCode();
        }
        if (getProcedureDate() != null) {
            _hashCode += getProcedureDate().hashCode();
        }
        if (getProcedureDescription() != null) {
            _hashCode += getProcedureDescription().hashCode();
        }
        if (getPatientId() != null) {
            _hashCode += getPatientId().hashCode();
        }
        if (getPatientName() != null) {
            _hashCode += getPatientName().hashCode();
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
        _hashCode += getImageCount();
        _hashCode += getSeriesCount();
        if (getSpecialtyDescription() != null) {
            _hashCode += getSpecialtyDescription().hashCode();
        }
        if (getReportContent() != null) {
            _hashCode += getReportContent().hashCode();
        }
        if (getModalities() != null) {
            _hashCode += getModalities().hashCode();
        }
        if (getComponentSeries() != null) {
            _hashCode += getComponentSeries().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(StudyType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "StudyType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("studyId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "study-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dicomUid");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "dicom-uid"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("description");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procedureCodes");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "procedure-codes"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", ">StudyType>procedure-codes"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procedureDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "procedure-date"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procedureDescription");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "procedure-description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "patient-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientName");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "patient-name"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
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
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageCount");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "image-count"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("seriesCount");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "series-count"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("specialtyDescription");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "specialty-description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("reportContent");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "report-content"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("modalities");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "modalities"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "ModalitiesType"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("componentSeries");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "component-series"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", ">StudyType>component-series"));
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
