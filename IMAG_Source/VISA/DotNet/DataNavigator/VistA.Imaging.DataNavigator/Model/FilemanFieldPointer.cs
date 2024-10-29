// -----------------------------------------------------------------------
// <copyright file="FilemanFieldPointer.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Model
{
    using System;
    using System.Diagnostics.Contracts;
    using VistA.Imaging.DataNavigator.Repositories;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class FilemanFieldPointer : FilemanFilePointer
    {
        /// <summary>
        /// The backing field for the TargetField property
        /// </summary>
        private FilemanField targetFieldBackingField;

        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanFieldPointer"/> class.
        /// </summary>
        /// <param name="fileRepository">The file repository.</param>
        /// <param name="sourceField">The source field.</param>
        /// <param name="targetFileNumber">The target file number.</param>
        /// <param name="targetfieldNumber">The targetfield number.</param>
        public FilemanFieldPointer(
            IFilemanFileRepository fileRepository,
            FilemanField sourceField,
            string targetFileNumber,
            string targetfieldNumber)
            : base(fileRepository, sourceField, targetFileNumber)
        {
            Contract.Requires<ArgumentException>(!String.IsNullOrWhiteSpace(targetfieldNumber));
            this.TargetFieldNumber = targetfieldNumber;
        }

        /// <summary>
        /// Gets the pointer target.
        /// </summary>
        public FilemanField TargetField
        {
            get
            {
                if (this.targetFieldBackingField == null && this.TargetFile != null)
                {
                    this.targetFieldBackingField = this.TargetFile[this.TargetFieldNumber];
                }

                return this.targetFieldBackingField;
            }
        }

        /// <summary>
        /// Gets the target field number.
        /// </summary>
        protected string TargetFieldNumber { get; private set; }
    }
}
