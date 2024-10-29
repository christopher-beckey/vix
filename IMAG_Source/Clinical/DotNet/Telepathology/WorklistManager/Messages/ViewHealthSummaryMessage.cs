// -----------------------------------------------------------------------
// <copyright file="ViewHealthSummaryMessage.cs" company="Patriot Technologies">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Worklist.Messages
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using GalaSoft.MvvmLight.Messaging;
    using VistA.Imaging.Telepathology.Common.Model;
    using System.Windows;

    public static partial class AppMessages
    {
        /// <summary>
        /// TODO: Update summary.
        /// </summary>
        public static class ViewHealthSummaryMessage
        {
            public class MessageData
            {
                public string PatientICN { get; set; }

                public string PatientID { get; set; }

                public string PatientName { get; set; }

                public string SiteName { get; set; }

                public string SiteCode { get; set; }

                public HealthSummaryType HealthSummaryType { get; set; }

                public Window Owner { get; set; }

                public bool Success { get; set; }
            }

            public static void Send(MessageData data)
            {
                Messenger.Default.Send(data, MessageTypes.ViewHealthSummary);
            }

            public static void Register(object recipient, Action<MessageData> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.ViewHealthSummary, action);
            }
        }
    }
}
