var append_state = "headline";
var append_transitions = {};

function set_append_transition(from_state, to_state, action) {
	append_transitions[from_state] = function() {
		action();
		append_state = to_state;
	};
}

function append_div (cls)
{
	var div = document.createElement('div');
	var addnew_div = function() { append_div (cls); };
	var focus_prev = function() { $(div).prev().focus(); }
	var focus_next = function() { $(div).next().focus(); }
	return $(div)
		.addClass(cls)
		.html(cls)
		.click(function() { return false; })
		.keypress(keystroke(["A-Enter", addnew_div],
												[["A-Up", "A-ArrowUp"], focus_prev],
												[["A-Down", "A-ArrowDown"], focus_next]))
		.appendTo($(document.body))
		.focus();
}

set_append_transition("headline", "paragraph", function() {
	append_div('headline');
});

set_append_transition("paragraph", "headline", function() {
	append_div('paragraph');
});

var add_datainput;
var click_datainput;

(function() {
	var datainput;

	add_datainput = function() {
		datainput = document.createElement('input');
		datainput.type="file";
		return $(datainput)
			.attr({id: "datainput"})
			.css({position: "fixed"})
			.appendTo($(document.body))
			.css({top: -1 * datainput.offsetHeight});
	};

	click_datainput = function () {
		var active = document.activeElement;
		$(datainput).focus().click();
		$(active).focus();
	};
})();

function console_log (event) { console.log(event); }

		
$(document).ready(function(){
	console.log("ready");
	if (false)
	$("body").click(function(event){
		console.log(event.target.tagName);
		(append_transitions[append_state])();
	});

	document.body.onkeypress=keystroke(
		["C-s", "e", console_log],
		["C-1", quotekey(1)]);

	add_datainput();

	(function() {
		var button = $(document.getElementById("main-menu-button"));
		var menu = $(document.getElementById("main-menu"));
		
		button.hover(
			function() { menu.show(); },
			function() { menu.hide(); }
		);
	})();

	(function() {
		var resizing = false;
		var start_x = null;
		var start_w = null;
		$('#left-handle')
			.mousedown(function(e) {
				console.debug(e);
				resizing = true;
				start_x = e.screenX;
				start_w = $('nav').width();
				console.debug(start_w);
				return false;
			})
			.mousemove(function(e) {
				if (resizing) {
					var offset = start_x - e.screenX;
					console.debug("offset: " + offset);
					var new_width = start_w - offset;
					console.debug("new width: " + new_width);
					document.getElementById('nav').style.width = new_width + 'px';
				}
			});
		$(document).mouseup(function() {
			if (resizing) {
				resizing = false;
				start_x = null;
				start_w = null;
			}
		});
	})();

});
