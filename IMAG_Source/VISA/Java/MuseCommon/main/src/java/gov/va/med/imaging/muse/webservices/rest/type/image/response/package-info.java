/**
 * @author William Peterson
 *
 */

@javax.xml.bind.annotation.XmlSchema
 (namespace = "http://schemas.datacontract.org/2004/07/MUSEAPIData",
 	xmlns = { 
    @XmlNs(prefix = "ns1", namespaceURI = "http://schemas.datacontract.org/2004/07/MUSEAPIData"),		 
    @XmlNs(prefix = "xs", namespaceURI = "http://www.w3.org/2001/XMLSchema"),
    @XmlNs(prefix = "xsi", namespaceURI = "http://www.w3.org/2001/XMLSchema-instance")},
 elementFormDefault = javax.xml.bind.annotation.XmlNsForm.QUALIFIED)

package gov.va.med.imaging.muse.webservices.rest.type.image.response;
import javax.xml.bind.annotation.XmlNs;
