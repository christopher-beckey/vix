/**
 * ImageMetadata.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.exchange.webservices.soap.v2;

public interface ImageMetadata extends java.rmi.Remote {
    public gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType getPatientStudyList(java.lang.String datasource, gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType requestor, gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType filter, java.lang.String patientId, java.lang.String transactionId, java.lang.String requestedSite) throws java.rmi.RemoteException;
    public gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType getPatientReport(java.lang.String datasource, gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType requestor, java.lang.String patientId, java.lang.String transactionId, java.lang.String studyId) throws java.rmi.RemoteException;
}
