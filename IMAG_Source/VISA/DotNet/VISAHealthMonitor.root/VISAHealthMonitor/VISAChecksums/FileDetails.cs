using System;
using System.Collections.Generic;
using System.Text;

namespace VISAChecksums
{
    public class FileDetails
    {
        public string Filename { get; private set; }
        public string Checksum { get; private set; }
        public long FileSize { get; private set; }

        public FileDetails(string filename, string checksum, long size)
        {
            this.Filename = filename;
            this.Checksum = checksum;
            this.FileSize = size;
        }
    }
}
