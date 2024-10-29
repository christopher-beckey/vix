using System.IO;

namespace Hydra.Common
{
    public interface IFileStorage
    {
        void WriteAllBytes(string filePath, byte[] content);

        void WriteBitmap(string filePath, System.Drawing.Bitmap content, System.Drawing.Imaging.ImageFormat format);

        void WriteAllText(string filePath, string content);

        void CopyFile(string filePath, string sourceFilePath, bool isSourceEncrypted);

        StreamWriter CreateText(string filePath);

        Stream CreateStream(string filePath);
    }

    public class DefaultFileStorage : IFileStorage
    {
        public void WriteAllBytes(string filePath, byte[] content)
        {
            File.WriteAllBytes(filePath, content);
        }

        public void WriteBitmap(string filePath, System.Drawing.Bitmap content, System.Drawing.Imaging.ImageFormat format)
        {
            content.Save(filePath);
        }

        public void WriteAllText(string filePath, string content)
        {
            File.WriteAllText(filePath, content);
        }

        public void CopyFile(string filePath, string sourceFilePath, bool isSourceEncrypted)
        {
            File.Copy(sourceFilePath, filePath);
        }

        public StreamWriter CreateText(string filePath)
        {
            return File.CreateText(filePath);
        }

        public Stream CreateStream(string filePath)
        {
            return File.OpenWrite(filePath);
        }
    }
}