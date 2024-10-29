// <copyright file="HierarchicalEntryLoadViewModelFactoryTest.Constructor.g.cs" company="Department of Veterans Affairs">Copyright � Department of Veterans Affairs 2011</copyright>
// <auto-generated>
// This file contains automatically generated unit tests.
// Do NOT modify this file manually.
// 
// When Pex is invoked again,
// it might remove or update any previously generated unit tests.
// 
// If the contents of this file becomes outdated, e.g. if it does not
// compile anymore, you may delete this file and invoke Pex again.
// </auto-generated>
using System;
using VistA.Imaging.DataNavigator.Repositories;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Pex.Framework.Generated;
using VistA.Imaging.DataNavigator.Repositories.Moles;

namespace VistA.Imaging.DataNavigator.ViewModels.Factories
{
    public partial class HierarchicalEntryLoadViewModelFactoryTest
    {
[TestMethod]
[PexGeneratedBy(typeof(HierarchicalEntryLoadViewModelFactoryTest))]
[ExpectedException(typeof(ArgumentNullException))]
public void ConstructorThrowsArgumentNullException991()
{
    HierarchicalEntryLoadViewModelFactory hierarchicalEntryLoadViewModelFactory;
    hierarchicalEntryLoadViewModelFactory =
      this.Constructor((IFilemanEntryRepository)null);
}
[TestMethod]
[PexGeneratedBy(typeof(HierarchicalEntryLoadViewModelFactoryTest))]
public void Constructor760()
{
    SIFilemanEntryRepository sIFilemanEntryRepository;
    HierarchicalEntryLoadViewModelFactory hierarchicalEntryLoadViewModelFactory;
    sIFilemanEntryRepository = new SIFilemanEntryRepository();
    hierarchicalEntryLoadViewModelFactory =
      this.Constructor((IFilemanEntryRepository)sIFilemanEntryRepository);
    Assert.IsNotNull((object)hierarchicalEntryLoadViewModelFactory);
    Assert.IsNull
        (hierarchicalEntryLoadViewModelFactory.HierarchicalEntryViewModelFactory);
}
    }
}