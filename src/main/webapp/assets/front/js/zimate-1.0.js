var zinMate;

;(function ($) {
	'use strict'
	zinMate = {
	    init: function() {
	    	this.galleryCarousel();
	    	this.brandCarousel();
	    	this.mobileMenu();
	    	this.proQuantity();
	    	this.relatedProduct();
	    	this.sweetAlert();
	    	this.miniCart();
	    	this.googleMaps();
	    	this.mainSlider();
	    },

	    galleryCarousel: function(){
	    	var galleryDots = $('.gallery-dots');
	    	var galleryArrow = $('.gallery-arrows');
            $('#product-gallery-active').slick({
                slidesToShow: 1,
                slidesToScroll: 1,
                fade: true,
                infinite: true,
                autoplay: false,
                autoplaySpeed: 6000,

                arrows: true,
                appendArrows: galleryArrow,
                prevArrow:'<button class="prev-arrow"><i class="ti ti-angle-left"></i></button>',
                nextArrow:'<button class="next-arrow"><i class="ti ti-angle-right"></i></button>',

                dots: true,
                appendDots: galleryDots,
                customPaging: function(slick, index) {
                    var portrait = $(slick.$slides[index]).data('thumb');
                    return '<img src=" ' + portrait + ' "/>';
                },  
            });
	    },

	    brandCarousel: function(){
	    	$('#brandsActive').slick({
		        infinite: true,
		        slidesToShow: 4,
		        slidesToScroll: 4,
		        autoplay: false,
		        arrows: false,
                dots: false,
                responsive: [
                    { 
                        breakpoint: 992, 
                        settings: { 
                            slidesToShow: 3,
		                    slidesToScroll: 3,
                        } 
                    },
                    { 
                        breakpoint: 768, 
                        settings: { 
                            slidesToShow: 2,
		                    slidesToScroll: 2,
                        } 
                    }
                ]
		    });
        },
        
        mobileMenu: function(){
            $("header nav.main-menu").slicknav({
                'label': '',
                'duplicate': true,
                'appendTo': '.mobilemenu',
            });
        },

        proQuantity: function(){
            $('#quantityDown').on('click', function(){
                var numProduct = Number($('#quantity').val());
                if(numProduct > 0) $(this).next().val(numProduct - 1);
            });
        
            $('#quantityUP').on('click', function(){
                var numProduct = Number($('#quantity').val());
                $(this).prev().val(numProduct + 1);
            });
        },

        relatedProduct: function(){
            $('#relatedSlideActive').each(function(){
                $(this).find('.related-slider').slick({
                    slidesToShow: 3,
                    slidesToScroll: 3,
                    infinite: false,
                    autoplay: false,
                    autoplaySpeed: 6000,
                    arrows: false,
                    responsive: [
                        {
                            breakpoint: 576,
                            settings: {
                                slidesToShow: 1,
                                slidesToScroll: 1
                                }
                        },
                        {
                            breakpoint: 768,
                            settings: {
                                slidesToShow: 2,
                                slidesToScroll: 2
                                }
                        },
                    ]    
                });
            });
        },

        sweetAlert: function(){
            // Add To Wishlist
            $('.add-wishlist').on('click', function(e){
                e.preventDefault();
            });
    
            $('.add-wishlist').each(function(){
                var nameProduct = $(this).data('name');
                $(this).on('click', function(){
                    swal(nameProduct, "is added to wishlist !", "success");
    
                    $(this).parent().addClass('added-wishlist');
                    $(this).off('click');
                });
            });
            // Add To Cart
            $('.add-to-cart').on('click', function(e){
                e.preventDefault();
            });
    
            $('.add-to-cart').each(function(){
                var nameProduct = $(this).data('name');
                $(this).on('click', function(){
                    swal(nameProduct, "is added to cart !", "success");
    
                    $(this).parent().addClass('added-to-cart');
                    $(this).off('click');
                });
            });
        },

        miniCart: function(){
            $(".cart a").on("click", function () {
                $(".cart-section").addClass("cart-section-active");
            });
            
            $(".cart-close, .cart-overly").on("click", function () {
                $(".cart-section").removeClass("cart-section-active");
            });
        },

        googleMaps: function(){
            function basicmap() {
                var mapOptions = {
                    // How zoomed in you want the map to start at (always required)
                    zoom: 11,
                    scrollwheel: false,
                    // The latitude and longitude to center the map (always required)
                    center: new google.maps.LatLng(40.6700, -73.9400), // New York
                    // This is where you would paste any style found on Snazzy Maps.
                    styles: [
                        {
                            "featureType": "landscape.man_made",
                            "elementType": "geometry.fill",
                            "stylers": [
                                {
                                    "color": "#ece2d9"
                                }
                            ]
                        },
                        {
                            "featureType": "landscape.natural",
                            "elementType": "geometry.fill",
                            "stylers": [
                                {
                                    "visibility": "on"
                                },
                                {
                                    "color": "#b8cb93"
                                }
                            ]
                        },
                        {
                            "featureType": "poi",
                            "elementType": "all",
                            "stylers": [
                                {
                                    "visibility": "off"
                                }
                            ]
                        },
                        {
                            "featureType": "poi.business",
                            "elementType": "all",
                            "stylers": [
                                {
                                    "visibility": "simplified"
                                }
                            ]
                        },
                        {
                            "featureType": "poi.medical",
                            "elementType": "all",
                            "stylers": [
                                {
                                    "visibility": "on"
                                }
                            ]
                        },
                        {
                            "featureType": "poi.park",
                            "elementType": "all",
                            "stylers": [
                                {
                                    "visibility": "on"
                                }
                            ]
                        },
                        {
                            "featureType": "poi.park",
                            "elementType": "geometry.fill",
                            "stylers": [
                                {
                                    "color": "#ccdca1"
                                }
                            ]
                        },
                        {
                            "featureType": "poi.sports_complex",
                            "elementType": "all",
                            "stylers": [
                                {
                                    "visibility": "on"
                                }
                            ]
                        },
                        {
                            "featureType": "road",
                            "elementType": "geometry.fill",
                            "stylers": [
                                {
                                    "hue": "#ff0000"
                                },
                                {
                                    "saturation": -100
                                },
                                {
                                    "lightness": 99
                                }
                            ]
                        },
                        {
                            "featureType": "road",
                            "elementType": "geometry.stroke",
                            "stylers": [
                                {
                                    "color": "#808080"
                                },
                                {
                                    "lightness": 54
                                }
                            ]
                        },
                        {
                            "featureType": "road",
                            "elementType": "labels.text.fill",
                            "stylers": [
                                {
                                    "color": "#767676"
                                }
                            ]
                        },
                        {
                            "featureType": "road",
                            "elementType": "labels.text.stroke",
                            "stylers": [
                                {
                                    "color": "#ffffff"
                                }
                            ]
                        },
                        {
                            "featureType": "water",
                            "elementType": "all",
                            "stylers": [
                                {
                                    "saturation": 43
                                },
                                {
                                    "lightness": -11
                                },
                                {
                                    "hue": "#0088ff"
                                }
                            ]
                        }
                    ]
                };

                var mapElement = document.getElementById('contact-map');
        
                // Create the Google Map using our element and options defined above
                var map = new google.maps.Map(mapElement, mapOptions);
        
                // Let's also add a marker while we're at it
                var marker = new google.maps.Marker({
                    position: new google.maps.LatLng(40.6700, -73.9400),
                    map: map,
                    title: 'Zimate'
                });
            }
            if ($('#contact-map').length != 0) {
                google.maps.event.addDomListener(window, 'load', basicmap);
            }
        },

        mainSlider: function(){
            var sliderActive = $('#bannerSlider');
            sliderActive.on('init', function(e, slick) {
                var $firstAnimatingElements = $('.single-banner-slide:first-child').find('[data-animation]');
                doAnimations($firstAnimatingElements);
            });
            sliderActive.on('beforeChange', function(e, slick, currentSlide, nextSlide) {
                var $animatingElements = $('.single-banner-slider[data-slick-index="' + nextSlide + '"]').find('[data-animation]');
                doAnimations($animatingElements);
            });
            sliderActive.slick({
                autoplay: true,
                autoplaySpeed: 10000,
                dots: false,
                fade: true,
                arrows: false,
            });

            function doAnimations(elements) {
                var animationEndEvents = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
                elements.each(function() {
                    var $this = $(this);
                    var $animationDelay = $this.data('delay');
                    var $animationType = 'animated ' + $this.data('animation');
                    $this.css({
                        'animation-delay': $animationDelay,
                        '-webkit-animation-delay': $animationDelay
                    });
                    $this.addClass($animationType).one(animationEndEvents, function() {
                        $this.removeClass($animationType);
                    });
                });
            }
        }
    
    };

    $(document).ready(function(){
        zinMate.init();
    });

})(jQuery);






// function slickSlider() {
//     var sliderActive = $('.slider-active');
//     sliderActive.on('init', function(e, slick) {
//         var $firstAnimatingElements = $('.single-slider:first-child').find('[data-animation]');
//         doAnimations($firstAnimatingElements);
//     });
//     sliderActive.on('beforeChange', function(e, slick, currentSlide, nextSlide) {
//         var $animatingElements = $('.single-slider[data-slick-index="' + nextSlide + '"]').find('[data-animation]');
//         doAnimations($animatingElements);
//     });
//     sliderActive.slick({
//         autoplay: false,
//         autoplaySpeed: 10000,
//         dots: false,
//         fade: true,
//   arrows: false,
//         responsive: [
//             { breakpoint: 767, settings: { dots: false, arrows: false } }
//         ]
//     });

//     function doAnimations(elements) {
//         var animationEndEvents = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
//         elements.each(function() {
//             var $this = $(this);
//             var $animationDelay = $this.data('delay');
//             var $animationType = 'animated ' + $this.data('animation');
//             $this.css({
//                 'animation-delay': $animationDelay,
//                 '-webkit-animation-delay': $animationDelay
//             });
//             $this.addClass($animationType).one(animationEndEvents, function() {
//                 $this.removeClass($animationType);
//             });
//         });
//     }
// }
// slickSlider();