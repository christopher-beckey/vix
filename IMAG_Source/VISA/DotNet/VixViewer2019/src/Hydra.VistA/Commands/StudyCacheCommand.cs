using Hydra.Log;
using Hydra.VistA.Parsers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Commands
{
    public class StudyCacheCommand
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private static readonly ILogger _AccessLogger = LogManager.GetAccessLogger();

        public static void Execute(VistAQuery studyQuery,  string cacheRequestText)
        {
            try
            {
                var displayObjectGroups = DisplayObjectParser.Parse(cacheRequestText);

                if (_Logger.IsDebugEnabled)
                {
                    _Logger.Debug("Performing study cache.", "Data", cacheRequestText);
                }

                VixServiceUtil.Authenticate(studyQuery);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error performing study cache.", "Exception", ex.ToString());
                throw;
            }
        }
    }
}
