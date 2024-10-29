/**
 * GetActiveWorklistResponseContentsType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class GetActiveWorklistResponseContentsType  implements java.io.Serializable {
    private java.lang.String headerLine1;

    private java.lang.String headerLine2;

    private gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType[] worklistItems;

    public GetActiveWorklistResponseContentsType() {
    }

    public GetActiveWorklistResponseContentsType(
           java.lang.String headerLine1,
           java.lang.String headerLine2,
           gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType[] worklistItems) {
           this.headerLine1 = headerLine1;
           this.headerLine2 = headerLine2;
           this.worklistItems = worklistItems;
    }


    /**
     * Gets the headerLine1 value for this GetActiveWorklistResponseContentsType.
     * 
     * @return headerLine1
     */
    public java.lang.String getHeaderLine1() {
        return headerLine1;
    }


    /**
     * Sets the headerLine1 value for this GetActiveWorklistResponseContentsType.
     * 
     * @param headerLine1
     */
    public void setHeaderLine1(java.lang.String headerLine1) {
        this.headerLine1 = headerLine1;
    }


    /**
     * Gets the headerLine2 value for this GetActiveWorklistResponseContentsType.
     * 
     * @return headerLine2
     */
    public java.lang.String getHeaderLine2() {
        return headerLine2;
    }


    /**
     * Sets the headerLine2 value for this GetActiveWorklistResponseContentsType.
     * 
     * @param headerLine2
     */
    public void setHeaderLine2(java.lang.String headerLine2) {
        this.headerLine2 = headerLine2;
    }


    /**
     * Gets the worklistItems value for this GetActiveWorklistResponseContentsType.
     * 
     * @return worklistItems
     */
    public gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType[] getWorklistItems() {
        return worklistItems;
    }


    /**
     * Sets the worklistItems value for this GetActiveWorklistResponseContentsType.
     * 
     * @param worklistItems
     */
    public void setWorklistItems(gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType[] worklistItems) {
        this.worklistItems = worklistItems;
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType getWorklistItems(int i) {
        return this.worklistItems[i];
    }

    public void setWorklistItems(int i, gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType _value) {
        this.worklistItems[i] = _value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GetActiveWorklistResponseContentsType)) return false;
        GetActiveWorklistResponseContentsType other = (GetActiveWorklistResponseContentsType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.headerLine1==null && other.getHeaderLine1()==null) || 
             (this.headerLine1!=null &&
              this.headerLine1.equals(other.getHeaderLine1()))) &&
            ((this.headerLine2==null && other.getHeaderLine2()==null) || 
             (this.headerLine2!=null &&
              this.headerLine2.equals(other.getHeaderLine2()))) &&
            ((this.worklistItems==null && other.getWorklistItems()==null) || 
             (this.worklistItems!=null &&
              java.util.Arrays.equals(this.worklistItems, other.getWorklistItems())));
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
        if (getHeaderLine1() != null) {
            _hashCode += getHeaderLine1().hashCode();
        }
        if (getHeaderLine2() != null) {
            _hashCode += getHeaderLine2().hashCode();
        }
        if (getWorklistItems() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getWorklistItems());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getWorklistItems(), i);
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
        new org.apache.axis.description.TypeDesc(GetActiveWorklistResponseContentsType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "GetActiveWorklistResponseContentsType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("headerLine1");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "headerLine1"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("headerLine2");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "headerLine2"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("worklistItems");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "worklistItems"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ActiveWorklistItemType"));
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
