using NAudio.Wave;
using NAudio.Lame;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    class AudioProcessor
    {
        public static void ProcessAudio(string filePath, Stream inputStream, Stream outputStream)
        {
            string extension = Path.GetExtension(filePath).ToLower();
            switch (extension)
            {
                case ".wav":
                    {
                        Stream stream = null;

                        try
                        {
                            stream = (inputStream != null) ? inputStream : stream = File.Open(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
                            using (var reader = new WaveFileReader(stream))
                            {
                                using (var writer = new LameMP3FileWriter(outputStream, reader.WaveFormat, 128))
                                {
                                    reader.CopyTo(writer);
                                }
                            }
                        }
                        finally
                        {
                            if (inputStream == null)
                            {
                                stream.Close();
                            }
                        }

                    }
                    break;

                case ".mp3":
                    {
                        // simply copy file
                        Stream stream = null;

                        try
                        {
                            stream = (inputStream != null) ? inputStream : stream = File.Open(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
                            stream.CopyTo(outputStream);
                        }
                        finally
                        {
                            if (inputStream == null)
                            {
                                stream.Close();
                            }
                        }
                    }
                    break;

                default:
                    throw new NotSupportedException(string.Format("Audio format not supported. {0}", filePath));
            }
        }
    }
}
