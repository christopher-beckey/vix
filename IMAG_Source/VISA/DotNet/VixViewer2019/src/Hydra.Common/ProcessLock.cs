using System;
using System.Security.AccessControl;
using System.Security.Principal;
using System.Threading;

namespace Hydra.Common
{
    public class ProcessLock : IDisposable
    {
        private static string _MutexId;

        private Mutex _GlobalMutex;

        private bool _Owned = false;

        public ProcessLock(string mutexname, int timeOut = -1)
        {
            _MutexId = string.Format("Global\\{0}", mutexname);
            _GlobalMutex = new Mutex(false, _MutexId);

            var allowEveryoneRule = new MutexAccessRule(new SecurityIdentifier(WellKnownSidType.WorldSid, null),
                                                        MutexRights.FullControl,
                                                        AccessControlType.Allow);
            var securitySettings = new MutexSecurity();
            securitySettings.AddAccessRule(allowEveryoneRule);
            _GlobalMutex.SetAccessControl(securitySettings);

            try
            {
                if (timeOut < 0)
                    _Owned = _GlobalMutex.WaitOne(Timeout.Infinite, false);
                else
                    _Owned = _GlobalMutex.WaitOne(timeOut, false);

                if (_Owned == false)
                    throw new TimeoutException("Timeout waiting for exclusive access");
            }
            catch (AbandonedMutexException)
            {
                _Owned = true;
            }
        }

        public void Dispose()
        {
            if (_GlobalMutex != null)
            {
                if (_Owned)
                    _GlobalMutex.ReleaseMutex();

                _GlobalMutex.Dispose();
            }
        }
    }
}