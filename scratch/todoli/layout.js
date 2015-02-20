var lorem = 
	(function () {
		var word = function () {
			var words = [
				"a", "ac", "accumsan", "adipiscing", "aenean", "aliquam",
				"aliquet", "amet", "ante", "arcu", "at", "auctor", "augue",
				"bibendum", "blandit", "commodo", "condimentum", "congue",
				"consectetur", "consequat", "convallis", "cras", "cum",
				"curabitur", "cursus", "dapibus", "diam", "dictum", "dictumst",
				"dignissim", "dis", "dolor", "donec", "dui", "duis", "egestas",
				"eget", "eleifend", "elementum", "elit", "enim", "erat", "eros",
				"est", "et", "etiam", "eu", "euismod", "facilisi", "facilisis",
				"fames", "faucibus", "felis", "fermentum", "feugiat", "fringilla",
				"fusce", "gravida", "habitant", "habitasse", "hac", "hendrerit",
				"iaculis", "id", "imperdiet", "in", "integer", "interdum",
				"ipsum", "justo", "lacinia", "lacus", "laoreet", "lectus", "leo",
				"libero", "ligula", "lobortis", "lorem", "luctus", "maecenas",
				"magna", "magnis", "malesuada", "massa", "mattis", "mauris",
				"metus", "mi", "molestie", "mollis", "montes", "morbi", "mus",
				"nam", "nascetur", "natoque", "nec", "neque", "netus", "nibh",
				"nisi", "nisl", "non", "nulla", "nullam", "nunc", "odio", "orci",
				"ornare", "parturient", "pellentesque", "penatibus", "pharetra",
				"phasellus", "placerat", "platea", "porta", "porttitor",
				"posuere", "potenti", "praesent", "pretium", "proin", "pulvinar",
				"purus", "quam", "quis", "quisque", "rhoncus", "ridiculus",
				"risus", "rutrum", "sagittis", "sapien", "scelerisque", "sed",
				"sem", "semper", "senectus", "sit", "sociis", "sodales",
				"sollicitudin", "suscipit", "suspendisse", "tellus", "tempor",
				"tempus", "tincidunt", "tortor", "tristique", "turpis",
				"ullamcorper", "ultrices", "ultricies", "urna", "ut", "varius",
				"vehicula", "vel", "velit", "venenatis", "vestibulum", "vitae",
				"vivamus", "viverra", "volutpat", "vulputate"];
			var i = Math.floor(Math.random() * words.length);
			return words[i];
		}
		return function (n) {
			var text = "";
			while (--n > 0)
				text += ' ' + word();
			return text;
		};
	})();

function loremfy (expr, n)
{
	$(expr).each(function() {
		var element = $(this);
		var original = element.text().trim();
		var loremtxt = lorem(n || 100);
		element.click(function() {
			element.text(element.text().trim() == original ?
									 loremtxt : original);
		});
	});
}

var layout;

$(document).ready(function(){
	loremfy('article', 100);
	loremfy('aside', 20);

	(function () {
		var id;
		layout = function () { return id; }
		var resize = function() {
			id = window
				.getComputedStyle(document.body, ':root')
				.getPropertyValue('--media').trim();
		};
		resize();
		window.onresize = resize;
	})();

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
