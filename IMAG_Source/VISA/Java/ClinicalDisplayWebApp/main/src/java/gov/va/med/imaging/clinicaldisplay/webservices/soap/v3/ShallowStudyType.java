/**
 * ShallowStudyType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v3;

public class ShallowStudyType  implements java.io.Serializable {
    private java.lang.String studyId;

    private java.lang.String description;

    private java.lang.String procedureDate;

    private java.lang.String procedure;

    private java.lang.String dicomSequenceNumber;

    private java.lang.String dicomImageNumber;

    private java.lang.String patientIcn;

    private java.lang.String patientName;

    private java.lang.String siteNumber;

    private java.lang.String siteAbbreviation;

    private java.math.BigInteger imageCount;

    private java.lang.String noteTitle;

    private java.lang.String imagePackage;

    private java.lang.String imageType;

    private java.lang.String specialty;

    private java.lang.String event;

    private java.lang.String origin;

    private java.lang.String radiologyReport;

    private java.lang.String studyPackage;

    private java.lang.String studyClass;

    private java.lang.String studyType;

    private java.lang.String captureDate;

    private java.lang.String capturedBy;

    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.FatImageType firstImage;

    private java.lang.String rpcResponseMsg;

    public ShallowStudyType() {
    }

    public ShallowStudyType(
           java.lang.String studyId,
           java.lang.String description,
           java.lang.String procedureDate,
           java.lang.String procedure,
           java.lang.String dicomSequenceNumber,
           java.lang.String dicomImageNumber,
           java.lang.String patientIcn,
           java.lang.String patientName,
           java.lang.String siteNumber,
           java.lang.String siteAbbreviation,
           java.math.BigInteger imageCount,
           java.lang.String noteTitle,
           java.lang.String imagePackage,
           java.lang.String imageType,
           java.lang.String specialty,
           java.lang.String event,
           java.lang.String origin,
           java.lang.String radiologyReport,
           java.lang.String studyPackage,
           java.lang.String studyClass,
           java.lang.String studyType,
           java.lang.String captureDate,
           java.lang.String capturedBy,
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.FatImageType firstImage,
           java.lang.String rpcResponseMsg) {
           this.studyId = studyId;
           this.description = description;
           this.procedureDate = procedureDate;
           this.procedure = procedure;
           this.dicomSequenceNumber = dicomSequenceNumber;
           this.dicomImageNumber = dicomImageNumber;
           this.patientIcn = patientIcn;
           this.patientName = patientName;
           this.siteNumber = siteNumber;
           this.siteAbbreviation = siteAbbreviation;
           this.imageCount = imageCount;
           this.noteTitle = noteTitle;
           this.imagePackage = imagePackage;
           this.imageType = imageType;
           this.specialty = specialty;
           this.event = event;
           this.origin = origin;
           this.radiologyReport = radiologyReport;
           this.studyPackage = studyPackage;
           this.studyClass = studyClass;
           this.studyType = studyType;
           this.captureDate = captureDate;
           this.capturedBy = capturedBy;
           this.firstImage = firstImage;
           this.rpcResponseMsg = rpcResponseMsg;
    }


    /**
     * Gets the studyId value for this ShallowStudyType.
     * 
     * @return studyId
     */
    public java.lang.String getStudyId() {
        return studyId;
    }


    /**
     * Sets the studyId value for this ShallowStudyType.
     * 
     * @param studyId
     */
    public void setStudyId(java.lang.String studyId) {
        this.studyId = studyId;
    }


    /**
     * Gets the description value for this ShallowStudyType.
     * 
     * @return description
     */
    public java.lang.String getDescription() {
        return description;
    }


    /**
     * Sets the description value for this ShallowStudyType.
     * 
     * @param description
     */
    public void setDescription(java.lang.String description) {
        this.description = description;
    }


    /**
     * Gets the procedureDate value for this ShallowStudyType.
     * 
     * @return procedureDate
     */
    public java.lang.String getProcedureDate() {
        return procedureDate;
    }


    /**
     * Sets the procedureDate value for this ShallowStudyType.
     * 
     * @param procedureDate
     */
    public void setProcedureDate(java.lang.String procedureDate) {
        this.procedureDate = procedureDate;
    }


    /**
     * Gets the procedure value for this ShallowStudyType.
     * 
     * @return procedure
     */
    public java.lang.String getProcedure() {
        return procedure;
    }


    /**
     * Sets the procedure value for this ShallowStudyType.
     * 
     * @param procedure
     */
    public void setProcedure(java.lang.String procedure) {
        this.procedure = procedure;
    }


    /**
     * Gets the dicomSequenceNumber value for this ShallowStudyType.
     * 
     * @return dicomSequenceNumber
     */
    public java.lang.String getDicomSequenceNumber() {
        return dicomSequenceNumber;
    }


    /**
     * Sets the dicomSequenceNumber value for this ShallowStudyType.
     * 
     * @param dicomSequenceNumber
     */
    public void setDicomSequenceNumber(java.lang.String dicomSequenceNumber) {
        this.dicomSequenceNumber = dicomSequenceNumber;
    }


    /**
     * Gets the dicomImageNumber value for this ShallowStudyType.
     * 
     * @return dicomImageNumber
     */
    public java.lang.String getDicomImageNumber() {
        return dicomImageNumber;
    }


    /**
     * Sets the dicomImageNumber value for this ShallowStudyType.
     * 
     * @param dicomImageNumber
     */
    public void setDicomImageNumber(java.lang.String dicomImageNumber) {
        this.dicomImageNumber = dicomImageNumber;
    }


    /**
     * Gets the patientIcn value for this ShallowStudyType.
     * 
     * @return patientIcn
     */
    public java.lang.String getPatientIcn() {
        return patientIcn;
    }


    /**
     * Sets the patientIcn value for this ShallowStudyType.
     * 
     * @param patientIcn
     */
    public void setPatientIcn(java.lang.String patientIcn) {
        this.patientIcn = patientIcn;
    }


    /**
     * Gets the patientName value for this ShallowStudyType.
     * 
     * @return patientName
     */
    public java.lang.String getPatientName() {
        return patientName;
    }


    /**
     * Sets the patientName value for this ShallowStudyType.
     * 
     * @param patientName
     */
    public void setPatientName(java.lang.String patientName) {
        this.patientName = patientName;
    }


    /**
     * Gets the siteNumber value for this ShallowStudyType.
     * 
     * @return siteNumber
     */
    public java.lang.String getSiteNumber() {
        return siteNumber;
    }


    /**
     * Sets the siteNumber value for this ShallowStudyType.
     * 
     * @param siteNumber
     */
    public void setSiteNumber(java.lang.String siteNumber) {
        this.siteNumber = siteNumber;
    }


    /**
     * Gets the siteAbbreviation value for this ShallowStudyType.
     * 
     * @return siteAbbreviation
     */
    public java.lang.String getSiteAbbreviation() {
        return siteAbbreviation;
    }


    /**
     * Sets the siteAbbreviation value for this ShallowStudyType.
     * 
     * @param siteAbbreviation
     */
    public void setSiteAbbreviation(java.lang.String siteAbbreviation) {
        this.siteAbbreviation = siteAbbreviation;
    }


    /**
     * Gets the imageCount value for this ShallowStudyType.
     * 
     * @return imageCount
     */
    public java.math.BigInteger getImageCount() {
        return imageCount;
    }


    /**
     * Sets the imageCount value for this ShallowStudyType.
     * 
     * @param imageCount
     */
    public void setImageCount(java.math.BigInteger imageCount) {
        this.imageCount = imageCount;
    }


    /**
     * Gets the noteTitle value for this ShallowStudyType.
     * 
     * @return noteTitle
     */
    public java.lang.String getNoteTitle() {
        return noteTitle;
    }


    /**
     * Sets the noteTitle value for this ShallowStudyType.
     * 
     * @param noteTitle
     */
    public void setNoteTitle(java.lang.String noteTitle) {
        this.noteTitle = noteTitle;
    }


    /**
     * Gets the imagePackage value for this ShallowStudyType.
     * 
     * @return imagePackage
     */
    public java.lang.String getImagePackage() {
        return imagePackage;
    }


    /**
     * Sets the imagePackage value for this ShallowStudyType.
     * 
     * @param imagePackage
     */
    public void setImagePackage(java.lang.String imagePackage) {
        this.imagePackage = imagePackage;
    }


    /**
     * Gets the imageType value for this ShallowStudyType.
     * 
     * @return imageType
     */
    public java.lang.String getImageType() {
        return imageType;
    }


    /**
     * Sets the imageType value for this ShallowStudyType.
     * 
     * @param imageType
     */
    public void setImageType(java.lang.String imageType) {
        this.imageType = imageType;
    }


    /**
     * Gets the specialty value for this ShallowStudyType.
     * 
     * @return specialty
     */
    public java.lang.String getSpecialty() {
        return specialty;
    }


    /**
     * Sets the specialty value for this ShallowStudyType.
     * 
     * @param specialty
     */
    public void setSpecialty(java.lang.String specialty) {
        this.specialty = specialty;
    }


    /**
     * Gets the event value for this ShallowStudyType.
     * 
     * @return event
     */
    public java.lang.String getEvent() {
        return event;
    }


    /**
     * Sets the event value for this ShallowStudyType.
     * 
     * @param event
     */
    public void setEvent(java.lang.String event) {
        this.event = event;
    }


    /**
     * Gets the origin value for this ShallowStudyType.
     * 
     * @return origin
     */
    public java.lang.String getOrigin() {
        return origin;
    }


    /**
     * Sets the origin value for this ShallowStudyType.
     * 
     * @param origin
     */
    public void setOrigin(java.lang.String origin) {
        this.origin = origin;
    }


    /**
     * Gets the radiologyReport value for this ShallowStudyType.
     * 
     * @return radiologyReport
     */
    public java.lang.String getRadiologyReport() {
        return radiologyReport;
    }


    /**
     * Sets the radiologyReport value for this ShallowStudyType.
     * 
     * @param radiologyReport
     */
    public void setRadiologyReport(java.lang.String radiologyReport) {
        this.radiologyReport = radiologyReport;
    }


    /**
     * Gets the studyPackage value for this ShallowStudyType.
     * 
     * @return studyPackage
     */
    public java.lang.String getStudyPackage() {
        return studyPackage;
    }


    /**
     * Sets the studyPackage value for this ShallowStudyType.
     * 
     * @param studyPackage
     */
    public void setStudyPackage(java.lang.String studyPackage) {
        this.studyPackage = studyPackage;
    }


    /**
     * Gets the studyClass value for this ShallowStudyType.
     * 
     * @return studyClass
     */
    public java.lang.String getStudyClass() {
        return studyClass;
    }


    /**
     * Sets the studyClass value for this ShallowStudyType.
     * 
     * @param studyClass
     */
    public void setStudyClass(java.lang.String studyClass) {
        this.studyClass = studyClass;
    }


    /**
     * Gets the studyType value for this ShallowStudyType.
     * 
     * @return studyType
     */
    public java.lang.String getStudyType() {
        return studyType;
    }


    /**
     * Sets the studyType value for this ShallowStudyType.
     * 
     * @param studyType
     */
    public void setStudyType(java.lang.String studyType) {
        this.studyType = studyType;
    }


    /**
     * Gets the captureDate value for this ShallowStudyType.
     * 
     * @return captureDate
     */
    public java.lang.String getCaptureDate() {
        return captureDate;
    }


    /**
     * Sets the captureDate value for this ShallowStudyType.
     * 
     * @param captureDate
     */
    public void setCaptureDate(java.lang.String captureDate) {
        this.captureDate = captureDate;
    }


    /**
     * Gets the capturedBy value for this ShallowStudyType.
     * 
     * @return capturedBy
     */
    public java.lang.String getCapturedBy() {
        return capturedBy;
    }


    /**
     * Sets the capturedBy value for this ShallowStudyType.
     * 
     * @param capturedBy
     */
    public void setCapturedBy(java.lang.String capturedBy) {
        this.capturedBy = capturedBy;
    }


    /**
     * Gets the firstImage value for this ShallowStudyType.
     * 
     * @return firstImage
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.FatImageType getFirstImage() {
        return firstImage;
    }


    /**
     * Sets the firstImage value for this ShallowStudyType.
     * 
     * @param firstImage
     */
    public void setFirstImage(gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.FatImageType firstImage) {
        this.firstImage = firstImage;
    }


    /**
     * Gets the rpcResponseMsg value for this ShallowStudyType.
     * 
     * @return rpcResponseMsg
     */
    public java.lang.String getRpcResponseMsg() {
        return rpcResponseMsg;
    }


    /**
     * Sets the rpcResponseMsg value for this ShallowStudyType.
     * 
     * @param rpcResponseMsg
     */
    public void setRpcResponseMsg(java.lang.String rpcResponseMsg) {
        this.rpcResponseMsg = rpcResponseMsg;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ShallowStudyType)) return false;
        ShallowStudyType other = (ShallowStudyType) obj;
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
            ((this.description==null && other.getDescription()==null) || 
             (this.description!=null &&
              this.description.equals(other.getDescription()))) &&
            ((this.procedureDate==null && other.getProcedureDate()==null) || 
             (this.procedureDate!=null &&
              this.procedureDate.equals(other.getProcedureDate()))) &&
            ((this.procedure==null && other.getProcedure()==null) || 
             (this.procedure!=null &&
              this.procedure.equals(other.getProcedure()))) &&
            ((this.dicomSequenceNumber==null && other.getDicomSequenceNumber()==null) || 
             (this.dicomSequenceNumber!=null &&
              this.dicomSequenceNumber.equals(other.getDicomSequenceNumber()))) &&
            ((this.dicomImageNumber==null && other.getDicomImageNumber()==null) || 
             (this.dicomImageNumber!=null &&
              this.dicomImageNumber.equals(other.getDicomImageNumber()))) &&
            ((this.patientIcn==null && other.getPatientIcn()==null) || 
             (this.patientIcn!=null &&
              this.patientIcn.equals(other.getPatientIcn()))) &&
            ((this.patientName==null && other.getPatientName()==null) || 
             (this.patientName!=null &&
              this.patientName.equals(other.getPatientName()))) &&
            ((this.siteNumber==null && other.getSiteNumber()==null) || 
             (this.siteNumber!=null &&
              this.siteNumber.equals(other.getSiteNumber()))) &&
            ((this.siteAbbreviation==null && other.getSiteAbbreviation()==null) || 
             (this.siteAbbreviation!=null &&
              this.siteAbbreviation.equals(other.getSiteAbbreviation()))) &&
            ((this.imageCount==null && other.getImageCount()==null) || 
             (this.imageCount!=null &&
              this.imageCount.equals(other.getImageCount()))) &&
            ((this.noteTitle==null && other.getNoteTitle()==null) || 
             (this.noteTitle!=null &&
              this.noteTitle.equals(other.getNoteTitle()))) &&
            ((this.imagePackage==null && other.getImagePackage()==null) || 
             (this.imagePackage!=null &&
              this.imagePackage.equals(other.getImagePackage()))) &&
            ((this.imageType==null && other.getImageType()==null) || 
             (this.imageType!=null &&
              this.imageType.equals(other.getImageType()))) &&
            ((this.specialty==null && other.getSpecialty()==null) || 
             (this.specialty!=null &&
              this.specialty.equals(other.getSpecialty()))) &&
            ((this.event==null && other.getEvent()==null) || 
             (this.event!=null &&
              this.event.equals(other.getEvent()))) &&
            ((this.origin==null && other.getOrigin()==null) || 
             (this.origin!=null &&
              this.origin.equals(other.getOrigin()))) &&
            ((this.radiologyReport==null && other.getRadiologyReport()==null) || 
             (this.radiologyReport!=null &&
              this.radiologyReport.equals(other.getRadiologyReport()))) &&
            ((this.studyPackage==null && other.getStudyPackage()==null) || 
             (this.studyPackage!=null &&
              this.studyPackage.equals(other.getStudyPackage()))) &&
            ((this.studyClass==null && other.getStudyClass()==null) || 
             (this.studyClass!=null &&
              this.studyClass.equals(other.getStudyClass()))) &&
            ((this.studyType==null && other.getStudyType()==null) || 
             (this.studyType!=null &&
              this.studyType.equals(other.getStudyType()))) &&
            ((this.captureDate==null && other.getCaptureDate()==null) || 
             (this.captureDate!=null &&
              this.captureDate.equals(other.getCaptureDate()))) &&
            ((this.capturedBy==null && other.getCapturedBy()==null) || 
             (this.capturedBy!=null &&
              this.capturedBy.equals(other.getCapturedBy()))) &&
            ((this.firstImage==null && other.getFirstImage()==null) || 
             (this.firstImage!=null &&
              this.firstImage.equals(other.getFirstImage()))) &&
            ((this.rpcResponseMsg==null && other.getRpcResponseMsg()==null) || 
             (this.rpcResponseMsg!=null &&
              this.rpcResponseMsg.equals(other.getRpcResponseMsg())));
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
        if (getDescription() != null) {
            _hashCode += getDescription().hashCode();
        }
        if (getProcedureDate() != null) {
            _hashCode += getProcedureDate().hashCode();
        }
        if (getProcedure() != null) {
            _hashCode += getProcedure().hashCode();
        }
        if (getDicomSequenceNumber() != null) {
            _hashCode += getDicomSequenceNumber().hashCode();
        }
        if (getDicomImageNumber() != null) {
            _hashCode += getDicomImageNumber().hashCode();
        }
        if (getPatientIcn() != null) {
            _hashCode += getPatientIcn().hashCode();
        }
        if (getPatientName() != null) {
            _hashCode += getPatientName().hashCode();
        }
        if (getSiteNumber() != null) {
            _hashCode += getSiteNumber().hashCode();
        }
        if (getSiteAbbreviation() != null) {
            _hashCode += getSiteAbbreviation().hashCode();
        }
        if (getImageCount() != null) {
            _hashCode += getImageCount().hashCode();
        }
        if (getNoteTitle() != null) {
            _hashCode += getNoteTitle().hashCode();
        }
        if (getImagePackage() != null) {
            _hashCode += getImagePackage().hashCode();
        }
        if (getImageType() != null) {
            _hashCode += getImageType().hashCode();
        }
        if (getSpecialty() != null) {
            _hashCode += getSpecialty().hashCode();
        }
        if (getEvent() != null) {
            _hashCode += getEvent().hashCode();
        }
        if (getOrigin() != null) {
            _hashCode += getOrigin().hashCode();
        }
        if (getRadiologyReport() != null) {
            _hashCode += getRadiologyReport().hashCode();
        }
        if (getStudyPackage() != null) {
            _hashCode += getStudyPackage().hashCode();
        }
        if (getStudyClass() != null) {
            _hashCode += getStudyClass().hashCode();
        }
        if (getStudyType() != null) {
            _hashCode += getStudyType().hashCode();
        }
        if (getCaptureDate() != null) {
            _hashCode += getCaptureDate().hashCode();
        }
        if (getCapturedBy() != null) {
            _hashCode += getCapturedBy().hashCode();
        }
        if (getFirstImage() != null) {
            _hashCode += getFirstImage().hashCode();
        }
        if (getRpcResponseMsg() != null) {
            _hashCode += getRpcResponseMsg().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ShallowStudyType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudyType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("studyId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("description");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procedureDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "procedure-date"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procedure");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "procedure"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dicomSequenceNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "dicom-sequence-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dicomImageNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "dicom-image-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientIcn");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-icn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientName");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-name"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteAbbreviation");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-abbreviation"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageCount");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-count"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "integer"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("noteTitle");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "note-title"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imagePackage");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-package"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageType");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-type"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("specialty");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "specialty"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("event");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "event"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("origin");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "origin"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("radiologyReport");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "radiology-report"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("studyPackage");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-package"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("studyClass");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-class"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("studyType");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-type"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("captureDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "capture-date"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("capturedBy");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "captured-by"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("firstImage");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "first-image"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FatImageType"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("rpcResponseMsg");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "rpcResponseMsg"));
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
