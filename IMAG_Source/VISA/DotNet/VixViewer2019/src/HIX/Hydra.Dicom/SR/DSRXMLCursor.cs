using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Hydra.Dicom
{
    public class DSRXMLCursor
    {
        /// <summary>
        /// XML node to get the root node
        /// </summary>
        public XmlNode Node;

        /// <summary>
        /// No of child nodes
        /// </summary>
        private static int childCount = 0;

        /// <summary>
        /// Default Constructor
        /// </summary>
        public DSRXMLCursor()
        {
            Node = null;
        }

        /// <summary>
        /// copy constructor
        /// </summary>
        /// <param name="cursor">cursor object to be copied</param>
        public DSRXMLCursor(DSRXMLCursor cursor)
        {
            Node = cursor.Node;
        }

        /// <summary>
        /// set cursor to next XML node (same level).
        /// Blank (empty or whitespace only) nodes are ignored/skipped.
        /// </summary>
        /// <returns>reference to this cursor object (might be invalid)</returns>
        public DSRXMLCursor gotoNext()
        {
            if (Node != null)
            {
                Node = Node.NextSibling;

                if (Node == null)
                {
                    return null;
                }
            }
            return this;
        }

        /// <summary>
        /// set cursor to first XML child node (next lower level).
        /// Blank (empty or whitespace only) nodes are ignored/skipped.
        /// </summary>
        /// <returns>reference to this cursor object (might be invalid)</returns>
        public DSRXMLCursor gotoChild()
        {
            if (Node != null)
            {
                Node = Node.ChildNodes[childCount];

                if (Node == null)
                {
                    return null;
                }
            }

            return this;
        }

        /// <summary>
        /// get cursor pointing to next XML node (same level).
        /// This cursor object is not modified.
        /// </summary>
        /// <returns>copy of the requested cursor object (might be invalid)</returns>
        public DSRXMLCursor getNext()
        {
            DSRXMLCursor cursor = new DSRXMLCursor();

            if (Node != null)
            {
                cursor.Node = Node.LastChild;
            }

            return cursor;
        }

        /// <summary>
        /// get cursor pointing to first XML child node (next lower level).
        /// This cursor object is not modified.
        /// </summary>
        /// <returns>copy of the requested cursor object (might be invalid)</returns>
        public DSRXMLCursor getChild()
        {
            DSRXMLCursor cursor = new DSRXMLCursor();

            if (Node != null)
            {
                cursor.Node = Node.ChildNodes[childCount];
            }

            return cursor;
        }

        public bool valid()
        {
            return (Node != null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public DSRXMLCursor getClone()
        {
            DSRXMLCursor cursor = new DSRXMLCursor();
            cursor.Node = Node;
            return cursor;
        }
    }
}
