using Hydra.IX.Common;
using Hydra.IX.Configuration;
using Hydra.IX.Storage;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    public class PurgeScheduler : Hydra.IX.Core.IPurgeScheduler
    {
        private static readonly ILogger _PurgeLogger = LogManager.GetPurgeLogger();
        private object _SyncLock = new object();
        private Timer _Timer = null;
        private IPurgeHandler _PurgeHandler = null;

        public PurgeScheduler(IPurgeHandler purgeHandler)
        {
            _PurgeHandler = purgeHandler;

            // create infinite timer
            _Timer = new Timer(TimerCallback);
        }

        //public event Action StartPurgeEvent;

        public void Start()
        {
            lock (_SyncLock)
            {
                TimeSpan? nextPurgeTime = GetNextPurgeTime();
                if (!nextPurgeTime.HasValue)
                {
                    if (_PurgeLogger.IsInfoEnabled)
                        _PurgeLogger.Info("Purge not scheduled.");

                    _Timer.Change(Timeout.Infinite, Timeout.Infinite);
                }
                else
                {
                    if (_PurgeLogger.IsInfoEnabled)
                        _PurgeLogger.Info("Purge scheduled.", "Time", nextPurgeTime.ToString());

                    _Timer.Change(nextPurgeTime.Value, Timeout.InfiniteTimeSpan);
                }
            }
        }

        public void Stop()
        {
            lock (_SyncLock)
            {
                if (_PurgeHandler != null)
                    _PurgeHandler.Stop();

                _Timer.Change(Timeout.Infinite, Timeout.Infinite);

                if (_PurgeLogger.IsInfoEnabled)
                    _PurgeLogger.Info("Purge stopped.");
            }
        }

        public void Execute(PurgeRequest purgeRequest)
        {
            lock (_SyncLock)
            {
                if (_PurgeHandler != null)
                    _PurgeHandler.Start(purgeRequest);
            }
        }

        public object GetCacheStatus()
        {
            return (_PurgeHandler != null) ? _PurgeHandler.GetCacheStatus() : null;
        }

        private TimeSpan? GetNextPurgeTime()
        {
            // abort if purge disabled
            if (!HixConfigurationSection.Instance.Purge.Enabled)
                return null;

            List<TimeSpan> purgeTimes = null;

            // parse purge times. format HH:mm;HH:mm
            if (!string.IsNullOrEmpty(HixConfigurationSection.Instance.Purge.PurgeTimes))
            {
                purgeTimes = new List<TimeSpan>();

                string[] tokens = HixConfigurationSection.Instance.Purge.PurgeTimes.Split(';');
                Array.ForEach<string>(tokens, item =>
                {
                    var purgeTime = DateTime.ParseExact(item, "HH:mm", CultureInfo.InvariantCulture).TimeOfDay;
                    purgeTimes.Add(purgeTime);
                });

                purgeTimes.Sort();
            }

            if ((purgeTimes == null) || (purgeTimes.Count() == 0))
                return null;

            // get the next purgetime based on current time
            var timeOfDay = DateTime.Now.TimeOfDay;
            TimeSpan? nextPurgeTime = null;
            foreach (var item in purgeTimes)
            {
                if (timeOfDay < item)
                {
                    nextPurgeTime = item;
                    break;
                }
            }

            if (nextPurgeTime == null && purgeTimes.Count > 0)
            {
                nextPurgeTime = purgeTimes[0];
            }

            nextPurgeTime = (nextPurgeTime < timeOfDay) ? nextPurgeTime.Value.Add(TimeSpan.FromDays(1)) : nextPurgeTime;

            var dueTime = nextPurgeTime - timeOfDay;

            return dueTime;
        }

        private void TimerCallback(object state)
        {
            lock (_SyncLock)
            {
                // send purge notification
                if (_PurgeLogger.IsInfoEnabled)
                    _PurgeLogger.Info("Purge started.");
                
                if (_PurgeHandler != null)
                {
                    try
                    {
                        // use values from the configuration
                        var purgeRequest = new PurgeRequest()
                        {
                            MaxCacheSizeMB = HixConfigurationSection.Instance.Purge.MaxCacheSizeMB,
                            MaxAgeDays = HixConfigurationSection.Instance.Purge.MaxAgeDays,
                            ImageGroupPurgeBlockSize = HixConfigurationSection.Instance.Purge.ImageGroupPurgeBlockSize,
                            ImagePurgeBlockSize = HixConfigurationSection.Instance.Purge.ImagePurgeBlockSize,
                            EnableCacheCleanup = HixConfigurationSection.Instance.Purge.EnableCacheCleanup
                        };

                        _PurgeHandler.Start(purgeRequest);
                    }
                    catch (Exception) { }
                }
                //StartPurgeEvent();

                // schedule next purge
                TimeSpan? nextPurgeTime = GetNextPurgeTime();
                if (nextPurgeTime.HasValue)
                {
                    if (_PurgeLogger.IsInfoEnabled)
                        _PurgeLogger.Info("Purge scheduled.", "Time", nextPurgeTime.ToString());
                    
                    _Timer.Change(nextPurgeTime.Value, Timeout.InfiniteTimeSpan);
                }
            }
        }
    }
}
