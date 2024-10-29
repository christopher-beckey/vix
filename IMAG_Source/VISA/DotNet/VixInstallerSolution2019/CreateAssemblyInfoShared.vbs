Rem Replace argVersion and copyright argYear in a file expected to be formatted like AssemblyInfo.cs

'Const ForReading = 1
Const ForWriting = 2
Const Abandon = "Abandoning file creation."

argFilePath = WScript.Arguments.Item(0)
argVersion = WScript.Arguments.Item(1)
argYear = WScript.Arguments.Item(2)
If Len(argFilePath) = 0 Then
	WScript.StdErr.WriteLine "File Path argument is empty. " & Abandon
	WScript.Quit
Else
	If Len(argVersion) = 0 Then
		WScript.StdErr.WriteLine "Version argument is empty. " & Abandon
		WScript.Quit
	Else 
		If Len(argYear) = 0 Then
			WScript.StdErr.WriteLine "Year argument is empty. " & Abandon
			WScript.Quit
		End If
	End if
End if

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(argFilePath, ForWriting)
objFile.WriteLine "using System.Reflection;"
objFile.WriteLine ""
objFile.WriteLine "[assembly: AssemblyCompany(""Department of Veterans Affairs"")]"
objFile.WriteLine "[assembly: AssemblyProduct(""C/VIX Installer"")]"
objFile.WriteLine "[assembly: AssemblyCopyright(""Copyright © " & argYear & """)]"
objFile.WriteLine "[assembly: AssemblyTrademark(""Built with MSBuild/MS VS 2019"")]"
objFile.WriteLine "[assembly: AssemblyCulture("""")]"
objFile.WriteLine "[assembly: AssemblyVersion(""" & argVersion & """)]"
objFile.Close
