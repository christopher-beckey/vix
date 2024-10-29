// -----------------------------------------------------------------------
// <copyright file="StringExtensions.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging
{
    using System.Diagnostics.Contracts;
    using System.Text.RegularExpressions;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public static class StringExtensions
    {
        /// <summary>
        /// Determines whether the specified string is in base64 format.
        /// </summary>
        /// <param name="s">The string.</param>
        /// <returns>
        ///   <c>true</c> if the specified string is base64 encoded; otherwise, <c>false</c>.
        /// </returns>
        [Pure]
        public static bool IsBase64String(this string s)
        {
            s = s.Trim();
            return (s.Length % 4 == 0) && Regex.IsMatch(s, @"^[a-zA-Z0-9\+/]*={0,3}$", RegexOptions.None);
        }
    }
}
