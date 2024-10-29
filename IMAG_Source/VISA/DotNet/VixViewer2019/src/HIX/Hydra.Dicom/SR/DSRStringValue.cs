using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRStringValue
    {
        private String Value;

        /// <summary>
        /// default constructor
        /// </summary>
        public DSRStringValue()
        {
            Value = string.Empty;
        }

        /// <summary>
        /// The string value is only set if it passed the validity check (see setValue()).
        /// </summary>
        /// <param name="stringValue"></param>
        public DSRStringValue(string stringValue)
        {
            setValue(stringValue);
        }

        /// <summary>
        /// copy constructor
        /// </summary>
        /// <param name="stringValue"></param>
        public DSRStringValue(ref DSRStringValue stringValue)
        {
            Value = stringValue.Value;
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRStringValue()
        {

        }

        /// <summary>
        /// clear all member variables. Please note that the content item might become invalid afterwards.
        /// </summary>
        public virtual void clear()
        {
            Value = string.Empty;
        }

        /// <summary>
        /// check whether the current code is valid. See checkValue() for details.
        /// </summary>
        /// <returns> true if code is valid, false otherwise </returns>
        public virtual bool isValid()
        {
            return checkValue(Value);
        }

        /// <summary>
        /// print string value.
        /// The output of a typical string value looks like this: "Short text" or "Very long t..."(incl. the quotation marks).
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="maxLength"></param>
        public void print(ref StringBuilder stream, int maxLength = 0)
        {
            string printString = string.Empty;
            if ((maxLength > 3) && (Value.Length > maxLength))
            {
                stream.Append("\"");
                stream.Append(DSRTypes.convertToPrintString(Value.Substring(0, maxLength - 3), ref printString));
                stream.Append("...\"");
            }
            else
            {
                stream.Append("\"");
                stream.Append(DSRTypes.convertToPrintString(Value, ref printString));
                stream.Append("\"");
            }
        }

        /// <summary>
        /// read string value from dataset.
        /// If error/warning output is enabled a warning message is printed if the string value does
        /// not conform with the type (= 1) and value multiplicity (= 1).
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="tagKey"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition read(DicomAttributeCollection dataset, DicomAttribute tagKey)
        {
            return DSRTypes.getAndCheckStringValueFromDataset(dataset, tagKey, ref Value, "1", "1", "content item");
        }

        /// <summary>
        /// write string value to dataset.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="tagKey"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition write(ref DicomAttributeCollection dataset, DicomAttribute tagKey)
        {
             return DSRTypes.putStringValueToDataset(dataset, tagKey, Value);
        }

        /// <summary>
        /// read string value from XML document.
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <param name="encoding"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor, bool encoding = false)
        {
            E_Condition result = E_Condition.SR_EC_CorruptedXMLStructure;
            if (cursor.valid())
            {
                doc.getStringFromNodeContent(cursor, ref Value);
                result = (isValid() ? E_Condition.EC_Normal : E_Condition.SR_EC_InvalidValue);
            }
            return result;
        }

        /// <summary>
        /// render string value in HTML/XHTML format
        /// </summary>
        /// <param name="docStream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition renderHTML(ref StringBuilder docStream, int flags)
        {
            string htmlString = string.Empty;
            if ((flags & DSRTypes.HF_renderItemsSeparately) == 0)
            {
                if ((flags & DSRTypes.HF_XHTML11Compatibility) != 0)
                {
                    docStream.Append("<span class=\"under\">");                    
                }
                else if ((flags & DSRTypes.HF_HTML32Compatibility) != 0)
                {
                    docStream.Append("<u>");
                }
                else
                {
                    docStream.Append("<span class=\"under\">");
                }
            }
            docStream.Append(DSRTypes.convertToHTMLString(Value, htmlString, flags));
            if ((flags & DSRTypes.HF_renderItemsSeparately) == 0)
            {
                if ((flags & DSRTypes.HF_HTML32Compatibility) != 0)
                {
                    docStream.Append("<u>");
                }
                else
                {
                    docStream.Append("</span>");
                }
            }

            return E_Condition.EC_Normal;
        }

        /// <summary>
        /// get string value
        /// </summary>
        /// <returns> reference to string value </returns>
        public string getValue()
        {
            return Value;
        }

        /// <summary>
        /// set string value.
        /// Before setting the string value it is checked (see checkValue()). If the value is
        /// invalid the current value is not replaced and remains unchanged. Use clear() to
        /// empty the string value (which becomes invalid afterwards).
        /// </summary>
        /// <param name="stringValue"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition setValue(string stringValue)
        {
            if (checkValue(stringValue))
            {
                Value = stringValue;
                return E_Condition.EC_Normal;
            }
            return E_Condition.EC_IllegalParameter;
        }

        /// <summary>
        /// check the specified string value for validity.
        /// This base class just checks that the string value is not empty (since all corresponding
        /// DICOM attributes are type 1). Derived classes might overwrite this method to perform more sophisticated tests.
        /// </summary>
        /// <param name="stringValue"></param>
        protected virtual bool checkValue(string stringValue)
        {
            if (string.IsNullOrEmpty(stringValue))
            {
                return false;
            }
            return true;
        }
    }
}
