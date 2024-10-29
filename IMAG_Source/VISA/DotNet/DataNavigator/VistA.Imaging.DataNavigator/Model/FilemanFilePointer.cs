// -----------------------------------------------------------------------
// <copyright file="FilemanFilePointer.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Model
{
    using System;
    using VistA.Imaging.DataNavigator.Repositories;
    using System.Diagnostics.Contracts;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class FilemanFilePointer
    {
        /// <summary>
        /// The backing field for the TargetFile property.
        /// </summary>
        private FilemanFile targetFileBackingField;

        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanFilePointer"/> class.
        /// </summary>
        /// <param name="fileRepository">The file repository.</param>
        /// <param name="sourceField">The source field.</param>
        /// <param name="targetFileNumber">The target file number.</param>
        public FilemanFilePointer(IFilemanFileRepository fileRepository, FilemanField sourceField, string targetFileNumber)
        {
            Contract.Requires<ArgumentNullException>(fileRepository != null);
            Contract.Requires<ArgumentNullException>(sourceField != null);
            Contract.Requires<ArgumentException>(!String.IsNullOrWhiteSpace(targetFileNumber));
            this.FileRepository = fileRepository;
            this.SourceField = sourceField;
            this.TargetFileNumber = targetFileNumber;
        }

        /// <summary>
        /// Gets the pointer source.
        /// </summary>
        public virtual FilemanField SourceField { get; private set; }

        /// <summary>
        /// Gets the pointer target file.
        /// </summary>
        public virtual FilemanFile TargetFile
        {
            get
            {
                if (this.targetFileBackingField == null)
                {
                    this.targetFileBackingField = this.FileRepository.GetById(this.TargetFileNumber);
                }

                return this.targetFileBackingField;
            }
        }

        /// <summary>
        /// Gets the file repository.
        /// </summary>
        protected virtual IFilemanFileRepository FileRepository { get; private set; }

        /// <summary>
        /// Gets the target file number.
        /// </summary>
        protected virtual string TargetFileNumber { get; private set; }

        public override string ToString()
        {
            return this.TargetFile.Number;
        }
    }
}
