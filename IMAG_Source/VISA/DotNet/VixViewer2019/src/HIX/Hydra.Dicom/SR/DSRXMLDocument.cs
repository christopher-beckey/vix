using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    /*--------------------*
 *  type definitions  *
 *--------------------*/

    //#ifndef WITH_LIBXML
    //// define types if 'libxml' absent
    //typedef void (*xmlDocPtr);
    //typedef void (*xmlCharEncodingHandlerPtr);
    //typedef char xmlChar;
    //#endif


    public class DSRXMLDocument : DSRTypes
    {
        /// <summary>
        /// Xml Document
        /// </summary>
        private XmlDocument xmlDoc;

        /// <summary>
        /// XML root element
        /// </summary>
        public XmlElement root;

        // /// pointer to the internal representation of the XML document (libxml)
        //private xmlDocPtr Document;
        ///// pointer to the currently selected character encoding handler (libxml)
        //private xmlCharEncodingHandlerPtr EncodingHandler;

        // --- constructors and destructor ---

        /** default constructor
         */
        public DSRXMLDocument()
        {

        }

        /** destructor
         */
        ~DSRXMLDocument()
        {

        }

        // --- misc routines ---

        /** clear all internal member variables
         */
        public void clear()
        {

        }

        /** check whether the current internal state is valid
         ** @return OFTrue if valid, OFFalse otherwise
         */
        public bool valid()
        {
            return (xmlDoc != null);
        }

        // --- input and output ---

        /** read XML document from file.
         *  In order to enable the optional Schema validation the flag XF_validateSchema has to be set.
         ** @param  filename  name of the file from which the XML document is read ("-" for stdin)
         *  @param  flags     optional flag used to customize the reading process (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition read(string filename, int flags = 0)
        {
            E_Condition result = E_Condition.EC_Normal;

            /* temporary buffer needed for errorFunction - more detailed explanation there */
            string tmpErrorString = string.Empty;

            /* first remove any possibly existing document from memory */
            clear();

            xmlDoc = new XmlDocument();
            xmlDoc.Load(filename);
            root = xmlDoc.DocumentElement;

            return result;
        }


        // --- character encoding ---

        /** check whether the currently set character encoding handler is valid.
         *  If no encoding handler is set this is equivalent to an invalid handler.
         ** @return OFTrue if handler is valid, OFFalse otherwise
         */
        public bool encodingHandlerValid()
        {
            return false;
        }

        /** set the specified character encoding handler.
         *  NB: 'libxml' relies on GNU 'libiconv' for most character sets.
         ** @param  charset  XML name of the character set (e.g. "ISO-8859-1" for ISO Latin-1)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setEncodingHandler(string charset)
        {
            return E_Condition.EC_IllegalCall;
        }


        // --- navigation and checking ---

        /** get root node of the document
         ** @return cursor pointing to the root node if successful, invalid cursor otherwise
         */
        public DSRXMLCursor getRootNode()
        {
            DSRXMLCursor cursor = new DSRXMLCursor();
            /* set cursor to root node */
            cursor.Node = root;

            return cursor;
        }

        /** get a particular named node of the document.
     *  Please note that the search process is limited to the current node level, i.e. no
     *  deep search is performed.
     ** @param  cursor    cursor pointing to the node where to start from
     *  @param  name      name of the node (XML element) to be searched for
     *  @param  required  flag specifying whether the node is required or not.  If the node
     *                    is required to be present an error message is reported.
     ** @return cursor pointing to the named node if successful, invalid cursor otherwise
     */
        public DSRXMLCursor getNamedNode(DSRXMLCursor cursor, string name, bool required = true)
        {
            if (cursor == null)
            {
                return null;
            }

            DSRXMLCursor result = new DSRXMLCursor();
            /* check whether given name is valid */
            if ((name != null) && (name.Length > 0))
            {
                XmlNode current = cursor.Node;
                /* iterate over all nodes */
                while (current != null)
                {
                    /* ignore blank (empty or whitespace only) nodes */
                    //current = current.NextSibling;
                    if (current != null)
                    {
                        if (String.Compare(current.Name, name, true) == 0)
                        {
                            break;
                        }

                        /* proceed with next node */
                        current = current.NextSibling;
                    }
                }

                if (current == null)
                {
                    /* report error message */
                    if (required)
                    {
                        //OFString tmpString;
                        //DCMSR_ERROR("Document of the wrong type, '" << name
                        //    << "' expected at " << getFullNodePath(cursor, tmpString, OFFalse /*omitCurrent*/));
                    }
                }
                else
                {
                    /* return new node position */
                    result.Node = current;
                }
            }
            return result;
        }

        /** check whether particular node matches a given name
         ** @param  cursor  cursor pointing to the particular node
         *  @param  name    name of the node (XML element) to be checked
         ** @return OFTrue if name matches, OFFalse otherwise
         */
        public bool matchNode(DSRXMLCursor cursor, string name)
        {
            bool result = false;
            if (cursor.Node != null)
            {
                /* check whether node name matches */
                if ((name != null) && (name.Length > 0))
                {
                    if (String.Compare(cursor.Node.Name, name, true) == 0)
                    {
                        result = true;
                    }
                }
            }
            return result;
        }

        /** check whether particular node matches a given name and report an error if not
         ** @param  cursor  cursor pointing to the particular node
         *  @param  name    name of the node (XML element) to be checked
         ** @return OFTrue if name matches, OFFalse otherwise
         */
        public E_Condition checkNode(DSRXMLCursor cursor, string name)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check whether parameters are valid */
            if ((name != null) && (name.Length > 0))
            {
                /* check whether node is valid at all */
                if (cursor.Node != null)
                {
                    /* check whether node has expected name */
                    if (String.Compare(cursor.Node.Name, name, true) != 0)
                    {
                        result = E_Condition.EC_IllegalParameter;
                    }
                    else
                    {
                        result = E_Condition.EC_Normal;
                    }
                }
                else
                {
                    result = E_Condition.EC_IllegalParameter;
                }
            }
            return result;
        }


        // --- get attributes and node content ---

        /** check whether particular node has a specific attribute
         ** @param  cursor  cursor pointing to the particular node
         *  @param  name    name of the XML attribute to be checked
         ** @return OFTrue if attribute is present, OFFalse otherwise
         */
        public bool hasAttribute(ref DSRXMLCursor cursor, string name)
        {
            bool result = false;
            if (cursor.Node != null)
            {
                /* check whether attribute exists */
                if ((name != null) && (name.Length > 0))
                {
                    XmlAttributeCollection attrCollection = cursor.Node.Attributes;
                    if (attrCollection != null)
                    {
                        foreach (XmlAttribute attr in attrCollection)
                        {
                            if ((String.Compare(attr.ToString(), name, true) == 0))
                            {
                                result = true;
                            }
                        }
                    }
                }
            }
            return result;
        }

        /** get string value from particular XML attribute.
         *  The result variable 'stringValue' is automatically cleared at the beginning.
         ** @param  cursor       cursor pointing to the particular node
         *  @param  stringValue  reference to string object in which the value should be stored
         *  @param  name         name of the XML attribute to be retrieved
         *  @param  encoding     use encoding handler if OFTrue, ignore character set otherwise
         *  @param  required     flag specifying whether the attribute is required or not.  If the
         *                       attribute is required to be present an error message is reported
         *                       in case it is not found.
         ** @return reference to string object (might be empty)
         */
        public string getStringFromAttribute(DSRXMLCursor cursor, ref string stringValue, string name, bool encoding = false, bool required = true)
        {
            /* always clear result string */
            stringValue = string.Empty;
            /* check whether parameters are valid */
            if ((cursor.Node != null) && (name != null) && (name.Length > 0))
            {
                /* get the XML attribute value */
                string attributevalue = cursor.Node.Attributes[name].Value;

                if ((attributevalue != null) && (attributevalue.Length > 0))
                {
                    /* put value to DICOM element */
                    stringValue = attributevalue;
                }
                else if (required)
                {
                    //printMissingAttributeError(cursor, name);
                }

            }
            return stringValue;
        }

        /** get element value from particular XML attribute
     ** @param  cursor    cursor pointing to the particular node
     *  @param  delem     DICOM element in which the attribute value is stored
     *  @param  name      name of the XML attribute to be retrieved
     *  @param  encoding  use encoding handler if OFTrue, ignore character set otherwise
     *  @param  required  flag specifying whether the attribute is required or not.  If the
     *                    attribute is required to be present an error message is reported
     *                    in case it is not found.
     ** @return status, EC_Normal if successful, an error code otherwise
     */
        public E_Condition getElementFromAttribute(DSRXMLCursor cursor, ref DicomAttribute delem, string name, bool encoding = false, bool required = true)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            /* check whether parameters are valid */
            if ((cursor.Node != null) && (name != null) && (name.Length > 0))
            {
                /* get the XML attribute value */
                string attributevalue = cursor.Node.Attributes[name].Value;

                if ((attributevalue != null) && (attributevalue.Length > 0))
                {
                    /* put value to DICOM element */
                    delem.AppendString(attributevalue);
                    result = E_Condition.EC_Normal;
                }
                else if (required)
                {
                    //printMissingAttributeError(cursor, name);
                }
            }
            return result;
        }

        /** get string value from particular XML element
         ** @param  cursor       cursor pointing to the particular node
         *  @param  stringValue  reference to string object in which the value should be stored
         *  @param  name         name of the XML element to be retrieved
         *  @param  encoding     use encoding handler if OFTrue, ignore character set otherwise
         *  @param  clearString  flag specifying whether to clear the 'stringValue' at first or not
         ** @return reference to string object (might be empty)
         */
        public string getStringFromNodeContent(DSRXMLCursor cursor, ref string stringValue, string name = null, bool encoding = false, bool clearString = true)
        {
            if (clearString)
            {
                stringValue = string.Empty;
            }
            if (cursor.Node != null)
            {
                /* compare element name if required */
                if ((name == null) || (String.Compare(cursor.Node.Name, name, true) == 0))
                {
                    /* get the XML node content */
                    stringValue = cursor.Node.InnerText;
                }
            }
            return stringValue;
        }

        /** get element value from particular XML element
         ** @param  cursor    cursor pointing to the particular node
         *  @param  delem     DICOM element in which the element value is stored
         *  @param  name      name of the XML element to be retrieved
         *  @param  encoding  use encoding handler if OFTrue, ignore character set otherwise
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition getElementFromNodeContent(DSRXMLCursor cursor, ref DicomAttribute delem, string name = null, bool encoding = false)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (cursor.Node != null)
            {
                /* compare element name if required */
                if (name == null || (String.Compare(cursor.Node.Name, name, true) == 0))
                {
                    string elemStr;
                    /* compare element name if required */
                    if ((name == null) || (String.Compare(cursor.Node.Name, name, true) == 0))
                    {
                        /* get the XML node content */
                        elemStr = cursor.Node.InnerText;
                        delem.AppendString(elemStr);
                        result = E_Condition.EC_Normal;
                    }
                }
            }
            return result;
        }

        /** get value type from particular node.
         *  The value type is either stored as the element name or in the attribute "valType".
         *  Additionally, by-reference relationships are also supported (either by attribute
         *  "ref" being present or element named "reference").
         ** @param  cursor  cursor pointing to the particular node
         ** @return value type (incl. by-reference) if successful, VT_invalid/unknown otherwise
         */
        public E_ValueType getValueTypeFromNode(ref DSRXMLCursor cursor)
        {
            E_ValueType valueType = E_ValueType.VT_invalid;
            if (cursor.valid())
            {
                if ((String.Compare(cursor.Node.Name, "item", true) == 0))
                {
                    XmlAttributeCollection attributeCollection = cursor.Node.Attributes;
                    foreach (Attribute attribute in attributeCollection)
                    {
                        if (String.Compare(attribute.ToString(), "ref", true) == 0)
                        {
                            valueType = E_ValueType.VT_byReference;
                        }
                        else
                        {
                            /* get the XML attribute value */
                            string attrVal = cursor.Node.Attributes[cursor.Node.Name].Value;
                            if ((attrVal != null) && (attrVal.Length > 0))
                            {
                                /* try to convert attribute value to SR value type */
                                valueType = definedTermToValueType(attrVal);
                            }
                        }
                    }
                }

                else
                {
                    /* try to convert tag name to SR value type */
                    valueType = xmlTagNameToValueType(cursor.Node.Name);
                }
            }

            return valueType;
        }

        /** get relationship type from particular node.
         *  The relationship type is either stored in the element "relationship" or in the
         *  attribute "relType".
         ** @param  cursor  cursor pointing to the particular node
         ** @return relationship type if successful, RT_invalid/unknown otherwise
         */
        public E_RelationshipType getRelationshipTypeFromNode(ref DSRXMLCursor cursor)
        {
            E_RelationshipType relationshipType = E_RelationshipType.RT_invalid;
            if (cursor.valid())
            {
                string tmpString = string.Empty;
                /* get the XML attribute value (if present) */
                if (hasAttribute(ref cursor, "relType"))
                {
                    /* try to convert attribute value to SR relationship type */
                    relationshipType = definedTermToRelationshipType(getStringFromAttribute(cursor, ref tmpString, "relType"));
                }
                else
                {
                    DSRXMLCursor Childcursor = getNamedNode(cursor.getChild(), "relationship");
                    /* try to convert content of "relationship" tag to SR relationship type */
                    if (Childcursor.valid())
                        relationshipType = definedTermToRelationshipType(getStringFromNodeContent(Childcursor, ref tmpString));
                }
            }
            return relationshipType;
        }


        // --- error/warning messages ---

        /** print warning message for unexpected node
         ** @param  cursor  cursor pointing to the unexpected node
         */
        public void printUnexpectedNodeWarning(DSRXMLCursor cursor)
        {
            //TODO: DSRXMLDocument: printUnexpectedNodeWarning
        }

        /** print general node error message
         ** @param  cursor  cursor pointing to the unexpected node
         *  @param  result  status used to print details on the error (no message if EC_Normal)
         */
        public void printGeneralNodeError(DSRXMLCursor cursor, ref E_Condition result)
        {
            //TODO: DSRXMLDocument: printGeneralNodeError
        }

        /** convert given string from 'libxml' format (UTF8) to current character set
     ** @param  fromString  character string to be converted
     *  @param  toString    reference to string object in which the result should be stored
     ** @return OFTrue if successful, OFFalse otherwise (e.g. no handler selected)
     */
        protected bool convertUtf8ToCharset(object /*xmlChar*/ fromString, ref string toString)
        {
            //TODO: DSRXMLDocument: convertUtf8ToCharset
            return false;
        }

        /** print error message for missing attribute
         ** @param  cursor  cursor pointing to the relevant node
         *  @param  name    name of the XML attribute
         */
        protected void printMissingAttributeError(ref DSRXMLCursor cursor, string name)
        {
            //TODO: DSRXMLDocument: printMissingAttributeError
        }

        // --- static function ---

        /** get the full path (incl. all predecessors) to the current node.
         *  Returns "<invalid>" in case of an invalid 'cursor'.
         ** @param  cursor       cursor pointing to the relevant node
         *  @param  stringValue  reference to string object in which the result should be stored
         *  @param  omitCurrent  flag indicating whether to omit the current node or not
         */
        protected static string getFullNodePath(ref DSRXMLCursor cursor, ref string stringValue, bool omitCurrent = false)
        {
            //TODO: DSRXMLDocument: getFullNodePath
            return string.Empty;
        }
    }
}
