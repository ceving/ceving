//
// Key bindings in JavaScript
//
// Time-stamp: <2015-01-30 10:15:02 szi>
//
// Keystrokes are defined as an array of keys using the Emacs modifier
// syntax with the following order: C-A-M-x for Ctrl-Alt-Meta-x.  The
// correct order is not checked.  If the order is wrong the binding
// gets ignored during the keystroke dispatching.
//
// Example 1: A shortcut for "C-s x" and "C-1".
//
//   function console_log (event) { console.log(event); }
//
//   document.body.onkeypress=keystroke(
//     ["C-s", "x", console_log],
//     ["C-1", quotekey(1)]);
//
// The example defines a shortcut for "C-s x", which displays the
// keypress event and defines a shortcut for "C-1", which quotes one
// key, to be able to enter the "C-s" key shadowed by the first
// shortcut.
//
// A keystroke is given by an array of keys.  Each key can be a string
// or an array of strings specifying alternatives for the same
// command.  This is sometimes necessary, when keys are renamed like
// "Down" and "ArrowDown" for example.
//
// Example 2: Key alternatives.
//
//   document.body.onkeypress=keystroke(
//     [["A-Down", "A-ArrowDown"], console_log]);
//

var keystroke;
var quotekey;

(function () {

	var QuoteKey = function (n) { this.n = n || 1; };
	quotekey = function (n) { return new QuoteKey(n); };

	// Recursively set the keystroke.  The recursion depth is given by
	// the length of the keystroke.

	var set_key = function (scope, key, stroke, func)
	{
		if (stroke.length > 0) {
			if (!(key in scope))
				scope[key] = {};
			set_stroke (scope[key], stroke, func);
		} else
			scope[key] = func;
	}

	var set_stroke = function (scope, stroke, func)
	{
		if (stroke.length <= 0)
			console.error ("Empty keystroke");
		else {
			var key = stroke.shift();
			if (key instanceof Array)
				for (var i=0; i < key.length; i++)
					set_key (scope, key[i], stroke, func);
			else
				set_key (scope, key, stroke, func);
		}
	}

	keystroke = function ()
	{
		// The keystroke bindings are shared by the definition, which sets
		// the bindings, and the dispatching, which reads the bindings.
		var bindings = {};

		// Quoting
		var quote = 0;

		for (var i=0; i < arguments.length; i++) {
			var argument = arguments[i];
			if (!(argument instanceof Array))
				console.error ("Array argument required", argument);
			else {
				var action = argument.pop();
				if (action instanceof QuoteKey) {
					var n = action.n;
					action = function () { quote = n; };
				}
				set_stroke (bindings, argument, action);
			}
		}

		// Dispatching requires a state between consecutive keys.
		var stroke; // List of already matched keys of a stroke.
		var scope;  // Scope of keys which can complete the stroke.

		// Initialize stroke
		var reset_stroke = function () {
			stroke = [];
			scope = bindings;
		};
		reset_stroke ();

		// Dispatching
		return function (event) {
			if (event.type == "keypress") {
				// Pass the key through if requested.
				if (quote > 0) {
					--quote;
					return true;
				}
				// Process the event
				var key = "";
				if (event.ctrlKey == true) key += "C-";
				if (event.altKey == true)  key += "A-";
				if (event.metaKey == true) key += "M-";
				// We do not support Shift as a modifier prefix 'S-', because
				// the Javascript event applies Shift already to the key.
				key += event.key;
				if (key in scope) {
					if (typeof scope[key] == "function") {
						scope[key](event);
						reset_stroke();
					}
					else {
						stroke.push (key);
						scope = scope[key];
					}
				}
				else {
					if (stroke.length == 0) {
						// If the key does not match at all we keep the event
						// bubbling.
						return true;
					} else {
						// When we get a non matching key in a sequence of keys
						// the previously keys matching a keystroke are lost.  An
						// error is loged in this case.
						stroke.push (key);
						console.error("Undefined keystroke", stroke);
						reset_stroke();
						// Maybe it might be possible to save the events in order
						// to inject them in this case once again.  But I am not
						// sure if it worth to do, because it cause also
						// confusion, when one defines a key stroke based on a key
						// the browser uses.  Example: if the keystroke "C-s a" is
						// defined and the user presses "C-s b", the key
						// dispatching will fail when the "b" arrives and if the
						// "C-s" will be injected now, the browser action for
						// "C-s" will be done after a "b" has been pressed by the
						// user, which is probably not what the user expects.
					}
				}
				// In general we stop bubbling of keypress events.
				return false;
			}
			// We keep the bubbles if we accidently got anything else but a
			// keypress event.
			return true;
		};
	};
})();

 //var save_file;
 //var find_file;
 //var next_paragraph;
 //var end_paragraph;
 //
 //console.debug(
 //	keystroke(
 //		["C-x", "s", save_file],
 //		["C-x", "f", find_file],
 //		["C-a", ["A-Down", "A-ArrowDown"], next_paragraph],
 //		["A-Enter", end_paragraph]));
