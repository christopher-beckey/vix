README FILE FOR API DOCUMENTATION

Reasons this documentation is not published with the normal user documentation:
- It helps us monitor who uses this API, because they need to request it from us (unless a user sends it to someone else, which we do not control).
- The user documentation is for the user interface, whereas this doc is for the developer.

One-time Setup
- If you do not have NPM installed, follow the instructions in How to Install NPM.pdf to install Node.js and NPM.
- Add this, C:\Program Files\nodejs\npm, to the end of your System PATH environment variable.
- Open a new cmd window, and:
  - Enter this, npm config set strict-ssl false, to disable strict SSL.
  - Enter this, npm install -g redoc-cli, to install the redoc command line interface. If that fails, unzip redoc-cli.zip, and follow the instructions in redoc-cli.txt.

Typical operations
- Update opanapi.json as needed.
  - It follows the OpenApi 3.x spec (https://github.com/OAI/OpenAPI-Specification/tree/main/versions).
  - Note that generate.cmd replaces REPLACE_VERSION_NUMBER with the correct version number of the patch release, so leave that alone.
- You can run generate.cmd either in a cmd window cd'd to this folder or double-clicking in File Explorer, but you do not need to, because the
  .csproj does it.
- VVSDoc.html is the generated doc that we send to the developers who will call the API. It is also deployed at the same level as the dash.
  To change the doc, edit the HTML that is the description tag's value. It easier if you copy and paste it into Notepad++, LibreOffice, or Word
  for temporary formatting and editing.

Converting openapi.json to a newer OpenApi standard 
- Copy the contents of openapi.json, and paste it into https://editor.swagger.io/.
  - If the site prompts you if you want to convert it to yaml, select yes.
  - Observe the display in the right-hand column, and make any necessary adjustments if there are errors.
  - File > Convert and save as JSON, and overwrite your local openapi.json file.
- Run generate.cmd to ensure redoc-cli still works. If it doesn't, we'll have to use swagger-ui-cli instead of redoc-cli.
- Update our TRM spreadsheet.
- Per the TRM (https://www.oit.va.gov/Services/TRM/StandardPage.aspx?tid=8259), the latest approved version at the time of this writing is 
  3.1.0 (https://github.com/OAI/OpenAPI-Specification/tree/master/versions), but https://editor.swagger.io/ (v4) did not convert it to 3.1.0.
  According to the following page [1], Swagger v4 PREPARES for 3.1, but the following page [2] shows that v4.0 is not compatible with 3.1.0.
  [1] https://swagger.io/blog/api-design/what%E2%80%99s-ahead-for-swaggerui-v4-and-swaggereditor-v4/
  [2] https://www.npmjs.com/package/swagger-ui