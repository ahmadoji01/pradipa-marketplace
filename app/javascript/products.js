window.sortChange = function(val) {
    var url = new URL(window.location);
    url.searchParams.set('sort', val);
    window.location = url;
}

window.changeActiveSlide = function(index) {
    var slider = $( '.product-gallery-slider' );
    slider[0].slick.slickGoTo(index);
}

window.updateCart = function() {
    form = $(".update-cart-form").serialize();
    $('#spinner-container').show();
    $.ajax({
        url: "/cart",
        type: "patch",
        dataType: 'script',
        format: 'js',
        data: form,
        success: function(data) { $('#spinner-container').hide(); },
        error: function(data) { $('#spinner-container').hide(); }
    })
}

var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
function onYouTubeIframeAPIReady() {
    $(".video-player").each ( function(i, obj) {
        videoCode = obj.dataset['videoCode'];
        player = new YT.Player(obj, {
            width: '100%',
            height: '100%',
            videoId: videoCode,
            playerVars: { 
                'autoplay': 1, 
                'rel' : 0,
                'showinfo' : 0,
                'showsearch' : 0,
                'controls' : 0,
                'mute': 1, 
                'loop': 1,
                'enablejsapi' : 1,
                'playlist': videoCode },
            events: {
                'onReady': onPlayerReady
            }
        });
    });
}

function onPlayerReady(event) {
    event.target.setVolume(70);
    event.target.playVideo();
}

$(window).on('load', function () {
    onYouTubeIframeAPIReady();
})