var append_state = "headline";
var append_transitions = {};

function set_append_transition(from_state, to_state, action) {
	append_transitions[from_state] = function() {
		action();
		append_state = to_state;
	};
}

function append_div (cls) {
	var div = document.createElement('div');
	return $(div)
		.addClass(cls)
		.attr('contenteditable', 'true')
		.html(cls)
		.click(function() { return false; })
		.keypress(function(event) {
			if (event.altKey) {
				switch (event.key) {
				case "Enter":
					append_div (cls);
					break;
				case "Up":
				case "ArrowUp":
					$(div).prev().focus();
					break;
				case "Down":
				case "ArrowDown":
					$(div).next().focus();
					break;
				case "Right":
					break;
				case "Left":
					break;
				}
			}
		})
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
		["C-s", "x", console_log],
		["C-1", quotekey(1)]);

	add_datainput();
});
