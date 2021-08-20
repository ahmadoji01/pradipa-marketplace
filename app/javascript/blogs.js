function convertTimeWithMoment() {
    var moment = require('moment');
    $('.moment-container').each( function() {
        var self = $(this);
        self.text(moment(self.text()).format('LLL'));
    }) 
}

$(window).on('load', function () {
    convertTimeWithMoment();
})