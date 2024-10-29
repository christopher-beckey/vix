/**
 * @author William Peterson
 *
 */

@javax.xml.bind.annotation.XmlSchema
 (namespace = "http://schemas.datacontract.org/2004/07/MUSEAPIRESTInterfaces.Test",
 	xmlns = { 
    @XmlNs(prefix = "ns1", namespaceURI = "http://schemas.datacontract.org/2004/07/MUSEAPIRESTInterfaces.Test"),
    @XmlNs(prefix = "ns2", namespaceURI = "http://schemas.datacontract.org/2004/07/MUSEAPIRESTInterfaces"),
    @XmlNs(prefix = "ns3", namespaceURI = "http://schemas.datacontract.org/2004/07/MUSEAPIData"),		 
    @XmlNs(prefix = "xs", namespaceURI = "http://www.w3.org/2001/XMLSchema"),
    @XmlNs(prefix = "xsi", namespaceURI = "http://www.w3.org/2001/XMLSchema-instance")},
 elementFormDefault = javax.xml.bind.annotation.XmlNsForm.QUALIFIED)

package gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.request;

import javax.xml.bind.annotation.XmlNs;

