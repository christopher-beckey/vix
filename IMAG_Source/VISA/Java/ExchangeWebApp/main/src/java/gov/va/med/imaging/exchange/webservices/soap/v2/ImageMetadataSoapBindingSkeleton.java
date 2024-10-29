/**
 * ImageMetadataSoapBindingSkeleton.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.exchange.webservices.soap.v2;

public class ImageMetadataSoapBindingSkeleton implements gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadata, org.apache.axis.wsdl.Skeleton {
    private gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadata impl;
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
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "datasource"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "DatasourceIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "requestor"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "RequestorType"), gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "filter"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "FilterType"), gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "requested-site"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "RequestedSiteNumberType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientStudyList", _params, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "result"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "StudyListResponseType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "getPatientStudyList"));
        _oper.setSoapAction("getPatientStudyList");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientStudyList") == null) {
            _myOperations.put("getPatientStudyList", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientStudyList")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "datasource"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "DatasourceIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "requestor"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "RequestorType"), gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "patient-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "PatientIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "transaction-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "TransactionIdentifierType"), java.lang.String.class, false, false), 
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "study-id"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "StudyIdentifierType"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getPatientReport", _params, new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "report"));
        _oper.setReturnType(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "ReportType"));
        _oper.setElementQName(new javax.xml.namespace.QName("urn:v2.types.soap.webservices.exchange.imaging.med.va.gov", "getPatientReport"));
        _oper.setSoapAction("getPatientReport");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getPatientReport") == null) {
            _myOperations.put("getPatientReport", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getPatientReport")).add(_oper);
    }

    public ImageMetadataSoapBindingSkeleton() {
        this.impl = new gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadataServiceImpl();
    }

    public ImageMetadataSoapBindingSkeleton(gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadata impl) {
        this.impl = impl;
    }
    public gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType getPatientStudyList(java.lang.String datasource, gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType requestor, gov.va.med.imaging.exchange.webservices.soap.types.v2.FilterType filter, java.lang.String patientId, java.lang.String transactionId, java.lang.String requestedSite) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.exchange.webservices.soap.types.v2.StudyListResponseType ret = impl.getPatientStudyList(datasource, requestor, filter, patientId, transactionId, requestedSite);
        return ret;
    }

    public gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType getPatientReport(java.lang.String datasource, gov.va.med.imaging.exchange.webservices.soap.types.v2.RequestorType requestor, java.lang.String patientId, java.lang.String transactionId, java.lang.String studyId) throws java.rmi.RemoteException
    {
        gov.va.med.imaging.exchange.webservices.soap.types.v2.ReportType ret = impl.getPatientReport(datasource, requestor, patientId, transactionId, studyId);
        return ret;
    }

}
