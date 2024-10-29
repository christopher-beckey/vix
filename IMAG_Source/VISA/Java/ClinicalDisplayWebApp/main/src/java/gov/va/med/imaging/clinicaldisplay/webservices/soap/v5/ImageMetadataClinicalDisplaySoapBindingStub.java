/**
 * ImageMetadataClinicalDisplaySoapBindingStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v5;

public class ImageMetadataClinicalDisplaySoapBindingStub extends org.apache.axis.client.Stub implements gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata {
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
        oper.setName("getPatientShallowStudyList");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FilterType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "authorizedSensitivityLevel"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "integer"), java.math.BigInteger.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesType"));
        oper.setReturnClass(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "result"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[0] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getStudyImageList");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FatImageType"));
        oper.setReturnClass(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[].class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[1] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("postImageAccessEvent");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "log-event"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ImageAccessLogEventType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventType.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        oper.setReturnClass(boolean.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "result"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[2] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("pingServerEvent");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "clientWorkstation"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "requestSiteNumber"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">PingServerType>pingResponse"));
        oper.setReturnClass(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PingServerTypePingResponse.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "pingResponse"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[3] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("prefetchStudyList");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FilterType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">PrefetchResponseType>prefetchResponse"));
        oper.setReturnClass(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PrefetchResponseTypePrefetchResponse.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "prefetchResponse"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[4] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getImageInformation");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[5] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getImageSystemGlobalNode");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[6] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getImageDevFields");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "flags"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[7] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getPatientSensitivityLevel");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "PatientSensitiveCheckResponseType"));
        oper.setReturnClass(gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "response"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[8] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("getStudyReport");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "studyReport"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[9] = oper;

    }

    private static void _initOperationDesc2(){
        org.apache.axis.description.OperationDesc oper;
        org.apache.axis.description.ParameterDesc param;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("remoteMethodPassthrough");
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "methodName"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodNameType"), java.lang.String.class, false, false);
        oper.addParameter(param);
        param = new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "inputParameters"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodInputParameterType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodInputParameterType.class, false, false);
        oper.addParameter(param);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "response"));
        oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
        oper.setUse(org.apache.axis.constants.Use.LITERAL);
        _operations[10] = oper;

    }

    public ImageMetadataClinicalDisplaySoapBindingStub() throws org.apache.axis.AxisFault {
         this(null);
    }

    public ImageMetadataClinicalDisplaySoapBindingStub(java.net.URL endpointURL, javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
         this(service);
         super.cachedEndpoint = endpointURL;
    }

    public ImageMetadataClinicalDisplaySoapBindingStub(javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
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
            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">FilterType>origin");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterTypeOrigin.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">ImageAccessLogEventType>eventType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventTypeEventType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">PingServerType>pingResponse");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PingServerTypePingResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">PrefetchResponseType>prefetchResponse");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PrefetchResponseTypePrefetchResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "DateType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FatImageType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FilterType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ImageAccessLogEventType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "PatientSensitiveCheckResponseType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "PatientSensitivityLevelType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitivityLevelType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodInputParameterType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodInputParameterType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodNameType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodParameterMultipleType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodParameterMultipleType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodParameterType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodParameterType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodParameterTypeType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodParameterTypeType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodParameterValueType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodParameterValueType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesErrorMessageType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesErrorMessageType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesErrorType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesErrorType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesStudiesType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesStudiesType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudyType");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(org.apache.axis.encoding.ser.BaseSerializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleSerializerFactory.class, cls, qName));
            cachedDeserFactories.add(org.apache.axis.encoding.ser.BaseDeserializerFactory.createFactory(org.apache.axis.encoding.ser.SimpleDeserializerFactory.class, cls, qName));

            qName = new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials");
            cachedSerQNames.add(qName);
            cls = gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials.class;
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

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType getPatientShallowStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials, java.math.BigInteger authorizedSensitivityLevel) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[0]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getPatientShallowStudyList");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getPatientShallowStudyList"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, siteId, patientId, filter, credentials, authorizedSensitivityLevel});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[] getStudyImageList(java.lang.String transactionId, java.lang.String studyId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[1]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getStudyImageList");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getStudyImageList"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, studyId, credentials});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[]) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[]) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[].class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventType logEvent) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[2]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("postImageAccessEvent");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "postImageAccessEvent"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, logEvent});

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
  throw axisFaultException;
}
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PingServerTypePingResponse pingServerEvent(java.lang.String transactionId, java.lang.String clientWorkstation, java.lang.String requestSiteNumber, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[3]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("pingServer");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "pingServer"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, clientWorkstation, requestSiteNumber, credentials});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PingServerTypePingResponse) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PingServerTypePingResponse) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PingServerTypePingResponse.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PrefetchResponseTypePrefetchResponse prefetchStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[4]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("prefetchStudyList");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "prefetchStudyList"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, siteId, patientId, filter, credentials});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PrefetchResponseTypePrefetchResponse) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PrefetchResponseTypePrefetchResponse) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PrefetchResponseTypePrefetchResponse.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public java.lang.String getImageInformation(java.lang.String id, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[5]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getImageInformation");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getImageInformation"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {id, transactionId, credentials});

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
  throw axisFaultException;
}
    }

    public java.lang.String getImageSystemGlobalNode(java.lang.String id, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[6]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getImageSystemGlobalNode");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getImageSystemGlobalNode"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {id, transactionId, credentials});

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
  throw axisFaultException;
}
    }

    public java.lang.String getImageDevFields(java.lang.String id, java.lang.String flags, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[7]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getImageDevFields");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getImageDevFields"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {id, flags, transactionId, credentials});

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
  throw axisFaultException;
}
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType getPatientSensitivityLevel(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[8]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getPatientSensitivityLevel");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getPatientSensitivityLevel"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, siteId, patientId, credentials});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType) _resp;
            } catch (java.lang.Exception _exception) {
                return (gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType) org.apache.axis.utils.JavaUtils.convert(_resp, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType.class);
            }
        }
  } catch (org.apache.axis.AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public java.lang.String getStudyReport(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials, java.lang.String studyId) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[9]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("getStudyReport");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getStudyReport"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, studyId});

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
  throw axisFaultException;
}
    }

    public java.lang.String remoteMethodPassthrough(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials, java.lang.String siteId, java.lang.String methodName, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodInputParameterType inputParameters) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[10]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("remoteMethodPassthrough");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("urn:v5.soap.webservices.clinicaldisplay.imaging.med.va.gov", "remoteMethodPassthrough"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {transactionId, credentials, siteId, methodName, inputParameters});

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
  throw axisFaultException;
}
    }

}
