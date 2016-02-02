// Javascript
$('document').ready(function(){

    // read cookies
    var font = getCookie('font');
    var border = getCookie('border');
    var underline = getCookie('underline');
    var theme = getCookie('theme');

    console.log(font+" "+border+" "+underline+" "+theme);

    // Apply custom display preferences
    $('body').css('font-size', font);
    $('a').css('color', underline);
    changeColor(border);
    changeTheme(theme);

});


// Change Display Preferences

$('#font').change(function(){
    var font = $('#font').val();
    $('body').css('font-size', font);
});

$('#border').change(function(){
    var border = $('#border').val();
    changeColor(border);
});

$('#underline').change(function(){
    var underline = $('#underline').val();
    $('a').css('color', underline);
});

$('#theme').change(function(){
    var theme = $('#theme').val();
    changeTheme(theme);
});

// Send info and set cookie.
$('body').on('click', '#save', function(){

    var font = $('#font').val();
    var border = $('#border').val();
    var underline = $('#underline').val();
    var theme = $('#theme').val();

    // set cookies
    document.cookie = "font="+font+";expires=Mon, 1, Jan 2016 12:00:00 GMT;path=/";
    document.cookie = "border="+border+";expires=Mon, 1, Jan 2016 12:00:00 GMT;path=/";
    document.cookie = "underline="+underline+";expires=Mon, 1, Jan 2016 12:00:00 GMT;path=/";
    document.cookie = "theme="+theme+";expires=Mon, 1, Jan 2016 12:00:00 GMT;path=/";

    // delete cookies
    /*document.cookie = "font="+font+";expires=Mon, 1, Jan 2016 12:00:00 GMT;path=/";
      document.cookie = "border="+border+";expires=Mon, 1, Jan 2016 12:00:00 GMT;path=/";
      document.cookie = "underline="+underline+";expires=Mon, 1, Jan 2016 12:00:00 GMT;path=/";
      document.cookie = "theme="+theme+";expires=Mon, 1, Jan 2016 12:00:00 GMT;path=/";*/

});


// Change the link and border color
// Across all platforms / media queries

function changeColor(line_color){
    var line_color = typeof line_color !== 'undefined' ? line_color : '#000';

    // media query change
    function updateColor(mq) {

        if (mq.matches){
            // matches mobile
            $('#main_section').css('border-left', 'none');
            $('#main_section').css('border-top', '1px solid '+line_color);
        }
        else {
            // desktop site
            $('#main_section').css('border-top', 'none');
            $('#main_section').css('border-left', '1px solid '+line_color);
            // test against refresh
            test = $('nav').css('position');
            if (test == 'static'){
                // matches mobile
                $('#main_section').css('border-left', 'none');
                $('#main_section').css('border-top', '1px solid '+line_color);
            }
        }

    }

    // media query event handler
    if (matchMedia) {
        /*check what media query matches*/
        var mq = window.matchMedia("(max-width:999px)");
        mq.addListener(updateColor);
        var mq = window.matchMedia("(device-aspect-ratio: 40/71)");
        mq.addListener(updateColor);
        var mq = window.matchMedia("(device-aspect-ratio:3/4)");
        mq.addListener(updateColor);
        var mq = window.matchMedia("(device-aspect-ratio:3/2)");
        mq.addListener(updateColor);
        var mq = window.matchMedia("(-webkit-device-pixel-ratio: 3)");
        mq.addListener(updateColor);
        updateColor(mq);
    }
}


// Change the theme.
function changeTheme(theme){
    if (theme == 'white'){
        // make white
        $('body').css('background-color', '#fff');
        $('#inner-hex').css('fill', '#fff');
        $('.markdown pre, .markdown code').css('background-color', '#fff');
    }else{
        // make grey
        $('body').css('background-color', '#ebebeb');
        $('#inner-hex').css('fill', '#F5F5F5');
        $('.markdown pre .markdown code').css('background-color', '#eee');
    }
}


// reads value of cookie
function getCookie(cname){
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++)
    {
        var c = ca[i].trim();
        if (c.indexOf(name)==0) return c.substring(name.length,c.length);
    }
    return "";
}
