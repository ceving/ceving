var data = document.implementation.createDocument("", "", null);
data.appendChild(data.createElement("data"));

data.add_from_text("<data/>");


var parser = new DOMParser();
var data2 = parser.parseFromString("<data/>", "application/xml");


var serializer = new XMLSerializer();
var sXML = serializer.serializeToString(data);

var reader = new FileReader();
reader.readAsText("work.html", "UTF-16");

document.getElementById('datafile')
	.addEventListener('change', read_file, false);


function read_file(evt) {
  //Retrieve the first (and only!) File from the FileList object
  var f = evt.target.files[0]; 

  if (f) {
    var r = new FileReader();
    r.onload = function(e) { 
	    var contents = e.target.result;
      console.log("Got the file. " 
									+ "name: " + f.name + "; "
									+ "type: " + f.type + "; "
									+ "size: " + f.size);
    }
    r.readAsText(f);
  } else { 
		console.log("Failed to load file");
  }
}



$("#click").click(click_datainput);

var capturing_d2;

(function () {
	var d2 = 1;
	capturing_d2 = function () {
		d2 = 2;
	};
})();

	$("body").keypress(function(event) {
		console.log(event);
		if (event.ctrlKey == true) {
			switch (event.key) {
			case "s":
			case "x":
				console.log ("Got Ctrl-" + event.key);
				return false;
			}
		}
		if (window.getSelection().getRangeAt(0).startOffset)
			console.log(event);
	});


			
					
			function(event) {
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
		}