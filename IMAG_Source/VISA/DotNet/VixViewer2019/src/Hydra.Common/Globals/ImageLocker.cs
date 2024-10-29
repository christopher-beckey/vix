using System;

namespace Hydra.Globals
{
    public static class ImageLocker
    {
        private static NamedReaderWriterLock _locker = new NamedReaderWriterLock();

        public static void RunWithWriteLock(string name, Action body)
        {
            _locker.RunWithWriteLock(name, body);
        }
    }
}