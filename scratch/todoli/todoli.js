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
});
