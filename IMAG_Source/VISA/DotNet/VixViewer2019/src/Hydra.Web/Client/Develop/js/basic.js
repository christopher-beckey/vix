/*
 * Basic, simple, functions independent from any other JavaScript file/module/class/library
 */

(function (global) {

    /*
     * Get the current URL Parameters, if any, after the question-mark (?)
     * @param {any} toDecode Whether to decode the URL parameters or not. Defaults to false.
     * @returns The parameters, decoded if toDecode is true
     */
    function getCurrentUrlParamsAfterQM(toDecode = false) {
        if (toDecode) {
            return decodeURIComponent(window.location.search.substring(1));
        } else {
            return window.location.search.substring(1);
        }
    }

    /*
     * Get the value of a URL parameter if it is in the specified URL (case insensitive match), otherwise return an empty string.
     * @param {string} paramName
     * @param {string} url Can be static, but defaults to current URL
     * @param {boolean} toDecode Whether to decode the URL parameter or not. Defaults to false.
     * @returns Value of parameter or empty string if not found
     */
    function getUrlParameter(paramName, url = window.location.href, toDecode = false) {
        if (typeof paramName == 'string') {
            if ((paramName === undefined) || (paramName.trim() === "")) {
                return "";
            }
        } else {
            console.error("Error: getUrlParameter(), paramName is not a string");
            return "";
        }
        if (typeof url == 'string') {
            if ((url === undefined) || (url.trim() === ""))
                url = window.location.href;
        }
        else {
            console.error("Error: getUrlParameter(), url is not a string");
            return "";
        }
        try {
            var i = url.indexOf("?");
            if (i == -1) {
                return "";
            }
            let urlParamString = url.substring(i + 1); //strip off the question-mark (?)
            var paramNameLower = paramName.toLowerCase();
            if (toDecode) {
                urlParamString = decodeURIComponent(urlParamString);
            }
            urlParamString = urlParamString.replace(/&amp;/g, "&");
            var urlParams = urlParamString.split('&');
            for (i = 0; i < urlParams.length; i++) {
                // use indexOf instead of split since some security tokens have trailing '=' characters
                var eq = urlParams[i].indexOf("=");
                var key = eq > -1 ? urlParams[i].substr(0, eq) : urlParams[i];
                var val = eq > -1 ? urlParams[i].substr(eq + 1) : "";

                if (key.toLowerCase() == paramNameLower) {
                    //Somewhere (where?) in the code, SecurityToken was followed by %23lblTypeMenu1%7Ccontent_View1 that should not be there, so strip it out
                    if (paramNameLower == "securitytoken") {
                        i = val.indexOf("#");
                        if (i != -1) {
                            val = val.substring(0, i - 1);
                        }
                        i = val.indexOf("%23");
                        if (i != -1) {
                            val = val.substring(0, i - 3);
                        }
                        i = val.indexOf("%3d");
                        if (i != -1) {
                            val = val.replace("%3d", "=");
                        }
                    }
                    return val;
                }
            }
        } catch (e) {
            console.error("Error: getUrlParameter(" + paramName + ") - " + e);
        }
        return "";
    }

    /*
     * Generate a version 4 GUID/UUID (VAI-760).
     * https://developer.mozilla.org/en-US/docs/Web/API/Crypto/randomUUID
     * Note this only works on localhost (or the localhost's fqdn), file:, and HTTPS, and any other secure contexts.
     * @returns A secure GUID/UUID that is difficult to reverse engineer by hackers.
     */
    function GetV4Guid() {
        let guid = self.crypto.randomUUID(); // for example "36b8f84d-df4e-4d49-b662-bcde71a8764f"
        return guid;
    }

    global.basicObj = {
        getCurrentUrlParamsAfterQM: getCurrentUrlParamsAfterQM,
        getUrlParameter: getUrlParameter,
        GetV4Guid: GetV4Guid
    };

})(window);

var BasicUtil = window.basicObj;
