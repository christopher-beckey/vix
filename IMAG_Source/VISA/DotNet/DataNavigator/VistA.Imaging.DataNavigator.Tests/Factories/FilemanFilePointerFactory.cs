using System;
using Microsoft.Pex.Framework;
using VistA.Imaging.DataNavigator.Model;
using VistA.Imaging.DataNavigator.Repositories;

namespace VistA.Imaging.DataNavigator.Model
{
    /// <summary>A factory for VistA.Imaging.DataNavigator.Model.FilemanFilePointer instances</summary>
    public static partial class FilemanFilePointerFactory
    {
        /// <summary>A factory for VistA.Imaging.DataNavigator.Model.FilemanFilePointer instances</summary>
        [PexFactoryMethod(typeof(FilemanFilePointer))]
        public static FilemanFilePointer Create(
            IFilemanFileRepository fileRepository_iFilemanFileRepository,
            FilemanField sourceField_filemanField,
            string targetFileNumber_s
        )
        {
            FilemanFilePointer filemanFilePointer
               = new FilemanFilePointer(fileRepository_iFilemanFileRepository,
                                        sourceField_filemanField, targetFileNumber_s);
            return filemanFilePointer;
        }
    }
}
