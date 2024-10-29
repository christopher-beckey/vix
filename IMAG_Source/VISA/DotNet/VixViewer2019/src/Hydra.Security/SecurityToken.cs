using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Web; //VAI-1284

namespace Hydra.Security
{
    /// <summary>
    /// VIX Viewer Security Token, not to be confused with the VIX Java Security Token or the VistA (BSE) Token
    /// </summary>
    public class SecurityToken
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public DateTime TimeExpiry { get; set; }
        public string Data { get; set; } //VIX Java Security Token (contains BSE Token among other things)
        public string UserId { get; set; }
        private string TokenId { get; set; }
        private string Signature { get; set; }

        protected SecurityToken()
        { }

        public SecurityToken(DateTime timeExpiry, string data, string userId)
        {
            TimeExpiry = timeExpiry;
            Data = data;
            UserId = userId;
            TokenId = Guid.NewGuid().ToString();
            Signature = CryptoUtil.EncryptAES(TokenId);
        }

        public bool IsExpired
        {
            get
            {
                return (TimeExpiry < DateTime.UtcNow);
            }
        }

        /// <summary>
        /// Get the Base64 string of the VIX Viewer Security Token (aka API Token)
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return Common.Util.Base64Encode($"{TimeExpiry:O}|{Data}|{UserId}|{TokenId}|{Signature}");
        }

        /// <summary>
        /// Salt
        /// </summary>
        public string Key
        {
            get
            {
                return TokenId;
            }
        }

        /// <summary>
        /// Get the VIX Viewer Security Token from a string
        /// </summary>
        /// <param name="text">A Base64-encoded VIX Viewer Security Token string</param>
        /// <param name="securityToken">(out) VIX Viewer Security Token (aka API Token)</param>
        /// <returns>If successful, true plus SecurityToken object. If failure, false.</returns>
        public static bool TryParse(string text, out SecurityToken securityToken)
        {
            securityToken = null;
            if (text == null)
                return false;

            string[] urlParams = text.Split(new char[] { '&' });
            if (urlParams == null)
            {
                _Logger.Error("Invalid URL Parameters");
                return false;
            }
            text = urlParams[0];

            if (Hydra.Common.Util.IsUrlEncoded(text))
                text = HttpUtility.UrlDecode(text);

            text = Hydra.Common.Util.Base64Decode(text);
            string[] tokens = text.Split(new char[] { '|' });
            if ((tokens == null) || ((tokens.Length != 5) && (tokens.Length != 4)))
            {
                _Logger.Error("Invalid token length");
                return false;
            }

            //VAI-707
            //Set the EXPIRE Conditional Compilation Symbol in this DLL's project to break here and set tokens[0] to whenever you want the token to expire for Debugging
#if (DEBUG && EXPIRE)
            if (Debugger.IsAttached)
            {
                Debugger.Break();
                tokens[0] = "2020-02-29T11:59:59.0000000Z";
            }
#endif
            if (!DateTime.TryParse(tokens[0], CultureInfo.InvariantCulture, DateTimeStyles.RoundtripKind, out DateTime dtTimeStamp))
            {
                _Logger.Error("Invalid datetime token");
                return false;
            }
            SecurityToken token = new SecurityToken
            {
                TimeExpiry = dtTimeStamp,
                Data = tokens[1]
            };
            if (tokens.Length == 4)
            {
                // old style
                token.TokenId = tokens[2];
                token.Signature = tokens[3];
            }
            else
            {
                // new style
                token.UserId = tokens[2];
                token.TokenId = tokens[3];
                token.Signature = tokens[4];
            }

            // validate
            string salt = CryptoUtil.DecryptAES(token.Signature);
            if (salt != token.TokenId)
            {
                _Logger.Error("Invalid salt token");
                return false;
            }

            securityToken = token;

            return true;
        }

        /// <summary>
        /// Get the VIX Viewer Security Token from the dictionary
        /// </summary>
        /// <param name="dict">Dictionary which is most likely the URL parameters</param>
        /// <param name="securityToken">(out) VIX Viewer Security Token (aka API Token)</param>
        /// <returns>If successful, true plus SecurityToken object. If failure, false.</returns>
        /// <remarks>Originally created for VAI-707</remarks>
        public static bool TryParse(Dictionary<string, object> dict, out SecurityToken securityToken)
        {
            securityToken = null;
            _ = dict.TryGetValue("SecurityToken", out object value);
            if ((value != null) && (value is string))
                return TryParse((string)value, out securityToken);
            return false;
        }

        /// <summary>
        /// Create the VIX Viewer Security Token (aka API Token) based on user ID, VIX Java Security Token, and timespan
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="data">The VIX Java Security Token</param>
        /// <param name="tsTimeout">The length of time (after now) to expire the VIX Viewer Security Token</param>
        /// <returns>VIX Viewer SecurityToken as string</returns>
        /// <remarks>VAI-707: Moved here from VIXServiceUtil.cs after refactoring</remarks>
        public static string GenerateVixViewerSecurityToken(string userId, string data, TimeSpan tsTimeout)
        {
            SecurityToken token = new SecurityToken(DateTime.UtcNow + tsTimeout, data, userId);
            return token.ToString();
        }
    }
}