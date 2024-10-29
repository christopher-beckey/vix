
function Browser()
{
	this.ie = document.all == null ? false : true;
	this.ns6 = document.getElementById && !document.all;
	this.ns4 = document.layers == null ? false : true;
	this.agt = navigator.userAgent;
	this.op5 = (navigator.userAgent.indexOf("Opera 5")!=-1) ||(navigator.userAgent.indexOf("Opera/5")!=-1);
	this.op6 = (navigator.userAgent.indexOf("Opera 6")!=-1) ||(navigator.userAgent.indexOf("Opera/6")!=-1);
}

Browser.prototype.isIE = function() {
	return this.ie;
}

Browser.prototype.isNetscapeFamily = function() {
	return this.ns6;
}

Browser.prototype.isFirefox = function() {
	return this.ns6;
}

Browser.prototype.getObjNN4 = function(obj,name) {
	var x = obj.layers;
	var foundLayer;
	for (var i=0;i<x.length;i++)
	{
		if (x[i].id == name)
		 	foundLayer = x[i];
		else if (x[i].layers.length)
			var tmp = getObjNN4(x[i],name);
		if (tmp) foundLayer = tmp;
	}
	return foundLayer;
}

Browser.prototype.getElementHeight = function(elementId) {
	var elem;
	if (this.ns4) {
		elem = getObjNN4(document, elementId);
		return elem.clip.height;
	} else {
		if(document.getElementById) {
			elem = document.getElementById(elementId);
		} else if (document.all){
			elem = document.all[elementId];
		}
		if (this.op5) { 
			xPos = elem.style.pixelHeight;
		} else {
			xPos = elem.offsetHeight;
		}
		return xPos;
	} 
};

Browser.prototype.getElementWidth = function(elementId) {
	var elem;
	if (this.ns4) {
		elem = getObjNN4(document, elementId);
		return elem.clip.width;
	} else {
		if(document.getElementById) {
			elem = document.getElementById(elementId);
		} else if (document.all){
			elem = document.all[elementId];
		}
		if (this.op5) {
			xPos = elem.style.pixelWidth;
		} else {
			xPos = elem.offsetWidth;
		}
		return xPos;
	}
};

Browser.prototype.getElementLeft = function(elementId) {
	var elem;
	if (this.ns4) {
		elem = getObjNN4(document, elementId);
		return elem.pageX;
	} else {
		if(document.getElementById) {
			elem = document.getElementById(elementId);
		} else if (document.all){
			elem = document.all[elementId];
		}
		xPos = elem.offsetLeft;
		tempEl = elem.offsetParent;
  		while (tempEl != null) {
  			xPos += tempEl.offsetLeft;
	  		tempEl = tempEl.offsetParent;
  		}
		return xPos;
	}
}

Browser.prototype.getElementTop = function(elementId) {
	var elem;
	if (this.ns4) {
		elem = getObjNN4(document, elementId);
		return elem.pageY;
	} else {
		if(document.getElementById) {	
			elem = document.getElementById(elementId);
		} else if (document.all) {
			elem = document.all[elementId];
		}
		yPos = elem.offsetTop;
		tempEl = elem.offsetParent;
		while (tempEl != null) {
  			yPos += tempEl.offsetTop;
	  		tempEl = tempEl.offsetParent;
  		}
		return yPos;
	}
}

Browser.prototype.getElementById = function(elementId) {
	if (this.ns4) {
		return getObjNN4(document, elementId);
	} else {
		if(document.getElementById) {	
			return document.getElementById(elementId);
		} else if (document.all) {
			return document.all[elementId];
		}
	}
}

var browserSniffer = new Browser();

/**
*
*  URL encode / decode
*  http://www.webtoolkit.info/
*
**/

var Url = {

    // public method for url encoding
    encode : function (string) {
        return escape(this._utf8_encode(string));
    },

    // public method for url decoding
    decode : function (string) {
        return this._utf8_decode(unescape(string));
    },

    // private method for UTF-8 encoding
    _utf8_encode : function (string) {
        string = string.replace(/\r\n/g,"\n");
        var utftext = "";

        for (var n = 0; n < string.length; n++) {

            var c = string.charCodeAt(n);

            if (c < 128) {
                utftext += String.fromCharCode(c);
            }
            else if((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            }
            else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }

        }

        return utftext;
    },

    // private method for UTF-8 decoding
    _utf8_decode : function (utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;

        while ( i < utftext.length ) {

            c = utftext.charCodeAt(i);

            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            }
            else if((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i+1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            }
            else {
                c2 = utftext.charCodeAt(i+1);
                c3 = utftext.charCodeAt(i+2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }

        }

        return string;
    }
}