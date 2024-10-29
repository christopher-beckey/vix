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
using VistA.Imaging.DataNavigator.Model;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Pex.Framework.Generated;
using ImagingClient.Infrastructure.Prism.Mvvm;
using System.Windows.Threading;

namespace VistA.Imaging.DataNavigator.ViewModels
{
    public partial class FilemanFieldViewModelTest
    {
[TestMethod]
[PexGeneratedBy(typeof(FilemanFieldViewModelTest))]
public void ToString01328()
{
    FilemanFieldViewModel filemanFieldViewModel;
    string s;
    filemanFieldViewModel = new FilemanFieldViewModel((FilemanField)null);
    filemanFieldViewModel.IsSelected = false;
    ((ViewModel)filemanFieldViewModel).IsActive = false;
    ((ViewModel)filemanFieldViewModel).UIDispatcher = (Dispatcher)null;
    s = this.ToString01(filemanFieldViewModel);
    Assert.AreEqual<string>("IEN", s);
    Assert.IsNotNull((object)filemanFieldViewModel);
    Assert.IsNull(filemanFieldViewModel.Field);
    Assert.AreEqual<bool>(false, filemanFieldViewModel.IsSelected);
    Assert.AreEqual<bool>(false, ((ViewModel)filemanFieldViewModel).IsActive);
    Assert.IsNull(((ViewModel)filemanFieldViewModel).UIDispatcher);
}
[TestMethod]
[PexGeneratedBy(typeof(FilemanFieldViewModelTest))]
public void ToString01993()
{
    FilemanFieldViewModel filemanFieldViewModel;
    string s;
    FilemanField s0 = new FilemanField();
    s0.DataType = (string)null;
    s0.File = (FilemanFile)null;
    s0.IsIndexed = false;
    s0.Name = (string)null;
    s0.Number = (string)null;
    s0.Pointer = (FilemanFilePointer)null;
    s0.PointerFileNumber = (string)null;
    filemanFieldViewModel = new FilemanFieldViewModel(s0);
    filemanFieldViewModel.IsSelected = false;
    ((ViewModel)filemanFieldViewModel).IsActive = false;
    ((ViewModel)filemanFieldViewModel).UIDispatcher = (Dispatcher)null;
    s = this.ToString01(filemanFieldViewModel);
    Assert.AreEqual<string>(": ", s);
    Assert.IsNotNull((object)filemanFieldViewModel);
    Assert.IsNotNull(filemanFieldViewModel.Field);
    Assert.AreEqual<string>((string)null, filemanFieldViewModel.Field.DataType);
    Assert.IsNull(filemanFieldViewModel.Field.File);
    Assert.AreEqual<bool>(false, filemanFieldViewModel.Field.IsIndexed);
    Assert.AreEqual<string>((string)null, filemanFieldViewModel.Field.Name);
    Assert.AreEqual<string>((string)null, filemanFieldViewModel.Field.Number);
    Assert.IsNull(filemanFieldViewModel.Field.Pointer);
    Assert.AreEqual<string>
        ((string)null, filemanFieldViewModel.Field.PointerFileNumber);
    Assert.AreEqual<bool>(false, filemanFieldViewModel.IsSelected);
    Assert.AreEqual<bool>(false, ((ViewModel)filemanFieldViewModel).IsActive);
    Assert.IsNull(((ViewModel)filemanFieldViewModel).UIDispatcher);
}
[TestMethod]
[PexGeneratedBy(typeof(FilemanFieldViewModelTest))]
public void ToString01477()
{
    FilemanFieldViewModel filemanFieldViewModel;
    string s;
    filemanFieldViewModel = new FilemanFieldViewModel((FilemanField)null);
    filemanFieldViewModel.IsSelected = false;
    ((ViewModel)filemanFieldViewModel).IsActive = true;
    ((ViewModel)filemanFieldViewModel).UIDispatcher = (Dispatcher)null;
    s = this.ToString01(filemanFieldViewModel);
    Assert.AreEqual<string>("IEN", s);
    Assert.IsNotNull((object)filemanFieldViewModel);
    Assert.IsNull(filemanFieldViewModel.Field);
    Assert.AreEqual<bool>(false, filemanFieldViewModel.IsSelected);
    Assert.AreEqual<bool>(true, ((ViewModel)filemanFieldViewModel).IsActive);
    Assert.IsNull(((ViewModel)filemanFieldViewModel).UIDispatcher);
}
    }
}
