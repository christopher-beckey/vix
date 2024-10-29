/**
 * ImageClinicalDisplayMetadata.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v2;

public interface ImageClinicalDisplayMetadata extends java.rmi.Remote {
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType[] getPatientShallowStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType[] getStudyImageList(java.lang.String transactionId, java.lang.String studyId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException;
    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventType logEvent) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.PingServerTypeResponse pingServerEvent(java.lang.String transactionId, java.lang.String clientWorkstation, java.lang.String requestSiteNumber, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String prefetchStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String getImageInformation(java.lang.String imageId, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String getStudyImageInformation(java.lang.String studyId, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String getImageSystemGlobalNode(java.lang.String imageId, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String getStudySystemGlobalNode(java.lang.String studyId, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String getImageDevFields(java.lang.String imageId, java.lang.String flags, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException;
    public java.lang.String getStudyDevFields(java.lang.String studyId, java.lang.String flags, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException;
}
