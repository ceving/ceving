var append_state = "headline";
var append_transitions = {};

function set_append_transition(from_state, to_state, action) {
	append_transitions[from_state] = function() {
		action();
		append_state = to_state;
	};
}

function append_div (cls) {
	div = document.createElement('div');
	return $(div)
		.addClass(cls)
		.attr('contenteditable', 'true')
		.html(cls)
		.click(function() { return false; })
		.appendTo($(document.body));
}

set_append_transition("headline", "paragraph", function() {
	append_div('headline');
});

set_append_transition("paragraph", "headline", function() {
	append_div('paragraph');
});
		
$(document).ready(function(){
	alert ("test");
	$("body").click(function(event){
		alert (event.target.tagName);
		(append_transitions[append_state])();
	});
});
