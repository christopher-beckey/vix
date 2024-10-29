using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Storage
{
    public static class ImageStoreHelper
    {
        public static bool IsDriveFull(this ImageStore imageStore)
        {
            string drive = Path.GetPathRoot(imageStore.Path);
            if (string.IsNullOrEmpty(drive))
                throw new Exception("Failed to get drive letter");

            // get available space in MB
            var driveInfo = new DriveInfo(drive);
            int freeSpace = (int)((driveInfo.AvailableFreeSpace / 1024f) / 1024f);

            return (freeSpace < imageStore.DiskFullThreshold);
        }
    }
}
