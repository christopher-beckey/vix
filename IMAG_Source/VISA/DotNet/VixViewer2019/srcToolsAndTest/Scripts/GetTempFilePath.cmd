@if (@CodeSection == @Batch) @then

::CMD and JScript hybrid script to get a unique temporary file path

@echo off
setlocal
for /F "delims=" %%a in ('CScript //nologo //E:JScript "%~F0"') do set "tempName=%%a"
echo %TEMP%\%tempName%
goto :EOF

@end

// JScript section
var fso = new ActiveXObject("Scripting.FileSystemObject");
WScript.Stdout.WriteLine(fso.GetTempName());
