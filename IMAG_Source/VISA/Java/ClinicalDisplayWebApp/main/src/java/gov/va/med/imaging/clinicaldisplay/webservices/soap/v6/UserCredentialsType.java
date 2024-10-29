/**
 * UserCredentialsType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v6;

public class UserCredentialsType  implements java.io.Serializable {
    private java.lang.String fullname;

    private java.lang.String duz;

    private java.lang.String ssn;

    private java.lang.String siteName;

    private java.lang.String siteNumber;

    private java.lang.String securityToken;

    private java.lang.String clientVersion;

    public UserCredentialsType() {
    }

    public UserCredentialsType(
           java.lang.String fullname,
           java.lang.String duz,
           java.lang.String ssn,
           java.lang.String siteName,
           java.lang.String siteNumber,
           java.lang.String securityToken,
           java.lang.String clientVersion) {
           this.fullname = fullname;
           this.duz = duz;
           this.ssn = ssn;
           this.siteName = siteName;
           this.siteNumber = siteNumber;
           this.securityToken = securityToken;
           this.clientVersion = clientVersion;
    }


    /**
     * Gets the fullname value for this UserCredentialsType.
     * 
     * @return fullname
     */
    public java.lang.String getFullname() {
        return fullname;
    }


    /**
     * Sets the fullname value for this UserCredentialsType.
     * 
     * @param fullname
     */
    public void setFullname(java.lang.String fullname) {
        this.fullname = fullname;
    }


    /**
     * Gets the duz value for this UserCredentialsType.
     * 
     * @return duz
     */
    public java.lang.String getDuz() {
        return duz;
    }


    /**
     * Sets the duz value for this UserCredentialsType.
     * 
     * @param duz
     */
    public void setDuz(java.lang.String duz) {
        this.duz = duz;
    }


    /**
     * Gets the ssn value for this UserCredentialsType.
     * 
     * @return ssn
     */
    public java.lang.String getSsn() {
        return ssn;
    }


    /**
     * Sets the ssn value for this UserCredentialsType.
     * 
     * @param ssn
     */
    public void setSsn(java.lang.String ssn) {
        this.ssn = ssn;
    }


    /**
     * Gets the siteName value for this UserCredentialsType.
     * 
     * @return siteName
     */
    public java.lang.String getSiteName() {
        return siteName;
    }


    /**
     * Sets the siteName value for this UserCredentialsType.
     * 
     * @param siteName
     */
    public void setSiteName(java.lang.String siteName) {
        this.siteName = siteName;
    }


    /**
     * Gets the siteNumber value for this UserCredentialsType.
     * 
     * @return siteNumber
     */
    public java.lang.String getSiteNumber() {
        return siteNumber;
    }


    /**
     * Sets the siteNumber value for this UserCredentialsType.
     * 
     * @param siteNumber
     */
    public void setSiteNumber(java.lang.String siteNumber) {
        this.siteNumber = siteNumber;
    }


    /**
     * Gets the securityToken value for this UserCredentialsType.
     * 
     * @return securityToken
     */
    public java.lang.String getSecurityToken() {
        return securityToken;
    }


    /**
     * Sets the securityToken value for this UserCredentialsType.
     * 
     * @param securityToken
     */
    public void setSecurityToken(java.lang.String securityToken) {
        this.securityToken = securityToken;
    }


    /**
     * Gets the clientVersion value for this UserCredentialsType.
     * 
     * @return clientVersion
     */
    public java.lang.String getClientVersion() {
        return clientVersion;
    }


    /**
     * Sets the clientVersion value for this UserCredentialsType.
     * 
     * @param clientVersion
     */
    public void setClientVersion(java.lang.String clientVersion) {
        this.clientVersion = clientVersion;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof UserCredentialsType)) return false;
        UserCredentialsType other = (UserCredentialsType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.fullname==null && other.getFullname()==null) || 
             (this.fullname!=null &&
              this.fullname.equals(other.getFullname()))) &&
            ((this.duz==null && other.getDuz()==null) || 
             (this.duz!=null &&
              this.duz.equals(other.getDuz()))) &&
            ((this.ssn==null && other.getSsn()==null) || 
             (this.ssn!=null &&
              this.ssn.equals(other.getSsn()))) &&
            ((this.siteName==null && other.getSiteName()==null) || 
             (this.siteName!=null &&
              this.siteName.equals(other.getSiteName()))) &&
            ((this.siteNumber==null && other.getSiteNumber()==null) || 
             (this.siteNumber!=null &&
              this.siteNumber.equals(other.getSiteNumber()))) &&
            ((this.securityToken==null && other.getSecurityToken()==null) || 
             (this.securityToken!=null &&
              this.securityToken.equals(other.getSecurityToken()))) &&
            ((this.clientVersion==null && other.getClientVersion()==null) || 
             (this.clientVersion!=null &&
              this.clientVersion.equals(other.getClientVersion())));
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
        if (getFullname() != null) {
            _hashCode += getFullname().hashCode();
        }
        if (getDuz() != null) {
            _hashCode += getDuz().hashCode();
        }
        if (getSsn() != null) {
            _hashCode += getSsn().hashCode();
        }
        if (getSiteName() != null) {
            _hashCode += getSiteName().hashCode();
        }
        if (getSiteNumber() != null) {
            _hashCode += getSiteNumber().hashCode();
        }
        if (getSecurityToken() != null) {
            _hashCode += getSecurityToken().hashCode();
        }
        if (getClientVersion() != null) {
            _hashCode += getClientVersion().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(UserCredentialsType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fullname");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "fullname"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("duz");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "duz"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ssn");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ssn"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteName");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "siteName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("siteNumber");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "siteNumber"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("securityToken");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "securityToken"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("clientVersion");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:v6.soap.webservices.clinicaldisplay.imaging.med.va.gov", "client-version"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
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
