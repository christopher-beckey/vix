extern alias DICOM;
extern alias aECG;
extern alias ISHNE;
extern alias MUSEXML;
extern alias OmronECG;
extern alias PDF;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.ECG
{
    public sealed class Referencer
    {
        private Type[] types = new[] 
        {
                typeof (DICOM::ECGConversion.ECGLoad),
                typeof (aECG::ECGConversion.ECGLoad),
                typeof (ISHNE::ECGConversion.ECGLoad),
                typeof (MUSEXML::ECGConversion.ECGLoad),
                typeof (OmronECG::ECGConversion.ECGLoad),
                typeof (PDF::ECGConversion.ECGLoad)
        };

        // This is the only constructor. So you can't instantiate this type.
        private Referencer()
        {
        }
    }
}
