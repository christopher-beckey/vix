using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Commands
{
    public class GetImagingDataCommand
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static string Execute(MetadataQuery metadataQuery)
        {
            _Logger.Info("Getting imaging data", "MetadataQuery", metadataQuery.ToJsonLog());

            VixServiceUtil.Authenticate(metadataQuery);

            return VixServiceUtil.GetImagingData(metadataQuery);
        }
    }
}
