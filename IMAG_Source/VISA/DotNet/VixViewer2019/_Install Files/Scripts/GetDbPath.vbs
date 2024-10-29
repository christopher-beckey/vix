'Get the full path of the database: cscript thisScriptPath vixRenderConfigPath
If WScript.Arguments.Count = 0 Then
    WScript.StdErr.WriteLine WScript.ScriptName & ", ERROR: No argument supplied."
    WScript.Quit
End If

Const ForReading = 1
argFilePath = WScript.Arguments.Item(0)
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(argFilePath, ForReading)
data = objFile.ReadAll()
objFile.Close

pos = InStr(data, "<!-- Database")
if pos < 0 Then pos = InStr(data, "<!--Database")
if pos > 0 Then
	data = Mid(data, pos+1, Len(data)-pos)
	pos = Instr(data, "-->")
	if pos < 0 Then
        WScript.StdErr.WriteLine WScript.ScriptName & ",ERROR: Cannot find --> for <!-- Database."
        WScript.Quit
	End If
	data = Mid(data, pos+3, Len(data)-pos-2)
End If

pos = InStr(data, "DataSource")
if pos < 0 Then
    WScript.StdErr.WriteLine WScript.ScriptName & ",ERROR: Cannot find DataSource."
    WScript.Quit
End If

data = Mid(data, pos+1, Len(data)-pos)
dbq = """"
pos = InStr(data, dbq)
if pos < 0 Then
    WScript.StdErr.WriteLine WScript.ScriptName & ",ERROR: Cannot find double quote after DataSource."
End If
data = Mid(data, pos+1, Len(data)-pos)
pos = InStr(data, dbq)
if pos < 0 Then
    WScript.StdErr.WriteLine WScript.ScriptName & ",ERROR: Cannot find double quote after .db."
End If
WScript.StdOut.WriteLine Left(data, pos-1)
