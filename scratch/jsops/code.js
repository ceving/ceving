var o = {
  a: 7,
  get b() { 
    return this.a + 1;
  },
  set c(x) {
    this.a = x / 2
  }
};

function data (query, success)
{
  return jQuery.ajax({
    'type': 'POST',
    'url': '/cgi-bin/eql?data',
    encoding: 'UTF-8',
    'contentType': 'application/sql; charset=UTF-8',
    'data': query,
    'dataType': 'json',
    'success': success
  });
}

function dbval (entity, id, attribute, value)
{
  return $ ('<span>')
    .addClass('dbval')
    .attr ('id', entity + '#' + id + '.' + attribute)
    .attr ('contenteditable', 'true')
    .append (value);
}


$ (function () {
  data ("select * from person",
        function (data) {
          $.each (data, function (key, val) {
            console.log (val.id, val.firstname, val.lastname);
            $ ("#person").find('tbody')
              .append ($ ('<tr>')
                       .append ($ ('<td>').addClass("oplus").append ('&oplus;'))
                       .append ($ ('<td>').append (dbval ('person', val.id, 'firstname', val.firstname)))
                       .append ($ ('<td>').append (dbval ('person', val.id, 'lastname', val.lastname)))
                       .append ($ ('<td>').addClass("ominus").append ('&ominus;'))
                      );
          });
        });
});
