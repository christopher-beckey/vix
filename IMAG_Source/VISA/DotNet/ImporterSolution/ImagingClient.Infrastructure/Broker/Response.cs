using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ImagingClient.Infrastructure.Broker
{
    public class Response
    {
        private string rawData;
        private string rPCName;

        public string RawData
        {
            get { return this.rawData; }
            set { this.rawData = value; }
        }

        public string RPCName
        {
            get { return this.rPCName; }
            set { this.rPCName = value; }
        }

        public Response()
        {
            rawData = string.Empty;
            rPCName = string.Empty;
        }

        public List<ResponseToken> Split(string delimStr)
        {
            ResponseToken responseToken = new ResponseToken(this.rawData);
            return responseToken.Split(delimStr);
        }
    }

    public class ResponseToken
    {
        private string value;

        public string Value
        {
            get { return this.value; }
            set { this.value = value; }
        }

        public ResponseToken()
        {
            this.value = string.Empty;
        }

        public ResponseToken(string value)
        {
            this.value = value;
        }

        public List<ResponseToken> Split(string delimStr)
        {
            List<ResponseToken> responseTokens = null;
            if (!string.IsNullOrEmpty(delimStr))
            {
                char[] delimiter = delimStr.ToCharArray();
                string[] tokens = this.value.Split(delimiter, StringSplitOptions.None);
                if (tokens != null)
                {
                    responseTokens = new List<ResponseToken>();
                    for (int i = 0; i < tokens.Length; i++)
                    {
                        responseTokens.Add(new ResponseToken(tokens[i]));
                    }
                }
            }

            return responseTokens;
        }
    }
}
