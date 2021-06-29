window.sortChange = function(val) {
    var url = new URL(window.location);
    url.searchParams.set('sort', val);
    window.location = url;
}

window.changeActiveSlide = function(index) {
    var slider = $( '.product-gallery-slider' );
    slider[0].slick.slickGoTo(index);
}