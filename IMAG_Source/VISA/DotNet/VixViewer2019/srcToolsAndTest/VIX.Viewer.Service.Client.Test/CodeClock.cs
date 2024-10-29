using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Viewer.Service.Client.Test
{
    public class CodeClock : IDisposable
    {
        private readonly Stopwatch _stopwatch;
        public static Action<string> LogDelegate = null;
        private string _name;

        public CodeClock(string name, params object[] args)
        {
            _name = string.Format(name, args);
            _stopwatch = new Stopwatch();

            if (LogDelegate != null)
                LogDelegate(string.Format("{0}...started", _name));

            _stopwatch.Start();
        }
        public void Dispose()
        {
            _stopwatch.Stop();

            if (LogDelegate != null)
                LogDelegate(string.Format("{0}...completed. {1} ms", _name, _stopwatch.ElapsedMilliseconds));
        }
    }
}
