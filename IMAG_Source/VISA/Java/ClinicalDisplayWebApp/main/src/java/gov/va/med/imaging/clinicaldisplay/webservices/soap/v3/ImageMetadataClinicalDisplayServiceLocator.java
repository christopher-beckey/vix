/**
 * ImageMetadataClinicalDisplayServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v3;

public class ImageMetadataClinicalDisplayServiceLocator extends org.apache.axis.client.Service implements gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.ImageMetadataClinicalDisplayService {

    public ImageMetadataClinicalDisplayServiceLocator() {
    }


    public ImageMetadataClinicalDisplayServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public ImageMetadataClinicalDisplayServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for ImageMetadataClinicalDisplayV3
    private java.lang.String ImageMetadataClinicalDisplayV3_address = "http://localhost:8080/ImagingExchangeWebApp/webservices/ImageMetadataClinicalDisplay";

    public java.lang.String getImageMetadataClinicalDisplayV3Address() {
        return ImageMetadataClinicalDisplayV3_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String ImageMetadataClinicalDisplayV3WSDDServiceName = "ImageMetadataClinicalDisplay.V3";

    public java.lang.String getImageMetadataClinicalDisplayV3WSDDServiceName() {
        return ImageMetadataClinicalDisplayV3WSDDServiceName;
    }

    public void setImageMetadataClinicalDisplayV3WSDDServiceName(java.lang.String name) {
        ImageMetadataClinicalDisplayV3WSDDServiceName = name;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.ImageClinicalDisplayMetadata getImageMetadataClinicalDisplayV3() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(ImageMetadataClinicalDisplayV3_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getImageMetadataClinicalDisplayV3(endpoint);
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.ImageClinicalDisplayMetadata getImageMetadataClinicalDisplayV3(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.ImageMetadataClinicalDisplaySoapBindingStub _stub = new gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.ImageMetadataClinicalDisplaySoapBindingStub(portAddress, this);
            _stub.setPortName(getImageMetadataClinicalDisplayV3WSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setImageMetadataClinicalDisplayV3EndpointAddress(java.lang.String address) {
        ImageMetadataClinicalDisplayV3_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.ImageClinicalDisplayMetadata.class.isAssignableFrom(serviceEndpointInterface)) {
                gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.ImageMetadataClinicalDisplaySoapBindingStub _stub = new gov.va.med.imaging.clinicaldisplay.webservices.soap.v3.ImageMetadataClinicalDisplaySoapBindingStub(new java.net.URL(ImageMetadataClinicalDisplayV3_address), this);
                _stub.setPortName(getImageMetadataClinicalDisplayV3WSDDServiceName());
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
        if ("ImageMetadataClinicalDisplay.V3".equals(inputPortName)) {
            return getImageMetadataClinicalDisplayV3();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ImageMetadataClinicalDisplayService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("urn:v3.soap.webservices.clinicaldisplay.imaging.med.va.gov", "ImageMetadataClinicalDisplay.V3"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("ImageMetadataClinicalDisplayV3".equals(portName)) {
            setImageMetadataClinicalDisplayV3EndpointAddress(address);
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
