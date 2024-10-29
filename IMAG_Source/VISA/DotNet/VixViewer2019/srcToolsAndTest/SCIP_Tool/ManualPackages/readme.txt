FO-DICOM
    Version 5 is latest, but uses .NET Standard, not .NET Framework (that we use)
    https://www.nuget.org/packages/fo-dicom.Desktop/4.0.8 > Download package
    Once downloaded, rename the file from .nupkg to .zip, and unzip it
    Remove everything except the lib\net45 folder, move it up a level, and remove the lib folder
	  This leaves us with fo-dicom.desktop.4.0.8\net45 that cotains the dll