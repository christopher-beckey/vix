/**
 * ImageMetadataClinicalDisplayService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v4;

public interface ImageMetadataClinicalDisplayService extends javax.xml.rpc.Service {
    public java.lang.String getImageMetadataClinicalDisplayV4Address();

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ImageClinicalDisplayMetadata getImageMetadataClinicalDisplayV4() throws javax.xml.rpc.ServiceException;

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v4.ImageClinicalDisplayMetadata getImageMetadataClinicalDisplayV4(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
