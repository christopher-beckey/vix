using System;
using System.Collections.Concurrent;

namespace DesktopCommon
{
    internal class lockedObject
    {
        public int count = 0;
    }

    public class LockManager
    {
        static ConcurrentDictionary<string, lockedObject> _locks = new ConcurrentDictionary<string, lockedObject>();
        private static lockedObject GetLock(string filename)
        {
            lockedObject o = null;
            if (_locks.TryGetValue(filename.ToLower(), out o))
            {
                o.count++;
                return o;
            }
            else
            {
                o = new lockedObject();
                _locks.TryAdd(filename.ToLower(), o);
                o.count++;
                return o;
            }
        }

        public static void GetLock(string filename, Action action)
        {
            lock (GetLock(filename))
            {
                action();
                Unlock(filename);
            }
        }

        private static void Unlock(string filename)
        {
            lockedObject o = null;
            if (_locks.TryGetValue(filename.ToLower(), out o))
            {
                o.count--;
                if (o.count == 0)
                    _locks.TryRemove(filename.ToLower(), out o);
            }
        }
    }
}