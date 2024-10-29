/**
 * ImageMetadataClinicalDisplaySoapBindingSkeleton.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v7;

public class ImageMetadataClinicalDisplaySoapBindingSkeleton implements gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageClinicalDisplayMetadata, org.apache.axis.wsdl.Skeleton {
    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageClinicalDisplayMetadata impl;
    private static java.util.Map _myOperations = new java.util.Hashtable();
    private static java.util.Collection _myOperationsList = new java.util.ArrayList();

    /**
    * Returns List of OperationDesc objects with this name
    */
    public static java.util.List getOperationDescByName(java.lang.String methodName) {
        return (java.util.List)_myOperations.get(methodName);
    }

    /**
    * Returns Collection of OperationDescs
    */
    public static java.util.Collection getOperationDescs() {
        return _myOperationsList;
    }

    static {
        org.apache.axis.description.OperationDesc _oper;
        org.apache.axis.description.FaultDesc _fault;
        org.apache.axis.description.ParameterDesc [] _params;
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FilterType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FilterType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "authorizedSensitivityLevel"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "integer"), java.math.BigInteger.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "includeArtifacts"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"), boolean.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientShallowStudyList", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudiesType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getPatientShallowStudyList"));
        _oper.setSoapAction("getPatientShallowStudyList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientShallowStudyList") == null) {
            _myOperations.put("getPatientShallowStudyList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientShallowStudyList")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "include-deleted-images"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"), boolean.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getStudyImageList", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FatImageType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getStudyImageList"));
        _oper.setSoapAction("getStudyImageList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getStudyImageList") == null) {
            _myOperations.put("getStudyImageList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getStudyImageList")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "log-event"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ImageAccessLogEventType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("postImageAccessEvent", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "postImageAccessEvent"));
        _oper.setSoapAction("postImageAccessEvent");
        _myOperationsList.add(_oper);
        if (_myOperations.get("postImageAccessEvent") == null) {
            _myOperations.put("postImageAccessEvent", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("postImageAccessEvent")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "clientWorkstation"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "requestSiteNumber"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("pingServerEvent", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "pingResponse"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">PingServerType>pingResponse"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "pingServer"));
        _oper.setSoapAction("pingServer");
        _myOperationsList.add(_oper);
        if (_myOperations.get("pingServerEvent") == null) {
            _myOperations.put("pingServerEvent", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("pingServerEvent")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FilterType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FilterType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("prefetchStudyList", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "prefetchResponse"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">PrefetchResponseType>prefetchResponse"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "prefetchStudyList"));
        _oper.setSoapAction("prefetchStudyList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("prefetchStudyList") == null) {
            _myOperations.put("prefetchStudyList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("prefetchStudyList")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "include-deleted-images"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"), boolean.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageInformation", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getImageInformation"));
        _oper.setSoapAction("getImageInformation");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageInformation") == null) {
            _myOperations.put("getImageInformation", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageInformation")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageSystemGlobalNode", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getImageSystemGlobalNode"));
        _oper.setSoapAction("getImageSystemGlobalNode");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageSystemGlobalNode") == null) {
            _myOperations.put("getImageSystemGlobalNode", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageSystemGlobalNode")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "flags"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageDevFields", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getImageDevFields"));
        _oper.setSoapAction("getImageDevFields");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageDevFields") == null) {
            _myOperations.put("getImageDevFields", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageDevFields")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientSensitivityLevel", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "PatientSensitiveCheckResponseType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getPatientSensitivityLevel"));
        _oper.setSoapAction("getPatientSensitivityLevel");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientSensitivityLevel") == null) {
            _myOperations.put("getPatientSensitivityLevel", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientSensitivityLevel")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getStudyReport", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "studyReport"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getStudyReport"));
        _oper.setSoapAction("getStudyReport");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getStudyReport") == null) {
            _myOperations.put("getStudyReport", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getStudyReport")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "methodName"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodNameType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "inputParameters"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "RemoteMethodInputParameterType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodInputParameterType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("remoteMethodPassthrough", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "remoteMethodPassthrough"));
        _oper.setSoapAction("remoteMethodPassthrough");
        _myOperationsList.add(_oper);
        if (_myOperations.get("remoteMethodPassthrough") == null) {
            _myOperations.put("remoteMethodPassthrough", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("remoteMethodPassthrough")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageAnnotations", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "AnnotationType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getImageAnnotations"));
        _oper.setSoapAction("getImageAnnotations");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageAnnotations") == null) {
            _myOperations.put("getImageAnnotations", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageAnnotations")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "annotation-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getAnnotationDetails", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "AnnotationDetailsType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getAnnotationDetails"));
        _oper.setSoapAction("getAnnotationDetails");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getAnnotationDetails") == null) {
            _myOperations.put("getAnnotationDetails", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getAnnotationDetails")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "details"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "version"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "source"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("postAnnotationDetails", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "AnnotationType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "postAnnotationDetails"));
        _oper.setSoapAction("postAnnotationDetails");
        _myOperationsList.add(_oper);
        if (_myOperations.get("postAnnotationDetails") == null) {
            _myOperations.put("postAnnotationDetails", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("postAnnotationDetails")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getUserDetails", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getUserDetails"));
        _oper.setSoapAction("getUserDetails");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getUserDetails") == null) {
            _myOperations.put("getUserDetails", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getUserDetails")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentialsType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("isAnnotationsSupported", _params, new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v7.soap.webservices.clinicaldisplay.imaging.med.va.gov", "isAnnotationsSupported"));
        _oper.setSoapAction("isAnnotationsSupported");
        _myOperationsList.add(_oper);
        if (_myOperations.get("isAnnotationsSupported") == null) {
            _myOperations.put("isAnnotationsSupported", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("isAnnotationsSupported")).add(_oper);
    }

    public ImageMetadataClinicalDisplaySoapBindingSkeleton() {
        this.impl = new gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageMetadataClinicalDisplayServiceImpl();
    }

    public ImageMetadataClinicalDisplaySoapBindingSkeleton(gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageClinicalDisplayMetadata impl) {
        this.impl = impl;
    }
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType getPatientShallowStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.math.BigInteger authorizedSensitivityLevel, boolean includeArtifacts) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType ret = impl.getPatientShallowStudyList(transactionId, siteId, patientId, filter, credentials, authorizedSensitivityLevel, includeArtifacts);
        return ret;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType[] getStudyImageList(java.lang.String transactionId, java.lang.String studyId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, boolean includeDeletedImages) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType[] ret = impl.getStudyImageList(transactionId, studyId, credentials, includeDeletedImages);
        return ret;
    }

    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventType logEvent) throws java.rmi.RemoteException
    {
        boolean ret = impl.postImageAccessEvent(transactionId, logEvent);
        return ret;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse pingServerEvent(java.lang.String transactionId, java.lang.String clientWorkstation, java.lang.String requestSiteNumber, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse ret = impl.pingServerEvent(transactionId, clientWorkstation, requestSiteNumber, credentials);
        return ret;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PrefetchResponseTypePrefetchResponse prefetchStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PrefetchResponseTypePrefetchResponse ret = impl.prefetchStudyList(transactionId, siteId, patientId, filter, credentials);
        return ret;
    }

    public java.lang.String getImageInformation(java.lang.String id, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, boolean includeDeletedImages) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getImageInformation(id, transactionId, credentials, includeDeletedImages);
        return ret;
    }

    public java.lang.String getImageSystemGlobalNode(java.lang.String id, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getImageSystemGlobalNode(id, transactionId, credentials);
        return ret;
    }

    public java.lang.String getImageDevFields(java.lang.String id, java.lang.String flags, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getImageDevFields(id, flags, transactionId, credentials);
        return ret;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitiveCheckResponseType getPatientSensitivityLevel(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitiveCheckResponseType ret = impl.getPatientSensitivityLevel(transactionId, siteId, patientId, credentials);
        return ret;
    }

    public java.lang.String getStudyReport(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String studyId) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getStudyReport(transactionId, credentials, studyId);
        return ret;
    }

    public java.lang.String remoteMethodPassthrough(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String siteId, java.lang.String methodName, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodInputParameterType inputParameters) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.remoteMethodPassthrough(transactionId, credentials, siteId, methodName, inputParameters);
        return ret;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[] getImageAnnotations(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String imageId) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[] ret = impl.getImageAnnotations(transactionId, credentials, imageId);
        return ret;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationDetailsType getAnnotationDetails(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String imageId, java.lang.String annotationId) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationDetailsType ret = impl.getAnnotationDetails(transactionId, credentials, imageId, annotationId);
        return ret;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType postAnnotationDetails(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String imageId, java.lang.String details, java.lang.String version, java.lang.String source) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType ret = impl.postAnnotationDetails(transactionId, credentials, imageId, details, version, source);
        return ret;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserType getUserDetails(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String siteId) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserType ret = impl.getUserDetails(transactionId, credentials, siteId);
        return ret;
    }

    public boolean isAnnotationsSupported(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, java.lang.String siteId) throws java.rmi.RemoteException
    {
        boolean ret = impl.isAnnotationsSupported(transactionId, credentials, siteId);
        return ret;
    }

}
