/**
 * RequestorType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.ax.webservices.rest.types;

public class RequestorType  implements java.io.Serializable {
    private java.lang.String username;

    private java.lang.String ssn;

    private java.lang.String facilityId;

    private java.lang.String facilityName;

    private java.lang.String purposeOfUse;

    public RequestorType() {
    }

    public RequestorType(
           java.lang.String username,
           java.lang.String ssn,
           java.lang.String facilityId,
           java.lang.String facilityName,
           java.lang.String purposeOfUse) {
           this.username = username;
           this.ssn = ssn;
           this.facilityId = facilityId;
           this.facilityName = facilityName;
           this.purposeOfUse = purposeOfUse;
    }


    /**
     * Gets the username value for this RequestorType.
     * 
     * @return username
     */
    public java.lang.String getUsername() {
        return username;
    }


    /**
     * Sets the username value for this RequestorType.
     * 
     * @param username
     */
    public void setUsername(java.lang.String username) {
        this.username = username;
    }


    /**
     * Gets the ssn value for this RequestorType.
     * 
     * @return ssn
     */
    public java.lang.String getSsn() {
        return ssn;
    }


    /**
     * Sets the ssn value for this RequestorType.
     * 
     * @param ssn
     */
    public void setSsn(java.lang.String ssn) {
        this.ssn = ssn;
    }


    /**
     * Gets the facilityId value for this RequestorType.
     * 
     * @return facilityId
     */
    public java.lang.String getFacilityId() {
        return facilityId;
    }


    /**
     * Sets the facilityId value for this RequestorType.
     * 
     * @param facilityId
     */
    public void setFacilityId(java.lang.String facilityId) {
        this.facilityId = facilityId;
    }


    /**
     * Gets the facilityName value for this RequestorType.
     * 
     * @return facilityName
     */
    public java.lang.String getFacilityName() {
        return facilityName;
    }


    /**
     * Sets the facilityName value for this RequestorType.
     * 
     * @param facilityName
     */
    public void setFacilityName(java.lang.String facilityName) {
        this.facilityName = facilityName;
    }


    /**
     * Gets the purposeOfUse value for this RequestorType.
     * 
     * @return purposeOfUse
     */
    public java.lang.String getPurposeOfUse() {
        return purposeOfUse;
    }


    /**
     * Sets the purposeOfUse value for this RequestorType.
     * 
     * @param purposeOfUse
     */
    public void setPurposeOfUse(java.lang.String purposeOfUse) {
        this.purposeOfUse = purposeOfUse;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof RequestorType)) return false;
        RequestorType other = (RequestorType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.username==null && other.getUsername()==null) || 
             (this.username!=null &&
              this.username.equals(other.getUsername()))) &&
            ((this.ssn==null && other.getSsn()==null) || 
             (this.ssn!=null &&
              this.ssn.equals(other.getSsn()))) &&
            ((this.facilityId==null && other.getFacilityId()==null) || 
             (this.facilityId!=null &&
              this.facilityId.equals(other.getFacilityId()))) &&
            ((this.facilityName==null && other.getFacilityName()==null) || 
             (this.facilityName!=null &&
              this.facilityName.equals(other.getFacilityName()))) &&
            ((this.purposeOfUse==null && other.getPurposeOfUse()==null) || 
             (this.purposeOfUse!=null &&
              this.purposeOfUse.equals(other.getPurposeOfUse())));
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
        if (getUsername() != null) {
            _hashCode += getUsername().hashCode();
        }
        if (getSsn() != null) {
            _hashCode += getSsn().hashCode();
        }
        if (getFacilityId() != null) {
            _hashCode += getFacilityId().hashCode();
        }
        if (getFacilityName() != null) {
            _hashCode += getFacilityName().hashCode();
        }
        if (getPurposeOfUse() != null) {
            _hashCode += getPurposeOfUse().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

}
