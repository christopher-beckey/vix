/**
 * FatImageType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v7;

public class FatImageType  implements java.io.Serializable {
    private java.lang.String imageId;

    private java.lang.String description;

    private java.lang.String procedureDate;

    private java.lang.String procedure;

    private java.lang.String dicomSequenceNumber;

    private java.lang.String dicomImageNumber;

    private java.lang.String patientIcn;

    private java.lang.String patientName;

    private java.lang.String siteNumber;

    private java.lang.String siteAbbr;

    private java.math.BigInteger imageType;

    private java.lang.String absLocation;

    private java.lang.String fullLocation;

    private java.lang.String imageClass;

    private java.lang.String fullImageURI;

    private java.lang.String absImageURI;

    private java.lang.String bigImageURI;

    private java.lang.String qaMessage;

    private java.lang.String captureDate;

    private java.lang.String documentDate;

    private java.lang.Boolean sensitive;

    private java.lang.String status;

    private java.lang.String viewStatus;

    private boolean imageHasAnnotations;

    private java.math.BigInteger imageAnnotationStatus;

    private java.lang.String imageAnnotationStatusDescription;

    private java.lang.String associatedNoteResulted;

    private java.lang.String imagePackage;

    public FatImageType() {
    }

    public FatImageType(
           java.lang.String imageId,
           java.lang.String description,
           java.lang.String procedureDate,
           java.lang.String procedure,
           java.lang.String dicomSequenceNumber,
           java.lang.String dicomImageNumber,
           java.lang.String patientIcn,
           java.lang.String patientName,
           java.lang.String siteNumber,
           java.lang.String siteAbbr,
           java.math.BigInteger imageType,
           java.lang.String absLocation,
           java.lang.String fullLocation,
           java.lang.String imageClass,
           java.lang.String fullImageURI,
           java.lang.String absImageURI,
           java.lang.String bigImageURI,
           java.lang.String qaMessage,
           java.lang.String captureDate,
           java.lang.String documentDate,
           java.lang.Boolean sensitive,
           java.lang.String status,
           java.lang.String viewStatus,
           boolean imageHasAnnotations,
           java.math.BigInteger imageAnnotationStatus,
           java.lang.String imageAnnotationStatusDescription,
           java.lang.String associatedNoteResulted,
           java.lang.String imagePackage) {
           this.imageId = imageId;
           this.description = description;
           this.procedureDate = procedureDate;
           this.procedure = procedure;
           this.dicomSequenceNumber = dicomSequenceNumber;
           this.dicomImageNumber = dicomImageNumber;
           this.patientIcn = patientIcn;
           this.patientName = patientName;
           this.siteNumber = siteNumber;
           this.siteAbbr = siteAbbr;
           this.imageType = imageType;
           this.absLocation = absLocation;
           this.fullLocation = fullLocation;
           this.imageClass = imageClass;
           this.fullImageURI = fullImageURI;
           this.absImageURI = absImageURI;
           this.bigImageURI = bigImageURI;
           this.qaMessage = qaMessage;
           this.captureDate = captureDate;
           this.documentDate = documentDate;
           this.sensitive = sensitive;
           this.status = status;
           this.viewStatus = viewStatus;
           this.imageHasAnnotations = imageHasAnnotations;
           this.imageAnnotationStatus = imageAnnotationStatus;
           this.imageAnnotationStatusDescription = imageAnnotationStatusDescription;
           this.associatedNoteResulted = associatedNoteResulted;
           this.imagePackage = imagePackage;
    }


    /**
     * Gets the imageId value for this FatImageType.
     * 
     * @return imageId
     */
    public java.lang.String getImageId() {
        return imageId;
    }


    /**
     * Sets the imageId value for this FatImageType.
     * 
     * @param imageId
     */
    public void setImageId(java.lang.String imageId) {
        this.imageId = imageId;
    }


    /**
     * Gets the description value for this FatImageType.
     * 
     * @return description
     */
    public java.lang.String getDescription() {
        return description;
    }


    /**
     * Sets the description value for this FatImageType.
     * 
     * @param description
     */
    public void setDescription(java.lang.String description) {
        this.description = description;
    }


    /**
     * Gets the procedureDate value for this FatImageType.
     * 
     * @return procedureDate
     */
    public java.lang.String getProcedureDate() {
        return procedureDate;
    }


    /**
     * Sets the procedureDate value for this FatImageType.
     * 
     * @param procedureDate
     */
    public void setProcedureDate(java.lang.String procedureDate) {
        this.procedureDate = procedureDate;
    }


    /**
     * Gets the procedure value for this FatImageType.
     * 
     * @return procedure
     */
    public java.lang.String getProcedure() {
        return procedure;
    }


    /**
     * Sets the procedure value for this FatImageType.
     * 
     * @param procedure
     */
    public void setProcedure(java.lang.String procedure) {
        this.procedure = procedure;
    }


    /**
     * Gets the dicomSequenceNumber value for this FatImageType.
     * 
     * @return dicomSequenceNumber
     */
    public java.lang.String getDicomSequenceNumber() {
        return dicomSequenceNumber;
    }


    /**
     * Sets the dicomSequenceNumber value for this FatImageType.
     * 
     * @param dicomSequenceNumber
     */
    public void setDicomSequenceNumber(java.lang.String dicomSequenceNumber) {
        this.dicomSequenceNumber = dicomSequenceNumber;
    }


    /**
     * Gets the dicomImageNumber value for this FatImageType.
     * 
     * @return dicomImageNumber
     */
    public java.lang.String getDicomImageNumber() {
        return dicomImageNumber;
    }


    /**
     * Sets the dicomImageNumber value for this FatImageType.
     * 
     * @param dicomImageNumber
     */
    public void setDicomImageNumber(java.lang.String dicomImageNumber) {
        this.dicomImageNumber = dicomImageNumber;
    }


    /**
     * Gets the patientIcn value for this FatImageType.
     * 
     * @return patientIcn
     */
    public java.lang.String getPatientIcn() {
        return patientIcn;
    }


    /**
     * Sets the patientIcn value for this FatImageType.
     * 
     * @param patientIcn
     */
    public void setPatientIcn(java.lang.String patientIcn) {
        this.patientIcn = patientIcn;
    }


    /**
     * Gets the patientName value for this FatImageType.
     * 
     * @return patientName
     */
    public java.lang.String getPatientName() {
        return patientName;
    }


    /**
     * Sets the patientName value for this FatImageType.
     * 
     * @param patientName
     */
    public void setPatientName(java.lang.String patientName) {
        this.patientName = patientName;
    }


    /**
     * Gets the siteNumber value for this FatImageType.
     * 
     * @return siteNumber
     */
    public java.lang.String getSiteNumber() {
        return siteNumber;
    }


    /**
     * Sets the siteNumber value for this FatImageType.
     * 
     * @param siteNumber
     */
    public void setSiteNumber(java.lang.String siteNumber) {
        this.siteNumber = siteNumber;
    }


    /**
     * Gets the siteAbbr value for this FatImageType.
     * 
     * @return siteAbbr
     */
    public java.lang.String getSiteAbbr() {
        return siteAbbr;
    }


    /**
     * Sets the siteAbbr value for this FatImageType.
     * 
     * @param siteAbbr
     */
    public void setSiteAbbr(java.lang.String siteAbbr) {
        this.siteAbbr = siteAbbr;
    }


    /**
     * Gets the imageType value for this FatImageType.
     * 
     * @return imageType
     */
    public java.math.BigInteger getImageType() {
        return imageType;
    }


    /**
     * Sets the imageType value for this FatImageType.
     * 
     * @param imageType
     */
    public void setImageType(java.math.BigInteger imageType) {
        this.imageType = imageType;
    }


    /**
     * Gets the absLocation value for this FatImageType.
     * 
     * @return absLocation
     */
    public java.lang.String getAbsLocation() {
        return absLocation;
    }


    /**
     * Sets the absLocation value for this FatImageType.
     * 
     * @param absLocation
     */
    public void setAbsLocation(java.lang.String absLocation) {
        this.absLocation = absLocation;
    }


    /**
     * Gets the fullLocation value for this FatImageType.
     * 
     * @return fullLocation
     */
    public java.lang.String getFullLocation() {
        return fullLocation;
    }


    /**
     * Sets the fullLocation value for this FatImageType.
     * 
     * @param fullLocation
     */
    public void setFullLocation(java.lang.String fullLocation) {
        this.fullLocation = fullLocation;
    }


    /**
     * Gets the imageClass value for this FatImageType.
     * 
     * @return imageClass
     */
    public java.lang.String getImageClass() {
        return imageClass;
    }


    /**
     * Sets the imageClass value for this FatImageType.
     * 
     * @param imageClass
     */
    public void setImageClass(java.lang.String imageClass) {
        this.imageClass = imageClass;
    }


    /**
     * Gets the fullImageURI value for this FatImageType.
     * 
     * @return fullImageURI
     */
    public java.lang.String getFullImageURI() {
        return fullImageURI;
    }


    /**
     * Sets the fullImageURI value for this FatImageType.
     * 
     * @param fullImageURI
     */
    public void setFullImageURI(java.lang.String fullImageURI) {
        this.fullImageURI = fullImageURI;
    }


    /**
     * Gets the absImageURI value for this FatImageType.
     * 
     * @return absImageURI
     */
    public java.lang.String getAbsImageURI() {
        return absImageURI;
    }


    /**
     * Sets the absImageURI value for this FatImageType.
     * 
     * @param absImageURI
     */
    public void setAbsImageURI(java.lang.String absImageURI) {
        this.absImageURI = absImageURI;
    }


    /**
     * Gets the bigImageURI value for this FatImageType.
     * 
     * @return bigImageURI
     */
    public java.lang.String getBigImageURI() {
        return bigImageURI;
    }


    /**
     * Sets the bigImageURI value for this FatImageType.
     * 
     * @param bigImageURI
     */
    public void setBigImageURI(java.lang.String bigImageURI) {
        this.bigImageURI = bigImageURI;
    }


    /**
     * Gets the qaMessage value for this FatImageType.
     * 
     * @return qaMessage
     */
    public java.lang.String getQaMessage() {
        return qaMessage;
    }


    /**
     * Sets the qaMessage value for this FatImageType.
     * 
     * @param qaMessage
     */
    public void setQaMessage(java.lang.String qaMessage) {
        this.qaMessage = qaMessage;
    }


    /**
     * Gets the captureDate value for this FatImageType.
     * 
     * @return captureDate
     */
    public java.lang.String getCaptureDate() {
        return captureDate;
    }


    /**
     * Sets the captureDate value for this FatImageType.
     * 
     * @param captureDate
     */
    public void setCaptureDate(java.lang.String captureDate) {
        this.captureDate = captureDate;
    }


    /**
     * Gets the documentDate value for this FatImageType.
     * 
     * @return documentDate
     */
    public java.lang.String getDocumentDate() {
        return documentDate;
    }


    /**
     * Sets the documentDate value for this FatImageType.
     * 
     * @param documentDate
     */
    public void setDocumentDate(java.lang.String documentDate) {
        this.documentDate = documentDate;
    }


    /**
     * Gets the sensitive value for this FatImageType.
     * 
     * @return sensitive
     */
    public java.lang.Boolean getSensitive() {
        return sensitive;
    }


    /**
     * Sets the sensitive value for this FatImageType.
     * 
     * @param sensitive
     */
    public void setSensitive(java.lang.Boolean sensitive) {
        this.sensitive = sensitive;
    }


    /**
     * Gets the status value for this FatImageType.
     * 
     * @return status
     */
    public java.lang.String getStatus() {
        return status;
    }


    /**
     * Sets the status value for this FatImageType.
     * 
     * @param status
     */
    public void setStatus(java.lang.String status) {
        this.status = status;
    }


    /**
     * Gets the viewStatus value for this FatImageType.
     * 
     * @return viewStatus
     */
    public java.lang.String getViewStatus() {
        return viewStatus;
    }


    /**
     * Sets the viewStatus value for this FatImageType.
     * 
     * @param viewStatus
     */
    public void setViewStatus(java.lang.String viewStatus) {
        this.viewStatus = viewStatus;
    }


    /**
     * Gets the imageHasAnnotations value for this FatImageType.
     * 
     * @return imageHasAnnotations
     */
    public boolean isImageHasAnnotations() {
        return imageHasAnnotations;
    }


    /**
     * Sets the imageHasAnnotations value for this FatImageType.
     * 
     * @param imageHasAnnotations
     */
    public void setImageHasAnnotations(boolean imageHasAnnotations) {
        this.imageHasAnnotations = imageHasAnnotations;
    }


    /**
     * Gets the imageAnnotationStatus value for this FatImageType.
     * 
     * @return imageAnnotationStatus
     */
    public java.math.BigInteger getImageAnnotationStatus() {
        return imageAnnotationStatus;
    }


    /**
     * Sets the imageAnnotationStatus value for this FatImageType.
     * 
     * @param imageAnnotationStatus
     */
    public void setImageAnnotationStatus(java.math.BigInteger imageAnnotationStatus) {
        this.imageAnnotationStatus = imageAnnotationStatus;
    }


    /**
     * Gets the imageAnnotationStatusDescription value for this FatImageType.
     * 
     * @return imageAnnotationStatusDescription
     */
    public java.lang.String getImageAnnotationStatusDescription() {
        return imageAnnotationStatusDescription;
    }


    /**
     * Sets the imageAnnotationStatusDescription value for this FatImageType.
     * 
     * @param imageAnnotationStatusDescription
     */
    public void setImageAnnotationStatusDescription(java.lang.String imageAnnotationStatusDescription) {
        this.imageAnnotationStatusDescription = imageAnnotationStatusDescription;
    }


    /**
     * Gets the associatedNoteResulted value for this FatImageType.
     * 
     * @return associatedNoteResulted
     */
    public java.lang.String getAssociatedNoteResulted() {
        return associatedNoteResulted;
    }


    /**
     * Sets the associatedNoteResulted value for this FatImageType.
     * 
     * @param associatedNoteResulted
     */
    public void setAssociatedNoteResulted(java.lang.String associatedNoteResulted) {
        this.associatedNoteResulted = associatedNoteResulted;
    }


    /**
     * Gets the imagePackage value for this FatImageType.
     * 
     * @return imagePackage
     */
    public java.lang.String getImagePackage() {
        return imagePackage;
    }


    /**
     * Sets the imagePackage value for this FatImageType.
     * 
     * @param imagePackage
     */
    public void setImagePackage(java.lang.String imagePackage) {
        this.imagePackage = imagePackage;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof FatImageType)) return false;
        FatImageType other = (FatImageType) obj;
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
            ((this.siteAbbr==null && other.getSiteAbbr()==null) || 
             (this.siteAbbr!=null &&
              this.siteAbbr.equals(other.getSiteAbbr()))) &&
            ((this.imageType==null && other.getImageType()==null) || 
             (this.imageType!=null &&
              this.imageType.equals(other.getImageType()))) &&
            ((this.absLocation==null && other.getAbsLocation()==null) || 
             (this.absLocation!=null &&
              this.absLocation.equals(other.getAbsLocation()))) &&
            ((this.fullLocation==null && other.getFullLocation()==null) || 
             (this.fullLocation!=null &&
              this.fullLocation.equals(other.getFullLocation()))) &&
            ((this.imageClass==null && other.getImageClass()==null) || 
             (this.imageClass!=null &&
              this.imageClass.equals(other.getImageClass()))) &&
            ((this.fullImageURI==null && other.getFullImageURI()==null) || 
             (this.fullImageURI!=null &&
              this.fullImageURI.equals(other.getFullImageURI()))) &&
            ((this.absImageURI==null && other.getAbsImageURI()==null) || 
             (this.absImageURI!=null &&
              this.absImageURI.equals(other.getAbsImageURI()))) &&
            ((this.bigImageURI==null && other.getBigImageURI()==null) || 
             (this.bigImageURI!=null &&
              this.bigImageURI.equals(other.getBigImageURI()))) &&
            ((this.qaMessage==null && other.getQaMessage()==null) || 
             (this.qaMessage!=null &&
              this.qaMessage.equals(other.getQaMessage()))) &&
            ((this.captureDate==null && other.getCaptureDate()==null) || 
             (this.captureDate!=null &&
              this.captureDate.equals(other.getCaptureDate()))) &&
            ((this.documentDate==null && other.getDocumentDate()==null) || 
             (this.documentDate!=null &&
              this.documentDate.equals(other.getDocumentDate()))) &&
            ((this.sensitive==null && other.getSensitive()==null) || 
             (this.sensitive!=null &&
              this.sensitive.equals(other.getSensitive()))) &&
            ((this.status==null && other.getStatus()==null) || 
             (this.status!=null &&
              this.status.equals(other.getStatus()))) &&
            ((this.viewStatus==null && other.getViewStatus()==null) || 
             (this.viewStatus!=null &&
              this.viewStatus.equals(other.getViewStatus()))) &&
            this.imageHasAnnotations == other.isImageHasAnnotations() &&
            ((this.imageAnnotationStatus==null && other.getImageAnnotationStatus()==null) || 
             (this.imageAnnotationStatus!=null &&
              this.imageAnnotationStatus.equals(other.getImageAnnotationStatus()))) &&
            ((this.imageAnnotationStatusDescription==null && other.getImageAnnotationStatusDescription()==null) || 
             (this.imageAnnotationStatusDescription!=null &&
              this.imageAnnotationStatusDescription.equals(other.getImageAnnotationStatusDescription()))) &&
            ((this.associatedNoteResulted==null && other.getAssociatedNoteResulted()==null) || 
             (this.associatedNoteResulted!=null &&
              this.associatedNoteResulted.equals(other.getAssociatedNoteResulted()))) &&
            ((this.imagePackage==null && other.getImagePackage()==null) || 
             (this.imagePackage!=null &&
              this.imagePackage.equals(other.getImagePackage())));
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
        if (getSiteAbbr() != null) {
            _hashCode += getSiteAbbr().hashCode();
        }
        if (getImageType() != null) {
            _hashCode += getImageType().hashCode();
        }
        if (getAbsLocation() != null) {
            _hashCode += getAbsLocation().hashCode();
        }
        if (getFullLocation() != null) {
            _hashCode += getFullLocation().hashCode();
        }
        if (getImageClass() != null) {
            _hashCode += getImageClass().hashCode();
        }
        if (getFullImageURI() != null) {
            _hashCode += getFullImageURI().hashCode();
        }
        if (getAbsImageURI() != null) {
            _hashCode += getAbsImageURI().hashCode();
        }
        if (getBigImageURI() != null) {
            _hashCode += getBigImageURI().hashCode();
        }
        if (getQaMessage() != null) {
            _hashCode += getQaMessage().hashCode();
        }
        if (getCaptureDate() != null) {
            _hashCode += getCaptureDate().hashCode();
        }
        if (getDocumentDate() != null) {
            _hashCode += getDocumentDate().hashCode();
        }
        if (getSensitive() != null) {
            _hashCode += getSensitive().hashCode();
        }
        if (getStatus() != null) {
            _hashCode += getStatus().hashCode();
        }
        if (getViewStatus() != null) {
            _hashCode += getViewStatus().hashCode();
        }
        _hashCode += (isImageHasAnnotations() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        if (getImageAnnotationStatus() != null) {
            _hashCode += getImageAnnotationStatus().hashCode();
        }
        if (getImageAnnotationStatusDescription() != null) {
            _hashCode += getImageAnnotationStatusDescription().hashCode();
        }
        if (getAssociatedNoteResulted() != null) {
            _hashCode += getAssociatedNoteResulted().hashCode();
        }
        if (getImagePackage() != null) {
            _hashCode += getImagePackage().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(FatImageType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FatImageType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("description");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procedureDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "procedure-date"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("procedure");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "procedure"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dicomSequenceNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "dicom-sequence-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dicomImageNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "dicom-image-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientIcn");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-icn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("patientName");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-name"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteAbbr");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-abbr"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageType");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-type"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "integer"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("absLocation");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "abs-location"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fullLocation");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "full-location"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageClass");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-class"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fullImageURI");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "full-image-URI"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("absImageURI");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "abs-image-URI"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("bigImageURI");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "big-image-URI"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("qaMessage");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "qaMessage"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("captureDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "capture-date"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("documentDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "document-date"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("sensitive");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "sensitive"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("status");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "status"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("viewStatus");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "view-status"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageHasAnnotations");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-has-annotations"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageAnnotationStatus");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-annotation-status"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "integer"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageAnnotationStatusDescription");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-annotation-status-description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("associatedNoteResulted");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "associated-note-resulted"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imagePackage");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-package"));
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
