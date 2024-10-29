/**
 * RemoteMethodParameterType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class RemoteMethodParameterType  implements java.io.Serializable {
    private java.math.BigInteger parameterIndex;

    private gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterTypeType parameterType;

    private gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterValueType parameterValue;

    public RemoteMethodParameterType() {
    }

    public RemoteMethodParameterType(
           java.math.BigInteger parameterIndex,
           gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterTypeType parameterType,
           gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterValueType parameterValue) {
           this.parameterIndex = parameterIndex;
           this.parameterType = parameterType;
           this.parameterValue = parameterValue;
    }


    /**
     * Gets the parameterIndex value for this RemoteMethodParameterType.
     * 
     * @return parameterIndex
     */
    public java.math.BigInteger getParameterIndex() {
        return parameterIndex;
    }


    /**
     * Sets the parameterIndex value for this RemoteMethodParameterType.
     * 
     * @param parameterIndex
     */
    public void setParameterIndex(java.math.BigInteger parameterIndex) {
        this.parameterIndex = parameterIndex;
    }


    /**
     * Gets the parameterType value for this RemoteMethodParameterType.
     * 
     * @return parameterType
     */
    public gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterTypeType getParameterType() {
        return parameterType;
    }


    /**
     * Sets the parameterType value for this RemoteMethodParameterType.
     * 
     * @param parameterType
     */
    public void setParameterType(gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterTypeType parameterType) {
        this.parameterType = parameterType;
    }


    /**
     * Gets the parameterValue value for this RemoteMethodParameterType.
     * 
     * @return parameterValue
     */
    public gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterValueType getParameterValue() {
        return parameterValue;
    }


    /**
     * Sets the parameterValue value for this RemoteMethodParameterType.
     * 
     * @param parameterValue
     */
    public void setParameterValue(gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterValueType parameterValue) {
        this.parameterValue = parameterValue;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof RemoteMethodParameterType)) return false;
        RemoteMethodParameterType other = (RemoteMethodParameterType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.parameterIndex==null && other.getParameterIndex()==null) || 
             (this.parameterIndex!=null &&
              this.parameterIndex.equals(other.getParameterIndex()))) &&
            ((this.parameterType==null && other.getParameterType()==null) || 
             (this.parameterType!=null &&
              this.parameterType.equals(other.getParameterType()))) &&
            ((this.parameterValue==null && other.getParameterValue()==null) || 
             (this.parameterValue!=null &&
              this.parameterValue.equals(other.getParameterValue())));
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
        if (getParameterIndex() != null) {
            _hashCode += getParameterIndex().hashCode();
        }
        if (getParameterType() != null) {
            _hashCode += getParameterType().hashCode();
        }
        if (getParameterValue() != null) {
            _hashCode += getParameterValue().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(RemoteMethodParameterType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodParameterType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("parameterIndex");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "parameterIndex"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "integer"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("parameterType");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "parameterType"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodParameterTypeType"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("parameterValue");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "parameterValue"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodParameterValueType"));
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
