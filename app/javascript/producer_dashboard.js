$(window).on('load', function () {
    $('#notif-dropdown').on('click', function() {
        $.ajax({
            url: "/producer_dashboard/update_notif_read_status",
            type: "patch",
            dataType: 'script',
            format: 'js',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data: {},
            success: function(data) { $('#notif-count').hide() },
            error: function(data) {  }
        })
    });
})

