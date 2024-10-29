using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;

namespace Hydra.Dicom
{
    public class DSRImageReferenceValue : DSRCompositeReferenceValue
    {
        /// composite reference value (SOP class/instance UID) to presentation state (optional)
        private DSRCompositeReferenceValue PresentationState;

        /// list of referenced frame numbers (associated DICOM VR=IS, VM=1-n, type 1C)
        DSRImageFrameList FrameList;

        /// <summary>
        /// Default Contructor
        /// </summary>
        public DSRImageReferenceValue()
            :base()
        {
            PresentationState = new DSRCompositeReferenceValue();
            FrameList = new DSRImageFrameList();
        }

        /** constructor.
         *  The UID pair is only set if it passed the validity check (see setValue()).
         ** @param  sopClassUID     referenced SOP class UID of the image object.
         *                          (VR=UI, mandatory)
         *  @param  sopInstanceUID  referenced SOP instance UID of the image object.
         *                          (VR=UI, mandatory)
         */
        public DSRImageReferenceValue(string sopClassUID,  string sopInstanceUID)
            : base()
        {
            PresentationState = new DSRCompositeReferenceValue();
            FrameList = new DSRImageFrameList();
            setReference(ref sopClassUID, ref sopInstanceUID);
        }

        /** constructor.
         *  The UID 4-tuple is only set if it passed the validity check (see setValue()).
         ** @param  imageSOPClassUID      referenced SOP class UID of the image object.
         *                                (VR=UI, mandatory)
         *  @param  imageSOPInstanceUID   referenced SOP instance UID of the image object.
         *                                (VR=UI, mandatory)
         *  @param  pstateSOPClassUID     referenced SOP class UID of the presentation state
         *                                object. (VR=UI, optional)
         *  @param  pstateSOPInstanceUID  referenced SOP instance UID of the presentation state
         *                                object. (VR=UI, optional)
         */
        public DSRImageReferenceValue(ref string imageSOPClassUID, ref string imageSOPInstanceUID, ref string pstateSOPClassUID, ref string pstateSOPInstanceUID)
            : base()
        {
            PresentationState = new DSRCompositeReferenceValue();
            FrameList = new DSRImageFrameList();
            setReference(ref imageSOPClassUID, ref imageSOPInstanceUID);
            setPresentationState(new DSRCompositeReferenceValue(ref pstateSOPClassUID, ref pstateSOPInstanceUID));
        }

        /** copy constructor
        ** @param  referenceValue  image reference value to be copied (not checked !)
        */
        public DSRImageReferenceValue(ref DSRImageReferenceValue referenceValue)
            //: DSRCompositeReferenceValue(referenceValue)
        {
            PresentationState = referenceValue.PresentationState;
            FrameList = referenceValue.FrameList;
        }

        /** copy constructor
         ** @param  imageReferenceValue   imagee reference value to be copied (not checked !)
         *  @param  pstateReferenceValue  presentation state reference value to be copied (not
         *                                checked !)
         */
        public DSRImageReferenceValue(ref DSRCompositeReferenceValue imageReferenceValue, ref DSRCompositeReferenceValue pstateReferenceValue)
            :base()
        {
            PresentationState = new DSRCompositeReferenceValue();
            FrameList = new DSRImageFrameList();
            base.setValue(imageReferenceValue);
            setPresentationState(pstateReferenceValue);
        }

        /** destructor
         */
        ~DSRImageReferenceValue()
        {

        }

        /** clear all internal variables.
         *  Since an empty image reference is invalid the reference becomes invalid afterwards.
         */
        public override void clear()
        {
            base.clear();
            PresentationState.clear();
            FrameList.clear();
        }

        /** check whether the current image reference value is valid.
         *  The reference value is valid if SOP class UID and SOP instance UID are valid (see
         *  checkSOP...UID() for details) and the optional presentation state is valid (see
         *  checkPresentationState()).
         ** @return OFTrue if reference value is valid, OFFalse otherwise
         */
        public override bool isValid()
        {
            return base.isValid() && checkPresentationState(ref PresentationState);
        }

        /** check whether the content is short.
         *  This method is used to check whether the rendered output of this content item can be
         *  expanded inline or not (used for renderHTML()).
         ** @param  flags  flag used to customize the output (see DSRTypes::HF_xxx)
         ** @return OFTrue if the content is short, OFFalse otherwise
         */
        public virtual bool isShort(int flags)
        {
            return (FrameList.isEmpty()) || ((flags & DSRTypes.HF_renderFullData) == 0);
        }

        /** print image reference.
     *  The output of a typical image reference value looks like this: (CT image,"1.2.3") or
     *  (CT image,"1.2.3"),(GSPS,"1.2.3.4") if a presentation state is present.
     *  If the SOP class UID is unknown the UID is printed instead of the related name.
     ** @param  stream  output stream to which the image reference value should be printed
     *  @param  flags   flag used to customize the output (see DSRTypes::PF_xxx)
     ** @return status, EC_Normal if successful, an error code otherwise
     */
        public override E_Condition print(ref StringBuilder stream, int flags)
        {
            string modality = DSRTypes.S_DCMModalityTableMap.dcmSOPClassUIDToModality(SOPClassUID);
            stream.Append("(");
            if (modality != null)
            {
                stream.Append(string.Format("{0}{1}", modality, " image"));
            }
            else
            {
                stream.Append(string.Format("{0}{1}{2}", "\\",SOPClassUID,"\\"));
            }
            stream.Append(",");
            if ((flags & DSRTypes.PF_printSOPInstanceUID) != 0)
            {
                stream.Append(string.Format("{0}{1}{2}", "\\", SOPInstanceUID, "\\"));
            }
            if (!FrameList.isEmpty())
            {
                stream.Append(",");
                FrameList.print(ref stream, flags);
            }
            stream.Append(")");
            if (PresentationState.isValid())
            {
                stream.Append(",(GSPS,");
                if ((flags & DSRTypes.PF_printSOPInstanceUID) != 0)
                {
                    stream.Append(string.Format("{0}{1}{2}", "\\", PresentationState.getSOPInstanceUID(), "\\"));
                }
            }
            stream.Append(")");
            return E_Condition.EC_Normal;
        }

        /** read image reference from XML document
         ** @param  doc     document containing the XML file content
         *  @param  cursor  cursor pointing to the starting node
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public override E_Condition readXML(ref DSRXMLDocument doc, DSRXMLCursor cursor)
        {
            /* first read general composite reference information */
            E_Condition result = base.readXML(ref doc, cursor);
            /* then read image related XML tags */
            if (result.good())
            {
                DSRXMLCursor childCursor = doc.getNamedNode(cursor, "frames",false);
                if (childCursor.valid())
                {
                    string tmpString = null;
                    /* put element content to the channel list */
                    result = FrameList.putString(doc.getStringFromNodeContent(childCursor, ref tmpString));
                }
                if (result.good())
                {
                    /* presentation state (optional) */
                    cursor = doc.getNamedNode(cursor, "pstate", false);
                    if (cursor.getChild().valid())
                    {
                        result = PresentationState.readXML(ref doc, cursor);
                    }
                }
            }
            return result;
        }

        /** write image reference in XML format
         ** @param  stream     output stream to which the XML document is written
         *  @param  flags      flag used to customize the output (see DSRTypes::XF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public override E_Condition writeXML(ref StringBuilder stream, int flags)
        {
            E_Condition result = base.writeXML(ref stream, flags);
            if (((flags & DSRTypes.XF_writeEmptyTags) != 0) || (!FrameList.isEmpty()))
            {
                stream.Append("<frames>");
                FrameList.print(ref stream);
                stream.Append("<frames>").AppendLine();
            }
            if (((flags & DSRTypes.XF_writeEmptyTags) != 0) || (PresentationState.isValid()))
            {
                stream.Append("<pstate>").AppendLine();
                if (PresentationState.isValid())
                {
                    PresentationState.writeXML(ref stream, flags);
                }
                stream.Append("<pstate>").AppendLine();
            }
            return result;
        }

        /** render image reference value in HTML/XHTML format
         ** @param  docStream    output stream to which the main HTML/XHTML document is written
         *  @param  annexStream  output stream to which the HTML/XHTML document annex is written
         *  @param  annexNumber  reference to the variable where the current annex number is stored.
         *                       Value is increased automatically by 1 after a new entry has been added.
         *  @param  flags        flag used to customize the output (see DSRTypes::HF_xxx)
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public override E_Condition renderHTML(ref StringBuilder docStream, ref StringBuilder annexStream, ref int annexNumber, int flags)
        {
            /* reference: image */
            docStream.Append("<a href=\"");
            docStream.Append("http://localhost/dicom.cgi");
            docStream.Append("?image=");
            docStream.Append(SOPClassUID);
            docStream.Append("+");
            docStream.Append(SOPInstanceUID);
            /* reference: pstate */
            if (PresentationState.isValid())
            {
                docStream.Append("&amp;pstate=");
                docStream.Append(PresentationState.getSOPClassUID());
                docStream.Append("+");
                docStream.Append(PresentationState.getSOPInstanceUID());
            }
            /* reference: frames */
            if (!FrameList.isEmpty())
            {
                docStream.Append("&amp;frames=");
                FrameList.print(ref docStream, 0 /*flags*/, '+');
            }
            docStream.Append("\">");
            /* text: image */
            string modality = DSRTypes.S_DCMModalityTableMap.dcmSOPClassUIDToModality(SOPClassUID);
            if (modality != null)
            {
                docStream.Append(modality);
            }
            else
            {
                docStream.Append("unknown");
            }
            docStream.Append(" image");
            /* text: pstate */
            if (PresentationState.isValid())
            {
                docStream.Append(" with GSPS");
            }            
            docStream.Append("</a>");
            if (!isShort(flags))
            {
                string lineBreak = ((flags & DSRTypes.HF_renderSectionTitlesInline) != 0) ? " " :
                                   ((flags & DSRTypes.HF_XHTML11Compatibility) != 0) ? "<br />" : "<br>";
                if ((flags & DSRTypes.HF_currentlyInsideAnnex) != 0)
                {
                    docStream.AppendLine();
                    docStream.Append("<p>").AppendLine();
                    /* render frame list (= print)*/
                    docStream.Append("<b>Referenced Frame Number:</b>");
                    docStream.Append(lineBreak);
                    FrameList.print(ref docStream);
                    docStream.Append("</p>");
                }
                else
                {
                    docStream.Append(" ");
                    DSRTypes.createHTMLAnnexEntry(docStream, annexStream, "for more details see", ref annexNumber, flags);
                    annexStream.Append("<p>").AppendLine();
                    annexStream.Append("<b>Referenced Frame Number:</b>");
                    annexStream.Append(lineBreak);
                    FrameList.print(ref annexStream);
                    annexStream.Append("</p>").AppendLine();

                }
            }

            return E_Condition.EC_Normal;
        }

        /** get reference to image reference value
         ** @return reference to image reference value
         */
        public DSRImageReferenceValue getValue()
        {
            return this;
        }

        /** get copy of image reference value
         ** @param  referenceValue  reference to variable in which the value should be stored
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition getValue(ref DSRImageReferenceValue referenceValue)
        {
            referenceValue = this;
            return E_Condition.EC_Normal;
        }

        /** set image reference value.
         *  Before setting the reference it is checked (see checkXXX()).  If the value is
         *  invalid the current value is not replaced and remains unchanged.
         ** @param  referenceValue  value to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setValue(ref DSRImageReferenceValue referenceValue)
        {
            E_Condition result = base.setValue(referenceValue);
            if (result.good())
            {
                FrameList = referenceValue.FrameList;
                setPresentationState(referenceValue.PresentationState);
            }
            return result;
        }

        /** get reference to presentation state value
         ** @return reference to presentation state value (might be empty or invalid)
         */
        public DSRCompositeReferenceValue getPresentationState()
        {
            return PresentationState;
        }

        /** set presentation state value.
         *  Before setting the reference it is checked (see checkPresentationState()).
         *  If the value is invalid the current value is not replaced and remains unchanged.
         ** @param  referenceValue  value to be set
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition setPresentationState(DSRCompositeReferenceValue referenceValue)
        {
            if (checkPresentationState(ref referenceValue))
            {
                PresentationState = referenceValue;
                return E_Condition.EC_Normal;
            }
            return E_Condition.EC_IllegalParameter;
        }

        /** check whether the image reference applies to a specific frame.
         *  The image reference applies to a frame (of multiframe images) if the list of
         *  referenced frame numbers is empty or the frame number is part of the list.
         ** @param  frameNumber  number of the frame to be checked
         ** @return OFTrue if reference applies to the specified frame, OFFalse otherwise
         */
        public bool appliesToFrame(Int32 frameNumber)
        {
            bool result = true;
            if (!FrameList.isEmpty())
            {
                result = FrameList.isElement(frameNumber);
            }
            return result;
        }

        /// <summary>
        /// get reference to list of referenced frame numbers
        /// </summary>
        /// <returns>reference to frame list</returns>
        public DSRImageFrameList getFrameList()
        {
            return FrameList;
        }

        protected DSRImageReferenceValue getValuePtr()
        {
            return this;
        }


        /** read image reference value from dataset
         ** @param  dataset    DICOM dataset from which the value should be read
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected override E_Condition readItem(ref DicomAttributeCollection dataset)
        {
            /* read ReferencedSOPClassUID and ReferencedSOPInstanceUID */
            E_Condition result = base.readItem(ref dataset);
            /* read ReferencedFrameNumber (conditional) */
            if (result.good())
            {
                FrameList.read(ref dataset);
            }
            /* read ReferencedSOPSequence (Presentation State, optional) */
            if (result.good())
            {
                string value = "3";
                PresentationState.readSequence(ref dataset, value);
            }
            return result;
        }

        /** write image reference value to dataset
         ** @param  dataset    DICOM dataset to which the value should be written
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected override E_Condition writeItem(DicomAttributeCollection dataset)
        {
            /* write ReferencedSOPClassUID and ReferencedSOPInstanceUID */
            E_Condition result = base.writeItem(dataset);
            /* read ReferencedFrameNumber (conditional) */
            if (result.good())
            {
                if (!FrameList.isEmpty())
                {
                    result = FrameList.write(ref dataset);
                }
            }
            /* write ReferencedSOPSequence (Presentation State, optional) */
            if (result.good())
            {
                if (PresentationState.isValid())
                {
                    PresentationState.writeSequence(ref dataset);
                }
            }
            return result;
        }

        /** check the specified SOP class UID for validity.
         *  The only check that is currently performed is that the UID is not empty.  Later on
         *  it might be checked whether the specified SOP class is really an image storage SOP
         *  class.
         ** @param  sopClassUID  SOP class UID to be checked
         ** @return OFTrue if SOP class UID is valid, OFFalse otherwise
         */
        protected override bool checkSOPClassUID(ref string sopClassUID)
        {
            bool result = false;
           if (base.checkSOPClassUID(ref sopClassUID))
           {
                /* tbd: might check for IMAGE storage class later on */
                result = true;
           }
           return result;
        }

        /** check the presentation state object for validity.
         *  The presentation state object is "valid" if both UIDs are empty or both are not empty
         *  and SOP class UID equals to "GrayscaleSoftcopyPresentationStateStorage".
         ** @param  referenceValue  value to be checked
         ** @return OFTrue if presentation state object is valid, OFFalse otherwise
         */
        protected bool checkPresentationState(ref DSRCompositeReferenceValue referenceValue)
        {
            return referenceValue.isEmpty() || (referenceValue.isValid() &&
                  (referenceValue.getSOPClassUID() ==  DicomUids.GrayscaleSoftcopyPresentationStateStorage.UID));
        }
    }
}
