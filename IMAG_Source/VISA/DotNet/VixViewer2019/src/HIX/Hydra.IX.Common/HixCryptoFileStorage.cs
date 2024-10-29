using Hydra.Common;
using Hydra.Security;
using System.IO;

namespace Hydra.IX.Common
{
    public class HixCryptoFileStorage : IFileStorage
    {
        public string Password { get; private set; }
        public string Salt { get; private set; }

        public HixCryptoFileStorage(string password, string salt)
        {
            Password = password;
            Salt = salt;
        }

        public void WriteAllBytes(string filePath, byte[] content)
        {
            using (var fileStream = File.OpenWrite(filePath))
            {
                using (var memoryStream = new MemoryStream(content))
                {
                    CryptoUtil.EncryptAES(memoryStream, fileStream, Password, Salt);
                }
            }
        }

        public void WriteBitmap(string filePath, System.Drawing.Bitmap content, System.Drawing.Imaging.ImageFormat format)
        {
            using (var fileStream = File.OpenWrite(filePath))
            {
                using (var memoryStream = new MemoryStream())
                {
                    content.Save(memoryStream, format);
                    memoryStream.Seek(0, SeekOrigin.Begin);

                    CryptoUtil.EncryptAES(memoryStream, fileStream, Password, Salt);
                }
            }
        }

        public void WriteAllText(string filePath, string content)
        {
            File.WriteAllText(filePath, CryptoUtil.EncryptAES(content, Password, Salt));
        }

        public void CopyFile(string filePath, string sourceFilePath, bool isSourceEncrypted)
        {
            if (isSourceEncrypted)
            {
                // simply copy files
                File.Copy(sourceFilePath, filePath);
            }
            else
            {
                using (var inputStream = File.Open(sourceFilePath, FileMode.Open, FileAccess.Read, FileShare.Read))
                {
                    using (var fileStream = File.OpenWrite(filePath))
                    {
                        CryptoUtil.EncryptAES(inputStream, fileStream, Password, Salt);
                    }
                }
            }
        }

        public System.IO.StreamWriter CreateText(string filePath)
        {
            var fileStream = File.OpenWrite(filePath);
            return new StreamWriter(CryptoUtil.CreateEncryptStream(fileStream, Password, Salt));
        }

        public System.IO.Stream CreateStream(string filePath)
        {
            var fileStream = File.OpenWrite(filePath);
            return CryptoUtil.CreateEncryptStream(fileStream, Password, Salt);
        }
    }
}