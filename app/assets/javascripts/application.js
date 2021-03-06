// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery
//= require_tree .

$(document).ready(function(){
	
    $(".flip").click(function(){
        $(this).next().find(".description-panel").slideToggle("slow");
    });

    // Check distance to top and display back-to-top.
	$( window ).scroll( function() {
		if ( $( this ).scrollTop() > 800 ) {
			$( '.back-to-top' ).addClass( 'show-back-to-top' );
		} else {
			$( '.back-to-top' ).removeClass( 'show-back-to-top' );
		}
	});

	// Click event to scroll to top.
	$( '.back-to-top' ).click( function() {
		$( 'html, body' ).animate( { scrollTop : 0 }, 800 );
		return false;
	});

	//add to favs
	$(".add-to-favorites").click(function(e){
	  e.preventDefault();
	  var idToGet = $(this).data('id');
	  var title = $(this).data('title');
	  var url = $(this).data('url');
	  var description = $(this).data('description');
	  data = {
	    id: idToGet,
	    title: title,
	    url: url,
	    description: description,
	  };

	  $.ajax({
	  	beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
	    url: "add_to_favorites",
	    type: "POST",
	    data: data
	  });
	});
});