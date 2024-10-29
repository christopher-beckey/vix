//-----------------------------------------------------------------------
// <copyright file="IRijndael.cs" company="Department of Veterans Affairs">
//     Copyright (c) Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace VistA.Imaging.RijndaelCOM
{
    using System;
    using System.Runtime.InteropServices;
    using System.Security.Cryptography;

    /// <summary>
    /// Rijndael Encryption
    /// </summary>
    /// <remarks>
    /// Supports COM interface
    /// </remarks>
    [ComVisible(true), Guid("136cc5c2-3c14-4b2c-8681-3336f3ee6871")]
    [InterfaceType(ComInterfaceType.InterfaceIsDual)]
    public interface IRijndael
    {
        /// <summary>
        /// Gets or sets the encryption key.
        /// </summary>
        byte[] Key { get; set; }

        /// <summary>
        /// Gets or sets the size of the block.
        /// </summary>
        int BlockSize { get; set; }

        /// <summary>
        /// Gets or sets the size of the key.
        /// </summary>
        int KeySize { get; set; }

        /// <summary>
        /// Gets or sets the padding mode.
        /// </summary>
        PaddingMode Padding { get; set; }

        /// <summary>
        /// Gets or sets the mode.
        /// </summary>
        CipherMode Mode { get; set; }

        /// <summary>
        /// Gets or sets the key string.
        /// </summary>
        string KeyString { get; set; }

        /// <summary>
        /// Decrypts the specified cipher bytes.
        /// </summary>
        /// <param name="cipherBytes">The cipher bytes.</param>
        /// <param name="iv">The initialization vector.</param>
        /// <returns>The decrypted bytes</returns>
        byte[] Decrypt(byte[] cipherBytes, byte[] iv);

        /// <summary>
        /// Decrypts the base64 to string.
        /// </summary>
        /// <param name="cipherText">The cipher text.</param>
        /// <param name="asciiIv">The ASCII iv.</param>
        /// <returns>The decrypted string</returns>
        string DecryptBase64ToString(string cipherText, string asciiIv);

        /// <summary>
        /// Encrypts the specified clear bytes.
        /// </summary>
        /// <param name="clearBytes">The clear bytes.</param>
        /// <param name="iv">The initialization vector.</param>
        /// <returns>The encrypted bytes</returns>
        byte[] Encrypt(byte[] clearBytes, byte[] iv);

        /// <summary>
        /// Encrypts the string to base64.
        /// </summary>
        /// <param name="clearText">The clear text.</param>
        /// <param name="asciiIv">The ASCII iv.</param>
        /// <returns>The encrypted string</returns>
        string EncryptStringToBase64(string clearText, string asciiIv);
    }
}
