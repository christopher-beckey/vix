// -----------------------------------------------------------------------
// <copyright file="ViewHealthSummaryListMessage.cs" company="Patriot Technologies">
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

    public static partial class AppMessages
    {
        /// <summary>
        /// TODO: Update summary.
        /// </summary>
        public static class ViewHealthSummaryListMessage
        {
            public class MessageData
            {
                public string SiteID { get; set; }

                public string SiteName { get; set; }

                public string PatientICN { get; set; }

                public string PatientID { get; set; }

                public string PatientName { get; set; }

                public bool Success { get; set; }
            }

            public static void Send(MessageData data)
            {
                Messenger.Default.Send(data, MessageTypes.ViewHealthSummaryList);
            }

            public static void Register(object recipient, Action<MessageData> action)
            {
                Messenger.Default.Register(recipient, MessageTypes.ViewHealthSummaryList, action);
            }
        }
    }
}
