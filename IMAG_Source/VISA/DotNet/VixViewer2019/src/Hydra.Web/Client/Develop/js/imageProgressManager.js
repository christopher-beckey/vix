var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }
    //spinnerConfig contains the size of the spinner color and rotation speed
    var spinnerConfig = {
        lines: 15, // The number of lines to draw
        length: 20, // The length of each line
        width: 10, // The line thickness
        radius: 50, // The radius of the inner circle
        corners: 1.5, // Corner roundness (0..1)
        rotate: 0, // The rotation offset
        direction: 1, // 1: clockwise, -1: counterclockwise
        color: '#F0FFF0', // #rgb or #rrggbb or array of colors
        speed: 1, // Rounds per second
        trail: 60, // Afterglow percentage
        shadow: false, // Whether to render a shadow
        hwaccel: false, // Whether to use hardware acceleration
        className: 'spinner', // The CSS class to assign to the spinner
        zIndex: 2e9, // The z-index (defaults to 2000000000)
        top: '50%', // Top position relative to parent
        left: '50%' // Left position relative to parent
    };
    //store the values based on viewport id as key and spinner object as value
    var spinners = {};
    /**
     *Return the spinnerConfig object
     */
    function getSpinnerConfig() {
        return spinnerConfig;
    }
    /**
     *@param viewportId
     *@param spinner
     *Using the viewport id we are storing the spinner object
     */
    function putSpinner(viewportId, spinner) {
        if (viewportId === undefined) {
            throw "putSpinner : view port id should not be null/undefined";
        }
        if (spinner === undefined) {
            throw "putSpinner : spinner object should not be null/undefined";
        }
        spinners[viewportId] = spinner;
    }
    /**
     *@param viewportId
     *retrive the spinner object based on the viewport id
     */
    function getSpinner(viewportId) {
        if (viewportId === undefined) {
            throw "getSpinner : view port id should not be null/undefined";
        }
        return spinners[viewportId];
    }
    /**
     *@param targetElement
     *Based on the target element create the spinner object and return
     */
    function createAndGetSpinner(targetElement) {
        if (targetElement === undefined) {
            throw "createAndGetSpinner : targetElement should not be null";
        }
        var target = document.getElementById(targetElement);
        if (target === undefined || target === null) {
            throw "createAndGetSpinner : target element is undefined";
        }

        // clear empty spinners
        clearEmptySpinners();

        return new Spinner(getSpinnerConfig()).spin(target);
    }
    /**
     *@param top
     *@param left
     *Set the postion of the spinner object based on top and left values
     */
    function setTopLeftValues(top, left) {
        if (top === undefined) {
            throw "setTopLeftValues: top value need to be set";
        }
        if (left === undefined) {
            throw "setTopLeftValues: left value need to be set";
        }
        var spinnerConfig = getSpinnerConfig();
        spinnerConfig.top = top + 'px';
        spinnerConfig.left = left + 'px';
    }

    function updateSpinnerInnerText(targetElement, innerText) {
        if (targetElement === undefined) {
            throw "createAndGetSpinner : targetElement should not be null";
        }
        var target = document.getElementById(targetElement);
        if (target === undefined || target === null) {
            throw "createAndGetSpinner : target element is undefined";
        }

        // clear empty spinners
        clearEmptySpinners();

        return new Spinner(getSpinnerConfig()).spin(target, innerText);
    }

    /**
     * Clear the empty spinners
     */
    function clearEmptySpinners() {
        try {
            if (spinners === null ||
                spinners === undefined ||
                spinners.length === 0) {
                return;
            }

            var emptySpinners = [];
            $.each(spinners, function (key, value) {
                if (value.el === undefined) {
                    emptySpinners.push(key);
                }
            });

            // Remove the spinners
            emptySpinners.forEach(function (spinner) {
                delete spinners[spinner];
            });
        } catch (e) {}
    }

    /** 
     * set the spinner date as per the viewport dimensions
     * @ param progressbar
     */
    function setSpinnerData(progressbar) {
        var spinnerSpace = progressbar.viewportHeight;
        if (progressbar.viewportHeight > progressbar.viewportWidth) {
            spinnerSpace = progressbar.viewportWidth;
        }
        // Take 1/6th of the value so that the spinner comes in the correct 
        // location in the viewport.
        spinnerSpace = spinnerSpace / 6;
        var actualViewportTop = spinnerSpace / 5;

        var spinnerConfig = getSpinnerConfig();
        spinnerConfig.radius = actualViewportTop * 3;
        spinnerConfig.length = actualViewportTop * 2;
    }

    dicomViewer.progress = {
        getSpinnerConfig: getSpinnerConfig,
        setTopLeftValues: setTopLeftValues,
        createAndGetSpinner: createAndGetSpinner,
        getSpinner: getSpinner,
        putSpinner: putSpinner,
        setSpinnerData: setSpinnerData,
        updateSpinnerInnerText: updateSpinnerInnerText
    };

    return dicomViewer;
}(dicomViewer));
