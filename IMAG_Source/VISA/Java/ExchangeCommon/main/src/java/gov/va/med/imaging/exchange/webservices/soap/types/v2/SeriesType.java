/**
 * SeriesType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.exchange.webservices.soap.types.v2;

public class SeriesType  implements java.io.Serializable {
    private java.lang.String seriesId;

    private java.lang.String dicomUid;

    private java.lang.Integer dicomSeriesNumber;

    private java.lang.String description;

    private java.lang.String modality;

    private int imageCount;

    private gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesTypeComponentInstances componentInstances;

    public SeriesType() {
    }

    public SeriesType(
           java.lang.String seriesId,
           java.lang.String dicomUid,
           java.lang.Integer dicomSeriesNumber,
           java.lang.String description,
           java.lang.String modality,
           int imageCount,
           gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesTypeComponentInstances componentInstances) {
           this.seriesId = seriesId;
           this.dicomUid = dicomUid;
           this.dicomSeriesNumber = dicomSeriesNumber;
           this.description = description;
           this.modality = modality;
           this.imageCount = imageCount;
           this.componentInstances = componentInstances;
    }


    /**
     * Gets the seriesId value for this SeriesType.
     * 
     * @return seriesId
     */
    public java.lang.String getSeriesId() {
        return seriesId;
    }


    /**
     * Sets the seriesId value for this SeriesType.
     * 
     * @param seriesId
     */
    public void setSeriesId(java.lang.String seriesId) {
        this.seriesId = seriesId;
    }


    /**
     * Gets the dicomUid value for this SeriesType.
     * 
     * @return dicomUid
     */
    public java.lang.String getDicomUid() {
        return dicomUid;
    }


    /**
     * Sets the dicomUid value for this SeriesType.
     * 
     * @param dicomUid
     */
    public void setDicomUid(java.lang.String dicomUid) {
        this.dicomUid = dicomUid;
    }


    /**
     * Gets the dicomSeriesNumber value for this SeriesType.
     * 
     * @return dicomSeriesNumber
     */
    public java.lang.Integer getDicomSeriesNumber() {
        return dicomSeriesNumber;
    }


    /**
     * Sets the dicomSeriesNumber value for this SeriesType.
     * 
     * @param dicomSeriesNumber
     */
    public void setDicomSeriesNumber(java.lang.Integer dicomSeriesNumber) {
        this.dicomSeriesNumber = dicomSeriesNumber;
    }


    /**
     * Gets the description value for this SeriesType.
     * 
     * @return description
     */
    public java.lang.String getDescription() {
        return description;
    }


    /**
     * Sets the description value for this SeriesType.
     * 
     * @param description
     */
    public void setDescription(java.lang.String description) {
        this.description = description;
    }


    /**
     * Gets the modality value for this SeriesType.
     * 
     * @return modality
     */
    public java.lang.String getModality() {
        return modality;
    }


    /**
     * Sets the modality value for this SeriesType.
     * 
     * @param modality
     */
    public void setModality(java.lang.String modality) {
        this.modality = modality;
    }


    /**
     * Gets the imageCount value for this SeriesType.
     * 
     * @return imageCount
     */
    public int getImageCount() {
        return imageCount;
    }


    /**
     * Sets the imageCount value for this SeriesType.
     * 
     * @param imageCount
     */
    public void setImageCount(int imageCount) {
        this.imageCount = imageCount;
    }


    /**
     * Gets the componentInstances value for this SeriesType.
     * 
     * @return componentInstances
     */
    public gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesTypeComponentInstances getComponentInstances() {
        return componentInstances;
    }


    /**
     * Sets the componentInstances value for this SeriesType.
     * 
     * @param componentInstances
     */
    public void setComponentInstances(gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesTypeComponentInstances componentInstances) {
        this.componentInstances = componentInstances;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof SeriesType)) return false;
        SeriesType other = (SeriesType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.seriesId==null && other.getSeriesId()==null) || 
             (this.seriesId!=null &&
              this.seriesId.equals(other.getSeriesId()))) &&
            ((this.dicomUid==null && other.getDicomUid()==null) || 
             (this.dicomUid!=null &&
              this.dicomUid.equals(other.getDicomUid()))) &&
            ((this.dicomSeriesNumber==null && other.getDicomSeriesNumber()==null) || 
             (this.dicomSeriesNumber!=null &&
              this.dicomSeriesNumber.equals(other.getDicomSeriesNumber()))) &&
            ((this.description==null && other.getDescription()==null) || 
             (this.description!=null &&
              this.description.equals(other.getDescription()))) &&
            ((this.modality==null && other.getModality()==null) || 
             (this.modality!=null &&
              this.modality.equals(other.getModality()))) &&
            this.imageCount == other.getImageCount() &&
            ((this.componentInstances==null && other.getComponentInstances()==null) || 
             (this.componentInstances!=null &&
              this.componentInstances.equals(other.getComponentInstances())));
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
        if (getSeriesId() != null) {
            _hashCode += getSeriesId().hashCode();
        }
        if (getDicomUid() != null) {
            _hashCode += getDicomUid().hashCode();
        }
        if (getDicomSeriesNumber() != null) {
            _hashCode += getDicomSeriesNumber().hashCode();
        }
        if (getDescription() != null) {
            _hashCode += getDescription().hashCode();
        }
        if (getModality() != null) {
            _hashCode += getModality().hashCode();
        }
        _hashCode += getImageCount();
        if (getComponentInstances() != null) {
            _hashCode += getComponentInstances().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(SeriesType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "SeriesType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("seriesId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "series-id"));
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
        elemField.setFieldName("dicomSeriesNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "dicom-series-number"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("description");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("modality");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "modality"));
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
        elemField.setFieldName("componentInstances");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "component-instances"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", ">SeriesType>component-instances"));
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
