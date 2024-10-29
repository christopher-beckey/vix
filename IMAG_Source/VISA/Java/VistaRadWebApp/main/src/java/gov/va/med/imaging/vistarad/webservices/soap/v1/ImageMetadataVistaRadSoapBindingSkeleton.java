/**
 * ImageMetadataVistaRadSoapBindingSkeleton.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class ImageMetadataVistaRadSoapBindingSkeleton implements gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata, org.apache.axis.wsdl.Skeleton {
    private gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata impl;
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
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getEnterpriseExamList", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamSite"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getEnterpriseExamList"));
        _oper.setSoapAction("getEnterpriseExamList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getEnterpriseExamList") == null) {
            _myOperations.put("getEnterpriseExamList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getEnterpriseExamList")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "force-refresh"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"), boolean.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getSiteExamList", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamSite"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getSiteExamList"));
        _oper.setSoapAction("getSiteExamList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getSiteExamList") == null) {
            _myOperations.put("getSiteExamList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getSiteExamList")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "StudyIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getExamDetails", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "study"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "FatExamType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getExamDetails"));
        _oper.setSoapAction("getExamDetails");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getExamDetails") == null) {
            _myOperations.put("getExamDetails", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getExamDetails")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "input-parameter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "LogExamAccessInputType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("postImageAccessEvent", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "postImageAccessEvent"));
        _oper.setSoapAction("postImageAccessEvent");
        _myOperationsList.add(_oper);
        if (_myOperations.get("postImageAccessEvent") == null) {
            _myOperations.put("postImageAccessEvent", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("postImageAccessEvent")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "clientWorkstation"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "requestSiteNumber"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("pingServer", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "pingResponse"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", ">PingServerType>pingResponse"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "pingServer"));
        _oper.setSoapAction("pingServer");
        _myOperationsList.add(_oper);
        if (_myOperations.get("pingServer") == null) {
            _myOperations.put("pingServer", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("pingServer")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "StudyIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("prefetchExam", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "prefetchResponse"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", ">PrefetchResponseType>prefetchResponse"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "prefetchExam"));
        _oper.setSoapAction("prefetchExam");
        _myOperationsList.add(_oper);
        if (_myOperations.get("prefetchExam") == null) {
            _myOperations.put("prefetchExam", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("prefetchExam")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "StudyIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getReport", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "reportDetails"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getReport"));
        _oper.setSoapAction("getReport");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getReport") == null) {
            _myOperations.put("getReport", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getReport")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "siteNumber"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "user-division"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "listDescriptor"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ListDescriptorType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getActiveWorklist", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "GetActiveWorklistResponseContentsType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getActiveWorklist"));
        _oper.setSoapAction("getActiveWorklist");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getActiveWorklist") == null) {
            _myOperations.put("getActiveWorklist", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getActiveWorklist")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exam-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "StudyIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getRequisition", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "reportDetails"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getRequisition"));
        _oper.setSoapAction("getRequisition");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getRequisition") == null) {
            _myOperations.put("getRequisition", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getRequisition")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "siteNumber"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "method-name"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodNameType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "parameters"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "RemoteMethodParameterType"), gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType[].class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("remoteMethodPassthrough", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "response"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "remoteMethodPassthrough"));
        _oper.setSoapAction("remoteMethodPassthrough");
        _myOperationsList.add(_oper);
        if (_myOperations.get("remoteMethodPassthrough") == null) {
            _myOperations.put("remoteMethodPassthrough", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("remoteMethodPassthrough")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "credentials"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "UserCredentials"), gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "patient-icn"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "site-number"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SiteIdentifierType"), java.lang.String[].class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getExamSiteMetadataCachedStatus", _params, new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "exams"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ExamSiteMetadataCachedStatusType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "getExamSiteMetadataCachedStatus"));
        _oper.setSoapAction("getExamSiteMetadataCachedStatus");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getExamSiteMetadataCachedStatus") == null) {
            _myOperations.put("getExamSiteMetadataCachedStatus", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getExamSiteMetadataCachedStatus")).add(_oper);
        _fault = new org.apache.axis.description.FaultDesc();
        _fault.setName("securityCredentialsExpiredFault");
        _fault.setQName(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "securityCredentialsExpiredFaultElement"));
        _fault.setClassName("gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType");
        _fault.setXmlType(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "SecurityCredentialsExpiredExceptionFaultType"));
        _oper.addFault(_fault);
    }

    public ImageMetadataVistaRadSoapBindingSkeleton() {
        this.impl = new gov.va.med.imaging.vistarad.webservices.soap.ImageMetadataVistaRadServiceImpl();
    }

    public ImageMetadataVistaRadSoapBindingSkeleton(gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata impl) {
        this.impl = impl;
    }
    public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite[] getEnterpriseExamList(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String patientIcn) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite[] ret = impl.getEnterpriseExamList(transactionId, credentials, patientIcn);
        return ret;
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite getSiteExamList(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String patientIcn, java.lang.String siteId, boolean forceRefresh) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite ret = impl.getSiteExamList(transactionId, credentials, patientIcn, siteId, forceRefresh);
        return ret;
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType getExamDetails(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType ret = impl.getExamDetails(transactionId, credentials, examId);
        return ret;
    }

    public boolean postImageAccessEvent(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String inputParameter, java.lang.String siteId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        boolean ret = impl.postImageAccessEvent(transactionId, credentials, inputParameter, siteId);
        return ret;
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse pingServer(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String clientWorkstation, java.lang.String requestSiteNumber) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse ret = impl.pingServer(transactionId, credentials, clientWorkstation, requestSiteNumber);
        return ret;
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse prefetchExam(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse ret = impl.prefetchExam(transactionId, credentials, examId);
        return ret;
    }

    public java.lang.String getReport(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        java.lang.String ret = impl.getReport(transactionId, credentials, examId);
        return ret;
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType getActiveWorklist(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String siteNumber, java.lang.String userDivision, java.lang.String listDescriptor) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType ret = impl.getActiveWorklist(transactionId, credentials, siteNumber, userDivision, listDescriptor);
        return ret;
    }

    public java.lang.String getRequisition(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String examId) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        java.lang.String ret = impl.getRequisition(transactionId, credentials, examId);
        return ret;
    }

    public java.lang.String remoteMethodPassthrough(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String siteNumber, java.lang.String methodName, gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType[] parameters) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        java.lang.String ret = impl.remoteMethodPassthrough(transactionId, credentials, siteNumber, methodName, parameters);
        return ret;
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType[] getExamSiteMetadataCachedStatus(java.lang.String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, java.lang.String patientIcn, java.lang.String[] siteNumber) throws java.rmi.RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
    {
        gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType[] ret = impl.getExamSiteMetadataCachedStatus(transactionId, credentials, patientIcn, siteNumber);
        return ret;
    }

}
