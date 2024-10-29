/**
 * FatExamType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class FatExamType  implements java.io.Serializable {
    private gov.va.med.imaging.vistarad.webservices.soap.v1.ExamTypeDetails examDetails;

    private java.lang.String radiologyReport;

    private java.lang.String requisitionReport;

    private gov.va.med.imaging.vistarad.webservices.soap.v1.ComponentImagesType componentImages;

    private java.lang.String presentationState;

    public FatExamType() {
    }

    public FatExamType(
           gov.va.med.imaging.vistarad.webservices.soap.v1.ExamTypeDetails examDetails,
           java.lang.String radiologyReport,
           java.lang.String requisitionReport,
           gov.va.med.imaging.vistarad.webservices.soap.v1.ComponentImagesType componentImages,
           java.lang.String presentationState) {
           this.examDetails = examDetails;
           this.radiologyReport = radiologyReport;
           this.requisitionReport = requisitionReport;
           this.componentImages = componentImages;
           this.presentationState = presentationState;
    }


    /**
     * Gets the examDetails value for this FatExamType.
     * 
     * @return examDetails
     */
    public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamTypeDetails getExamDetails() {
        return examDetails;
    }


    /**
     * Sets the examDetails value for this FatExamType.
     * 
     * @param examDetails
     */
    public void setExamDetails(gov.va.med.imaging.vistarad.webservices.soap.v1.ExamTypeDetails examDetails) {
        this.examDetails = examDetails;
    }


    /**
     * Gets the radiologyReport value for this FatExamType.
     * 
     * @return radiologyReport
     */
    public java.lang.String getRadiologyReport() {
        return radiologyReport;
    }


    /**
     * Sets the radiologyReport value for this FatExamType.
     * 
     * @param radiologyReport
     */
    public void setRadiologyReport(java.lang.String radiologyReport) {
        this.radiologyReport = radiologyReport;
    }


    /**
     * Gets the requisitionReport value for this FatExamType.
     * 
     * @return requisitionReport
     */
    public java.lang.String getRequisitionReport() {
        return requisitionReport;
    }


    /**
     * Sets the requisitionReport value for this FatExamType.
     * 
     * @param requisitionReport
     */
    public void setRequisitionReport(java.lang.String requisitionReport) {
        this.requisitionReport = requisitionReport;
    }


    /**
     * Gets the componentImages value for this FatExamType.
     * 
     * @return componentImages
     */
    public gov.va.med.imaging.vistarad.webservices.soap.v1.ComponentImagesType getComponentImages() {
        return componentImages;
    }


    /**
     * Sets the componentImages value for this FatExamType.
     * 
     * @param componentImages
     */
    public void setComponentImages(gov.va.med.imaging.vistarad.webservices.soap.v1.ComponentImagesType componentImages) {
        this.componentImages = componentImages;
    }


    /**
     * Gets the presentationState value for this FatExamType.
     * 
     * @return presentationState
     */
    public java.lang.String getPresentationState() {
        return presentationState;
    }


    /**
     * Sets the presentationState value for this FatExamType.
     * 
     * @param presentationState
     */
    public void setPresentationState(java.lang.String presentationState) {
        this.presentationState = presentationState;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof FatExamType)) return false;
        FatExamType other = (FatExamType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.examDetails==null && other.getExamDetails()==null) || 
             (this.examDetails!=null &&
              this.examDetails.equals(other.getExamDetails()))) &&
            ((this.radiologyReport==null && other.getRadiologyReport()==null) || 
             (this.radiologyReport!=null &&
              this.radiologyReport.equals(other.getRadiologyReport()))) &&
            ((this.requisitionReport==null && other.getRequisitionReport()==null) || 
             (this.requisitionReport!=null &&
              this.requisitionReport.equals(other.getRequisitionReport()))) &&
            ((this.componentImages==null && other.getComponentImages()==null) || 
             (this.componentImages!=null &&
              this.componentImages.equals(other.getComponentImages()))) &&
            ((this.presentationState==null && other.getPresentationState()==null) || 
             (this.presentationState!=null &&
              this.presentationState.equals(other.getPresentationState())));
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
        if (getExamDetails() != null) {
            _hashCode += getExamDetails().hashCode();
        }
        if (getRadiologyReport() != null) {
            _hashCode += getRadiologyReport().hashCode();
        }
        if (getRequisitionReport() != null) {
            _hashCode += getRequisitionReport().hashCode();
        }
        if (getComponentImages() != null) {
            _hashCode += getComponentImages().hashCode();
        }
        if (getPresentationState() != null) {
            _hashCode += getPresentationState().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(FatExamType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "FatExamType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("examDetails");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "examDetails"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamTypeDetails"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("radiologyReport");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "radiology-report"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("requisitionReport");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "requisition-report"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("componentImages");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "componentImages"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ComponentImagesType"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("presentationState");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "presentation-state"));
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
