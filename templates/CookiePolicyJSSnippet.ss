// defer method, wait for jQuery
function deferJQ(method) {
    if (window.jQuery) {
        method();
    } else {
        setTimeout(function() { deferJQ(method) }, 50);
    }
}

// regular method needs the combined file
function injectPolicyScript(file) {
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.async = false;
    script.onload = function(){
        jQuery('body').cookieNotify($config.RAW);
    };
    script.src = file;
    document.getElementsByTagName('head')[0].appendChild(script);
}

// init script
function initCookiePolicy() {
    if (typeof window.jQuery === 'undefined' && typeof window.$ !== 'undefined') {
        window.jQuery = $;
    }

    if (typeof define === 'function' && typeof require === 'function' && typeof window.jQuery === 'undefined') {
        deferJQ(function () {
            require([
                '$resourceURL('novatio/gdpr-cookiepolicy:javascript/jquery.cookie.min.js')'
            ], function(cookie) {
                require([
                    '$resourceURL('novatio/gdpr-cookiepolicy:javascript/jquery.policy.min.js')'
                ], function (policy) {
                    jQuery('body').cookieNotify($config.RAW);
                });
            });
        });
    } else {
        injectPolicyScript('$resourceURL('novatio/gdpr-cookiepolicy:javascript/jquery.cookie.policy.min.js')');
    }
}

// we do not know whether require.js is loaded with "async"; just hold off for a sec to start the checks.
setTimeout(function() {
    initCookiePolicy();
}, 1000);
