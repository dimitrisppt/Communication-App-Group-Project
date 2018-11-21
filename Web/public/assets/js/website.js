// MOD Title: Simple Image Upload
// MOD Author: Sium < admin@imgbb.com > (N/A) http://imgbb.com/mod
// MOD Version: 2.0.0
if (typeof(imgbb_add_text) == 'undefined') {
    var imgbb_lang = "en";

    var imgbb_add_text = "Add image to announcement";

    var imgbb_style = "padding:15px 0px 15px 0px;";

    var imgbb_skip_textarea = new RegExp("recaptcha|username_list|search|recipients", "i");

    if (imgbb_lang == "en") {
        imgbb_lang = "";
    } else if (imgbb_lang.indexOf(".") === -1) {
        imgbb_lang += ".";
    }
    if (window.location.hash) {
        var imgbb_text;
        var imgbb_hash;
        if (window.name.indexOf("imgbb_") === -1) {
            imgbb_text = window.name;
            imgbb_hash = window.location.hash.substring(1).split("_");
        } else {
            imgbb_text = window.location.hash.substring(1);
            imgbb_hash = window.name.split("_");
        }
        if (imgbb_text != "" && imgbb_hash.length > 1) {
            if (imgbb_hash[0] == "imgbb") {
                var imgbb_id = imgbb_hash[1];
                imgbb_text = decodeURIComponent(imgbb_text);
                if (imgbb_text.length > 20) {
                    if (opener != null && !opener.closed) {
                        var imgbb_area = opener.document.getElementsByTagName('textarea');
                        for (var i = 0; i < imgbb_area.length; i++) {
                            if (i == imgbb_id) {
                                if (opener.editorHandlemessage && opener.editorHandlemessage.bRichTextEnabled) {
                                    opener.editorHandlemessage.insertText(imgbb_text.replace(new RegExp("\n", 'g'), "<br />"), false);
                                } else {
                                    var v = "![](";
                                    var y = "" + imgbb_text.split("[/img]", 1);
                                    var u = y.split("[img]", 2).slice(1);
                                    imgbb_text = (v + u + ")");
                                    imgbb_area[i].value = imgbb_area[i].value + imgbb_text;
                                }
                                opener.focus();
                                window.close();
                            }
                        }
                    }
                }
                window.location.replace("//" + imgbb_lang + "imgbb.com/upload?mode=code&url=" + encodeURIComponent(document.location.href));
            }
        }
    }

    function imgbb_insert() {
        var imgbb_area = document.getElementsByTagName('textarea');
        for (var i = 0; i < imgbb_area.length; i++) {
            if (imgbb_area[i].name && !imgbb_skip_textarea.test(imgbb_area[i].name)) {
                var attr = imgbb_area[i].getAttribute('data-imgbb');
                if (attr != "true") {
                    var imgbb_div = document.createElement('div');
                    imgbb_div.setAttribute('class', "imgbb");
                    imgbb_div.setAttribute('style', imgbb_style);
                    var imgbb_a = document.createElement('a');
                    imgbb_a.innerHTML = imgbb_add_text;
                    imgbb_a.href = "javascript:imgbb_upload(" + i + ");";
                    var imgbb_bullet = document.createElement('span');
                    imgbb_bullet.innerHTML = "&#160;&#8226;&#160;";
                    imgbb_div.appendChild(imgbb_bullet);
                    imgbb_div.appendChild(imgbb_a);
                    imgbb_area[i].setAttribute('data-imgbb', "true");
                    if (imgbb_area[i].nextSibling) {
                        imgbb_area[i].parentNode.insertBefore(imgbb_div, imgbb_area[i].nextSibling);
                    } else {
                        imgbb_area[i].parentNode.appendChild(imgbb_div);
                    }
                }
            }
        }
    }

    function imgbb_upload(areaid) {
        console.log(encodeURIComponent(document.location.href));
        window.open("//" + imgbb_lang + "imgbb.com/upload?mode=website&url=" + encodeURIComponent(document.location.href), "imgbb_" + areaid, "resizable=yes,width=720,height=550");
        return void(0);
    }

    if (typeof(window.addEventListener) == 'function') {
        window.addEventListener('DOMContentLoaded', imgbb_insert, false);
        window.addEventListener('load', imgbb_insert, false);
    } else if (typeof(window.attachEvent) == 'function') {
        window.attachEvent('onload', imgbb_insert);
    } else {
        if (window.onload != null) {
            var old_onload = window.onload;
            window.onload = function(e) {
                old_onload(e);
                imgbb_insert();
            };
        } else {
            window.onload = imgbb_insert;
        }
    }
    for (var i = 1; i < 12; i += 2) {
        setTimeout("imgbb_insert()", i * 1000);
    }
    imgbb_insert();
}