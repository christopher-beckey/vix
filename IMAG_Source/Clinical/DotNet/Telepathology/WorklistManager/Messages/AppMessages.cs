/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 1/9/2012
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Paul Pentapaty
 * Description: 
 * 
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *       
 * 
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GalaSoft.MvvmLight.Messaging;
using VistA.Imaging.Telepathology.Common.Model;
using GalaSoft.MvvmLight.Threading;
using VistA.Imaging.Telepathology.Worklist.ViewModel;
using System.Windows;

namespace VistA.Imaging.Telepathology.Worklist.Messages
{
    public static partial class AppMessages
    {
        public enum MessageTypes
        {
            /// <summary>
            /// Sent when active worklist filter has changed
            /// </summary>
            WorklistFilterChanged,

            /// <summary>
            /// Sent when global worklist filter list has changed
            /// </summary>
            WorklistFilterListChanged,

            WorklistFilterNew,
            PatientSelected,
            ActiveWorklistChanged,
            ActiveWorklistFilterEdit,
            //CaseSelected,
            ViewConsultationStatus,
            EditConsultationStatus,

            EditReport,
            ViewReport,
            ViewSnapshots,

            ApplicationInitialized,
            ApplicationLogout,

            ViewHealthSummary,
            ViewHealthSummaryList,

            ViewNotes,

            UpdateStatuses
        }

        public static class WorklistFilterChangeMessage
        {
            public static void Send(WorkListFilter filter, object sender)
            {
                Messenger.Default.Send(new GenericMessage<WorkListFilter>(sender, filter), MessageTypes.WorklistFilterChanged);
            }

            public static void Register(object recipient, Action<GenericMessage<WorkListFilter>> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.WorklistFilterChanged, action);
            }
        }

        public static class ActiveWorklistFilterChangeMessage
        {
            public static void Send(WorklistViewModel view)
            {
                Messenger.Default.Send(view, MessageTypes.ActiveWorklistChanged);
            }

            public static void Register(object recipient, Action<WorklistViewModel> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.ActiveWorklistChanged, action);
            }
        }

        public static class ViewConsultationStatusMessage
        {
            public class MessageData
            {
                public CaseListItem Item { get; set; }

                public WorklistViewModel Worklist { get; set; }

                public bool CancelConsultationRequest { get; set; }
            }

            public static void Send(MessageData data)
            {
                Messenger.Default.Send(data, MessageTypes.ViewConsultationStatus);
            }

            public static void Register(object recipient, Action<MessageData> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.ViewConsultationStatus, action);
            }
        }

        public static class EditConsultationStatusMessage
        {
            public class MessageData
            {
                public CaseListItem Item { get; set; }

                public ReadingSiteInfo ConsultingSite { get; set; }

                public string ConsultationID { get; set; }

                public bool CancelConsultationRequest { get; set; }

                public bool RefuseConsultationRequest { get; set; }

                public bool Success { get; set; }
            }

            public static void Send(MessageData data)
            {
                Messenger.Default.Send(data, MessageTypes.EditConsultationStatus);
            }

            public static void Register(object recipient, Action<MessageData> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.EditConsultationStatus, action);
            }
        }

        public static class PatientSelectedMessage
        {
            public static void Send(string patientICN, string patientID, object sender)
            {
                Messenger.Default.Send(new GenericMessage<Patient>(sender, new Patient { PatientICN = patientICN, PatientShortID = patientID}), MessageTypes.PatientSelected);
            }

            public static void Register(object recipient, Action<GenericMessage<Patient>> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.PatientSelected, action);
            }
        }

        public static class WorklistFilterListChangedMessage
        {
            public static void Send(WorkListFilter filter)
            {
                Messenger.Default.Send(filter, MessageTypes.WorklistFilterListChanged);
            }

            public static void Register(object recipient, Action<WorkListFilter> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.WorklistFilterListChanged, action);
            }
        }

        public static class WorklistFilterNewMessage
        {
            public static void Send(WorklistFilterEditSettingsViewModel worklistFilterEditSettingsViewModel)
            {
                Messenger.Default.Send(worklistFilterEditSettingsViewModel, MessageTypes.WorklistFilterNew);
            }

            public static void Register(object recipient, Action<WorklistFilterEditSettingsViewModel> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.WorklistFilterNew, action);
            }
        }

        public static class ActiveWorklistFilterEditMessage
        {
            public static bool Send(WorkListFilter filter)
            {
                bool result = false;

                var message = new GenericMessageAction<WorkListFilter, bool>(
                    filter,
                    callbackMessage =>
                    {
                        result = callbackMessage;
                    });

                Messenger.Default.Send(message, MessageTypes.ActiveWorklistFilterEdit);

                return result;
            }

            public static void Register(object recipient, Action<GenericMessageAction<WorkListFilter, bool>> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.ActiveWorklistFilterEdit, action);
            }
        }

        public static class EditReportMessage
        {
            public class MessageData
            {
                public CaseListItem Item { get; set; }

                public WorklistViewModel Worklist { get; set; }
            }

            public static void Send(MessageData data)
            {
                Messenger.Default.Send(data, MessageTypes.EditReport);
            }

            public static void Register(object recipient, Action<MessageData> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.EditReport, action);
            }
        }

        public static class ViewReportMessage
        {
            public static void Send(CaseListItem item)
            {
                Messenger.Default.Send(item, MessageTypes.ViewReport);
            }

            public static void Register(object recipient, Action<CaseListItem> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.ViewReport, action);
            }
        }

        public static class ViewSnapshotsMessage
        {
            public static void Send(CaseListItem item)
            {
                Messenger.Default.Send(item, MessageTypes.ViewSnapshots);
            }

            public static void Register(object recipient, Action<CaseListItem> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.ViewSnapshots, action);
            }
        }

        public static class ApplicationLogoutMessage
        {
            public static void Send()
            {
                Messenger.Default.Send(MessageTypes.ApplicationLogout, MessageTypes.ApplicationLogout);
            }

            public static void Register(object recipient, Action<MessageTypes> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.ApplicationLogout, action);
            }
        }

        public static class ApplicationInitializedMessage
        {
            public static void Send()
            {
                Messenger.Default.Send(MessageTypes.ApplicationInitialized, MessageTypes.ApplicationInitialized);
            }

            public static void Register(object recipient, Action<MessageTypes> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.ApplicationInitialized, action);
            }
        }

        public static class UpdateStatusesMessage
        {
            public class MessageData
            {
                public string GeneralStatus { get; set; }

                public string UnreadTime { get; set; }

                public string ReadTime { get; set; }
            }

            public static void Send(MessageData data)
            {
                Messenger.Default.Send(data, MessageTypes.UpdateStatuses);
            }

            public static void Register(object recipient, Action<MessageData> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.UpdateStatuses, action);
            }
        }
    }
}
