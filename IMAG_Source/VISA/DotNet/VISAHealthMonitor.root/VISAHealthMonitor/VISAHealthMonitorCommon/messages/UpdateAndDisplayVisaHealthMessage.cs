using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;

namespace VISAHealthMonitorCommon.messages
{
    public class UpdateAndDisplayVisaHealthMessage: BaseVisaHealthMessage
    {
        public UpdateAndDisplayVisaHealthMessage(VisaSource visaSource)
            : base(visaSource)
        {

        }
    }
}
