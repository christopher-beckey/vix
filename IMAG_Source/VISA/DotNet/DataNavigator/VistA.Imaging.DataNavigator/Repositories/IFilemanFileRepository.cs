// -----------------------------------------------------------------------
// <copyright file="IFilemanFileRepository.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataNavigator.Repositories
{
    using System;
    using VistA.Imaging.DataNavigator.Model;

    /// <summary>
    /// Repository for getting fileman files
    /// </summary>
    public interface IFilemanFileRepository : ICachingRepository<FilemanFile, string>
    {
        void GetByIdAsync(string id, Action<FilemanFile> callback);
    }
}
