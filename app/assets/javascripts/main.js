(function ($) {
    "use strict";
    
    var $window = $(window);

    $('[data-bg-image]').each(function () {
        var $this = $(this),
            $image = $this.data('bg-image');
        $this.css('background-image', 'url(' + $image + ')');
    });
    $('[data-bg-color]').each(function () {
        var $this = $(this),
            $color = $this.data('bg-color');
        $this.css('background-color', $color);
    });

    $window.on('scroll', function () {
        if ($window.scrollTop() > 350) {
            $('.sticky-header').addClass('is-sticky');
        } else {
            $('.sticky-header').removeClass('is-sticky');
        }
    });

    var subMenuMegaMenuAlignment = () => {
        var $this,
            $subMenu,
            $megaMenu,
            $siteMainMenu = $('.site-main-menu');

        $siteMainMenu.each(function () {
            $this = $(this);
            if ($this.is('.site-main-menu-left, .site-main-menu-right') && $this.closest('.section-fluid').length) {
                $megaMenu = $this.find('.mega-menu');
                $this.css("position", "relative");
                if ($this.hasClass('site-main-menu-left')) {
                    $megaMenu.css({
                        "left": "0px",
                        "right": "auto"
                    });
                } else if ($this.hasClass('site-main-menu-left')) {
                    $megaMenu.css({
                        "right": "0px",
                        "left": "auto"
                    });
                }
            }
        });
        $subMenu = $('.sub-menu');
        if ($subMenu.length) {
            $subMenu.each(function () {
                $this = $(this);
                var $elementOffsetLeft = $this.offset().left,
                    $elementWidth = $this.outerWidth(true),
                    $windowWidth = $window.outerWidth(true) - 10,
                    isElementVisible = ($elementOffsetLeft + $elementWidth < $windowWidth);
                if (!isElementVisible) {
                    if ($this.hasClass('mega-menu')) {
                        var $this = $(this),
                            $thisOffsetLeft = $this.parent().offset().left,
                            $widthDiff = $windowWidth - $elementWidth,
                            $left = $thisOffsetLeft - ($widthDiff / 2);
                        $this.attr("style", "left:" + -$left + "px !important").parent().css("position", "relative");
                    } else {
                        $this.parent().addClass('align-left');
                    }
                } else {
                    $this.removeAttr('style').parent().removeClass('align-left');
                }
            });
        }
    }

    function mobileOffCanvasMenu() {
        var $offCanvasNav = $('.offcanvas-menu, .overlay-menu'),
            $offCanvasNavSubMenu = $offCanvasNav.find('.sub-menu');

        $offCanvasNavSubMenu.parent().prepend('<span class="menu-expand"></span>');

        $offCanvasNav.on('click', 'li a, .menu-expand', function (e) {
            var $this = $(this);
            if ($this.attr('href') === '#' || $this.hasClass('menu-expand')) {
                e.preventDefault();
                if ($this.siblings('ul:visible').length) {
                    $this.parent('li').removeClass('active');
                    $this.siblings('ul').slideUp();
                    $this.parent('li').find('li').removeClass('active');
                    $this.parent('li').find('ul:visible').slideUp();
                } else {
                    $this.parent('li').addClass('active');
                    $this.closest('li').siblings('li').removeClass('active').find('li').removeClass('active');
                    $this.closest('li').siblings('li').find('ul:visible').slideUp();
                    $this.siblings('ul').slideDown();
                }
            }
        });
    }
    mobileOffCanvasMenu();

    $('.header-categories').on('click', '.category-toggle', function (e) {
        e.preventDefault();
        var $this = $(this);
        if ($this.hasClass('active')) {
            $this.removeClass('active').siblings('.header-category-list').slideUp();
        } else {
            $this.addClass('active').siblings('.header-category-list').slideDown();
        }
    })

    $('.product-filter-toggle').on('click', function (e) {
        e.preventDefault();
        var $this = $(this),
            $target = $this.attr('href');
        $this.toggleClass('active');
        $($target).slideToggle();
    });

    $('.product-column-toggle').on('click', '.toggle', function (e) {
        e.preventDefault();
        var $this = $(this),
            $column = $this.data('column'),
            $prevColumn = $this.siblings('.active').data('column');
        $this.toggleClass('active').siblings().removeClass('active');
        $('.products').removeClass('row-cols-xl-' + $prevColumn).addClass('row-cols-xl-' + $column);
        $.fn.matchHeight._update();
        $('.isotope-grid').isotope('layout');
    });

    $('.select2-basic').select2();
    $('.select2-noSearch').select2({
        minimumResultsForSearch: Infinity
    });
    
    $('.isotope-grid .product').matchHeight();
    
    $(".range-slider").ionRangeSlider({
        skin: "learts",
        hide_min_max: true,
        type: 'double',
        prefix: "$",
    });

    $('.product-carousel').slick({
        infinite: true,
        slidesToShow: 4,
        slidesToScroll: 1,
        focusOnSelect: true,
        prevArrow: '<button class="slick-prev"><i class="fal fa-chevron-left"></i></button>',
        nextArrow: '<button class="slick-next"><i class="fal fa-chevron-right"></i></i></button>',
        responsive: [{
                breakpoint: 991,
                settings: {
                    slidesToShow: 3
                }
            },
            {
                breakpoint: 767,
                settings: {
                    slidesToShow: 2
                }
            },
            {
                breakpoint: 575,
                settings: {
                    slidesToShow: 2
                }
            }
        ]
    });

    $('.product-list-slider').slick({
        rows: 3,
        prevArrow: '<button class="slick-prev"><i class="fal fa-chevron-left"></i></button>',
        nextArrow: '<button class="slick-next"><i class="fal fa-chevron-right"></i></button>'
    });

    $('.product-gallery-slider').slick({
        dots: true,
        infinite: true,
        slidesToShow: 1,
        slidesToScroll: 1,
        asNavFor: '.product-thumb-slider, .product-thumb-slider-vertical',
        prevArrow: '<button class="slick-prev"><i class="fal fa-chevron-left"></i></button>',
        nextArrow: '<button class="slick-next"><i class="fal fa-chevron-right"></i></button>'
    });
    $('.product-thumb-slider').slick({
        infinite: true,
        slidesToShow: 4,
        slidesToScroll: 1,
        focusOnSelect: true,
        asNavFor: '.product-gallery-slider',
        prevArrow: '<button class="slick-prev"><i class="fal fa-chevron-left"></i></button>',
        nextArrow: '<button class="slick-next"><i class="fal fa-chevron-right"></i></button>'
    });

    $('.blog-carousel').slick({
        infinite: true,
        slidesToShow: 3,
        slidesToScroll: 1,
        focusOnSelect: true,
        prevArrow: '<button class="slick-prev"><i class="fal fa-chevron-left"></i></button>',
        nextArrow: '<button class="slick-next"><i class="fal fa-chevron-right"></i></button>',
        responsive: [{
                breakpoint: 991,
                settings: {
                    slidesToShow: 2
                }
            },
            {
                breakpoint: 767,
                settings: {
                    slidesToShow: 1
                }
            }
        ]
    });

    $('.brand-carousel').slick({
        infinite: true,
        slidesToShow: 5,
        slidesToScroll: 1,
        focusOnSelect: true,
        prevArrow: '<button class="slick-prev"><i class="fal fa-chevron-left"></i></button>',
        nextArrow: '<button class="slick-next"><i class="fal fa-chevron-right"></i></button>',
        responsive: [{
            breakpoint: 1199,
            settings: {
                slidesToShow: 4
            }
        }, {
            breakpoint: 991,
            settings: {
                slidesToShow: 3
            }
        }, {
            breakpoint: 767,
            settings: {
                slidesToShow: 2
            }
        }, {
            breakpoint: 575,
            settings: {
                slidesToShow: 1
            }
        }]
    });

    $('.testimonial-slider').slick({
        infinite: true,
        slidesToShow: 1,
        slidesToScroll: 1,
        prevArrow: '<button class="slick-prev"><i class="fal fa-chevron-left"></i></button>',
        nextArrow: '<button class="slick-next"><i class="fal fa-chevron-right"></i></button>'
    });
    $('.testimonial-carousel').slick({
        infinite: true,
        slidesToShow: 3,
        slidesToScroll: 1,
        prevArrow: '<button class="slick-prev"><i class="fal fa-chevron-left"></i></button>',
        nextArrow: '<button class="slick-next"><i class="fal fa-chevron-right"></i></button>',
        responsive: [{
                breakpoint: 991,
                settings: {
                    slidesToShow: 2
                }
            },
            {
                breakpoint: 767,
                settings: {
                    slidesToShow: 1
                }
            }
        ]
    });

    var $isotopeGrid = $('.isotope-grid');
    $isotopeGrid.isotope({
        itemSelector: '.grid-item',
        masonry: {
            columnWidth: '.grid-sizer'
        }
    });

    var $isotopeFilter = $('.isotope-filter');
    $isotopeFilter.on('click', 'button', function () {
        var $this = $(this),
            $filterValue = $this.attr('data-filter'),
            $targetIsotop = $this.parent().data('target');
        $this.addClass('active').siblings().removeClass('active');
        $($targetIsotop).isotope({
            filter: $filterValue
        });
    });

    $('[data-countdown]').each(function () {
        var $this = $(this),
            $finalDate = $this.data('countdown');
        $this.countdown($finalDate, function (event) {
            $this.html(event.strftime('<div class="count"><span class="amount">%-D</span><span class="period">Days</span></div><div class="count"><span class="amount">%-H</span><span class="period">Hours</span></div><div class="count"><span class="amount">%-M</span><span class="period">Minutes</span></div><div class="count"><span class="amount">%-S</span><span class="period">Seconds</span></div>'));
        });
    });

    $('.collapse').on('show.bs.collapse', function (e) {
        $(this).closest('.card').addClass('active').siblings().removeClass('active');
    });
    $('.collapse').on('hide.bs.collapse', function (e) {
        $(this).closest('.card').removeClass('active');
    });

    $('.qty-btn').on('click', function () {
        var $this = $(this);
        var oldValue = $this.siblings('input').val();
        if ($this.hasClass('plus')) {
            var newVal = parseFloat(oldValue) + 1;
        } else {
            if (oldValue > 1) {
                var newVal = parseFloat(oldValue) - 1;
            } else {
                newVal = 1;
            }
        }
        $this.siblings('input').val(newVal);
    });

    $('.post-share').on('click', ".toggle", function () {
        var $this = $(this),
            $target = $this.parent();
        $target.hasClass('active') ? $target.removeClass('active') : $target.addClass('active');
    });

    $('.video-popup').magnificPopup({
        type: 'iframe'
    });

    $('.product-zoom').each(function () {
        var $this = $(this),
            $image = $this.data('image');
        $this.zoom({
            url: $image
        });
    });

    $('.sticky-sidebar').stickySidebar({
        topSpacing: 60,
        bottomSpacing: 60,
        containerSelector: '.sticky-sidebar-container',
        innerWrapperSelector: '.sticky-sidebar-inner',
        minWidth: 992
    });

    

    $window.on('load', function () {
        subMenuMegaMenuAlignment();
        $isotopeGrid.isotope( 'reloadItems' ).isotope();
    });

    $window.on('resize', function () {
        subMenuMegaMenuAlignment();
        $isotopeGrid.isotope( 'reloadItems' ).isotope();
    });

})(jQuery);