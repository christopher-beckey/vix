/**
 * ImageMetadataFederationService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.federation.webservices.soap.v3;

public interface ImageMetadataFederationService extends javax.xml.rpc.Service {
    public java.lang.String getImageMetadataFederationV3Address();

    public gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata getImageMetadataFederationV3() throws javax.xml.rpc.ServiceException;

    public gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata getImageMetadataFederationV3(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
