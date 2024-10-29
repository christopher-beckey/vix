using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    // Does not close underlying stream when disposed
    class HixCryptoStream : CryptoStream
    {
        public HixCryptoStream(Stream stream, ICryptoTransform transform, CryptoStreamMode mode)
            : base( stream, transform, mode)
        {
        }

        protected override void Dispose( bool disposing )
        {
            if( !HasFlushedFinalBlock )
                FlushFinalBlock();

            base.Dispose(false);
        }
    }
}
