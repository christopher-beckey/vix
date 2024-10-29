/**
 * ImageMetadataFederationSoapBindingSkeleton.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.federation.webservices.soap.v3;

public class ImageMetadataFederationSoapBindingSkeleton implements gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata, org.apache.axis.wsdl.Skeleton {
    private gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata impl;
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
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "requestor"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "RequestorType"), gov.va.med.imaging.federation.webservices.types.v3.RequestorType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationFilterType"), gov.va.med.imaging.federation.webservices.types.v3.FederationFilterType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "authorizedSensitivityLevel"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "integer"), java.math.BigInteger.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "studyLoadLevel"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationStudyLoadLevelType"), gov.va.med.imaging.federation.webservices.types.v3.FederationStudyLoadLevelType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientStudyList", _params, new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "StudiesType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getPatientStudyList"));
        _oper.setSoapAction("getPatientStudyList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientStudyList") == null) {
            _myOperations.put("getPatientStudyList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientStudyList")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "log-event"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationImageAccessLogEventType"), gov.va.med.imaging.federation.webservices.types.v3.FederationImageAccessLogEventType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("postImageAccessEvent", _params, new javax.xml.namespace.QName("", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "postImageAccessEvent"));
        _oper.setSoapAction("postImageAccessEvent");
        _myOperationsList.add(_oper);
        if (_myOperations.get("postImageAccessEvent") == null) {
            _myOperations.put("postImageAccessEvent", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("postImageAccessEvent")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationFilterType"), gov.va.med.imaging.federation.webservices.types.v3.FederationFilterType.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("prefetchStudyList", _params, new javax.xml.namespace.QName("", "value"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "prefetchStudyList"));
        _oper.setSoapAction("prefetchStudyList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("prefetchStudyList") == null) {
            _myOperations.put("prefetchStudyList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("prefetchStudyList")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "image-urn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "ImageUrnType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageInformation", _params, new javax.xml.namespace.QName("", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getImageInformation"));
        _oper.setSoapAction("getImageInformation");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageInformation") == null) {
            _myOperations.put("getImageInformation", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageInformation")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "image-urn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "ImageUrnType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageSystemGlobalNode", _params, new javax.xml.namespace.QName("", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getImageSystemGlobalNode"));
        _oper.setSoapAction("getImageSystemGlobalNode");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageSystemGlobalNode") == null) {
            _myOperations.put("getImageSystemGlobalNode", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageSystemGlobalNode")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "image-urn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "ImageUrnType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "flags"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getImageDevFields", _params, new javax.xml.namespace.QName("", "imageInfo"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getImageDevFields"));
        _oper.setSoapAction("getImageDevFields");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImageDevFields") == null) {
            _myOperations.put("getImageDevFields", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImageDevFields")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientSitesVisited", _params, new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-number"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getPatientSitesVisited"));
        _oper.setSoapAction("getPatientSitesVisited");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientSitesVisited") == null) {
            _myOperations.put("getPatientSitesVisited", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientSitesVisited")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "search-criteria"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("searchPatients", _params, new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "patient"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "PatientType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "searchPatients"));
        _oper.setSoapAction("searchPatients");
        _myOperationsList.add(_oper);
        if (_myOperations.get("searchPatients") == null) {
            _myOperations.put("searchPatients", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("searchPatients")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientSensitivityLevel", _params, new javax.xml.namespace.QName("", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "PatientSensitiveCheckResponseType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getPatientSensitivityLevel"));
        _oper.setSoapAction("getPatientSensitivityLevel");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientSensitivityLevel") == null) {
            _myOperations.put("getPatientSensitivityLevel", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientSensitivityLevel")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "cprsIdentifier"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "CprsIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getStudyFromCprsIdentifier", _params, new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationStudyType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getStudyFromCprsIdentifier"));
        _oper.setSoapAction("getStudyFromCprsIdentifier");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getStudyFromCprsIdentifier") == null) {
            _myOperations.put("getStudyFromCprsIdentifier", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getStudyFromCprsIdentifier")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "listDescriptor"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "ListDescriptorType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getActiveWorklist", _params, new javax.xml.namespace.QName("", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationVistaRadActiveExamsType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getActiveWorklist"));
        _oper.setSoapAction("getActiveWorklist");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getActiveWorklist") == null) {
            _myOperations.put("getActiveWorklist", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getActiveWorklist")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "fully-loaded"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"), boolean.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientExams", _params, new javax.xml.namespace.QName("", "exams"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationVistaRadExamType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getPatientExams"));
        _oper.setSoapAction("getPatientExams");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientExams") == null) {
            _myOperations.put("getPatientExams", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientExams")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "study-urn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "StudyUrnType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getVistaRadRadiologyReport", _params, new javax.xml.namespace.QName("", "report"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "ReportType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getVistaRadRadiologyReport"));
        _oper.setSoapAction("getVistaRadRadiologyReport");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getVistaRadRadiologyReport") == null) {
            _myOperations.put("getVistaRadRadiologyReport", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getVistaRadRadiologyReport")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "study-urn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "StudyUrnType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getVistaRadRequisitionReport", _params, new javax.xml.namespace.QName("", "report"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "ReportType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getVistaRadRequisitionReport"));
        _oper.setSoapAction("getVistaRadRequisitionReport");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getVistaRadRequisitionReport") == null) {
            _myOperations.put("getVistaRadRequisitionReport", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getVistaRadRequisitionReport")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "study-urn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "StudyUrnType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getExamImagesForExam", _params, new javax.xml.namespace.QName("", "exam-images"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationVistaRadExamImagesType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getExamImagesForExam"));
        _oper.setSoapAction("getExamImagesForExam");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getExamImagesForExam") == null) {
            _myOperations.put("getExamImagesForExam", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getExamImagesForExam")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "cpt-code"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationVistaRadCptCodeType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getRelevantPriorCptCodes", _params, new javax.xml.namespace.QName("", "cpt-codes"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationVistaRadCptCodeType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getRelevantPriorCptCodes"));
        _oper.setSoapAction("getRelevantPriorCptCodes");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getRelevantPriorCptCodes") == null) {
            _myOperations.put("getRelevantPriorCptCodes", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getRelevantPriorCptCodes")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getNextPatientRegistration", _params, new javax.xml.namespace.QName("", "patientRegistration"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationVistaRadPatientRegistrationType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getNextPatientRegistration"));
        _oper.setSoapAction("getNextPatientRegistration");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getNextPatientRegistration") == null) {
            _myOperations.put("getNextPatientRegistration", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getNextPatientRegistration")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "study-urn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "StudyUrnType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientExam", _params, new javax.xml.namespace.QName("", "exam"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationVistaRadExamType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "getPatientExam"));
        _oper.setSoapAction("getPatientExam");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientExam") == null) {
            _myOperations.put("getPatientExam", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientExam")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "method-name"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationRemoteMethodNameType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "parameters"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationRemoteMethodParameterType"), gov.va.med.imaging.federation.webservices.types.v3.FederationRemoteMethodParameterType[].class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "imaging-context-type"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationRemoteMethodImagingContextType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("remoteMethodPassthrough", _params, new javax.xml.namespace.QName("", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "remoteMethodPassthrough"));
        _oper.setSoapAction("remoteMethodPassthrough");
        _myOperationsList.add(_oper);
        if (_myOperations.get("remoteMethodPassthrough") == null) {
            _myOperations.put("remoteMethodPassthrough", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("remoteMethodPassthrough")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "input-parameter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationVistaRadLogExamAccessInputType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("postVistaRadExamAccessEvent", _params, new javax.xml.namespace.QName("", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "postVistaRadExamAccessEvent"));
        _oper.setSoapAction("postVistaRadExamAccessEvent");
        _myOperationsList.add(_oper);
        if (_myOperations.get("postVistaRadExamAccessEvent") == null) {
            _myOperations.put("postVistaRadExamAccessEvent", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("postVistaRadExamAccessEvent")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationSecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("methodFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v3.intf.webservices.federation.imaging.med.va.gov", "methodExceptionFaultElement"));
        _fault.setClassName("gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v3.types.webservices.federation.imaging.med.va.gov", "FederationMethodExceptionFaultType"));
        _oper.addFault(_fault);
    }

    public ImageMetadataFederationSoapBindingSkeleton() {
        this.impl = new gov.va.med.imaging.federation.webservices.soap.v3.ImageMetadataFederationServiceImpl();
    }

    public ImageMetadataFederationSoapBindingSkeleton(gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata impl) {
        this.impl = impl;
    }
    public gov.va.med.imaging.federation.webservices.types.v3.StudiesType getPatientStudyList(gov.va.med.imaging.federation.webservices.types.v3.RequestorType requestor, gov.va.med.imaging.federation.webservices.types.v3.FederationFilterType filter, java.lang.String patientId, java.lang.String transactionId, java.lang.String siteId, java.math.BigInteger authorizedSensitivityLevel, gov.va.med.imaging.federation.webservices.types.v3.FederationStudyLoadLevelType studyLoadLevel) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        gov.va.med.imaging.federation.webservices.types.v3.StudiesType ret = impl.getPatientStudyList(requestor, filter, patientId, transactionId, siteId, authorizedSensitivityLevel, studyLoadLevel);
        return ret;
    }

    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.federation.webservices.types.v3.FederationImageAccessLogEventType logEvent) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        boolean ret = impl.postImageAccessEvent(transactionId, logEvent);
        return ret;
    }

    public java.lang.String prefetchStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.federation.webservices.types.v3.FederationFilterType filter) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        java.lang.String ret = impl.prefetchStudyList(transactionId, siteId, patientId, filter);
        return ret;
    }

    public java.lang.String getImageInformation(java.lang.String imageUrn, java.lang.String transactionId) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        java.lang.String ret = impl.getImageInformation(imageUrn, transactionId);
        return ret;
    }

    public java.lang.String getImageSystemGlobalNode(java.lang.String imageUrn, java.lang.String transactionId) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        java.lang.String ret = impl.getImageSystemGlobalNode(imageUrn, transactionId);
        return ret;
    }

    public java.lang.String getImageDevFields(java.lang.String imageUrn, java.lang.String flags, java.lang.String transactionId) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        java.lang.String ret = impl.getImageDevFields(imageUrn, flags, transactionId);
        return ret;
    }

    public java.lang.String[] getPatientSitesVisited(java.lang.String patientIcn, java.lang.String transactionId, java.lang.String siteId) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        java.lang.String[] ret = impl.getPatientSitesVisited(patientIcn, transactionId, siteId);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v3.PatientType[] searchPatients(java.lang.String searchCriteria, java.lang.String transactionId, java.lang.String siteId) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        gov.va.med.imaging.federation.webservices.types.v3.PatientType[] ret = impl.searchPatients(searchCriteria, transactionId, siteId);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v3.PatientSensitiveCheckResponseType getPatientSensitivityLevel(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientIcn) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        gov.va.med.imaging.federation.webservices.types.v3.PatientSensitiveCheckResponseType ret = impl.getPatientSensitivityLevel(transactionId, siteId, patientIcn);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v3.FederationStudyType getStudyFromCprsIdentifier(java.lang.String patientId, java.lang.String transactionId, java.lang.String siteId, java.lang.String cprsIdentifier) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        gov.va.med.imaging.federation.webservices.types.v3.FederationStudyType ret = impl.getStudyFromCprsIdentifier(patientId, transactionId, siteId, cprsIdentifier);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadActiveExamsType getActiveWorklist(java.lang.String transactionId, java.lang.String siteId, java.lang.String listDescriptor) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadActiveExamsType ret = impl.getActiveWorklist(transactionId, siteId, listDescriptor);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamType[] getPatientExams(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientIcn, boolean fullyLoaded) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamType[] ret = impl.getPatientExams(transactionId, siteId, patientIcn, fullyLoaded);
        return ret;
    }

    public java.lang.String getVistaRadRadiologyReport(java.lang.String transactionId, java.lang.String studyUrn) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        java.lang.String ret = impl.getVistaRadRadiologyReport(transactionId, studyUrn);
        return ret;
    }

    public java.lang.String getVistaRadRequisitionReport(java.lang.String transactionId, java.lang.String studyUrn) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        java.lang.String ret = impl.getVistaRadRequisitionReport(transactionId, studyUrn);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamImagesType getExamImagesForExam(java.lang.String transactionId, java.lang.String studyUrn) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamImagesType ret = impl.getExamImagesForExam(transactionId, studyUrn);
        return ret;
    }

    public java.lang.String[] getRelevantPriorCptCodes(java.lang.String transactionId, java.lang.String cptCode, java.lang.String siteId) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        java.lang.String[] ret = impl.getRelevantPriorCptCodes(transactionId, cptCode, siteId);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadPatientRegistrationType getNextPatientRegistration(java.lang.String transactionId, java.lang.String siteId) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadPatientRegistrationType ret = impl.getNextPatientRegistration(transactionId, siteId);
        return ret;
    }

    public gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamType getPatientExam(java.lang.String transactionId, java.lang.String studyUrn) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamType ret = impl.getPatientExam(transactionId, studyUrn);
        return ret;
    }

    public java.lang.String remoteMethodPassthrough(java.lang.String transactionId, java.lang.String siteId, java.lang.String methodName, gov.va.med.imaging.federation.webservices.types.v3.FederationRemoteMethodParameterType[] parameters, java.lang.String imagingContextType) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        java.lang.String ret = impl.remoteMethodPassthrough(transactionId, siteId, methodName, parameters, imagingContextType);
        return ret;
    }

    public boolean postVistaRadExamAccessEvent(java.lang.String transactionId, java.lang.String siteId, java.lang.String inputParameter) throws java.rmi.RemoteException, gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType, gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType
    {
        boolean ret = impl.postVistaRadExamAccessEvent(transactionId, siteId, inputParameter);
        return ret;
    }

}
