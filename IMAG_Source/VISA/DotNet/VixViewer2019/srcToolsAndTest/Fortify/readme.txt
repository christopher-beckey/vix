README FILE FOR FORTIFY

Fortify can be run by developers on their GFE or on a server (such as our build server).
This file explains how to run these scripts for developers.

Workflow - Open a cmd window and:
  Enter (syntax)                                       To                                         Example
  ---------------------------------------------        -----------------------------------------  ---------------------------------------
  Fortify_1_Prep.cmd fullSrcPathToVixViewer2019        Copy files from the src path to C:\VV2019  Fortify_1_Prep.cmd C:\git\IMAG_Source\VISA\DotNet\VixViewer2019
                                                         and delete files we don't want to scan

  Fortify_2_Translate.cmd fullPathToFortifyBinFolder   Create the mapping of C:\VV2019 into FPR   Fortify_2_Translate.cmd C:\Fortify_SCA_and_Apps_22.2.2\bin

  Fortify_3_ScanReport.cmd fullPathToFortifyBinFolder  Scan C:\VV2019 and update FPR, plus        Fortify_3_ScanReport.cmd C:\Fortify_SCA_and_Apps_22.2.2\bin
                                                         generate a report (PDF)

  Then we submit to OIS according to procedures documented elsewhere.

Fortify_ReportWithoutScan.cmd fullPathToFortifyBinFolder is provided in case we want to generate the PDF report without rescanning.