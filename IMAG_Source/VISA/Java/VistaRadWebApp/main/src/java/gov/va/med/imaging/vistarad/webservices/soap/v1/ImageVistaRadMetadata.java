/**
 * ImageVistaRadMetadata.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public interface ImageVistaRadMetadata extends java.rmi.Remote {
    gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite[] getEnterpriseExamList(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String patientIcn) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
    gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite getSiteExamList(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String patientIcn, java.lang.String siteId, boolean forceRefresh, String patListColumnsIndicator) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
    gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType getExamDetails(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
    boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String inputParameter, java.lang.String siteId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
    gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse pingServer(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String clientWorkstation, java.lang.String requestSiteNumber) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
    gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse prefetchExam(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
    java.lang.String getReport(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
    gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType getActiveWorklist(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String siteNumber, java.lang.String userDivision, java.lang.String listDescriptor) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
    java.lang.String getRequisition(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
    java.lang.String remoteMethodPassthrough(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String siteNumber, java.lang.String methodName, gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType[] parameters) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
    gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType[] getExamSiteMetadataCachedStatus(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String patientIcn, java.lang.String[] siteNumber) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
}
