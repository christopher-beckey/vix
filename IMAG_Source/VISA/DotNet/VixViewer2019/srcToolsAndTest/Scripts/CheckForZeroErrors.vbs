Rem Given arg1 = log file, arg2 = output file.
Rem If the arg1 file contains " 0 Error(s)" remove the arg2 file. If it doesn't contain it, output the " Error(s)" line to the arg2 file.

Const ForReading = 1
Const ForWriting = 2

argInFilePath = WScript.Arguments.Item(0)
If len(argInFilePath) = 0 then
    WScript.StdErr.WriteLine "ERROR: Input file path is missing from command line."
Else
    argOutFilePath = WScript.Arguments.Item(1)
    If len(argOutFilePath) = 0 then
        WScript.StdErr.WriteLine "ERROR: Output file path is missing from command line."
    Else
        Set objFSO = CreateObject("Scripting.FileSystemObject")
        Set objFile1 = objFSO.OpenTextFile(argInFilePath, ForReading)
        Set objFile2 = objFSO.OpenTextFile(argOutFilePath, ForWriting, True)
        weAreDone = 0
        Do Until objFile1.AtEndOfStream or weAreDone = 1
          sLine = objFile1.ReadLine
          i = InStr(sLine, " Error(s)")
          If i > 0 Then
            i = InStr(sLine, " 0 Error(s)")
            If i = 0 Then
              objFile2.WriteLine sLine
              objFile2.Close
              weAreDone = 1
            Else
              objFile2.Close
              weAreDone = 1
              Set objFile2 = objFSO.GetFile(argOutFilePath)
              objFile2.Delete
            End If
          End if
        Loop
        objFile1.Close
    End If
End If
