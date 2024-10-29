using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Common
{
    public class CodeClock
    {
        private Stopwatch _stopWatch = new Stopwatch();

        private CodeClock()
        {
            _stopWatch.Start();
        }

        public static CodeClock Start()
        {
            return new CodeClock();
        }

        public long ElapsedMilliseconds
        {
            get
            {
                return _stopWatch.ElapsedMilliseconds;
            }
        }

        public string ElapsedSeconds
        {
            get
            {
                return ((double)_stopWatch.ElapsedMilliseconds / 1000).ToString("0.##");
            }
        }

        public void Stop()
        {
            _stopWatch.Stop();
        }
    }
}
