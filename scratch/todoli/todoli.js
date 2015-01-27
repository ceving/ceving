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
		
$(document).ready(function(){
	console.log("ready");
	if (false)
	$("body").click(function(event){
		console.log(event.target.tagName);
		(append_transitions[append_state])();
	});
	$("body").keypress(function(event) {
		//console.log(event);
		if (window.getSelection().getRangeAt(0).startOffset)
			console.log(event);
	});
});
