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


using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Net.Http;

namespace ImagingClient.Infrastructure.Exceptions
{
    public class ServerException : Exception
    {
        public int ErrorCode { get; set; }
        public String ServerStackTrace { get; set; }
        public String TransactionId { get; set; }

        private ServerException(String message, int errorCode, String serverStackTrace, String transactionId)
            : base(message)
        {
            ErrorCode = errorCode;
            ServerStackTrace = serverStackTrace;
            TransactionId = transactionId;
        }

        public override string ToString()
        {
            StringBuilder builder = new StringBuilder();
            builder.AppendLine("Message: " + Message);
            builder.AppendLine("Error Code: " + ErrorCode);
            builder.AppendLine("Transaction Id: " + TransactionId);
            builder.AppendLine("Server Stack Trace: " + ServerStackTrace);

            return builder.ToString();
        }

        public static ServerException CreateServerException(HttpResponseMessage responseMessage, String transactionId)
        {
            String message = GetMessage(responseMessage);
            int errorCode = GetErrorCode(responseMessage);
            String serverStackTrace = responseMessage.Content.ReadAsString();
            return new ServerException(message, errorCode, serverStackTrace, transactionId);
        }

        public static String GetMessage(HttpResponseMessage responseMessage)
        {
            // First look to see if it's an authentication error coming back from the realm
            String message = GetHeaderValueAsString(responseMessage, "xxx-authenticate-error-message");
            
            // Next, check for the standard server error reason coming from a web app
            if (String.IsNullOrEmpty(message))
            {
                message = GetHeaderValueAsString(responseMessage, "xxx-error-message");
            }

            // If it's still empty, fall back to the HTTP reason phrase
            if (String.IsNullOrEmpty(message))
            {
                message = responseMessage.ReasonPhrase;
            }

            return message;
        }

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

        private static String GetHeaderValueAsString(HttpResponseMessage responseMessage, String headerName)
        {
            String value = String.Empty;
            IEnumerable<String> values;
            if (responseMessage.Headers.TryGetValues(headerName, out values))
            {
                value = values.FirstOrDefault();
            }

            return value;

        }

        private static int GetHeaderValueAsInt(HttpResponseMessage responseMessage, String headerName)
        {
            int value = 0;
            IEnumerable<String> values;
            if (responseMessage.Headers.TryGetValues(headerName, out values))
            {
                String valueAsString = values.FirstOrDefault();
                if (!String.IsNullOrEmpty(valueAsString))
                {
                    int.TryParse(valueAsString, out value);
                }
            }

            return value;

        }

    }
}
