using Hydra.Log;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Commands
{
    public class LogImageExportCommand
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static bool Execute(string siteId, ImageQuery imageQuery)
        {
            if (_Logger.IsInfoEnabled)
                _Logger.Info("Logging image export.", "ImageQuery", imageQuery.ToJsonLog());

            VixServiceUtil.Authenticate(imageQuery);

            return VixServiceUtil.LogImageExport(siteId, imageQuery.ImageURN, imageQuery.Reason, imageQuery.VixJavaSecurityToken);
        }
    }
}
