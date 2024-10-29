using Hydra.IX.Common;
using Hydra.IX.Core;
using Owin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace VIX.Render.Service
{
    public static class AppBuilderExtensions
    {
        private const string AppDisposingKey = "host.OnAppDisposing";

        public static IAppBuilder UseHix(this IAppBuilder builder)
        {
            HookDisposal(builder);

            var configFilePath = ConfigurationLocator.ResolveConfigFilePath(Globals.ConfigFilePath);

            HixService.Instance.Start(configFilePath);

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
                    HixService.Instance.Stop();
                });
            }
        }
    }
}
