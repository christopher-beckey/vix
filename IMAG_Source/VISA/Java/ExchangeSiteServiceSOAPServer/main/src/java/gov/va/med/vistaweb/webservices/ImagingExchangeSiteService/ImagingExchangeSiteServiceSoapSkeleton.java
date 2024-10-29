/**
 * ImagingExchangeSiteServiceSoapSkeleton.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.vistaweb.webservices.ImagingExchangeSiteService;

public class ImagingExchangeSiteServiceSoapSkeleton implements gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteServiceSoap, org.apache.axis.wsdl.Skeleton {
    private gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteServiceSoap impl;
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
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "regionID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getVISN", _params, new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "getVISNResult"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "ImagingExchangeRegionTO"));
        _oper.setElementQName(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "getVISN"));
        _oper.setSoapAction("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService/getVISN");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getVISN") == null) {
            _myOperations.put("getVISN", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getVISN")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "siteIDs"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getSites", _params, new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "getSitesResult"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "ArrayOfImagingExchangeSiteTO"));
        _oper.setElementQName(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "getSites"));
        _oper.setSoapAction("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService/getSites");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getSites") == null) {
            _myOperations.put("getSites", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getSites")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
            new org.apache.axis.description.ParameterDesc(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "siteID"), org.apache.axis.description.ParameterDesc.IN, new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, false, false), 
        };
        _oper = new org.apache.axis.description.OperationDesc("getSite", _params, new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "getSiteResult"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "ImagingExchangeSiteTO"));
        _oper.setElementQName(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "getSite"));
        _oper.setSoapAction("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService/getSite");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getSite") == null) {
            _myOperations.put("getSite", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getSite")).add(_oper);
        _params = new org.apache.axis.description.ParameterDesc [] {
        };
        _oper = new org.apache.axis.description.OperationDesc("getImagingExchangeSites", _params, new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "getImagingExchangeSitesResult"));
        _oper.setReturnType(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "ArrayOfImagingExchangeSiteTO"));
        _oper.setElementQName(new javax.xml.namespace.QName("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService", "getImagingExchangeSites"));
        _oper.setSoapAction("http://vistaweb.med.va.gov/webservices/ImagingExchangeSiteService/getImagingExchangeSites");
        _myOperationsList.add(_oper);
        if (_myOperations.get("getImagingExchangeSites") == null) {
            _myOperations.put("getImagingExchangeSites", new java.util.ArrayList());
        }
        ((java.util.List)_myOperations.get("getImagingExchangeSites")).add(_oper);
    }

    public ImagingExchangeSiteServiceSoapSkeleton() {
        this.impl = new gov.va.med.vista.siteservice.exchange.soap.ExchangeSiteServiceImpl();
    }

    public ImagingExchangeSiteServiceSoapSkeleton(gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteServiceSoap impl) {
        this.impl = impl;
    }
    public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeRegionTO getVISN(java.lang.String regionID) throws java.rmi.RemoteException
    {
        gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeRegionTO ret = impl.getVISN(regionID);
        return ret;
    }

    public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO getSites(java.lang.String siteIDs) throws java.rmi.RemoteException
    {
        gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO ret = impl.getSites(siteIDs);
        return ret;
    }

    public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO getSite(java.lang.String siteID) throws java.rmi.RemoteException
    {
        gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO ret = impl.getSite(siteID);
        return ret;
    }

    public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO getImagingExchangeSites() throws java.rmi.RemoteException
    {
        gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO ret = impl.getImagingExchangeSites();
        return ret;
    }

}
