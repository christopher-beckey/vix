/**
 * ImageMetadataVistaRadServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.vistarad.webservices.soap.v1;

public class ImageMetadataVistaRadServiceLocator extends org.apache.axis.client.Service implements gov.va.med.imaging.vistarad.webservices.soap.v1.ImageMetadataVistaRadService {

    public ImageMetadataVistaRadServiceLocator() {
    }


    public ImageMetadataVistaRadServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public ImageMetadataVistaRadServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for ImageMetadataVistaradV1
    private java.lang.String ImageMetadataVistaradV1_address = "http://localhost:8080/VistaRadWebApp/webservices/ImageMetadataVistaRad";

    public java.lang.String getImageMetadataVistaradV1Address() {
        return ImageMetadataVistaradV1_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String ImageMetadataVistaradV1WSDDServiceName = "ImageMetadataVistarad.V1";

    public java.lang.String getImageMetadataVistaradV1WSDDServiceName() {
        return ImageMetadataVistaradV1WSDDServiceName;
    }

    public void setImageMetadataVistaradV1WSDDServiceName(java.lang.String name) {
        ImageMetadataVistaradV1WSDDServiceName = name;
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata getImageMetadataVistaradV1() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(ImageMetadataVistaradV1_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getImageMetadataVistaradV1(endpoint);
    }

    public gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata getImageMetadataVistaradV1(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            gov.va.med.imaging.vistarad.webservices.soap.v1.ImageMetadataVistaRadSoapBindingStub _stub = new gov.va.med.imaging.vistarad.webservices.soap.v1.ImageMetadataVistaRadSoapBindingStub(portAddress, this);
            _stub.setPortName(getImageMetadataVistaradV1WSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setImageMetadataVistaradV1EndpointAddress(java.lang.String address) {
        ImageMetadataVistaradV1_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata.class.isAssignableFrom(serviceEndpointInterface)) {
                gov.va.med.imaging.vistarad.webservices.soap.v1.ImageMetadataVistaRadSoapBindingStub _stub = new gov.va.med.imaging.vistarad.webservices.soap.v1.ImageMetadataVistaRadSoapBindingStub(new java.net.URL(ImageMetadataVistaradV1_address), this);
                _stub.setPortName(getImageMetadataVistaradV1WSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : "" + serviceEndpointInterface.getName()));
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
        if ("ImageMetadataVistarad.V1".equals(inputPortName)) {
            return getImageMetadataVistaradV1();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ImageMetadataVistaRadService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("urn:v1.soap.webservices.vistarad.imaging.med.va.gov", "ImageMetadataVistarad.V1"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("ImageMetadataVistaradV1".equals(portName)) {
            setImageMetadataVistaradV1EndpointAddress(address);
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
