/**
 * ShallowStudiesErrorMessageType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v6;

public class ShallowStudiesErrorMessageType  implements java.io.Serializable {
    private java.lang.String errorMessage;

    private java.math.BigInteger errorCode;

    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesErrorType shallowStudiesError;

    public ShallowStudiesErrorMessageType() {
    }

    public ShallowStudiesErrorMessageType(
           java.lang.String errorMessage,
           java.math.BigInteger errorCode,
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesErrorType shallowStudiesError) {
           this.errorMessage = errorMessage;
           this.errorCode = errorCode;
           this.shallowStudiesError = shallowStudiesError;
    }


    /**
     * Gets the errorMessage value for this ShallowStudiesErrorMessageType.
     * 
     * @return errorMessage
     */
    public java.lang.String getErrorMessage() {
        return errorMessage;
    }


    /**
     * Sets the errorMessage value for this ShallowStudiesErrorMessageType.
     * 
     * @param errorMessage
     */
    public void setErrorMessage(java.lang.String errorMessage) {
        this.errorMessage = errorMessage;
    }


    /**
     * Gets the errorCode value for this ShallowStudiesErrorMessageType.
     * 
     * @return errorCode
     */
    public java.math.BigInteger getErrorCode() {
        return errorCode;
    }


    /**
     * Sets the errorCode value for this ShallowStudiesErrorMessageType.
     * 
     * @param errorCode
     */
    public void setErrorCode(java.math.BigInteger errorCode) {
        this.errorCode = errorCode;
    }


    /**
     * Gets the shallowStudiesError value for this ShallowStudiesErrorMessageType.
     * 
     * @return shallowStudiesError
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesErrorType getShallowStudiesError() {
        return shallowStudiesError;
    }


    /**
     * Sets the shallowStudiesError value for this ShallowStudiesErrorMessageType.
     * 
     * @param shallowStudiesError
     */
    public void setShallowStudiesError(gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesErrorType shallowStudiesError) {
        this.shallowStudiesError = shallowStudiesError;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ShallowStudiesErrorMessageType)) return false;
        ShallowStudiesErrorMessageType other = (ShallowStudiesErrorMessageType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.errorMessage==null && other.getErrorMessage()==null) || 
             (this.errorMessage!=null &&
              this.errorMessage.equals(other.getErrorMessage()))) &&
            ((this.errorCode==null && other.getErrorCode()==null) || 
             (this.errorCode!=null &&
              this.errorCode.equals(other.getErrorCode()))) &&
            ((this.shallowStudiesError==null && other.getShallowStudiesError()==null) || 
             (this.shallowStudiesError!=null &&
              this.shallowStudiesError.equals(other.getShallowStudiesError())));
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
        if (getErrorMessage() != null) {
            _hashCode += getErrorMessage().hashCode();
        }
        if (getErrorCode() != null) {
            _hashCode += getErrorCode().hashCode();
        }
        if (getShallowStudiesError() != null) {
            _hashCode += getShallowStudiesError().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ShallowStudiesErrorMessageType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesErrorMessageType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("errorMessage");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "errorMessage"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("errorCode");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "errorCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "integer"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("shallowStudiesError");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "shallowStudiesError"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesErrorType"));
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
