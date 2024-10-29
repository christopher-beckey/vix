/**
 * ErrorResultType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.mix.webservices.rest.types.v1;

public class ErrorResultType  implements java.io.Serializable {
    private java.lang.String codeContext;

    private gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType severity;

    private java.lang.String location;

    private gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType errorCode;

    public ErrorResultType() {
    }

    public ErrorResultType(
           java.lang.String codeContext,
           gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType severity,
           java.lang.String location,
           gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType errorCode) {
           this.codeContext = codeContext;
           this.severity = severity;
           this.location = location;
           this.errorCode = errorCode;
    }


    /**
     * Gets the codeContext value for this ErrorResultType.
     * 
     * @return codeContext
     */
    public java.lang.String getCodeContext() {
        return codeContext;
    }


    /**
     * Sets the codeContext value for this ErrorResultType.
     * 
     * @param codeContext
     */
    public void setCodeContext(java.lang.String codeContext) {
        this.codeContext = codeContext;
    }


    /**
     * Gets the severity value for this ErrorResultType.
     * 
     * @return severity
     */
    public gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType getSeverity() {
        return severity;
    }


    /**
     * Sets the severity value for this ErrorResultType.
     * 
     * @param severity
     */
    public void setSeverity(gov.va.med.imaging.mix.webservices.rest.types.v1.SeverityType severity) {
        this.severity = severity;
    }


    /**
     * Gets the location value for this ErrorResultType.
     * 
     * @return location
     */
    public java.lang.String getLocation() {
        return location;
    }


    /**
     * Sets the location value for this ErrorResultType.
     * 
     * @param location
     */
    public void setLocation(java.lang.String location) {
        this.location = location;
    }


    /**
     * Gets the errorCode value for this ErrorResultType.
     * 
     * @return errorCode
     */
    public gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType getErrorCode() {
        return errorCode;
    }


    /**
     * Sets the errorCode value for this ErrorResultType.
     * 
     * @param errorCode
     */
    public void setErrorCode(gov.va.med.imaging.mix.webservices.rest.types.v1.ErrorCodeType errorCode) {
        this.errorCode = errorCode;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ErrorResultType)) return false;
        ErrorResultType other = (ErrorResultType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.codeContext==null && other.getCodeContext()==null) || 
             (this.codeContext!=null &&
              this.codeContext.equals(other.getCodeContext()))) &&
            ((this.severity==null && other.getSeverity()==null) || 
             (this.severity!=null &&
              this.severity.equals(other.getSeverity()))) &&
            ((this.location==null && other.getLocation()==null) || 
             (this.location!=null &&
              this.location.equals(other.getLocation()))) &&
            ((this.errorCode==null && other.getErrorCode()==null) || 
             (this.errorCode!=null &&
              this.errorCode.equals(other.getErrorCode())));
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
        if (getCodeContext() != null) {
            _hashCode += getCodeContext().hashCode();
        }
        if (getSeverity() != null) {
            _hashCode += getSeverity().hashCode();
        }
        if (getLocation() != null) {
            _hashCode += getLocation().hashCode();
        }
        if (getErrorCode() != null) {
            _hashCode += getErrorCode().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ErrorResultType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "ErrorResultType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("codeContext");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "code-context"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("severity");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "severity"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "SeverityType"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("location");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "location"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("errorCode");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "error-code"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "ErrorCodeType"));
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
