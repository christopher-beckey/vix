using Microsoft.AspNet.SignalR;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using Microsoft.AspNet.SignalR.Hubs;
using System.Collections.Concurrent;
using System.IO;

namespace Hydra.Web
{
    //VAI-307
    /// <summary>
    /// Called from client side in session.js to request the TIFF-PDF file
    /// </summary>
    [HubName("PdfRequestHub")]
    public class PdfRequestHub : Hub
    {
        private static ConcurrentDictionary<int, CancellationTokenSource> _pendingOperations = new ConcurrentDictionary<int, CancellationTokenSource>();
        private static int _operationId;
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        public int RequestPdfFile(string imageUid) 
        {
            int operationId = Interlocked.Increment(ref _operationId);
            var cts = new CancellationTokenSource();
            _pendingOperations.TryAdd(operationId, cts);
            buildPrintPdfs(operationId, cts, imageUid);
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Received RequestPdfFile.", "imageUid", imageUid); //VAI-1336
        
            return (operationId);
        }

        public void CancelOperation(int operationId)
        {
            CancellationTokenSource cts;
            if (_pendingOperations.TryGetValue(operationId, out cts))
            {
                cts.Cancel();
            }
        }
        //VAI-307
        /// <summary>
        /// Builds PDF file
        /// </summary>
        /// <returns>(VAI-307)</returns>
        public string BuildPdfFile(string imageUid)
        {
            var hixConnection = Hydra.IX.Client.HixConnectionFactory.Create();
            string pdfResult = hixConnection.RequestPdfBuild(imageUid);
            if (System.IO.File.Exists(pdfResult))
            {
                string pdfData = "/vix/files/" + pdfResult.Substring(pdfResult.IndexOf("pdffile")).Replace('\\', '/');
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("PDF built.", "pdfData", pdfData); //VAI-1336
                return (pdfData);// normal return point with pdf file
            }
            if (pdfResult.StartsWith("Error")) return (pdfResult); //or error message
            return (string.Empty);
        }
        private void buildPrintPdfs(int operationId, CancellationTokenSource cts, string imageUid)
        {
            CancellationTokenRegistration registration = cts.Token.Register(() => Clients.Caller.cancelled(operationId));
            string pdfFile = BuildPdfFile(imageUid);
            if (!cts.IsCancellationRequested)
            {
                Clients.Caller.complete(operationId, imageUid, pdfFile);
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("PDF build complete. OK."); //VAI-1336
            }
            else {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("PDF build cancelled."); //VAI-1336
            }
            registration.Dispose();
            _pendingOperations.TryRemove(operationId, out cts);
            cts.Dispose();
            return;
        }
    }

    public class SessionHub : Hub
    {
        public static Dictionary<string, TaskCompletionSource<object>> getResponseTasks = new Dictionary<string, TaskCompletionSource<object>>();

        public void Send(string name, string message) 
        { 
            Clients.All.broadcastMessage(name, message); 
        }

        public void SendViewerMessage(string errorCode, string descritpion)
        {
            Clients.All.viewerMessage(errorCode, descritpion);
        }

        public void SendQaMessage(dynamic message)
        {
            Clients.All.QaMessage(message);
        }

        public void setSessionIdleTime(string operationId, bool isValidSession, string idleTime, string[] contextIds)
        {
            TaskCompletionSource<object> toCall;
            dynamic response = new StatusResponse();
            response.IdleTime = isValidSession ? idleTime : "invalid";
            response.ContextIds = contextIds;

            if (getResponseTasks.TryGetValue(operationId, out toCall))
            {
                toCall.TrySetResult(response);
            }
        }
    }

    public class StatusResponse
    {
        public string IdleTime { get; set; }
        public string[] ContextIds { get; set; }
    }
}
