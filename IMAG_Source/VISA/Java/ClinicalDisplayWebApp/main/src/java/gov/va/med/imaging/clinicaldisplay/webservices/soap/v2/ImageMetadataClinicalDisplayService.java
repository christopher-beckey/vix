/**
 * ImageMetadataClinicalDisplayService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.imaging.clinicaldisplay.webservices.soap.v2;

public interface ImageMetadataClinicalDisplayService extends javax.xml.rpc.Service {
    public java.lang.String getImageMetadataClinicalDisplayV2Address();

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata getImageMetadataClinicalDisplayV2() throws javax.xml.rpc.ServiceException;

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata getImageMetadataClinicalDisplayV2(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
