README FILE FOR Hydra.Web\Client\Build

For Pre-ECMAScript 6 (Pre-ES6):
- Download and unzip Apache Ant from https://ant.apache.org/bindownload.cgi
- We know this works as of 1.10.9
- Set ANT_HOME environment variable to ant's bin path, such as E:\Portable\apache-ant-1.10.9
- If you want to try one file on the command line: java -jar lib\yuicompressor-2.4.2.jar --charset ANSI -o foo.min.js ..\Develop\js\foo.js

Edit the .js and .cshtml files in the Develop (HYDRA_ROOT_PATH\src\Hydra.Web\Client\Develop) folder as needed

See ..\readme.md for info on building.
TODO: Remove this file when we no longer need pre-ES6 files.
