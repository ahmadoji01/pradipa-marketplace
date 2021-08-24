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