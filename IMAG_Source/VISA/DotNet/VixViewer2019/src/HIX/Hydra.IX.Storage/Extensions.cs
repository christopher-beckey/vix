using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Storage
{
    public static class Extensions
    {
        public static bool IsText(this Hydra.Common.ImagePartTransform transformType)
        {
            switch (transformType)
            {
                case Hydra.Common.ImagePartTransform.Html:
                case Hydra.Common.ImagePartTransform.Json:
                    return true;
                default: return false;
            }
        }
    }
}
