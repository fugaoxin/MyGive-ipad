var isMobile = {
    Android: function () {
        return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function () {
        return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function () {
        return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera: function () {
        return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function () {
        return navigator.userAgent.match(/IEMobile/i) || navigator.userAgent.match(/WPDesktop/i);
    },
    any: function () {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
    }
};

// Set default y-position of the page
function ScrollToPageTop() {
    scrollTo(0, 0);
}
function ScrollToContentTop() {
    scrollTo(0, 498);
}

// log I00950: hide show of own dim background for handling dim background not showing up in mobile browser
function ShowDimBackground(OnClickFunction) {
    $('#DimBackground').attr('onclick', OnClickFunction);
    $('#DimBackground').show();
}

function HideDimBackground(PopUpID) {
    var ID = '#' + PopUpID;
    $(ID).hide();
    $('#DimBackground').hide();
}

function CenterPopup() {
    var DonateCart = $('#donatecart-popup');
    SetPopupLeft(DonateCart);
    SetPopupTop(DonateCart);

    var CommentBoxPopup = $("#commentbox-popup");
    SetPopupLeft(CommentBoxPopup);

    var ErrMsgPopup = $("#errMsg-popup");
    if (isMobile.Android() || isMobile.BlackBerry() || isMobile.Opera() || isMobile.Windows()) {  // log E01027
        var PopupLeft = (1024 - ErrMsgPopup.width()) / 2;
        ErrMsgPopup.css('left', PopupLeft + 'px');
    }
    else {
        SetPopupLeft(ErrMsgPopup);
    }

    var PhotoViewerPopup = $("#photo-viewer-popup");
    SetPopupLeft(PhotoViewerPopup);
}

function SetPopupLeft(Popup) {
    if (Popup.css('display') == 'block') {
        var WindowWidth = $(window).width();
        var PopupLeft = 0;
        if (WindowWidth < Popup.width()) {
            PopupLeft = (1024 - Popup.width()) / 2;
        }
        else {
            PopupLeft = (WindowWidth - Popup.width()) / 2;
        }
        Popup.css('left', PopupLeft + 'px');
    }
}

function SetPopupTop(Popup) {
    if (Popup.css('display') == 'block') {
        var WindowHeight = $(window).height();
        var PopupTop = 0;
        if (WindowHeight < Popup.height()) {
            Popup.css('top', '80px');
        }
        else {
            PopupTop = (WindowHeight - Popup.height()) / 2;
            Popup.css('top', PopupTop + 'px');
        }
    }
}

function SetElementStyleByID(ElementID, StyleAttr, AttrValue) {    // (string, array, array)
    if (StyleAttr.length > 0 && AttrValue.length > 0 && StyleAttr.length == AttrValue.length) {
        var ID = '#' + ElementID;
        var i;
        $(ID).ready(function () {
            for (i = 0; i < StyleAttr.length; i++) {
                $(ID).css(StyleAttr[i].value, AttrValue[i].value);
            }
        });
    }
}


// Return class name of sbHolder of custom style dropdown list
function GetsbValue(DropDownListID) { return document.getElementById(DropDownListID).getAttribute('sb'); }
function GetsbHolderClassName(DropDownListID) { return 'sbHolder_' + GetsbValue(DropDownListID); }


// change website icon when language changes
function ChangeIconByLang(LangID) {
    var LangCode = 'TC';
    switch (LangID) {
        case '1':
            LangCode = 'TC';
            break;
        case '2':
            LangCode = 'SC';
            break;
        case '3':
            LangCode = 'EN';
            break;
        default:
            break;
    }
    $(document).ready(function () {
        $('.WebIcon').each(function () {
            var imgsrc = $(this).attr('src');
            $(this).attr('src', imgsrc.replace('_TC.', '_' + LangCode + '.'));
        });
    });
    return false;
}


// include custom css file according to language
function AddCSSByLang(LangID) {
    var cssId = 'CustomCSS';  // you could encode the css path itself to generate id..
    if (!document.getElementById(cssId)) {
        var head = document.getElementsByTagName('head')[0];
        var link = document.createElement('link');
        link.id = cssId;
        link.rel = 'stylesheet';
        link.type = 'text/css';
        switch (LangID) {
            case '1':
                break;
            case '2':
                break;
            case '3':
                link.href = 'css/custom_EN.css';
                break;
            default:
                break;
        }
        link.media = 'all';
        head.appendChild(link);
    }
}


// Show Donate Cart
function DonateNow() {
    __doPostBack('DONATECART', '');
    return false;
}


// Get member's default profile pic file path
function GetProfilePicFilePath(Tp) {
    switch (Tp) {
        case 'M':
            return 'Images/default_m.jpg';
            break;
        case 'F':
            return 'Images/default_f.jpg';
            break;
        case 'C':
            return 'Images/default_c.png';
            break;
        default:
            return ''
            break;
    }
    return false;
}


// Upload download count of document
function UploadDownloadCountForDocument(UploadDocumentID) {
    $.post("updateDocumentDownloadCount.aspx?DocumentID=" + UploadDocumentID, { DocumentID: UploadDocumentID }, function () { });
}