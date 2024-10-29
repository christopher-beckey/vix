/**
 * ImageMetadata.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.exchange.webservices.soap.v1;

public interface ImageMetadata extends java.rmi.Remote {
    public gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType[] getPatientStudyList(java.lang.String datasource, gov.va.med.imaging.exchange.webservices.soap.types.v1.RequestorType requestor, gov.va.med.imaging.exchange.webservices.soap.types.v1.FilterType filter, java.lang.String patientId, java.lang.String transactionId) throws java.rmi.RemoteException;
}
