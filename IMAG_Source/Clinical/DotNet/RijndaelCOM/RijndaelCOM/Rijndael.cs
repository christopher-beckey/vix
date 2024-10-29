//-----------------------------------------------------------------------
// <copyright file="Rijndael.cs" company="Department of Veterans Affairs">
//     Copyright (c) Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace VistA.Imaging.RijndaelCOM
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Runtime.InteropServices;
    using System.Security.Cryptography;
    using System.Text;

    /// <summary>
    /// Rijndael Encryption
    /// </summary>
    /// <remarks>
    /// Supports COM interface
    /// </remarks>
    [ComVisible(true), Guid("cf0cba9b-7268-4792-a675-be10ae9e8011")]
    [ProgId("VistAImaging.Rijndael")]
    [ClassInterface(ClassInterfaceType.None)]
    public class Rijndael : IRijndael
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="Rijndael"/> class.
        /// </summary>
        public Rijndael()
        {
            // set defaults
            this.BlockSize = 128;
            this.KeySize = 128;
            this.Padding = PaddingMode.PKCS7;
            this.Mode = CipherMode.ECB;
        }

        /// <summary>
        /// Gets or sets the encryption key.
        /// </summary>
        public byte[] Key { get; set; }

        /// <summary>
        /// Gets or sets the size of the block.
        /// </summary>
        public int BlockSize { get; set; }

        /// <summary>
        /// Gets or sets the size of the key.
        /// </summary>
        public int KeySize { get; set; }

        /// <summary>
        /// Gets or sets the padding mode.
        /// </summary>
        public PaddingMode Padding { get; set; }

        /// <summary>
        /// Gets or sets the mode.
        /// </summary>
        public CipherMode Mode { get; set; }

        /// <summary>
        /// Gets or sets the key string.
        /// </summary>
        public string KeyString
        {
            get { return Encoding.ASCII.GetString(this.Key); }
            set { this.Key = Encoding.ASCII.GetBytes(value); }
        }

        /// <summary>
        /// Decrypts the specified cipher bytes.
        /// </summary>
        /// <param name="cipherBytes">The cipher bytes.</param>
        /// <param name="iv">The initialization vector.</param>
        /// <returns>The decrypted bytes</returns>
        public byte[] Decrypt(byte[] cipherBytes, byte[] iv)
        {
            // Check arguments.
            if (cipherBytes == null || cipherBytes.Length <= 0)
            {
                throw new ArgumentNullException("cipherBytes");
            }

            if (iv == null || iv.Length <= 0)
            {
                throw new ArgumentNullException("iv");
            }

            // Declare the RijndaelManaged object
            // used to decrypt the data.
            RijndaelManaged aesAlg = null;

            // Declare the string used to hold
            // the decrypted text.
            byte[] clearBytes = null;

            try
            {
                // Create a RijndaelManaged object
                // with the specified key and IV.
                aesAlg = new RijndaelManaged()
                {
                    BlockSize = this.BlockSize,
                    KeySize = this.KeySize,
                    Padding = this.Padding,
                    Mode = this.Mode
                };
                aesAlg.Key = this.Key;
                aesAlg.IV = iv;

                // Create a decrytor to perform the stream transform.
                ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);

                // Create the streams used for decryption.
                using (MemoryStream targetStream = new MemoryStream(cipherBytes))
                {
                    using (CryptoStream cypherStream = new CryptoStream(targetStream, decryptor, CryptoStreamMode.Read))
                    {
                        using (MemoryStream sourceStream = new MemoryStream())
                        {
                            CopyStream(cypherStream, sourceStream);
                            clearBytes = sourceStream.ToArray();
                        }
                    }
                }
            }
            finally
            {
                // Clear the RijndaelManaged object.
                if (aesAlg != null)
                {
                    aesAlg.Clear();
                }
            }

            return clearBytes;
        }

        /// <summary>
        /// Decrypts the base64 to string.
        /// </summary>
        /// <param name="cipherText">The cipher text.</param>
        /// <param name="asciiIv">The ASCII iv.</param>
        /// <returns>The decrypted string</returns>
        public string DecryptBase64ToString(string cipherText, string asciiIv)
        {
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            byte[] vectorBytes = Encoding.ASCII.GetBytes(asciiIv);
            byte[] clearBytes = this.Decrypt(cipherBytes, vectorBytes);
            return Encoding.ASCII.GetString(clearBytes);
        }

        /// <summary>
        /// Encrypts the specified clear bytes.
        /// </summary>
        /// <param name="clearBytes">The clear bytes.</param>
        /// <param name="iv">The initialization vector.</param>
        /// <returns>The encrypted bytes</returns>
        public byte[] Encrypt(byte[] clearBytes, byte[] iv)
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

            // Declare the RijndaelManaged object
            // used to encrypt the data.
            RijndaelManaged aesAlg = null;

            try
            {
                // Create a RijndaelManaged object
                // with the specified key and IV.
                aesAlg = new RijndaelManaged()
                {
                    BlockSize = this.BlockSize,
                    KeySize = this.KeySize,
                    Padding = this.Padding,
                    Mode = this.Mode
                };
                aesAlg.Key = this.Key;
                aesAlg.IV = iv;

                // Create an encryptor to perform the stream transform.
                ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);

                // Create the streams used for encryption.
                targetStream = new MemoryStream();
                using (CryptoStream cypherEncrypt = new CryptoStream(targetStream, encryptor, CryptoStreamMode.Write))
                {
                    // Write all data to the stream.
                    cypherEncrypt.Write(clearBytes, 0, clearBytes.Length);
                }
            }
            finally
            {
                // Clear the RijndaelManaged object.
                if (aesAlg != null)
                {
                    aesAlg.Clear();
                }
            }

            // Return the encrypted bytes from the memory stream.
            return targetStream.ToArray();
            throw new NotImplementedException();
        }

        /// <summary>
        /// Encrypts the string to base64.
        /// </summary>
        /// <param name="clearText">The clear text.</param>
        /// <param name="asciiIv">The ASCII iv.</param>
        /// <returns>The encrypted string</returns>
        public string EncryptStringToBase64(string clearText, string asciiIv)
        {
            byte[] clearBytes = Encoding.ASCII.GetBytes(clearText);
            byte[] vectorBytes = Encoding.ASCII.GetBytes(asciiIv);
            byte[] cipherBytes = this.Encrypt(clearBytes, vectorBytes);
            return Convert.ToBase64String(cipherBytes);
        }

        /// <summary>
        /// Copies the stream.
        /// </summary>
        /// <param name="input">The input stream.</param>
        /// <param name="output">The output stream.</param>
        private static void CopyStream(Stream input, Stream output)
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
