<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Viewer</title>
    <style type="text/css">
    html, body {
        height: 100%;
        overflow: auto;
    }
    body {
        padding: 0;
        margin: 0;
    }
    #silverlightControlHost {
        height: 100%;
        text-align:center;
    }
    </style>
    <script type="text/javascript" src="Silverlight.js"></script>
    <script type="text/javascript">
        function onSilverlightError(sender, args) {
            var appSource = "";
            if (sender != null && sender != 0) {
                appSource = sender.getHost().Source;
            }

            var errorType = args.ErrorType;
            var iErrorCode = args.ErrorCode;

            if (errorType == "ImageError" || errorType == "MediaError") {
                return;
            }

            var errMsg = "Unhandled Error in Silverlight Application " + appSource + "\n";

            errMsg += "Code: " + iErrorCode + "    \n";
            errMsg += "Category: " + errorType + "       \n";
            errMsg += "Message: " + args.ErrorMessage + "     \n";

            if (errorType == "ParserError") {
                errMsg += "File: " + args.xamlFile + "     \n";
                errMsg += "Line: " + args.lineNumber + "     \n";
                errMsg += "Position: " + args.charPosition + "     \n";
            }
            else if (errorType == "RuntimeError") {
                if (args.lineNumber != 0) {
                    errMsg += "Line: " + args.lineNumber + "     \n";
                    errMsg += "Position: " + args.charPosition + "     \n";
                }
                errMsg += "MethodName: " + args.methodName + "     \n";
            }

            throw new Error(errMsg);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" style="height:100%">
    <div id="silverlightControlHost">
        <object data="data:application/x-silverlight-2," type="application/x-silverlight-2" width="100%" height="100%">
          <param name="source" value="ClientBin/Viewer.xap"/>
          <param name="onError" value="onSilverlightError" />
          <param name="background" value="white" />
          <param name="minRuntimeVersion" value="5.0.61118.0" />
          <param name="autoUpgrade" value="true" />
          <param name="initParams" value="iv=ZmVkY2JhOTg3NjU0MzIxMA==,ct=ZflDsgulVGU8q1Wwl1miF25PE5vkmGTQL09xuBPrmGraM/VMmiTTVRCj/FgIO1eGfAcDICaJfJU2n4ZwaLqxFvBNo0Mt6QdgK1vFBwoOlptCwfZtEvDlk8hlMiPUfs3US4naGAsRgG1wIYdxD4xTFjnfxpHgXAkHQxGXR+cKbgeaj+9Ekxiyn88ZBCO7TRzsCQLTBUo32EgWA5018aYeauLukpeeRoL3S7o2mFJkXnjmfvIDdKAALyf/DInaRiI7lGb8r3UHfP7rEvMOSnSMK4bsXt871NcsyP2N3KpLK+qhje84+n4qaSivmAYdRWUliCDqST3YSZw+Z/P5vP4h8eGuN18w+jsDDQ6DGsfB+7qZ8pwz5aH+TO2KcExuAejB0ZlVjpTrvMTljVO5DZ7VY0TsQB7JLPHuQXxeT7xQivQOX5Yfk/OvE/XOTFM1IOWq" />
          <a href="http://go.microsoft.com/fwlink/?LinkID=149156&v=5.0.61118.0" style="text-decoration:none">
              <img src="http://go.microsoft.com/fwlink/?LinkId=161376" alt="Get Microsoft Silverlight" style="border-style:none"/>
          </a>
        </object><iframe id="_sl_historyFrame" style="visibility:hidden;height:0px;width:0px;border:0px"></iframe></div>
    </form>
</body>
</html>
