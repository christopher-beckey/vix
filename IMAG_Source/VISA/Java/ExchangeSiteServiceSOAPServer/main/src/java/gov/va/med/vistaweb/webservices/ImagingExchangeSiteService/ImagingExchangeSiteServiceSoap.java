/**
 * ImagingExchangeSiteServiceSoap.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package gov.va.med.vistaweb.webservices.ImagingExchangeSiteService;

public interface ImagingExchangeSiteServiceSoap extends java.rmi.Remote {
    public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeRegionTO getVISN(java.lang.String regionID) throws java.rmi.RemoteException;
    public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO getSites(java.lang.String siteIDs) throws java.rmi.RemoteException;
    public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ImagingExchangeSiteTO getSite(java.lang.String siteID) throws java.rmi.RemoteException;
    public gov.va.med.vistaweb.webservices.ImagingExchangeSiteService.ArrayOfImagingExchangeSiteTO getImagingExchangeSites() throws java.rmi.RemoteException;
}
