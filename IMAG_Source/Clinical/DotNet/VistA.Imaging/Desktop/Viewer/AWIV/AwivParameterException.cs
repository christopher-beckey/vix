// -----------------------------------------------------------------------
// <copyright file="AwivParameterException.cs" company="Department of Veterans Affairs">
// Department of Veterans Affairs
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.Viewer.AWIV
{
    using System;
    using System.Net;
    using System.Windows;
    using System.Windows.Controls;
    using System.Windows.Documents;
    using System.Windows.Ink;
    using System.Windows.Input;
    using System.Windows.Media;
    using System.Windows.Media.Animation;
    using System.Windows.Shapes;

    /// <summary>
    /// AWIV Parameter Exception
    /// </summary>
    public class AwivParameterException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AwivParameterException"/> class.
        /// </summary>
        public AwivParameterException()
            : base()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AwivParameterException"/> class.
        /// </summary>
        /// <param name="message">The message.</param>
        public AwivParameterException(string message)
            : base(message)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AwivParameterException"/> class.
        /// </summary>
        /// <param name="message">The error message that explains the reason for the exception.</param>
        /// <param name="innerException">The exception that is the cause of the current exception, or a null reference (Nothing in Visual Basic) if no inner exception is specified.</param>
        public AwivParameterException(string message, Exception innerException)
            : base(message, innerException)
        {
        }
    }
}
