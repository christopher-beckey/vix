using Hydra.Log;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Commands
{
    public class GetImageCommand
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static void Execute(ImageQuery imageQuery, Stream outputStream)
        {
            if (_Logger.IsInfoEnabled)
                _Logger.Info("Getting thumbnail image", "ImageQuery", imageQuery.ToJsonLog());

            VixServiceUtil.Authenticate(imageQuery);

            VixServiceUtil.GetImage(imageQuery, outputStream);
        }
    }
}
