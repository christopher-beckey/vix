package gov.va.med.imaging.utils;

import gov.va.med.logging.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

import javax.xml.XMLConstants;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamResult;
import java.beans.XMLDecoder;
import java.io.*;

/**
 * Utility class designed to centralize certain operations to minimize footprint for Fortify and other scans and
 * to find solutions to satisfy its criteria in a single place.
 */
public class XmlUtilities {
    private static final Logger LOGGER = Logger.getLogger(XmlUtilities.class);

    private XmlUtilities() {
        // ---
    }

    public static DocumentBuilderFactory getSafeDocumentBuilderFactory() throws Exception {
        try {
            DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
            documentBuilderFactory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
            documentBuilderFactory.setFeature("http://xml.org/sax/features/external-general-entities", false);
            documentBuilderFactory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
            documentBuilderFactory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
            documentBuilderFactory.setXIncludeAware(false);
            documentBuilderFactory.setExpandEntityReferences(false);
            documentBuilderFactory.setNamespaceAware(true);

            return documentBuilderFactory;
        } catch (Exception e) {
            throw new Exception("Error initializing DocumentBuilderFactory", e);
        }
    }

    public static Element getFirstChildElement(Element rootElement) {
        if ((rootElement.hasChildNodes()) && (rootElement.getChildNodes().getLength() > 0)) {
            for (int i = 0; i < rootElement.getChildNodes().getLength(); ++i) {
                Node childNode = rootElement.getChildNodes().item(i);
                if (Node.ELEMENT_NODE == childNode.getNodeType()) {
                    return (Element) childNode;
                }
            }
        }

        return null;
    }

    public static Element parseDocument(DocumentBuilder documentBuilder, InputStream inputStream) throws Exception {
        Document document;
        try {
            document = documentBuilder.parse(inputStream);
        } catch (Exception e) {
            throw new Exception("Error parsing input stream into XML document", e);
        }

        return document.getDocumentElement();
    }

    public static Element convertObjectToElement(Object value) throws Exception {
        JAXBContext jaxbContext = JAXBContext.newInstance(new Class[] { value.getClass() });
        Marshaller marshaller = jaxbContext.createMarshaller();
        return null;
    }

    public static <T> T deserializeXMLDecoderContent(Class<T> type, InputStream inputStream) throws IOException {
        // Do this the unsafe way for now
        //return deserializeXMLDecoderContentViaJAXB(type, inputStream);
        XMLDecoder xmlDecoder = new XMLDecoder(inputStream);
        return (T) xmlDecoder.readObject();
    }

    /**
     * Converts XMLDecoder-formatted XML into an object of the provided type without using XMLDecoder
     *
     * @param type The type to convert to
     * @param inputStream The input XML contents (formatted assuming XMLDecoder syntax)
     * @param <T> The type to return
     * @return The converted object
     * @throws IOException In the event of any exceptions during deserialization
     */
    public static <T> T deserializeXMLDecoderContentViaJAXB(Class<T> type, InputStream inputStream) throws IOException {
        // Initialize buffer for converted XML
        ByteArrayInputStream inputBuffer = null;
        ByteArrayOutputStream outputBuffer = null;

        try {
            // Initialize a safe transform factory
            TransformerFactory transformerFactory;
            try {
                transformerFactory = TransformerFactory.newInstance("com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl", null);
                transformerFactory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
                transformerFactory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
            } catch (Exception e) {
                throw new IOException("Error initializing TransformerFactory for conversion", e);
            }

            // Create the unmarshaller
            Unmarshaller unmarshaller;
            try {
                unmarshaller = JAXBContext.newInstance(type).createUnmarshaller();
            } catch (Exception e) {
                throw new IOException("Error initializing JAXB Unmarshaller for conversion", e);
            }

            // Get sources for the transform and input
            Source transform = new SAXSource(getXmlReader(), new InputSource(new StringReader(CONVERSION_XSLT)));
            //Source input = new SAXSource(getXmlReader(), new InputSource(inputStream));

            Element inputElement;
            try {
                inputElement = getSafeDocumentBuilderFactory().newDocumentBuilder().parse(inputStream).getDocumentElement();
            } catch (Exception e) {
                throw new IOException("Error parsing input XML for conversion", e);
            }

            // Create a transformer
            Transformer transformer;
            try {
                transformer = transformerFactory.newTransformer(transform);
            } catch (Exception e) {
                throw new IOException("Error creating a transformer for conversion", e);
            }

            // Create an output "buffer" to feed to JAXB
            outputBuffer = new ByteArrayOutputStream();

            // Transform the input XML and write the results out to our "buffer"
            try {
                transformer.transform(new DOMSource(inputElement), new StreamResult(outputBuffer));
            } catch (Exception e) {
                throw new IOException("Error transforming contents for conversion", e);
            }

            // Temporary: Log results
            LOGGER.debug("[XmlUtilities] - Produced XML: {}", outputBuffer.toString());

            // Create the input stream for the "buffer"
            inputBuffer = new ByteArrayInputStream(outputBuffer.toByteArray());

            // Convert our result XML to the provided type
            try {
                return (T) unmarshaller.unmarshal(inputBuffer);
            } catch (Exception e) {
                throw new IOException("Error converting transformed contents to provided type [" + type.getName() + "]", e);
            }
        } finally {
            // Close streams
            if (inputBuffer != null) {
                try {
                    inputBuffer.close();
                } catch (Exception e) {
                    // Ignore
                }
            }

            if (outputBuffer != null) {
                try {
                    outputBuffer.close();
                } catch (Exception e) {
                    // Ignore
                }
            }
        }
    }

    private static XMLReader getXmlReader() throws IOException {
        // Initialize a safe XMLReader for the input stream and the XSLT
        XMLReader xmlReader;
        try {
            xmlReader = XMLReaderFactory.createXMLReader();
            xmlReader.setFeature("http://xml.org/sax/features/external-general-entities", false);
            xmlReader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
        } catch (Exception e) {
            throw new IOException("Error initializing XMLReader for conversion", e);
        }
        return xmlReader;
    }

    // XSLT to convert XMLDecoder style XML to something approximating JAXB
    // Currently this does not handle references
    private static String CONVERSION_XSLT = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><xsl:transform xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\" version=\"1.0\"><!--Identity transform --><xsl:template match=\"@*|node()\"><xsl:copy><xsl:apply-templates select=\"@*|node()\" /></xsl:copy></xsl:template><xsl:template match=\"/java\"><xsl:apply-templates select=\"object\" /></xsl:template><xsl:template match=\"object[string-length(../@property) != 0]\"><xsl:apply-templates select=\"*\" /></xsl:template><xsl:template match=\"object[string-length(../@property) = 0]\"><xsl:element name=\"{@class}\"><xsl:apply-templates select=\"*\" /></xsl:element></xsl:template><xsl:template match=\"void[string-length(@property) != 0]\"><xsl:element name=\"{@property}\"><xsl:apply-templates select=\"*\" /></xsl:element></xsl:template><xsl:template match=\"void[@method = 'add']\"><xsl:apply-templates select=\"*\" /></xsl:template><xsl:template match=\"void[@method = 'put']\"><entry><key><xsl:apply-templates select=\"*[1]\" /></key><value><xsl:apply-templates select=\"*[2]\" /></value></entry></xsl:template><xsl:template match=\"array\"><xsl:for-each select=\"void\"><entry><xsl:apply-templates select=\"*\" /></entry></xsl:for-each></xsl:template><xsl:template match=\"string | boolean | long | int | char | short\"><xsl:value-of select=\"string(.)\" /></xsl:template></xsl:transform>";
}
