/**
 * ImageClinicalDisplayMetadata.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap;

public interface ImageClinicalDisplayMetadata extends java.rmi.Remote {
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.ShallowStudyType[] getPatientShallowStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.UserCredentials credentials) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType[] getStudyImageList(java.lang.String transactionId, java.lang.String studyId, gov.va.med.imaging.clinicaldisplay.webservices.soap.UserCredentials credentials) throws java.rmi.RemoteException;
    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.ImageAccessLogEventType logEvent) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.PingServerTypeResponse pingServerEvent(java.lang.String transactionId, java.lang.String clientWorkstation, java.lang.String requestSiteNumber) throws java.rmi.RemoteException;
    public java.lang.String prefetchStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.UserCredentials credentials) throws java.rmi.RemoteException;
}
