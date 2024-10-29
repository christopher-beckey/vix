/**
 * This module cache and handle the security token
 */

var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var securityToken = null;

    /**
     *@param token
     *set the security token from the url to securityToken
     */
    function setSecurityToken(token) {
        securityToken = token;
    }

    /**
     *Get the security token from the securityToken variable
     */
    function getSecurityToken() {
        return securityToken;
    }

    dicomViewer.security = {
        setSecurityToken: setSecurityToken,
        getSecurityToken: getSecurityToken
    }

    return dicomViewer;
}(dicomViewer));
