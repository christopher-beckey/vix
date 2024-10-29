# README FILE FOR VIX VIEWER 2019 SOLUTION

## AT A GLANCE
- Visual Studio 2019 (16.11.x), Run as Admin  
- .NET Framework 4.8  
- To jump right in, see the Development Tools topic below.


## NOTES
### READING THIS DOCUMENT
If not viewing this in GitHub, another way to view this file is to open it in Visual Studio Code (VSC) using the Instant Markdown extension, which displays the file in your browser as you type. Notepad++'s plugin is not as good as the VSC extension.
### PLACEHOLDERS
Placeholders are used in this document:
- XXX is the previous-previous patch number, the one we released before YYY.
- YYY is the previous patch number, the one we last released.
- ZZZ is the new patch number we are going to release.  
  
For example, XXX is 303, YYY is 329, and ZZZ is 344.  
The chronological (historical) order of patch number releases are not necessarily ordinal (sequential order).


## CONTENTS
- [Build Server Tools](#BUILD_SERVER_TOOLS)
- [Development Tools](#DEVELOPMENT_TOOLS)
- [Folders and Files](#FOLDERS_AND_FILES)
- [How to Build](#HOW_TO_BUILD)
- [How to Clean](#HOW_TO_CLEAN)
- [How to Add a Project](#HOW_TO_ADD_PROJECT)
- [How to Add a Third-Party Package](#HOW_TO_ADD_3RDPARTY)
- [How to Customize Third-Party Packages](#HOW_TO_CUSTOMIZE_3RDPARTY)
- [How to Package for Release](#HOW_TO_PACKAGE_FOR_RELEASE)
- [How to Start Work on a New Release](#HOW_TO_START_WORK_ON_A_NEW_RELEASE)
- [How to Finish Work on a Release](#HOW_TO_FINISH_WORK_ON_A_RELEASE)
- [Online Help and API Doc](#ONLINE_HELP_AND_API_DOC)
- [Source Code Control](#SOURCE_CODE_CONTROL)
- [Target Machine](#TARGET_MACHINE)
- [Troubleshooting](#TROUBLESHOOTING)


## DETAILED TOPICS

### BUILD SERVER TOOLS<a name="BUILD_SERVER_TOOLS"></a>
Most .NET build servers install MSBuild instead of Visual Studio. However, our build server is not normal, so install all software according to the DEVELOPMENT TOOLS topic.


### DEVELOPMENT TOOLS<a name="DEVELOPMENT_TOOLS"></a>
- Visual Studio 2019 Enterprise 16.11.x. Retrieve a license from the VA. Start with your Area Manager and/or who furnished your GFE.
- This is a one-time setup.
- Follow the instructions here (https://learn.microsoft.com/en-us/visualstudio/install/install-visual-studio?view=vs-2019), and:
  - When you get to Step 4 - Choose workloads in the Installer, select ASP.NET and web development, .NET desktop development, and Desktop development with C++.
  - Click Install, and uncheck Start after installation.
  - When the install is done, click the More button, select Import configuration, browse to the IMAG_MS2019\.vsconfig file, click Review details, and click Modify.
  - When the modify is done, close the Installer.
- Open Visual Studio, Run as Administrator.
  - You should be prompted if you are missing any components, and install them.
  - Tools > Options > Debugging > Just-In-Time, check all checkboxes.
  - Tools > Options > Text Editor > All Languages, check Line Numbers, OK.
  - Tools > Options > Text Editor > General, check View whitespace, OK. <-- OPTIONAL.
  - Tools > Options > Projects and Solutions > Track Active Item in Solution Explorer.
  - Tools > Options > Environment > Product Updates > Uncheck Automatically Download Updates.
  - File > Exit.
- Install NodeJs, NPM, and redoc-cli to generate the API doc (see VIX.Viewer.Service\doc\readme.txt).
- Download and unzip Apache Ant from https://ant.apache.org/bindownload.cgi to build the client-side.
- Follow the HOW TO BUILD topic.
- Visual Studio Code (VSC), optional:
  - If Terminal shows weird characters, try disabling this setting: shellIntegration
  - Microsoft PowerShell Extension (https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell):
    - Add this extension using the VSC IDE
    - Install-Module -Name PSScriptAnalyzer -Force
    - Get-ScriptAnalyzerRule
    - Invoke-ScriptAnalyzer "FullPathToPsScript.ps1" -Recurse
    - To open examples, enter this in PowerShell: code (Get-ChildItem $HOME/.vscode/extensions/ms-vscode.powershell-*/examples)[-1]
    - More examples here: https://www.powershellgallery.com/
 

### FOLDERS AND FILES<a name="FOLDERS_AND_FILES"></a>
- build.cmd - Builds a solution, defaulting to Hydra.sln and its dependents
- buildDev.cmd - Builds a Debug version
- buildOfficial.cmd - Builds a Release version and packages it for release & installation
  - Due to Jenkins bug, must first: echo 30.999.9.9999 > build\patchVerstion.txt & src\VIX.Viewer.Service\doc\generate & buildOfficial
- buildRel.cmd - Builds a Release version
- clean.cmd - Cleans all folders according to the HOW TO CLEAN topic.
- Hydra.sln - The .NET solution to build and debug all projects.
- README.md - This file.
- The following are the source folders: 
 
  | Source Folder   | Description   |
  | --- | --- |
  | src             | The sources for the main service/application whose targets go to production. |
  | src3rdParty     | The third-party source code and nuget packages used by src.  |
  | srcToolsAndTest | The tools/utilities, nuget packages, and test code used by team members (not end-users or sys admins). |


### HOW TO BUILD<a name="HOW_TO_BUILD"></a>
Simple for most developers:  Get and Build.  
A little more complicated for release developers: See the HOW TO PACKAGE FOR RELEASE topic.
This assumes you have already cloned the right branch.
- Get (git pull) = Retrieve all files from source code control, for example into C:\git\pZZZ.
- Build:
  - Open an elevated cmd window, cd to C:\git\pZZZ\IMAG_Source\VISA\DotNet\VixViewer2019, and enter:
    - **buildDev** for the Debug configuration or **buildRel** for the Release configuration
    - If you want to know about build options, enter: build -h
  - Open Visual Studio, open C:\git\pZZZ\IMAG_Source\VISA\DotNet\VixViewer2019\Hydra.sln, and:
    - Select Debug from the Solutions Configurations and Mixed Platforms from the Solution Platform dropdowns
    - Select Project > Build Solution


### HOW TO CLEAN<a name="HOW_TO_CLEAN"></a>
- Cleaning removes most folders we do not want to checkin (such as bin, log, obj, and x64), recursively.  See :DoClean and -u in build.cmd.
- Open elevated cmd window, and cd to this folder.
- To clean all folders:  clean
- Note: If you ran the build with elevated priveleges, you need to clean with elevated priveleges. (It's simplest to always run elevated.)
  
  
### HOW TO ADD A PROJECT<a name="HOW_TO_ADD_PROJECT"></a>
- If the DLL or EXE is being deployed
  - If it is not a tool
    Then    Add it to src
            Edit the .csproj and set RestorePackages to false
            Add a dependency to src3rdParty\Hydra3rdParty (we need to tell Visual Studio to build that project first)
    Else    Add it to srcToolsAndTest
            If using the solution's packages folder
            Then    Edit the .csproj and set RestorePackages to false
                    Add a dependency to src3rdParty\Hydra3rdParty (we need to tell Visual Studio to build that project first)
            Else    Copy the MockService's .nuget folder and packages.config, add them to the project in the Solution Explorer, and edit as needed
  
  
### HOW TO ADD A THIRD-PARTY PACKAGE<a name="HOW_TO_ADD_3RDPARTY"></a>
- Q: What is a third-party package?
  A: Any package that is not in our git repo. The VA Technical Reference Model is very strict about this (https://trm.oit.va.gov/SearchPage.aspx).
- We need to tightly control the third-party DLLs and EXEs we use due to the TRM.
  - So, we do ***NOT*** use NuGet on-the-fly.
  - We checkin the packages we rely on, because sometimes people remove or move them.
  - We do NOT restore packages during a build. If you want to restore packages, follow "To test retrieving packages below".
- src3rdParty\Hydra3rdParty.csproj uses NuGet so that all packages we deploy go in the solution's packages folder, and ***src3rdParty is the only way they are obtained***.
- If the package is going to be deployed to the target machine (included in the MSI)  
  Then    Add it to the src3rdParty\Hydra3rdParty\packages.config, if possible  
            (Some packages must be done manually, such as PDFSharp)  
  Else    Keep it self-contained within its own project structure under srcToolsAndTest and add it to build.cmd and restore.cmd
            (Example: see MockService)
- To test retrieving packages:
  - dir packages/b/s shows you all the packages folders.
  - Rename all those packages folders to packagesSave.
  - Run clean -u.
  - Run srcToolsAndTest\Scripts\restore.cmd which should restore all the packages folders.
  - Compare all packages to packagesSave folders.
  
  
### HOW TO CUSTOMIZE THIRD-PARTY PACKAGES<a name="HOW_TO_CUSTOMIZE_3RDPARTY"></a>
- Get the source and add it to the src3rdParty folder.
- Wherever you customize, add a comment to make it easy to find.
  C# or C++ or JS = //customized
  CMD = ::customized
  HTML or CSHTML = <!-- customized -->
  PS = #customized
- It's preferable to put custom code in a separate folder to make it easy to upgrade, but it's not required.


### HOW TO PACKAGE FOR RELEASE<a name="HOW_TO_PACKAGE_FOR_RELEASE"></a>
- Make sure the new files were checked in (see the HOW TO START WORK ON A NEW RELEASE topic)
- Make sure you have the right software as described in the DEVELOPMENT TOOLS topic
- Open an elevated cmd window, cd to the Hydra.sln's folder, and:
  - build -c Release -t CVIX -v 30.999.9.9999 -p (where you would enter the correct version number and VIX instead of CVIX)
  - srcToolsAndTest\Scripts\PackageForRelease 30.999.9.9999


### HOW TO START WORK ON A NEW RELEASE<a name="HOW_TO_START_WORK_ON_A_NEW_RELEASE"></a>
- git-develop is the branch we work on in the imag-code-scip git repository for normal work.
  The Configuration Manager creates a copy of that branch into a release_pYYY branch when development is frozen for that YYY patch and another branch, pYYY, under imag-code.
  You need to decide which branch you are working on, develop or release_pYYY.
  THIS SECTION ASSUMES YOU ARE STARTING WORK ON PATCH ZZZ USING THE DEVELOP BRANCH.
- Open a bash cmd window
  - Clone the develop branch C:\git-develop (we call this GIT_ROOT)
  - set GIT_ROOT=(your GIT_ROOT path from above)
  - cd %GIT_ROOT%\IMAG_Source\VISA\DotNet\VixViewer2019
  - Run the following command: cscript srcToolsAndTest\Scripts\SetNewPatch.vbs //nologo /p:YYY /n:ZZZ
    - It creates new manifest and build manifest patch files (used for this solution and for VixBuilder2019/AssembleMSI2019)
  - Open Hydra.sln in Visual Studio, and in _Install Files\Scripts:
    - Rename pYYY_post_scripts_delete.ps1 to pZZZ_post_scripts_delete.ps1.
    - Remove any other pYYY scripts.
  - Do a build
  - Make a pull request for the following, and specify a review for your teammates.
    - IMAG_Build\Configuration\VisaBuildConfiguration\VixBuildManifestPatchZZZCVIX.xml
    - IMAG_Build\Configuration\VisaBuildConfiguration\VixBuildManifestPatchZZZVIX.xml
    - IMAG_Build\Configuration\VisaBuildConfiguration\VixManifestPatchZZZCVIX.xml
    - IMAG_Build\Configuration\VisaBuildConfiguration\VixManifestPatchZZZVIX.xml
    - IMAG_Source\VISA\DotNet\VixViewer2019\_Install Files\Scripts\pZZZ_post_scripts_delete.ps1
    - IMAG_Source\VISA\DotNet\VixViewer2019\VIX.Viewer.Service\doc\VVSDoc.html
    - If VVSDoc.html has changed, you need to install NPM; see Vix.Viewer.Service\doc\readme.txt
- Online Help
  - Get the latest MAG3_0ZZZ_VIEWER_USER_GUIDE.docx from the technical writer.
    If it does not yet exist:
    - Get the last MAG3_0YYY_VIEWER_USER_GUIDE.docx from the technical writer.
    - Rename it MAG3_0ZZZ_VIEWER_USER_GUIDE.docx.
    - Replace all YYY occurrences with ZZZ except for the Revision History.
    - Save the file, and upload it for the technical writer.
  - Save the file as PDF in VIX.Viewer.Service\VIX_Viewer_User_Guide.pdf, and check it into source code control.
  - There is more info in the ONLINE HELP AND API DOC topic.


### HOW TO FINISH WORK ON A RELEASE<a name="HOW_TO_FINISH_WORK_ON_A_RELEASE"></a>
- If the USER GUIDE (VIX.Viewer.Service\VIX_Viewer_User_Guide.pdf) is over a month out of date, update the date (see the ONLINE HELP AND API DOC topic).
- Add all IMAG changes to VIX.Viewer.Service\ReleaseHistory.xlsx.
    
  
### ONLINE HELP AND API DOC<a name="ONLINE_HELP_AND_API_DOC"></a>
- For the User Guide:
  - The VIX_Viewer_User_Guide.pdf file is the online help and is installed by the VIX Installer.
  - The PDF gets into the VIX Installer automatically with the other target files in VIX.Viewer.Service.
  - Before updating the PDF, follow the Online Help sub-topic in the HOW TO START WORK ON A NEW RELEASE topic, especially about where to save VIX_Viewer_User_Guide.pdf.
  - When viewing an image, the user can read the PDF by clicking the ... icon (External Links) and selecting User Guide.  The ... icon is in a circle at the upper-right of the web page.
  - The source for the online help is maintained in a Word document by the technical writer.  It is a VDL (VA Document Library) document (https://www.va.gov/vdl/application.asp?appid=105).
  - When we want to change the document, we coordinate with the technical writer.
- For the API Doc:
  - During a build, after doc\VVSDoc.html gets generated, it is copied to the Viewer folder so users can access it the same as the dash.


### SOURCE CODE CONTROL<a name="SOURCE_CODE_CONTROL"></a>
- Before checking in
  - Make sure the solution builds in Debug and Release configs.
  - Run your code through Fortify.
  - Create a feature/dev branch and checkin your code there.
  - Desire only one change # per checkin, but sometimes this cannot be avoided.
  - Get a code review.
- The .gitignore file controls which files are and are not checked into source code control.
- We do not use .gitignore for bin and obj files, because we want to whitelist src3rdParty.
- References:
  https://stackoverflow.com/questions/72298/should-i-add-the-visual-studio-suo-and-user-files-to-source-control
  https://github.com/github/gitignore
  https://gist.github.com/jamiebergen/91a49b3c3e648031619178050122d90f


### TARGET MACHINE<a name="TARGET_MACHINE"></a>
Windows Server 2012R2, 2016, or 2019


### TROUBLESHOOTING<a name="TROUBLESHOOTING"></a>
- Developer errors when installing Visual Studio
  - For MSI version problems, see https://developercommunity.visualstudio.com/t/microsoftvisualstudiosetupconfiguration-error-when/889463
- Developer errors when running Visual Studio
  - Opening the .sln
    - Some of the properties associated with the solution could not be read.
    FIX: Remove dangling spaces (lines ending in a space) in the .sln file
  - Build time
    - error MSB4019: The imported project "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Microsoft\VC\v160\Microsoft.Cpp.Default.props" was not found.
      - FIX: Use IMAG_MS2019\.vsconfig as described above to install C++
    - error MSB3091: Task failed because "resgen.exe" was not found, or the correct Microsoft Windows SDK is not installed. The task is looking for "resgen.exe" in the "bin" subdirectory beneath the location specified in the InstallationFolder value of the registry key HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SDKs\Windows\v8.0A\WinSDK-NetFx35Tools-x86.
      - FIX: - The error message is incorrect. Assuming you have installed C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\, add that path to the PATH environment variable, and run regedit, and import srcToolsAndTest\Scripts\sdk-ManualFixResGen.reg
  - Programming/Editing
    - Cannot get JavaScript Intellisense
      FIX: This is what worked for me:  
           Add a Scripts folder to the solution  
           Add a file '_references.js'  
           Add reference statements to jQuery  
             ///\<reference path="jquery-1.16.4.js" />  
             ///\<reference path="jquery-1.16.4.intellisense.js" />  
           Close/Re-open the solution  
           Here is some back story: https://www.madskristensen.net/blog/the-story-behind-_referencesjs/
  - Run-time
    - Error Could not load file or assembly 'blah, Version=blah, Culture=neutral, PublicKeyToken=null' or one of its dependencies.
      - Make sure you have Mixed Platforms set in the Solution Platform dropdown.
    - Key places to put breakpoints:
      - VIX Viewer Service to Client-side/Front-end: src\Hydra.VistA.Web\*Module.cs and Hydra.Web\Modules\*Module.cs
      - Client-side/Front-end request to VIX Viewer Service, in JavaScript: scattered all over the place. Look in ImageURLHandler.js, but that's not all
      - Client-side/Front-end request to VIX Viewer Service, in VIX Viewer: src\Hydra.Web\Modules\*Module.cs and src\Hydra.VistA.Web\*Module.cs
      - VIX Viewer Service request to VIX Java, in VIX Viewer: src\Hydra.VistA\VixClient.cs
      - VIX Viewer Service request to VIX Render Service, in VIX Viewer: src\Hydra.IX.Client\HixConnection.cs and src\Hydra.VistA\VixServiceUtil.cs
      - VIX Viewer Service request to VIX Render Service, in VIX Render: src\HIX\Hydra.IX.Core\Modules\DefaultHixRequestHandler.cs and src\HIX\Hydra.IX.Web\Modules\*Module.cs
    - Where to find ... ?
      - StudyMetadata: src\Hydra.VistA\VixServiceUtil.cs, method=GetDisplayObjectGroups, breakpoint after string studyMetadata = ...
      - Where the cliet code is done loading, preparing, and caching the images and will start to view them: see load_home() in loader.cshtml
    - How to force errors
      - Error opening images - If you think there are images associated with this study, please contact technical support.
        Set the wrong path for the database in VIX.Rener.config and try to view a study
    - EXAMINE THE SPINNER DATA
      - Put a breakpoint in loader.cshtml or common.js in the first statement of function cacheAllImagesFunction(...
      - To see the server-side ...
        - Viewer: Put a breakpoint in Hydra.Web\Modules\ViewerModule.cs in the GetDisplayContext method
        - Render: Put a breakpoint on the switch statement in HIX\Hydra.IX.Core\Modules\DefaultHixRequestHandler.cs in the ProessRequest method
    - HOW TO SEE WHAT PORTS ARE BEING USED ON YOUR MACHINE
      - This is useful, because we use URLs and Ports for network communications.
        - Show all ports in use (cmd): netstat -aon
        - See if a particular port is being used right now (cmd): netstat -aon | findstr "9901"
    - WHEN WE ARE TROUBLESHOOTING AND NEED TO GET AT STUFF (EASTER EGGS)
      - Dash on VIX (/vix/viewer/dash?EasterE88)
      - All C/VIX tools on one page (vix/viewer/tools?All) All displays all, but does not mean they will work
      - viewerURL with login page, add &lp=1 (viewerURL from JLV does not have lp parameter)
    - WHEN WE ARE DEBUGGING IN VISUAL STUDIO ...
      - IN THE DEBUG CONFIGURATION, AND WE DO *NOT* WANT THE RENDER CHILD PROCESSES TO START
        - Set the UseSeparateProcess to false in the Render config file
      - AND WE WANT TO SEE INCOMING HIX REQUESTS
        - Put a breakpoint on the switch statement in HIX\Hydra.IX.Core\Modules\DefaultHixRequestHandler.cs in the ProessRequest method
      - AND WE WANT TO EXAMINE THE SQLite (HIX) or SQLServerCompact (ClearCanvas) DATABASES
       - Run "_Install Files\Scripts\GetDbRecords.cmd" (SQLite only)
       or
       - Extensions > Manage Extensions... > Online > search for SQLite and SQL Server Compact Toolbox, and Install
        - Close Visual Studio when instructed
        - Once installed, open Visual Studio and Tools > SQLite/SQL Server Compact Toolbox, and add a connection of your choice
- Run-time regardless of Visual Studio
  - 500 Server error: Nancy.RequestExecutionException: Oh noes! ---> Nancy.ViewEngines.ViewNotFoundException: Unable to locate view 'dash.cshtml'
    - Did you get the deployed files by unzipping? If so, you probably forgot to unblock all files.
    - Open up a PowerShell window, and enter: Get-ChildItem rootFolderPath -Recurse | Unblock-File
    - Or, right-click on the file in File Explorer, Properties, and check Unblock at the bottom
  - Port conflicts with another program running on this machine
    - Make sure your service isn't already running. If it isn't:
      - Open a cmd window, elevated, and enter: netstat -ano | findstr "yourPortNumber"
      - The right-most integer is the PID that you can see in the Task Manager Details
  - SignalR troubleshooting: https://docs.microsoft.com/en-us/aspnet/signalr/overview/testing-and-debugging/troubleshooting
  - To see VIX Render database records, run "_Install Files\Scripts\GetDbRecords.cmd"
  - WHEN WE ARE DEBUGGING IN THE BROWSER, AND WE WANT TO ...
    - PROGRAMATICALLY ADD A BREAKPOINT
      - Edit the Viewer JavaScript and add a line that says: debugger;
    - SEE THE CONSOLE LOGS
      - Put a breakpoint in common.js right after logPreferences.loglevel = LL_NONE; and when hit, enter this in the Console: logPreferences.loglevel = LL_TRACE
      - And/Or put a breakpoint in logUtility.js on if (logPreferences.loglevel == "None"), and set the loglevel back to LL_TRACE again if needed
    - WALK-THROUGH VIEWING A STUDY
      - Put a breakpoint in dash.js in the first statement of function viewStudy(...
      - Q: How did I know that? A: F12 in browswer, inspect View button that shows viewStudy() is called and searched the Client\Develop code for it
    - TRACK CLIENT-SIDE REQUESTS/RESPONSES IN BROWSER ONLY (HAR FILE)
      - Open Network tab in Developer Tools
        - In Chrome
           - Look for a round button at the top left of the Network tab. Make sure it's red. If it's grey, click it once to start recording
           - Turn on "Preserve log"
          - You can use the clear button (a circle with a diagonal line through it) right before trying to reproduce the issue to remove unnecessary header information
            - Reproduce the issue
           - Save the capture by right-clicking on the grid and choosing "Save as HAR with Content"
        - In Edge
            - Look for a round button at the top left of the Network tab. Make sure it's red. If it's grey, click it once to start recording.
            - Turn on "Preserve log".
            - Reproduce the issue.
            - Save the capture by right-clicking on the grid and choosing "Save as HAR with Content"
      - Tools to process HAR files
        - Analyze https://toolbox.googleapps.com/apps/har_analyzer/
        - Compare https://comp
        - View http://www.softwareishard.com/har/viewer/
