/**
 * StudyTypeComponentSeries.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.exchange.webservices.soap.types.v2;

public class StudyTypeComponentSeries  implements java.io.Serializable {
    private gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType[] series;

    public StudyTypeComponentSeries() {
    }

    public StudyTypeComponentSeries(
           gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType[] series) {
           this.series = series;
    }


    /**
     * Gets the series value for this StudyTypeComponentSeries.
     * 
     * @return series
     */
    public gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType[] getSeries() {
        return series;
    }


    /**
     * Sets the series value for this StudyTypeComponentSeries.
     * 
     * @param series
     */
    public void setSeries(gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType[] series) {
        this.series = series;
    }

    public gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType getSeries(int i) {
        return this.series[i];
    }

    public void setSeries(int i, gov.va.med.imaging.exchange.webservices.soap.types.v2.SeriesType _value) {
        this.series[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof StudyTypeComponentSeries)) return false;
        StudyTypeComponentSeries other = (StudyTypeComponentSeries) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.series==null && other.getSeries()==null) || 
             (this.series!=null &&
              java.util.Arrays.equals(this.series, other.getSeries())));
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
        if (getSeries() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getSeries());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getSeries(), i);
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
        new org.apache.axis.description.TypeDesc(StudyTypeComponentSeries.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", ">StudyType>component-series"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("series");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "series"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "SeriesType"));
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
