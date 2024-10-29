using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom.SR
{
    public class DSRNumericMeasurementValue
    {

        /// numeric value (VR=DS, type 1)
        private string NumericValue;
        /// measurement unit (type 2)
        DSRCodedEntryValue MeasurementUnit;
        /// numeric value qualifier (type 3)
        DSRCodedEntryValue ValueQualifier;


        /** default constructor
     */
        public DSRNumericMeasurementValue()
        {
            NumericValue = string.Empty;
            MeasurementUnit = new DSRCodedEntryValue();
            ValueQualifier = new DSRCodedEntryValue();
        }


        /** constructor.
         *  The code triple is only set if it passed the validity check (see setValue()).
         ** @param  numericValue     numeric measurement value. (VR=DS, type 1)
         *  @param  measurementUnit  code representing the measurement name (code meaning)
         *                           and unit (code value). (type 2)
         */
        public DSRNumericMeasurementValue(ref string numericValue, ref DSRCodedEntryValue measurementUnit)
        {
            NumericValue = string.Empty;
            MeasurementUnit = new DSRCodedEntryValue();
            ValueQualifier = new DSRCodedEntryValue();
            /* use the set methods for checking purposes */
            setValue(ref numericValue, ref measurementUnit);
        }


        /** constructor.
         *  The two codes are only set if they passed the validity check (see setValue()).
         ** @param  numericValue     numeric measurement value. (VR=DS, type 1)
         *  @param  measurementUnit  code representing the measurement name (code meaning)
         *                           and unit (code value). (type 2)
         *  @param  valueQualifier   code representing the numeric value qualifier. (type 3)
         */
        public DSRNumericMeasurementValue(ref string numericValue, ref DSRCodedEntryValue measurementUnit, ref DSRCodedEntryValue valueQualifier)
        {
            NumericValue = string.Empty;
            MeasurementUnit = new DSRCodedEntryValue();
            ValueQualifier = new DSRCodedEntryValue();
            /* use the set methods for checking purposes */
            setValue(ref numericValue, ref measurementUnit, ref valueQualifier);
        }


        /** copy constructor
         ** @param  numericMeasurement  numeric measurement value to be copied (not checked !)
         */
        public DSRNumericMeasurementValue(ref DSRNumericMeasurementValue numericMeasurement)
        {
            NumericValue = numericMeasurement.NumericValue;
            MeasurementUnit = numericMeasurement.MeasurementUnit;
            ValueQualifier = numericMeasurement.ValueQualifier;
        }


        /** destructor
         */
        ~DSRNumericMeasurementValue()
        {

        }


        /** clear all internal variables.
     *  Use this method to create an empty numeric measurement value.
     */
        public virtual void clear()
        {
            NumericValue = string.Empty;
            MeasurementUnit.clear();
            ValueQualifier.clear();
        }


        /** check whether the current numeric measurement value is valid.
         *  The value is valid if isEmpty() is true or all three values (numeric value, measurement
         *  unit and value qualifier) do contain valid values (see checkXXX() methods).
         ** @return OFTrue if value is valid, OFFalse otherwise
         */
        public virtual bool isValid()
        {
            return isEmpty() || (checkNumericValue(ref NumericValue) &&
                         checkMeasurementUnit(ref MeasurementUnit) &&
                         checkNumericValueQualifier(ref ValueQualifier));
        }


        /** check whether the current numeric measurement value is empty.
         *  Checks whether both the numeric value and the measurement unit are empty.
         ** @return OFTrue if value is empty, OFFalse otherwise
         */
        public virtual bool isEmpty()
        {
            return (string.IsNullOrEmpty(NumericValue)) && MeasurementUnit.isEmpty();
        }


        /** print numeric measurement value.
         *  The output of a typical numeric measurement value looks like this:
         *  "3" (cm,99_OFFIS_DCMTK,"Length Unit").  If the value is empty the text "empty" is
         *  printed instead.  The numeric value qualifier is never printed.
         ** @param  stream  output stream to which the numeric measurement value should be printed
         *  @param  flags   flag used to customize the output (not used)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public virtual E_Condition print(ref StringBuilder stream, int flags)
        {
            if (isEmpty())
            {
                /* empty value */
                stream.Append("empty");
            }
            else
            {
                string printString = string.Empty;
                stream.Append("\"");
                stream.Append(DSRTypes.convertToPrintString(NumericValue, ref printString));
                stream.Append("\" ");
                MeasurementUnit.print(ref stream, true /*printCodeValue*/, true /*printInvalid*/);
            }
            return E_Condition.EC_Normal;
        }


        /** read numeric measurement value from XML document
         ** @param  doc     document containing the XML file content
         *  @param  cursor  cursor pointing to the starting node
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public virtual E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            E_Condition result = E_Condition.SR_EC_CorruptedXMLStructure;
            if (cursor.valid())
            {
                cursor.gotoChild();
                /* get "value" element (might be absent since "Measured Value Sequence" is type 2) */
                if (!(doc.getStringFromNodeContent(doc.getNamedNode(cursor, "value", false /*required*/), ref NumericValue) == string.Empty))
                {
                    /* get "unit" element (only if "value" present) */
                    result = MeasurementUnit.readXML(ref doc, doc.getNamedNode(cursor, "unit"));
                }
                else
                    result = E_Condition.EC_Normal;
                if (result.good())
                {
                    /* get "qualifier" element (optional, do not report if absent or erroneous) */
                    ValueQualifier.readXML(ref doc, doc.getNamedNode(cursor, "qualifier", false /*required*/));
                }
                if (!isValid())
                    result = E_Condition.SR_EC_InvalidValue;
            }
            return result;
        }


        /** write numeric measurement value in XML format
         ** @param  stream     output stream to which the XML document is written
         *  @param  flags      flag used to customize the output (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public virtual E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            //TODO: DSRNumericMeasurementValue: writeXML
            return E_Condition.EC_IllegalCall;
        }

        /** read measured value sequence and numeric value qualifier code sequence from dataset.
         *  The number of items within the sequences is checked.  If error/warning output are
         *  enabled a warning message is printed if a sequence is absent or contains more than
         *  one item.
         ** @param  dataset    DICOM dataset from which the sequences should be read
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public virtual E_Condition readSequence(ref DicomAttributeCollection dataset)
        {
            /* read MeasuredValueSequence */
            DicomAttribute dseq = DSRTypes.getDicomAttribute(DicomTags.MeasuredValueSequence);
            E_Condition result = DSRTypes.getElementFromDataset(dataset, ref dseq);
            DSRTypes.checkElementValue(dseq, "1", "2", result, "NUM content item");
            if (result.good())
            {
                /* read first item */
                DicomAttributeCollection ditem = dseq.GetSequenceItem(0);
                if (ditem != null)
                {
                    /* read Code */
                    result = readItem(ref ditem);
                }
                else
                {
                    result = E_Condition.EC_CorruptedData;
                }
            }
            if(result.good())
            {
                /* read NumericValueQualifierCodeSequence (optional) */
                dseq = DSRTypes.getDicomAttribute(DicomTags.NumericValueQualifierCodeSequence);
                ValueQualifier.readSequence(ref dataset, ref dseq, "3" /*type*/);
            }
            return result;
        }


        /** write measured value sequence and numeric value qualifier code sequence to dataset.
         *  The measured value sequence is always written (might be empty, though).  The numeric
         *  value qualifier code sequence is optional and, therefore, only written if non-empty.
         ** @param  dataset    DICOM dataset to which the sequences should be written
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public virtual E_Condition writeSequence(ref DicomAttributeCollection dataset)
        {
            //TODO: DSRNumericMeasurementValue: writeSequence
            return E_Condition.EC_IllegalCall;
        }


        /** render numeric measurement value in HTML/XHTML format
     ** @param  docStream    output stream to which the main HTML/XHTML document is written
     *  @param  annexStream  output stream to which the HTML/XHTML document annex is written
     *  @param  annexNumber  reference to the variable where the current annex number is stored.
     *                       Value is increased automatically by 1 after a new entry has been added.
     *  @param  flags        flag used to customize the output (see DSRTypes::HF_xxx)
     ** @return status, EC_Normal if successful, an error code otherwise
     */
        public virtual E_Condition renderHTML(ref StringBuilder docStream, ref StringBuilder annexStream, ref int annexNumber, int flags)
        {
            if (isEmpty())
            {
                /* empty value */
                docStream.Append("<i>empty</i>");
            }
            else
            {
                string htmlString = string.Empty;
                bool fullCode = ((flags & DSRTypes.HF_renderNumericUnitCodes) != 0) && (((flags & DSRTypes.HF_renderInlineCodes) != 0) || ((flags & DSRTypes.HF_renderItemsSeparately) != 0));
                if (!fullCode || ((flags & DSRTypes.HF_useCodeDetailsTooltip) != 0))
                {
                    if ((flags & DSRTypes.HF_XHTML11Compatibility) != 0)
                    {
                        docStream.Append("<span class=\"num\">");
                    }
                    else if ((flags & DSRTypes.HF_HTML32Compatibility) != 0)
                    {
                        docStream.Append("<u>");
                    }
                    else /* HTML 4.01 */
                    {
                        docStream.Append("<span class=\"under\">");
                    }
                }
                docStream.Append(DSRTypes.convertToHTMLString(NumericValue, htmlString, flags));
                docStream.Append(" ");
                /* render full code of the measurement unit (value first?) or code value only */
                MeasurementUnit.renderHTML(ref docStream, flags, fullCode, (flags & DSRTypes.HF_useCodeMeaningAsUnit) == 0 /*valueFirst*/);
                if (!fullCode || ((flags & DSRTypes.HF_useCodeDetailsTooltip) != 0))
                {
                    if ((flags & DSRTypes.HF_HTML32Compatibility) != 0)
                    {
                        docStream.Append("</u>");
                    }
                    else
                    {
                        docStream.Append("</span>");
                    }
                }
            }
            if (!ValueQualifier.isEmpty())
            {
                /* render optional numeric value qualifier */
                docStream.Append(" [");
                ValueQualifier.renderHTML(ref docStream, flags, (flags & DSRTypes.HF_renderInlineCodes) > 0 /*fullCode*/);
                docStream.Append("]");
            }
            return E_Condition.EC_Normal;
        }


        /** get reference to numeric measurement value
         ** @return reference to numeric measurement value
         */
        public DSRNumericMeasurementValue getValue()
        {
            return this;
        }

        /** get copy of numeric measurement value
         ** @param  numericMeasurement  reference to variable in which the value should be stored
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition getValue(ref DSRNumericMeasurementValue numericMeasurement)
        {
            numericMeasurement = this;
            return E_Condition.EC_Normal;
        }


        /** get numeric value
         ** @return current numeric value (might be invalid or an empty string)
         */
        public string getNumericValue()
        {
            return NumericValue;
        }

        /** get measurement unit
         ** @return reference to current measurement unit code (might be invalid or empty)
         */
        //public object /*DSRCodedEntryValue*/ getMeasurementUnit()
        //{
        ////TODO: DSRNumericMeasurementValue: getMeasurementUnit
        //    return object;
        //}


        /** get numeric value qualifier (optional)
         ** @return reference to current numeric value qualifier code (might be invalid or empty)
         */
        //public /*DSRCodedEntryValue*/ getNumericValueQualifier()
        //{
        //    ////TODO: DSRNumericMeasurementValue: getNumericValueQualifier
        //    //return ValueQualifier;
        //}


        /** get copy of measurement unit
     ** @param  measurementUnit  reference to variable in which the code should be stored
     ** @return status, EC_Normal if successful, an error code otherwise
     */
        public E_Condition getMeasurementUnit(ref DSRCodedEntryValue measurementUnit)
        {
            measurementUnit = MeasurementUnit;
            return E_Condition.EC_Normal;
        }

        /** set numeric measurement value.
         *  Before setting the value it is checked (see checkXXX()).  If the value is invalid
         *  the current value is not replaced and remains unchanged.
         ** @param  numericMeasurement  value to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setValue(ref DSRNumericMeasurementValue numericMeasurement)
        {
            return setValue(ref numericMeasurement.NumericValue, ref numericMeasurement.MeasurementUnit, ref numericMeasurement.ValueQualifier);
        }


        /** set numeric value and measurement unit.
         *  Before setting the values they are checked (see checkXXX()).  If the value pair is
         *  invalid the current value pair is not replaced and remains unchanged.
         ** @param  numericValue     numeric value to be set
         *  @param  measurementUnit  measurement unit to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setValue(ref string numericValue, ref DSRCodedEntryValue measurementUnit)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check both values before setting them */
            if (checkNumericValue(ref numericValue) && checkMeasurementUnit(ref measurementUnit))
            {
                NumericValue = numericValue;
                MeasurementUnit = measurementUnit;
                result = E_Condition.EC_Normal;
            }
            return result;
        }


        /** set numeric value, measurement unit and numeric value qualifier.
         *  Before setting the values they are checked (see checkXXX()).  If one of the three
         *  values is invalid the current numeric measurement value is not replaced and remains
         *  unchanged.
         ** @param  numericValue     numeric value to be set
         *  @param  measurementUnit  measurement unit to be set
         *  @param  valueQualifier   numeric value qualifier to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setValue(ref string numericValue, ref DSRCodedEntryValue measurementUnit, ref DSRCodedEntryValue valueQualifier)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* check all three values before setting them */
            if (checkNumericValue(ref numericValue) && checkMeasurementUnit(ref measurementUnit) &&
                checkNumericValueQualifier(ref valueQualifier))
            {
                NumericValue = numericValue;
                MeasurementUnit = measurementUnit;
                ValueQualifier = valueQualifier;
                result = E_Condition.EC_Normal;
            }
            return result;
        }


        /** set numeric value.
         *  Before setting the value it is checked (see checkNumericValue()).  If the value is
         *  invalid the current value is not replaced and remains unchanged.
         ** @param  numericValue     numeric value to be set (VR=DS)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setNumericValue(ref string numericValue)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            if (checkNumericValue(ref numericValue))
            {
                NumericValue = numericValue;
                result = E_Condition.EC_Normal;
            }
            return result;
        }


        /** set measurement unit.
         *  Before setting the code it is checked (see checkMeasurementUnit()).  If the code is
         *  invalid the current code is not replaced and remains unchanged.
         ** @param  measurementUnit  measurement unit to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setMeasurementUnit(ref DSRCodedEntryValue measurementUnit)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            if (checkMeasurementUnit(ref measurementUnit))
            {
                MeasurementUnit = measurementUnit;
                result = E_Condition.EC_Normal;
            }
            return result;
        }


        /** set numeric value qualifier.
         *  This optional code specifies the qualification of the Numeric Value in the Measured
         *  Value Sequence, or the reason for the absence of the Measured Value Sequence Item.
         *  Before setting the code it is checked (see checkNumericValueQualifier()).  If the
         *  code is invalid the current code is not replaced and remains unchanged.
         ** @param  valueQualifier  numeric value qualifier to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setNumericValueQualifier(ref DSRCodedEntryValue valueQualifier)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            if (checkNumericValueQualifier(ref valueQualifier))
            {
                ValueQualifier = valueQualifier;
                result = E_Condition.EC_Normal;
            }
            return result;
        }


        /** get pointer to numeric measurement value
     ** @return pointer to numeric measurement value (never NULL)
     */
        protected DSRNumericMeasurementValue getValuePtr()
        {
            return this;
        }


        /** read numeric measurement value from dataset
         ** @param  dataset    DICOM dataset from which the value should be read
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected virtual E_Condition readItem(ref DicomAttributeCollection dataset)
        {
            /* read NumericValue */
            DicomAttribute key = DSRTypes.getDicomAttribute(DicomTags.NumericValue);
            E_Condition result = DSRTypes.getAndCheckStringValueFromDataset(dataset, key, ref NumericValue, "1", "1", "MeasuredValueSequence");
            if (result.good())
            {
                /* read MeasurementUnitsCodeSequence */
                key = null;
                key = DSRTypes.getDicomAttribute(DicomTags.MeasurementUnitsCodeSequence);
                result = MeasurementUnit.readSequence(ref dataset, ref key, "1" /*type*/);
            }
            return result;
        }


        /** write numeric measurement value to dataset
         ** @param  dataset    DICOM dataset to which the value should be written
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected virtual E_Condition writeItem(ref DicomAttributeCollection dataset)
        {
            /* write NumericValue */
            E_Condition result = DSRTypes.putStringValueToDataset(dataset, DSRTypes.getDicomAttribute(DicomTags.NumericValue), NumericValue);
            /* write MeasurementUnitsCodeSequence */
            if (result.good())
            {
                DicomAttribute seq = DSRTypes.getDicomAttribute(DicomTags.MeasurementUnitsCodeSequence);
                result = MeasurementUnit.writeSequence(ref dataset, ref seq);
            }
            return result;
        }


        /** check the specified numeric value for validity.
         *  Currently the only check that is performed is that the string is not empty.  Later
         *  on it might be checked whether the format conforms to the definition of DS.
         ** @param  numericValue  numeric value to be checked
         ** @return OFTrue if numeric value is valid, OFFalse otherwise
         */
        protected virtual bool checkNumericValue(ref string numericValue)
        {
            return !string.IsNullOrEmpty(numericValue);
        }


        /** check the specified measurement unit for validity.
         *  The isValid() method in class DSRCodedEntryValue is used for this purpose.
         ** @param  measurementUnit  measurement unit to be checked
         ** @return OFTrue if measurement unit is valid, OFFalse otherwise
         */
        protected virtual bool checkMeasurementUnit(ref DSRCodedEntryValue measurementUnit)
        {
            return measurementUnit.isValid();
        }


        /** check the specified numeric value qualifier for validity.
         *  The isEmpty() and isValid() methods in class DSRCodedEntryValue are used for this
         *  purpose.  The conformance with the Context Group 42 (as defined in the DICOM
         *  standard) is not yet checked.
         ** @param  valueQualifier  numeric value qualifier to be checked
         ** @return OFTrue if value qualifier is valid, OFFalse otherwise
         */
        protected virtual bool checkNumericValueQualifier(ref DSRCodedEntryValue valueQualifier)
        {
            return valueQualifier.isEmpty() || valueQualifier.isValid();
        }
    }
}