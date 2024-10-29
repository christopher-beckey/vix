SCIP_Tool README file

The SCIP_Tool provides utility functions internally for the SCIP Imaging team.
This is primarily a Development tool, but Test and Ops can also run it.

The tools
---------
Local Image Processor - Uses the source code we deploy to convert files like the VIX Render Service does without having to run the entire system.
Rename Files - Useful for troubleshooting, when there a lot of files in the VixCache. Enter the first N (for N-REFERENCE-application%2fdicom, VixRenderCache\N_ABS.jpeg, etc.).
Local Image VistA Worker - Runs the Hydra VistA Worker on a VixCache folder in isolation from the rest of the system.
DICOM Tools - Tools we run on DICOM files.
Security Token - How to unpack a VIX Viewer security token. TODO - pack.
Token2 (WIP) - Paste the thumbprint from VIX.Viewer.config you are interested in. You can use .NET Decrypt to see the encrypted values. TODO - get this working.
Parse Study Response - Click Parse to use source code we deploy to parse the study metadata. Click Execute to try running it against Study_Tools\Sample1.xml. TODO - add XML path textbox with Browse.
Reformat Log Files - Copies the files in a log folder to a log-out folder, removing the date/time from each log line for easier comparison.

Changes (Newest to Oldest)
--------------------------
11/4/2022  - Removed zlib compression and window leveling proof of convepts
           - Added FO-DICOM (see ManualPackages)

07/20/2022 - Call new method for Java decryption

04/15/2022 - Changed Java decryption for their new algorithm

10/21/2020 - Local Image Processor - No change
             Local Image VistAWorker - Work in progress to figure out why it isn't working as expected in production
             DICOM Tools - Reads a DICOM image and outputs some info about it that we cannot get from DicomParser
             Security Token - Work in progress to reverse engineer certain security tokens. Click Token, Use Example, and Go.
             Token2 (WIP) - Work in progress to test certifications

06/08/2020 - Local Image Processor button now handles all input and places output in a folder named InputFolderPath.out, where InputFolderPath is the real path to the input folder.
           - This was done by removing TIFF and JPEG specific code and including the actual Hydra.Dicom project.
           - This was done because of VAI-232 and our inability to test DICOM, so now we can.

06/05/2020 - Local Image button now handles JPEG.  TIFF button removed.  This was done because of VAI-250 and our problems with JPEG - inaccurate (zero length files) and slow.

01/01/2020 - Added TIFF button to handle TIFF images.  Copied real Hydra.sln into a new TIFF folder.
           - Multi-page TIFF changes
           - Added Max PDF Pages textbox.
           - Added JPEG and PDF checkboxes so you can choose to only convert one or both.
           - If we are processing a TIFF file for PDF conversion, its page count exceeds the max, and the max is greater than zero, then convert it to JPEG instead.
