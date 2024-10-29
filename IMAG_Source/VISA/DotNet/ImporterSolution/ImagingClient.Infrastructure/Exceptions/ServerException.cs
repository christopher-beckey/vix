/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
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
 */
namespace ImagingClient.Infrastructure.Exceptions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Text;

    /// <summary>
    /// The server exception.
    /// </summary>
    public class ServerException : Exception
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ServerException"/> class.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="e">The e.</param>
        public ServerException(string message, Exception e) : base(message, e)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ServerException"/> class.
        /// </summary>
        /// <param name="message">
        /// The message.
        /// </param>
        /// <param name="errorCode">
        /// The error code.
        /// </param>
        /// <param name="serverStackTrace">
        /// The server stack trace.
        /// </param>
        /// <param name="transactionId">
        /// The transaction id.
        /// </param>
        private ServerException(string message, int errorCode, string serverStackTrace, string transactionId)
            : base(message)
        {
            this.ErrorCode = errorCode;
            this.ServerStackTrace = serverStackTrace;
            this.TransactionId = transactionId;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets ErrorCode.
        /// </summary>
        public int ErrorCode { get; set; }

        /// <summary>
        /// Gets or sets ServerStackTrace.
        /// </summary>
        public string ServerStackTrace { get; set; }

        /// <summary>
        /// Gets or sets TransactionId.
        /// </summary>
        public string TransactionId { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// The create server exception.
        /// </summary>
        /// <param name="responseMessage">
        /// The response message.
        /// </param>
        /// <param name="transactionId">
        /// The transaction id.
        /// </param>
        /// <returns>A server exception</returns>
        public static ServerException CreateServerException(HttpResponseMessage responseMessage, string transactionId)
        {
            string message = GetMessage(responseMessage);
            int errorCode = GetErrorCode(responseMessage);
            string serverStackTrace = responseMessage.Content.ReadAsString();
            return new ServerException(message, errorCode, serverStackTrace, transactionId);
        }

        /// <summary>
        /// Returns the error code from the HTTP header.
        /// </summary>
        /// <param name="responseMessage">
        /// The response message.
        /// </param>
        /// <returns>
        /// The error code.
        /// </returns>
        public static int GetErrorCode(HttpResponseMessage responseMessage)
        {
            // Default to the server header value.
            int errorCode = GetHeaderValueAsInt(responseMessage, "xxx-error-code");

            // If it's 0, default to 500 (internal server error)
            if (errorCode == 0)
            {
                errorCode = 500;
            }

            return errorCode;
        }

        /// <summary>
        /// Gets the HTTP Response message.
        /// </summary>
        /// <param name="responseMessage">
        /// The response message.
        /// </param>
        /// <returns>
        /// The HTTP response message.
        /// </returns>
        public static string GetMessage(HttpResponseMessage responseMessage)
        {
            // First look to see if it's an authentication error coming back from the realm
            string message = GetHeaderValueAsString(responseMessage, "xxx-authenticate-error-message");

            // Next, check for the standard server error reason coming from a web app
            if (string.IsNullOrEmpty(message))
            {
                message = GetHeaderValueAsString(responseMessage, "xxx-error-message");
            }

            // If it's still empty, fall back to the HTTP reason phrase
            if (string.IsNullOrEmpty(message))
            {
                message = responseMessage.ReasonPhrase;
            }

            return message;
        }

        /// <summary>
        /// A string representation of the server exception.
        /// </summary>
        /// <returns>
        /// Returns a string representing the exception.
        /// </returns>
        public override string ToString()
        {
            var builder = new StringBuilder();
            builder.AppendLine("Message: " + this.Message);
            builder.AppendLine("Error Code: " + this.ErrorCode);
            builder.AppendLine("Transaction Id: " + this.TransactionId);
            builder.AppendLine("Server Stack Trace: " + this.ServerStackTrace);

            return builder.ToString();
        }

        #endregion

        #region Methods

        /// <summary>
        /// Gets the header value as int.
        /// </summary>
        /// <param name="responseMessage">The response message.</param>
        /// <param name="headerName">Name of the header.</param>
        /// <returns>A header value converted to an int</returns>
        private static int GetHeaderValueAsInt(HttpResponseMessage responseMessage, string headerName)
        {
            int value = 0;
            IEnumerable<string> values;
            if (responseMessage.Headers.TryGetValues(headerName, out values))
            {
                string valueAsString = values.FirstOrDefault();
                if (!string.IsNullOrEmpty(valueAsString))
                {
                    int.TryParse(valueAsString, out value);
                }
            }

            return value;
        }

        /// <summary>
        /// Gets the header value as string.
        /// </summary>
        /// <param name="responseMessage">The response message.</param>
        /// <param name="headerName">Name of the header.</param>
        /// <returns>A header value converted to a string</returns>
        private static string GetHeaderValueAsString(HttpResponseMessage responseMessage, string headerName)
        {
            string value = string.Empty;
            IEnumerable<string> values;
            if (responseMessage.Headers.TryGetValues(headerName, out values))
            {
                value = values.FirstOrDefault();
            }

            return value;
        }

        #endregion
    }
}