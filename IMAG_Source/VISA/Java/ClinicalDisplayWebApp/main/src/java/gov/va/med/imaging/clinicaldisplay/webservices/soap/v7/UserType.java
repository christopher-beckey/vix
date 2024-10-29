/**
 * UserType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v7;

public class UserType  implements java.io.Serializable {
    private java.lang.String userId;

    private java.lang.String[] key;

    private boolean canCreateAnnotations;

    public UserType() {
    }

    public UserType(
           java.lang.String userId,
           java.lang.String[] key,
           boolean canCreateAnnotations) {
           this.userId = userId;
           this.key = key;
           this.canCreateAnnotations = canCreateAnnotations;
    }


    /**
     * Gets the userId value for this UserType.
     * 
     * @return userId
     */
    public java.lang.String getUserId() {
        return userId;
    }


    /**
     * Sets the userId value for this UserType.
     * 
     * @param userId
     */
    public void setUserId(java.lang.String userId) {
        this.userId = userId;
    }


    /**
     * Gets the key value for this UserType.
     * 
     * @return key
     */
    public java.lang.String[] getKey() {
        return key;
    }


    /**
     * Sets the key value for this UserType.
     * 
     * @param key
     */
    public void setKey(java.lang.String[] key) {
        this.key = key;
    }

    public java.lang.String getKey(int i) {
        return this.key[i];
    }

    public void setKey(int i, java.lang.String _value) {
        this.key[i] = _value;
    }


    /**
     * Gets the canCreateAnnotations value for this UserType.
     * 
     * @return canCreateAnnotations
     */
    public boolean isCanCreateAnnotations() {
        return canCreateAnnotations;
    }


    /**
     * Sets the canCreateAnnotations value for this UserType.
     * 
     * @param canCreateAnnotations
     */
    public void setCanCreateAnnotations(boolean canCreateAnnotations) {
        this.canCreateAnnotations = canCreateAnnotations;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof UserType)) return false;
        UserType other = (UserType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.userId==null && other.getUserId()==null) || 
             (this.userId!=null &&
              this.userId.equals(other.getUserId()))) &&
            ((this.key==null && other.getKey()==null) || 
             (this.key!=null &&
              java.util.Arrays.equals(this.key, other.getKey()))) &&
            this.canCreateAnnotations == other.isCanCreateAnnotations();
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
        if (getUserId() != null) {
            _hashCode += getUserId().hashCode();
        }
        if (getKey() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getKey());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getKey(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        _hashCode += (isCanCreateAnnotations() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(UserType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userId");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "user-id"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("key");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "key"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        elemField.setMaxOccursUnbounded(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("canCreateAnnotations");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "can-create-annotations"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
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
