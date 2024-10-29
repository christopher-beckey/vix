/**
 * ImageMetadataServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.exchange.webservices.soap.v1;

public class ImageMetadataServiceLocator extends org.apache.axis.client.Service implements gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadataService {

    public ImageMetadataServiceLocator() {
    }


    public ImageMetadataServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public ImageMetadataServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for ImageMetadataV1
    private java.lang.String ImageMetadataV1_address = "http://localhost:8080/ImagingExchangeWebApp/webservices/ImageMetadata";

    public java.lang.String getImageMetadataV1Address() {
        return ImageMetadataV1_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String ImageMetadataV1WSDDServiceName = "ImageMetadata.V1";

    public java.lang.String getImageMetadataV1WSDDServiceName() {
        return ImageMetadataV1WSDDServiceName;
    }

    public void setImageMetadataV1WSDDServiceName(java.lang.String name) {
        ImageMetadataV1WSDDServiceName = name;
    }

    public gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadata getImageMetadataV1() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(ImageMetadataV1_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getImageMetadataV1(endpoint);
    }

    public gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadata getImageMetadataV1(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadataSoapBindingStub _stub = new gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadataSoapBindingStub(portAddress, this);
            _stub.setPortName(getImageMetadataV1WSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setImageMetadataV1EndpointAddress(java.lang.String address) {
        ImageMetadataV1_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadata.class.isAssignableFrom(serviceEndpointInterface)) {
                gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadataSoapBindingStub _stub = new gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadataSoapBindingStub(new java.net.URL(ImageMetadataV1_address), this);
                _stub.setPortName(getImageMetadataV1WSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("ImageMetadata.V1".equals(inputPortName)) {
            return getImageMetadataV1();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("urn:v1.soap.webservices.exchange.imaging.med.va.gov", "ImageMetadataService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("urn:v1.soap.webservices.exchange.imaging.med.va.gov", "ImageMetadata.V1"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("ImageMetadataV1".equals(portName)) {
            setImageMetadataV1EndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}