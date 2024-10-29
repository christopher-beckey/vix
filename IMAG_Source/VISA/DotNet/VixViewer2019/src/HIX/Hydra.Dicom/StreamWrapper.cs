using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class StreamWrapper : Stream
    {
        private Stream _Stream = null;

        public StreamWrapper(Stream stream)
        {
            _Stream = stream;
        }

        public override int Read(byte[] buffer, int offset, int count)
        {
            return _Stream.Read(buffer, offset, count);
        }



        public override void Close()
        {
        }

        public override void Write(byte[] buffer, int offset, int count)
        {
            _Stream.Write(buffer, offset, count);
        }

        public override long Seek(long offset, SeekOrigin origin)
        {
            return _Stream.Seek(offset, origin);
        }

        public override bool CanRead { get { return _Stream.CanRead; } }
        public override bool CanSeek { get { return _Stream.CanSeek; } }
        public override bool CanTimeout { get { return false; } }
        public override bool CanWrite { get { return false; } }
        public override long Length { get { return _Stream.Length; } }
        public override void Flush() { _Stream.Flush(); }

        public override void SetLength(long value)
        {
            _Stream.SetLength(value);
        }

        public override long Position
        {
            get
            {
                return _Stream.Position;
            }
            set
            {
                _Stream.Position = value;
            }
        }



        internal void CloseForReal()
        {
            _Stream.Close();
            base.Close();
        }
    }
}
