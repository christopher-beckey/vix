// -----------------------------------------------------------------------
// <copyright file="KeySizesExtensions.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Security.Cryptography
{
    using System.Collections.Generic;
    using System.Diagnostics.Contracts;
    using System.Linq;
    using System.Security.Cryptography;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public static class KeySizesExtensions
    {
        /// <summary>
        /// Determines whether the specified size is valid.
        /// </summary>
        /// <param name="sizes">The sizes.</param>
        /// <param name="targetKeySize">Size of the target key.</param>
        /// <returns>
        ///   <c>true</c> if the specified sizes is valid; otherwise, <c>false</c>.
        /// </returns>
        [Pure]
        public static bool IsValid(this KeySizes sizes, int targetKeySize)
        {
            return sizes.MinSize <= targetKeySize && targetKeySize <= sizes.MaxSize
                && (targetKeySize - sizes.MinSize) % sizes.SkipSize == 0;
        }

        /// <summary>
        /// Determines whether the specified size is valid.
        /// </summary>
        /// <param name="sizes">The sizes.</param>
        /// <param name="targetKeySize">Size of the target key.</param>
        /// <returns>
        ///   <c>true</c> if the specified sizes is valid; otherwise, <c>false</c>.
        /// </returns>
        [Pure]
        public static bool IsValid(this IEnumerable<KeySizes> sizes, int targetKeySize)
        {
            return sizes.Any(s => s.IsValid(targetKeySize));
        }
    }
}
