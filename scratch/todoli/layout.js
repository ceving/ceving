$(document).ready(function(){
	(function () {
		$('nav').after()
			.hover(
				function(e) {
					console.debug ("in");
					$(this).toggleClass('highlight');
				},
				function (e) {
					console.debug ("out");
					$(this).toggleClass('highlight');
				})
			.mouseover(
				function(e) {
					console.debug(e);
					if ($('nav').hasClass('highlight'))
						console.debug ("is on");
				});
	})();
});
