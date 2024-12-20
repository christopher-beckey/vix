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
using VistA.Imaging.DataNavigator.Repositories.Moles;
using VistA.Imaging.DataNavigator.ViewModels.Factories.Moles;
using VistA.Imaging.DataNavigator.Model;
using VistA.Imaging.DataNavigator.Repositories;
using VistA.Imaging.DataNavigator.ViewModels.Factories;
using ImagingClient.Infrastructure.Prism.Mvvm;
using System.Windows.Threading;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Pex.Framework.Generated;
using Microsoft.Pex.Framework.Moles;
using VistA.Imaging.DataNavigator.ViewModels.Moles;
using Microsoft.Pex.Framework;

namespace VistA.Imaging.DataNavigator.ViewModels
{
    public partial class HierarchicalEntryViewModelTest
    {
[TestMethod]
[PexGeneratedBy(typeof(HierarchicalEntryViewModelTest))]
public void ParentSet79()
{
    SIFilemanEntryRepository sIFilemanEntryRepository;
    SIHierarchicalEntryViewModelFactory sIHierarchicalEntryViewModelFactory;
    SIHierarchicalEntryLoadViewModelFactory sIHierarchicalEntryLoadViewModelFactory;
    HierarchicalEntryViewModel hierarchicalEntryViewModel;
    sIFilemanEntryRepository = new SIFilemanEntryRepository();
    sIHierarchicalEntryViewModelFactory = new SIHierarchicalEntryViewModelFactory();
    sIHierarchicalEntryLoadViewModelFactory =
      new SIHierarchicalEntryLoadViewModelFactory();
    FilemanEntry s0 = new FilemanEntry();
    s0.Ien = (string)null;
    FilemanFile s1 = new FilemanFile();
    s1.Name = (string)null;
    s1.Number = (string)null;
    s1.Fields = (FilemanField[])null;
    s0.File = s1;
    s0.Values = (FilemanFieldValue[])null;
    hierarchicalEntryViewModel =
      new HierarchicalEntryViewModel(s0, (FilemanField)null, (FilemanField)null, 
                                     (IFilemanEntryRepository)sIFilemanEntryRepository, 
                                     (IHierarchicalEntryViewModelFactory)sIHierarchicalEntryViewModelFactory, 
                                     (IHierarchicalEntryLoadViewModelFactory)
                                       sIHierarchicalEntryLoadViewModelFactory);
    hierarchicalEntryViewModel.Parent = (TreeNodeViewModel)null;
    hierarchicalEntryViewModel.IsExpanded = false;
    ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected = false;
    ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded = false;
    ((ViewModel)hierarchicalEntryViewModel).IsActive = false;
    ((ViewModel)hierarchicalEntryViewModel).UIDispatcher = (Dispatcher)null;
    this.ParentSet(hierarchicalEntryViewModel, (TreeNodeViewModel)null);
    Assert.IsNotNull((object)hierarchicalEntryViewModel);
    Assert.IsNotNull(hierarchicalEntryViewModel.File);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Name);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Number);
    Assert.IsNull(hierarchicalEntryViewModel.File.Fields);
    Assert.IsNotNull(hierarchicalEntryViewModel.Entry);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.Entry.Ien);
    Assert.IsNotNull(hierarchicalEntryViewModel.Entry.File);
    Assert.IsTrue(object.ReferenceEquals
                      (hierarchicalEntryViewModel.Entry.File, hierarchicalEntryViewModel.File));
    Assert.IsNull(hierarchicalEntryViewModel.Entry.Values);
    Assert.IsNull(hierarchicalEntryViewModel.Parent);
    Assert.IsNull(hierarchicalEntryViewModel.ParentPointerField);
    Assert.AreEqual<bool>(false, hierarchicalEntryViewModel.IsExpanded);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsExpanded);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded);
    Assert.IsNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Parent);
    Assert.IsNotNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Children);
    Assert.AreEqual<bool>(false, ((ViewModel)hierarchicalEntryViewModel).IsActive);
    Assert.IsNull(((ViewModel)hierarchicalEntryViewModel).UIDispatcher);
}
[TestMethod]
[PexGeneratedBy(typeof(HierarchicalEntryViewModelTest))]
public void ParentSet986()
{
    SIFilemanEntryRepository sIFilemanEntryRepository;
    SIHierarchicalEntryViewModelFactory sIHierarchicalEntryViewModelFactory;
    SIHierarchicalEntryLoadViewModelFactory sIHierarchicalEntryLoadViewModelFactory;
    HierarchicalEntryViewModel hierarchicalEntryViewModel;
    sIFilemanEntryRepository = new SIFilemanEntryRepository();
    sIHierarchicalEntryViewModelFactory = new SIHierarchicalEntryViewModelFactory();
    sIHierarchicalEntryLoadViewModelFactory =
      new SIHierarchicalEntryLoadViewModelFactory();
    FilemanEntry s0 = new FilemanEntry();
    s0.Ien = (string)null;
    FilemanFile s1 = new FilemanFile();
    s1.Name = (string)null;
    s1.Number = (string)null;
    s1.Fields = (FilemanField[])null;
    s0.File = s1;
    s0.Values = (FilemanFieldValue[])null;
    hierarchicalEntryViewModel =
      new HierarchicalEntryViewModel(s0, (FilemanField)null, (FilemanField)null, 
                                     (IFilemanEntryRepository)sIFilemanEntryRepository, 
                                     (IHierarchicalEntryViewModelFactory)sIHierarchicalEntryViewModelFactory, 
                                     (IHierarchicalEntryLoadViewModelFactory)
                                       sIHierarchicalEntryLoadViewModelFactory);
    hierarchicalEntryViewModel.Parent = (TreeNodeViewModel)null;
    hierarchicalEntryViewModel.IsExpanded = false;
    ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected = false;
    ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded = false;
    ((ViewModel)hierarchicalEntryViewModel).IsActive = true;
    ((ViewModel)hierarchicalEntryViewModel).UIDispatcher = (Dispatcher)null;
    this.ParentSet(hierarchicalEntryViewModel, (TreeNodeViewModel)null);
    Assert.IsNotNull((object)hierarchicalEntryViewModel);
    Assert.IsNotNull(hierarchicalEntryViewModel.File);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Name);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Number);
    Assert.IsNull(hierarchicalEntryViewModel.File.Fields);
    Assert.IsNotNull(hierarchicalEntryViewModel.Entry);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.Entry.Ien);
    Assert.IsNotNull(hierarchicalEntryViewModel.Entry.File);
    Assert.IsTrue(object.ReferenceEquals
                      (hierarchicalEntryViewModel.Entry.File, hierarchicalEntryViewModel.File));
    Assert.IsNull(hierarchicalEntryViewModel.Entry.Values);
    Assert.IsNull(hierarchicalEntryViewModel.Parent);
    Assert.IsNull(hierarchicalEntryViewModel.ParentPointerField);
    Assert.AreEqual<bool>(false, hierarchicalEntryViewModel.IsExpanded);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsExpanded);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded);
    Assert.IsNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Parent);
    Assert.IsNotNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Children);
    Assert.AreEqual<bool>(true, ((ViewModel)hierarchicalEntryViewModel).IsActive);
    Assert.IsNull(((ViewModel)hierarchicalEntryViewModel).UIDispatcher);
}
[TestMethod]
[PexGeneratedBy(typeof(HierarchicalEntryViewModelTest))]
public void ParentSet241()
{
    using (PexChooseBehavedBehavior.Setup())
    {
      SIFilemanEntryRepository sIFilemanEntryRepository;
      SIHierarchicalEntryViewModelFactory sIHierarchicalEntryViewModelFactory;
      SIHierarchicalEntryLoadViewModelFactory 
        sIHierarchicalEntryLoadViewModelFactory;
      HierarchicalEntryViewModel hierarchicalEntryViewModel;
      sIFilemanEntryRepository = new SIFilemanEntryRepository();
      sIHierarchicalEntryViewModelFactory =
        new SIHierarchicalEntryViewModelFactory();
      sIHierarchicalEntryLoadViewModelFactory =
        new SIHierarchicalEntryLoadViewModelFactory();
      FilemanEntry s0 = new FilemanEntry();
      s0.Ien = (string)null;
      FilemanFile s1 = new FilemanFile();
      s1.Name = (string)null;
      s1.Number = (string)null;
      s1.Fields = (FilemanField[])null;
      s0.File = s1;
      s0.Values = (FilemanFieldValue[])null;
      FilemanField s2 = new FilemanField();
      s2.DataType = (string)null;
      s2.File = (FilemanFile)null;
      s2.IsIndexed = false;
      s2.Name = (string)null;
      s2.Number = (string)null;
      s2.Pointer = (FilemanFilePointer)null;
      s2.PointerFileNumber = (string)null;
      hierarchicalEntryViewModel =
        new HierarchicalEntryViewModel(s0, s2, (FilemanField)null, 
                                       (IFilemanEntryRepository)sIFilemanEntryRepository, 
                                       (IHierarchicalEntryViewModelFactory)sIHierarchicalEntryViewModelFactory, 
                                       (IHierarchicalEntryLoadViewModelFactory)
                                         sIHierarchicalEntryLoadViewModelFactory);
      hierarchicalEntryViewModel.Parent = (TreeNodeViewModel)null;
      hierarchicalEntryViewModel.IsExpanded = false;
      ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected = false;
      ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded = false;
      ((ViewModel)hierarchicalEntryViewModel).IsActive = false;
      ((ViewModel)hierarchicalEntryViewModel).UIDispatcher = (Dispatcher)null;
      this.ParentSet(hierarchicalEntryViewModel, (TreeNodeViewModel)null);
      Assert.IsNotNull((object)hierarchicalEntryViewModel);
      Assert.IsNotNull(hierarchicalEntryViewModel.File);
      Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Name);
      Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Number);
      Assert.IsNull(hierarchicalEntryViewModel.File.Fields);
      Assert.IsNotNull(hierarchicalEntryViewModel.Entry);
      Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.Entry.Ien);
      Assert.IsNotNull(hierarchicalEntryViewModel.Entry.File);
      Assert.IsTrue(object.ReferenceEquals(hierarchicalEntryViewModel.Entry.File, 
                                           hierarchicalEntryViewModel.File));
      Assert.IsNull(hierarchicalEntryViewModel.Entry.Values);
      Assert.IsNull(hierarchicalEntryViewModel.Parent);
      Assert.IsNull(hierarchicalEntryViewModel.ParentPointerField);
      Assert.AreEqual<bool>(false, hierarchicalEntryViewModel.IsExpanded);
      Assert.AreEqual<bool>
          (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected);
      Assert.AreEqual<bool>
          (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsExpanded);
      Assert.AreEqual<bool>
          (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded);
      Assert.IsNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Parent);
      Assert.IsNotNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Children);
      Assert.AreEqual<bool>(false, ((ViewModel)hierarchicalEntryViewModel).IsActive);
      Assert.IsNull(((ViewModel)hierarchicalEntryViewModel).UIDispatcher);
    }
}
[TestMethod]
[PexGeneratedBy(typeof(HierarchicalEntryViewModelTest))]
public void ParentSet988()
{
    SIFilemanEntryRepository sIFilemanEntryRepository;
    SIHierarchicalEntryViewModelFactory sIHierarchicalEntryViewModelFactory;
    SIHierarchicalEntryLoadViewModelFactory sIHierarchicalEntryLoadViewModelFactory;
    HierarchicalEntryViewModel hierarchicalEntryViewModel;
    sIFilemanEntryRepository = new SIFilemanEntryRepository();
    sIHierarchicalEntryViewModelFactory = new SIHierarchicalEntryViewModelFactory();
    sIHierarchicalEntryLoadViewModelFactory =
      new SIHierarchicalEntryLoadViewModelFactory();
    FilemanEntry s0 = new FilemanEntry();
    s0.Ien = (string)null;
    FilemanFile s1 = new FilemanFile();
    s1.Name = (string)null;
    s1.Number = (string)null;
    s1.Fields = (FilemanField[])null;
    s0.File = s1;
    s0.Values = (FilemanFieldValue[])null;
    hierarchicalEntryViewModel =
      new HierarchicalEntryViewModel(s0, (FilemanField)null, (FilemanField)null, 
                                     (IFilemanEntryRepository)sIFilemanEntryRepository, 
                                     (IHierarchicalEntryViewModelFactory)sIHierarchicalEntryViewModelFactory, 
                                     (IHierarchicalEntryLoadViewModelFactory)
                                       sIHierarchicalEntryLoadViewModelFactory);
    hierarchicalEntryViewModel.Parent = (TreeNodeViewModel)null;
    hierarchicalEntryViewModel.IsExpanded = true;
    ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected = false;
    ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded = false;
    ((ViewModel)hierarchicalEntryViewModel).IsActive = false;
    ((ViewModel)hierarchicalEntryViewModel).UIDispatcher = (Dispatcher)null;
    this.ParentSet(hierarchicalEntryViewModel, (TreeNodeViewModel)null);
    Assert.IsNotNull((object)hierarchicalEntryViewModel);
    Assert.IsNotNull(hierarchicalEntryViewModel.File);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Name);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Number);
    Assert.IsNull(hierarchicalEntryViewModel.File.Fields);
    Assert.IsNotNull(hierarchicalEntryViewModel.Entry);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.Entry.Ien);
    Assert.IsNotNull(hierarchicalEntryViewModel.Entry.File);
    Assert.IsTrue(object.ReferenceEquals
                      (hierarchicalEntryViewModel.Entry.File, hierarchicalEntryViewModel.File));
    Assert.IsNull(hierarchicalEntryViewModel.Entry.Values);
    Assert.IsNull(hierarchicalEntryViewModel.Parent);
    Assert.IsNull(hierarchicalEntryViewModel.ParentPointerField);
    Assert.AreEqual<bool>(true, hierarchicalEntryViewModel.IsExpanded);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected);
    Assert.AreEqual<bool>
        (true, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsExpanded);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded);
    Assert.IsNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Parent);
    Assert.IsNotNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Children);
    Assert.AreEqual<bool>(false, ((ViewModel)hierarchicalEntryViewModel).IsActive);
    Assert.IsNull(((ViewModel)hierarchicalEntryViewModel).UIDispatcher);
}
[TestMethod]
[PexGeneratedBy(typeof(HierarchicalEntryViewModelTest))]
public void ParentSet383()
{
    SIFilemanEntryRepository sIFilemanEntryRepository;
    SIHierarchicalEntryViewModelFactory sIHierarchicalEntryViewModelFactory;
    SIHierarchicalEntryLoadViewModelFactory sIHierarchicalEntryLoadViewModelFactory;
    SHierarchicalEntryViewModel sHierarchicalEntryViewModel;
    HierarchicalEntryViewModel hierarchicalEntryViewModel;
    sIFilemanEntryRepository = new SIFilemanEntryRepository();
    sIHierarchicalEntryViewModelFactory = new SIHierarchicalEntryViewModelFactory();
    sIHierarchicalEntryLoadViewModelFactory =
      new SIHierarchicalEntryLoadViewModelFactory();
    sHierarchicalEntryViewModel = new SHierarchicalEntryViewModel();
    FilemanEntry s0 = new FilemanEntry();
    s0.Ien = (string)null;
    FilemanFile s1 = new FilemanFile();
    s1.Name = (string)null;
    s1.Number = (string)null;
    s1.Fields = (FilemanField[])null;
    s0.File = s1;
    s0.Values = (FilemanFieldValue[])null;
    hierarchicalEntryViewModel =
      new HierarchicalEntryViewModel(s0, (FilemanField)null, (FilemanField)null, 
                                     (IFilemanEntryRepository)sIFilemanEntryRepository, 
                                     (IHierarchicalEntryViewModelFactory)sIHierarchicalEntryViewModelFactory, 
                                     (IHierarchicalEntryLoadViewModelFactory)
                                       sIHierarchicalEntryLoadViewModelFactory);
    hierarchicalEntryViewModel.Parent =
      (TreeNodeViewModel)sHierarchicalEntryViewModel;
    hierarchicalEntryViewModel.IsExpanded = false;
    ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected = false;
    ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded = false;
    ((ViewModel)hierarchicalEntryViewModel).IsActive = false;
    ((ViewModel)hierarchicalEntryViewModel).UIDispatcher = (Dispatcher)null;
    this.ParentSet(hierarchicalEntryViewModel, (TreeNodeViewModel)null);
    Assert.IsNotNull((object)hierarchicalEntryViewModel);
    Assert.IsNotNull(hierarchicalEntryViewModel.File);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Name);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Number);
    Assert.IsNull(hierarchicalEntryViewModel.File.Fields);
    Assert.IsNotNull(hierarchicalEntryViewModel.Entry);
    Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.Entry.Ien);
    Assert.IsNotNull(hierarchicalEntryViewModel.Entry.File);
    Assert.IsTrue(object.ReferenceEquals
                      (hierarchicalEntryViewModel.Entry.File, hierarchicalEntryViewModel.File));
    Assert.IsNull(hierarchicalEntryViewModel.Entry.Values);
    Assert.IsNull(hierarchicalEntryViewModel.Parent);
    Assert.IsNull(hierarchicalEntryViewModel.ParentPointerField);
    Assert.AreEqual<bool>(false, hierarchicalEntryViewModel.IsExpanded);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsExpanded);
    Assert.AreEqual<bool>
        (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded);
    Assert.IsNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Parent);
    Assert.IsNotNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Children);
    Assert.AreEqual<bool>(false, ((ViewModel)hierarchicalEntryViewModel).IsActive);
    Assert.IsNull(((ViewModel)hierarchicalEntryViewModel).UIDispatcher);
}
[TestMethod]
[PexGeneratedBy(typeof(HierarchicalEntryViewModelTest))]
public void ParentSet121()
{
    using (PexChooseBehavedBehavior.Setup())
    {
      SIFilemanEntryRepository sIFilemanEntryRepository;
      SIHierarchicalEntryViewModelFactory sIHierarchicalEntryViewModelFactory;
      SIHierarchicalEntryLoadViewModelFactory 
        sIHierarchicalEntryLoadViewModelFactory;
      HierarchicalEntryViewModel hierarchicalEntryViewModel;
      sIFilemanEntryRepository = new SIFilemanEntryRepository();
      sIHierarchicalEntryViewModelFactory =
        new SIHierarchicalEntryViewModelFactory();
      sIHierarchicalEntryLoadViewModelFactory =
        new SIHierarchicalEntryLoadViewModelFactory();
      IPexChoiceRecorder choices = PexChoose.Replay.Setup();
      FilemanEntry s0 = new FilemanEntry();
      s0.Ien = (string)null;
      FilemanFile s1 = new FilemanFile();
      s1.Name = (string)null;
      s1.Number = (string)null;
      s1.Fields = (FilemanField[])null;
      s0.File = s1;
      s0.Values = (FilemanFieldValue[])null;
      FilemanField s2 = new FilemanField();
      s2.DataType = (string)null;
      s2.File = (FilemanFile)null;
      s2.IsIndexed = false;
      s2.Name = (string)null;
      s2.Number = (string)null;
      s2.Pointer = (FilemanFilePointer)null;
      s2.PointerFileNumber = (string)null;
      FilemanField s3 = new FilemanField();
      s3.DataType = (string)null;
      s3.File = (FilemanFile)null;
      s3.IsIndexed = false;
      s3.Name = (string)null;
      s3.Number = (string)null;
      s3.Pointer = (FilemanFilePointer)null;
      s3.PointerFileNumber = (string)null;
      hierarchicalEntryViewModel = new HierarchicalEntryViewModel
                                       (s0, s2, s3, (IFilemanEntryRepository)sIFilemanEntryRepository, 
                                                    (IHierarchicalEntryViewModelFactory)sIHierarchicalEntryViewModelFactory, 
                                                    (IHierarchicalEntryLoadViewModelFactory)
                                                      sIHierarchicalEntryLoadViewModelFactory);
      hierarchicalEntryViewModel.Parent = (TreeNodeViewModel)null;
      hierarchicalEntryViewModel.IsExpanded = true;
      ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected = false;
      ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded = false;
      ((ViewModel)hierarchicalEntryViewModel).IsActive = false;
      ((ViewModel)hierarchicalEntryViewModel).UIDispatcher = (Dispatcher)null;
      this.ParentSet(hierarchicalEntryViewModel, (TreeNodeViewModel)null);
      Assert.IsNotNull((object)hierarchicalEntryViewModel);
      Assert.IsNotNull(hierarchicalEntryViewModel.File);
      Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Name);
      Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.File.Number);
      Assert.IsNull(hierarchicalEntryViewModel.File.Fields);
      Assert.IsNotNull(hierarchicalEntryViewModel.Entry);
      Assert.AreEqual<string>((string)null, hierarchicalEntryViewModel.Entry.Ien);
      Assert.IsNotNull(hierarchicalEntryViewModel.Entry.File);
      Assert.IsTrue(object.ReferenceEquals(hierarchicalEntryViewModel.Entry.File, 
                                           hierarchicalEntryViewModel.File));
      Assert.IsNull(hierarchicalEntryViewModel.Entry.Values);
      Assert.IsNull(hierarchicalEntryViewModel.Parent);
      Assert.IsNotNull(hierarchicalEntryViewModel.ParentPointerField);
      Assert.AreEqual<string>
          ((string)null, hierarchicalEntryViewModel.ParentPointerField.DataType);
      Assert.IsNull(hierarchicalEntryViewModel.ParentPointerField.File);
      Assert.AreEqual<bool>
          (false, hierarchicalEntryViewModel.ParentPointerField.IsIndexed);
      Assert.AreEqual<string>
          ((string)null, hierarchicalEntryViewModel.ParentPointerField.Name);
      Assert.AreEqual<string>
          ((string)null, hierarchicalEntryViewModel.ParentPointerField.Number);
      Assert.IsNull(hierarchicalEntryViewModel.ParentPointerField.Pointer);
      Assert.AreEqual<string>((string)null, 
                              hierarchicalEntryViewModel.ParentPointerField.PointerFileNumber);
      Assert.AreEqual<bool>(true, hierarchicalEntryViewModel.IsExpanded);
      Assert.AreEqual<bool>
          (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsSelected);
      Assert.AreEqual<bool>
          (true, ((TreeNodeViewModel)hierarchicalEntryViewModel).IsExpanded);
      Assert.AreEqual<bool>
          (false, ((TreeNodeViewModel)hierarchicalEntryViewModel).AreChildrenLoaded);
      Assert.IsNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Parent);
      Assert.IsNotNull(((TreeNodeViewModel)hierarchicalEntryViewModel).Children);
      Assert.AreEqual<bool>(false, ((ViewModel)hierarchicalEntryViewModel).IsActive);
      Assert.IsNull(((ViewModel)hierarchicalEntryViewModel).UIDispatcher);
    }
}
    }
}
