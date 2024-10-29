using Hydra.VistA;
using Hydra.Web;
using Owin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace VIX.Viewer.Service
{
    public static class AppBuilderExtensions
    {
        private const string AppDisposingKey = "host.OnAppDisposing";

        public static IAppBuilder UseVistAService(this IAppBuilder builder)
        {
            HookDisposal(builder);

            VistAService.Instance.Initialize();

            return builder;
        }

        private static void HookDisposal(IAppBuilder builder)
        {
            if (!builder.Properties.ContainsKey(AppDisposingKey))
            {
                return;
            }

            var appDisposing = builder.Properties[AppDisposingKey] as CancellationToken?;

            if (appDisposing.HasValue)
            {
                appDisposing.Value.Register(() =>
                {
                    VistAService.Instance.Uninitialize();
                });
            }
        }
    }
}
