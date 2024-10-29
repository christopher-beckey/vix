using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class HttpClientTimeoutHandler : DelegatingHandler
    {
        public TimeSpan DefaultTimeout { get; set; }
    
        public HttpClientTimeoutHandler()
        {
            DefaultTimeout = TimeSpan.FromSeconds(100);
        }

        protected async override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            using (var cts = GetCancellationTokenSource(request, cancellationToken))
            {
                try
                {
                    CancellationToken actualCancellationToken;
                    if (cts != null)
                        actualCancellationToken = cts.Token;

                    if (actualCancellationToken == null)
                        actualCancellationToken = cancellationToken;

                    return await base.SendAsync(request, actualCancellationToken);
                }
                catch(OperationCanceledException)
                {
                    if (!cancellationToken.IsCancellationRequested)
                        throw new TimeoutException();
                    else
                        throw;
                }
            }
        }
    
        private CancellationTokenSource GetCancellationTokenSource(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            var timeout = request.GetTimeout() ?? DefaultTimeout;
            if (timeout == Timeout.InfiniteTimeSpan)
            {
                // No need to create a CTS if there's no timeout
                return null;
            }
            else
            {
                var cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
                cts.CancelAfter(timeout);
                return cts;
            }
        }
    }
}
