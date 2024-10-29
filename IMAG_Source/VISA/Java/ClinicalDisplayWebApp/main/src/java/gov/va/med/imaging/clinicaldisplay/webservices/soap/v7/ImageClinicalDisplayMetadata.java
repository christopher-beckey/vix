/**
 * ImageClinicalDisplayMetadata.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v7;

public interface ImageClinicalDisplayMetadata extends java.rmi.Remote {
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType getPatientShallowStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.math.BigInteger authorizedSensitivityLevel, boolean includeArtifacts) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType[] getStudyImageList(java.lang.String transactionId, java.lang.String studyId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, boolean includeDeletedImages) throws java.rmi.RemoteException;
    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventType logEvent) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse pingServerEvent(java.lang.String transactionId, java.lang.String clientWorkstation, java.lang.String requestSiteNumber, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PrefetchResponseTypePrefetchResponse prefetchStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) throws java.rmi.RemoteException;
    public java.lang.String getImageInformation(java.lang.String id, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, boolean includeDeletedImages) throws java.rmi.RemoteException;
    public java.lang.String getImageSystemGlobalNode(java.lang.String id, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) throws java.rmi.RemoteException;
    public java.lang.String getImageDevFields(java.lang.String id, java.lang.String flags, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitiveCheckResponseType getPatientSensitivityLevel(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) throws java.rmi.RemoteException;
    public java.lang.String getStudyReport(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String studyId) throws java.rmi.RemoteException;
    public java.lang.String remoteMethodPassthrough(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String siteId, java.lang.String methodName, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodInputParameterType inputParameters) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[] getImageAnnotations(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String imageId) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationDetailsType getAnnotationDetails(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String imageId, java.lang.String annotationId) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType postAnnotationDetails(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String imageId, java.lang.String details, java.lang.String version, java.lang.String source) throws java.rmi.RemoteException;
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserType getUserDetails(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String siteId) throws java.rmi.RemoteException;
    public boolean isAnnotationsSupported(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String siteId) throws java.rmi.RemoteException;
}
