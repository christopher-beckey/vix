// <copyright file="HierarchicalEntryLoadViewModelFactoryFactory.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>

using System;
using Microsoft.Pex.Framework;
using VistA.Imaging.DataNavigator.ViewModels;
using VistA.Imaging.DataNavigator.Repositories;
using VistA.Imaging.DataNavigator.ViewModels.Factories;

namespace VistA.Imaging.DataNavigator.ViewModels
{
    /// <summary>A factory for VistA.Imaging.DataNavigator.ViewModels.HierarchicalEntryLoadViewModelFactory instances</summary>
    public static partial class HierarchicalEntryLoadViewModelFactoryFactory
    {
        /// <summary>A factory for VistA.Imaging.DataNavigator.ViewModels.HierarchicalEntryLoadViewModelFactory instances</summary>
        [PexFactoryMethod(typeof(HierarchicalEntryLoadViewModelFactory))]
        public static HierarchicalEntryLoadViewModelFactory Create(
            IFilemanEntryRepository entryRepository_iFilemanEntryRepository,
            IHierarchicalEntryViewModelFactory value_iHierarchicalEntryViewModelFactory
        )
        {
            HierarchicalEntryLoadViewModelFactory hierarchicalEntryLoadViewModelFactory
               = new HierarchicalEntryLoadViewModelFactory
                     (entryRepository_iFilemanEntryRepository);
            hierarchicalEntryLoadViewModelFactory.HierarchicalEntryViewModelFactory =
              value_iHierarchicalEntryViewModelFactory;
            return hierarchicalEntryLoadViewModelFactory;

            // TODO: Edit factory method of HierarchicalEntryLoadViewModelFactory
            // This method should be able to configure the object in all possible ways.
            // Add as many parameters as needed,
            // and assign their values to each field by using the API.
        }
    }
}
