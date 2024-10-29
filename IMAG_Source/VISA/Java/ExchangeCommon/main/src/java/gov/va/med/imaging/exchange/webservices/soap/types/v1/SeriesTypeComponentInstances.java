/**
 * SeriesTypeComponentInstances.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.exchange.webservices.soap.types.v1;

public class SeriesTypeComponentInstances  implements java.io.Serializable {
    private gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType[] instance;

    public SeriesTypeComponentInstances() {
    }

    public SeriesTypeComponentInstances(
           gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType[] instance) {
           this.instance = instance;
    }


    /**
     * Gets the instance value for this SeriesTypeComponentInstances.
     * 
     * @return instance
     */
    public gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType[] getInstance() {
        return instance;
    }


    /**
     * Sets the instance value for this SeriesTypeComponentInstances.
     * 
     * @param instance
     */
    public void setInstance(gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType[] instance) {
        this.instance = instance;
    }

    public gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType getInstance(int i) {
        return this.instance[i];
    }

    public void setInstance(int i, gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType _value) {
        this.instance[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof SeriesTypeComponentInstances)) return false;
        SeriesTypeComponentInstances other = (SeriesTypeComponentInstances) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.instance==null && other.getInstance()==null) || 
             (this.instance!=null &&
              java.util.Arrays.equals(this.instance, other.getInstance())));
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
        if (getInstance() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getInstance());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getInstance(), i);
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
        new org.apache.axis.description.TypeDesc(SeriesTypeComponentInstances.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.types.soap.webservices.exchange.imaging.med.va.gov", ">SeriesType>component-instances"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("instance");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.types.soap.webservices.exchange.imaging.med.va.gov", "instance"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v1.types.soap.webservices.exchange.imaging.med.va.gov", "InstanceType"));
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
