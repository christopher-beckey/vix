using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRCodedEntryValue
    {
        /// code value (VR=SH, mandatory)
        private string CodeValue;

        /// coding scheme designator (VR=SH, mandatory)
        private string CodingSchemeDesignator;

        /// coding scheme version (VR=SH, optional)
        private string CodingSchemeVersion;

        /// code meaning (VR=LO, mandatory)
        private string CodeMeaning;

        /// <summary>
        /// Default Constructor
        /// </summary>
        public DSRCodedEntryValue()
        {
            CodeValue = string.Empty;
            CodingSchemeDesignator = string.Empty;
            CodingSchemeVersion = string.Empty;
            CodeMeaning = string.Empty;
        }


        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="codeValue"></param>
        /// <param name="codingSchemeDesignator"></param>
        /// <param name="codeMeaning"></param>
        public DSRCodedEntryValue(string codeValue, string codingSchemeDesignator, string codeMeaning)
        {
            CodeValue = codeValue;
            CodingSchemeDesignator = codingSchemeDesignator;
            CodingSchemeVersion = string.Empty;
            CodeMeaning = codeMeaning;
            /* check code */
            setCode(codeValue, codingSchemeDesignator, codeMeaning);
        }


        /// <summary>
        ///  constructor.
        /// </summary>
        /// <param name="codeValue"></param>
        /// <param name="codingSchemeDesignator"></param>
        /// <param name="codingSchemeVersion"></param>
        /// <param name="codeMeaning"></param>
        public DSRCodedEntryValue(ref string codeValue, ref string codingSchemeDesignator, ref string codingSchemeVersion, ref string codeMeaning)
        {
            CodeValue = string.Empty;
            CodingSchemeDesignator = string.Empty;
            CodingSchemeVersion = string.Empty;
            CodeMeaning = string.Empty;

            /* check code */
            setCode(codeValue, codingSchemeDesignator, codingSchemeVersion, codeMeaning);
        }


        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="codedEntryValue"></param>
        public DSRCodedEntryValue(ref DSRCodedEntryValue codedEntryValue)
        {
            CodeValue = codedEntryValue.CodeValue;
            CodingSchemeDesignator = codedEntryValue.CodingSchemeDesignator;
            CodingSchemeVersion = codedEntryValue.CodingSchemeVersion;
            CodeMeaning = codedEntryValue.CodeMeaning;
        }

        /// <summary>
        /// Destructor
        /// </summary>
        ~DSRCodedEntryValue()
        {
        }


        /// <summary>
        /// clear all internal variables.
        /// </summary>
        public virtual void clear()
        {
            CodeValue = string.Empty;
            CodingSchemeDesignator = string.Empty;
            CodingSchemeVersion = string.Empty;
            CodeMeaning = string.Empty;
        }


        /// <summary>
        ///  check whether the current code is valid.
        /// </summary>
        /// <returns></returns>
        public virtual bool isValid()
        {
            return checkCode(CodeValue, CodingSchemeDesignator, CodeMeaning);
        }


        /// <summary>
        ///  check whether the current code is empty.
        /// </summary>
        /// <returns></returns>
        public virtual bool isEmpty()
        {
            return string.IsNullOrEmpty(CodeValue) && string.IsNullOrEmpty(CodingSchemeDesignator) && string.IsNullOrEmpty(CodingSchemeVersion) && string.IsNullOrEmpty(CodeMeaning);
        }


        /// <summary>
        ///  print code.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="printCodeValue"></param>
        /// <param name="printInvalid"></param>
        public void print(ref StringBuilder stream, bool printCodeValue = true, bool printInvalid = false)
        {
            if (isValid())
            {
                string printString = string.Empty;
                stream.Append("(");
                if (printCodeValue)
                {
                    stream.Append(DSRTypes.convertToPrintString(CodeValue, ref printString));
                    stream.Append(",");
                    stream.Append(DSRTypes.convertToPrintString(CodingSchemeDesignator, ref printString));
                    if (!(string.IsNullOrEmpty(CodingSchemeVersion)))
                    {
                        stream.Append("[");
                        stream.Append(DSRTypes.convertToPrintString(CodingSchemeVersion, ref printString));
                        stream.Append("]");
                    }
                }
                else
                {
                    stream.Append(",");
                }
                stream.Append(",\"");
                stream.Append(DSRTypes.convertToPrintString(CodeMeaning, ref printString));
                stream.Append("\")");
            }
            else if (printInvalid)
            {
                stream.Append("invalid code");
            }
        }

        /// <summary>
        ///  read code sequence from dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="tagKey"></param>
        /// <param name="type"></param>
        /// <returns></returns>

        public E_Condition readSequence(ref DicomAttributeCollection dataset, ref DicomAttribute tagKey, string type)
        {
            E_Condition result = E_Condition.SR_EC_InvalidValue;
            /* read CodeSequence */
            DicomAttribute dseq = tagKey;
            result = DSRTypes.getElementFromDataset(dataset, ref dseq);
            DSRTypes.checkElementValue(dseq, "1", type, result, "content item");
            if (result.good())
            {
                DicomSequenceItem ditem = dseq.GetSequenceItem(0);
                if (ditem != null)
                {
                    /* read Code */
                    result = readItem(ditem, tagKey.Tag.Name);
                }
                else
                {
                    result = E_Condition.SR_EC_InvalidDocumentTree;
                }
            }
            return result;
        }


        /// <summary>
        ///  write code sequence to dataset
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="tagKey"></param>
        /// <returns></returns>
        public E_Condition writeSequence(ref DicomAttributeCollection dataset, ref DicomAttribute tagKey)
        {
            E_Condition result = E_Condition.EC_MemoryExhausted;
            ///* write CodeSequence */
            DicomAttribute dseq = tagKey;
            if (dseq != null)
            {
                /* check for empty value */
                if (isEmpty())
                {
                    result = E_Condition.EC_MemoryExhausted;
                }
                else
                {
                    DicomSequenceItem ditem = new DicomSequenceItem();
                    if (ditem != null)
                    {
                        /* write Code */
                        if (isValid())
                        {
                            result = writeItem(ditem);
                        }
                        if (result.good())
                        {
                            dseq.AddSequenceItem(ditem);
                        }                           
                    }
                    else
                    {
                        result = E_Condition.EC_MemoryExhausted;
                    }
                }

                if (result.good())
                {
                    dataset[dseq.Tag.TagValue] = dseq;
                }
            }
            return result;
        }


        /// <summary>
        ///  read code from XML document
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <returns></returns>
        public E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            E_Condition result = E_Condition.SR_EC_CorruptedXMLStructure;
            if (cursor.valid())
            {
                /* check whether code is stored as XML attributes */
                if (doc.hasAttribute(ref cursor, "codValue"))
                {
                    doc.getStringFromAttribute(cursor, ref CodeValue, "codValue", true /*encoding*/);
                    doc.getStringFromAttribute(cursor, ref CodingSchemeDesignator, "codScheme", true /*encoding*/);
                    doc.getStringFromAttribute(cursor, ref CodingSchemeVersion, "codVersion", true /*encoding*/, false /*required*/);
                    doc.getStringFromNodeContent(cursor, ref CodeMeaning, null /*name*/, true /*encoding*/);
                }
                else
                {
                    /* goto first child node */
                    cursor.gotoChild();
                    /* iterate over all content items */
                    while (cursor.valid())
                    {
                        /* check for known element tags */
                        if (doc.matchNode(cursor, "scheme"))
                        {
                            doc.getStringFromNodeContent(doc.getNamedNode(cursor.getChild(), "designator"), ref CodingSchemeDesignator, null /*name*/, true /*encoding*/, false /*clearString*/);
                            doc.getStringFromNodeContent(doc.getNamedNode(cursor.getChild(), "version", false /*required*/), ref CodingSchemeVersion, null /*name*/, true /*encoding*/, false /*clearString*/);
                        }
                        else
                        {
                            doc.getStringFromNodeContent(cursor, ref CodeValue, "value", true /*encoding*/, false /*clearString*/);
                            doc.getStringFromNodeContent(cursor, ref CodeMeaning, "meaning", true /*encoding*/, false /*clearString*/);
                        }
                        /* proceed with next node */
                        cursor.gotoNext();
                    }
                }
                /* check whether code is valid */
                result = (isValid() ? E_Condition.EC_Normal : E_Condition.SR_EC_InvalidValue);
            }
            return result;
        }


        /// <summary>
        ///  write code in XML format
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns></returns>
        public E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            string tmpString = string.Empty;
            int codeComponentsAsAttribute = flags & DSRTypes.XF_codeComponentsAsAttribute;
            int writeEmptyTags = flags & DSRTypes.XF_writeEmptyTags;
            if (Convert.ToBoolean(codeComponentsAsAttribute))
            {
                stream.Append(" codValue=\"");
                stream.Append(DSRTypes.convertToXMLString(CodeValue, tmpString));
                stream.Append("\"");
                stream.Append(" codScheme=\"");
                stream.Append(DSRTypes.convertToXMLString(CodingSchemeDesignator, tmpString));
                stream.Append("\"");

                if (!(string.IsNullOrEmpty(CodingSchemeVersion)) || (Convert.ToBoolean(writeEmptyTags)))
                {
                    stream.Append(" codVersion=\"");
                    stream.Append(DSRTypes.convertToXMLString(CodingSchemeVersion, tmpString));
                    stream.Append("\"");
                }
                stream.Append(">");      // close open bracket from calling routine
                stream.Append(DSRTypes.convertToXMLString(CodeMeaning, tmpString));
            }
            else
            {
                DSRTypes.writeStringValueToXML(stream, CodeValue, "value", (flags & DSRTypes.XF_writeEmptyTags) > 0);
                stream.Append("<scheme>");
                stream.AppendLine();
                DSRTypes.writeStringValueToXML(stream, CodingSchemeDesignator, "designator", (flags & DSRTypes.XF_writeEmptyTags) > 0);
                DSRTypes.writeStringValueToXML(stream, CodingSchemeVersion, "version", (flags & DSRTypes.XF_writeEmptyTags) > 0);
                stream.Append("</scheme>");
                stream.AppendLine();
                DSRTypes.writeStringValueToXML(stream, CodeMeaning, "meaning", (flags & DSRTypes.XF_writeEmptyTags) > 0);
            }
            return E_Condition.EC_Normal;
        }

        /// <summary>
        ///  render code in HTML/XHTML format
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <param name="fullCode"></param>
        /// <param name="valueFirst"></param>
        /// <returns></returns>

        public E_Condition renderHTML(ref StringBuilder stream, int flags, bool fullCode = true, bool valueFirst = false)
        {
            string htmlString = string.Empty;
            int useCodeDetailsTooltip = flags & DSRTypes.HF_useCodeDetailsTooltip;

            if (Convert.ToBoolean(useCodeDetailsTooltip))
            {
                /* render code details as a tooltip */
                stream.Append("<span title=\"(");
                stream.Append(DSRTypes.convertToHTMLString(CodeValue, htmlString, flags));
                stream.Append(", ");
                stream.Append(DSRTypes.convertToHTMLString(CodingSchemeDesignator, htmlString, flags));
                if (!(string.IsNullOrEmpty(CodingSchemeVersion)))
                {
                    stream.Append(" [");
                    stream.Append(DSRTypes.convertToHTMLString(CodingSchemeVersion, htmlString, flags));
                    stream.Append("]");
                }
                stream.Append(", &quot;");
                stream.Append(DSRTypes.convertToHTMLString(CodeMeaning, htmlString, flags));
                stream.Append("&quot;)\">");
                /* render value */
                if (valueFirst)
                {
                    stream.Append(DSRTypes.convertToHTMLString(CodeValue, htmlString, flags));
                }
                else
                {
                    stream.Append(DSRTypes.convertToHTMLString(CodeMeaning, htmlString, flags));
                }
                stream.Append("</span>");
            }
            else
            {
                /* render code in a conventional manner */
                if (valueFirst)
                {
                    stream.Append(DSRTypes.convertToHTMLString(CodeValue, htmlString, flags));
                }
                else
                {
                    stream.Append(DSRTypes.convertToHTMLString(CodeMeaning, htmlString, flags));
                }
                if (fullCode)
                {
                    stream.Append(" (");
                    if (!valueFirst)
                    {
                        stream.Append(DSRTypes.convertToHTMLString(CodeValue, htmlString, flags));
                        stream.Append(", ");
                    }
                    stream.Append(DSRTypes.convertToHTMLString(CodingSchemeDesignator, htmlString, flags));
                    if (!(string.IsNullOrEmpty(CodingSchemeVersion)))
                    {
                        stream.Append(" [");
                        stream.Append(DSRTypes.convertToHTMLString(CodingSchemeVersion, htmlString, flags));
                        stream.Append("]");
                    }
                    if (valueFirst)
                    {
                        stream.Append(", &quot;");
                        stream.Append(DSRTypes.convertToHTMLString(CodeMeaning, htmlString, flags));
                        stream.Append("&quot;");
                    }
                    stream.Append(")");
                }
            }
            return E_Condition.EC_Normal;
        }

        /// <summary>
        ///  get reference to code value
        /// </summary>
        /// <returns></returns>
        public DSRCodedEntryValue getValue()
        {
            return this;
        }

        /// <summary>
        /// get copy of code value
        /// </summary>
        /// <param name="codedEntryValue"></param>
        /// <returns></returns>

        public E_Condition getValue(ref DSRCodedEntryValue codedEntryValue)
        {
            codedEntryValue = this;
            return E_Condition.EC_Normal;
        }

        /// <summary>
        ///  get code value.
        /// </summary>
        /// <returns></returns>
        public string getCodeValue()
        {
            return CodeValue;
        }

        /// <summary>
        ///  get coding scheme designator.
        /// </summary>
        /// <returns></returns>
        public string getCodingSchemeDesignator()
        {
            return CodingSchemeDesignator;
        }

        /// <summary>
        ///  get coding scheme version.
        /// </summary>
        /// <returns></returns>
        public string getCodingSchemeVersion()
        {
            return CodingSchemeVersion;
        }

        /// <summary>
        ///  get code meaning.
        /// </summary>
        /// <returns></returns>

        public string getCodeMeaning()
        {
            return CodeMeaning;
        }

        /// <summary>
        ///  set code value.
        /// </summary>
        /// <param name="codedEntryValue"></param>
        /// <returns></returns>
        E_Condition setValue(ref DSRCodedEntryValue codedEntryValue)
        {
            return setCode(codedEntryValue.CodeValue, codedEntryValue.CodingSchemeDesignator, codedEntryValue.CodingSchemeVersion, codedEntryValue.CodeMeaning);
        }

        /// <summary>
        ///  set code value.
        /// </summary>
        /// <param name="codeValue"></param>
        /// <param name="codingSchemeDesignator"></param>
        /// <param name="codeMeaning"></param>
        /// <returns></returns>
        E_Condition setCode(string codeValue, string codingSchemeDesignator, string codeMeaning)
        {
            return setCode(codeValue, codingSchemeDesignator, "", codeMeaning);
        }


        /// <summary>
        ///  set code value.
        /// </summary>
        /// <param name="codeValue"></param>
        /// <param name="codingSchemeDesignator"></param>
        /// <param name="codingSchemeVersion"></param>
        /// <param name="codeMeaning"></param>
        /// <returns></returns>
        E_Condition setCode(string codeValue, string codingSchemeDesignator, string codingSchemeVersion, string codeMeaning)
        {
            E_Condition result = E_Condition.EC_Normal;
            if (checkCode(codeValue, codingSchemeDesignator, codeMeaning))
            {
                /* copy attributes */
                CodeValue = codeValue;
                CodingSchemeDesignator = codingSchemeDesignator;
                CodingSchemeVersion = codingSchemeVersion;
                CodeMeaning = codeMeaning;
            }
            else
            {
                result = E_Condition.SR_EC_InvalidValue;
            }

            return result;
        }

        /// <summary>
        ///  get pointer to code value
        /// </summary>
        /// <returns></returns>

        protected DSRCodedEntryValue getValuePtr()
        {
            return this;
        }


        /// <summary>
        ///  read code from dataset
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="moduleName"></param>
        /// <returns></returns>
        protected E_Condition readItem(DicomAttributeCollection dataset, string moduleName)
        {
            /* read BasicCodedEntryAttributes only */
            E_Condition result = DSRTypes.getAndCheckStringValueFromDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.CodeValue), ref CodeValue, "1", "1", moduleName);
            if (result.good())
            {
                result = DSRTypes.getAndCheckStringValueFromDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.CodingSchemeDesignator), ref CodingSchemeDesignator, "1", "1", moduleName);
            }

            if (result.good()) /* conditional (type 1C) */
            {
                DSRTypes.getAndCheckStringValueFromDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.CodingSchemeVersion), ref CodingSchemeVersion, "1", "1C", moduleName);
            }

            if (result.good())
            {
                result = DSRTypes.getAndCheckStringValueFromDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.CodeMeaning), ref CodeMeaning, "1", "1", moduleName);
            }

            /* tbd: might add check for correct code */
            return result;
        }

        /// <summary>
        ///  write code to dataset
        /// </summary>
        /// <param name="dataset"></param>
        /// <returns></returns>
        E_Condition writeItem(DicomAttributeCollection dataset)
        {
            /* write BasicCodedEntryAttributes only */
            E_Condition result = DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.CodeValue), CodeValue);
            if (result.good())
                result = DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.CodingSchemeDesignator), CodingSchemeDesignator);
            if (result.good() && !(string.IsNullOrEmpty(CodingSchemeVersion)))                /* conditional (type 1C) */
                result = DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.CodingSchemeVersion), CodingSchemeVersion);
            if (result.good())
                result = DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.CodeMeaning), CodeMeaning);
            return result;
        }

        /// <summary>
        ///  check the specified code for validity.
        /// </summary>
        /// <param name="codeValue"></param>
        /// <param name="codingSchemeDesignator"></param>
        /// <param name="codeMeaning"></param>
        /// <returns></returns>
        bool checkCode(string codeValue, string codingSchemeDesignator, string codeMeaning)
        {
            /* need to check correctness of the code (code dictionary?) */
            return (!string.IsNullOrEmpty(codeValue) && !string.IsNullOrEmpty(codingSchemeDesignator) && !string.IsNullOrEmpty(codeMeaning));
        }
    }
}
