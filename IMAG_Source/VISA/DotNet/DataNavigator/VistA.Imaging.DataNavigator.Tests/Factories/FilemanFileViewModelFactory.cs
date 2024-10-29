using System;
using Microsoft.Pex.Framework;
using VistA.Imaging.DataNavigator.ViewModels;
using ImagingClient.Infrastructure.Prism.Mvvm;
using VistA.Imaging.DataNavigator.Model;
using System.Windows.Threading;

namespace VistA.Imaging.DataNavigator.ViewModels
{
    /// <summary>A factory for VistA.Imaging.DataNavigator.ViewModels.FilemanFileViewModel instances</summary>
    public static partial class FilemanFileViewModelFactory
    {
        /// <summary>A factory for VistA.Imaging.DataNavigator.ViewModels.FilemanFileViewModel instances</summary>
        [PexFactoryMethod(typeof(FilemanFileViewModel))]
        public static FilemanFileViewModel Create(
            FilemanFile file_filemanFile,
            bool value_b,
            bool value_b1,
            Dispatcher value_dispatcher
        )
        {
            FilemanFileViewModel filemanFileViewModel
               = new FilemanFileViewModel(file_filemanFile);
            filemanFileViewModel.IsSelected = value_b;
            ((ViewModel)filemanFileViewModel).IsActive = value_b1;
            ((ViewModel)filemanFileViewModel).UIDispatcher = value_dispatcher;
            return filemanFileViewModel;

            // TODO: Edit factory method of FilemanFileViewModel
            // This method should be able to configure the object in all possible ways.
            // Add as many parameters as needed,
            // and assign their values to each field by using the API.
        }
    }
}
