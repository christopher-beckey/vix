using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon;
using VISACommon;
using VixHealthMonitorCommon;

namespace VixHealthMonitorCommon
{
    public class VixHealthSource : VisaHealthSource
    {
        public BaseVixHealth VixHealth { get; private set; }

        public VixHealthSource(VisaSource visaSource, BaseVixHealth vixHealth)
            : base(visaSource, vixHealth.VisaHealth)
        {
            VixHealth = vixHealth;
        }

        public override bool Equals(object obj)
        {
            if (obj is VixHealthSource)
            {
                VixHealthSource that = (VixHealthSource)obj;
                return (this.VisaSource.Equals(that.VisaSource));
                //return (this.VisaSource == that.VisaSource);
            }
            return false;
        }


    }
}
