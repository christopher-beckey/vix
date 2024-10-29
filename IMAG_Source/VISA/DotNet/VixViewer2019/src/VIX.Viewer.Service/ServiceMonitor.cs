using Hydra.Common;
using Hydra.Log;
using Hydra.VistA;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace VIX.Viewer.Service
{
    public class ServiceMonitor
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private static readonly ILogger _StartupLogger = LogManager.GetStartupLogger();
        private object _SyncLock = new object();
        private Timer _Timer = null;
        private IViewerWebApp _ViewerWebApp = null;

        public ServiceMonitor(IViewerWebApp viewerWebApp)
        {
            _ViewerWebApp = viewerWebApp;

            // create infinite timer
            _Timer = new Timer(TimerCallback);
        }

        public void Start()
        {
            lock (_SyncLock)
            {
                TimeSpan? nextMonitorTime = GetNextMonitorTime();
                if (!nextMonitorTime.HasValue)
                {
                    _StartupLogger.Info("Service monitoring not scheduled.");
                    _Timer.Change(Timeout.Infinite, Timeout.Infinite);
                }
                else
                {
                    _StartupLogger.Info("Service monitoring scheduled.", "Time", nextMonitorTime.ToString());
                    _Timer.Change(nextMonitorTime.Value, Timeout.InfiniteTimeSpan);
                }
            }
        }

        public void Stop()
        {
            lock (_SyncLock)
            {
                _Timer.Change(Timeout.Infinite, Timeout.Infinite);
            }
        }

        private TimeSpan? GetNextMonitorTime()
        {
            string monitoringSchedule = PolicyUtil.GetPolicySettingsText("Viewer.MonitoringSchedule");
            List<TimeSpan> monitorTimes = null;

            // parse purge times. format HH:mm;HH:mm
            if (!string.IsNullOrEmpty(monitoringSchedule))
            {
                monitorTimes = new List<TimeSpan>();

                string[] tokens = monitoringSchedule.Split(';');
                Array.ForEach<string>(tokens, item =>
                {
                    var purgeTime = DateTime.ParseExact(item, "HH:mm", CultureInfo.InvariantCulture).TimeOfDay;
                    monitorTimes.Add(purgeTime);
                });

                monitorTimes.Sort();
            }

            if ((monitorTimes == null) || (monitorTimes.Count() == 0))
                return null;

            // get the next purgetime based on current time
            var timeOfDay = DateTime.Now.TimeOfDay;
            TimeSpan? nextMonitorTime = null;
            foreach (var item in monitorTimes)
            {
                if (timeOfDay < item)
                {
                    nextMonitorTime = item;
                    break;
                }
            }

            if (nextMonitorTime == null && monitorTimes.Count > 0)
                nextMonitorTime = monitorTimes[0];

            nextMonitorTime = (nextMonitorTime < timeOfDay) ? nextMonitorTime.Value.Add(TimeSpan.FromDays(1)) : nextMonitorTime;
            var dueTime = nextMonitorTime - timeOfDay;

            return dueTime;
        }

        private void TimerCallback(object state)
        {
            lock (_SyncLock)
            {
                try
                {
                    if (PerformServiceCheck())
                    {
                        // schedule next purge
                        TimeSpan? nextMonitorTime = GetNextMonitorTime();
                        if (nextMonitorTime.HasValue)
                        {
                            if (_Logger.IsInfoEnabled)
                                _Logger.Info("Service monitoring scheduled.", "Time", nextMonitorTime.ToString());
                            _Timer.Change(nextMonitorTime.Value, Timeout.InfiniteTimeSpan);
                        }
                    }
                    else
                    {
                        // service error
                        _ViewerWebApp.Stop();

                        Environment.Exit(1);
                    }
                }
                catch (Exception)
                {
                }
            }
        }

        private bool PerformServiceCheck()
        {
            try
            {
                if (_Logger.IsInfoEnabled)
                    _Logger.Info("Performing service check.");

                if (_ViewerWebApp.IsRunning)
                {
                    int maxMemoryUsageLimitKB = PolicyUtil.GetPolicySettingsInt("Viewer.MemoryUsageLimitKB", 0);
                    if (maxMemoryUsageLimitKB > 0)
                    {
                        // check process memory usage
                        if (ProcessUtil.GetMemoryUsageKB() > maxMemoryUsageLimitKB)
                        {
                            throw new Exception("Memory usage threshold reached.");
                        }
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                _Logger.Error(ex.Message);
                return false;
            }
        }
    }
}
