README FILE FOR PDFSHARP

https://github.com/empira/PDFsharp

Downloaded PDFsharp-master.zip from github.
Renamed it PDFsharp-master(1.51.5185 beta).zip, because that is the version referenced in the github repo.  The DLL versions are 1.51.5185.0.
Kept the zip here for posterity, although we do not currently use all of its files.
Unzipped it.
Deleted all folders and files except for PDFsharp-master\src\PdfSharp and PDFsharp-master\src\PdfSharp-gdi.  
Moved those two folders to this folder, and deleted PdfSharp.csproj and StrongnameKey.snk, because they are unused.
PdfSharp-gdi.csproj is in our solution because we need its DLL.  It uses ***files*** from PdfSharp's ***folder***, but we do not need the PdfSharp.csproj to build PdfSharp-gdi.csproj.
That is why only PdfSharp-gdi is in the solution.
