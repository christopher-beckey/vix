using System.IO;
using System.Security.Cryptography;

namespace Hydra.IX.Common
{
    // Does not close underlying stream when disposed
    internal class HixCryptoStream : CryptoStream
    {
        public HixCryptoStream(Stream stream, ICryptoTransform transform, CryptoStreamMode mode)
            : base(stream, transform, mode)
        {
        }

        protected override void Dispose(bool disposing)
        {
            if (!HasFlushedFinalBlock)
                FlushFinalBlock();

            base.Dispose(false);
        }
    }
}