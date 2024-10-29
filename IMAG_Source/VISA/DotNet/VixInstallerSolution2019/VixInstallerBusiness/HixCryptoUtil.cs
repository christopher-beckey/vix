using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public class HixCryptoUtil
    {
        private static string _password = "77304A2769A545117ACE7AA6383FC865";
        private static string _salt = "532730456FA388594B15D04DC4FCF15230779F7661308112C591EFDE61908632";

        public static string EncryptAES(string value)
        {
            return Encrypt<AesCryptoServiceProvider>(value, _password, _salt);
        }

        public static string DecryptAES(string value)
        {
            return Decrypt<AesCryptoServiceProvider>(value, _password, _salt);
        }

        public static string Encrypt<T>(string value, string password, string salt) where T : SymmetricAlgorithm, new()
        {
            ICryptoTransform transform = CreateEncryptor<T>(password, salt); ;

            using (MemoryStream buffer = new MemoryStream())
            {
                using (var stream = new CryptoStream(buffer, transform, CryptoStreamMode.Write))
                {
                    using (StreamWriter writer = new StreamWriter(stream, Encoding.Unicode))
                    {
                        writer.Write(value);
                    }
                }

                return Convert.ToBase64String(buffer.ToArray());
            }
        }

        public static string Decrypt<T>(string text, string password, string salt) where T : SymmetricAlgorithm, new()
        {
            ICryptoTransform transform = CreateDecryptor<T>(password, salt);

            using (MemoryStream buffer = new MemoryStream(Convert.FromBase64String(text)))
            {
                using (var stream = new CryptoStream(buffer, transform, CryptoStreamMode.Read))
                {
                    using (StreamReader reader = new StreamReader(stream, Encoding.Unicode))
                    {
                        return reader.ReadToEnd();
                    }
                }
            }
        }

        private static ICryptoTransform CreateEncryptor<T>(string password, string salt) where T : SymmetricAlgorithm, new()
        {
            DeriveBytes rgb = new Rfc2898DeriveBytes(password, Encoding.Unicode.GetBytes(salt));
            SymmetricAlgorithm algorithm = new T();
            byte[] rgbKey = rgb.GetBytes(algorithm.KeySize >> 3);
            byte[] rgbIV = rgb.GetBytes(algorithm.BlockSize >> 3);
            ICryptoTransform transform = algorithm.CreateEncryptor(rgbKey, rgbIV);

            return transform;
        }

        private static ICryptoTransform CreateDecryptor<T>(string password, string salt) where T : SymmetricAlgorithm, new()
        {
            DeriveBytes rgb = new Rfc2898DeriveBytes(password, Encoding.Unicode.GetBytes(salt));
            SymmetricAlgorithm algorithm = new T();
            byte[] rgbKey = rgb.GetBytes(algorithm.KeySize >> 3);
            byte[] rgbIV = rgb.GetBytes(algorithm.BlockSize >> 3);
            ICryptoTransform transform = algorithm.CreateDecryptor(rgbKey, rgbIV);

            return transform;
        }

        public static MemoryStream Encrypt<T>(Stream inputStream, string password, string salt) where T : SymmetricAlgorithm, new()
        {
            ICryptoTransform transform = CreateEncryptor<T>(password, salt);

            MemoryStream buffer = new MemoryStream();
            using (var stream = new HixCryptoStream(buffer, transform, CryptoStreamMode.Write))
            {
                inputStream.CopyTo(stream);
                buffer.Seek(0, SeekOrigin.Begin);
                return buffer;
            }
        }

        public static void Encrypt<T>(Stream inputStream, Stream outputStream, string password, string salt) where T : SymmetricAlgorithm, new()
        {
            ICryptoTransform transform = CreateEncryptor<T>(password, salt);
            using (var stream = new CryptoStream(outputStream, transform, CryptoStreamMode.Write))
            {
                inputStream.CopyTo(stream);
            }
        }

        public static Stream CreateEncryptStream<T>(Stream outputStream, string password, string salt) where T : SymmetricAlgorithm, new()
        {
            ICryptoTransform transform = CreateEncryptor<T>(password, salt);
            return new CryptoStream(outputStream, transform, CryptoStreamMode.Write);
        }

        public static MemoryStream Decrypt<T>(Stream inputStream, string password, string salt) where T : SymmetricAlgorithm, new()
        {
            ICryptoTransform transform = CreateDecryptor<T>(password, salt);

            using (var stream = new HixCryptoStream(inputStream, transform, CryptoStreamMode.Read))
            {
                MemoryStream buffer = new MemoryStream();
                stream.CopyTo(buffer);
                buffer.Seek(0, SeekOrigin.Begin);
                return buffer;
            }
        }

        public static byte[] DecryptBytes<T>(Stream inputStream, string password, string salt) where T : SymmetricAlgorithm, new()
        {
            ICryptoTransform transform = CreateDecryptor<T>(password, salt);

            using (var stream = new HixCryptoStream(inputStream, transform, CryptoStreamMode.Read))
            {
                using (MemoryStream buffer = new MemoryStream())
                {
                    stream.CopyTo(buffer);
                    return buffer.ToArray();
                }
            }
        }

        public static byte[] DecryptBytes(Stream inputStream, string password, string salt)
        {
            return DecryptBytes<AesCryptoServiceProvider>(inputStream, password, salt);
        }

        public static void Decrypt<T>(Stream inputStream, Stream outputStream, string password, string salt) where T : SymmetricAlgorithm, new()
        {
            ICryptoTransform transform = CreateDecryptor<T>(password, salt);

            using (var stream = new CryptoStream(inputStream, transform, CryptoStreamMode.Read))
            {
                stream.CopyTo(outputStream);
            }
        }

        public static MemoryStream DecryptAES(Stream inputStream, string password, string salt)
        {
            return Decrypt<AesCryptoServiceProvider>(inputStream, password, salt);
        }

        public static MemoryStream EncryptAES(Stream inputStream, string password, string salt)
        {
            return Encrypt<AesCryptoServiceProvider>(inputStream, password, salt);
        }

        public static void EncryptAES(Stream inputStream, Stream outputStream, string password, string salt)
        {
            Encrypt<AesCryptoServiceProvider>(inputStream, outputStream, password, salt);
        }

        public static void DecryptAES(Stream inputStream, Stream outputStream, string password, string salt)
        {
            Decrypt<AesCryptoServiceProvider>(inputStream, outputStream, password, salt);
        }

        public static string DecryptAES(string text, string password, string salt)
        {
            return Decrypt<AesCryptoServiceProvider>(text, password, salt);
        }

        public static string EncryptAES(string text, string password, string salt)
        {
            return Encrypt<AesCryptoServiceProvider>(text, password, salt);
        }

        public static Stream CreateEncryptStream(Stream outputStream, string password, string salt)
        {
            return CreateEncryptStream<AesCryptoServiceProvider>(outputStream, password, salt);
        }
    }
}
