/**
 * AnnotationType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v7;

public class AnnotationType  implements java.io.Serializable {
    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationUserType user;

    private java.lang.String savedDate;

    private java.lang.String annotationId;

    private java.lang.String imageId;

    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource source;

    private boolean savedAfterResult;

    private java.lang.String annotationVersion;

    private boolean annotationDeleted;

    public AnnotationType() {
    }

    public AnnotationType(
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationUserType user,
           java.lang.String savedDate,
           java.lang.String annotationId,
           java.lang.String imageId,
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource source,
           boolean savedAfterResult,
           java.lang.String annotationVersion,
           boolean annotationDeleted) {
           this.user = user;
           this.savedDate = savedDate;
           this.annotationId = annotationId;
           this.imageId = imageId;
           this.source = source;
           this.savedAfterResult = savedAfterResult;
           this.annotationVersion = annotationVersion;
           this.annotationDeleted = annotationDeleted;
    }


    /**
     * Gets the user value for this AnnotationType.
     * 
     * @return user
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationUserType getUser() {
        return user;
    }


    /**
     * Sets the user value for this AnnotationType.
     * 
     * @param user
     */
    public void setUser(gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationUserType user) {
        this.user = user;
    }


    /**
     * Gets the savedDate value for this AnnotationType.
     * 
     * @return savedDate
     */
    public java.lang.String getSavedDate() {
        return savedDate;
    }


    /**
     * Sets the savedDate value for this AnnotationType.
     * 
     * @param savedDate
     */
    public void setSavedDate(java.lang.String savedDate) {
        this.savedDate = savedDate;
    }


    /**
     * Gets the annotationId value for this AnnotationType.
     * 
     * @return annotationId
     */
    public java.lang.String getAnnotationId() {
        return annotationId;
    }


    /**
     * Sets the annotationId value for this AnnotationType.
     * 
     * @param annotationId
     */
    public void setAnnotationId(java.lang.String annotationId) {
        this.annotationId = annotationId;
    }


    /**
     * Gets the imageId value for this AnnotationType.
     * 
     * @return imageId
     */
    public java.lang.String getImageId() {
        return imageId;
    }


    /**
     * Sets the imageId value for this AnnotationType.
     * 
     * @param imageId
     */
    public void setImageId(java.lang.String imageId) {
        this.imageId = imageId;
    }


    /**
     * Gets the source value for this AnnotationType.
     * 
     * @return source
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource getSource() {
        return source;
    }


    /**
     * Sets the source value for this AnnotationType.
     * 
     * @param source
     */
    public void setSource(gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationTypeSource source) {
        this.source = source;
    }


    /**
     * Gets the savedAfterResult value for this AnnotationType.
     * 
     * @return savedAfterResult
     */
    public boolean isSavedAfterResult() {
        return savedAfterResult;
    }


    /**
     * Sets the savedAfterResult value for this AnnotationType.
     * 
     * @param savedAfterResult
     */
    public void setSavedAfterResult(boolean savedAfterResult) {
        this.savedAfterResult = savedAfterResult;
    }


    /**
     * Gets the annotationVersion value for this AnnotationType.
     * 
     * @return annotationVersion
     */
    public java.lang.String getAnnotationVersion() {
        return annotationVersion;
    }


    /**
     * Sets the annotationVersion value for this AnnotationType.
     * 
     * @param annotationVersion
     */
    public void setAnnotationVersion(java.lang.String annotationVersion) {
        this.annotationVersion = annotationVersion;
    }


    /**
     * Gets the annotationDeleted value for this AnnotationType.
     * 
     * @return annotationDeleted
     */
    public boolean isAnnotationDeleted() {
        return annotationDeleted;
    }


    /**
     * Sets the annotationDeleted value for this AnnotationType.
     * 
     * @param annotationDeleted
     */
    public void setAnnotationDeleted(boolean annotationDeleted) {
        this.annotationDeleted = annotationDeleted;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof AnnotationType)) return false;
        AnnotationType other = (AnnotationType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.user==null && other.getUser()==null) || 
             (this.user!=null &&
              this.user.equals(other.getUser()))) &&
            ((this.savedDate==null && other.getSavedDate()==null) || 
             (this.savedDate!=null &&
              this.savedDate.equals(other.getSavedDate()))) &&
            ((this.annotationId==null && other.getAnnotationId()==null) || 
             (this.annotationId!=null &&
              this.annotationId.equals(other.getAnnotationId()))) &&
            ((this.imageId==null && other.getImageId()==null) || 
             (this.imageId!=null &&
              this.imageId.equals(other.getImageId()))) &&
            ((this.source==null && other.getSource()==null) || 
             (this.source!=null &&
              this.source.equals(other.getSource()))) &&
            this.savedAfterResult == other.isSavedAfterResult() &&
            ((this.annotationVersion==null && other.getAnnotationVersion()==null) || 
             (this.annotationVersion!=null &&
              this.annotationVersion.equals(other.getAnnotationVersion()))) &&
            this.annotationDeleted == other.isAnnotationDeleted();
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
        if (getUser() != null) {
            _hashCode += getUser().hashCode();
        }
        if (getSavedDate() != null) {
            _hashCode += getSavedDate().hashCode();
        }
        if (getAnnotationId() != null) {
            _hashCode += getAnnotationId().hashCode();
        }
        if (getImageId() != null) {
            _hashCode += getImageId().hashCode();
        }
        if (getSource() != null) {
            _hashCode += getSource().hashCode();
        }
        _hashCode += (isSavedAfterResult() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        if (getAnnotationVersion() != null) {
            _hashCode += getAnnotationVersion().hashCode();
        }
        _hashCode += (isAnnotationDeleted() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(AnnotationType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "AnnotationType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("user");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "user"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "AnnotationUserType"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("savedDate");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "saved-date"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("annotationId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "annotation-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("imageId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("source");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "source"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">AnnotationType>source"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("savedAfterResult");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "saved-after-result"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("annotationVersion");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "annotation-version"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("annotationDeleted");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "annotation-deleted"));
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
