$(function() {

	$(".moretxt").hide();
	$(".moretxt").parent().append("<span class='readmore'>… read more</span>");


	$(".readmore").on("click", function(event){
		$(this).parent().children().show();
		$(this).hide();

	});

});


