README FILE FOR RECURSIVEFOLDERFILES PROGRAM

The best way to run this program is from a cmd window.

You can cd to a directory and run this program, that outputs to stdout, the file information in the current folder and its children.
If an empty folder is encountered, it is output with an explanation.

You can also run the recurse.cmd batch file that saves the output to a text file instead of stdout.  See comments at the top of the .cmd file.

The output is like CSV, except the delimiter is | instead of a comma.
The "Folders with restricted access:" label lists any files whose info cannot be obtained due to access permissions.