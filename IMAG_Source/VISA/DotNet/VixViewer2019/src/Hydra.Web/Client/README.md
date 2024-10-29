# README FILE FOR Client-side (Front-end) VIX Viewer Web App

## CONTENTS
- [Building](#BUILDING)
- [Languages and Techniques](#LANGUAGES_AND_TECHNIQUES)
- [External Packages](#EXTERNAL_PACKAGES)
- [How to Add a Toolbar Icon/Button](#TOOLBAR_ICON)
- [How to Add a Folder to the Release/Viewer folder](#ADD_DEPLOY_FOLDER)
- [How to Change Legacy Code to Modern Code](#LEGACY_TO_MODERN)
- [How to Change Modern Code to Legacy Code](#MODERN_TO_LEGACY)

## BUILDING<a name="BUILDING"></a>
- src\VIX.Viewer.Service\bin\x64\SOLUTION_CONFIGURATION\Viewer is created by the src\VIX.Viewer.Service project.
  - When SOLUTION_CONFIGURATION is Debug, Develop gets automatically COPIED to src\VIX.Viewer.Service\bin\x64\Debug\Viewer to ease browser debugging.
  - When SOLUTION_CONFIGURATION is Release, Release gets automatically MOVED to src\VIX.Viewer.Service\bin\x64\Release\Viewer.
- Build\dobuild.cmd ...
  - is called when SOLUTION_CONFIGURATION is Release.
  - creates the Release folder by running dobuildPostEs6.cmd and dobuildPreEs6.cmd.
- You can optionally run Build\dobuild.cmd in a cmd window.

## LANGUAGES AND TECHINIQUES<a name="LANGUAGES_AND_TECHNIQUES"></a>
- JavaScript is the language used on the front-end. It is not a separate package. Browsers, node.js, and other software have their own JavaScript engine that runs JavaScript scripts.
  - References:
    - https://exploringjs.com/impatient-js/toc.html
    - https://eloquentjavascript.net/ and https://eloquentjavascript.net/code
    - https://jsdoc.app
- ECMAScript (https://www.ecma-international.org/) is a specification that JavaScript (https://developer.mozilla.org/en-US/docs/Web/JavaScript) follows.
  - The TRM JavaScript page points to ECMAScript. Minification must match the ES (ECMAScript) version.
  - ES6 stands for ECMAScript 6, where 6 is the version of the spec introduced in 2015. Most of Hydra client code was written before that ("PreEs6").
  - ES2019 stands for the ECMAScript 2019, where 2019 is the year and the version.
  - See esArgs in dobuildPostEs6.cmd to see what version we are using for the modern code we write.
- What is unusual (and good) about JavaScript and ECMAScript is that we do not check for a certain version, but we check if *features* are available.
  - https://caniuse.com/es6 or https://caniuse.com/const
  - https://davidwalsh.name/hasjs or https://modernizr.com/
- NOTE: We want to migrate legacy code into modern code, but we cannot do it all at once. See the HOW TO CHANGE LEGACY CODE TO MODERN CODE topic.
- Ajax (https://developer.mozilla.org/en-US/docs/Web/Guide/AJAX) is a technique we use in Hydra by JavaScript and jQuery. Ajax can be called by other languages, too.

## EXTERNAL PACKAGES<a name="EXTERNAL_PACKAGES"></a>
It is a balancing act to keep these up-to-date with the TRM and in sync. There is little-to-none test code.
- Bootstrap (https://getbootstrap.com/) is a framework for HTML and CSS to enhance and quicken the development of websites and web apps.
- jQuery (jquery.com) is a JavaScript library.
- jQuery-UI (jqueryui.com) is a widget and interaction library implemented by jQuery. jQuery-UI's compatibility with jQuery is listed here: https://github.com/jquery/jquery-ui/blob/main/bower.json
- Kendo UI (https://github.com/telerik/kendo-ui-core) is an HTML5, jQuery-based widget library.
- SignalR (https://github.com/SignalR/SignalR) is an ASP.Net library that lets the server-side push to the client-side.

## HOW TO ADD A TOOLBAR ICON/BUTTON<a name="TOOLBAR_ICON"></a>
- Create a png in your image editor of choice, such as MS Paint, at 256x256 or 128x128, with background bright pink, and copy
- Paste the image in irfanview (or gimp, or ImageMagick, etc.) with the main window color brigh pink
- Change any white to red, then black to white, then red to black as needed
- Resize to 128x128 if needed
- File > Save As (into image folder), Check Save Transparent color under PNG and ICO, Uncheck Save Transparency as Alpha channel, Check Use main window for transparency
- In js\toolbar.js:
  - Add var xElement = $("#xButton"); to the disableOrEnableDicomTools method with the other elements, where x is the name of the button
  - Choose where to place the button in the existing sequence, and add an item in $("#toolbar").kendoToolBar as follows:
    {
       type: "button",
       text: "",
       id: "xButton",
       title: "Y",
       imageUrl: "images/x.png",
       click: dicomViewer.tools.Z
    }
    where x = name of button, Y is the title for hover text / tooltip, and Z is the method to call
- Choose a toolbar icon that you want to mimic, and duplicate its code in toolbar.js, 3DImageViewPort.js, imageViewPort.js, 3DView*.cshtml, view*.cshtml, and others as needed
- Add a list item (li) element to <ul id="contextMenu" in 3DView*.cshtml and view*.cshtml

## HOW TO ADD A FOLDER TO THE RELEASE/VIEWER FOLDER<a name="ADD_DEPLOY_FOLDER"></a>
We can use relative paths for the files under Client\Develop (DEBUG) or VIX.Viewer.Service\bin\x64\Release\Viewer (RELEASE) when added to 
nancyConventions.StaticContentsConventions (see src\VIX.Viewer.Service\CustomBootstrapper.cs). Compare dash.cshtml to viewer.cshtml for more info.
You'll also need to update the Client\Build files, of course.

## HOW TO CHANGE LEGACY CODE TO MODERN CODE<a name="LEGACY_TO_MODERN"></a>
- Individual files
  - When changing a .js file and we find the build fails because modern code was used in the PreES6 build, a quick test is to run:
    - src\Hydra.Web\Client\Build\dobuildPostEs6 filePath
    - If that works, move the code to the build PostEs6 build. Run the Release code with Dev Tools activated, and fix any console errors.
    - That's the minimum amount of work. Test!
  - Run code through eslint or https://validatejavascript.com/
  - Go to http://linterrors.com/js/option-jshint-es3 to ensure syntax is correct
- Generally speaking
  - Here are some articles we should consider:
    - https://www.thinkcompany.com/blog/refactoring-mountains-of-legacy-javascript-code/
    - I commented out some code with //TODO VAI-919: blah. These should be the first files we change for esbuild (dobuildPostEs6.cmd)
  - If we had all the time in the world or a large dev team, we could scan the code looking for legacy techniques, such as for loops, and modernize.

## HOW TO CHANGE MODERN CODE TO LEGACY CODE<a name="MODERN_TO_LEGACY"></a>
- Copy your modern code to the Windows clipboard
- Go to https://babeljs.io/repl, and paste it in the left-hand panel, which generates code in the right-hand panel
- Copy the generated code in the right-hand panel to the clipboard
- Go to https://jsfiddle.net/, and paste the legacy code into the JavaScript panel, and test it
- Go to http://linterrors.com/js/option-jshint-es3 to ensure syntax is correct
