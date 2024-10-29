var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    $(document).ready(function () {

    });

    $(window).resize(function () {
        if (!isMaximized) {
            minimizePanel();
        } else {
            setTimeout(function () {
                $(".ui-layout-resizer").hide();
            }, 220);
        }

        filterCallStack($("#filterBy").val());
    });

    var enableConsoleLog = false;
    var enableCallStack = true;
    var isMaximized = false;
    var firstEntry = false;

    var logClasses = [".tracelog", ".debuglog", ".infolog", ".warnlog", ".errorlog"];
    var preferences = ["loglevel", "linelimit", "keys"];

    function initialze() {
        $("#filterBy").change(function () {
            $(".headerlog").hide();
            filterCallStack(this.value);
        });

        if (window.console) {
            enableConsoleLog = true;
        }

        if (enableCallStack) {
            document.addEventListener('keydown', function (event) {
                var splitValue = ["CTRL", "Z"];
                if (logPreferences["keys"]) {
                    splitValue = logPreferences["keys"].split("+");
                }

                var isKeyCheckIE = false;
                if ((event.key).toUpperCase() !== splitValue[splitValue.length - 1]) {
                    isKeyCheckIE = true;
                }

                var isKeyCheckChrome = false;
                if (event.code !== "Key" + splitValue[splitValue.length - 1]) {
                    isKeyCheckChrome = true;
                }

                if (isKeyCheckIE && isKeyCheckChrome) {
                    return;
                }

                if (event.ctrlKey != (logPreferences["keys"].indexOf("CTRL") > -1)) {
                    return;
                }

                if (event.altKey != (logPreferences["keys"].indexOf("ALT") > -1)) {
                    return;
                }

                if (event.shiftKey != (logPreferences["keys"].indexOf("SHIFT") > -1)) {
                    return;
                }

                minimizePanel();
                togglePanel();
                filterCallStack($("#filterBy").val());

            });
        }
        //var userPref =  getLogPreference('user');
        //var sysPref =  getLogPreference('SYS');

        logPreferences = {
            loglevel: LL_NONE,
            linelimit: "1000",
            keys: "CTRL+Y",
            useDefault: false
        };

        /*if(userPref) {
            if(userPref.useDefault == false){
                logPreferences = userPref;
            } else if(sysPref){
                logPreferences = sysPref;
            }
        }*/

        clearLog();
        addLogPreferenceTag();
        setLogPreference(logPreferences);

        if (!enableConsoleLog) {
            var logParam = {
                level: LL_WARN,
                message: ("window.console is undefined")
            };
            writeLog(logParam);
        }
    }

    /**
     * Get user/global preference from viewer service
     * @param {Type} type - Specifies the type
     */
    function getLogPreference(type) {
        var preferenceData = null;
        var requestUrl = dicomViewer.getLogConfigUrl(type);

        try {
            $.ajax({
                    url: requestUrl,
                    cache: false,
                    async: false
                })
                .done(function (data) {
                    if (data) {
                        preferenceData = JSON.parse(data);
                        return preferenceData;

                    }
                });
        } catch (e) {

        } finally {}
        return preferenceData;
    }

    function togglePanel() {
        var callStackHeader = document.getElementById("callStackHeader");
        callStackHeader.classList.toggle("show");
        var callStackPanel = document.getElementById("callStackPanel");
        callStackPanel.classList.toggle("show");
    }

    function addLogPreferenceTag() {
        $.each(preferences, function (key, value) {
            $("#logPreferences").append('<br/>' + value.toUpperCase() + ' : <label id="' + value.toLowerCase() + '"style="width:80px"> </label>');
        });
        $("#logPreferences").append('<br/>');
        $("#logPreferences").append("************************************");
    }

    function setLogPreference(pref) {
        if (!pref) {
            var logConfig = dicomViewer.configuration.log.getLogPreference("USER", true);
            pref = [];
            pref["loglevel"] = logConfig.logLevel;
            pref["linelimit"] = logConfig.lineLimit;
            pref["keys"] = logConfig.keys;
        }
        var prevclassname = getByLevel(logPreferences["loglevel"], 2);
        $.each(preferences, function (key, value) {
            $("#" + value.toLowerCase())[0].innerHTML = pref[value];
        });
        $("#loglevel").removeClass(prevclassname).addClass(getByLevel(pref["loglevel"], 2));
        $("#filterBy").val(pref["loglevel"]);
        filterCallStack($("#filterBy").val());
        logPreferences = pref;
    }

    function filterCallStack(level) {
        $("#stackMessage").remove();
        if (level == "All") {
            handleStacks("show");
            $(".headerlog").show();
        } else {
            handleStacks("hide");
            var stack = getByLevel(level, 2);
            $("#" + stack + ".headerlog").show();
            if ($("p." + stack).length == 0) {
                var classname = getByLevel(level, 2);
                var stack = '<p id="stackMessage" class=' + classname + '><span style="vertical-align:middle"> No ' + level + ' logs available</span></p>';
                $("#callStackPanel").append(stack);
            } else {
                $("p." + stack).show();
                $("p." + stack).children().show();
                $("p." + stack).children().css("display", "inline-block");
            }
        }
    }

    function clearLog() {
        if (enableConsoleLog) {
            window.console.clear();
        }

        if (enableCallStack) {
            handleStacks("remove");
        }
        $(".headerlog").remove();
        filterCallStack($("#filterBy").val());
    }

    function handleStacks(display) {
        var emptyCount = 0;
        $.each(logClasses, function (key, value) {
            value = "p" + value;
            if (display == "hide") {
                $(value).hide();
            } else if (display == "show") {
                $(value).show();
                if ($(value).length == 0) {
                    emptyCount++;
                } else {
                    $(value).children().show();
                    $(value).children().css("display", "inline-block");
                }
            } else if (display == "remove") {
                $(value).remove();
            }
        });
        if (emptyCount == logClasses.length) {
            var stack = '<p id="stackMessage" class="infolog"><span style="vertical-align:middle"> No logs available</span></p>';
            $("#callStackPanel").append(stack);
        }
    }

    function writeLog(logParam, isAsync, skipConsole) {
        if ($("#callStackPanel br").length >= logPreferences["linelimit"]) {
            clearLog();
            writeClearLog();
        }
        var isHeader = (logParam.type == "header") ? true : false;
        var prefix = (isHeader || !isAsync) ? "\t\t" : (logParam.level + " : ");
        var align = (isHeader) ? "middle" : "left";
        var display = getDisplayOption(logParam.level, isHeader);
        var logLevel = getByLevel(logParam.level, 2);
        var classname = (isHeader) ? "headerlog" : logLevel;

        if (logParam.message.indexOf("Method :") > -1) {
            prefix = "-------------------------------------------" + prefix;
        }

        if (enableConsoleLog && !skipConsole) {
            var fnConsole = getByLevel(logParam.level, 1);
            if (fnConsole) {
                fnConsole(prefix + logParam.message);
            }
        }

        if (enableCallStack) {
            var lastChild = isSameLogLevel(classname);
            var isUrlMessage = (logParam.message.indexOf("url : ") >= 0) ? true : false;
            if ((lastChild) && !isHeader) {
                var spanElement = $("#callStackPanel")[0].lastChild.lastChild;
                if (spanElement) {
                    var message = (spanElement.innerHTML + '\n' + prefix + (isUrlMessage ? formatUrlMessage(logParam.message) : logParam.message));
                    if (!firstEntry) {
                        firstEntry = true;
                        message = '\n' + message;
                    }
                    spanElement.innerHTML = parseMultiLine(message);
                    setTimeout(function () {
                        spanElement.style.display = (display == "block") ? "inline-block" : "none";
                    }, 0);
                }
            } else {
                firstEntry = false;
                var message = logParam.message;
                var stack = '<p id=' + logLevel + ' class=' + classname + '>' + getSpanElement(align, display, prefix, message, isUrlMessage) + '</p>';
                $("#callStackPanel").append(stack);
            }
        }
    }

    function getSpanElement(align, display, prefix, message, isUrl) {
        if (isUrl) {
            return '<span style="vertical-align:' + align + ';display:' + display + '">' + prefix + formatUrlMessage(message) + '</span>';
        }
        return '<span style="vertical-align:' + align + ';display:' + display + '">' + prefix + parseMultiLine(message) + '</span>';
    }

    function formatUrlMessage(message) {
        var splitMessage = message.split("url : ");
        var prefix = splitMessage[0] + "url : ";
        var suffix = "";
        splitMessage = splitMessage[1].split("\n");
        url = splitMessage[0];
        if (splitMessage.length > 1) {
            suffix = splitMessage[1];
        }
        return prefix + '<a href=# class="urllog">' + url + '</a>' + "<br/>" + suffix;
    }

    function isSameLogLevel(classname) {
        var lastChild = $("#callStackPanel")[0].lastChild;
        if (lastChild.classList) {
            if (lastChild.classList[0] == classname) {
                return lastChild;
            }
        }
        return false;
    }

    function writeClearLog() {
        var logParam = {
            level: LL_INFO,
            type: "header",
            message: "\n************************************ \
                       \nReaches line limit, logs are cleared\n \
                       ************************************"
        }
        writeLog(logParam);
    }

    function getDisplayOption(level, isHeader) {
        var display = "none";
        var filterLevel = $("#filterBy").val();
        if (filterLevel == "All" || filterLevel == level) {
            display = isHeader ? "inline-block" : "block";
            $("#stackMessage").remove();
        }
        return display;
    }

    function isLogLevelEnabled(level) {
        if (logPreferences["loglevel"] == "None") {
            return false;
        }
        var isSelLogLevel = (logPreferences["loglevel"] == level);
        switch (logPreferences["loglevel"]) {
            case LL_TRACE:
                return true;
                break;
            case LL_DEBUG:
                return isSelLogLevel || level == LL_INFO || level == LL_WARN || level == LL_ERROR;
                break;
            case LL_INFO:
                return isSelLogLevel || level == LL_WARN || level == LL_ERROR;
                break;
            case LL_WARN:
                return isSelLogLevel || level == LL_ERROR;
                break;
            case LL_ERROR:
                return isSelLogLevel;
                break;
        }
    }

    function parseMultiLine(message) {
        return message.replace(/\n/g, "<br/>");
    }

    function getByLevel(level, type) {
        switch (level) {
            case LL_TRACE:
                return (type == 1) ? window.console.trace : "tracelog";
                break;
            case LL_DEBUG:
                return (type == 1) ? window.console.debug : "debuglog";
                break;
            case LL_INFO:
                return (type == 1) ? window.console.info : "infolog";
                break;
            case LL_WARN:
                return (type == 1) ? window.console.warn : "warnlog";
                break;
            case LL_ERROR:
                return (type == 1) ? window.console.error : "errorlog";
                break;
        }
    }

    function minimizePanel() {
        isMaximized = false;

        $("#callStackHeader").css("position", "absolute");
        $("#callStackPanel").css("position", "absolute");

        $("#callStackHeader").css("max-width", "88%");
        $("#callStackHeader").css("max-height", "100px");

        $("#callStackPanel").css("max-width", "88%");

        $("#callStackHeader").width("88%");
        $("#callStackHeader").height("100px");

        var viewerLeft = parseInt($("#viewer").css("left"));
        var viewerTop = parseInt($("#viewer").css("top"));
        var viewerHeight = $("#viewer").height() * 0.3;
        var headerHeight = $("#callStackHeader").height();

        $("#callStackHeader").css("left", viewerLeft + "px");
        $("#callStackHeader").css("top", (viewerTop + viewerHeight) + "px");

        $("#callStackPanel").css("left", viewerLeft + "px");
        $("#callStackPanel").css("top", (viewerTop + viewerHeight + headerHeight) + "px");

        $("#callStackPanel").width("88%");
        var panelHeight = $("#viewer").height() - parseInt($("#callStackHeader").css("top")) - 20;
        $("#callStackPanel").css("max-height", panelHeight + "px");
        $("#callStackPanel").height(panelHeight + "px");

        $("#callStackHeader").css("background-color", "rgba(52, 52, 52, 0.3)");
        $("#callStackPanel").css("background-color", "rgba(52, 52, 52, 0.3)");

        $(".ui-layout-resizer").show();
    }

    function maximizePanel() {
        isMaximized = true;

        $("#callStackHeader").css("position", "absolute");
        $("#callStackPanel").css("position", "absolute");

        $("#callStackHeader").css("max-width", "100%");
        $("#callStackHeader").css("max-height", "110px");

        $("#callStackPanel").css("max-width", "100%");
        $("#callStackPanel").css("max-height", "88%");

        $("#callStackHeader").width("100%");
        $("#callStackHeader").height("110px");

        $("#callStackPanel").width("100%");
        $("#callStackPanel").height("100%");

        $("#callStackHeader").css("left", "0px");
        $("#callStackHeader").css("top", "0px");

        var panelTop = $("#callStackHeader").height();
        $("#callStackPanel").css("left", "0px");
        $("#callStackPanel").css("top", panelTop);

        $("#callStackHeader").css("background-color", "rgba(52, 52, 52, 1)");
        $("#callStackPanel").css("background-color", "rgba(52, 52, 52, 1)");

        $(".ui-layout-resizer").hide();
    }

    function closePanel() {
        togglePanel();
    }

    dicomViewer.logUtility = {
        initialze: initialze,
        togglePanel: togglePanel,
        clearLog: clearLog,
        isLogLevelEnabled: isLogLevelEnabled,
        writeLog: writeLog,
        minimizePanel: minimizePanel,
        maximizePanel: maximizePanel,
        closePanel: closePanel,
        setLogPreference: setLogPreference
    };

    return dicomViewer;

}(dicomViewer));
