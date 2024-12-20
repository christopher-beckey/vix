/**
 * ImageMetadataFederationSoapBindingSkeleton.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.federation.webservices.soap.v2;

public class ImageMetadataFederationSoapBindingSkeleton implements gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata, org.apache.axis.wsdl.Skeleton {
    private gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata impl;
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
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "requestor"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "RequestorType"), gov.va.med.imaging.federation.webservices.types.v2.RequestorType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "FederationFilterType"), gov.va.med.imaging.federation.webservices.types.v2.FederationFilterType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "authorizedSensitivityLevel"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "integer"), java.math.BigInteger.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "studyLoadLevel"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "FederationStudyLoadLevelType"), gov.va.med.imaging.federation.webservices.types.v2.FederationStudyLoadLevelType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientStudyList", _params, new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "StudiesType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "getPatientStudyList"));
        _oper.setSoapAction("getPatientStudyList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientStudyList") == null) {
            _myOperations.put("getPatientStudyList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientStudyList")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "log-event"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "FederationImageAccessLogEventType"), gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("postImageAccessEvent", _params, new javax.xml.namespace.QName("", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "postImageAccessEvent"));
        _oper.setSoapAction("postImageAccessEvent");
        _myOperationsList.add(_oper);
        if (_myOperations.get("postImageAccessEvent") == null) {
            _myOperations.put("postImageAccessEvent", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("postImageAccessEvent")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "FederationFilterType"), gov.va.med.imaging.federation.webservices.types.v2.FederationFilterType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("prefetchStudyList", _params, new javax.xml.namespace.QName("", "value"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "prefetchStudyList"));
        _oper.setSoapAction("prefetchStudyList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("prefetchStudyList") == null) {
            _myOperations.put("prefetchStudyList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("prefetchStudyList")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "image-urn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "ImageUrnType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageInformation", _params, new javax.xml.namespace.QName("", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "getImageInformation"));
        _oper.setSoapAction("getImageInformation");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageInformation") == null) {
            _myOperations.put("getImageInformation", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageInformation")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "image-urn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "ImageUrnType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageSystemGlobalNode", _params, new javax.xml.namespace.QName("", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "getImageSystemGlobalNode"));
        _oper.setSoapAction("getImageSystemGlobalNode");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageSystemGlobalNode") == null) {
            _myOperations.put("getImageSystemGlobalNode", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageSystemGlobalNode")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "image-urn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "ImageUrnType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "flags"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageDevFields", _params, new javax.xml.namespace.QName("", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "getImageDevFields"));
        _oper.setSoapAction("getImageDevFields");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageDevFields") == null) {
            _myOperations.put("getImageDevFields", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageDevFields")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientSitesVisited", _params, new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "site-number"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "getPatientSitesVisited"));
        _oper.setSoapAction("getPatientSitesVisited");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientSitesVisited") == null) {
            _myOperations.put("getPatientSitesVisited", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientSitesVisited")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "search-criteria"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("searchPatients", _params, new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "patient"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "PatientType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "searchPatients"));
        _oper.setSoapAction("searchPatients");
        _myOperationsList.add(_oper);
        if (_myOperations.get("searchPatients") == null) {
            _myOperations.put("searchPatients", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("searchPatients")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientSensitivityLevel", _params, new javax.xml.namespace.QName("", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "PatientSensitiveCheckResponseType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "getPatientSensitivityLevel"));
        _oper.setSoapAction("getPatientSensitivityLevel");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientSensitivityLevel") == null) {
            _myOperations.put("getPatientSensitivityLevel", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientSensitivityLevel")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "cprsIdentifier"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "CprsIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getStudyFromCprsIdentifier", _params, new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v2.types.webservices.federation.imaging.med.va.gov", "FederationStudyType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.intf.webservices.federation.imaging.med.va.gov", "getStudyFromCprsIdentifier"));
        _oper.setSoapAction("getStudyFromCprsIdentifier");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getStudyFromCprsIdentifier") == null) {
            _myOperations.put("getStudyFromCprsIdentifier", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getStudyFromCprsIdentifier")).add(_oper);
    }

    public ImageMetadataFederationSoapBindingSkeleton() {
        this.impl = new gov.va.med.imaging.federation.webservices.soap.v2.ImageMetadataFederationServiceImpl();
    }

    public ImageMetadataFederationSoapBindingSkeleton(gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata impl) {
        this.impl = impl;
    }
    public gov.va.med.imaging.federation.webservices.types.v2.StudiesType getPatientStudyList(gov.va.med.imaging.federation.webservices.types.v2.RequestorType requestor, gov.va.med.imaging.federation.webservices.types.v2.FederationFilterType filter, java.lang.String patientId, java.lang.String transactionId, java.lang.String siteId, java.math.BigInteger authorizedSensitivityLevel, gov.va.med.imaging.federation.webservices.types.v2.FederationStudyLoadLevelType studyLoadLevel) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.federation.webservices.types.v2.StudiesType ret = impl.getPatientStudyList(requestor, filter, patientId, transactionId, siteId, authorizedSensitivityLevel, studyLoadLevel);
        return ret;
    }

    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventType logEvent) throws java.rmi.RemoteException
    {
        boolean ret = impl.postImageAccessEvent(transactionId, logEvent);
        return ret;
    }

    public java.lang.String prefetchStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.federation.webservices.types.v2.FederationFilterType filter) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.prefetchStudyList(transactionId, siteId, patientId, filter);
        return ret;
    }

    public java.lang.String getImageInformation(java.lang.String imageUrn, java.lang.String transactionId) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getImageInformation(imageUrn, transactionId);
        return ret;
    }

    public java.lang.String getImageSystemGlobalNode(java.lang.String imageUrn, java.lang.String transactionId) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getImageSystemGlobalNode(imageUrn, transactionId);
        return ret;
    }

    public java.lang.String getImageDevFields(java.lang.String imageUrn, java.lang.String flags, java.lang.String transactionId) throws java.rmi.RemoteException
    {
        java.lang.String ret = impl.getImageDevFields(imageUrn, flags, transactionId);
        return ret;
    }

    public java.lang.String[] getPatientSitesVisited(java.lang.String patientIcn, java.lang.String transactionId, java.lang.String siteId) throws java.rmi.RemoteException
    {
        java.lang.String[] ret = impl.getPatientSitesVisited(patientIcn, transactionId, siteId);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v2.PatientType[] searchPatients(java.lang.String searchCriteria, java.lang.String transactionId, java.lang.String siteId) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.federation.webservices.types.v2.PatientType[] ret = impl.searchPatients(searchCriteria, transactionId, siteId);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v2.PatientSensitiveCheckResponseType getPatientSensitivityLevel(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientIcn) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.federation.webservices.types.v2.PatientSensitiveCheckResponseType ret = impl.getPatientSensitivityLevel(transactionId, siteId, patientIcn);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType getStudyFromCprsIdentifier(java.lang.String patientId, java.lang.String transactionId, java.lang.String siteId, java.lang.String cprsIdentifier) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType ret = impl.getStudyFromCprsIdentifier(patientId, transactionId, siteId, cprsIdentifier);
        return ret;
    }

}
