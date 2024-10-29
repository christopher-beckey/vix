/**
 * StudyListResponseType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.exchange.webservices.soap.types.v2;

public class StudyListResponseType  implements java.io.Serializable {
    private boolean partialResponse;

    private gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType[] studies;

    private gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType[] errors;

    public StudyListResponseType() {
    }

    public StudyListResponseType(
           boolean partialResponse,
           gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType[] studies,
           gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType[] errors) {
           this.partialResponse = partialResponse;
           this.studies = studies;
           this.errors = errors;
    }


    /**
     * Gets the partialResponse value for this StudyListResponseType.
     * 
     * @return partialResponse
     */
    public boolean isPartialResponse() {
        return partialResponse;
    }


    /**
     * Sets the partialResponse value for this StudyListResponseType.
     * 
     * @param partialResponse
     */
    public void setPartialResponse(boolean partialResponse) {
        this.partialResponse = partialResponse;
    }


    /**
     * Gets the studies value for this StudyListResponseType.
     * 
     * @return studies
     */
    public gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType[] getStudies() {
        return studies;
    }


    /**
     * Sets the studies value for this StudyListResponseType.
     * 
     * @param studies
     */
    public void setStudies(gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType[] studies) {
        this.studies = studies;
    }

    public gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType getStudies(int i) {
        return this.studies[i];
    }

    public void setStudies(int i, gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyType _value) {
        this.studies[i] = _value;
    }


    /**
     * Gets the errors value for this StudyListResponseType.
     * 
     * @return errors
     */
    public gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType[] getErrors() {
        return errors;
    }


    /**
     * Sets the errors value for this StudyListResponseType.
     * 
     * @param errors
     */
    public void setErrors(gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType[] errors) {
        this.errors = errors;
    }

    public gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType getErrors(int i) {
        return this.errors[i];
    }

    public void setErrors(int i, gov.va.med.imaging.exchange.webservices.soap.types.v2.ErrorResultType _value) {
        this.errors[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof StudyListResponseType)) return false;
        StudyListResponseType other = (StudyListResponseType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.partialResponse == other.isPartialResponse() &&
            ((this.studies==null && other.getStudies()==null) || 
             (this.studies!=null &&
              java.util.Arrays.equals(this.studies, other.getStudies()))) &&
            ((this.errors==null && other.getErrors()==null) || 
             (this.errors!=null &&
              java.util.Arrays.equals(this.errors, other.getErrors())));
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
        _hashCode += (isPartialResponse() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        if (getStudies() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getStudies());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getStudies(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getErrors() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getErrors());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getErrors(), i);
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
        new org.apache.axis.description.TypeDesc(StudyListResponseType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "StudyListResponseType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("partialResponse");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "partial-response"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("studies");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "studies"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "StudyType"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("errors");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "errors"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "ErrorResultType"));
        elemField.setMinOccurs(0);
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
