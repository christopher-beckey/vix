using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Commands
{
    public class VerifyESignatureCommand
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static bool Execute(string siteId, string eSignature, VistAQuery vistaQuery)
        {
            VixServiceUtil.Authenticate(vistaQuery);

            return VixServiceUtil.VerifyElectronicSignature(siteId, eSignature, vistaQuery.VixJavaSecurityToken);
        }
    }
}
