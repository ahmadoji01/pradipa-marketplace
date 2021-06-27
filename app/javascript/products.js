window.sortChange = function(val) {
    var url = new URL(window.location);
    url.searchParams.set('sort', val);
    window.location = url;
}