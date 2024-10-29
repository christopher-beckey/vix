# README FILE FOR IMAG_MS2019 FOLDER

This folder contains files common to the IMAG_* folders that use Miscrosoft 2019 files (Visual Studio, MSBuild, etc.).
This folder is for .NET developers. Do not use as-is for the Java code.

- copy .gitignore to your root git folder

- .vsconfig should be used when importing the Visual Studio configuration in the Visual Studio installer.  It includes MSBuild.

- IntstallerProjects.vsix is a Visual Studio 2019 extension to open .vdproj files.
  Close Visual Studio, then double-click this file to install it.
  https://marketplace.visualstudio.com/items?itemName=VisualStudioClient.MicrosoftVisualStudio2017InstallerProjects
