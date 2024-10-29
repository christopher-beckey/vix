/**
 * ImageMetadataClinicalDisplaySoapBindingSkeleton.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v2;

public class ImageMetadataClinicalDisplaySoapBindingSkeleton implements gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata, org.apache.axis.wsdl.Skeleton {
    private gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata impl;
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
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FilterType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FilterType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientShallowStudyList", _params, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ShallowStudyType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getPatientShallowStudyList"));
        _oper.setSoapAction("getPatientShallowStudyList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientShallowStudyList") == null) {
            _myOperations.put("getPatientShallowStudyList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientShallowStudyList")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getStudyImageList", _params, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FatImageType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getStudyImageList"));
        _oper.setSoapAction("getStudyImageList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getStudyImageList") == null) {
            _myOperations.put("getStudyImageList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getStudyImageList")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "log-event"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ImageAccessLogEventType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("postImageAccessEvent", _params, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "postImageAccessEvent"));
        _oper.setSoapAction("postImageAccessEvent");
        _myOperationsList.add(_oper);
        if (_myOperations.get("postImageAccessEvent") == null) {
            _myOperations.put("postImageAccessEvent", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("postImageAccessEvent")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "clientWorkstation"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "requestSiteNumber"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("pingServerEvent", _params, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", ">PingServerType>response"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "pingServer"));
        _oper.setSoapAction("pingServer");
        _myOperationsList.add(_oper);
        if (_myOperations.get("pingServerEvent") == null) {
            _myOperations.put("pingServerEvent", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("pingServerEvent")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "FilterType"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FilterType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("prefetchStudyList", _params, new javax.xml.namespace.QName("", "value"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "prefetchStudyList"));
        _oper.setSoapAction("prefetchStudyList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("prefetchStudyList") == null) {
            _myOperations.put("prefetchStudyList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("prefetchStudyList")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageInformation", _params, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getImageInformation"));
        _oper.setSoapAction("getImageInformation");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageInformation") == null) {
            _myOperations.put("getImageInformation", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageInformation")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getStudyImageInformation", _params, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getStudyImageInformation"));
        _oper.setSoapAction("getStudyImageInformation");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getStudyImageInformation") == null) {
            _myOperations.put("getStudyImageInformation", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getStudyImageInformation")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageSystemGlobalNode", _params, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getImageSystemGlobalNode"));
        _oper.setSoapAction("getImageSystemGlobalNode");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageSystemGlobalNode") == null) {
            _myOperations.put("getImageSystemGlobalNode", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageSystemGlobalNode")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getStudySystemGlobalNode", _params, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getStudySystemGlobalNode"));
        _oper.setSoapAction("getStudySystemGlobalNode");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getStudySystemGlobalNode") == null) {
            _myOperations.put("getStudySystemGlobalNode", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getStudySystemGlobalNode")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "image-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "flags"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageDevFields", _params, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getImageDevFields"));
        _oper.setSoapAction("getImageDevFields");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageDevFields") == null) {
            _myOperations.put("getImageDevFields", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageDevFields")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "study-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "flags"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getStudyDevFields", _params, new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.soap.webservices.clinicaldisplay.imaging.med.va.gov", "getStudyDevFields"));
        _oper.setSoapAction("getStudyDevFields");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getStudyDevFields") == null) {
            _myOperations.put("getStudyDevFields", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getStudyDevFields")).add(_oper);
    }

    public ImageMetadataClinicalDisplaySoapBindingSkeleton() {
        this.impl = new gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageMetadataClinicalDisplayServiceImpl();
    }

    public ImageMetadataClinicalDisplaySoapBindingSkeleton(gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata impl) {
        this.impl = impl;
    }
    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType[] getPatientShallowStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType[] ret = impl.getPatientShallowStudyList(transactionId, siteId, patientId, filter, credentials);
        return ret;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType[] getStudyImageList(java.lang.String transactionId, java.lang.String studyId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType[] ret = impl.getStudyImageList(transactionId, studyId, credentials);
        return ret;
    }

    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventType logEvent) throws java.rmi.RemoteException
    {
        boolean ret = impl.postImageAccessEvent(transactionId, logEvent);
        return ret;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.PingServerTypeResponse pingServerEvent(java.lang.String transactionId, java.lang.String clientWorkstation, java.lang.String requestSiteNumber, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.PingServerTypeResponse ret = impl.pingServerEvent(transactionId, clientWorkstation, requestSiteNumber, credentials);
        return ret;
    }

    public java.lang.String prefetchStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.prefetchStudyList(transactionId, siteId, patientId, filter, credentials);
        return ret;
    }

    public java.lang.String getImageInformation(java.lang.String imageId, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getImageInformation(imageId, transactionId, credentials);
        return ret;
    }

    public java.lang.String getStudyImageInformation(java.lang.String studyId, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getStudyImageInformation(studyId, transactionId, credentials);
        return ret;
    }

    public java.lang.String getImageSystemGlobalNode(java.lang.String imageId, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getImageSystemGlobalNode(imageId, transactionId, credentials);
        return ret;
    }

    public java.lang.String getStudySystemGlobalNode(java.lang.String studyId, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getStudySystemGlobalNode(studyId, transactionId, credentials);
        return ret;
    }

    public java.lang.String getImageDevFields(java.lang.String imageId, java.lang.String flags, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getImageDevFields(imageId, flags, transactionId, credentials);
        return ret;
    }

    public java.lang.String getStudyDevFields(java.lang.String studyId, java.lang.String flags, java.lang.String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getStudyDevFields(studyId, flags, transactionId, credentials);
        return ret;
    }

}