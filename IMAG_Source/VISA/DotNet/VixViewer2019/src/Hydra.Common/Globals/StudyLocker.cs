using System;

namespace Hydra.Globals
{
    public static class StudyLocker
    {
        private static NamedReaderWriterLock _locker = new NamedReaderWriterLock();

        public static void RunWithWriteLock(string name, Action body)
        {
            _locker.RunWithWriteLock(name, body);
        }

        public static void RunWithReadLock(string name, Action body)
        {
            _locker.RunWithReadLock(name, body);
        }

        public static void RunWithReadLock(string name, int timeoutMilliseconds, Action body)
        {
            _locker.RunWithReadLock(name, timeoutMilliseconds, body);
        }
    }
}