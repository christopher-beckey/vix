using System;
using System.Linq;
using Hydra.IX.Common;

namespace Hydra.IX.Client
{
    public class TokenHixAuthentication : IHixAuthentication
    {
        public Func<string> GetLatestToken { get; set; }
        public Action<string> UpdateToken { get; set; }
        public string HeaderName { get; set; }

        public void PrepareClient(System.Net.Http.HttpClient client)
        {
            if (GetLatestToken != null)
            {
                if (client.DefaultRequestHeaders.Contains(HeaderName))
                {
                    client.DefaultRequestHeaders.Remove(HeaderName);
                }
                string token = GetLatestToken();
                client.DefaultRequestHeaders.Add(HeaderName, token);
            }
        }

        public TokenHixAuthentication(string headerName, Func<string> getLatestToken, Action<string> updateToken)
        {
            HeaderName = headerName;
            GetLatestToken = getLatestToken;
            UpdateToken = updateToken;
        }

        public void ProcessResult(System.Net.Http.HttpResponseMessage response)
        {
            if (response != null && UpdateToken != null)
            {
                if (response.Headers.Contains(HeaderName))
                {
                    string token = response.Headers.GetValues(HeaderName).FirstOrDefault();
                    if (token != null)
                        UpdateToken(token);
                }
            }
        }

        public void PrepareUrl(ref string url)
        {
        }
    }
}
