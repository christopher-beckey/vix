/**
 * ReportTypeProcedureCodes.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.mix.webservices.rest.types.v1;

public class ReportTypeProcedureCodes  implements java.io.Serializable {
    private java.lang.String[] cptCode;

    public ReportTypeProcedureCodes() {
    }

    public ReportTypeProcedureCodes(
           java.lang.String[] cptCode) {
           this.cptCode = cptCode;
    }


    /**
     * Gets the cptCode value for this ReportTypeProcedureCodes.
     * 
     * @return cptCode
     */
    public java.lang.String[] getCptCode() {
        return cptCode;
    }


    /**
     * Sets the cptCode value for this ReportTypeProcedureCodes.
     * 
     * @param cptCode
     */
    public void setCptCode(java.lang.String[] cptCode) {
        this.cptCode = cptCode;
    }

    public java.lang.String getCptCode(int i) {
        return this.cptCode[i];
    }

    public void setCptCode(int i, java.lang.String _value) {
        this.cptCode[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ReportTypeProcedureCodes)) return false;
        ReportTypeProcedureCodes other = (ReportTypeProcedureCodes) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.cptCode==null && other.getCptCode()==null) || 
             (this.cptCode!=null &&
              java.util.Arrays.equals(this.cptCode, other.getCptCode())));
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
        if (getCptCode() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getCptCode());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getCptCode(), i);
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
        new org.apache.axis.description.TypeDesc(ReportTypeProcedureCodes.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", ">ReportType>procedure-codes"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("cptCode");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "cpt-code"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "CptCodeType"));
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
