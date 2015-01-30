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
// Example:
//
//   1.) Define some kind of action for the key stroke:
//
//     function action(event) { console.log(event); }
//
//   2.) Define the keystroke:
//
//     define_keystroke (["C-s", "x"], action);
//
//   3.) Define a quoting keystroke to be able to enter the keystroke
//   shadowed by the above definition:
//
//     define_keystroke (["C-1"], quote_keystroke(1));
//
//   4.) Activate the keystroke dispatching for the body of the
//   document:
//
//     document.body.onkeypress=dispatch_keystroke;
//

var define_keystroke;
var dispatch_keystroke;
var quote_keystroke;
var debug_keystroke_bindings;

(function() {
	// The keystroke bindings are shared by the definition, which sets
	// the bindings, and the dispatching, which reads the bindings.
	var bindings = {};
	debug_keystroke_bindings = function () { console.debug(bindings); };

	(function () {
		// Recursively set the keystroke.  The recursion depth is given by
		// the length of the keystroke.
		var recset = function (scope, keystroke, func) {
			if (keystroke.length <= 0)
				console.error ("Empty keystroke");
			else {
				var key = keystroke.shift();
				if (keystroke.length > 0) {
					if (!(key in scope))
						scope[key] = {};
					recset (scope[key], keystroke, func);
				} else
					scope[key] = func;
			}
		};
		define_keystroke = function (keystroke, func) {
			recset (bindings, keystroke, func);
		};
	})();

	(function () {
		// Dispatching requires a state between consecutive keys.
		var stroke; // List of already matched keys of a stroke.
		var scope;  // Scope of keys which can complete the stroke.

		// Initialize stroke
		var reset_stroke = function () {
			stroke = [];
			scope = bindings;
		};
		reset_stroke ();

		// Quoting
		var quote = 0;
		quote_keystroke = function (n) {
			if (typeof n != 'undefined') n = 1;
			return function() { quote = n; };
		};

		// Dispatching
		dispatch_keystroke = function (event) {
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
					if (stroke.length == 0)
						// If the key does not match at all we keep the event
						// bubbling.
						return true;
					else {
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
	})();
})();
