var o = {
  a: 7,
  get b() { 
    return this.a + 1;
  },
  set c(x) {
    this.a = x / 2
  }
};


$ (function () {
  
  return;
  $.getJSON ("data.cgi", function (data) {
    $.each (data, function (key, val) {
      console.log (val.id, val.firstname, val.lastname);
      $ ("#person").find('tbody')
        .append ($ ('<tr>')
                 .append ($ ('<td>').addClass("oplus").append ('&oplus;'))
                 .append ($ ('<td>').append (val.firstname))
                 .append ($ ('<td>').append (val.lastname))
                 .append ($ ('<td>').addClass("ominus").append ('&ominus;'))
                );
    });
  });
});
