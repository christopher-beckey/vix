#region License

// Copyright (c) 2013, ClearCanvas Inc.
// All rights reserved.
// http://www.clearcanvas.ca
//
// This file is part of the ClearCanvas RIS/PACS open source project.
//
// The ClearCanvas RIS/PACS open source project is free software: you can
// redistribute it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// The ClearCanvas RIS/PACS open source project is distributed in the hope that it
// will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
// Public License for more details.
//
// You should have received a copy of the GNU General Public License along with
// the ClearCanvas RIS/PACS open source project.  If not, see
// <http://www.gnu.org/licenses/>.

#endregion

using System;
using System.Collections.Generic;
using System.Text;

namespace ClearCanvas.Dicom.Network
{
    /// <summary>
    /// Enumerated value representing classes of DICOM status codes.
    /// </summary>
    public enum DicomState
    {
        Success,
        Cancel,
        Pending,
        Warning,
        Failure
    }

    /// <summary>
    /// Representation of a DICOM Status code set in a DICOM response message.
    /// </summary>
    public class DicomStatus
    {
        public readonly ushort Code;
        public readonly ushort Mask;
        public readonly DicomState Status;
        public readonly string Description;

        /// <summary>
        /// Construcotr.
        /// </summary>
        /// <param name="code">The hex value of the code.</param>
        /// <param name="status">The type of the code</param>
        /// <param name="desc">The description of the code.</param>
        public DicomStatus(string code, DicomState status, string desc)
        {
            Code = ushort.Parse(code.Replace('x', '0'), System.Globalization.NumberStyles.HexNumber, System.Globalization.CultureInfo.InvariantCulture);

            StringBuilder msb = new StringBuilder();
            msb.Append(code.ToLower());
            msb.Replace('0', 'F').Replace('1', 'F').Replace('2', 'F')
                .Replace('3', 'F').Replace('4', 'F').Replace('5', 'F')
                .Replace('6', 'F').Replace('7', 'F').Replace('8', 'F')
                .Replace('9', 'F').Replace('a', 'F').Replace('b', 'F')
                .Replace('c', 'F').Replace('d', 'F').Replace('e', 'F')
                .Replace('x', '0');
			Mask = ushort.Parse(msb.ToString(), System.Globalization.NumberStyles.HexNumber, System.Globalization.CultureInfo.InvariantCulture);

            Status = status;
            Description = desc;
        }

        public override string ToString()
        {
            if (Status == DicomState.Warning || Status == DicomState.Failure)
            {
                return String.Format("{0}: {1}", Status, Description);
            }
            return Description;
        }

        public static bool operator ==(DicomStatus s1, DicomStatus s2)
        {
            if ((object)s1 == null || (object)s2 == null)
                return false;
            return (s1.Code & s2.Mask) == (s2.Code & s1.Mask);
        }
        public static bool operator !=(DicomStatus s1, DicomStatus s2)
        {
            if ((object)s1 == null || (object)s2 == null)
                return false;
            return !(s1 == s2);
        }
        public override bool Equals(object obj)
        {
            return (DicomStatus)obj == this;
        }
        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
    }

    /// <summary>
    /// Lookup table of DICOM status values.
    /// </summary>
    public static class DicomStatuses
    {
        public static List<DicomStatus> GenericEntries = new List<DicomStatus>();
        public static List<DicomStatus> StorageEntries = new List<DicomStatus>();
        public static List<DicomStatus> QueryRetrieveEntries = new List<DicomStatus>();
        public static List<DicomStatus> PrintEntries = new List<DicomStatus>();
        public static List<DicomStatus> MediaEntries = new List<DicomStatus>();

        static DicomStatuses()
        {
            #region Load Dicom Status List
            GenericEntries.Add(Success);
            GenericEntries.Add(Cancel);
            GenericEntries.Add(Pending);
            GenericEntries.Add(AttributeListError);
            GenericEntries.Add(AttributeValueOutOfRange);
            GenericEntries.Add(SOPClassNotSupported);
            GenericEntries.Add(ClassInstanceConflict);
            GenericEntries.Add(DuplicateSOPInstance);
            GenericEntries.Add(DuplicateInvocation);
            GenericEntries.Add(InvalidArgumentValue);
            GenericEntries.Add(InvalidAttributeValue);
            GenericEntries.Add(InvalidObjectInstance);
            GenericEntries.Add(MissingAttribute);
            GenericEntries.Add(MissingAttributeValue);
            GenericEntries.Add(MistypedArgument);
            GenericEntries.Add(NoSuchArgument);
            GenericEntries.Add(NoSuchEventType);
            GenericEntries.Add(NoSuchObjectInstance);
            GenericEntries.Add(NoSuchSOPClass);
            GenericEntries.Add(ProcessingFailure);
            GenericEntries.Add(ResourceLimitation);
            GenericEntries.Add(UnrecognizedOperation);
            GenericEntries.Add(NoSuchActionType);
            StorageEntries.Add(StorageStorageOutOfResources);
            StorageEntries.Add(StorageDataSetDoesNotMatchSOPClassError);
            StorageEntries.Add(StorageCannotUnderstand);
            StorageEntries.Add(StorageCoercionOfDataElements);
            StorageEntries.Add(StorageDataSetDoesNotMatchSOPClassWarning);
            StorageEntries.Add(StorageElementsDiscarded);
            QueryRetrieveEntries.Add(QueryRetrieveOutOfResources);
            QueryRetrieveEntries.Add(QueryRetrieveUnableToCalculateNumberOfMatches);
            QueryRetrieveEntries.Add(QueryRetrieveUnableToPerformSuboperations);
            QueryRetrieveEntries.Add(QueryRetrieveMoveDestinationUnknown);
            QueryRetrieveEntries.Add(QueryRetrieveIdentifierDoesNotMatchSOPClass);
            QueryRetrieveEntries.Add(QueryRetrieveUnableToProcess);
            QueryRetrieveEntries.Add(QueryRetrieveOptionalKeysNotSupported);
            QueryRetrieveEntries.Add(QueryRetrieveSubOpsOneOrMoreFailures);
            PrintEntries.Add(PrintManagementMemoryAllocationNotSupported);
            PrintEntries.Add(PrintManagementFilmSessionPrintingNotSupported);
            PrintEntries.Add(PrintManagementFilmSessionEmptyPage);
            PrintEntries.Add(PrintManagementFilmBoxEmptyPage);
            PrintEntries.Add(PrintManagementImageDemagnified);
            PrintEntries.Add(PrintManagementMinMaxDensityOutOfRange);
            PrintEntries.Add(PrintManagementImageCropped);
            PrintEntries.Add(PrintManagementImageDecimated);
            PrintEntries.Add(PrintManagementFilmSessionEmpty);
            PrintEntries.Add(PrintManagementPrintQueueFull);
            PrintEntries.Add(PrintManagementImageLargerThanImageBox);
            PrintEntries.Add(PrintManagementInsufficientMemoryInPrinter);
            PrintEntries.Add(PrintManagementCombinedImageLargerThanImageBox);
            PrintEntries.Add(PrintManagementExistingFilmBoxNotPrinted);
            MediaEntries.Add(MediaCreationManagementDuplicateInitiateMediaCreation);
            MediaEntries.Add(MediaCreationManagementMediaCreationRequestAlreadyCompleted);
            MediaEntries.Add(MediaCreationManagementMediaCreationRequestAlreadyInProgress);
            MediaEntries.Add(MediaCreationManagementCancellationDeniedForUnspecifiedReason);
            #endregion
        }

        public static DicomStatus Lookup(ushort code)
        {
            foreach (DicomStatus status in GenericEntries)
            {
                if (status.Code == (code & status.Mask))
                    return status;
            }
            foreach (DicomStatus status in StorageEntries)
            {
                if (status.Code == (code & status.Mask))
                    return status;
            }
            foreach (DicomStatus status in QueryRetrieveEntries)
            {
                if (status.Code == (code & status.Mask))
                    return status;
            }
            foreach (DicomStatus status in PrintEntries)
            {
                if (status.Code == (code & status.Mask))
                    return status;
            }
            foreach (DicomStatus status in MediaEntries)
            {
                if (status.Code == (code & status.Mask))
                    return status;
            }

            return ProcessingFailure;
        }

        public static DicomStatus LookupQueryRetrieve(ushort code)
        {
            foreach (DicomStatus status in QueryRetrieveEntries)
            {
                if (status.Code == (code & status.Mask))
                    return status;
            } 
            foreach (DicomStatus status in GenericEntries)
            {
                if (status.Code == (code & status.Mask))
                    return status;
            }            
            return ProcessingFailure;
        }

        #region Dicom Statuses
        /// <summary>Success: Success</summary>
        public static DicomStatus Success = new DicomStatus("0000", DicomState.Success, "Success");

        /// <summary>Cancel: Cancel</summary>
        public static DicomStatus Cancel = new DicomStatus("FE00", DicomState.Cancel, "Cancel");

        /// <summary>Pending: Pending</summary>
        public static DicomStatus Pending = new DicomStatus("FF00", DicomState.Pending, "Pending");

        /// <summary>Warning: Attribute list error</summary>
        public static DicomStatus AttributeListError = new DicomStatus("0107", DicomState.Warning, "Attribute list error");

        /// <summary>Warning: Attribute Value Out of Range</summary>
        public static DicomStatus AttributeValueOutOfRange = new DicomStatus("0116", DicomState.Warning, "Attribute Value Out of Range");

        /// <summary>Failure: Refused: SOP class not supported</summary>
        public static DicomStatus SOPClassNotSupported = new DicomStatus("0122", DicomState.Failure, "Refused: SOP class not supported");

        /// <summary>Failure: Class-instance conflict</summary>
        public static DicomStatus ClassInstanceConflict = new DicomStatus("0119", DicomState.Failure, "Class-instance conflict");

        /// <summary>Failure: Duplicate SOP instance</summary>
        public static DicomStatus DuplicateSOPInstance = new DicomStatus("0111", DicomState.Failure, SR.DuplicateSOPInstance);

        /// <summary>Failure: Duplicate invocation</summary>
        public static DicomStatus DuplicateInvocation = new DicomStatus("0210", DicomState.Failure, "Duplicate invocation");

        /// <summary>Failure: Invalid argument value</summary>
        public static DicomStatus InvalidArgumentValue = new DicomStatus("0115", DicomState.Failure, "Invalid argument value");

        /// <summary>Failure: Invalid attribute value</summary>
        public static DicomStatus InvalidAttributeValue = new DicomStatus("0106", DicomState.Failure, "Invalid attribute value");

        /// <summary>Failure: Invalid object instance</summary>
        public static DicomStatus InvalidObjectInstance = new DicomStatus("0117", DicomState.Failure, "Invalid object instance");

        /// <summary>Failure: Missing attribute</summary>
        public static DicomStatus MissingAttribute = new DicomStatus("0120", DicomState.Failure, SR.MissingAttribute);

        /// <summary>Failure: Missing attribute value</summary>
        public static DicomStatus MissingAttributeValue = new DicomStatus("0121", DicomState.Failure, "Missing attribute value");

        /// <summary>Failure: Mistyped argument</summary>
        public static DicomStatus MistypedArgument = new DicomStatus("0212", DicomState.Failure, "Mistyped argument");

        /// <summary>Failure: No such argument</summary>
        public static DicomStatus NoSuchArgument = new DicomStatus("0114", DicomState.Failure, "No such argument");

        /// <summary>Failure: No such event type</summary>
        public static DicomStatus NoSuchEventType = new DicomStatus("0113", DicomState.Failure, "No such event type");

        /// <summary>Failure: No Such object instance</summary>
        public static DicomStatus NoSuchObjectInstance = new DicomStatus("0112", DicomState.Failure, "No Such object instance");

        /// <summary>Failure: No Such SOP class</summary>
        public static DicomStatus NoSuchSOPClass = new DicomStatus("0118", DicomState.Failure, "No Such SOP class");

        /// <summary>Failure: Processing failure</summary>
        public static DicomStatus ProcessingFailure = new DicomStatus("0110", DicomState.Failure, SR.ProcessingFailure);

        /// <summary>Failure: Resource limitation</summary>
        public static DicomStatus ResourceLimitation = new DicomStatus("0213", DicomState.Failure, "Resource limitation");

        /// <summary>Failure: Unrecognized operation</summary>
        public static DicomStatus UnrecognizedOperation = new DicomStatus("0211", DicomState.Failure, "Unrecognized operation");

        /// <summary>Failure: No such action type</summary>
        public static DicomStatus NoSuchActionType = new DicomStatus("0123", DicomState.Failure, "No such action type");

        /// <summary>Storage Failure: Out of Resources</summary>
        public static DicomStatus StorageStorageOutOfResources = new DicomStatus("A7xx", DicomState.Failure, SR.OutOfResources);

        /// <summary>Storage Failure: Data Set does not match SOP Class (Error)</summary>
        public static DicomStatus StorageDataSetDoesNotMatchSOPClassError = new DicomStatus("A9xx", DicomState.Failure, "Data Set does not match SOP Class (Error)");

        /// <summary>Storage Failure: Cannot understand</summary>
        public static DicomStatus StorageCannotUnderstand = new DicomStatus("Cxxx", DicomState.Failure, SR.CannotUnderstand);

        /// <summary>Storage Warning: Coercion of Data Elements</summary>
        public static DicomStatus StorageCoercionOfDataElements = new DicomStatus("B000", DicomState.Warning, "Coercion of Data Elements");

        /// <summary>Storage Warning: Data Set does not match SOP Class (Warning)</summary>
        public static DicomStatus StorageDataSetDoesNotMatchSOPClassWarning = new DicomStatus("B007", DicomState.Warning, "Data Set does not match SOP Class (Warning)");

        /// <summary>Storage Warning: Elements Discarded</summary>
        public static DicomStatus StorageElementsDiscarded = new DicomStatus("B006", DicomState.Warning, "Elements Discarded");

        /// <summary>QueryRetrieve Failure: Out of Resources</summary>
        public static DicomStatus QueryRetrieveOutOfResources = new DicomStatus("A700", DicomState.Failure, SR.OutOfResources);

        /// <summary>QueryRetrieve Failure: Unable to calculate number of matches</summary>
        public static DicomStatus QueryRetrieveUnableToCalculateNumberOfMatches = new DicomStatus("A701", DicomState.Failure, "Unable to calculate number of matches");

        /// <summary>QueryRetrieve Failure: Unable to perform suboperations</summary>
        public static DicomStatus QueryRetrieveUnableToPerformSuboperations = new DicomStatus("A702", DicomState.Failure, "Unable to perform suboperations");

        /// <summary>QueryRetrieve Failure: Move Destination unknown</summary>
        public static DicomStatus QueryRetrieveMoveDestinationUnknown = new DicomStatus("A801", DicomState.Failure, SR.QueryRetrieveMoveDestinationUnknown);

        /// <summary>QueryRetrieve Failure: Identifier does not match SOP Class</summary>
        public static DicomStatus QueryRetrieveIdentifierDoesNotMatchSOPClass = new DicomStatus("A900", DicomState.Failure, "Identifier does not match SOP Class");

        /// <summary>QueryRetrieve Failure: Unable to process</summary>
        public static DicomStatus QueryRetrieveUnableToProcess = new DicomStatus("Cxxx", DicomState.Failure, SR.UnableToProcess);

        /// <summary>QueryRetrieve Pending: Optional Keys Not Supported</summary>
        public static DicomStatus QueryRetrieveOptionalKeysNotSupported = new DicomStatus("FF01", DicomState.Pending, "Optional Keys Not Supported");

        /// <summary>QueryRetrieve Warning: Sub-operations Complete - One or more Failures</summary>
        public static DicomStatus QueryRetrieveSubOpsOneOrMoreFailures = new DicomStatus("B000", DicomState.Warning, "Sub-operations Complete - One or more Failures");

        /// <summary>PrintManagement Warning: Memory allocation not supported</summary>
        public static DicomStatus PrintManagementMemoryAllocationNotSupported = new DicomStatus("B000", DicomState.Warning, "Memory allocation not supported");

        /// <summary>PrintManagement Warning: Film session printing (collation) is not supported</summary>
        public static DicomStatus PrintManagementFilmSessionPrintingNotSupported = new DicomStatus("B601", DicomState.Warning, "Film session printing (collation) is not supported");

        /// <summary>PrintManagement Warning: Film session SOP instance hierarchy does not contain image box SOP instances (empty page)</summary>
        public static DicomStatus PrintManagementFilmSessionEmptyPage = new DicomStatus("B602", DicomState.Warning, "Film session SOP instance hierarchy does not contain image box SOP instances (empty page)");

        /// <summary>PrintManagement Warning: Film box SOP instance hierarchy does not contain image box SOP instances (empty page)</summary>
        public static DicomStatus PrintManagementFilmBoxEmptyPage = new DicomStatus("B603", DicomState.Warning, "Film box SOP instance hierarchy does not contain image box SOP instances (empty page)");

        /// <summary>PrintManagement Warning: Image size is larger than image box size, the image has been demagnified</summary>
        public static DicomStatus PrintManagementImageDemagnified = new DicomStatus("B604", DicomState.Warning, "Image size is larger than image box size, the image has been demagnified");

        /// <summary>PrintManagement Warning: Requested min density or max density outside of printer's operating range</summary>
        public static DicomStatus PrintManagementMinMaxDensityOutOfRange = new DicomStatus("B605", DicomState.Warning, "Requested min density or max density outside of printer's operating range");

        /// <summary>PrintManagement Warning: Image size is larger than the image box size, the Image has been cropped to fit</summary>
        public static DicomStatus PrintManagementImageCropped = new DicomStatus("B609", DicomState.Warning, "Image size is larger than the image box size, the Image has been cropped to fit");

        /// <summary>PrintManagement Warning: Image size or combined print image size is larger than the image box size, image or combined print image has been decimated to fit</summary>
        public static DicomStatus PrintManagementImageDecimated = new DicomStatus("B60A", DicomState.Warning, "Image size or combined print image size is larger than the image box size, image or combined print image has been decimated to fit");

        /// <summary>PrintManagement Failure: Film session SOP instance hierarchy does not contain film box SOP instances</summary>
        public static DicomStatus PrintManagementFilmSessionEmpty = new DicomStatus("C600", DicomState.Failure, "Film session SOP instance hierarchy does not contain film box SOP instances");

        /// <summary>PrintManagement Failure: Unable to create Print Job SOP Instance; print queue is full</summary>
        public static DicomStatus PrintManagementPrintQueueFull = new DicomStatus("C601", DicomState.Failure, "Unable to create Print Job SOP Instance; print queue is full");

        /// <summary>PrintManagement Failure: Image size is larger than image box size</summary>
        public static DicomStatus PrintManagementImageLargerThanImageBox = new DicomStatus("C603", DicomState.Failure, "Image size is larger than image box size");

        /// <summary>PrintManagement Failure: Insufficient memory in printer to store the image</summary>
        public static DicomStatus PrintManagementInsufficientMemoryInPrinter = new DicomStatus("C605", DicomState.Failure, "Insufficient memory in printer to store the image");

        /// <summary>PrintManagement Failure: Combined Print Image size is larger than the Image Box size</summary>
        public static DicomStatus PrintManagementCombinedImageLargerThanImageBox = new DicomStatus("C613", DicomState.Failure, "Combined Print Image size is larger than the Image Box size");

        /// <summary>PrintManagement Failure: There is an existing film box that has not been printed and N-ACTION at the Film Session level is not supported.</summary>
        public static DicomStatus PrintManagementExistingFilmBoxNotPrinted = new DicomStatus("C616", DicomState.Failure, "There is an existing film box that has not been printed and N-ACTION at the Film Session level is not supported.");

        /// <summary>MediaCreationManagement Failure: Refused because an Initiate Media Creation action has already been received for this SOP Instance</summary>
        public static DicomStatus MediaCreationManagementDuplicateInitiateMediaCreation = new DicomStatus("A510", DicomState.Failure, "Refused because an Initiate Media Creation action has already been received for this SOP Instance");

        /// <summary>MediaCreationManagement Failure: Media creation request already completed</summary>
        public static DicomStatus MediaCreationManagementMediaCreationRequestAlreadyCompleted = new DicomStatus("C201", DicomState.Failure, "Media creation request already completed");

        /// <summary>MediaCreationManagement Failure: Media creation request already in progress and cannot be interrupted</summary>
        public static DicomStatus MediaCreationManagementMediaCreationRequestAlreadyInProgress = new DicomStatus("C202", DicomState.Failure, "Media creation request already in progress and cannot be interrupted");

        /// <summary>MediaCreationManagement Failure: Cancellation denied for unspecified reason</summary>
        public static DicomStatus MediaCreationManagementCancellationDeniedForUnspecifiedReason = new DicomStatus("C203", DicomState.Failure, "Cancellation denied for unspecified reason");
        #endregion
    }
}
