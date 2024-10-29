// -----------------------------------------------------------------------
// <copyright file="AesBase64.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Security.Cryptography
{
    using System;
    using System.Diagnostics.Contracts;
    using System.IO;
    using System.Security.Cryptography;
    using System.Text;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class AesBase64
    {
        /// <summary>
        /// Legal key sizes
        /// </summary>
        public static readonly KeySizes[] LegalKeySizes;

        /// <summary>
        /// The block size
        /// </summary>
        public static readonly int BlockSize;

        /// <summary>
        /// Initializes static members of the <see cref="AesBase64"/> class.
        /// </summary>
        static AesBase64()
        {
            using (AesManaged aesAlg = new AesManaged())
            {
                LegalKeySizes = aesAlg.LegalKeySizes;
                BlockSize = aesAlg.BlockSize;
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AesBase64"/> class.
        /// </summary>
        /// <param name="key">The key.</param>
        public AesBase64(byte[] key)
        {
            Contract.Requires(key != null);
            Contract.Requires(LegalKeySizes.IsValid(key.Length * 8));
            this.Key = key;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AesBase64"/> class.
        /// </summary>
        /// <param name="base64Key">The base64 key.</param>
        public AesBase64(string base64Key)
        {
            Contract.Requires(base64Key != null);
            Contract.Requires(base64Key.IsBase64String());
            Contract.Requires(LegalKeySizes.IsValid(Convert.FromBase64String(base64Key).Length * 8));
            this.Key = Convert.FromBase64String(base64Key);
        }

        /// <summary>
        /// Gets or sets the encryption key.
        /// </summary>
        public virtual byte[] Key { get; protected set; }

        /// <summary>
        /// Decrypts the base64 to string.
        /// </summary>
        /// <param name="base64CipherText">The cipher text.</param>
        /// <param name="base64Iv">The base 64 encoded initialization vector.</param>
        /// <returns>The decrypted string</returns>
        public virtual string DecryptToString(string base64CipherText, string base64Iv)
        {
            Contract.Requires(base64CipherText != null);
            Contract.Requires(base64CipherText.IsBase64String());
            Contract.Requires(!string.IsNullOrEmpty(base64Iv));
            Contract.Requires(base64Iv.IsBase64String());
            Contract.Requires(Convert.FromBase64String(base64Iv).Length * 8 == BlockSize);
            byte[] cipherBytes = Convert.FromBase64String(base64CipherText);
            byte[] vectorBytes = Convert.FromBase64String(base64Iv);
            byte[] clearBytes = this.Decrypt(cipherBytes, vectorBytes);
            return Encoding.UTF8.GetString(clearBytes, 0, clearBytes.Length);
        }

        /// <summary>
        /// Encrypts the string to base64.
        /// </summary>
        /// <param name="clearText">The clear text.</param>
        /// <param name="base64Iv">The base 64 encoded initialization vector.</param>
        /// <returns>The encrypted string base 64 encoded</returns>
        public virtual string EncryptString(string clearText, string base64Iv)
        {
            Contract.Requires(clearText != null);
            Contract.Requires(!string.IsNullOrEmpty(base64Iv));
            Contract.Requires(base64Iv.IsBase64String());
            Contract.Requires(Convert.FromBase64String(base64Iv).Length * 8 == BlockSize);
            byte[] clearBytes = Encoding.UTF8.GetBytes(clearText);
            byte[] vectorBytes = Convert.FromBase64String(base64Iv);
            byte[] cipherBytes = this.Encrypt(clearBytes, vectorBytes);
            return Convert.ToBase64String(cipherBytes);
        }

        /// <summary>
        /// Decrypts the specified cipher bytes.
        /// </summary>
        /// <param name="cipherBytes">The cipher bytes.</param>
        /// <param name="iv">The initialization vector.</param>
        /// <returns>The decrypted bytes</returns>
        protected virtual byte[] Decrypt(byte[] cipherBytes, byte[] iv)
        {
            Contract.Requires(cipherBytes != null);
            Contract.Requires(iv != null);
            Contract.Requires(cipherBytes.Length > 0);
            Contract.Requires(iv.Length > 0);

            byte[] clearBytes = null;

            // Create a AesManaged object
            // with the specified key and IV.
            using (AesManaged aesAlg = new AesManaged())
            {
                aesAlg.KeySize = this.Key.Length * 8;

                // Create a decrytor to perform the stream transform.
                ICryptoTransform decryptor = aesAlg.CreateDecryptor(this.Key, iv);

                // Create the streams used for decryption.
                using (MemoryStream targetStream = new MemoryStream(cipherBytes))
                {
                    using (CryptoStream cypherStream = new CryptoStream(targetStream, decryptor, CryptoStreamMode.Read))
                    {
                        using (MemoryStream sourceStream = new MemoryStream())
                        {
                            this.CopyStream(cypherStream, sourceStream);
                            clearBytes = sourceStream.ToArray();
                        }
                    }
                }
            }

            return clearBytes;
        }

        /// <summary>
        /// Encrypts the specified clear bytes.
        /// </summary>
        /// <param name="clearBytes">The clear bytes.</param>
        /// <param name="iv">The initialization vector.</param>
        /// <returns>The encrypted bytes</returns>
        protected virtual byte[] Encrypt(byte[] clearBytes, byte[] iv)
        {
            // Check arguments.
            if (clearBytes == null || clearBytes.Length <= 0)
            {
                throw new ArgumentNullException("clearBytes");
            }

            if (iv == null || iv.Length <= 0)
            {
                throw new ArgumentNullException("iv");
            }

            // Declare the stream used to encrypt to an in memory
            // array of bytes.
            MemoryStream targetStream = null;

            // Create a AesManaged object
            // with the specified key and IV.
            using (AesManaged aesAlg = new AesManaged())
            {
                aesAlg.KeySize = this.Key.Length * 8;

                // Create an encryptor to perform the stream transform.
                ICryptoTransform encryptor = aesAlg.CreateEncryptor(this.Key, iv);

                // Create the streams used for encryption.
                targetStream = new MemoryStream();
                using (CryptoStream cypherEncrypt = new CryptoStream(targetStream, encryptor, CryptoStreamMode.Write))
                {
                    // Write all data to the stream.
                    cypherEncrypt.Write(clearBytes, 0, clearBytes.Length);
                }
            }

            // Return the encrypted bytes from the memory stream.
            return targetStream.ToArray();
        }

        /// <summary>
        /// Copies the stream.
        /// </summary>
        /// <param name="input">The input stream.</param>
        /// <param name="output">The output stream.</param>
        protected virtual void CopyStream(Stream input, Stream output)
        {
            byte[] b = new byte[32768];
            int r;
            while ((r = input.Read(b, 0, b.Length)) > 0)
            {
                output.Write(b, 0, r);
            }
        }
    }
}
