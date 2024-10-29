using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;
using System.IO;

namespace Hydra.Dicom
{
    public class DSRDocument : DSRTypes
    {
        DicomAttribute SOPClassUID;

        DicomAttribute SOPInstanceUID;

        DicomAttribute SpecificCharacterSet;

        DicomAttribute InstanceCreationDate;

        DicomAttribute InstanceCreationTime;

        DicomAttribute InstanceCreatorUID;

        DicomAttribute StudyInstanceUID;

        DicomAttribute StudyDate;

        DicomAttribute StudyTime;

        DicomAttribute ReferringPhysicianName;

        DicomAttribute StudyID;

        DicomAttribute AccessionNumber;

        DicomAttribute StudyDescription;

        DicomAttribute PatientName;

        DicomAttribute PatientID;

        DicomAttribute PatientBirthDate;

        DicomAttribute PatientSex;

        DicomAttribute Manufacturer;

        DicomAttribute ManufacturerModelName;

        DicomAttribute DeviceSerialNumber;

        DicomAttribute SoftwareVersions;

        DicomAttribute Modality;

        DicomAttribute SeriesInstanceUID;

        DicomAttribute SeriesDescription;

        DicomAttribute SeriesNumber;

        DicomAttribute InstanceNumber;

        DicomAttribute ContentDate;

        DicomAttribute ContentTime;

        DicomAttribute PreliminaryFlag;

        DicomAttribute CompletionFlag;

        DicomAttribute CompletionFlagDescription;

        DicomAttribute VerificationFlag;

        DicomAttribute VerifyingObserver;

        DicomAttribute PerformedProcedureCode;

        DicomAttribute ReferencedPerformedProcedureStep;

        E_PreliminaryFlag PreliminaryFlagEnum;

        E_CompletionFlag CompletionFlagEnum;

        E_VerificationFlag VerificationFlagEnum;

        E_CharacterSet SpecificCharacterSetEnum;

        DSRSOPInstanceReferenceList PredecessorDocuments;

        DSRSOPInstanceReferenceList IdenticalDocuments;

        DSRSOPInstanceReferenceList PertinentOtherEvidence;

        DSRSOPInstanceReferenceList CurrentRequestedProcedureEvidence;

        DSRCodingSchemeIdentificationList CodingSchemeIdentification;

        DSRDocumentTree DocumentTree;

        bool FinalizedFlag;

        public DSRDocument(E_DocumentType documentType = E_DocumentType.DT_BasicTextSR)
        {
            PreliminaryFlagEnum = E_PreliminaryFlag.PF_invalid;
            CompletionFlagEnum = E_CompletionFlag.CF_invalid;
            VerificationFlagEnum = E_VerificationFlag.VF_invalid;
            SpecificCharacterSetEnum = E_CharacterSet.CS_invalid;

            SOPClassUID = DSRTypes.getDicomAttribute(DicomTags.SopClassUid);
            SOPInstanceUID = DSRTypes.getDicomAttribute(DicomTags.SopInstanceUid);
            SpecificCharacterSet = DSRTypes.getDicomAttribute(DicomTags.SpecificCharacterSet);
            InstanceCreationDate = DSRTypes.getDicomAttribute(DicomTags.InstanceCreationDate);
            InstanceCreationTime = DSRTypes.getDicomAttribute(DicomTags.InstanceCreationTime);
            InstanceCreatorUID = DSRTypes.getDicomAttribute(DicomTags.InstanceCreatorUid);
            StudyInstanceUID = DSRTypes.getDicomAttribute(DicomTags.StudyInstanceUid);
            StudyDate = DSRTypes.getDicomAttribute(DicomTags.StudyDate);
            StudyTime = DSRTypes.getDicomAttribute(DicomTags.StudyTime);
            ReferringPhysicianName = DSRTypes.getDicomAttribute(DicomTags.ReferringPhysiciansName);
            StudyID = DSRTypes.getDicomAttribute(DicomTags.StudyId);
            AccessionNumber = DSRTypes.getDicomAttribute(DicomTags.AccessionNumber);
            StudyDescription = DSRTypes.getDicomAttribute(DicomTags.StudyDescription);
            PatientName = DSRTypes.getDicomAttribute(DicomTags.PatientsName);
            PatientID = DSRTypes.getDicomAttribute(DicomTags.PatientId);
            PatientBirthDate = DSRTypes.getDicomAttribute(DicomTags.PatientsBirthDate);
            PatientSex = DSRTypes.getDicomAttribute(DicomTags.PatientsSex);
            Manufacturer = DSRTypes.getDicomAttribute(DicomTags.Manufacturer);
            ManufacturerModelName = DSRTypes.getDicomAttribute(DicomTags.ManufacturersModelName);
            DeviceSerialNumber = DSRTypes.getDicomAttribute(DicomTags.DeviceSerialNumber);
            SoftwareVersions = DSRTypes.getDicomAttribute(DicomTags.SoftwareVersions);
            SeriesInstanceUID = DSRTypes.getDicomAttribute(DicomTags.SeriesInstanceUid);
            SeriesDescription = DSRTypes.getDicomAttribute(DicomTags.SeriesDescription);
            SeriesNumber = DSRTypes.getDicomAttribute(DicomTags.SeriesNumber);
            InstanceNumber = DSRTypes.getDicomAttribute(DicomTags.InstanceNumber);
            ContentDate = DSRTypes.getDicomAttribute(DicomTags.ContentDate);
            ContentTime = DSRTypes.getDicomAttribute(DicomTags.ContentTime);
            PreliminaryFlag = DSRTypes.getDicomAttribute(DicomTags.PreliminaryFlag);
            CompletionFlag = DSRTypes.getDicomAttribute(DicomTags.CompletionFlag);
            CompletionFlagDescription = DSRTypes.getDicomAttribute(DicomTags.CompletionFlagDescription);
            VerificationFlag = DSRTypes.getDicomAttribute(DicomTags.VerificationFlag);
            Modality = DSRTypes.getDicomAttribute(DicomTags.Modality);
            ReferencedPerformedProcedureStep = DSRTypes.getDicomAttribute(DicomTags.ReferencedPerformedProcedureStepSequence);
            VerifyingObserver = DSRTypes.getDicomAttribute(DicomTags.VerifyingObserverSequence);
            PerformedProcedureCode = DSRTypes.getDicomAttribute(DicomTags.PerformedProcedureCodeSequence);

            PredecessorDocuments = new DSRSOPInstanceReferenceList(DSRTypes.getDicomAttribute(DicomTags.PredecessorDocumentsSequence));
            PertinentOtherEvidence = new DSRSOPInstanceReferenceList(DSRTypes.getDicomAttribute(DicomTags.PertinentOtherEvidenceSequence));
            IdenticalDocuments = new DSRSOPInstanceReferenceList(DSRTypes.getDicomAttribute(DicomTags.IdenticalDocumentsSequence));
            CurrentRequestedProcedureEvidence = new DSRSOPInstanceReferenceList(DSRTypes.getDicomAttribute(DicomTags.CurrentRequestedProcedureEvidenceSequence));
            CodingSchemeIdentification = new DSRCodingSchemeIdentificationList();

            DocumentTree = new DSRDocumentTree(documentType);

            FinalizedFlag = false;

            /* set initial values for a new SOP instance */
            updateAttributes();
        }

        /** update several DICOM attributes.
         *  (e.g. set the modality attribute, generate a new SOP instance UID if required, set date/time, etc.)
         ** @param  updateAll  flag indicating whether all DICOM attributes should be updated or only the
         *                     completion and verification flag. (set DICOM defined terms from enum values)
         */
        public void updateAttributes(bool updateAll = true)
        {
            if (updateAll)
            {
                /* retrieve SOP class UID from internal document type */
                SOPClassUID.SetStringValue(documentTypeToSOPClassUID(getDocumentType()));
                /* put modality string depending on document type */
                Modality.SetStringValue(documentTypeToModality(getDocumentType()));

                /* create new instance number if required (type 1) */
                if (InstanceNumber.IsEmpty)
                    InstanceNumber.SetStringValue("1");
                /* create new series number if required (type 1) */
                if (SeriesNumber.IsEmpty)
                    SeriesNumber.SetStringValue("1");

                /* create new SOP instance UID if required */
                if (SOPInstanceUID.IsEmpty)
                {
                    string tmpString = string.Empty;
                    SOPInstanceUID.SetStringValue(DicomUid.GenerateUid().UID);
                    /* set instance creation date to current date (YYYYMMDD) */
                    InstanceCreationDate.SetStringValue(currentDate(tmpString));
                    /* set instance creation time to current time (HHMMSS) */
                    InstanceCreationTime.SetStringValue(currentTime(tmpString));
                    /* set instance creator UID to identify instances that have been created by this toolkit */
                    InstanceCreatorUID.SetStringValue(DicomUid.GenerateUid().UID);
                }

                /* create new study instance UID if required */
                if (StudyInstanceUID.IsEmpty)
                    StudyInstanceUID.SetStringValue(DicomUid.GenerateUid().UID);
                /* create new series instance UID if required */
                if (SeriesInstanceUID.IsEmpty)
                    SeriesInstanceUID.SetStringValue(DicomUid.GenerateUid().UID);

                /* check and set content date if required */
                if (ContentDate.IsEmpty)
                    ContentDate.SetStringValue(getStringValueFromElement(InstanceCreationDate));
                /* check and set content time if required */
                if (ContentTime.IsEmpty)
                    ContentTime.SetStringValue(getStringValueFromElement(InstanceCreationTime));
            }

            if (getDocumentType() != E_DocumentType.DT_KeyObjectSelectionDocument)
            {
                /* set preliminary flag */
                PreliminaryFlag.SetStringValue(preliminaryFlagToEnumeratedValue(PreliminaryFlagEnum));
                /* check and adjust completion flag if required */
                if (CompletionFlagEnum == E_CompletionFlag.CF_invalid)
                    CompletionFlagEnum = E_CompletionFlag.CF_Partial;
                CompletionFlag.SetStringValue(completionFlagToEnumeratedValue(CompletionFlagEnum));
                /* check and adjust verification flag if required */
                if (VerificationFlagEnum == E_VerificationFlag.VF_invalid)
                    VerificationFlagEnum = E_VerificationFlag.VF_Unverified;
                VerificationFlag.SetStringValue(verificationFlagToEnumeratedValue(VerificationFlagEnum));
            }
        }

        /** read SR document from DICOM dataset.
         *  Please note that the current document is also deleted if the reading process fails.
         *  If the log stream is set and valid the reason for any error might be obtained
         *  from the error/warning output.
         ** @param  dataset  reference to DICOM dataset from which the document should be read
         *  @param  flags    optional flag used to customize the reading process (see DSRTypes::RF_xxx).
         *                   E.g. RF_readDigitalSignatures indicates whether to read the digital
         *                   signatures from the dataset or not.  If set the MACParametersSequence
         *                   and the DigitalSignaturesSequence are read for the general document
         *                   header (equivilent to top-level content item) and each content item
         *                   of the document tree.
         *                   If not removed manually (with 'DSRDocumentTree::removeSignatures')
         *                   the signatures are written back to the dataset when the method 'write'
         *                   is called.
         *                   Please note that the two signature sequences for any other sequence
         *                   (e.g. VerifyingObserver or PredecessorDocuments) are never read.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition read(DicomAttributeCollection dataset, int flags = 0)
        {
            E_Condition result = E_Condition.EC_Normal;
            E_DocumentType documentType = E_DocumentType.DT_invalid;
            Clear();

            result = checkDatasetForReading(dataset, ref documentType);
            if (result.good())
            {
                E_Condition searchCond = E_Condition.EC_Normal;
                E_Condition obsSearchCond = E_Condition.EC_Normal;
                /* type 3 element and attributes which have already been checked are not checked */

                // --- SOP Common Module ---
                getElementFromDataset(dataset, ref SOPClassUID);   /* already checked */
                getAndCheckElementFromDataset(dataset, ref SOPInstanceUID, "1", "1", "SOPCommonModule");
                getAndCheckElementFromDataset(dataset, ref SpecificCharacterSet, "1-n", "1C", "SOPCommonModule");
                if (SpecificCharacterSet.Tag.VM.Length > 1)
                {
                    //TODO: Log
                }

                getAndCheckElementFromDataset(dataset, ref InstanceCreationDate, "1", "3", "SOPCommonModule");
                getAndCheckElementFromDataset(dataset, ref InstanceCreationTime, "1", "3", "SOPCommonModule");
                getAndCheckElementFromDataset(dataset, ref InstanceCreatorUID, "1", "3", "SOPCommonModule");
                CodingSchemeIdentification.read(dataset);

                // --- General Study Module ---
                getAndCheckElementFromDataset(dataset, ref StudyInstanceUID, "1", "1", "GeneralStudyModule");
                getAndCheckElementFromDataset(dataset, ref StudyDate, "1", "2", "GeneralStudyModule");
                getAndCheckElementFromDataset(dataset, ref StudyTime, "1", "2", "GeneralStudyModule");
                getAndCheckElementFromDataset(dataset, ref ReferringPhysicianName, "1", "2", "GeneralStudyModule");
                getAndCheckElementFromDataset(dataset, ref StudyID, "1", "2", "GeneralStudyModule");
                getAndCheckElementFromDataset(dataset, ref AccessionNumber, "1", "2", "GeneralStudyModule");
                getAndCheckElementFromDataset(dataset, ref StudyDescription, "1", "3", "GeneralStudyModule");

                // --- Patient Module ---
                getAndCheckElementFromDataset(dataset, ref PatientName, "1", "2", "PatientModule");
                getAndCheckElementFromDataset(dataset, ref PatientID, "1", "2", "PatientModule");
                getAndCheckElementFromDataset(dataset, ref PatientBirthDate, "1", "2", "PatientModule");
                getAndCheckElementFromDataset(dataset, ref PatientSex, "1", "2", "PatientModule");

                if (requiresEnhancedEquipmentModule(documentType))
                {
                    // --- Enhanced General Equipment Module ---
                    getAndCheckElementFromDataset(dataset, ref Manufacturer, "1", "1", "EnhancedGeneralEquipmentModule");
                    getAndCheckElementFromDataset(dataset, ref ManufacturerModelName, "1", "1", "EnhancedGeneralEquipmentModule");
                    getAndCheckElementFromDataset(dataset, ref DeviceSerialNumber, "1", "1", "EnhancedGeneralEquipmentModule");
                    getAndCheckElementFromDataset(dataset, ref SoftwareVersions, "1-n", "1", "EnhancedGeneralEquipmentModule");
                }
                else
                {
                    // --- General Equipment Module ---
                    getAndCheckElementFromDataset(dataset, ref Manufacturer, "1", "2", "GeneralEquipmentModule");
                    getAndCheckElementFromDataset(dataset, ref ManufacturerModelName, "1", "3", "GeneralEquipmentModule");
                    getAndCheckElementFromDataset(dataset, ref DeviceSerialNumber, "1", "3", "GeneralEquipmentModule");
                    getAndCheckElementFromDataset(dataset, ref SoftwareVersions, "1-n", "3", "GeneralEquipmentModule");
                }

                // --- SR Document Series Module / Key Object Document Series Module ---
                getElementFromDataset(dataset, ref Modality);   /* already checked */
                if (documentType == E_DocumentType.DT_KeyObjectSelectionDocument)
                {
                    getAndCheckElementFromDataset(dataset, ref SeriesInstanceUID, "1", "1", "KeyObjectDocumentSeriesModule");
                    getAndCheckElementFromDataset(dataset, ref SeriesNumber, "1", "1", "KeyObjectDocumentSeriesModule");
                    getAndCheckElementFromDataset(dataset, ref SeriesDescription, "1", "3", "KeyObjectDocumentSeriesModule");
                    /* need to check sequence in two steps (avoids additional getAndCheck... method) */
                    searchCond = getElementFromDataset(dataset, ref ReferencedPerformedProcedureStep);
                    checkElementValue(ReferencedPerformedProcedureStep, "1", "2", searchCond, "KeyObjectDocumentSeriesModule");
                }
                else
                {
                    getAndCheckElementFromDataset(dataset, ref SeriesInstanceUID, "1", "1", "SRDocumentSeriesModule");
                    getAndCheckElementFromDataset(dataset, ref SeriesNumber, "1", "1", "SRDocumentSeriesModule");
                    getAndCheckElementFromDataset(dataset, ref SeriesDescription, "1", "3", "SRDocumentSeriesModule");
                    /* need to check sequence in two steps (avoids additional getAndCheck... method) */
                    searchCond = getElementFromDataset(dataset, ref ReferencedPerformedProcedureStep);
                    checkElementValue(ReferencedPerformedProcedureStep, "1", "2", searchCond, "SRDocumentSeriesModule");
                }

                /* remove possible signature sequences */
                removeAttributeFromSequence(ReferencedPerformedProcedureStep, DSRTypes.getDicomAttribute(DicomTags.MacParametersSequence));
                removeAttributeFromSequence(ReferencedPerformedProcedureStep, DSRTypes.getDicomAttribute(DicomTags.DigitalSignaturesSequence));

                // --- SR Document General Module / Key Object Document Module ---
                if (documentType == E_DocumentType.DT_KeyObjectSelectionDocument)
                {
                    getAndCheckElementFromDataset(dataset, ref InstanceNumber, "1", "1", "KeyObjectDocumentModule");
                    getAndCheckElementFromDataset(dataset, ref ContentDate, "1", "1", "KeyObjectDocumentModule");
                    getAndCheckElementFromDataset(dataset, ref ContentTime, "1", "1", "KeyObjectDocumentModule");
                }
                else
                {
                    getAndCheckElementFromDataset(dataset, ref InstanceNumber, "1", "1", "SRDocumentGeneralModule");
                    getAndCheckElementFromDataset(dataset, ref ContentDate, "1", "1", "SRDocumentGeneralModule");
                    getAndCheckElementFromDataset(dataset, ref ContentTime, "1", "1", "SRDocumentGeneralModule");
                    getAndCheckElementFromDataset(dataset, ref PreliminaryFlag, "1", "3", "SRDocumentGeneralModule");
                    getAndCheckElementFromDataset(dataset, ref CompletionFlag, "1", "1", "SRDocumentGeneralModule");
                    getAndCheckElementFromDataset(dataset, ref CompletionFlagDescription, "1", "3", "SRDocumentGeneralModule");
                    getAndCheckElementFromDataset(dataset, ref VerificationFlag, "1", "1", "SRDocumentGeneralModule");
                    obsSearchCond = getElementFromDataset(dataset, ref VerifyingObserver);
                    PredecessorDocuments.read(dataset);

                    /* need to check sequence in two steps (avoids additional getAndCheck... method) */
                    searchCond = getElementFromDataset(dataset, ref PerformedProcedureCode);
                    checkElementValue(PerformedProcedureCode, "1", "2", searchCond, "SRDocumentGeneralModule");
                    PertinentOtherEvidence.read(dataset);
                }
                IdenticalDocuments.read(dataset);
                CurrentRequestedProcedureEvidence.read(dataset);

                /* remove possible signature sequences */
                removeAttributeFromSequence(VerifyingObserver, DSRTypes.getDicomAttribute(DicomTags.MacParametersSequence));
                removeAttributeFromSequence(VerifyingObserver, DSRTypes.getDicomAttribute(DicomTags.DigitalSignaturesSequence));
                removeAttributeFromSequence(PerformedProcedureCode, DSRTypes.getDicomAttribute(DicomTags.MacParametersSequence));
                removeAttributeFromSequence(PerformedProcedureCode, DSRTypes.getDicomAttribute(DicomTags.DigitalSignaturesSequence));

                /* update internal enumerated values and perform additional checks */
                string tmpString = string.Empty;
                if (documentType != E_DocumentType.DT_KeyObjectSelectionDocument)
                {
                    /* get and check PreliminaryFlag (if present) */
                    if (!PreliminaryFlag.IsEmpty)
                    {
                        PreliminaryFlagEnum = enumeratedValueToPreliminaryFlag(getStringValueFromElement(PreliminaryFlag, ref tmpString));
                        if (PreliminaryFlagEnum == E_PreliminaryFlag.PF_invalid)
                        {
                            printUnknownValueWarningMessage("PreliminaryFlag", tmpString);
                        }
                    }

                    /* get and check CompletionFlag */
                    CompletionFlagEnum = enumeratedValueToCompletionFlag(getStringValueFromElement(CompletionFlag, ref tmpString));
                    if (CompletionFlagEnum == E_CompletionFlag.CF_invalid)
                    {
                        printUnknownValueWarningMessage("CompletionFlag", tmpString);
                    }

                    /* get and check VerificationFlag / VerifyingObserverSequence */
                    VerificationFlagEnum = enumeratedValueToVerificationFlag(getStringValueFromElement(VerificationFlag, ref tmpString));
                    if (VerificationFlagEnum == E_VerificationFlag.VF_invalid)
                    {
                        printUnknownValueWarningMessage("VerificationFlag", tmpString);
                    }
                    else if (VerificationFlagEnum == E_VerificationFlag.VF_Verified)
                    {
                        checkElementValue(VerifyingObserver, "1-n", "1", obsSearchCond, "SRDocumentGeneralModule");
                    }
                }

                SpecificCharacterSetEnum = definedTermToCharacterSet(getStringValueFromElement(SpecificCharacterSet, ref tmpString));
                /* check SpecificCharacterSet */
                if ((SpecificCharacterSetEnum == E_CharacterSet.CS_invalid) && string.IsNullOrEmpty(tmpString))
                {
                    printUnknownValueWarningMessage("SpecificCharacterSet", tmpString);
                }

                /* read SR document tree */
                if (result.good())
                {
                    result = DocumentTree.read(dataset, documentType, flags);
                }
            }

            return result;
        }

        /** check the given dataset before reading.
         *  This methods checks whether the dataset contains at least the DICOM attributes SOP class UID
         *  and modality.  Any incorrectness regarding these two attributes is reported to the log stream
         *  (if valid).  Currently unsupported SOP classes are also reported as an error.
         ** @param  dataset       DICOM dataset to be checked
         *  @param  documentType  SR document type retrieved from the SOP class UID
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        protected E_Condition checkDatasetForReading(DicomAttributeCollection dataset, ref E_DocumentType documentType)
        {
            if (dataset == null)
            {
                return E_Condition.EC_IllegalParameter;
            }

            E_Condition result = E_Condition.EC_Normal;
            string tmpString = string.Empty;
            DicomAttribute sopClassUID = DSRTypes.getDicomAttribute(DicomTags.SopClassUid);
            DicomAttribute modality = DSRTypes.getDicomAttribute(DicomTags.Modality);
            result = getAndCheckElementFromDataset(dataset, ref sopClassUID, "1", "1", "SOPCommonModule");
            if (result.good())
            {
                documentType = sopClassUIDToDocumentType(getStringValueFromElement(sopClassUID, ref tmpString));
                if (documentType == E_DocumentType.DT_invalid)
                {
                    return E_Condition.SR_EC_UnknownDocumentType;
                }
                else if (!isDocumentTypeSupported(documentType))
                {
                    return E_Condition.SR_EC_UnsupportedValue;
                }
            }
            else
            {
                documentType = E_DocumentType.DT_invalid;
            }

            if (result.good())
            {
                if (documentType == E_DocumentType.DT_KeyObjectSelectionDocument)
                {
                    result = getAndCheckElementFromDataset(dataset, ref modality, "1", "1", "KeyObjectDocumentSeriesModule");
                }
                else
                {
                    result = getAndCheckElementFromDataset(dataset, ref modality, "1", "1", "SRDocumentSeriesModule");
                }

                if (result.good())
                {
                    if (getStringValueFromElement(modality, ref tmpString) != documentTypeToModality(documentType))
                    {
                        //TODO: Log
                    }
                }
            }

            return result;
        }

        // --- misc routines ---

        /** clear all internal member variables
         */
        private void Clear()
        {
            SOPClassUID.SetEmptyValue();
            SOPInstanceUID.SetEmptyValue();
            SpecificCharacterSet.SetEmptyValue();
            InstanceCreationDate.SetEmptyValue();
            InstanceCreationTime.SetEmptyValue();
            InstanceCreatorUID.SetEmptyValue();
            StudyInstanceUID.SetEmptyValue();
            StudyDate.SetEmptyValue();
            StudyTime.SetEmptyValue();
            ReferringPhysicianName.SetEmptyValue();
            StudyID.SetEmptyValue();
            AccessionNumber.SetEmptyValue();
            StudyDescription.SetEmptyValue();
            PatientName.SetEmptyValue();
            PatientID.SetEmptyValue();
            PatientBirthDate.SetEmptyValue();
            PatientSex.SetEmptyValue();
            Manufacturer.SetEmptyValue();
            ManufacturerModelName.SetEmptyValue();
            DeviceSerialNumber.SetEmptyValue();
            SoftwareVersions.SetEmptyValue();
            SeriesInstanceUID.SetEmptyValue();
            SeriesNumber.SetEmptyValue();
            InstanceNumber.SetEmptyValue();
            ContentDate.SetEmptyValue();
            ContentTime.SetEmptyValue();
            PreliminaryFlag.SetEmptyValue();
            CompletionFlag.SetEmptyValue();
            CompletionFlagDescription.SetEmptyValue();
            VerificationFlag.SetEmptyValue();
            CodingSchemeIdentification.clear();
            DocumentTree.clear();
        }

        /// <summary>
        /// check whether the document is finalized.
        /// A new document is originally not finalized but can be finalized using the method
        /// finalizeDocument().  This flag is e.g. used to indicate whether the entire document
        /// is digitally signed and, therefore, each newly added verifying observer would corrupt all previous signatures.
        /// </summary>
        /// <returns> true if finalized, false otherwise </returns>
        public bool isFinalized()
        {
            return FinalizedFlag;
        }

        /// <summary>
        /// check whether the current internal state is valid.
        /// The SR document is valid if the corresponding document tree is valid and
        /// the SOP instance UID as well as the SOP class UID are not "empty".
        /// </summary>
        /// <returns> true if valid, false otherwise </returns>
        public bool isValid()
        {
            /* document is valid if the document tree is valid and ... */
            return DocumentTree.isValid() && !string.IsNullOrEmpty(SOPClassUID) && !string.IsNullOrEmpty(SOPInstanceUID);
        }

        // --- input and output ---

        /// <summary>
        /// print current SR document to specified output stream. The output format is identical to that of the dsrdump command line tool.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition print(ref StringBuilder stream, int flags = 0)
        {
            if (stream == null)
            {
                stream = new StringBuilder();
            }

            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (isValid())
            {
                string tmpString = string.Empty;
                /* update only some DICOM attributes */
                updateAttributes(false /*updateAll*/);

                // --- print some general document information ---

                if (!Convert.ToBoolean(flags & PF_printNoDocumentHeader))
                {
                    /* document type/title */
                    stream.Append(documentTypeToDocumentTitle(getDocumentType(), ref tmpString));
                    stream.AppendLine();
                    stream.AppendLine();

                    /* patient related information */
                    if (!string.IsNullOrEmpty(PatientName.ToString()))
                    {
                        stream.Append("Patient             : ");
                        stream.Append(getPrintStringFromElement(PatientName, ref tmpString));

                        string patientStr = string.Empty;
                        if (!string.IsNullOrEmpty(PatientSex.ToString()))
                        {
                            patientStr += getPrintStringFromElement(PatientSex, ref tmpString);
                        }

                        if (!string.IsNullOrEmpty(PatientBirthDate.ToString()))
                        {
                            if (!string.IsNullOrEmpty(patientStr))
                            {
                                patientStr += ", ";
                            }

                            patientStr += getPrintStringFromElement(PatientBirthDate, ref tmpString);
                        }

                        if (!string.IsNullOrEmpty(PatientID.ToString()))
                        {
                            if (!string.IsNullOrEmpty(patientStr))
                            {
                                patientStr += ", ";
                            }

                            patientStr += '#';
                            patientStr += getPrintStringFromElement(PatientID, ref tmpString);
                        }

                        if (!string.IsNullOrEmpty(patientStr))
                        {
                            stream.Append(" (");
                            stream.Append(patientStr);
                            stream.Append(")");
                        }

                        stream.AppendLine();
                    }

                    /* referring physician */
                    if (!string.IsNullOrEmpty(ReferringPhysicianName.ToString()))
                    {
                        stream.Append("Referring Physician : ");
                        stream.Append(getPrintStringFromElement(ReferringPhysicianName, ref tmpString));
                        stream.AppendLine();
                    }

                    /* study related information  */
                    if (!string.IsNullOrEmpty(StudyDescription.ToString()))
                    {
                        stream.Append("Study               : ");
                        stream.Append(getPrintStringFromElement(StudyDescription, ref tmpString));
                        if (!string.IsNullOrEmpty(StudyID.ToString()))
                        {
                            stream.Append(" (#");
                            stream.Append(getPrintStringFromElement(StudyID, ref tmpString));
                            stream.Append(")");
                        }

                        stream.AppendLine();
                    }

                    /* manufacturer and device */
                    if (!string.IsNullOrEmpty(Manufacturer.ToString()))
                    {
                        stream.Append("Manufacturer        : ");
                        stream.Append(getPrintStringFromElement(Manufacturer, ref tmpString));

                        string deviceStr = string.Empty;
                        if (!string.IsNullOrEmpty(ManufacturerModelName.ToString()))
                        {
                            deviceStr += getPrintStringFromElement(ManufacturerModelName, ref tmpString);
                        }

                        if (!string.IsNullOrEmpty(DeviceSerialNumber.ToString()))
                        {
                            if (!string.IsNullOrEmpty(deviceStr))
                            {
                                deviceStr += ", ";
                            }

                            deviceStr += '#';
                            deviceStr += getPrintStringFromElement(DeviceSerialNumber, ref tmpString);
                        }

                        if (!string.IsNullOrEmpty(deviceStr))
                        {
                            stream.Append(" (");
                            stream.Append(deviceStr);
                            stream.Append(")");
                        }

                        stream.AppendLine();
                    }
                    /* Key Object Selection Documents do not contain the SR Document General Module */
                    if (getDocumentType() != E_DocumentType.DT_KeyObjectSelectionDocument)
                    {
                        /* preliminary flag */
                        if (!string.IsNullOrEmpty(PreliminaryFlag.ToString()))
                        {
                            stream.Append("Preliminary Flag    : ");
                            stream.Append(getStringValueFromElement(PreliminaryFlag, ref tmpString));
                            stream.AppendLine();
                        }

                        /* completion flag */
                        stream.Append("Completion Flag     : ");
                        stream.Append(getStringValueFromElement(CompletionFlag, ref tmpString));
                        stream.AppendLine();

                        if (!string.IsNullOrEmpty(CompletionFlagDescription.ToString()))
                        {
                            stream.Append("                      ");
                            stream.Append(getPrintStringFromElement(CompletionFlagDescription, ref tmpString));
                            stream.AppendLine();
                        }

                        /* predecessor documents */
                        if (!PredecessorDocuments.empty())
                        {
                            stream.Append("Predecessor Docs    : ");
                            stream.Append(PredecessorDocuments.getNumberOfInstances());
                            stream.AppendLine();
                        }
                    }

                    /* identical documents */
                    if (!IdenticalDocuments.empty())
                    {
                        stream.Append("Identical Docs      : ");
                        stream.Append(IdenticalDocuments.getNumberOfInstances());
                        stream.AppendLine();
                    }

                    if (getDocumentType() != E_DocumentType.DT_KeyObjectSelectionDocument)
                    {
                        /* verification flag */
                        stream.Append("Verification Flag   : ");
                        stream.Append(getStringValueFromElement(VerificationFlag, ref tmpString));
                        stream.AppendLine();

                        /* verifying observer */
                        int obsCount = getNumberOfVerifyingObservers();
                        for (int i = 1; i <= obsCount; i++)
                        {
                            string dateTime = string.Empty, obsName = string.Empty, organization = string.Empty;
                            DSRCodedEntryValue obsCode = new DSRCodedEntryValue();
                            if (getVerifyingObserver(i, ref dateTime, ref obsName, ref obsCode, ref organization).good())
                            {
                                if (i == 1)
                                {
                                    stream.Append("Verifying Observers : ");
                                    stream.Append(dateTime);
                                    stream.Append(": ");
                                    stream.Append(obsName);
                                }
                                else
                                {
                                    stream.Append("                      ");
                                    stream.Append(dateTime);
                                    stream.Append(": ");
                                    stream.Append(obsName);
                                }

                                if (obsCode.isValid())
                                {
                                    stream.Append(" ");
                                    obsCode.print(ref stream, (flags & PF_printAllCodes) > 0 /*printCodeValue*/);
                                }

                                stream.Append(", ");
                                stream.Append(organization);
                                stream.AppendLine();
                            }
                        }
                    }

                    /* content date and time */
                    if (!string.IsNullOrEmpty(ContentDate.ToString()) && !string.IsNullOrEmpty(ContentTime.ToString()))
                    {
                        stream.Append("Content Date/Time   : ");
                        stream.Append(getPrintStringFromElement(ContentDate, ref tmpString));
                        stream.Append(" ");
                        stream.Append(getPrintStringFromElement(ContentTime, ref tmpString));
                        stream.AppendLine();
                    }

                    stream.AppendLine();
                }

                // --- dump document tree to stream ---
                result = DocumentTree.print(ref stream, flags);
            }
            return result;
        }

        /// <summary>
        /// write current SR document to DICOM dataset.
        /// Please note that the ContentTemplateSequence for the root content item is not written
        /// automatically for particular SOP Classes (e.g. Key Object Selection Document).
        /// Instead, the template identification has to be set manually for the root CONTAINER
        /// (see DSRDocumentTreeNode::setTemplateIdentification()).  This is because the template constraints cannot be checked yet.
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="markedItems"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition write(ref DicomAttributeCollection dataset, DicomAttributeCollection markedItems = null)
        {
            E_Condition result = E_Condition.EC_Normal;
            /* only write valid documents */
            if (isValid())
            {
                /* update all DICOM attributes */
                updateAttributes();

                /* write general document attributes */
                // --- SOP Common Module ---
                addElementToDataset(dataset, SOPClassUID, "1", "1", "SOPCommonModule");
                addElementToDataset(dataset, SOPInstanceUID, "1", "1", "SOPCommonModule");
                addElementToDataset(dataset, SpecificCharacterSet, "1-n", "1C", "SOPCommonModule");
                addElementToDataset(dataset, InstanceCreationDate, "1", "3", "SOPCommonModule");
                addElementToDataset(dataset, InstanceCreationTime, "1", "3", "SOPCommonModule");
                addElementToDataset(dataset, InstanceCreatorUID, "1", "3", "SOPCommonModule");
                CodingSchemeIdentification.write(ref dataset);

                // --- General Study Module ---
                addElementToDataset(dataset, StudyInstanceUID, "1", "1", "GeneralStudyModule");
                addElementToDataset(dataset, StudyDate, "1", "2", "GeneralStudyModule");
                addElementToDataset(dataset, StudyTime, "1", "2", "GeneralStudyModule");
                addElementToDataset(dataset, ReferringPhysicianName, "1", "2", "GeneralStudyModule");
                addElementToDataset(dataset, StudyID, "1", "2", "GeneralStudyModule");
                addElementToDataset(dataset, AccessionNumber, "1", "2", "GeneralStudyModule");
                addElementToDataset(dataset, StudyDescription, "1", "3", "GeneralStudyModule");

                // --- Patient Module ---
                addElementToDataset(dataset, PatientName, "1", "2", "PatientModule");
                addElementToDataset(dataset, PatientID, "1", "2", "PatientModule");
                addElementToDataset(dataset, PatientBirthDate, "1", "2", "PatientModule");
                addElementToDataset(dataset, PatientSex, "1", "2", "PatientModule");

                if (requiresEnhancedEquipmentModule(getDocumentType()))
                {
                    // --- Enhanced General Equipment Module ---
                    addElementToDataset(dataset, Manufacturer, "1", "1", "EnhancedGeneralEquipmentModule");
                    addElementToDataset(dataset, ManufacturerModelName, "1", "1", "EnhancedGeneralEquipmentModule");
                    addElementToDataset(dataset, DeviceSerialNumber, "1", "1", "EnhancedGeneralEquipmentModule");
                    addElementToDataset(dataset, SoftwareVersions, "1-n", "1", "EnhancedGeneralEquipmentModule");
                }
                else
                {
                    // --- General Equipment Module ---
                    addElementToDataset(dataset, Manufacturer, "1", "2", "GeneralEquipmentModule");
                    addElementToDataset(dataset, ManufacturerModelName, "1", "3", "GeneralEquipmentModule");
                    addElementToDataset(dataset, DeviceSerialNumber, "1", "3", "GeneralEquipmentModule");
                    addElementToDataset(dataset, SoftwareVersions, "1-n", "3", "GeneralEquipmentModule");
                }

                // --- SR Document Series Module / Key Object Document Series Module ---
                if (getDocumentType() == E_DocumentType.DT_KeyObjectSelectionDocument)
                {
                    addElementToDataset(dataset, Modality, "1", "1", "KeyObjectDocumentSeriesModule");
                    addElementToDataset(dataset, SeriesInstanceUID, "1", "1", "KeyObjectDocumentSeriesModule");
                    addElementToDataset(dataset, SeriesNumber, "1", "1", "KeyObjectDocumentSeriesModule");
                    addElementToDataset(dataset, SeriesDescription, "1", "3", "KeyObjectDocumentSeriesModule");
                    /* always write empty sequence since not yet fully supported */
                    ReferencedPerformedProcedureStep = null;
                    addElementToDataset(dataset, ReferencedPerformedProcedureStep, "1", "2", "KeyObjectDocumentSeriesModule");
                }
                else
                {
                    addElementToDataset(dataset, Modality, "1", "1", "SRDocumentSeriesModule");
                    addElementToDataset(dataset, SeriesInstanceUID, "1", "1", "SRDocumentSeriesModule");
                    addElementToDataset(dataset, SeriesNumber, "1", "1", "SRDocumentSeriesModule");
                    addElementToDataset(dataset, SeriesDescription, "1", "3", "SRDocumentSeriesModule");
                    /* always write empty sequence since not yet fully supported */
                    ReferencedPerformedProcedureStep = null;
                    addElementToDataset(dataset, ReferencedPerformedProcedureStep, "1", "2", "SRDocumentSeriesModule");
                }

                // --- SR Document General Module / Key Object Document Module ---
                if (getDocumentType() == E_DocumentType.DT_KeyObjectSelectionDocument)
                {
                    addElementToDataset(dataset, InstanceNumber, "1", "1", "KeyObjectDocumentModule");
                    addElementToDataset(dataset, ContentDate, "1", "1", "KeyObjectDocumentModule");
                    addElementToDataset(dataset, ContentTime, "1", "1", "KeyObjectDocumentModule");
                }
                else
                {
                    addElementToDataset(dataset, InstanceNumber, "1", "1", "SRDocumentGeneralModule");
                    addElementToDataset(dataset, ContentDate, "1", "1", "SRDocumentGeneralModule");
                    addElementToDataset(dataset, ContentTime, "1", "1", "SRDocumentGeneralModule");
                    addElementToDataset(dataset, PreliminaryFlag, "1", "3", "SRDocumentGeneralModule");
                    addElementToDataset(dataset, CompletionFlag, "1", "1", "SRDocumentGeneralModule");
                    addElementToDataset(dataset, CompletionFlagDescription, "1", "3", "SRDocumentGeneralModule");
                    addElementToDataset(dataset, VerificationFlag, "1", "1", "SRDocumentGeneralModule");
                    if (VerificationFlagEnum == E_VerificationFlag.VF_Verified)
                    {
                        addElementToDataset(dataset, VerifyingObserver, "1-n", "1", "SRDocumentGeneralModule");
                    }
                    PredecessorDocuments.write(dataset);        /* optional */
                    /* always write empty sequence since not yet fully supported */
                    PerformedProcedureCode = null;
                    addElementToDataset(dataset, PerformedProcedureCode, "1", "2", "SRDocumentGeneralModule");
                    if (result.good())
                    {
                        result = PertinentOtherEvidence.write(dataset);
                    }
                }
                if (result.good())
                {
                    IdenticalDocuments.write(dataset);          /* optional */
                }
                if (result.good())
                {
                    result = CurrentRequestedProcedureEvidence.write(dataset);
                }
                /* write SR document tree */
                if (result.good())
                {
                    result = DocumentTree.write(ref dataset);
                }
            }
            else
            {
                result = E_Condition.EC_IllegalCall;
            }
            return result;
        }

        /// <summary>
        /// read SR document from XML file. The format (Schema) of the XML document is expected to conform to the output format
        /// of the writeXML() method.  In addition, the document can be validated against an XML Schema by setting the flag XF_validateSchema.
        /// Digital signatures in the XML document are not yet supported. Please note that the current document is also deleted if the parsing process fails.
        /// </summary>
        /// <param name="filename"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition readXML(string filename, int flags = 0)
        {
            DSRXMLDocument doc = new DSRXMLDocument();
            /* read, parse and validate XML document */
            E_Condition result = doc.read(filename, flags);
            if (result.good())
            {
                /* re-initialize SR document */
                Clear();
                /* start with document root node */
                DSRXMLCursor cursor = doc.getRootNode();
                /* check whether we really parse a "report" document */
                result = doc.checkNode(cursor, "report");
                if (result.good())
                {
                    /* goto sub-element "sopclass" (first child node!) */
                    result = doc.checkNode(cursor.gotoChild(), "sopclass");
                    if (result.good())
                    {
                        /* determine document type (SOP class) */
                        result = doc.getElementFromAttribute(cursor, ref SOPClassUID, "uid");
                        if (result.good())
                        {
                            /* create new document of specified type (also checks for support) */
                            result = createNewDocument(sopClassUIDToDocumentType(getSOPClassUID()));
                            if (result.good())
                            {
                                /* proceed with document header */
                                result = readXMLDocumentHeader(ref doc, cursor.gotoNext(), flags);
                            }
                            else
                            {
                                //DCMSR_ERROR("Unknown/Unsupported SOP Class UID");
                            }
                        }
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// write current SR document in XML format. The output format is identical to that of the dsr2xml command line tool.  
        /// Digital signatures in the XML document are not yet supported.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition writeXML(ref StringBuilder stream, int flags = 0)
        {
            //TODO DSRDocumentTree: writeXML
            return E_Condition.EC_IllegalCall;
        }

        /// <summary>
        /// render current SR document in HTML/XHTML format. The output format is identical to that of the dsr2html command line tool.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        /// <param name="styleSheet"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition renderHTML(ref StringBuilder stream, int flags = 0, string styleSheet = null)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* only render valid documents */
            if (isValid())
            {
                int newFlags = flags;
                if ((flags & HF_XHTML11Compatibility) != 0)
                {
                    newFlags = (flags & ~DSRTypes.HF_HTML32Compatibility);
                }
                else if ((flags & HF_HTML32Compatibility) != 0)
                {
                    /* fixes for HTML 3.2 */
                    newFlags = (flags & ~HF_useCodeDetailsTooltip) | HF_convertNonASCIICharacters;
                    /* ignore CSS (if any) */
                    styleSheet = null;
                }

                /* used for multiple purposes */
                string tmpString = string.Empty;
                string string2 = string.Empty;
                /* used for HTML tmpString conversion */
                string htmlString = string.Empty;
                /* update only some DICOM attributes */
                updateAttributes(false /* updateAll */);

                // --- HTML/XHTML document structure (start) ---

                if ((newFlags & HF_XHTML11Compatibility) != 0)
                {
                    stream.Append("<?xml version=\"1.0\"");
                    /* optional character set */
                    tmpString = characterSetToXMLName(SpecificCharacterSetEnum);
                    if (!string.IsNullOrEmpty(tmpString))
                    {
                        if (tmpString != "?")
                        {
                            stream.Append(" encoding=\"");
                            stream.Append(tmpString);
                            stream.Append("\"");
                        }
                        else
                        {
                            //TODO: Logging
                            //DCMSR_WARN("Cannot map Specific Character Set to equivalent XML encoding");
                        }
                    }
                    stream.Append("?>");
                    stream.Append(Environment.NewLine);
                }

                /* optional document type definition */
                if ((newFlags & HF_addDocumentTypeReference) != 0)
                {
                    if ((newFlags & HF_XHTML11Compatibility) != 0)
                    {
                        stream.Append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">");
                        stream.Append(Environment.NewLine);
                    }
                    else
                    {
                        if ((newFlags & HF_HTML32Compatibility) != 0)
                        {
                            stream.Append("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//EN\">");
                            stream.Append(Environment.NewLine);
                        }
                        else
                        {
                            stream.Append("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">");
                            stream.Append(Environment.NewLine);
                        }
                    }
                }

                stream.Append("<html");
                if ((newFlags & HF_XHTML11Compatibility) != 0)
                {
                    stream.Append(" xmlns=\"http://www.w3.org/1999/xhtml\"");
                }
                stream.Append(">");
                stream.Append(Environment.NewLine);
                stream.Append("<head>");
                stream.Append(Environment.NewLine);
                /* document title */
                stream.Append("<title>");
                if ((newFlags & HF_renderPatientTitle) != 0)
                {
                    renderHTMLPatientData(ref stream, newFlags);
                }
                else
                {
                    stream.Append(documentTypeToDocumentTitle(getDocumentType(), ref tmpString));
                }
                stream.Append("</title>");
                stream.Append(Environment.NewLine);
                /* for HTML 4.01 and XHTML 1.1 only */
                if ((newFlags & HF_HTML32Compatibility) == 0)
                {
                    /* optional cascading style sheet */
                    if (styleSheet != null)
                    {
                        if ((newFlags & HF_copyStyleSheetContent) != 0)
                        {
                            /* copy content from CSS file */
                            string cssFile = string.Empty;
                            try
                            {
                                cssFile = File.ReadAllText(styleSheet);
                            }
                            catch(Exception)
                            {}

                            if (!string.IsNullOrEmpty(cssFile))
                            {
                                stream.Append("<style type=\"text/css\">");
                                stream.Append(Environment.NewLine);
                                stream.Append("<!--");
                                stream.Append(Environment.NewLine);
                                /* copy all characters */
                                stream.Append(cssFile);
                                stream.Append("//-->");
                                stream.Append(Environment.NewLine);
                                stream.Append("</style>");
                                stream.Append(Environment.NewLine);
                            }
                            else
                            {
                                //DCMSR_WARN("Could not open CSS file \"" << styleSheet << "\" ... ignoring");
                            }
                        }
                        else
                        {
                            /* just add a reference to the CSS file (might be an URL) */
                            stream.Append("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
                            stream.Append(styleSheet);
                            stream.Append("\"");
                            if ((newFlags & HF_XHTML11Compatibility) != 0)
                            {
                                stream.Append(" /");
                            }
                            stream.Append(">");
                            stream.Append(Environment.NewLine);
                        }
                    }

                    /* optional character set */
                    tmpString = characterSetToHTMLName(SpecificCharacterSetEnum);
                    if (!string.IsNullOrEmpty(tmpString))
                    {
                        if (tmpString != "?")
                        {
                            stream.Append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=");
                            stream.Append(tmpString);
                            stream.Append("\"");
                            if ((newFlags & HF_XHTML11Compatibility) != 0)
                            {
                                stream.Append(" /");
                            }
                            stream.Append(">");
                            stream.Append(Environment.NewLine);
                        }
                        else
                        {
                            //TODO: Logging
                            //DCMSR_WARN("Cannot map Specific Character Set to equivalent HTML charset");
                        }
                    }
                }

                /* generator meta element referring to the DCMTK */
                if ((newFlags & HF_omitGeneratorMetaElement) == 0)
                {
                    stream.Append("<meta name=\"generator\" content=\"OFFIS DCMTK "); stream.Append("3.6.0"); stream.Append("\"");
                    if ((newFlags & HF_XHTML11Compatibility) != 0)
                    {
                        stream.Append(" /");
                    }
                    stream.Append(">"); stream.Append(Environment.NewLine);
                }
                stream.Append("</head>"); stream.Append(Environment.NewLine);
                stream.Append("<body>"); stream.Append(Environment.NewLine);



                // --- render some general document information ---
                if ((newFlags & HF_renderNoDocumentHeader) == 0)
                {
                    /* create a table for this purpose */
                    stream.Append("<table>"); stream.Append(Environment.NewLine);
                    /* patient related information */
                    if (!string.IsNullOrEmpty(PatientName))
                    {
                        stream.Append("<tr>"); stream.Append(Environment.NewLine);
                        stream.Append("<td><b>Patient:</b></td>"); stream.Append(Environment.NewLine);
                        stream.Append("<td>");
                        renderHTMLPatientData(ref stream, newFlags);
                        stream.Append("</td>"); stream.Append(Environment.NewLine);
                        stream.Append("</tr>"); stream.Append(Environment.NewLine);
                    }
                    /* referring physician */
                    if (!string.IsNullOrEmpty(ReferringPhysicianName))
                    {
                        stream.Append("<tr>"); stream.Append(Environment.NewLine);
                        stream.Append("<td><b>Referring Physician:</b></td>"); stream.Append(Environment.NewLine);
                        stream.Append("<td>"); stream.Append(convertToHTMLString(dicomToReadablePersonName(getStringValueFromElement(ReferringPhysicianName, ref tmpString), string2), htmlString, newFlags));
                        stream.Append("</td>"); stream.Append(Environment.NewLine);
                        stream.Append("</tr>"); stream.Append(Environment.NewLine);
                    }
                    /* study related information */
                    if (!string.IsNullOrEmpty(StudyDescription))
                    {
                        stream.Append("<tr>"); stream.Append(Environment.NewLine);
                        stream.Append("<td><b>Study:</b></td>"); stream.Append(Environment.NewLine);
                        stream.Append("<td>"); stream.Append(convertToHTMLString(getStringValueFromElement(StudyDescription, ref tmpString), htmlString, newFlags));
                        if (!string.IsNullOrEmpty(StudyID))
                        {
                            stream.Append(" (#"); stream.Append(convertToHTMLString(getStringValueFromElement(StudyID, ref tmpString), htmlString, newFlags)); stream.Append(")");
                        }
                        stream.Append("</td>"); stream.Append(Environment.NewLine);
                        stream.Append("</tr>"); stream.Append(Environment.NewLine);
                    }
                    /* manufacturer */
                    if (!string.IsNullOrEmpty(Manufacturer))
                    {
                        stream.Append("<tr>"); stream.Append(Environment.NewLine);
                        stream.Append("<td><b>Manufacturer:</b></td>"); stream.Append(Environment.NewLine);
                        stream.Append("<td>"); stream.Append(convertToHTMLString(getStringValueFromElement(Manufacturer, ref tmpString), htmlString, newFlags));
                        string deviceStr = string.Empty;
                        if (!string.IsNullOrEmpty(ManufacturerModelName))
                        {
                            deviceStr += convertToHTMLString(getStringValueFromElement(ManufacturerModelName, ref tmpString), htmlString, newFlags);
                        }
                        if (!string.IsNullOrEmpty(DeviceSerialNumber))
                        {
                            if (!string.IsNullOrEmpty(deviceStr))
                            {
                                deviceStr += ", ";
                            }
                            deviceStr += '#';
                            deviceStr += convertToHTMLString(getStringValueFromElement(DeviceSerialNumber, ref tmpString), htmlString, newFlags);
                        }
                        if (!string.IsNullOrEmpty(deviceStr))
                        {
                            stream.Append(" ("); stream.Append(deviceStr); stream.Append(")");
                        }
                        stream.Append("</td>"); stream.Append(Environment.NewLine);
                        stream.Append("</tr>"); stream.Append(Environment.NewLine);
                    }
                    if (getDocumentType() !=  E_DocumentType.DT_KeyObjectSelectionDocument)
                    {
                        /* preliminary flag */
                        if (!string.IsNullOrEmpty(PreliminaryFlag))
                        {
                            stream.Append("<tr>"); stream.Append(Environment.NewLine);
                            stream.Append("<td><b>Preliminary Flag:</b></td>"); stream.Append(Environment.NewLine);
                            stream.Append("<td>"); stream.Append(getStringValueFromElement(PreliminaryFlag, ref tmpString)); stream.Append("</td>"); stream.Append(Environment.NewLine);
                            stream.Append("</tr>"); stream.Append(Environment.NewLine);
                        }
                        /* completion flag */
                        stream.Append("<tr>"); stream.Append(Environment.NewLine);
                        stream.Append("<td><b>Completion Flag:</b></td>"); stream.Append(Environment.NewLine);
                        stream.Append("<td>"); stream.Append(getStringValueFromElement(CompletionFlag, ref tmpString)); stream.Append("</td>"); stream.Append(Environment.NewLine);
                        stream.Append("</tr>"); stream.Append(Environment.NewLine);
                        /* completion flag description */
                        if (!string.IsNullOrEmpty(CompletionFlagDescription))
                        {
                            stream.Append("<tr>"); stream.Append(Environment.NewLine);
                            stream.Append("<td></td>"); stream.Append(Environment.NewLine);
                            stream.Append("<td>"); stream.Append(convertToHTMLString(getStringValueFromElement(CompletionFlagDescription, ref tmpString), htmlString, newFlags));
                            stream.Append("</td>"); stream.Append(Environment.NewLine);
                            stream.Append("</tr>"); stream.Append(Environment.NewLine);
                        }
                        /* predecessor documents */
                        if (!PredecessorDocuments.empty())
                        {
                            stream.Append("<tr>"); stream.Append(Environment.NewLine);
                            stream.Append("<td><b>Predecessor Docs:</b></td>"); stream.Append(Environment.NewLine);
                            renderHTMLReferenceList(ref stream, ref PredecessorDocuments, flags);
                            stream.Append("</tr>"); stream.Append(Environment.NewLine);
                        }
                    }
                    /* identical documents */
                    if (!IdenticalDocuments.empty())
                    {
                        stream.Append("<tr>"); stream.Append(Environment.NewLine);
                        stream.Append("<td><b>Identical Docs:</b></td>"); stream.Append(Environment.NewLine);
                        renderHTMLReferenceList(ref stream, ref IdenticalDocuments, flags);
                        stream.Append("</tr>"); stream.Append(Environment.NewLine);
                    }
                    if (getDocumentType() != E_DocumentType.DT_KeyObjectSelectionDocument)
                    {
                        /* verification flag */
                        stream.Append("<tr>"); stream.Append(Environment.NewLine);
                        stream.Append("<td><b>Verification Flag:</b></td>"); stream.Append(Environment.NewLine);
                        stream.Append("<td>"); stream.Append(getStringValueFromElement(VerificationFlag, ref tmpString)); stream.Append("</td>"); stream.Append(Environment.NewLine);
                        stream.Append("</tr>"); stream.Append(Environment.NewLine);
                        /* verifying observer */
                        int obsCount = getNumberOfVerifyingObservers();
                        for (int i = 1; i <= obsCount; i++)
                        {
                            string dateTime = string.Empty;
                            string obsName = string.Empty;
                            string organization = string.Empty;
                            DSRCodedEntryValue obsCode = new DSRCodedEntryValue();
                            if (getVerifyingObserver(i, ref dateTime, ref obsName, ref obsCode, ref organization).good())
                            {
                                stream.Append("<tr>"); stream.Append(Environment.NewLine);
                                if (i == 1)
                                {
                                    stream.Append("<td><b>Verifying Observers:</b></td>"); stream.Append(Environment.NewLine);
                                }
                                else
                                {
                                    stream.Append("<td></td>");
                                    stream.Append(Environment.NewLine);
                                }
                                stream.Append("<td>");
                                stream.Append(dicomToReadableDateTime(dateTime, string2)); stream.Append(" - ");
                                /* render code details as a tooltip (HTML 4.01 or above) */
                                if (obsCode.isValid() && ((newFlags & DSRTypes.HF_useCodeDetailsTooltip) != 0))
                                {
                                    if ((newFlags & HF_XHTML11Compatibility) != 0)
                                    {
                                        stream.Append("<span class=\"code\" title=\"(");
                                    }
                                    else /* HTML 4.01 */
                                    {
                                        stream.Append("<span class=\"under\" title=\"(");
                                    }
                                    stream.Append(convertToHTMLString(obsCode.getCodeValue(), htmlString, newFlags)); stream.Append(", ");
                                    stream.Append(convertToHTMLString(obsCode.getCodingSchemeDesignator(), htmlString, newFlags));
                                    if (!string.IsNullOrEmpty(obsCode.getCodingSchemeVersion()))
                                    {
                                        stream.Append(" ["); stream.Append(convertToHTMLString(obsCode.getCodingSchemeVersion(), htmlString, newFlags)); stream.Append("]");
                                    }
                                    stream.Append(", &quot;"); stream.Append(convertToHTMLString(obsCode.getCodeMeaning(), htmlString, newFlags)); stream.Append("&quot;)\">");
                                }
                                stream.Append(convertToHTMLString(dicomToReadablePersonName(obsName, string2), htmlString, newFlags));
                                if (obsCode.isValid() && ((newFlags & DSRTypes.HF_useCodeDetailsTooltip) != 0))
                                {
                                    stream.Append("</span>");
                                }
                                else
                                {
                                    /* render code in a conventional manner */
                                    if (obsCode.isValid() && ((newFlags & HF_renderAllCodes) == HF_renderAllCodes))
                                    {
                                        stream.Append(" ("); stream.Append(convertToHTMLString(obsCode.getCodeValue(), htmlString, newFlags));
                                        stream.Append(", "); stream.Append(convertToHTMLString(obsCode.getCodingSchemeDesignator(), htmlString, newFlags));
                                        if (!string.IsNullOrEmpty(obsCode.getCodingSchemeVersion()))
                                        {
                                            stream.Append(" ["); stream.Append(convertToHTMLString(obsCode.getCodingSchemeVersion(), htmlString, newFlags)); stream.Append("]");
                                        }
                                        stream.Append(", &quot;"); stream.Append(convertToHTMLString(obsCode.getCodeMeaning(), htmlString, newFlags)); stream.Append( "&quot;)");
                                    }
                                }
                                stream.Append(", "); stream.Append(convertToHTMLString(organization, htmlString, newFlags));
                                stream.Append("</td>"); stream.Append(Environment.NewLine);
                                stream.Append("</tr>"); stream.Append(Environment.NewLine);
                            }
                        }
                    }
                    if (!string.IsNullOrEmpty(ContentDate) && !string.IsNullOrEmpty(ContentTime))
                    {
                        /* content date and time */
                        stream.Append("<tr>"); stream.Append(Environment.NewLine);
                        stream.Append("<td><b>Content Date/Time:</b></td>"); stream.Append(Environment.NewLine);
                        stream.Append("<td>"); stream.Append(dicomToReadableDate(getStringValueFromElement(ContentDate, ref tmpString), string2)); stream.Append(" ");
                        stream.Append(dicomToReadableTime(getStringValueFromElement(ContentTime, ref tmpString), string2)); stream.Append("</td>"); stream.Append(Environment.NewLine);
                        stream.Append("</tr>"); stream.Append(Environment.NewLine);
                    }
                    /* end of table */
                    stream.Append("</table>"); stream.Append(Environment.NewLine);

                    if ((newFlags & HF_XHTML11Compatibility) != 0)
                    {
                        stream.Append("<hr />"); stream.Append(Environment.NewLine);
                    }
                    else
                    {
                        stream.Append("<hr>"); stream.Append(Environment.NewLine);
                    }
                }

                // --- render document tree to stream ---

                /* create memory output stream for the annex */
                StringBuilder annexStream = new StringBuilder();
                /* render document tree two the streams */
                result = DocumentTree.renderHTML(ref stream, ref annexStream, newFlags);
                /* append annex (with heading) to main document */
                if (result.good())
                {
                    result = appendStream(ref stream, ref annexStream, "<h1>Annex</h1>");
                }

                // --- footnote ---

                if ((newFlags & HF_renderDcmtkFootnote) != 0)
                {
                    if ((newFlags & HF_XHTML11Compatibility) != 0)
                    {
                        stream.Append("<hr />"); stream.Append(Environment.NewLine);
                        stream.Append("<div class=\"footnote\">"); stream.Append(Environment.NewLine);
                    }
                    else
                    {
                        stream.Append("<hr>"); stream.Append(Environment.NewLine);
                        if ((newFlags & HF_HTML32Compatibility) != 0)
                        {
                            stream.Append("<div>"); stream.Append(Environment.NewLine);
                        }
                        else /* HTML 4.01 */
                        {
                            stream.Append("<div class=\"footnote\">"); stream.Append(Environment.NewLine);
                        }
                        stream.Append("<small>"); stream.Append(Environment.NewLine);
                    }
                    stream.Append("This page was generated from a DICOM Structured Reporting document by ");
                    stream.Append("<a href=\""); stream.Append("http://dicom.offis.de/dcmtk"); stream.Append("\">OFFIS DCMTK</a> "); stream.Append("3.6.0"); stream.Append("."); stream.Append(Environment.NewLine);
                    if ((newFlags & HF_XHTML11Compatibility) == 0)
                    {
                        stream.Append("</small>"); stream.Append(Environment.NewLine);
                    }
                    stream.Append("</div>"); stream.Append(Environment.NewLine);
                }

                // --- HTML document structure (end) ---

                stream.Append("</body>"); stream.Append(Environment.NewLine);
                stream.Append("</html>"); stream.Append(Environment.NewLine);
            }

            return result;
        }

        // --- get/set misc attributes ---

        /** get the current SR document type
         ** @return document type (might be DT_invalid if read from dataset)
         */
        E_DocumentType getDocumentType()
        {
            return DocumentTree.getDocumentType();
        }

        /// <summary>
        /// get document tree
        /// </summary>
        /// <returns> reference to the document tree </returns>
        public DSRDocumentTree getTree()
        {
            return DocumentTree;
        }

        /// <summary>
        /// get specific character set type.
        /// If the type is unknown the original DICOM defined term can be retrieved
        /// with the method getSpecificCharacterSet().  Please note that only the
        /// first of possibly multiple values is used to determine the type from the
        /// DICOM code string (multiple character sets are not yet supported).
        /// </summary>
        /// <returns> character set (might be CS_invalid/unknown if not supported) </returns>
        public E_CharacterSet getSpecificCharacterSetType()
        {
            return SpecificCharacterSetEnum;
        }

        /// <summary>
        /// set specific character set type.
        /// The DICOM defined term (see SpecificCharacterSet) is set accordingly.
        /// </summary>
        /// <param name="characterSet"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setSpecificCharacterSetType(E_CharacterSet characterSet)
        {
            SpecificCharacterSetEnum = characterSet;
            SpecificCharacterSet.SetStringValue(characterSetToDefinedTerm(SpecificCharacterSetEnum));

            return true;
        }

        /// <summary>
        /// get document preliminary flag. Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <returns> preliminary flag (might be PF_invalid if not specified) </returns>
        public E_PreliminaryFlag getPreliminaryFlag()
        {
            return PreliminaryFlagEnum;
        }

        /// <summary>
        /// get document completion flag. Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <returns> completion flag (might be CF_invalid if read from dataset) </returns>
        public E_CompletionFlag getCompletionFlag()
        {
            return CompletionFlagEnum;
        }

        /// <summary>
        /// get document completion flag. Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getCompletionFlagDescription()
        {
            return getStringValueFromElement(CompletionFlagDescription);
        }

        /// <summary>
        /// get document completion flag. Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <returns> character string (might be empty) </returns>
        public string getCompletionFlagDescription(ref string description)
        {
            return getStringValueFromElement(CompletionFlagDescription, ref description);
        }

        /// <summary>
        /// get document verification flag. Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <returns> verification flag (might be VF_invalid if read from dataset) </returns>
        public E_VerificationFlag getVerificationFlag()
        {
            return VerificationFlagEnum;
        }

        /// <summary>
        /// get number of verifying observers.
        /// A document can be verified more than once.  The verification flag should be VERIFIED
        /// if any verifying observer is specified.  The details on the observer can be retrieved using the getVerifyingObserver() methods.
        /// Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <returns> number of verifying observers (if any), 0 otherwise </returns>
        public int getNumberOfVerifyingObservers()
        {
            return (int)VerifyingObserver.Count;
        }

        /// <summary>
        /// get information about a verifying observer. All reference variables are cleared before the information is retrieved, i.e. if an error
        /// occurs (return value != EC_Normal) non-empty variables do contain valid (empty) data. Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <param name="idx"></param>
        /// <param name="dateTime"></param>
        /// <param name="observerName"></param>
        /// <param name="organization"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition getVerifyingObserver(int idx, ref string dateTime, ref string observerName, ref string organization)
        {
            DSRCodedEntryValue dummyCode = new DSRCodedEntryValue();
            return getVerifyingObserver(idx, ref dateTime, ref observerName, ref dummyCode, ref organization);
        }

        /// <summary>
        /// get information about a verifying observer. All reference variables are cleared before the information is retrieved, i.e. if an error
        /// occurs (return value != EC_Normal) non-empty variables do contain valid (empty) data. Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <param name="idx"></param>
        /// <param name="dateTime"></param>
        /// <param name="observerName"></param>
        /// <param name="observerCode"></param>
        /// <param name="organization"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition getVerifyingObserver(int idx, ref string dateTime, ref string observerName, ref DSRCodedEntryValue observerCode, ref string organization)
        {
            E_Condition result = E_Condition.EC_IllegalParameter;
            /* clear all reference variables */
            dateTime = string.Empty;
            observerName = string.Empty;
            observerCode.clear();
            organization = string.Empty;
            /* get specified entry */
            if ((idx > 0) && (idx <= getNumberOfVerifyingObservers()))
            {
                DicomAttribute tagKey = DSRTypes.getDicomAttribute(DicomTags.VerificationDateTime);
                /* access by index is currently not very efficient */
                DicomAttributeCollection ditem = VerifyingObserver.GetSequenceItem(idx - 1);
                if (ditem != null)
                {
                    bool res = getStringValueFromDataset(ditem, tagKey, ref dateTime);
                    if (res)
                    {
                        tagKey = DSRTypes.getDicomAttribute(DicomTags.VerifyingObserverName);
                        res = getStringValueFromDataset(ditem, tagKey, ref observerName);
                    }
                    if (res)
                    {
                        tagKey = DSRTypes.getDicomAttribute(DicomTags.VerifyingObserverIdentificationCodeSequence);
                        /* code is optional (type 2) */
                        observerCode.readSequence(ref ditem, ref tagKey, "2" /*type*/);
                        tagKey = DSRTypes.getDicomAttribute(DicomTags.VerifyingOrganization);
                        res = getStringValueFromDataset(ditem, tagKey, ref organization);
                    }
                    if (res)
                    {
                        if (string.IsNullOrEmpty(dateTime) || string.IsNullOrEmpty(observerName) || string.IsNullOrEmpty(organization))
                            result = E_Condition.SR_EC_InvalidValue;
                        else
                            result = E_Condition.EC_Normal;
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// get list of predecessor documents. A document can have more than one (direct) predecessor document.  This is e.g. the case
        /// when two or more documents have been merged to create it.  The corresponding method
        /// createRevisedVersion() automatically adds a reference to the current document.
        /// The DICOM standard states: "[The Predecessor Documents Sequence] Shall refer to SR SOP
        /// Instances (e.g. prior or provisional reports) whose content has been wholly or partially
        /// included in this document with or without modification." and "[...] the use of the
        /// Predecessor Document Sequence allows tracing back to the input SR Document, which in this case is the previous version."
        /// Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <returns> reference to list object </returns>
        public DSRSOPInstanceReferenceList getPredecessorDocuments()
        {
            return PredecessorDocuments;
        }

        /// <summary>
        /// get list of identical documents. Please note that currently the user is responsible for filling and modifying the content of
        /// this list.  However, the list is automatically cleared when a new instance is created (incl.
        /// a revised version of the current document).  Possibly, there will be a createDuplicate()
        /// method or the like in the future which creates an identical copy of the current document in a new study/series.
        /// The DICOM standard states: "If identical copies of an SR Document are to be included in
        /// multiple Studies then the entire SR Document shall be duplicated with appropriate changes
        /// for inclusion into the different Studies (i.e. Study Instance UID, Series Instance UID, SOP
        /// Instance UID, Identical Documents Sequence etc.).  The Identical Documents Sequence Attribute
        /// in each SOP Instance shall contain references to all other duplicate SOP Instances."
        /// </summary>
        /// <returns> reference to list object </returns>
        public DSRSOPInstanceReferenceList getIdenticalDocuments()
        {
            return IdenticalDocuments;
        }

        /// <summary>
        /// get list of referenced SOP instances (Current Requested Procedure Evidence).
        /// The DICOM standard states: "The intent of the Current Requested Procedure Evidence Sequence
        /// is to reference all evidence created in order to satisfy the current Requested Procedure(s)
        /// for this SR Document.  This shall include, but is not limited to, all current evidence
        /// referenced in the content tree." and "For a completed SR Document satisfying (i.e., being
        /// the final report for) the current Requested Procedure(s), this sequence shall list the full
        /// set of Composite SOP Instances created for the current Requested Procedure(s).  For other
        /// SOP Instances that include the SR Document General Module, this sequence shall contain at
        /// minimum the set of Composite SOP Instances from the current Requested Procedure(s) that are
        /// referenced in the content tree." and "In the context of the Key Object Selection, the
        /// current evidence is considered to be only the set of instances referenced within the Key  Object Selection."
        /// </summary>
        /// <returns> reference to list object </returns>
        public DSRSOPInstanceReferenceList getCurrentRequestedProcedureEvidence()
        {
            return CurrentRequestedProcedureEvidence;
        }

        /// <summary>
        /// get list of referenced SOP instances (Pertinent Other Evidence).
        /// The DICOM standard states: "The Pertinent Other Evidence Sequence attribute is used to
        /// reference all other evidence considered pertinent for this SR Document that is not listed
        /// in the Current Requested Procedure Evidence Sequence.  This requires that the same SOP
        /// Instance shall not be referenced in both of these Sequences."
        /// Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <returns> reference to list object </returns>
        public DSRSOPInstanceReferenceList getPertinentOtherEvidence()
        {
            return PertinentOtherEvidence;
        }

        /// <summary>
        /// get list of coding schemes used (Coding Scheme Identification). The Coding Scheme Identification Sequence maps Coding Scheme 
        /// Designators to an external coding system registration, or to a private or local coding scheme.  See DICOM standard for details.
        /// </summary>
        /// <returns> reference to list object </returns>
        public DSRCodingSchemeIdentificationList getCodingSchemeIdentification()
        {
            return CodingSchemeIdentification;
        }

        // --- get DICOM string attributes (C string) ---
        // --- (these functions return the whole string value,
        // ---  i.e. all components of multi-valued attributes)

        /// <summary>
        /// get modality
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getModality()
        {
            return getStringValueFromElement(Modality);
        }

        /// <summary>
        /// get SOP class UID
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getSOPClassUID()
        {
            return getStringValueFromElement(SOPClassUID);
        }

        /// <summary>
        /// get study instance UID
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getStudyInstanceUID()
        {
            return getStringValueFromElement(StudyInstanceUID);
        }

        /// <summary>
        /// get series instance UID
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getSeriesInstanceUID()
        {
            return getStringValueFromElement(SeriesInstanceUID);
        }

        /// <summary>
        /// get SOP instance UID
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getSOPInstanceUID()
        {
            return getStringValueFromElement(SOPInstanceUID);
        }

        /// <summary>
        /// get instance creator UID
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getInstanceCreatorUID()
        {
            return getStringValueFromElement(InstanceCreatorUID);
        }

        /// <summary>
        /// get specific character set
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getSpecificCharacterSet()
        {
            return getStringValueFromElement(SpecificCharacterSet);
        }

        /// <summary>
        /// get patient's name.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getPatientName()
        {
            return getStringValueFromElement(PatientName);
        }

        /// <summary>
        /// get patient's birth date.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getPatientBirthDate()
        {
            return getStringValueFromElement(PatientBirthDate);
        }

        /// <summary>
        /// get patient's sex.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getPatientSex()
        {
            return getStringValueFromElement(PatientSex);
        }

        /// <summary>
        /// get referring physicians name.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getReferringPhysicianName()
        {
            return getStringValueFromElement(ReferringPhysicianName);
        }

        /// <summary>
        /// get study description.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getStudyDescription()
        {
            return getStringValueFromElement(StudyDescription);
        }

        /// <summary>
        /// get series description.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getSeriesDescription()
        {
            return getStringValueFromElement(SeriesDescription);
        }

        /// <summary>
        /// get manufacturer.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getManufacturer()
        {
            return getStringValueFromElement(Manufacturer);
        }

        /// <summary>
        /// get manufacturer's model name.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getManufacturerModelName()
        {
            return getStringValueFromElement(ManufacturerModelName);
        }

        /// <summary>
        /// get device serial number.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getDeviceSerialNumber()
        {
            return getStringValueFromElement(DeviceSerialNumber);
        }

        /// <summary>
        /// get software version(s).
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getSoftwareVersions()
        {
            return getStringValueFromElement(SoftwareVersions);
        }

        /// <summary>
        /// get study date.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getStudyDate()
        {
            return getStringValueFromElement(StudyDate);
        }

        /// <summary>
        /// get study time.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getStudyTime()
        {
            return getStringValueFromElement(StudyTime);
        }

        /// <summary>
        /// get instance creation date.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getInstanceCreationDate()
        {
            return getStringValueFromElement(InstanceCreationDate);
        }

        /// <summary>
        /// get instance creation time.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getInstanceCreationTime()
        {
            return getStringValueFromElement(InstanceCreationTime);
        }

        /// <summary>
        /// get content date.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getContentDate()
        {
            return getStringValueFromElement(ContentDate);
        }

        /// <summary>
        /// get content time.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getContentTime()
        {
            return getStringValueFromElement(ContentTime);
        }

        /// <summary>
        /// get study ID.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getStudyID()
        {
                return getStringValueFromElement(StudyID);
        }

        /// <summary>
        /// get patient ID.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getPatientID()
        {
            return getStringValueFromElement(PatientID);
        }

        /// <summary>
        /// get series number.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getSeriesNumber()
        {
            return getStringValueFromElement(SeriesNumber);
        }

        /// <summary>
        /// get instance number.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getInstanceNumber()
        {
            return getStringValueFromElement(InstanceNumber);
        }

        /// <summary>
        /// get accession number.
        /// </summary>
        /// <returns> pointer to string value (might be NULL) </returns>
        public string getAccessionNumber()
        {
            return getStringValueFromElement(AccessionNumber);
        }

        // --- get DICOM string attributes (C++ string) ---
        // --- (these functions return only the first
        // ---  component of multi-valued attributes)

        /// <summary>
        /// get modality
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getModality(ref string value)
        {
            return getStringValueFromElement(Modality, ref value);
        }

        /// <summary>
        /// get SOP class UID
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getSOPClassUID(ref string value)
        {
            return getStringValueFromElement(SOPClassUID, ref value);
        }

        /// <summary>
        /// get study instance UID
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getStudyInstanceUID(ref string value)
        {
            return getStringValueFromElement(StudyInstanceUID, ref value);
        }

        /// <summary>
        /// get series instance UID
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getSeriesInstanceUID(ref string value)
        {
            return getStringValueFromElement(SeriesInstanceUID, ref value);
        }

        /// <summary>
        /// get SOP instance UID
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getSOPInstanceUID(ref string value)
        {
            return getStringValueFromElement(SOPInstanceUID, ref value);
        }

        /// <summary>
        /// get instance creator UID
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getInstanceCreatorUID(ref string value)
        {
            return getStringValueFromElement(InstanceCreatorUID, ref value);
        }

        /// <summary>
        /// get specific character set
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getSpecificCharacterSet(ref string value)
        {
            return getStringValueFromElement(SpecificCharacterSet, ref value);
        }

        /// <summary>
        /// get patient's name.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getPatientName(ref string value)
        {
            return getStringValueFromElement(PatientName, ref value);
        }

        /// <summary>
        /// get patient's birth date.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getPatientBirthDate(ref string value)
        {
            return getStringValueFromElement(PatientBirthDate, ref value);
        }

        /// <summary>
        /// get patient's sex.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getPatientSex(ref string value)
        {
            return getStringValueFromElement(PatientSex, ref value);
        }

        /// <summary>
        /// get referring physicians name.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getReferringPhysicianName(ref string value)
        {
            return getStringValueFromElement(ReferringPhysicianName, ref value);
        }

        /// <summary>
        /// get study description.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getStudyDescription(ref string value)
        {
            return getStringValueFromElement(StudyDescription, ref value);
        }

        /// <summary>
        /// get series description.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getSeriesDescription(ref string value)
        {
            return getStringValueFromElement(SeriesDescription, ref value);
        }

        /// <summary>
        /// get manufacturer.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getManufacturer(ref string value)
        {
            return getStringValueFromElement(Manufacturer, ref value);
        }

        /// <summary>
        /// get manufacturer's model name.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getManufacturerModelName(ref string value)
        {
            return getStringValueFromElement(ManufacturerModelName, ref value);
        }

        /// <summary>
        /// get device serial number.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getDeviceSerialNumber(ref string value)
        {
            return getStringValueFromElement(DeviceSerialNumber, ref value);
        }

        /// <summary>
        /// get software version(s).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getSoftwareVersions(ref string value)
        {
            return getStringValueFromElement(SoftwareVersions, ref value);
        }

        /// <summary>
        /// get study date.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getStudyDate(ref string value)
        {
            return getStringValueFromElement(StudyDate, ref value);
        }

        /// <summary>
        /// get study time.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getStudyTime(ref string value)
        {
            return getStringValueFromElement(StudyTime, ref value);
        }

        /// <summary>
        /// get instance creation date.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getInstanceCreationDate(ref string value)
        {
            return getStringValueFromElement(InstanceCreationDate, ref value);
        }

        /// <summary>
        /// get instance creation time.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getInstanceCreationTime(ref string value)
        {
            return getStringValueFromElement(InstanceCreationTime, ref value);
        }

        /// <summary>
        /// get content date.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getContentDate(ref string value)
        {
            return getStringValueFromElement(ContentDate, ref value);
        }

        /// <summary>
        /// get content time.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getContentTime(ref string value)
        {
            return getStringValueFromElement(ContentTime, ref value);
        }

        /// <summary>
        /// get study ID.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getStudyID(ref string value)
        {
            return getStringValueFromElement(StudyID, ref value);
        }

        /// <summary>
        /// get patient ID.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getPatientID(ref string value)
        {
            return getStringValueFromElement(PatientID, ref value);
        }

        /// <summary>
        /// get series number.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getSeriesNumber(ref string value)
        {
            return getStringValueFromElement(SeriesNumber, ref value);
        }

        /// <summary>
        /// get instance number.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getInstanceNumber(ref string value)
        {
            return getStringValueFromElement(InstanceNumber, ref value);
        }

        /// <summary>
        /// get accession number.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> character string (might empty) </returns>
        public string getAccessionNumber(ref string value)
        {
            return getStringValueFromElement(AccessionNumber, ref value);
        }

        // --- set DICOM string attributes ---

        /// <summary>
        /// set specific character set. The passed string must be a valid DICOM Code String (CS). 
        /// The internal enumerated value is set accordingly.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setSpecificCharacterSet(string value)
        {
            SpecificCharacterSetEnum = definedTermToCharacterSet(value);
            /* might add check for correct format (VR) later on */
            SpecificCharacterSet.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set document preliminary flag. According to the DICOM standard, the concept of "completeness" is independent of the
        /// concept of "preliminary" or "final". Therefore, this flag can be specified separately.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition setPreliminaryFlag(E_PreliminaryFlag flag)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* not applicable to Key Object Selection Documents */
            if (getDocumentType() != E_DocumentType.DT_KeyObjectSelectionDocument)
            {
                PreliminaryFlagEnum = flag;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// <summary>
        /// set document completion flag description. The description can be removed from the DICOM dataset (type 3) by setting an empty
        /// string. Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition setCompletionFlagDescription(string value)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* not applicable to Key Object Selection Documents */
            if (getDocumentType() != E_DocumentType.DT_KeyObjectSelectionDocument)
            {
                if (string.IsNullOrEmpty(value))
                {
                    CompletionFlagDescription.SetEmptyValue();
                    result = E_Condition.EC_Normal;
                }
                else
                {
                    CompletionFlagDescription.SetStringValue(value);
                    result = E_Condition.EC_Normal;
                }
            }

            return result;
        }

        /// <summary>
        /// set patient's name. The passed string must be a valid DICOM Person Name (PN).
        /// </summary>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setPatientName(string value)
        {
            /* might add check for correct format (VR) later on */
            PatientName.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set patient's birth date. The passed string must be a valid DICOM Date (DA).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setPatientBirthDate(string value)
        {
            /* might add check for correct format (VR) later on */
            PatientBirthDate.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set patient's sex. The passed string must be a valid DICOM Code String (CS).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setPatientSex(string value)
        {
            /* might add check for correct format (VR) later on */
            PatientSex.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set referring physicians name. The passed string must be a valid DICOM Person Name (PN).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setReferringPhysicianName(string value)
        {
            /* might add check for correct format (VR) later on */
            ReferringPhysicianName.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set study description. The passed string must be a valid DICOM Long String (LO).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setStudyDescription(string value)
        {
            /* might add check for correct format (VR) later on */
            StudyDescription.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set series description. The passed string must be a valid DICOM Long String (LO).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setSeriesDescription(string value)
        {
            /* might add check for correct format (VR) later on */
            SeriesDescription.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set manufacturer. The passed string must be a valid DICOM Long String (LO).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setManufacturer(string value)
        {
            /* might add check for correct format (VR) later on */
            Manufacturer.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set  manufacturer's model name. The passed string must be a valid DICOM Long String (LO).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setManufacturerModelName(string value)
        {
            /* might add check for correct format (VR) later on */
            ManufacturerModelName.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set device serial number. The passed string must be a valid DICOM Long String (LO).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setDeviceSerialNumber(string value)
        {
            /* might add check for correct format (VR) later on */
            DeviceSerialNumber.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set software version(s). The passed string must be a valid DICOM Long String (LO).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setSoftwareVersions(string value)
        {
            /* might add check for correct format (VR) later on */
            SoftwareVersions.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set content date. The passed string must be a valid DICOM Date (DA). 
        /// If an empty string is passed the current time is set when displaying or writing the document
        /// since the corresponding DICOM attribute is type 1 (= mandatory).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setContentDate(string value)
        {
            /* might add check for correct format (VR) later on */
            ContentDate.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set content time. The passed string must be a valid DICOM Time (TM). 
        /// If an empty string is passed the current time is set when displaying or writing the document
        /// since the corresponding DICOM attribute is type 1 (= mandatory).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setContentTime(string value)
        {
            /* might add check for correct format (VR) later on */
            ContentTime.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set study ID. The passed string must be a valid DICOM Short String (SH).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setStudyID(string value)
        {
            /* might add check for correct format (VR) later on */
            StudyID.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set patient ID. The passed string must be a valid DICOM Long String (LO).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setPatientID(string value)
        {
            /* might add check for correct format (VR) later on */
            PatientID.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set series number. The passed string must be a valid DICOM Short String (SH).
        /// If an empty string is passed the value "1" is set when displaying or writing the
        /// document since the corresponding DICOM attribute is type 1 (= mandatory).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setSeriesNumber(string value)
        {
            /* might add check for correct format (VR) later on */
            SeriesNumber.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set instance number. The passed string must be a valid DICOM Integer String (IS). 
        /// If an empty string is passed the value "1" is set when displaying or writing the
        /// document since the corresponding DICOM attribute is type 1 (= mandatory).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setInstanceNumber(string value)
        {
            /* might add check for correct format (VR) later on */
            InstanceNumber.SetStringValue(value);

            return true;
        }

        /// <summary>
        /// set accession number. The passed string must be a valid DICOM Short String (SH).
        /// </summary>
        /// <param name="value"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public bool setAccessionNumber(string value)
        {
            /* might add check for correct format (VR) later on */
            AccessionNumber.SetStringValue(value);

            return true;
        }

        // --- document management functions ---

        /// <summary>
        /// create new study. After generating a new study instance UID the method createNewSeries() is called,
        /// i.e. also a new series instance UID and SOP instance UID are generated. This is a requirement of the DICOM standard.
        /// </summary>
        public void createNewStudy()
        {
            StudyInstanceUID.SetEmptyValue();
            /* also creates new study (since UID is empty) and SOP instance */
            createNewSeries();
        }

        /// <summary>
        /// create a new series. After generating a new series instance UID the method createNewSOPInstance() is
        /// called, i.e. also a SOP instance UID is generated. This is a requirement of the DICOM standard.
        /// </summary>
        public void createNewSeries()
        {
            SeriesInstanceUID.SetEmptyValue();
            /* also creates new series (since UID is empty) */
            createNewSOPInstance();
        }

        /// <summary>
        /// create a new series within a given study. After generating a new series instance UID within the given study the method
        /// createNewSOPInstance() is called, i.e. also a SOP instance UID is generated. This is a requirement of the DICOM standard.
        /// </summary>
        /// <param name="studyUID"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition createNewSeriesInStudy(ref string studyUID)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            if (!string.IsNullOrEmpty(studyUID))
            {
                StudyInstanceUID.SetStringValue(studyUID);
                /* also creates new SOP instance */
                createNewSeries();
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// <summary>
        /// create a new SOP instance. Generate a new SOP instance UID, set the instance creation date/time and reset the finalized flag (OFFalse).
        /// This method is used internally for createNewDocument(), createRevisedVersion() and during object initialization.
        /// It could also be used explicitly from the calling application if a new UID should be created (this is the case 
        /// if the study instance UID or series instance UID has changed as well as any other attribute within the SR Document General Module or
        /// SR Document Content Module, see DICOM standard for details). This method also updates the other DICOM header attributes (calling updateAttributes()).
        /// </summary>
        public void createNewSOPInstance()
        {
            SOPInstanceUID.SetEmptyValue();
            /* reset FinalizedFlag */
            FinalizedFlag = false;
            /* update all DICOM attributes (incl. empty UIDs) */
            updateAttributes();
        }

        /// <summary>
        /// create a new document. A new SOP instance is only created if the current document type was valid/supported.
        /// Please note that the current document is deleted (cleared).
        /// </summary>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition createNewDocument()
        {
            /* create new document with the same type as the current one */
            return createNewDocument(getDocumentType());
        }

        /// <summary>
        /// create a new document of the specified type. A new SOP instance is only created if the current document type was valid/supported.
        /// Please note that the current document is deleted by this method.
        /// </summary>
        /// <param name="documentType"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition createNewDocument(E_DocumentType documentType)
        {
            /* document type is stored only once (namely in the document tree) */
            E_Condition result = DocumentTree.changeDocumentType(documentType);
            if (result.good())
            {
                /* clear object (all member variables) */
                Clear();
                /* set initial values for a new SOP instance */
                createNewSOPInstance();
            }
            return result;
        }

        /// <summary>
        /// create a revised version of the current document. A revised version can only be created if the current document is already completed
        /// (see completion flag).  If so, a reference to the current document is added to the
        /// predecessor documents sequence.  If all revised versions of a SR document are
        /// stored (written to datasets/files) it is possible to trace back the full chain of previous versions.
        /// A new SOP instance is created and the content date/time are set automatically.
        /// Furthermore, the verifying observer and identical documents sequence are deleted,
        /// the verification flag is set to UNVERIFIED, the completion flag is set to PARTIAL (i.e. not complete),
        /// the completion flag description is deleted, all digital signatures contained in the document tree are deleted 
        /// and the finalized flag is reset (OFFalse).  The preliminary flag is not modified by this method. Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <param name="clearList"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition createRevisedVersion(bool clearList = true)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* not applicable to Key Object Selection Documents */
            if (getDocumentType() != E_DocumentType.DT_KeyObjectSelectionDocument)
            {
                /* check whether document is already completed */
                if (CompletionFlagEnum == E_CompletionFlag.CF_Complete)
                {
                    if (clearList)
                        PredecessorDocuments.clear();
                    /* add current document */
                    result = PredecessorDocuments.addItem(getStringValueFromElement(StudyInstanceUID),
                                                          getStringValueFromElement(SeriesInstanceUID),
                                                          getStringValueFromElement(SOPClassUID),
                                                          getStringValueFromElement(SOPInstanceUID));
                    if (result.good())
                    {
                        IdenticalDocuments.clear();
                        /* set completion flag to PARTIAL, delete description */
                        CompletionFlagEnum = E_CompletionFlag.CF_Partial;
                        CompletionFlagDescription.SetEmptyValue();
                        /* clear content date/time, will be set automatically in updateAttributes() */
                        ContentDate.SetEmptyValue();
                        ContentTime.SetEmptyValue();
                        /* clear list of verifying observers and set flag to UNVERIFIED */
                        removeVerification();
                        /* remove digital signatures from document tree */
                        DocumentTree.removeSignatures();
                        /* create new instance UID, update creation date/time and reset finalized flag */
                        createNewSOPInstance();
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// complete the current document. Sets the completion flag to COMPLETE if not already done (fails otherwise).
        /// The completion flag description is set to an empty string (i.e. absent in DICOM dataset).
        /// Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition completeDocument()
        {
            /* complete document with empty/absent completion description */
            return completeDocument("");
        }

        /// <summary>
        /// complete the current document and set a completion description. Sets the completion flag to COMPLETE if not already done (fails otherwise).
        /// The completion flag description can be modified independently from the flag by means of the method setCompletionFlagDescription() - see above
        /// Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <param name="description"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition completeDocument(string description)
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* not applicable to Key Object Selection Documents */
            if (getDocumentType() != E_DocumentType.DT_KeyObjectSelectionDocument)
            {
                /* if document is not already completed */
                if (CompletionFlagEnum != E_CompletionFlag.CF_Complete)
                {
                    /* completed for now and ever */
                    CompletionFlagEnum = E_CompletionFlag.CF_Complete;
                    /* completion flag description */
                    setCompletionFlagDescription(description);
                    result = E_Condition.EC_Normal;
                }
            }
            return result;
        }

        /// <summary>
        /// verify the current document by a specific observer. A document can be verified more than once.  The observer information is added to a
        /// sequence stored in the dataset.  The verification flag is automatically set to
        /// VERIFIED (if not already done) and the finalized flag is reset (set to OFFalse).
        /// Please note that only completed documents (see completion flag) can be verified and that
        /// a new SOP instance UID has to be generated (manually) according to the DICOM standard when creating a dataset/file from this document.
        /// Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <param name="observerName"></param>
        /// <param name="organization"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition verifyDocument(ref string observerName, ref string organization)
        {
            /* empty CodedEntryValue and VerificationDateTime */
            DSRCodedEntryValue dummy = new DSRCodedEntryValue();
            return verifyDocument(observerName, ref dummy /*dummy*/, organization, "" /*dateTime*/);
        }

        /// <summary>
        /// verify the current document by a specific observer. Same as above but allows to specify the verification date time value.
        /// Only required since Sun CC 2.0.1 compiler does not support default parameter values for "complex types" like OFString. 
        /// Reports the error message: "Sorry not implemented" :-/
        /// </summary>
        /// <param name="observerName"></param>
        /// <param name="organization"></param>
        /// <param name="dateTime"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition verifyDocument(ref string observerName, ref string organization, ref string dateTime /*= ""*/)
        {
            /* empty CodedEntryValue */
            DSRCodedEntryValue dummy = new DSRCodedEntryValue();
            return verifyDocument(observerName, ref dummy /*dummy*/, organization, dateTime);
        }

        /// <summary>
        /// verify the current document by a specific observer. A document can be verified more than once.  The observer information is added to a
        /// sequence stored in the dataset.  The verification flag is automatically set to VERIFIED (if not already done) and the finalized flag is reset (set to OFFalse).
        /// Please note that only completed documents (see completion flag) can be verified and that
        /// a new SOP instance UID has to be generated (manually) according to the DICOM standard when creating a dataset/file from this document.
        /// Not applicable to Key Object Selection Documents.
        /// </summary>
        /// <param name="observerName"></param>
        /// <param name="observerCode"></param>
        /// <param name="organization"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition verifyDocument(string observerName, ref DSRCodedEntryValue observerCode, string organization)
        {
            /* empty VerificationDateTime */
            return verifyDocument(observerName, ref observerCode, organization, "" /*dateTime*/);
        }

        /** verify the current document by a specific observer.
         *  Same as above but allows to specify the verification date time value.
         *  Only required since Sun CC 2.0.1 compiler does not support default parameter values for
         *  "complex types" like OFString.  Reports the error message: "Sorry not implemented" :-/
         ** @param  observerName  name of the person who has verified this document (required, VR=PN)
         *  @param  observerCode  code identifying the verifying observer (optional, see previous method)
         *  @param  organization  name of the organization to which the observer belongs (required, VR=LO)
         *  @param  dateTime      verification date time (optional). If empty/absent the current date and
         *                        time are used.
         ** @return status, EC_Normal if successful, an error code otherwise
         */
        public E_Condition verifyDocument(string observerName, ref DSRCodedEntryValue observerCode,
                                   string organization, string dateTime /*= ""*/)
        {
            //TODO DSRDocumentTree: verifyDocument
            return E_Condition.EC_IllegalCall;
        }

        /// <summary>
        /// remove verification information.
        /// The list of verifying observers is cleared, the verification flag is set to UNVERIFIED and
        /// the finalized flag is reset (set to OFFalse).
        /// Normally, there should be no need to call this method.  On the other hand, it is useful to
        /// guarantee a consistent state when processing documents which have not been created with this module/toolkit.
        /// </summary>
        public void removeVerification()
        {
            /* clear list of verifying observers and set flag to UNVERIFIED */
            VerifyingObserver.SetEmptyValue();
            VerificationFlagEnum = E_VerificationFlag.VF_Unverified;
            /* reset FinalizedFlag */
            FinalizedFlag = false;
        }

        /// <summary>
        /// finalize the current state of the document. A new document is originally not finalized but can be finalized using this method.
        /// This internal flag is e.g. used to indicate whether the entire document is digitally signed
        /// and, therefore, each newly added verifying observer would corrupt all previous signatures.
        /// NB: A document needs to be completed first in order to be finalized.  Some of the above
        ///     document management functions do reset the flag (i.e. set the FinalizedFlag to OFFalse),
        ///     other methods (e.g. setXXX) do not change the flag though the state of the document is
        ///     not finalized any more after they have been called.
        /// Not applicable to Key Object Selection Documents since there's no completion flag in this
        /// type of SR document.  Please note that this method has nothing to do with the preliminary flag.
        /// </summary>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        public E_Condition finalizeDocument()
        {
            E_Condition result = E_Condition.EC_IllegalCall;
            /* document can only be finalized if it is already completed */
            if (CompletionFlagEnum == E_CompletionFlag.CF_Complete)
            {
                /* set FinalizedFlag */
                FinalizedFlag = true;
                result = E_Condition.EC_Normal;
            }
            return result;
        }

        /// <summary>
        /// read XML document header
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readXMLDocumentHeader(ref DSRXMLDocument doc, DSRXMLCursor cursor, int flags)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (doc.valid() && cursor.valid())
            {
                result = E_Condition.EC_Normal;
                /* iterate over all nodes */
                while (cursor.valid() && result.good())
                {
                    /* check for known element tags */
                    if (doc.matchNode(cursor, "charset"))
                    {
                        /* use "charset" to decode special characters (has to be at the beginning) */
                        if (!doc.encodingHandlerValid())
                        {
                            string tmpString = string.Empty;
                            /* check for known character set */
                            setSpecificCharacterSet(doc.getStringFromNodeContent(cursor, ref tmpString));
                            string encString = characterSetToXMLName(SpecificCharacterSetEnum);
                            if ((encString.CompareTo("?") == 0) || doc.setEncodingHandler(encString).bad())
                            {
                                //DCMSR_WARN("Character set '" << tmpString << "' not supported");
                            }
                        }
                        else
                        {
                            /* only one "charset" node allowed */
                            doc.printUnexpectedNodeWarning(cursor);
                        }
                    }
                    else if (doc.matchNode(cursor, "modality"))
                    {
                        string tmpString = string.Empty;
                        /* compare the XML node content */
                        if (doc.getStringFromNodeContent(cursor, ref tmpString) != documentTypeToModality(getDocumentType()))
                        {
                            //DCMSR_WARN("Invalid value for 'modality' ... ignoring");
                        }
                    }
                    else if (doc.matchNode(cursor, "referringphysician"))
                    {
                        /* goto sub-element "name" */
                        DSRXMLCursor childNode = doc.getNamedNode(cursor.getChild(), "name");
                        if (childNode.valid())
                        {
                            /* Referring Physician's Name */
                            string tmpString = string.Empty;
                            DSRPNameTreeNode.getValueFromXMLNodeContent(ref doc, childNode.getChild(), ref tmpString);
                            ReferringPhysicianName.SetStringValue(tmpString);
                        }
                    }
                    else if (doc.matchNode(cursor, "patient"))
                        result = readXMLPatientData(ref doc, cursor.getChild(), flags);
                    else if (doc.matchNode(cursor, "study"))
                        result = readXMLStudyData(ref doc, cursor, flags);
                    else if (doc.matchNode(cursor, "series"))
                        result = readXMLSeriesData(ref doc, cursor, flags);
                    else if (doc.matchNode(cursor, "instance"))
                        result = readXMLInstanceData(ref doc, cursor, flags);
                    else if (doc.matchNode(cursor, "coding"))
                    {
                        DSRXMLCursor childNode = cursor.getChild();
                        if (childNode.valid())
                            result = CodingSchemeIdentification.readXML(doc, childNode, flags);
                    }
                    else if (doc.matchNode(cursor, "evidence"))
                    {
                        string typeString = string.Empty;
                        /* check "type" attribute for corresponding sequence */
                        if (doc.getStringFromAttribute(cursor, ref typeString, "type") == "Current Requested Procedure")
                            result = CurrentRequestedProcedureEvidence.readXML(ref doc, cursor.getChild(), flags);
                        else if (typeString == "Pertinent Other")
                        {
                            if (getDocumentType() != E_DocumentType.DT_KeyObjectSelectionDocument)
                                result = PertinentOtherEvidence.readXML(ref doc, cursor.getChild(), flags);
                            else
                                doc.printUnexpectedNodeWarning(cursor);
                        }
                        else // none of the standard defined evidence types
                            printUnknownValueWarningMessage("Evidence type", typeString);
                    }
                    else if (doc.matchNode(cursor, "document"))
                        result = readXMLDocumentData(ref doc, cursor.getChild(), flags);
                    else if (doc.matchNode(cursor, "device"))
                    {
                        doc.getElementFromNodeContent(doc.getNamedNode(cursor.getChild(), "manufacturer"), ref Manufacturer, null, true /*encoding*/);
                        doc.getElementFromNodeContent(doc.getNamedNode(cursor.getChild(), "model"), ref ManufacturerModelName, null, true /*encoding*/);
                        doc.getElementFromNodeContent(doc.getNamedNode(cursor.getChild(), "serial", false /*required*/), ref DeviceSerialNumber, null, true /*encoding*/);
                        doc.getElementFromNodeContent(doc.getNamedNode(cursor.getChild(), "version", false /*required*/), ref SoftwareVersions, null, true /*encoding*/);
                    }
                    else if (doc.getElementFromNodeContent(cursor, ref Manufacturer, "manufacturer", true /*encoding*/).bad())
                        doc.printUnexpectedNodeWarning(cursor);
                    /* print node error message (if any) */
                    doc.printGeneralNodeError(cursor, ref result);
                    /* proceed with next node */
                    cursor.gotoNext();
                }
            }
            return result;
        }

        /// <summary>
        /// read XML "patient" data
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readXMLPatientData(ref DSRXMLDocument doc, DSRXMLCursor cursor, int flags)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (cursor.valid())
            {
                string tmpString = string.Empty;
                result = E_Condition.EC_Normal;
                /* iterate over all nodes */
                while (cursor.valid())
                {
                    /* check for known element tags (all type 2) */
                    if (doc.matchNode(cursor, "name"))
                    {
                        /* Patient's Name */
                        DSRPNameTreeNode.getValueFromXMLNodeContent(ref doc, cursor.getChild(), ref tmpString);
                        PatientName.SetStringValue(tmpString);
                    }
                    else if (doc.matchNode(cursor, "birthday"))
                    {
                        /* Patient's Birth Date */
                        DSRDateTreeNode.getValueFromXMLNodeContent(ref doc, doc.getNamedNode(cursor.getChild(), "date"), ref tmpString);
                        PatientBirthDate.SetStringValue(tmpString);
                    }
                    else if (doc.getElementFromNodeContent(cursor, ref PatientID, "id").bad() &&
                             doc.getElementFromNodeContent(cursor, ref PatientSex, "sex").bad())
                    {
                        doc.printUnexpectedNodeWarning(cursor);
                    }
                    /* proceed with next node */
                    cursor.gotoNext();
                }
            }
            return result;
        }

        /// <summary>
        /// read XML "study"data
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readXMLStudyData(ref DSRXMLDocument doc, DSRXMLCursor cursor, int flags)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (cursor.valid())
            {
                string tmpString = string.Empty;
                /* get Study Instance UID from XML attribute */
                result = doc.getElementFromAttribute(cursor, ref StudyInstanceUID, "uid");
                /* goto first sub-element */
                DSRXMLCursor childNode = cursor.getChild();
                /* iterate over all nodes */
                while (childNode.valid())
                {
                    /* check for known element tags */
                    if (doc.matchNode(childNode, "accession"))
                    {
                        /* goto sub-element "number" */
                        doc.getElementFromNodeContent(doc.getNamedNode(childNode.getChild(), "number"), ref AccessionNumber);
                    }
                    else if (doc.matchNode(childNode, "date"))
                    {
                        DSRDateTreeNode.getValueFromXMLNodeContent(ref doc, childNode, ref tmpString);
                        StudyDate.SetStringValue(tmpString);
                    }
                    else if (doc.matchNode(childNode, "time"))
                    {
                        DSRTimeTreeNode.getValueFromXMLNodeContent(ref doc, childNode, ref tmpString);
                        StudyTime.SetStringValue(tmpString);
                    }
                    else if (doc.getElementFromNodeContent(childNode, ref StudyID, "id").bad() &&
                             doc.getElementFromNodeContent(childNode, ref StudyDescription, "description", true /*encoding*/).bad())
                    {
                        doc.printUnexpectedNodeWarning(childNode);
                    }
                    /* proceed with next node */
                    childNode.gotoNext();
                }
                /* check required element values */
                checkElementValue(StudyInstanceUID, "1", "1");
            }
            return result;
        }

        /// <summary>
        /// read XML "series" data
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readXMLSeriesData(ref DSRXMLDocument doc, DSRXMLCursor cursor, int flags)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (cursor.valid())
            {
                /* get Series Instance UID from XML attribute */
                result = doc.getElementFromAttribute(cursor, ref SeriesInstanceUID, "uid");
                /* goto first sub-element */
                DSRXMLCursor childNode = cursor.getChild();
                /* iterate over all nodes */
                while (childNode.valid())
                {
                    /* check for known element tags */
                    if (doc.getElementFromNodeContent(childNode, ref SeriesNumber, "number").bad() &&
                        doc.getElementFromNodeContent(childNode, ref SeriesDescription, "description", true /*encoding*/).bad())
                    {
                        doc.printUnexpectedNodeWarning(childNode);
                    }
                    /* proceed with next node */
                    childNode.gotoNext();
                }
                /* check required element values */
                checkElementValue(SeriesInstanceUID, "1", "1");
                checkElementValue(SeriesNumber, "1", "1");
            }
            return result;
        }

        /// <summary>
        /// read XML "instance" data
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readXMLInstanceData(ref DSRXMLDocument doc, DSRXMLCursor cursor, int flags)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (cursor.valid())
            {
                string tmpString = string.Empty;
                /* get SOP Instance UID from XML attribute */
                result = doc.getElementFromAttribute(cursor, ref SOPInstanceUID, "uid");
                /* goto first sub-element */
                DSRXMLCursor childNode = cursor.getChild();
                /* iterate over all nodes */
                while (childNode.valid())
                {
                    /* check for known element tags */
                    if (doc.matchNode(childNode, "creation"))
                    {
                        /* Instance Creation Date */
                        DSRDateTreeNode.getValueFromXMLNodeContent(ref doc, doc.getNamedNode(childNode.getChild(), "date"), ref tmpString);
                        InstanceCreationDate.SetStringValue(tmpString);
                        /* Instance Creation Time */
                        DSRTimeTreeNode.getValueFromXMLNodeContent(ref doc, doc.getNamedNode(childNode.getNext(), "time"), ref tmpString);
                        InstanceCreationTime.SetStringValue(tmpString);
                    }
                    else if (doc.getElementFromNodeContent(childNode, ref InstanceNumber, "number").bad())
                        doc.printUnexpectedNodeWarning(childNode);
                    /* proceed with next node */
                    childNode.gotoNext();
                }
                /* check required element values */
                checkElementValue(SOPInstanceUID, "1", "1");
            }
            return result;
        }

        /// <summary>
        /// read XML "document" data
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readXMLDocumentData(ref DSRXMLDocument doc, DSRXMLCursor cursor, int flags)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (cursor.valid())
            {
                string tmpString = string.Empty;
                E_DocumentType documentType = getDocumentType();
                result = E_Condition.EC_Normal;
                /* iterate over all nodes */
                while (cursor.valid() && result.good())
                {
                    /* check for known element tags
                       (Key Object Selection Documents do not contain the SR Document General Module) */
                    if ((documentType != E_DocumentType.DT_KeyObjectSelectionDocument) && doc.matchNode(cursor, "preliminary"))
                    {
                        /* Preliminary Flag */
                        PreliminaryFlagEnum = enumeratedValueToPreliminaryFlag(doc.getStringFromAttribute(cursor, ref tmpString, "flag"));
                        if (PreliminaryFlagEnum == E_PreliminaryFlag.PF_invalid)
                            printUnknownValueWarningMessage("PreliminaryFlag", tmpString);
                    }
                    else if ((documentType != E_DocumentType.DT_KeyObjectSelectionDocument) && doc.matchNode(cursor, "completion"))
                    {
                        /* Completion Flag */
                        CompletionFlagEnum = enumeratedValueToCompletionFlag(doc.getStringFromAttribute(cursor, ref tmpString, "flag"));
                        if (CompletionFlagEnum != E_CompletionFlag.CF_invalid)
                        {
                            /* Completion Flag Description (optional) */
                            DSRXMLCursor childCursor = doc.getNamedNode(cursor.getChild(), "description", false /*required*/);
                            if (childCursor.valid())
                                doc.getElementFromNodeContent(childCursor, ref CompletionFlagDescription, null /*name*/, true /*encoding*/);
                        }
                        else
                            printUnknownValueWarningMessage("CompletionFlag", tmpString);
                    }
                    else if ((documentType != E_DocumentType.DT_KeyObjectSelectionDocument) && doc.matchNode(cursor, "verification"))
                    {
                        /* Verification Flag */
                        VerificationFlagEnum = enumeratedValueToVerificationFlag(doc.getStringFromAttribute(cursor, ref tmpString, "flag"));
                        if (VerificationFlagEnum != E_VerificationFlag.VF_invalid)
                        {
                            /* Verifying Observers (required if VERIFIED) */
                            result = readXMLVerifyingObserverData(ref doc, cursor, flags);
                            /* allow absence in case of UNVERIFIED */
                            if (VerificationFlagEnum == E_VerificationFlag.VF_Unverified)
                                result = E_Condition.EC_Normal;
                        }
                        else
                            printUnknownValueWarningMessage("VerificationFlag", tmpString);
                    }
                    else if ((documentType != E_DocumentType.DT_KeyObjectSelectionDocument) && doc.matchNode(cursor, "predecessor"))
                    {
                        /* Predecessor Documents Sequence (optional) */
                        result = PredecessorDocuments.readXML(ref doc, cursor.getChild(), flags);
                    }
                    else if (doc.matchNode(cursor, "identical"))
                    {
                        /* Identical Documents Sequence (optional) */
                        result = IdenticalDocuments.readXML(ref doc, cursor.getChild(), flags);
                    }
                    else if (doc.matchNode(cursor, "content"))
                    {
                        DSRXMLCursor childCursor = cursor.getChild();
                        /* Content Date */
                        DSRDateTreeNode.getValueFromXMLNodeContent(ref doc, doc.getNamedNode(childCursor, "date"), ref tmpString);
                        ContentDate.SetStringValue(tmpString);
                        /* Content Time */
                        DSRTimeTreeNode.getValueFromXMLNodeContent(ref doc, doc.getNamedNode(childCursor.gotoNext(), "time"), ref tmpString);
                        ContentTime.SetStringValue(tmpString);
                        /* proceed with document tree */
                        result = DocumentTree.readXML(ref doc, childCursor, flags);
                    }
                    else
                        doc.printUnexpectedNodeWarning(cursor);
                    /* print node error message (if any) */
                    doc.printGeneralNodeError(cursor, ref result);
                    /* proceed with next node */
                    cursor.gotoNext();
                }
            }
            return result;
        }

        /// <summary>
        /// read XML verifying observer data
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="cursor"></param>
        /// <param name="flags"></param>
        /// <returns> status, EC_Normal if successful, an error code otherwise </returns>
        protected E_Condition readXMLVerifyingObserverData(ref DSRXMLDocument doc, DSRXMLCursor cursor, int flags)
        {
            E_Condition result = E_Condition.SR_EC_InvalidDocument;
            if (cursor.valid())
            {
                result = E_Condition.EC_Normal;
                cursor = cursor.getChild();
                /* iterate over all nodes */
                while (cursor.valid())
                {
                    /* check for known element tags */
                    if (doc.matchNode(cursor, "observer"))
                    {
                        DicomAttributeCollection ditem = new DicomAttributeCollection();
                        if (ditem != null)
                        {
                            string datetimeString = string.Empty, nameString = string.Empty, orgaString = string.Empty;
                            DSRCodedEntryValue codeValue = new DSRCodedEntryValue();
                            DSRXMLCursor childCursor = cursor.getChild();
                            /* iterate over all child nodes */
                            while (childCursor.valid())
                            {
                                /* check for known element tags */
                                if (doc.matchNode(childCursor, "code"))
                                {
                                    /* Verifying Observer Code */
                                    codeValue.readXML(ref doc, childCursor);
                                }
                                else if (doc.matchNode(childCursor, "name"))
                                {
                                    /* Verifying Observer Name */
                                    DSRPNameTreeNode.getValueFromXMLNodeContent(ref doc, childCursor.getChild(), ref nameString);
                                }
                                else if (doc.matchNode(childCursor, "datetime"))
                                {
                                    /* Verification Datetime */
                                    DSRDateTimeTreeNode.getValueFromXMLNodeContent(ref doc, childCursor, ref datetimeString);
                                }
                                else
                                {
                                    /* Verifying Observer Organization */
                                    doc.getStringFromNodeContent(childCursor, ref orgaString, "organization", true /*encoding*/, false /*clearString*/);
                                }
                                /* proceed with next node */
                                childCursor.gotoNext();
                            }
                            /* put string values into the sequence item */
                            putStringValueToDataset(ditem, getDicomAttribute(DicomTags.VerificationDateTime), datetimeString);
                            putStringValueToDataset(ditem, getDicomAttribute(DicomTags.VerifyingObserverName), nameString);
                            putStringValueToDataset(ditem, getDicomAttribute(DicomTags.VerifyingOrganization), orgaString);
                            /* write code value to sequence item (might be empty, type 2) */

                            DicomAttribute _VerifyingObserverIdentificationCodeSequence = getDicomAttribute(DicomTags.VerifyingObserverIdentificationCodeSequence);

                            //TODO: readXMLVerifyingObserverData: Need to write the sequence
                            //codeValue.writeSequence(ref ditem, ref _VerifyingObserverIdentificationCodeSequence);
                            /* insert items into sequence */
                            //VerifyingObserver.AddSequenceItem(_VerifyingObserverIdentificationCodeSequence);
                        }
                    }
                    else
                        doc.printUnexpectedNodeWarning(cursor);
                    /* proceed with next node */
                    cursor.gotoNext();
                }
            }
            return result;
        }

        /// <summary>
        /// render patient name, sex, birthdate and ID in HTML/XHTML format
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="flags"></param>
        protected void renderHTMLPatientData(ref StringBuilder stream, int flags)
        {
            if (stream == null)
            {
                stream = new StringBuilder();
            }

            string tmpString = string.Empty, string2 = string.Empty;
            string htmlString = string.Empty;
            stream.Append(convertToHTMLString(dicomToReadablePersonName(getStringValueFromElement(PatientName, ref tmpString), string2), htmlString, flags));
            string patientStr = string.Empty;
            if (!string.IsNullOrEmpty(PatientSex))
            {
                getPrintStringFromElement(PatientSex, ref tmpString);
                if (tmpString == "M")
                    patientStr += "male";
                else if (tmpString == "F")
                    patientStr += "female";
                else if (tmpString == "O")
                    patientStr += "other";
                else
                    patientStr += convertToHTMLString(tmpString, htmlString, flags);
            }

            if (!string.IsNullOrEmpty(PatientBirthDate))
            {
                if (!string.IsNullOrEmpty(patientStr))
                    patientStr += ", ";
                patientStr += '*';
                patientStr += dicomToReadableDate(getStringValueFromElement(PatientBirthDate, ref tmpString), string2);
            }

            if (!string.IsNullOrEmpty(PatientID))
            {
                if (!string.IsNullOrEmpty(patientStr))
                    patientStr += ", ";
                patientStr += '#';
                patientStr += convertToHTMLString(getStringValueFromElement(PatientID, ref tmpString), htmlString, flags);
            }

            if (!string.IsNullOrEmpty(patientStr))
            {
                stream.Append(" (");
                stream.Append(patientStr);
                stream.Append(")");
            }
        }

        /// <summary>
        /// render list of referenced SOP instances in HTML/XHTML format
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="refList"></param>
        /// <param name="flags"></param>
        protected void renderHTMLReferenceList(ref StringBuilder stream, ref DSRSOPInstanceReferenceList refList, int flags)
        {
            /* goto first list item (if not empty) */
            if (refList.gotoFirstItem().good())
            {
                string tmpString = string.Empty;
                int i = 0;
                /* iterate over all list items */
                do
                {
                    if (i > 0)
                    {
                        stream.AppendLine("</tr>");
                        stream.AppendLine("<tr>");
                        stream.AppendLine("<td></td>");
                    }
                    /* hyperlink to composite object */
                    string sopClass = string.Empty, sopInstance = string.Empty;
                    if (!string.IsNullOrEmpty(refList.getSOPClassUID(ref sopClass)) && !string.IsNullOrEmpty(refList.getSOPInstanceUID(ref sopInstance)))
                    {
                        stream.Append("<td><a href=\"");
                        stream.Append("http://localhost/dicom.cgi");
                        stream.Append("?composite=");
                        stream.Append(sopClass);
                        stream.Append("+");
                        stream.Append(sopInstance);
                        stream.Append("\">");
                        stream.Append(documentTypeToDocumentTitle(sopClassUIDToDocumentType(sopClass), ref tmpString));
                        stream.Append("</a></td>");
                        stream.AppendLine();
                    }
                    else
                    {
                        stream.Append("<td><i>invalid document reference</i></td>");
                        stream.AppendLine();
                    }

                    i++;
                } while (refList.gotoNextItem().good());
            }
        }
    }
}
