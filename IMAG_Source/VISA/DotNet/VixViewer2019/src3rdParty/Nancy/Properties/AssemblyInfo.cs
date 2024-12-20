using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;
using System.Reflection;

[assembly: AssemblyTitle("Nancy")]
[assembly: AssemblyDescription("A Sinatra inspired web framework for the .NET platform")]
[assembly: AssemblyCompany("Nancy")]
[assembly: AssemblyProduct("Nancy")]
// customized: This file is actually SharedAssemblyInfo.cs one level higher than the Nancy project from the 1.x-WorkingBranch from https://github.com/NancyFx/Nancy
[assembly: AssemblyCopyright("Copyright (C) Andreas Hakansson, Steven Robbins and contributors-customized")]
[assembly: AssemblyVersion("1.4.4")]
[assembly: AssemblyInformationalVersion("1.4.4")]

[assembly: InternalsVisibleTo("Nancy.Tests")]
[assembly: InternalsVisibleTo("Nancy.Hosting.Self.Tests")]
