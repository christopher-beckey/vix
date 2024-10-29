README FILE FOR MockService

This is a web app and service that pretends to be C/VIX so that the VIX Viewer's VixClient has something to call for demo/debugging purposes.
Run this web app and point the VIX Viewer's Local RootUrl to this Project's Url. See Mock in VIX.Viewer.config.
It might not be complete, meaning all web api calls in VixClient might not be implemented yet.

************************************* INSTALL EXISTING ****************************************

Please follow these steps to install the existing sample images and templates

Step 1: (One time setup) Add Setup\setup.cmd as an External Tool like this:
1. Click Tools->External Tools…
2. Click Add
3. For Title, enter &MockServiceSetup
4. For Command, enter C:\Windows\System32\cmd.exe
5. For Arguments, enter /c $(ProjectDir)\Setup\setup.cmd
6. Click OK

Step 2: Whenever you want to run Setup\setup.cmd, it is now on your Tools menu as MockServiceSetup.
If you do not change the default DataSource path in VIX.Render.config, you will overwrite the database for the installed service!
If you opened the Hydra.sln (instead of the MockService.sln), you will need to select the MockService project before running the menu item.
***** NOTE: THIS OVERWRITES:
    C:\VixConfig\MockService\xml\
    C:\VixCache\va-image-region\660\icn(1008861107V475740)\26732Mock\
    (The Datasource folder from the VIX.Render.config)

Step 3: Follow the directions on the Info page.

************************************* ADD A NEW SAMPLE ****************************************

Please follow these steps to add a new sample file:

1. Run the VIX, VIX Render, and VIX Viewer code and access the Dash.
2. Do NOT put a dash (-) in the file name.
3. To create a new Setup\XML\fileType\GetStudyMetadata.xml file:
   1. Either:
        Add a breakpoint after string studyMetadata in the code described in the Hydra.sln's README.md file under the topic "Where to find ... ?" > StudyMetadata.
      Or
        Run Developer Tools in the browser, do what you want to do, then right-click in the Network grid, save the HAR to a file and view the file.
   2. View the study.
   3. Copy and paste the XML into the new file.
      Remove the lines so the file starts with <studies> and ends with </studies>.
      For each Uri in your study that you want:
        Change the site number to 660, group ien to 26732Mock, 2nd group number to the filename(s) you rename in the next step, and the patient to 1008861107V475740.
          For example:
            From: 756-7230-7229-9299999980V804874
            To:   660-26732Mock-CT_WasBadLungLevel.DCM-1008861107V475740
        Also change the ImageId.
4. Get the original file(s) from VixRenderCache\Images, save them in Setup\XML\ImagesToImport, and rename them with descriptive names and extensions.
5. Add an entry to Views\Select.cshtml.

************************************* TO DO ****************************************

Please place more important changes higher in the list
/ViewerImagingWebApp/token/restservices/viewerImaging/getDeleteReasons
AVI - Started, but not working. TO DO: Fix.
TXT
xml
DOC
SVG
mpeg3/mp3
mp4
CDA
wav

************************************* TROUBLESHOOTING ****************************************
Runtime
- Maximum request length exceeded.
  - Ultimately, I would like to have an async file uploader, but until then, do the following.
  - Increase 