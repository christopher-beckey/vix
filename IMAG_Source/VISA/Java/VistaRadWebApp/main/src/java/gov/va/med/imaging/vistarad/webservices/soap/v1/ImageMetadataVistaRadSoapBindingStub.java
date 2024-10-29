/**
 * ImageMetadataVistaRadSoapBindingStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class ImageMetadataVistaRadSoapBindingStub extends org.apache.axis.client.Stub implements gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata {
    private java.util.Vector cachedSerClasses = new java.util.Vector();
    private java.util.Vector cachedSerQNames = new java.util.Vector();
    private java.util.Vector cachedSerFactories = new java.util.Vector();
    private java.util.Vector cachedDeserFactories = new java.util.Vector();

    static org.apache.axis.description.OperationDesc [] _operations;

    static {
        _operations = new org.apache.axis.description.OperationDesc[11];
        _initOperationDesc1();
        _initOperationDesc2();
    }

    private static void _initOperationDesc1(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getEnterpriseExamList");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamSite"));
        oper.setReturnClass(gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[0] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getSiteExamList");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "force-refresh"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"), boolean.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamSite"));
        oper.setReturnClass(gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[1] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getExamDetails");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "StudyIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "FatExamType"));
        oper.setReturnClass(gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "study"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[2] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("postImageAccessEvent");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "input-parameter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "LogExamAccessInputType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        oper.setReturnClass(boolean.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "result"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[3] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("pingServer");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "clientWorkstation"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "requestSiteNumber"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", ">PingServerType>pingResponse"));
        oper.setReturnClass(gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "pingResponse"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[4] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("prefetchExam");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "StudyIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", ">PrefetchResponseType>prefetchResponse"));
        oper.setReturnClass(gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "prefetchResponse"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[5] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getReport");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "StudyIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "reportDetails"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[6] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getActiveWorklist");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "siteNumber"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "user-division"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false);
        param.setNillable(true);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "listDescriptor"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ListDescriptorType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "GetActiveWorklistResponseContentsType"));
        oper.setReturnClass(gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "response"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[7] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getRequisition");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "StudyIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "reportDetails"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[8] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("remoteMethodPassthrough");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "siteNumber"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "method-name"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodNameType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "parameters"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodParameterType"), gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType[].class, false, false);
        param.setNillable(true);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "response"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[9] = oper;

    }

    private static void _initOperationDesc2(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getExamSiteMetadataCachedStatus");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site-number"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String[].class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamSiteMetadataCachedStatusType"));
        oper.setReturnClass(gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exams"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        oper.addFault(new org.apache.axis.description.FaultDesc(
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"),
                      "gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType",
                      new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"), 
                      true
                     ));
        _operations[10] = oper;

    }

    public ImageMetadataVistaRadSoapBindingStub() throws org.apache.axis.AxisFault {
         this(null);
    }

    public ImageMetadataVistaRadSoapBindingStub(java.net.URL endpointURL, javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
         this(service);
         super.cachedEndpoint = endpointURL;
    }

    public ImageMetadataVistaRadSoapBindingStub(javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
        if (service == null) {
            super.service = new org.apache.axis.client.Service();
        } else {
            super.service = service;
        }
        ((org.apache.axis.client.Service)super.service).setTypeMappingVersion("1.2");
            java.lang.Class cls;
            javax.xml.namespace.QName qName;
            javax.xml.namespace.QName qName2;
            java.lang.Class beansf = org.apache.axis.encoding.ser.BeanSerializerFactory.class;
            java.lang.Class beandf = org.apache.axis.encoding.ser.BeanDeserializerFactory.class;
            java.lang.Class enumsf = org.apache.axis.encoding.ser.EnumSerializerFactory.class;
            java.lang.Class enumdf = org.apache.axis.encoding.ser.EnumDeserializerFactory.class;
            java.lang.Class arraysf = org.apache.axis.encoding.ser.ArraySerializerFactory.class;
            java.lang.Class arraydf = org.apache.axis.encoding.ser.ArrayDeserializerFactory.class;
            java.lang.Class simplesf = org.apache.axis.encoding.ser.SimpleSerializerFactory.class;
            java.lang.Class simpledf = org.apache.axis.encoding.ser.SimpleDeserializerFactory.class;
            java.lang.Class simplelistsf = org.apache.axis.encoding.ser.SimpleListSerializerFactory.class;
            java.lang.Class simplelistdf = org.apache.axis.encoding.ser.SimpleListDeserializerFactory.class;
            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", ">ExamSite>status");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteStatus.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", ">PingServerType>pingResponse");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", ">PrefetchResponseType>prefetchResponse");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ActiveWorklistItemType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.ActiveWorklistItemType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ComponentImagesType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.ComponentImagesType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "CPTCodeType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamImageType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.ExamImageType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamSite");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamSiteMetadataCachedStatusType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamTypeDetails");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.ExamTypeDetails.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "FatExamType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "GetActiveWorklistResponseContentsType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "HeaderStringType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ImageUrnType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ListDescriptorType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "LogExamAccessInputType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ModalityType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "PatientIdentifierType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RawStringType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodNameType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodParameterMultipleType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterMultipleType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodParameterType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodParameterTypeType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterTypeType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodParameterValueType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterValueType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ShallowExamType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.ShallowExamType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteAbbreviationType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteNameType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SocialSecurityNumberType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "StudyIdentifierType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

    }

    protected org.apache.axis.client.Call createCall() throws java.rmi.RemoteException {
        try {
            org.apache.axis.client.Call _call = super._createCall();
            if (super.maintainSessionSet) {
                _call.setMaintainSession(super.maintainSession);
            }
            if (super.cachedUsername != null) {
                _call.setUsername(super.cachedUsername);
            }
            if (super.cachedPassword != null) {
                _call.setPassword(super.cachedPassword);
            }
            if (super.cachedEndpoint != null) {
                _call.setTargetEndpointAddress(super.cachedEndpoint);
            }
            if (super.cachedTimeout != null) {
                _call.setTimeout(super.cachedTimeout);
            }
            if (super.cachedPortName != null) {
                _call.setPortName(super.cachedPortName);
            }
            java.util.Enumeration keys = super.cachedProperties.keys();
            while (keys.hasMoreElements()) {
                java.lang.String key = (java.lang.String) keys.nextElement();
                _call.setProperty(key, super.cachedProperties.get(key));
            }
            // All the type mapping information is registered
            // when the first call is made.
            // The type mapping information is actually registered in
            // the TypeMappingRegistry of the service, which
            // is the reason why registration is only needed for the first call.
            synchronized (this) {
                if (firstCall()) {
                    // must set encoding style before registering serializers
                    _call.setEncodingStyle(null);
                    for (int i = 0; i < cachedSerFactories.size(); ++i) {
                        java.lang.Class cls = (java.lang.Class) cachedSerClasses.get(i);
                        javax.xml.namespace.QName qName =
                                (javax.xml.namespace.QName) cachedSerQNames.get(i);
                        java.lang.Object x = cachedSerFactories.get(i);
                        if (x instanceof Class) {
                            java.lang.Class sf = (java.lang.Class)
                                 cachedSerFactories.get(i);
                            java.lang.Class df = (java.lang.Class)
                                 cachedDeserFactories.get(i);
                            _call.registerTypeMapping(cls, qName, sf, df, false);
                        }
                        else if (x instanceof javax.xml.rpc.encoding.SerializerFactory) {
                            org.apache.axis.encoding.SerializerFactory sf = (org.apache.axis.encoding.SerializerFactory)
                                 cachedSerFactories.get(i);
                            org.apache.axis.encoding.DeserializerFactory df = (org.apache.axis.encoding.DeserializerFactory)
                                 cachedDeserFactories.get(i);
                            _call.registerTypeMapping(cls, qName, sf, df, false);
                        }
                    }
                }
            }
            return _call;
        }
        catch (java.lang.Throwable _t) {
            throw new org.apache.axis.AxisFault("Failure trying to get the Call object", _t);
        }
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite[] getEnterpriseExamList(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String patientIcn) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[0]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getEnterpriseExamList");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getEnterpriseExamList"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, patientIcn});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite[]) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite[].class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite getSiteExamList(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String patientIcn, java.lang.String siteId, boolean forceRefresh) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[1]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getSiteExamList");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getSiteExamList"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, patientIcn, siteId, new java.lang.Boolean(forceRefresh)});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType getExamDetails(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[2]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getExamDetails");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getExamDetails"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, examId});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String inputParameter, java.lang.String siteId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[3]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("postImageAccessEvent");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "postImageAccessEvent"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, inputParameter, siteId});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return ((java.lang.Boolean) _resp).booleanValue();
            } catch (java.lang.Exception _exception) {
                return ((java.lang.Boolean) org.apache.axis.utils.JavaUtils.convert(_resp, boolean.class)).booleanValue();
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse pingServer(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String clientWorkstation, java.lang.String requestSiteNumber) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[4]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("pingServer");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "pingServer"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, clientWorkstation, requestSiteNumber});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse prefetchExam(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[5]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("prefetchExam");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "prefetchExam"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, examId});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public java.lang.String getReport(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[6]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getReport");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getReport"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, examId});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (java.lang.String) _resp;
            } catch (java.lang.Exception _exception) {
                return (java.lang.String) org.apache.axis.utils.JavaUtils.convert(_resp, java.lang.String.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType getActiveWorklist(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String siteNumber, java.lang.String userDivision, java.lang.String listDescriptor) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[7]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getActiveWorklist");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getActiveWorklist"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, siteNumber, userDivision, listDescriptor});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public java.lang.String getRequisition(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[8]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getRequisition");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getRequisition"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, examId});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (java.lang.String) _resp;
            } catch (java.lang.Exception _exception) {
                return (java.lang.String) org.apache.axis.utils.JavaUtils.convert(_resp, java.lang.String.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public java.lang.String remoteMethodPassthrough(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String siteNumber, java.lang.String methodName, gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType[] parameters) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[9]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("remoteMethodPassthrough");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "remoteMethodPassthrough"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, siteNumber, methodName, parameters});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (java.lang.String) _resp;
            } catch (java.lang.Exception _exception) {
                return (java.lang.String) org.apache.axis.utils.JavaUtils.convert(_resp, java.lang.String.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType[] getExamSiteMetadataCachedStatus(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String patientIcn, java.lang.String[] siteNumber) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[10]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getExamSiteMetadataCachedStatus");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getExamSiteMetadataCachedStatus"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, patientIcn, siteNumber});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType[]) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType[].class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
    if (axisFaultException.detail != null) {
        if (axisFaultException.detail instanceof java.rmi.RemoteException) {
              throw (java.rmi.RemoteException) axisFaultException.detail;
         }
        if (axisFaultException.detail instanceof gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) {
              throw (gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType) axisFaultException.detail;
         }
   }
  throw axisFaultException;
}
    }

}
