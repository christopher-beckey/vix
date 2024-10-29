'Set up a new patch; see ShowHelp subroutine for syntax
'Env variable GIT_ROOT must be set to the root folder where your local clone is for the new patch, such as C:\git-p303 or C:\git\p303
'cscript srcToolsAndTest\Scripts\SetNewPatch.vbs //nologo "%thisDirWithEndingBackslash%AssemblyInfoShared.cs" /p:269 /n:303
'To debug, add //X

Const ForReading = 1
Const ForWriting = 2
Const CreateIfNotExist = True
Const OneDoubleQuote = """"
Const Unicode = -1
Const Ascii = 0

Set oShell = CreateObject( "WScript.Shell" )
GitFolder=oShell.ExpandEnvironmentStrings("%GIT_ROOT%")
If (GitFolder = "%GIT_ROOT%") Or Len(GitFolder) = 0 Then
	WScript.Echo "ERROR: The GIT_ROOT environment variable is not set. Set it to C:\git-pNNN or C:\git\pNNN or whatever your root path is."
	WScript.Quit
End if

NewPatchNumber = ""
PrevPatchNumber = ""

BadArgs = "ERROR: Syntax error.  Please run 'cscript SetNewPatch /h'."
BadArgs2 = "ERROR: Syntax error.  Patch numbers must be all digits. Please run 'cscript SetNewPatch /h'."
BuildConfigFolderNotFound = "ERROR: The build configuration folder does not exist."
PrevManifestNotFound = "ERROR: The previous build patch manifest file is not found."

'============================== Parse command line arguments ==============================
i = (InStrRev(UCase(WScript.FullName), "CSCRIPT") <> 0)
If i = 0 Then
	WScript.Echo "You must start this script from cscript, not wscript."
	WScript.Quit
End If

If WScript.Arguments.Count = 1 Then
	If WScript.Arguments.Item(0) = "-h" Or WScript.Arguments.Item(0) = "/h" Then
		ShowHelp
	Else
		WScript.StdErr.WriteLine BadArgs
	End If
	WScript.Quit
End If

NewPatchNumber = WScript.Arguments.Named.Item("n")
PrevPatchNumber = WScript.Arguments.Named.Item("p")
WScript.StdOut.WriteLine "Previous patch number is " & PrevPatchNumber
WScript.StdOut.WriteLine "New patch number is " & NewPatchNumber

If (NewPatchNumber = "") Or (PrevPatchNumber = "") Then
	WScript.StdErr.WriteLine BadArgs
	WScript.Quit
End If

'VBScript strings are one-based, not zero-based
If Mid(NewPatchNumber, 1, 1) = "p" Or Mid(NewPatchNumber, 1, 1) = "P" Then NewPatchNumber = Mid(NewPatchNumber, 2, Len(NewPatchNumber) - 1)
If Mid(PrevPatchNumber, 1, 1) = "p" Or Mid(PrevPatchNumber, 1, 1) = "P" Then PrevPatchNumber = Mid(PrevPatchNumber, 2, Len(PrevPatchNumber) - 1)

If Not IsNumeric(PrevPatchNumber) Then
	WScript.StdErr.WriteLine BadArgs2
	WScript.Quit
End If

If Not IsNumeric(NewPatchNumber) Then
	WScript.StdErr.WriteLine BadArgs2
	WScript.Quit
End If

If PrevPatchNumber >= NewPatchNumber Then
	WScript.StdErr.WriteLine "ERROR: Syntax error.  The previous patch number (" & PrevPatchNumber & ") must be less than the new patch number (" & NewPatchNumber & ")."
	WScript.Quit
End If
	
'============================== Get file paths ==============================
BuildConfigFolder = GitFolder & "\IMAG_Build\Configuration\VisaBuildConfiguration"
Set fso = CreateObject("Scripting.FileSystemObject")
If Not fso.FileExists("Hydra.sln") Then
	WScript.StdErr.WriteLine "ERROR: Please run this script from Hydra.sln's root folder"
	WScript.Quit
End If
If Not fso.FolderExists(BuildConfigFolder) Then
	WScript.StdErr.WriteLine BuildConfigFolderNotFound & " (" & BuildConfigFolder & ")"
	WScript.Quit
End If

'============================== Create new build manifest and manifest patch files with new patch version ==============================
CreateBuildConfigFiles "VixBuildManifest", PrevPatchNumber, NewPatchNumber
CreateBuildConfigFiles "VixManifest", PrevPatchNumber, NewPatchNumber
    
WScript.Quit


'============================== Show command line syntax ==============================
Sub ShowHelp()
    WScript.StdOut.WriteLine "Set GIT_ROOT environment variable to your new patch's git root folder"
	WScript.StdOut.WriteLine "Syntax is shown below where YYY and ZZZ are argument values"
    WScript.StdOut.WriteLine "cscript " & WScript.ScriptName & " /h"
    WScript.StdOut.WriteLine "or"
    WScript.StdOut.WriteLine "cscript " & WScript.ScriptName & " /p:YYY /n:ZZZ"
    WScript.StdOut.WriteLine "where:"
    WScript.StdOut.WriteLine "  /h = help (Optional, default is *NOT* to show) If specified, shows this help info and exits"
    WScript.StdOut.WriteLine "  /n = new patch number (REQUIRED)"
    WScript.StdOut.WriteLine "  /p = previous patch number (REQUIRED)"
    WScript.StdOut.WriteLine "Example: cscript " & WScript.ScriptName & " /p:284 /n:269"
End Sub

'============================== Ensure the prev version of the config file exists, then set the new patch version ==============================
Sub CreateBuildConfigFiles(FileNamePrefix, PrevPatchNumber, NewPatchNumber)

NewFilePathPrefix = BuildConfigFolder & "\" & FileNamePrefix & "Patch" & NewPatchNumber
NewFilePathCVIX = NewFilePathPrefix & "CVIX.xml"
NewFilePathVIX = NewFilePathPrefix & "VIX.xml"

PrevFilePathPrefix = BuildConfigFolder & "\" & FileNamePrefix & "Patch" & PrevPatchNumber
PrevFilePathCVIX = PrevFilePathPrefix & "CVIX.xml"
PrevFilePathVIX = PrevFilePathPrefix & "VIX.xml"
If Not fso.FileExists(PrevFilePathCVIX) Then
	WScript.StdErr.WriteLine PrevManifestNotFound & " (" & PrevFilePathCVIX & ")"
	WScript.Quit
End If
If Not fso.FileExists(PrevFilePathVIX) Then
	WScript.StdErr.WriteLine PrevManifestNotFound & " (" & PrevFilePathVIX & ")"
	WScript.Quit
End If

SetNewPatchVersion PrevFilePathCVIX, NewFilePathCVIX, PrevPatchNumber, NewPatchNumber
SetNewPatchVersion PrevFilePathVIX, NewFilePathVIX, PrevPatchNumber, NewPatchNumber

End Sub

'============================== Set the new patch version ==============================
Sub SetNewPatchVersion(prevFilePath, newFilePath, previousPatchNumber, currentPatchNumber)
	'Example: <Patch number="30.303.1.1234" msiName="MAG3_0P303T1_CVIX_Setup.msi" />
	
	Set fIn = fso.OpenTextFile(prevFilePath, ForReading, Unicode)
	'Write as ASCII so there is no BOM at the beginning of the file
	on error resume next
	Set fOut = fso.OpenTextFile(newFilePath, ForWriting, CreateIfNotExist, Ascii)
	Do Until fIn.AtEndOfStream
		ln = fIn.ReadLine
		If justReplacedDeprecatedWithActive = true And Len(PrevDeprecatedVersion) > 0 And InStr(ln, PrevDeprecatedVersion) > 0 Then
			ln = Replace(ln, PrevDeprecatedVersion, PrevActiveVersion)
			fOut.WriteLine ln
			justReplacedDeprecatedWithActive = false
		Else
			justReplacedDeprecatedWithActive = false
			If InStr(LCase(ln), "<patch number=") > 0 Then
		  		partsLine = split(ln, OneDoubleQuote)
				prevVersion = partsLine(1) 'Example: 30.284.1.7804
				p = split(prevVersion, ".")
				p(1) = currentPatchNumber 'Example: was 284 now 269
				p(3) = p(3) + 100 'Example: was 7804 now 7904
				currVersion = p(0) & "." & p(1) & "." & p(2) & "." & p(3)
				ln = partsLine(0) & OneDoubleQuote & currVersion 'Example: 30.269.1.7904
				For i = 2 To UBound(partsLine)
					ln = ln & OneDoubleQuote & partsLine(i)
				Next
			End If
			If Instr(LCase(ln), "This wizard will guide you through the installation of the Patch " & previousPathNumber) > 0 Then
				ln = Replace(ln, previousPatchNumber, currentPatchNumber)
			End If
			If InStr(ln, "<Prerequisite") > 0 And InStr(ln, "Viewer Services") > 0 Then
				If InStr(ln, "Active") > 0 Then
					pav = split(ln, OneDoubleQuote)
					PrevActiveVersion = pav(5)
					ln = Replace(ln, PrevActiveVersion, currVersion)
				Else
					pdv = split(ln, OneDoubleQuote)
					PrevDeprecatedVersion = pdv(5)
					ln = Replace(ln, PrevDeprecatedVersion, PrevActiveVersion)
					justReplacedDeprecatedWithActive = true
				End If
			End If
			If justReplacedDeprecatedWithActive = false And Instr(ln, prevVersion) > 0 Then
				ln = Replace(ln, prevVersion, currVersion)
			End If
			If InStr(LCase(ln), "<!-- p" & previousPathNumber) > 0 Or InStr(LCase(ln), "<!--p" & previousPathNumber) > 0 Then
				fOut.WriteLine ln
			Else
				If justReplacedDeprecatedWithActive = false Then
					fOut.WriteLine Replace(ln, previousPatchNumber, currentPatchNumber)
				Else
					fOut.WriteLine ln
				End If
			End If
		End If
	Loop
	fIn.Close
	fOut.Close
	WScript.StdOut.WriteLine "Created " & newFilePath
End Sub
