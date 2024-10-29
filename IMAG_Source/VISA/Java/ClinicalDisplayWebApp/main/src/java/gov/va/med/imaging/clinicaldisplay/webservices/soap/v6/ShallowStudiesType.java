/**
 * ShallowStudiesType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v6;

public class ShallowStudiesType  implements java.io.Serializable {
    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesStudiesType studies;

    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesErrorMessageType error;

    private boolean partialResult;

    private java.lang.String partialResultMessage;

    public ShallowStudiesType() {
    }

    public ShallowStudiesType(
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesStudiesType studies,
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesErrorMessageType error,
           boolean partialResult,
           java.lang.String partialResultMessage) {
           this.studies = studies;
           this.error = error;
           this.partialResult = partialResult;
           this.partialResultMessage = partialResultMessage;
    }


    /**
     * Gets the studies value for this ShallowStudiesType.
     * 
     * @return studies
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesStudiesType getStudies() {
        return studies;
    }


    /**
     * Sets the studies value for this ShallowStudiesType.
     * 
     * @param studies
     */
    public void setStudies(gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesStudiesType studies) {
        this.studies = studies;
    }


    /**
     * Gets the error value for this ShallowStudiesType.
     * 
     * @return error
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesErrorMessageType getError() {
        return error;
    }


    /**
     * Sets the error value for this ShallowStudiesType.
     * 
     * @param error
     */
    public void setError(gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesErrorMessageType error) {
        this.error = error;
    }


    /**
     * Gets the partialResult value for this ShallowStudiesType.
     * 
     * @return partialResult
     */
    public boolean isPartialResult() {
        return partialResult;
    }


    /**
     * Sets the partialResult value for this ShallowStudiesType.
     * 
     * @param partialResult
     */
    public void setPartialResult(boolean partialResult) {
        this.partialResult = partialResult;
    }


    /**
     * Gets the partialResultMessage value for this ShallowStudiesType.
     * 
     * @return partialResultMessage
     */
    public java.lang.String getPartialResultMessage() {
        return partialResultMessage;
    }


    /**
     * Sets the partialResultMessage value for this ShallowStudiesType.
     * 
     * @param partialResultMessage
     */
    public void setPartialResultMessage(java.lang.String partialResultMessage) {
        this.partialResultMessage = partialResultMessage;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ShallowStudiesType)) return false;
        ShallowStudiesType other = (ShallowStudiesType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.studies==null && other.getStudies()==null) || 
             (this.studies!=null &&
              this.studies.equals(other.getStudies()))) &&
            ((this.error==null && other.getError()==null) || 
             (this.error!=null &&
              this.error.equals(other.getError()))) &&
            this.partialResult == other.isPartialResult() &&
            ((this.partialResultMessage==null && other.getPartialResultMessage()==null) || 
             (this.partialResultMessage!=null &&
              this.partialResultMessage.equals(other.getPartialResultMessage())));
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
        if (getStudies() != null) {
            _hashCode += getStudies().hashCode();
        }
        if (getError() != null) {
            _hashCode += getError().hashCode();
        }
        _hashCode += (isPartialResult() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        if (getPartialResultMessage() != null) {
            _hashCode += getPartialResultMessage().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ShallowStudiesType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("studies");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "studies"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesStudiesType"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("error");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "error"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesErrorMessageType"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("partialResult");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "partial-result"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("partialResultMessage");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "partial-result-message"));
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