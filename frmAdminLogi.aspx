

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>
	Maharashtra Medical Council
</title><meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />

    <script type="text/javascript" src="Scripts/jquery-1.11.3.min.js"></script>

    


    <script src="Scripts/jquery.validate.js"></script>
    <script src="Scripts/jquery.validate.unobtrusive.js"></script>
    <script src="Scripts/custom.jquery.validate.unobtrusive.js"></script>


    <script type="text/javascript" src="Scripts/bootstrap.min.js"></script>

    <script type="text/javascript" src="Scripts/jquery.md5.js"></script>

    <link href="Content/HomeLayout.css" rel="stylesheet" /><link href="Content/bootstrap.css" rel="stylesheet" /><link href="Content/bootstrap.min.css" rel="stylesheet" /><link href="Content/font-awesome.min.css" rel="stylesheet" /><link href="Content/custom.css" rel="stylesheet" /><link href="Content/textAnimate.css" rel="stylesheet" />

    <style>
        .phding {
            padding-left: 30%;
        }

        .pull-dwn {
            padding-top: 15px;
        }

        .navbar-default .navbar-nav > li > a {
            background-color: #cc2b2b;
        }

        .btn-social :first-child {
            position: relative;
            left: 0;
            top: 0;
            bottom: 0;
            /*width: 32px;*/
            line-height: 20px;
            font-size: 1.0em;
            text-align: left;
            border-right: 0px solid rgba(0,0,0,0.2);
        }

        .row {
            margin-right: 0px;
            margin-bottom: 10px;
        }
.row1 {
            margin-right: 0px;
            margin-bottom: 1px;
        }
        .auto-style1 {
            width: 20%;
        }
    </style>


    <script type="text/javascript">
        $(document).ready(function () {
            var navpos = $('#myMenu').offset();
            console.log(navpos.top);
            $(window).bind('scroll', function () {
                if ($(window).scrollTop() > navpos.top) {
                    $('#myMenu').addClass('navbar-fixed-top');
                }
                else {
                    $('#myMenu').removeClass('navbar-fixed-top');
                }
            });

            // scroll to top
            $(window).scroll(function () {
                if ($(this).scrollTop() > 50) {
                    $('#back-to-top').fadeIn();
                } else {
                    $('#back-to-top').fadeOut();
                }
            });
            // scroll body to 0px on click
            $('#back-to-top').click(function () {
                $('#back-to-top').tooltip('hide');
                $('body,html').animate({
                    scrollTop: 0
                }, 800);
                return false;
            });

            $('#back-to-top').tooltip('show');
        });
    </script>



    <script language="JavaScript" type="text/javascript">

        //////////F12 disable code////////////////////////
        document.onkeypress = function (event) {
            event = (event || window.event);
            if (event.keyCode == 123) {
                //alert('No F-12');
                return false;
            }
        }
        document.onmousedown = function (event) {
            event = (event || window.event);
            if (event.keyCode == 123) {
                //alert('No F-keys');
                return false;
            }
        }
        document.onkeydown = function (event) {
            event = (event || window.event);
            if (event.keyCode == 123) {
                //alert('No F-keys');
                return false;
            }
        }
    </script>


    <script language="JavaScript" type="text/javascript">
        //Function for disable right click on website
        //Message to display whenever right click on website
        var message = "Sorry, Right Click have been disabled.";
        function click(e) {
            if (document.all) {
                if (event.button == 2 || event.button == 3) {
                    alert(message);
                    return false;
                }
            }
            else {
                if (e.button == 2 || e.button == 3) {
                    e.preventDefault();
                    e.stopPropagation();
                    alert(message);
                    return false;
                }
            }
        }
        if (document.all) {
            document.onmousedown = click;
        }
        else {
            document.onclick = click;
        }
        document.oncontextmenu = function () {
            return false;

        };
    </script>

    <script type="text/javascript" language="javascript">
        function DisableBackButton() {
            window.history.forward()
        }
        DisableBackButton();
        window.onload = DisableBackButton;
        window.onpageshow = function (evt) { if (evt.persisted) DisableBackButton() }
        window.onunload = function () { void (0) }
    </script>

    
    <script src="../JavaScripts/Comman_Validations.js" type="text/javascript"></script>
    <script src="JavaScripts/md5.js"></script>


    <script type="text/javascript">
        function GoBack() {
            window.History.forward(-1);
        }

        function HashPwdwithSalt(salt) {

            if (document.getElementById("ctl00_ContentPlaceHolder1_txtPassword").value != "") {

                 document.getElementById("ctl00_ContentPlaceHolder1_txtPassword").value =
                     hex_md5(document.getElementById("ctl00_ContentPlaceHolder1_txtPassword").value);

                 document.getElementById("ctl00_ContentPlaceHolder1_txtPassword").value =
                     hex_md5(document.getElementById("ctl00_ContentPlaceHolder1_txtPassword").value + salt);
             }
        }


        function ChkPassLength(no) {

            var limit = no.value;
            if (limit.length < 8) {
                alert('Password Should be minimum 8 characters');
                no.value = '';
             
                return false;
            }
            else if (limit.length > 15) {
                alert('Password Should not be greater than 15 Characters');
                no.value = '';
              
            }
            else {
                return true;
            }

        }

        function ValidatePassword(field) {
            debugger;
            var varNo = document.getElementById(field).value;
            if (varNo != '') {
                if (varNo.length < 5) {
                    alert('Password should be minimum 5 characters.');
                    document.getElementById(field).value = "";
                    document.getElementById(field).focus();
                    return false;
                }
            }
        }
    </script>
    <style type="text/css">
         
    </style>

    
    <script language="JavaScript" type="text/javascript">
        //Function for disable right click on website
        //Message to display whenever right click on website
        var message = "Sorry, Right Click have been disabled.";
        function click(e) {
            if (document.all) {
                if (event.button == 2 || event.button == 3) {
                    alert(message);
                    return false;
                }
            }
            else {
                if (e.button == 2 || e.button == 3) {
                    e.preventDefault();
                    e.stopPropagation();
                    alert(message);
                    return false;
                }
            }
        }
        if (document.all) {
            document.onmousedown = click;
        }
        else {
            document.onclick = click;
        }
        document.oncontextmenu = function () {
            return false;

        };
    </script>
    <script language="JavaScript" type="text/javascript">

        //////////F12 disable code//////////
        document.onkeypress = function (event) {
            event = (event || window.event);
            if (event.keyCode == 123) {
                //alert('No F-12');
                return false;
            }
        }
        document.onmousedown = function (event) {
            event = (event || window.event);
            if (event.keyCode == 123) {
                //alert('No F-keys');
                return false;
            }
        }
        document.onkeydown = function (event) {
            event = (event || window.event);
            if (event.keyCode == 123) {
                //alert('No F-keys');
                return false;
            }
        }
    </script>




</head>


<body>
    <form name="aspnetForm" method="post" action="./frmAdminLogin.aspx" id="aspnetForm">
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwULLTEyMTM2MDI3NjkPZBYCZg9kFgICAw9kFhYCAw8PFgIeBFRleHQFYTE4OSAtIEEsIEFuYW5kIENvbXBsZXggIEZpcnN0IEZsb29yLCBTYW5lIEd1cnVqaSBNYXJnIEFydGh1ciBSb2FkIE5ha2EgLCBDaGluY2hwb2thbGkoVyksICBNVU1CQUlkZAIFDw8WAh8ABSQwMjIyMzAwNzY1MCAvODE2OTExODI2NiAvIDcwMjE5MzI1NDRkZAIHDw8WAh8ABR1tYWhhcmFzaHRyYW1jb3VuY2lsQGdtYWlsLmNvbWRkAgkPZBYEAgEPZBYGAgMPDxYCHhNWYWxpZGF0ZVJlcXVlc3RNb2RlAgJkZAIHD2QWAgIBDw8WAh8ABQdSREZBV1dLZGQCDQ8PZBYCHgdPbkNsaWNrBSNyZXR1cm4gSGFzaFB3ZHdpdGhTYWx0KCd0MlNrWVVjPScpO2QCAw8WAh4HVmlzaWJsZWgWBAIDDw8WAh8BAgJkZAIHDw8WAh8BAgJkZAILDxYCHglpbm5lcmh0bWwFnRo8bWFycXVlZSBpZD0nTWFyUUInIGRpcmVjdGlvbj0ndXAnIGxvb3A9J3RydWUnIHNjcm9sbGRlbGF5PSczMDAnIGhlaWdodD0nMTUwcHgnIG9ubW91c2VvdmVyPSd0aGlzLnN0b3AoKSdvbm1vdXNlb3V0PSd0aGlzLnN0YXJ0KCknPjx1bD48bGkgc3R5bGU9JyBwYWRkaW5nOiA1cHg7Jz4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J0ZpbGVzL0Fubm91bmNlbWVudHNfMjkxMjIwMjNfTm90aWNlIG9mIHJlbmV3YWwgb2YgcmVnaXN0cmF0aW9uIGZvciBSTVBzIHdobyBoYXZlIGJlZW4gcmVnaXN0ZXJlZCBkdXJpbmcgMDEuMDEuMjAxOSB0byAzMS4xMi4yMDE5LnBkZic+Tm90aWNlIG9mIHJlbmV3YWwgb2YgcmVnaXN0cmF0aW9uIGZvciBSTVBzIHdobyBoYXZlIGJlZW4gcmVnaXN0ZXJlZCBkdXJpbmcgMDEuMDEuMjAxOSB0byAzMS4xMi4yMDE5PC9hPjwvbGk+PGxpIHN0eWxlPScgcGFkZGluZzogNXB4Oyc+IDxhIHRhcmdldD0nX2JsYW5rJyBocmVmPSdGaWxlcy9Bbm5vdW5jZW1lbnRzXzIwMTIyMDIyX0NMQVJJRklDQVRJT04gT04gQ1JNSSBQUk9CTEVNIEZBQ0VEIEJZIEZPUkVJR04gTUVESUNBTCBHUkFEVUFURVMgU1RVREVOVFMuLnBkZic+Q0xBUklGSUNBVElPTiBPTiBDUk1JIFBST0JMRU0gRkFDRUQgQlkgRk9SRUlHTiBNRURJQ0FMIEdSQURVQVRFUyBTVFVERU5UUy48L2E+PC9saT48bGkgc3R5bGU9JyBwYWRkaW5nOiA1cHg7Jz4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J0ZpbGVzL0Fubm91bmNlbWVudHNfMzAxMTIwMjJfQ0xBUklGSUNBVElPTiBPTiBUSEUgUkVGRVJFTkNFUyBSRUNFSVZFRCBGUk9NIFNUQVRFIE1FRElDQUwgQ09VTkNJTFMgUkVHQVJESU5HIENSTUkgT0YgRk9SRUlHTiBNRURJQ0FMIEdSQURVQVRFUy5wZGYnPkNMQVJJRklDQVRJT04gT04gVEhFIFJFRkVSRU5DRVMgUkVDRUlWRUQgRlJPTSBTVEFURSBNRURJQ0FMIENPVU5DSUxTIFJFR0FSRElORyBDUk1JIE9GIEZPUkVJR04gTUVESUNBTCBHUkFEVUFURVM8L2E+PC9saT48bGkgc3R5bGU9JyBwYWRkaW5nOiA1cHg7Jz4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J0ZpbGVzL0Fubm91bmNlbWVudHNfMjYwODIwMjJfUkVHQVJESU5HIEFMTE9UTUVOVCBPRiBJTlRFUk5TSElQIFRPIEZPUkVJR04gTUVESUNBTCBHUkFEVUFURS5wZGYnPlJFR0FSRElORyBBTExPVE1FTlQgT0YgSU5URVJOU0hJUCBUTyBGT1JFSUdOIE1FRElDQUwgR1JBRFVBVEU8L2E+PC9saT48bGkgc3R5bGU9JyBwYWRkaW5nOiA1cHg7Jz4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J0ZpbGVzL0Fubm91bmNlbWVudHNfMDgwODIwMjJfQ0lSQ1VMQVItIFJFR0FSRElORyBJTExFR0FMIENIQVJHRVMgRkVFUyBDSEFSR0VEIEJZIE1FRElDQUwgQ09MTEVHRVMgVE9XQVJEUyBGTUcgQ1JNSSBQT1NUSU5HLnBkZic+Q0lSQ1VMQVItIFJFR0FSRElORyBJTExFR0FMIENIQVJHRVMgL0ZFRVMgQ0hBUkdFRCBCWSBNRURJQ0FMIENPTExFR0VTIFRPV0FSRFMgRk1HIENSTUkgUE9TVElORzwvYT48L2xpPjxsaSBzdHlsZT0nIHBhZGRpbmc6IDVweDsnPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0nRmlsZXMvQW5ub3VuY2VtZW50c18xNzA1MjAyMl9DaXJjdWxhciByZWdhcmRpbmcgU2V5Y2hlbGxlcyBVbml2ZXJzaXR5LnBkZic+Q2lyY3VsYXIgcmVnYXJkaW5nIFNleWNoZWxsZXMgVW5pdmVyc2l0eTwvYT48L2xpPjxsaSBzdHlsZT0nIHBhZGRpbmc6IDVweDsnPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0nRmlsZXMvQW5ub3VuY2VtZW50c18yOTAzMjAyMl9NTUMgQUNISUVWRU1FTlQucGRmJz5NTUMgQUNISUVWRU1FTlQ8L2E+PC9saT48bGkgc3R5bGU9JyBwYWRkaW5nOiA1cHg7Jz4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J0ZpbGVzL0Fubm91bmNlbWVudHNfMDcwMTIwMjJfUHJvY2VkdXJlIHRvIGNoYW5nZSBmb3Jnb3R0ZW4gVXNlcm5hbWUgTW9iaWxlIE5vIGZvciBSZWdpc3RyYXRpb24gUHJvY2Vzcy5wZGYnPlByb2NlZHVyZSB0byBjaGFuZ2UgZm9yZ290dGVuIFVzZXJuYW1lICYgTW9iaWxlIE5vIGZvciBSZWdpc3RyYXRpb24gUHJvY2VzczwvYT48L2xpPjxsaSBzdHlsZT0nIHBhZGRpbmc6IDVweDsnPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0nRmlsZXMvQW5ub3VuY2VtZW50c18yNDA4MjAyMF9HVUlERUxJTkVTIEZPUiBXRUJJTkFSUy5wZGYnPkdVSURFTElORVMgRk9SIFdFQklOQVJTPC9hPjwvbGk+PGxpIHN0eWxlPScgcGFkZGluZzogNXB4Oyc+IDxhIHRhcmdldD0nX2JsYW5rJyBocmVmPSdGaWxlcy9Bbm5vdW5jZW1lbnRzXzI0MDgyMDIwX0NpcmN1bGFyIFJlZ2FyZGluZyBXZWJpbmFyLnBkZic+Q2lyY3VsYXIgUmVnYXJkaW5nIFdlYmluYXI8L2E+PC9saT48bGkgc3R5bGU9JyBwYWRkaW5nOiA1cHg7Jz4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J0ZpbGVzL0Fubm91bmNlbWVudHNfMTkwNjIwMjBfVXBkYXRpb24gb2YgQ1BEIENyZWRpdCBQb2ludHMgdW5kZXIgcmVuZXdhbCBQcm9jZXNzLnBkZic+VXBkYXRpb24gb2YgQ1BEIENyZWRpdCBQb2ludHMgdW5kZXIgcmVuZXdhbCBQcm9jZXNzPC9hPjwvbGk+PGxpIHN0eWxlPScgcGFkZGluZzogNXB4Oyc+IDxhIHRhcmdldD0nX2JsYW5rJyBocmVmPSdGaWxlcy9Bbm5vdW5jZW1lbnRzXzE4MDYyMDIwX0F1dGhlbnRpY2F0aW9uIG9mIEFkZGl0aW9uYWwgUXVhbGlmaWNhdGlvbiBDZXJ0aWZpY2F0ZSBpbiByZXNwZWN0IG9mIE90aGVyIHN0YXRlIFN0dWRlbnRzLnBkZic+QXV0aGVudGljYXRpb24gb2YgQWRkaXRpb25hbCBRdWFsaWZpY2F0aW9uIENlcnRpZmljYXRlIGluIHJlc3BlY3Qgb2YgT3RoZXIgc3RhdGUgU3R1ZGVudHM8L2E+PC9saT48bGkgc3R5bGU9JyBwYWRkaW5nOiA1cHg7Jz4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J0ZpbGVzL0Fubm91bmNlbWVudHNfMzAwNDIwMjBfQ2lyY3VsYXIgUmVnYXJkaW5nIENvcm9uYSB2aXJ1cy5wZGYnPkNpcmN1bGFyIGZvciBDUEQgQ3JlZGl0IFBvaW50czwvYT48L2xpPjxsaSBzdHlsZT0nIHBhZGRpbmc6IDVweDsnPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0nRmlsZXMvQW5ub3VuY2VtZW50c18yNzEyMjAxN19Eb3dubG9hZCBvZiBJZGVudGl0eSBDYXJkLnBkZic+RG93bmxvYWQgb2YgSWRlbnRpdHkgQ2FyZDwvYT48L2xpPjxsaSBzdHlsZT0nIHBhZGRpbmc6IDVweDsnPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0nRmlsZXMvQW5ub3VuY2VtZW50c18xNDExMjAxN19FeGVtcHRpb24gZnJvbSBlYXJuaW5nIGNyZWRpdCBwb2ludCBmb3IgUmVuZXdhbCBvZiBSZWdpc3RyYXRpb24ucGRmJz5FeGVtcHRpb24gZnJvbSBlYXJuaW5nIGNyZWRpdCBwb2ludCBmb3IgUmVuZXdhbCBvZiBSZWdpc3RyYXRpb248L2E+PC9saT48L3VsPjwvbWFycXVlZT5kAg0PFgIfBAXjLzxtYXJxdWVlIGlkPSdNYXJRQicgZGlyZWN0aW9uPSd1cCcgbG9vcD0ndHJ1ZScgc2Nyb2xsZGVsYXk9JzMwMCcgaGVpZ2h0PScxNTBweCcgb25tb3VzZW92ZXI9J3RoaXMuc3RvcCgpJ29ubW91c2VvdXQ9J3RoaXMuc3RhcnQoKSc+PHVsPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18yMTA2MjAyNF9SZWdhcmRpbmcgbm9uLWNvbXBsaWFuY2Ugb2YgZXhjZWwgc2hlZXRzLnBkZic+IDxpbWcgc3JjPSdpbWFnZXMvSWNvbi5naWYnIGFsdD0nJyB0aXRsZT0nTWFoYXJhc2h0cmEgU3RhdGUgR292ZXJubWVudCcgLz4gUmVnYXJkaW5nIG5vbi1jb21wbGlhbmNlIG9mIGV4Y2VsIHNoZWV0czwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18xODA2MjAyNF9SZWdhcmRpbmcgcmVxdWVzdHMgZm9yIGRlbGF5ZWQgYXBwbGljYXRpb25zIGZvciBwaHlzaWNhbCBDUEQgYW5kIHdlYmluYXIucGRmJz4gPGltZyBzcmM9J2ltYWdlcy9JY29uLmdpZicgYWx0PScnIHRpdGxlPSdNYWhhcmFzaHRyYSBTdGF0ZSBHb3Zlcm5tZW50JyAvPiBSZWdhcmRpbmcgcmVxdWVzdHMgZm9yIGRlbGF5ZWQgYXBwbGljYXRpb25zIGZvciBwaHlzaWNhbCBDUEQgYW5kIHdlYmluYXI8L2E+PC9saT48bGk+IDxhIHRhcmdldD0nX2JsYW5rJyBocmVmPSdodHRwczovL3d3dy5tYWhhcmFzaHRyYW1lZGljYWxjb3VuY2lsLmluL0ZpbGVzL05vdGlmaWNhdGlvbnNfMDYwNjIwMjRfUmVnYXJkaW5nIGFsbG90bWVudCBvZiAybmQgeWVhciBJbnRlcm5zaGlwIGZvciBGb3JlaWduIE1lZGljYWwgR3JhZHVhdGVzLnBkZic+IDxpbWcgc3JjPSdpbWFnZXMvSWNvbi5naWYnIGFsdD0nJyB0aXRsZT0nTWFoYXJhc2h0cmEgU3RhdGUgR292ZXJubWVudCcgLz4gUmVnYXJkaW5nIGFsbG90bWVudCBvZiAybmQgeWVhciBJbnRlcm5zaGlwIGZvciBGb3JlaWduIE1lZGljYWwgR3JhZHVhdGVzPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlcy9Ob3RpZmljYXRpb25zXzA0MDYyMDI0X0V4dGVuc2lvbiBmb3Igc3VibWlzc2lvbiBvZiB1cGRhdGVkIGNvbnRhY3QgaW5mb3JtYXRpb24gb2YgQWNjcmVkaXRlZCBvcmdhbml6YXRpb25zLCBhc3NvY2lhdGlvbnMsIHRlYWNoaW5nIGluc3RpdHV0ZSBhbmQgbWVkaWNhbCBjb2xsZWdlcy5wZGYnPkV4dGVuc2lvbiBmb3Igc3VibWlzc2lvbiBvZiB1cGRhdGVkIGNvbnRhY3QgaW5mb3JtYXRpb24gb2YgQWNjcmVkaXRlZCBvcmdhbml6YXRpb25zLCBhc3NvY2lhdGlvbnMsIHRlYWNoaW5nIGluc3RpdHV0ZSBhbmQgbWVkaWNhbCBjb2xsZWdlczwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18yODA1MjAyNF9SZWdhcmRpbmcgYWN0aXZhdGlvbiBvZiBsaW5rIGZvciB1cGRhdGlvbiBvZiBjcmVkaXQgcG9pbnRzIGZvciBSTVBzIHdobyB3ZXJlIGFjdGl2ZWx5IHBhcnRpY2lwYXRlZCBpbiB0aGUgY29udGFpbm1lbnQsIHRyZWF0bWVudCBvZiBDb3ZpZCAxOSBwYXRpZW50cy5wZGYnPlJlZ2FyZGluZyBhY3RpdmF0aW9uIG9mIGxpbmsgZm9yIHVwZGF0aW9uIG9mIGNyZWRpdCBwb2ludHMgZm9yIFJNUHMgd2hvIHdlcmUgYWN0aXZlbHkgcGFydGljaXBhdGVkIGluIHRoZSBjb250YWlubWVudCwgdHJlYXRtZW50IG9mIENvdmlkIDE5IHBhdGllbnRzPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlcy9Ob3RpZmljYXRpb25zXzI1MDQyMDI0X1JlZ2FyZGluZyB1cGRhdGlvbiBvZiBjb250YWN0IGluZm9ybWF0aW9uIG9mIEFjY3JlZGl0ZWQgQXNzb2NpYXRpb25zICxPcmdhbml6YXRpb25zICxUZWFjaGluZyBJbnN0aXR1dGVzICwgTWVkaWNhbCBjb2xsZWdlcy5wZGYnPlJlZ2FyZGluZyB1cGRhdGlvbiBvZiBjb250YWN0IGluZm9ybWF0aW9uIG9mIEFjY3JlZGl0ZWQgQXNzb2NpYXRpb25zICxPcmdhbml6YXRpb25zICxUZWFjaGluZyBJbnN0aXR1dGVzICwgTWVkaWNhbCBjb2xsZWdlczwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18yNjAyMjAyNF9BcHBvaW50bWVudCBvZiBBZG1pbmlzdHJhdG9yLnBkZic+QXBwb2ludG1lbnQgb2YgQWRtaW5pc3RyYXRvcjwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18wNTEyMjAyM19OYXRpb25hbCBNZWRpY2FsIENvbW1pc3Npb24gUHVibGljIE5vdGljZSBkYXRlZCAyMjExMjAyMyByZWdhcmRpbmcgQ2xhcmlmaWNhdGlvbiBvbiB2YXJpb3VzIGlzc3VlcyByZWxhdGluZyB0byBGb3JlaWduIE1lZGljYWwgR3JhZHVhdGVzIChGTUdzKS4ucGRmJz5OYXRpb25hbCBNZWRpY2FsIENvbW1pc3Npb24gUHVibGljIE5vdGljZSBkYXRlZCAyMi8xMS8yMDIzIHJlZ2FyZGluZyBDbGFyaWZpY2F0aW9uIG9uIHZhcmlvdXMgaXNzdWVzIHJlbGF0aW5nIHRvIEZvcmVpZ24gTWVkaWNhbCBHcmFkdWF0ZXMgKEZNR3MpLjwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18yMTExMjAyM19XaXRoZHJhd2FsIG9mIHRoZSBjaXJjdWxhciBkdC4gMjkuMDQuMjAyMCBpbiByZXNwZWN0IG9mIGNvdmlkIGR1dHkgY3JlZGl0IHBvaW50cyB1cGRhdGlvbiB0byB0aG9zZSBSTVBzIHdobyBhY3RpdmVseSBwYXJ0aWNpcGF0ZWQgaW4gdGhlIGNvbnRhaW5tZW50LnBkZic+V2l0aGRyYXdhbCBvZiB0aGUgY2lyY3VsYXIgZHQuIDI5LjA0LjIwMjAgaW4gcmVzcGVjdCBvZiBjb3ZpZCBkdXR5IGNyZWRpdCBwb2ludHMgdXBkYXRpb24gdG8gdGhvc2UgUk1QcyB3aG8gYWN0aXZlbHkgcGFydGljaXBhdGVkIGluIHRoZSBjb250YWlubWVudDwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18yMzA4MjAyM19BZHZpc29yeWFsZXJ0IGZvciBJbmRpYW4gc3R1ZGVudHMgc2Vla2luZyBhZG1pc3Npb24gaW4gZm9yZWlnbiBJbnN0aXR1dGVzIFVuaXZlcnNpdGllcyBmb3IgVW5kZXJncmFkdWF0ZSBNZWRpY2FsIENvdXJzZXMtIHJlZy4ucGRmJz5BZHZpc29yeS9hbGVydCBmb3IgSW5kaWFuIHN0dWRlbnRzIHNlZWtpbmcgYWRtaXNzaW9uIGluIGZvcmVpZ24gSW5zdGl0dXRlcy8gVW5pdmVyc2l0aWVzIGZvciBVbmRlcmdyYWR1YXRlIE1lZGljYWwgQ291cnNlcy0gcmVnLjwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18yMzAxMjAyM19HdWlkZWxpbmUgZm9yIEludGVybnNoaXAgQWxsb3RtZW50IG9mIEZvcmVpZ24gTWVkaWNhbCBHcmFkdWF0ZXMucGRmJz5HdWlkZWxpbmUgZm9yIEludGVybnNoaXAgQWxsb3RtZW50IG9mIEZvcmVpZ24gTWVkaWNhbCBHcmFkdWF0ZXM8L2E+PC9saT48bGk+IDxhIHRhcmdldD0nX2JsYW5rJyBocmVmPSdodHRwczovL3d3dy5tYWhhcmFzaHRyYW1lZGljYWxjb3VuY2lsLmluL0ZpbGVzL05vdGlmaWNhdGlvbnNfMDEwOTIwMjJfUkVHQVJESU5HIEVYVEVOU0lPTiBPRiBJTlRFUk5TSElQLnBkZic+UkVHQVJESU5HIEVYVEVOU0lPTiBPRiBJTlRFUk5TSElQPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlcy9Ob3RpZmljYXRpb25zXzIzMTIyMDIxX0hvdyB0byBjaGVjayBDUEQgQ3JlZGl0IHBvaW50cy5wZGYnPkhvdyB0byBjaGVjayBDUEQgQ3JlZGl0IHBvaW50czwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18xNTEyMjAyMF9OT1RJQ0UgUkVHQVJESU5HIFBSQUNUSVNFIE9GIE1PREVSTiBNRURJQ0lORSBBUyBQRVIgSU5ESUFOIE1FRElDQUwgQ09VTkNJTCwgQ09ERSBPRiBFVEhJQ1MgMjAwMi5wZGYnPk5PVElDRSBSRUdBUkRJTkcgUFJBQ1RJU0UgT0YgTU9ERVJOIE1FRElDSU5FIEFTIFBFUiBJTkRJQU4gTUVESUNBTCBDT1VOQ0lMLCBDT0RFIE9GIEVUSElDUyAyMDAyPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlcy9Ob3RpZmljYXRpb25zXzI2MDMyMDIwX01DSSBOb3RpZmljYXRpb24gUmVnYXJkaW5nIFRFTEVNRURJQ0lORS5wZGYnPk1DSSBOb3RpZmljYXRpb24gUmVnYXJkaW5nIFRFTEVNRURJQ0lORTwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18wNDAzMjAyMF9Db21wbGlhbmNlIG9mIE1DSSBDb2RlIG9mIEV0aGljcyByZWd1bGF0aW9ucyAyMDAyLnBkZic+Q29tcGxpYW5jZSBvZiBNQ0kgQ29kZSBvZiBFdGhpY3MgcmVndWxhdGlvbnMgMjAwMjwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18yNzAyMjAyMF9SZXBvcnRpbmcgb2YgUExISVYgb24gQVJUIFByaXZhdGUgU2VjdG9yIHJlZy5wZGYnPlJlcG9ydGluZyBvZiBQTEhJViBvbiBBUlQgUHJpdmF0ZSBTZWN0b3IgcmVnPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlcy9Ob3RpZmljYXRpb25zXzE2MDUyMDE5X1JlZ2lzdHJhdGlvbkFkZGl0aW9uYWwgUXVhbGlmaWNhdGlvbiBjZXJ0aWZpY2F0ZSB0aHJvdWdoIGhhbmQgZGVsaXZlcnlQb3N0LnBkZic+UmVnaXN0cmF0aW9uL0FkZGl0aW9uYWwgUXVhbGlmaWNhdGlvbiBjZXJ0aWZpY2F0ZSB0aHJvdWdoIGhhbmQgZGVsaXZlcnkvUG9zdDwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvTm90aWZpY2F0aW9uc18wMTA5MjAxOF9SZWdhcmRpbmcgc2lnbmluZyBvZiBtdWx0aXBsZSBQYXRob2xvZ3kgcmVwb3J0IHdpdGhvdXQgc3VwZXJ2aXNpb24ucGRmJz5SZWdhcmRpbmcgc2lnbmluZyBvZiBtdWx0aXBsZSBQYXRob2xvZ3kgcmVwb3J0IHdpdGhvdXQgc3VwZXJ2aXNpb248L2E+PC9saT48bGk+IDxhIHRhcmdldD0nX2JsYW5rJyBocmVmPSdodHRwczovL3d3dy5tYWhhcmFzaHRyYW1lZGljYWxjb3VuY2lsLmluL0ZpbGVzL05vdGlmaWNhdGlvbnNfMTIwMzIwMThfTk9USUNFIEZPUiBQQVlNRU5ULnBkZic+Tk9USUNFIEZPUiBQQVlNRU5UPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlcy9Ob3RpZmljYXRpb25zXzE2MTIyMDE3X05vdGljZSBGb3IgQWFkaGFyIENhcmQucGRmJz5Ob3RpY2UgRm9yIEFhZGhhciBDYXJkPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlcy9Ob3RpZmljYXRpb25zXzExMDUyMDE3X1VzZSBvZiBHZW5lcmljIG5hbWVzIG9mIGRydWdzLnBkZic+VXNlIG9mIEdlbmVyaWMgbmFtZXMgb2YgZHJ1Z3M8L2E+PC9saT48L3VsPjwvbWFycXVlZT5kAg8PFgIfBAXUDjxtYXJxdWVlIGlkPSdNYXJRQicgZGlyZWN0aW9uPSd1cCcgbG9vcD0ndHJ1ZScgc2Nyb2xsZGVsYXk9JzMwMCcgaGVpZ2h0PScxNTBweCcgb25tb3VzZW92ZXI9J3RoaXMuc3RvcCgpJ29ubW91c2VvdXQ9J3RoaXMuc3RhcnQoKSc+PHVsPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vZG9jcy5nb29nbGUuY29tL2d2aWV3P2VtYmVkZGVkPXRydWUmdXJsPWh0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvRG93bmxvYWRzXzIyMDEyMDIxX0Zvcm1hdCBvZiBVbmRlcnRha2luZyBmb3IgQWRkaXRpb25hbCBRdWFsaWZpY2F0aW9uLnBkZic+IDxpbWcgc3JjPSdpbWFnZXMvSWNvbi5naWYnIGFsdD0nJyB0aXRsZT0nTWFoYXJhc2h0cmEgU3RhdGUgR292ZXJubWVudCcgLz4gRm9ybWF0IG9mIFVuZGVydGFraW5nIGZvciBBZGRpdGlvbmFsIFF1YWxpZmljYXRpb248L2E+PC9saT48bGk+IDxhIHRhcmdldD0nX2JsYW5rJyBocmVmPSdodHRwczovL2RvY3MuZ29vZ2xlLmNvbS9ndmlldz9lbWJlZGRlZD10cnVlJnVybD1odHRwczovL3d3dy5tYWhhcmFzaHRyYW1lZGljYWxjb3VuY2lsLmluL0ZpbGVzL0Rvd25sb2Fkc18yMzAzMjAxOF9Gb3JtYXQgb2YgQWZmaWRhdml0IGFuZCBJbmRlbW5pdHkgQm9uZCBmb3IgREVGQVVMVEVSUy5wZGYnPkZvcm1hdCBvZiBBZmZpZGF2aXQgYW5kIEluZGVtbml0eSBCb25kIGZvciBERUZBVUxURVJTPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly9kb2NzLmdvb2dsZS5jb20vZ3ZpZXc/ZW1iZWRkZWQ9dHJ1ZSZ1cmw9aHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlcy9Eb3dubG9hZHNfMjMwMzIwMThfRm9ybWF0IG9mIEFmZmlkYXZpdCBhbmQgSW5kZW1uaXR5IEJvbmQgZm9yIFJlbmV3YWwgb2YgUmVnaXN0cmF0aW9uLnBkZic+Rm9ybWF0IG9mIEFmZmlkYXZpdCBhbmQgSW5kZW1uaXR5IEJvbmQgZm9yIFJlbmV3YWwgb2YgUmVnaXN0cmF0aW9uPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly9kb2NzLmdvb2dsZS5jb20vZ3ZpZXc/ZW1iZWRkZWQ9dHJ1ZSZ1cmw9aHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlcy9Eb3dubG9hZHNfMDcxMjIwMTdfRk9STUFUIE9GIEFGRklEQVZJVCBGT1IgSU5ESUFOIE5BVElPTkFMUyAgT0NJIFJFR0lTVFJBVElPTi5wZGYnPkZPUk1BVCBPRiBBRkZJREFWSVQgRk9SIElORElBTiBOQVRJT05BTFMgLyBPQ0kgUkVHSVNUUkFUSU9OPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly9kb2NzLmdvb2dsZS5jb20vZ3ZpZXc/ZW1iZWRkZWQ9dHJ1ZSZ1cmw9aHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlcy9Eb3dubG9hZHNfMDQwMTIwMTdfVW5kZXJ0YWtpbmcucGRmJz5VbmRlcnRha2luZzwvYT48L2xpPjxsaT4gPGEgdGFyZ2V0PSdfYmxhbmsnIGhyZWY9J2h0dHBzOi8vZG9jcy5nb29nbGUuY29tL2d2aWV3P2VtYmVkZGVkPXRydWUmdXJsPWh0dHBzOi8vd3d3Lm1haGFyYXNodHJhbWVkaWNhbGNvdW5jaWwuaW4vRmlsZXMvRG93bmxvYWRzXzE3MTAyMDE2X0RFQ0xBUkFUSU9OIFVSVUxFIDYyLnBkZic+REVDTEFSQVRJT04gVS9SVUxFIDYyPC9hPjwvbGk+PGxpPiA8YSB0YXJnZXQ9J19ibGFuaycgaHJlZj0naHR0cHM6Ly9kb2NzLmdvb2dsZS5jb20vZ3ZpZXc/ZW1iZWRkZWQ9dHJ1ZSZ1cmw9aHR0cHM6Ly93d3cubWFoYXJhc2h0cmFtZWRpY2FsY291bmNpbC5pbi9GaWxlc1xBRkZJREFWSVQucGRmJz5BRkZJREFWSVQgRk9SIEZPUkVJR04gR1JBRFVBVEU8L2E+PC9saT48L3VsPjwvbWFycXVlZT5kAhEPFgIfBAXXBjxtYXJxdWVlIGlkPSdNYXJRQicgZGlyZWN0aW9uPSd1cCcgbG9vcD0ndHJ1ZScgc2Nyb2xsZGVsYXk9JzMwMCcgaGVpZ2h0PScxNTBweCcgb25tb3VzZW92ZXI9J3RoaXMuc3RvcCgpJ29ubW91c2VvdXQ9J3RoaXMuc3RhcnQoKSc+PHVsID48bGk+IDxhIHRhcmdldD0nX2JsYW5rJyBocmVmPSdodHRwczovL2RvY3MuZ29vZ2xlLmNvbS9ndmlldz9lbWJlZGRlZD10cnVlJnVybD1odHRwczovL3d3dy5tYWhhcmFzaHRyYW1lZGljYWxjb3VuY2lsLmluL0ZpbGVzL0luc3RydWN0aW9uc18yODAxMjAxOF9JbnN0cnVjdGlvbiB0byBkb3dubG9hZCBNTUMgQXBwIGZyb20gZ29vZ2xlIHBsYXkucGRmJz5JbnN0cnVjdGlvbiB0byBkb3dubG9hZCBNTUMgQXBwIGZyb20gZ29vZ2xlIHBsYXk8L2E+PC9saT48bGk+IDxhIHRhcmdldD0nX2JsYW5rJyBocmVmPSdodHRwczovL2RvY3MuZ29vZ2xlLmNvbS9ndmlldz9lbWJlZGRlZD10cnVlJnVybD1odHRwczovL3d3dy5tYWhhcmFzaHRyYW1lZGljYWxjb3VuY2lsLmluL0ZpbGVzL0luc3RydWN0aW9uc18yOTExMjAxN19JbnN0cnVjdGlvbiBmb3IgTU1DIElEIENhcmQucGRmJz5JbnN0cnVjdGlvbiBmb3IgTU1DIElEIENhcmQ8L2E+PC9saT48bGk+IDxhIHRhcmdldD0nX2JsYW5rJyBocmVmPSdodHRwczovL2RvY3MuZ29vZ2xlLmNvbS9ndmlldz9lbWJlZGRlZD10cnVlJnVybD1odHRwczovL3d3dy5tYWhhcmFzaHRyYW1lZGljYWxjb3VuY2lsLmluL0ZpbGVzL0luc3RydWN0aW9uc18yOTExMjAxN19JbnN0cnVjdGlvbiBmb3IgRG9jdW1lbnQgdXBsb2FkaW5nLnBkZic+SW5zdHJ1Y3Rpb24gZm9yIERvY3VtZW50IHVwbG9hZGluZzwvYT48L2xpPjwvdWw+PC9tYXJxdWVlPmQCEw8PFgIfAAUIMTI3MzMxMDBkZAIVDw8WAh8ABQExZGQCFw8PFgIfAAUKMzEvMDcvMjAyNGRkZIsklgSVnAsOgcqjDYB/6yppZSfL" />


<script src="/ScriptResource.axd?d=aVLv1e9PH8BNpJXN8mjaqRGlLdGoM3WWOP-AGd73SUSRjUF-G1o5qGcHQYyBBtcq6a205wyJDmBkJ6pHNLotalWrn6oGGHsglRq2I5q5WAbmS6qu-DEGH9GvuwiTDiTd_svr9w2&amp;t=7c776dc1" type="text/javascript"></script>
<input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="90C73F70" />
<input type="hidden" name="__EVENTVALIDATION" id="__EVENTVALIDATION" value="/wEdAAi+8WbU+x+IC5lM199bP1Pn9nsvgpcFVLgi4qzbwR9V0Hjjswiyhm+g6KodwobC/fMIsaT9NZ4XdQv+v8RRmR9BDvPkFS0h5UAh9iN3ZQhI1AdQIPyRBaj2VRoh6YkstdcEY1f+joXAJpOQEEyR73sBUUazXO8Sg+7X5KxpBPVfPKOCtLYi4oCMXk188KuazkUb3kLW" />

        


        <nav class="navbar navbar-default navbar-fixed-top" role="navigation">


            <div class="container2">
                <div class="navbar-header page-scroll">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-main-collapse">
                        <i class="fa fa-bars"></i>
                    </button>

                    <a class="navbar-brand hide_lg hide_md" style="color: white;" href="#">M.M.C.</a>
                </div>

                <!-- Collect the nav links, forms, and other content for toggling -->

                <div class="collapse navbar-collapse navbar-right navbar-main-collapse">
                    <ul class="nav navbar-nav">

                        <li><a href="Index.aspx"><span class="glyphicon glyphicon-home"></span>Home</a></li>

                        <li><a href="frmTabPage.aspx?page=about"><span class="glyphicon glyphicon-info-sign"></span>About</a></li>


                        <li><a href="frmTabPage.aspx?page=contact"><span class="glyphicon glyphicon-envelope"></span>Contact</a></li>

                        <li><a href="frmTabPage.aspx?page=rti"><span class="glyphicon glyphicon-repeat"></span>RTI</a></li>
                        <li><a href="frmTabPage.aspx?page=Ethics"><span class="glyphicon glyphicon-repeat"></span>Act & Rules</a></li>
                        <li><a href="frmProvisionalLogin.aspx"><span class="glyphicon glyphicon-repeat"></span>Login</a></li>

                    </ul>
                </div>
                <!-- /.navbar-collapse -->
            </div>
        </nav>

        <div class="container bg_white" style="background-color: #f5f6f7;">
            <div class="row" style=" margin-bottom: 1px;">
                <br />
                <br />
                <br />
                <div class="col-md-2 text-center hidden-xs hidden-sm">
                    <center>
 
             <img src="Images/mmc_logo.png" class="img-responsive mobile-bg" style="max-height:70%;max-width:70%" />
        </center>
                </div>
                <div class="col-md-8 hidden-xs hidden-sm ">
                    <center>
           
        <h3 class="bannertext" style="color: #333 "><b>MAHARASHTRA MEDICAL COUNCIL, MUMBAI</b></h3>
            <h4>
                (Established by Government of Maharashtra Under MMC Act, 1965)  
            </h4>
             <h4 class="off-add1">
                   ISO 9001:2015 Certified
                    <br />
                </h4>

            <h4 class="off-add1">
                   
                </h4>

            </center>


                </div>

                <div class="col-md-2 text-center hidden-xs hidden-sm">
                    <center>
 
             <img src="Images/75 VARSH.jpg" class="img-responsive mobile-bg" style="max-height:70%;max-width:70%" />
        </center>
                </div>


            </div>
            <div class="row border-bottom" style="margin-top: 5px; margin-bottom: 5px; color: red;">
            </div>

            <div class="row" style="margin-top: 10px;">
                <div class="col-md-3 col-lg-3">
                    



                    <div class="panel panel-primary">
                        <div class="panel-heading clearfix">
                            <h3 class="panel-title">
                                <i class="fa fa-fw fa-desktop"></i>MMC Information</h3>
                        </div>
                        <div class="panel-body">
                            <div style="margin-top: 15px; margin-bottom: 10px; margin-right: 15px; margin-left: 15px">

                                <a class="btn btn-block btn-social btn-twitter trans" href="frmTabPage.aspx?page=MMC">
                                    <i class="fa fa-fw fa-group"></i><span>MMC Members</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="/Files/list_of_pastpresent_presidentadmin.pdf" target="_blank">
                                    
                                    <i class="fa fa-fw fa-group"></i><span>President/ Administrators List</span>
                                </a>
								 
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmRmpList.aspx">
                                    <i class="fa fa-check-circle"></i><span>RMP Information</span>
                                </a>
                                
                                <a class="btn btn-block btn-social btn-twitter trans" href="https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/FeesStructure.pdf" target="_blank">
                                    <i class="fa fa-fw fa-certificate"></i><span>Fees Structure</span>
                                </a>
                                
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmTabPage.aspx?page=Register">
                                    <i class="fa fa-check-circle"></i><span>Register</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/final FAQ.pdf" target="_blank">
                                    <i class="fa fa-fw fa-question-circle"></i><span>FAQ</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmTabPage.aspx?page=FeedBack">
                                    <i class="fa fa-fw fa-pencil-square-o"></i><span>FeedBack</span>
                                </a>



                                <a class="btn btn-block btn-social btn-twitter trans" href="#">
                                    <i class="fa fa-fw fa-angle-right"></i><span>Novel Corona Virus</span>
                                </a>


                            </div>
                        </div>
                    </div>


                   



                    <div class="panel panel-primary">
                        <div class="panel-heading clearfix">
                            <h3 class="panel-title">
                                <i class="fa fa-fw fa-envelope"></i>MMC Helpline</h3>
                        </div>
                        <div class="panel-body">
                            <div style="margin-top: 15px; margin-bottom: 10px; margin-right: 5px; margin-left: 5px">

                                <a class="btn btn-block btn-social btn-twitter trans" href="#">
                                    <i class="fa fa-fw fa-certificate"></i><span>MMC office</span>
                                </a>


                                <a class="btn btn-block btn-social btn-twitter trans" href="#">
                                    <i class="fa fa-phone-square"></i><span>
                                        <span id="ctl00_lblContactno">02223007650 /8169118266 / 7021932544</span></span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="#">
                                    <i class="fa fa-envelope-o fa-fw"></i><span>
                                        <span id="ctl00_lblOfficeemail">maharashtramcouncil@gmail.com</span></span>
                                </a>

                                <a class="btn btn-block btn-social btn-twitter trans" href="#">
                                    <i class="fa fa-fw fa-certificate"></i><span>Technical Support </span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="#">
                                    <i class="fa fa-phone-square"></i><span>022 23007650 (extension 110)</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="#">
                                    <i class="fa fa-envelope-o fa-fw"></i><span>mmconlineservices1@gmail.com</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="#">
                                    <i class="fa fa-envelope-o fa-fw"></i><span>(Time 10.30 Am To 5.00 Pm)</span>
                                </a>



                            </div>
                        </div>
                    </div>

                </div>






                <div class="col-md-6" style="padding-left: 20px; background-color: #fff;">
                    <div class="page-content">
                        



    <div style="min-height: 550px">
        <div id="ctl00_ContentPlaceHolder1_div_login" class="row" style="margin: 2px 2px 0 2px">
            <div class="col-lg-2 col-md-2 col-sm-12 col-xs-12">
            </div>
            <div class="col-lg-8 col-md-8 col-sm-12 col-xs-12">
                <div class="panel panel-primary">
                    <div class="panel-heading clearfix">
                        <h3 class="panel-title">MMC Admin Login</h3>

                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div style="margin: 0 2px 10px 2px;" class="input-group">
                                <span class="input-group-addon"><i class="fa fa-envelope-o fa-fw"></i></span>
                                <input name="ctl00$ContentPlaceHolder1$txtUserName" type="text" id="ctl00_ContentPlaceHolder1_txtUserName" class="form-control" placeholder="Enter user name" autocomplete="off" oncut="return false;" onpaste="return false;" oncopy="return false;" />

                            </div>

                        </div>
                        <div class="row">
                            <div style="margin: 0 2px 10px 2px;" class="input-group">
                                <span class="input-group-addon"><i class="fa fa-key fa-fw"></i></span>
                                <input name="ctl00$ContentPlaceHolder1$txtPassword" type="password" id="ctl00_ContentPlaceHolder1_txtPassword" class="form-control" autocomplete="off" placeholder="Enter Password" onpaste="return false;" oncopy="return false;" oncut="return false;" />

                            </div>

                        </div>

                        <div class="row">
                            <center>
                                    <input type="hidden" name="ctl00$ContentPlaceHolder1$HiddenField1" id="ctl00_ContentPlaceHolder1_HiddenField1" value="t2SkYUc=" />
                                    <div>
	
                                    <span id="ctl00_ContentPlaceHolder1_lbl_captcha" oncut="return false;" oncopy="retun false;" onpater="return false;" style="display:inline-block;"><b><font size="6">RDFAWWK</font></b></span>

                                
</div>

                                    <a id="ctl00_ContentPlaceHolder1_lbtnChageImage" tabindex="11" href="javascript:__doPostBack(&#39;ctl00$ContentPlaceHolder1$lbtnChageImage&#39;,&#39;&#39;)">Change Image</a>
                                </center>
                        </div>
                        <div class="row">
                            <div style="margin: 0 2px 10px 2px;" class="input-group">
                                <span class="input-group-addon"><i class="fa fa-info-circle"></i></span>
                                <input name="ctl00$ContentPlaceHolder1$txt_dispCaptcha" type="text" id="ctl00_ContentPlaceHolder1_txt_dispCaptcha" class="form-control" Onpaste="return false;" oncut="return false;" oncopy="retun false;" autocomplete="off" />
                            </div>

                        </div>

                        <div class="row">
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                <input type="submit" name="ctl00$ContentPlaceHolder1$btnlogin" value="Login" onclick="return HashPwdwithSalt(&#39;t2SkYUc=&#39;);" id="ctl00_ContentPlaceHolder1_btnlogin" class="btn btn-success btn-block" />
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                <input type="submit" name="ctl00$ContentPlaceHolder1$btnCancel" value="Cancel" id="ctl00_ContentPlaceHolder1_btnCancel" class="btn btn-default btn-block" />
                                <span id="ctl00_ContentPlaceHolder1_lblMsg"><font color="Maroon"></font></span>
                            </div>
                        </div>


                    </div>

                </div>
            </div>
            <div class="col-lg-2 col-md-2 col-sm-12 col-xs-12">
            </div>
        </div>

        
	 </div>

                    </div>
                </div>

                <div class="col-md-3 col-lg-3">


                    <div class="panel panel-primary">
                        <div class="panel-heading clearfix">
                            <h3 class="panel-title">
                                <i class="fa fa-fw fa-desktop"></i>Online Services</h3>
                        </div>
                        <div class="panel-body">
                            <div style="margin-top: 15px; margin-bottom: 10px; margin-right: 15px; margin-left: 15px">



                                <a class="btn btn-block btn-social btn-twitter trans" href="CME/home.aspx">
                                    <i class="fa fa-fw fa-certificate"></i><span>C.P.D.</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="CME/frmAccreditationLogin.aspx">
                                    <i class="fa fa-fw fa-certificate"></i><span>Webinar</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="Complaint/frmComplaintEntry.aspx">
                                    <i class="fa fa-fw fa-desktop"></i><span>Complaint</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frm_MakePayment.aspx">
                                    <i class="fa fa-check-circle"></i><span>Online Payment</span>
                                </a>

                            </div>
                        </div>
                    </div>
                    <div class="panel panel-primary">
                        <div class="panel-heading clearfix">
                            <h3 class="panel-title">
                                <i class="fa fa-fw fa-pencil-square-o"></i><span>Rmp Online Services </span></h3>
                        </div>
                        <div class="panel-body">
                            <div style="margin-top: 15px; margin-bottom: 10px; margin-right: 5px; margin-left: 5px">
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>RMP Login</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>Provisional Registration</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>Permanent Registration</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>Additioanl Qualification</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>Renewal Of Registration</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>Registration for Foreign Graduate</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>Change of Name</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>Change of Address</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>Duplicate Certificate</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>NOC For Other State</span>
                                </a>
                                <a class="btn btn-block btn-social btn-twitter trans" href="frmProvisionalLogin.aspx">
                                    <i class="fa fa-fw fa-angle-right"></i><span>Good Standing Certificate</span>
                                </a>

                            </div>
                        </div>
                    </div>
                    
                </div>

            </div>

            <div class="row row1">
                <div class="col-md-3 col-lg-3">
                    <div class="panel panel-primary">
                        <div class="panel-heading clearfix">
                            <h3 class="panel-title">
                                <span class="fa fa-fw fa-bell"></span>Announcement </h3>
                        </div>
                        <div class="panel-body" style="height: 200px;">
                            <div id="ctl00_divAnncouncement"><marquee id='MarQB' direction='up' loop='true' scrolldelay='300' height='150px' onmouseover='this.stop()'onmouseout='this.start()'><ul><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_29122023_Notice of renewal of registration for RMPs who have been registered during 01.01.2019 to 31.12.2019.pdf'>Notice of renewal of registration for RMPs who have been registered during 01.01.2019 to 31.12.2019</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_20122022_CLARIFICATION ON CRMI PROBLEM FACED BY FOREIGN MEDICAL GRADUATES STUDENTS..pdf'>CLARIFICATION ON CRMI PROBLEM FACED BY FOREIGN MEDICAL GRADUATES STUDENTS.</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_30112022_CLARIFICATION ON THE REFERENCES RECEIVED FROM STATE MEDICAL COUNCILS REGARDING CRMI OF FOREIGN MEDICAL GRADUATES.pdf'>CLARIFICATION ON THE REFERENCES RECEIVED FROM STATE MEDICAL COUNCILS REGARDING CRMI OF FOREIGN MEDICAL GRADUATES</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_26082022_REGARDING ALLOTMENT OF INTERNSHIP TO FOREIGN MEDICAL GRADUATE.pdf'>REGARDING ALLOTMENT OF INTERNSHIP TO FOREIGN MEDICAL GRADUATE</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_08082022_CIRCULAR- REGARDING ILLEGAL CHARGES FEES CHARGED BY MEDICAL COLLEGES TOWARDS FMG CRMI POSTING.pdf'>CIRCULAR- REGARDING ILLEGAL CHARGES /FEES CHARGED BY MEDICAL COLLEGES TOWARDS FMG CRMI POSTING</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_17052022_Circular regarding Seychelles University.pdf'>Circular regarding Seychelles University</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_29032022_MMC ACHIEVEMENT.pdf'>MMC ACHIEVEMENT</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_07012022_Procedure to change forgotten Username Mobile No for Registration Process.pdf'>Procedure to change forgotten Username & Mobile No for Registration Process</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_24082020_GUIDELINES FOR WEBINARS.pdf'>GUIDELINES FOR WEBINARS</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_24082020_Circular Regarding Webinar.pdf'>Circular Regarding Webinar</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_19062020_Updation of CPD Credit Points under renewal Process.pdf'>Updation of CPD Credit Points under renewal Process</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_18062020_Authentication of Additional Qualification Certificate in respect of Other state Students.pdf'>Authentication of Additional Qualification Certificate in respect of Other state Students</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_30042020_Circular Regarding Corona virus.pdf'>Circular for CPD Credit Points</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_27122017_Download of Identity Card.pdf'>Download of Identity Card</a></li><li style=' padding: 5px;'> <a target='_blank' href='Files/Announcements_14112017_Exemption from earning credit point for Renewal of Registration.pdf'>Exemption from earning credit point for Renewal of Registration</a></li></ul></marquee></div>
                        </div>
                        
                    </div>
                </div>
                <div class="col-md-3 col-lg-3">
                    <div class="panel panel-primary">
                        <div class="panel-heading clearfix">
                            <h3 class="panel-title">
                                <span class="fa fa-fw fa-bell"></span>Notifications </h3>
                        </div>
                        <div class="panel-body" style="height: 200px;">
                            <div id="ctl00_divNotification"><marquee id='MarQB' direction='up' loop='true' scrolldelay='300' height='150px' onmouseover='this.stop()'onmouseout='this.start()'><ul><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_21062024_Regarding non-compliance of excel sheets.pdf'> <img src='images/Icon.gif' alt='' title='Maharashtra State Government' /> Regarding non-compliance of excel sheets</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_18062024_Regarding requests for delayed applications for physical CPD and webinar.pdf'> <img src='images/Icon.gif' alt='' title='Maharashtra State Government' /> Regarding requests for delayed applications for physical CPD and webinar</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_06062024_Regarding allotment of 2nd year Internship for Foreign Medical Graduates.pdf'> <img src='images/Icon.gif' alt='' title='Maharashtra State Government' /> Regarding allotment of 2nd year Internship for Foreign Medical Graduates</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_04062024_Extension for submission of updated contact information of Accredited organizations, associations, teaching institute and medical colleges.pdf'>Extension for submission of updated contact information of Accredited organizations, associations, teaching institute and medical colleges</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_28052024_Regarding activation of link for updation of credit points for RMPs who were actively participated in the containment, treatment of Covid 19 patients.pdf'>Regarding activation of link for updation of credit points for RMPs who were actively participated in the containment, treatment of Covid 19 patients</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_25042024_Regarding updation of contact information of Accredited Associations ,Organizations ,Teaching Institutes , Medical colleges.pdf'>Regarding updation of contact information of Accredited Associations ,Organizations ,Teaching Institutes , Medical colleges</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_26022024_Appointment of Administrator.pdf'>Appointment of Administrator</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_05122023_National Medical Commission Public Notice dated 22112023 regarding Clarification on various issues relating to Foreign Medical Graduates (FMGs)..pdf'>National Medical Commission Public Notice dated 22/11/2023 regarding Clarification on various issues relating to Foreign Medical Graduates (FMGs).</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_21112023_Withdrawal of the circular dt. 29.04.2020 in respect of covid duty credit points updation to those RMPs who actively participated in the containment.pdf'>Withdrawal of the circular dt. 29.04.2020 in respect of covid duty credit points updation to those RMPs who actively participated in the containment</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_23082023_Advisoryalert for Indian students seeking admission in foreign Institutes Universities for Undergraduate Medical Courses- reg..pdf'>Advisory/alert for Indian students seeking admission in foreign Institutes/ Universities for Undergraduate Medical Courses- reg.</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_23012023_Guideline for Internship Allotment of Foreign Medical Graduates.pdf'>Guideline for Internship Allotment of Foreign Medical Graduates</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_01092022_REGARDING EXTENSION OF INTERNSHIP.pdf'>REGARDING EXTENSION OF INTERNSHIP</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_23122021_How to check CPD Credit points.pdf'>How to check CPD Credit points</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_15122020_NOTICE REGARDING PRACTISE OF MODERN MEDICINE AS PER INDIAN MEDICAL COUNCIL, CODE OF ETHICS 2002.pdf'>NOTICE REGARDING PRACTISE OF MODERN MEDICINE AS PER INDIAN MEDICAL COUNCIL, CODE OF ETHICS 2002</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_26032020_MCI Notification Regarding TELEMEDICINE.pdf'>MCI Notification Regarding TELEMEDICINE</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_04032020_Compliance of MCI Code of Ethics regulations 2002.pdf'>Compliance of MCI Code of Ethics regulations 2002</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_27022020_Reporting of PLHIV on ART Private Sector reg.pdf'>Reporting of PLHIV on ART Private Sector reg</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_16052019_RegistrationAdditional Qualification certificate through hand deliveryPost.pdf'>Registration/Additional Qualification certificate through hand delivery/Post</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_01092018_Regarding signing of multiple Pathology report without supervision.pdf'>Regarding signing of multiple Pathology report without supervision</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_12032018_NOTICE FOR PAYMENT.pdf'>NOTICE FOR PAYMENT</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_16122017_Notice For Aadhar Card.pdf'>Notice For Aadhar Card</a></li><li> <a target='_blank' href='https://www.maharashtramedicalcouncil.in/Files/Notifications_11052017_Use of Generic names of drugs.pdf'>Use of Generic names of drugs</a></li></ul></marquee></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3 col-lg-3">
                    <div class="panel panel-primary">
                        <div class="panel-heading clearfix">
                            <h3 class="panel-title">
                                <span class="fa fa-fw fa-arrow-circle-o-down"></span>Downlaod</h3>
                        </div>
                        <div class="panel-body" style="height: 200px;">
                            <div id="ctl00_divDownload"><marquee id='MarQB' direction='up' loop='true' scrolldelay='300' height='150px' onmouseover='this.stop()'onmouseout='this.start()'><ul><li> <a target='_blank' href='https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/Downloads_22012021_Format of Undertaking for Additional Qualification.pdf'> <img src='images/Icon.gif' alt='' title='Maharashtra State Government' /> Format of Undertaking for Additional Qualification</a></li><li> <a target='_blank' href='https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/Downloads_23032018_Format of Affidavit and Indemnity Bond for DEFAULTERS.pdf'>Format of Affidavit and Indemnity Bond for DEFAULTERS</a></li><li> <a target='_blank' href='https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/Downloads_23032018_Format of Affidavit and Indemnity Bond for Renewal of Registration.pdf'>Format of Affidavit and Indemnity Bond for Renewal of Registration</a></li><li> <a target='_blank' href='https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/Downloads_07122017_FORMAT OF AFFIDAVIT FOR INDIAN NATIONALS  OCI REGISTRATION.pdf'>FORMAT OF AFFIDAVIT FOR INDIAN NATIONALS / OCI REGISTRATION</a></li><li> <a target='_blank' href='https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/Downloads_04012017_Undertaking.pdf'>Undertaking</a></li><li> <a target='_blank' href='https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/Downloads_17102016_DECLARATION URULE 62.pdf'>DECLARATION U/RULE 62</a></li><li> <a target='_blank' href='https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files\AFFIDAVIT.pdf'>AFFIDAVIT FOR FOREIGN GRADUATE</a></li></ul></marquee></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-lg-3">
                    <div class="panel panel-primary">
                        <div class="panel-heading clearfix">
                            <h3 class="panel-title">
                                <span class="glyphicon glyphicon-list-alt">Instruction</span> </h3>
                        </div>
                        <div class="panel-body" style="height: 200px;">
                            <div id="ctl00_divInstruction"><marquee id='MarQB' direction='up' loop='true' scrolldelay='300' height='150px' onmouseover='this.stop()'onmouseout='this.start()'><ul ><li> <a target='_blank' href='https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/Instructions_28012018_Instruction to download MMC App from google play.pdf'>Instruction to download MMC App from google play</a></li><li> <a target='_blank' href='https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/Instructions_29112017_Instruction for MMC ID Card.pdf'>Instruction for MMC ID Card</a></li><li> <a target='_blank' href='https://docs.google.com/gview?embedded=true&url=https://www.maharashtramedicalcouncil.in/Files/Instructions_29112017_Instruction for Document uploading.pdf'>Instruction for Document uploading</a></li></ul></marquee></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row footer" id="footer">
                <div class="row">
                    <div class="pull-left">
                        <a href="Index.aspx">Home</a> | <a href="frmAdminLogin.aspx">Admin Login</a> | <a href="frmTabPage.aspx?page=link">Important Links</a> | <a href="frmTabPage.aspx?page=Disclaimer">Disclaimer</a> | <a href="frmTabPage.aspx?page=TC">Terms & Conditions</a>|<a href="frmTabPage.aspx?page=contact">Contact Us
                        </a>|
                            <a href="frmTabPage.aspx?page=site">Site Map</a>
                    </div>
                    <div class="pull-right">
                        <a title="Total Visits"><b>Total Visits :</b>  </a>
                        <span id="ctl00_lblTotalVisit" class="footerVisitCount">12733100</span>
                        
                        
                    </div>
                </div>
                <div class="row">
                    <div class="pull-left">
                        <a><b>Last Updated On :</b>
                            <span id="ctl00_lbldate" class="footerVisitCount">31/07/2024</span>
                        </a>

                    </div>
                    <div class="pull-right">
                        Copyright &copy; 2015
                        <a title="Web Design"><b>Web Design By</b></a>  <a href="http://ibinfosolution.com/" target="_blank"
                            title="Web Design">Integrated Business Solution</a>
                    </div>
                </div>


            </div>

        </div>


    </form>
</body>
</html>
