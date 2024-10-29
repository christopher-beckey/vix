using System;
using System.Collections.Generic;
using System.Threading;

namespace Hydra.Globals
{
    public class NamedReaderWriterLock
    {
        private static readonly Dictionary<string, RefCounter> _locks = new Dictionary<string, RefCounter>();
        private const int TIMEOUT_MILLISECONDS = -1; // infinite

        public void RunWithWriteLock(string name, Action body)
        {
            using (LockWrite(name))
                body();
        }

        public void RunWithWriteLock(string name, int timeoutMilliseconds, Action body)
        {
            using (LockWrite(name, timeoutMilliseconds))
                body();
        }

        public void RunWithReadLock(string name, Action body)
        {
            using (LockRead(name))
                body();
        }

        public void RunWithReadLock(string name, int timeoutMilliseconds, Action body)
        {
            using (LockWrite(name, timeoutMilliseconds))
                body();
        }

        public IDisposable LockRead(string name)
        {
            return LockRead(name, TIMEOUT_MILLISECONDS);
        }

        public IDisposable LockRead(string name, int timeoutMilliseconds)
        {
            return WithLock(name, refCounter =>
            {
                if (!refCounter.RWLock.TryEnterReadLock(timeoutMilliseconds))
                    throw new TimeoutException(String.Format("Timed out after {0}ms waiting to acquire read lock on '{1}' - possible deadlock", timeoutMilliseconds, name));
                return 0;
            }, refCounter =>
            {
                refCounter.RWLock.ExitReadLock();
                return refCounter.Refs;
            });
        }

        public IDisposable LockWrite(string name)
        {
            return LockWrite(name, TIMEOUT_MILLISECONDS);
        }

        public IDisposable LockWrite(string name, int timeoutMilliseconds)
        {
            return WithLock(name, refCounter =>
            {
                if (!refCounter.RWLock.TryEnterWriteLock(timeoutMilliseconds))
                    throw new TimeoutException(String.Format("Timed out after {0}ms waiting to acquire write lock on '{1}' - possible deadlock", timeoutMilliseconds, name));
                return 0;
            }, refCounter =>
            {
                refCounter.RWLock.ExitWriteLock();
                return refCounter.Refs;
            });
        }

        public IDisposable LockUpgradeableRead(string name)
        {
            return LockUpgradeableRead(name, TIMEOUT_MILLISECONDS);
        }

        public IDisposable LockUpgradeableRead(string name, int timeoutMilliseconds)
        {
            return WithLock(name, refCounter =>
            {
                if (!refCounter.RWLock.TryEnterUpgradeableReadLock(timeoutMilliseconds))
                    throw new TimeoutException(String.Format("Timed out after {0}ms waiting to acquire upgradeable read lock on '{1}' - possible deadlock", timeoutMilliseconds, name));
                return 0;
            }, refCounter =>
            {
                refCounter.RWLock.ExitUpgradeableReadLock();
                return refCounter.Refs;
            });
        }

        private static void WithUnlock(string name, Func<RefCounter, int> unlockAction)
        {
            lock (_locks)
            {
                RefCounter refCounter = null;
                _locks.TryGetValue(name, out refCounter);
                if (refCounter != null)
                {
                    if (0 == unlockAction(refCounter))
                    {
                        _locks.Remove(name);
                    }
                }
            }
        }

        private static IDisposable WithLock(string name, Func<RefCounter, int> lockAction, Func<RefCounter, int> unlockAction)
        {
            Monitor.Enter(_locks);
            RefCounter refCounter = null;
            _locks.TryGetValue(name, out refCounter);
            if (refCounter == null)
            {
                refCounter = new RefCounter();
                lockAction(refCounter);
                _locks.Add(name, refCounter);
                Monitor.Exit(_locks);
            }
            else
            {
                Monitor.Exit(_locks);
                lockAction(refCounter);
            }
            return new Token(() => WithUnlock(name, unlockAction));
        }

        public class RefCounter //public for unit tests - can be internal if the unit tests assembly can access this assembl_y
        {
            public readonly ReaderWriterLockSlim RWLock = new ReaderWriterLockSlim();

            public int Refs
            {
                get
                {
                    return RWLock.CurrentReadCount + RWLock.WaitingReadCount + RWLock.WaitingUpgradeCount + RWLock.WaitingWriteCount;
                }
            }
        }

        private class Token : IDisposable
        {
            private readonly Action _fn;

            public Token(Action fn)
            {
                _fn = fn;
            }

            public void Dispose()
            {
                _fn();
            }
        }
    }
}