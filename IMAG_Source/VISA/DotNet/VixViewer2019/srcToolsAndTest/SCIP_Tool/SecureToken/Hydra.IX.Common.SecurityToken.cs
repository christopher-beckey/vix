//TODO temp using Hydra.Log;
using System;
using System.Globalization;

namespace SCIP_Tool //TODO temp Hydra.IX.Common
{
    public class SecurityToken
    {
        //TODO temp private static readonly ILogger //_Logger = LogManager.GetCurrentClassLogger();

        public DateTime TimeExpiry { get; set; }
        public string Data { get; set; }
        public string UserId { get; set; }
        //TODO temp private
        public string TokenId { get; set; }
        //TODO temp private
        public string Signature { get; set; }

        protected SecurityToken()
        { }

        public SecurityToken(DateTime timeExpiry, string data, string userId)
        {
            TimeExpiry = timeExpiry;
            Data = data;
            UserId = userId;
            TokenId = Guid.NewGuid().ToString();
            Signature = HixCryptoUtil.EncryptAES(TokenId);
        }

        public bool IsExpired
        {
            get
            {
                return (TimeExpiry < DateTime.UtcNow);
            }
        }

        public override string ToString()
        {
            //TODO temp return Hydra.Common.Util.Base64EncodeUrl(string.Format("{0}|{1}|{2}|{3}|{4}",
            return Util.Base64EncodeUrl(string.Format("{0}|{1}|{2}|{3}|{4}",
                                                                TimeExpiry.ToString("O"),
                                                                Data,
                                                                UserId,
                                                                TokenId,
                                                                Signature));
        }

        public string Key
        {
            get
            {
                return TokenId;
            }
        }

        public static bool TryParse(string text, out SecurityToken securityToken)
        {
            securityToken = null;

            //TODO temp text = Hydra.Common.Util.Base64DecodeUrl(text);
            text = Util.Base64DecodeUrl(text);
            string[] tokens = text.Split(new char[] { '|' });
            if ((tokens == null) || ((tokens.Length != 5) && (tokens.Length != 4)))
            {
                //_Logger.Error("Invalid token length");
                return false;
            }

            DateTime dtTimeStamp;
            if (!DateTime.TryParse(tokens[0], CultureInfo.InvariantCulture, DateTimeStyles.RoundtripKind, out dtTimeStamp))
            {
                //_Logger.Error("Invalid datetime token");
                return false;
            }
            var token = new SecurityToken();
            token.TimeExpiry = dtTimeStamp;
            token.Data = tokens[1];
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
            string salt = HixCryptoUtil.DecryptAES(token.Signature);
            if (salt != token.TokenId)
            {
                //_Logger.Error("Invalid salt token");
                return false;
            }

            securityToken = token;

            return true;
        }
    }
}