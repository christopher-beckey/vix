/**
 * RemoteMethodInputParameterType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v6;

public class RemoteMethodInputParameterType  implements java.io.Serializable {
    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.RemoteMethodParameterType[] remoteMethodParameter;

    public RemoteMethodInputParameterType() {
    }

    public RemoteMethodInputParameterType(
           gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.RemoteMethodParameterType[] remoteMethodParameter) {
           this.remoteMethodParameter = remoteMethodParameter;
    }


    /**
     * Gets the remoteMethodParameter value for this RemoteMethodInputParameterType.
     * 
     * @return remoteMethodParameter
     */
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.RemoteMethodParameterType[] getRemoteMethodParameter() {
        return remoteMethodParameter;
    }


    /**
     * Sets the remoteMethodParameter value for this RemoteMethodInputParameterType.
     * 
     * @param remoteMethodParameter
     */
    public void setRemoteMethodParameter(gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.RemoteMethodParameterType[] remoteMethodParameter) {
        this.remoteMethodParameter = remoteMethodParameter;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.RemoteMethodParameterType getRemoteMethodParameter(int i) {
        return this.remoteMethodParameter[i];
    }

    public void setRemoteMethodParameter(int i, gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.RemoteMethodParameterType _value) {
        this.remoteMethodParameter[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof RemoteMethodInputParameterType)) return false;
        RemoteMethodInputParameterType other = (RemoteMethodInputParameterType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.remoteMethodParameter==null && other.getRemoteMethodParameter()==null) || 
             (this.remoteMethodParameter!=null &&
              java.util.Arrays.equals(this.remoteMethodParameter, other.getRemoteMethodParameter())));
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
        if (getRemoteMethodParameter() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getRemoteMethodParameter());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getRemoteMethodParameter(), i);
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
        new org.apache.axis.description.TypeDesc(RemoteMethodInputParameterType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodInputParameterType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("remoteMethodParameter");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "remoteMethodParameter"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodParameterType"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
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
