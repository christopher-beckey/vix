/**
 * ImageClinicalDisplayMetadata.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v4;

public interface ImageClinicalDisplayMetadata extends java.rmi.Remote {
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ShallowStudiesType getPatientShallowStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.UserCredentials credentials, java.math.BigInteger authorizedSensitivityLevel) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FatImageType[] getStudyImageList(java.lang.String transactionId, java.lang.String studyId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.UserCredentials credentials) throws java.rmi.RemoteException;
    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ImageAccessLogEventType logEvent) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PingServerTypePingResponse pingServerEvent(java.lang.String transactionId, java.lang.String clientWorkstation, java.lang.String requestSiteNumber, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.UserCredentials credentials) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PrefetchResponseTypePrefetchResponse prefetchStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String getImageInformation(java.lang.String id, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String getImageSystemGlobalNode(java.lang.String id, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String getImageDevFields(java.lang.String id, java.lang.String flags, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.UserCredentials credentials) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.PatientSensitiveCheckResponseType getPatientSensitivityLevel(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String getStudyReport(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.UserCredentials credentials, java.lang.String studyId) throws java.rmi.RemoteException;
}
