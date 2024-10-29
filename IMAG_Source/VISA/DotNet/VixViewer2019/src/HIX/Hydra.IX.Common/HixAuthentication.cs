using System.Net.Http;

namespace Hydra.IX.Common
{
    public interface IHixAuthentication
    {
        void PrepareClient(HttpClient client);

        void ProcessResult(HttpResponseMessage response);

        void PrepareUrl(ref string url);
    }
}